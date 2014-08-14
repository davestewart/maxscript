/*
  TRUETYPES.H

  A few classes for reading a TrueType file. The classes don't require
  Win32 functions. Nor is it necessary to install a font for this code
  to work.

  It is in fact expected that this code would be portable. It doesn't
  depend on the native byte order. TTF's are big-endian, and the first
  implementation was little-endian. 

  There is only enough in this header to support finding the name of a
  font. 

  As written, the lightweight types, such as ULONG, that could be 
  typedef'ed are in fact the typedefs from <windows.h>. If ported, those 
  typedefs would have to be written.

  TTFByteSource: Abstract file reading interface, which clients must derive
                 from.
  TTFDirectory:  A directory of a TTF file's tables.
  TTFNameData:   A directory of the names in a TTF's name table.

  Ancillary classes:
  TTFFixed:      Partial implementation of Fixed type for TTF.
  TTFNameHeader: The header of a name table.
  TTFNameRecord: An entry in a name table.
  TTFTableEntry: An entry in the TTF table directory
  TTFTableHeader: The header of the TTF table directory
  TTFTagType:    A type for directory table tags.

  Copyright © 1997 Michael T. Enright.
  
  THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
  KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
  PURPOSE.
*/
#ifndef TRUETYPES_H__
#define TRUETYPES_H__

#ifndef _INC_WINDOWS
#include <windows.h>
#endif

/*
  TTFByteSource is an abstract random and sequential file
  reader. It is used by the various input routines.
*/
class TTFByteSource
{
public:
  virtual int GetByte() = 0; // byte is 0-255, error is -1
  virtual int Error() const = 0; // did an error occur?
  virtual int Seek(unsigned offset) = 0;
  virtual int SeekRelative(unsigned offset) = 0;
  virtual unsigned GetCurrentOffset() = 0;
};

struct TTFFixed 
{
  int GetMantissa() const { return highlow/65536; }
  int GetFraction() const { return highlow-(highlow&0xffff0000); }
  double Get() const { return highlow/65536.0; }
  int GetBits() const { return (int)highlow; }
  int Read(TTFByteSource& f)
  {
    int t = f.GetByte();
    t = t*256 + f.GetByte();
    t = t*256 + f.GetByte();
    t = t*256 + f.GetByte();
    if (!f.Error())
      highlow = t;
    return !f.Error();
  }
private:
  __int32 highlow;
};
struct TTFTagType {
  char text[5];
  int Read(TTFByteSource& f)
  {
    text[0] = (char)f.GetByte();
    text[1] = (char)f.GetByte();
    text[2] = (char)f.GetByte();
    text[3] = (char)f.GetByte();
    text[4] =0;
    return !f.Error();
  }
};
//BYTE	8-bit unsigned integer.
//CHAR	8-bit signed integer.
//USHORT	16-bit unsigned integer.
//SHORT	16-bit signed integer.
//ULONG	32-bit unsigned integer.
//LONG	32-bit signed integer.
//FIXED	32-bit signed fixed-point number (16.16)
//FUNIT	Smallest measurable distance in the em space.
//FWORD	16-bit signed integer (SHORT) that describes a quantity in FUnits.
//UFWORD	Unsigned 16-bit integer (USHORT) that describes a quantity in FUnits. 
//F2DOT14	16-bit signed fixed number with the low 14 bits of fraction (2.14).

inline int Read(TTFByteSource& f, SHORT& out)
{
  SHORT s;
  s = f.GetByte();
  s = s*256 + f.GetByte();
  if (!f.Error())
    out = s;
  return !f.Error();
}
inline int Read(TTFByteSource& f, LONG& out)
{
  LONG s;
  s = f.GetByte();
  s = s*256 + f.GetByte();
  s = s*256 + f.GetByte();
  s = s*256 + f.GetByte();
  if (!f.Error())
    out = s;
  return !f.Error();
}
inline int Read(TTFByteSource& f, USHORT& out)
{
  USHORT us;
  us = (unsigned)f.GetByte();
  us = us*256 + (unsigned)f.GetByte();
  if (!f.Error())
    out = us;
  return !f.Error();
}
inline int Read(TTFByteSource& f, ULONG& out)
{
  ULONG us;
  us = (unsigned)f.GetByte();
  us = us*256 + (unsigned)f.GetByte();
  us = us*256 + (unsigned)f.GetByte();
  us = us*256 + (unsigned)f.GetByte();
  if (!f.Error())
    out = us;
  return !f.Error();
}

// TABLE HEADER
//Fixed	sfnt version	0x00010000 for version 1.0.
//USHORT 	numTables	Number of tables. 
//USHORT 	searchRange	(Maximum power of 2 £ numTables) x 16.
//USHORT 	entrySelector	Log2(maximum power of 2 £ numTables).
//USHORT 	rangeShift	NumTables x 16-searchRange.
struct TTFTableHeader
{
  TTFFixed version;
  USHORT numTables;
  USHORT searchRange;
  USHORT entrySelector;
  USHORT rangeShift;
};
inline int Read(TTFByteSource& f, TTFTableHeader& out)
{
  return out.version.Read(f)
    && Read(f, out.numTables)
    && Read(f, out.searchRange)
    && Read(f, out.entrySelector)
    && Read(f, out.rangeShift)
    ;
}
// TABLE ENTRY
//ULONG	tag	4 -byte identifier.
//ULONG	checkSum	CheckSum for this table.
//ULONG	offset	Offset from beginning of TrueType font file.
//ULONG	length	Length of this table.
struct TTFTableEntry
{
  TTFTagType tag;
  ULONG checkSum;
  ULONG offset;
  ULONG length;
};
inline int Read(TTFByteSource& f, TTFTableEntry& out)
{
  return out.tag.Read(f)
    && Read(f, out.checkSum)
    && Read(f, out.offset)
    && Read(f, out.length)
    ;
}

class TTFDirectory
{
public:
  int Load(TTFByteSource& f)
  {
    Read(f, header);
    entries = new TTFTableEntry[header.numTables];
    for (USHORT i = 0; i<header.numTables; ++i)
      Read(f, entries[i]);
    return !f.Error();
  }
  ULONG GetSize(int index)
  {
    return entries[index].length;
  }
  ULONG GetOffset(int index)
  {
    return entries[index].offset;
  }
  char* GetName(int index)
  {
    return entries[index].tag.text;
  }
  USHORT GetCount() const
  {
    return header.numTables;
  }
private:
  TTFTableHeader header;
  TTFTableEntry* entries;
};
// NAME table HEADER
//USHORT	Format selector (=0). 
//USHORT	Number of NameRecords that follow n.
//USHORT	Offset to start of string storage (from start of table).
struct TTFNameHeader
{
  USHORT formatSelector;
  USHORT nRecords;
  USHORT stringOffset;
};

inline int Read(TTFByteSource& f, TTFNameHeader& out)
{
  return (Read(f, out.formatSelector)
    && Read(f, out.nRecords) 
    && Read(f, out.stringOffset)
    );
}

// NAME table record
//USHORT	Platform ID.
//USHORT	Platform-specific encoding ID.
//USHORT	Language ID.
//USHORT	Name ID.
//USHORT	String length (in bytes).
//USHORT	String offset from start of storage area (in bytes).
struct TTFNameRecord
{
  USHORT platformID;
  USHORT encodingID;
  USHORT languageID;
  USHORT nameID;
  USHORT length; // bytes!
  USHORT offset; // from start of specified storage
};

inline int Read(TTFByteSource& f, TTFNameRecord& out)
{
  return (Read(f, out.platformID) 
    && Read(f, out.encodingID)
    && Read(f, out.languageID)
    && Read(f, out.nameID)
    && Read(f, out.length)
    && Read(f, out.offset)
    );
}

enum TTFNameType { NT_COPYRIGHT, NT_FAMILY, NT_SUBFAMILY, NT_UNIQUE, NT_FULL, NT_VERSION, NT_POSTSCRIPT, NT_TRADEMARK };
enum TTFNamePlatforms { NP_APPLE_UNICODE, NP_MACINTOSH, NP_ISO, NP_MICROSOFT };
enum TTFNameEncodingMS { NE_UNDEFINED, NE_UGL };
enum TTFNameLangMS { 
  NLMS_US = 0X409, NLMS_BRIT = 0X809, NLMS_OZ = 0XC09, NLMS_CAN = 0X1009, NLMS_NZ = 0X1409, NLMS_EIRE=0X1809 
};

struct TTFNameData
{
  TTFNameHeader header;
  TTFNameRecord* records;
  BYTE* stringData; // some unicode, some various byte encodings.
  unsigned GetSize() const
  {
    return header.nRecords;
  }
  int Load(TTFByteSource& f, ULONG assignedLength)
  {
    Read(f, header);
    records = new TTFNameRecord[header.nRecords];
    for (USHORT i = 0; i<header.nRecords; ++i)
      Read(f, records[i]);
    unsigned space = assignedLength-header.stringOffset;
    stringData = new BYTE[space];
    for (unsigned k=0; k<space; ++k)
      stringData[k] = f.GetByte();
    return !f.Error();
  }
  BYTE* GetBytesByType(unsigned plat, unsigned enco, unsigned lang, unsigned name)
  {
    int i;
    for (i=0; i<header.nRecords; ++i)
      if (records[i].platformID==plat
      && records[i].encodingID == enco
      && records[i].languageID == lang
      && records[i].nameID == name
      )
      return GetByteEntry(i);
    return 0;
  }
  wchar_t* GetWCharsByType(unsigned plat, unsigned enco, unsigned lang, unsigned name)
  {
    int i;
    for (i=0; i<header.nRecords; ++i)
      if (records[i].platformID==plat
      && records[i].encodingID == enco
      && records[i].languageID == lang
      && records[i].nameID == name
      )
      return GetUnicodeEntry(i);
    return 0;
  }
  BYTE* GetByteEntry(int index)
  {
    BYTE* result = new BYTE[records[index].length];
    unsigned memoff = records[index].offset;
    memcpy(result, stringData+memoff, records[index].length);
    return result;
  }
  wchar_t* GetUnicodeEntry(int index)
  {
    wchar_t* result = new wchar_t[records[index].length/2];
    unsigned memoff = records[index].offset;
    unsigned cb = records[index].length/2;
    for (unsigned i=0; i<cb; ++i)
      result[i] = (stringData+memoff)[i*2]*256 + (stringData+memoff)[i*2+1];
    return result;
  }
  TTFNameRecord& GetRecordEntry(int index)
  {
    return records[index];
  }
};

#endif