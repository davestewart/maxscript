/*
  TTFNAME.CPP

  This program uses truetypes.h to try to find all 8 of the standard
  names in a TrueType font file.

  THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
  KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
  PURPOSE.
*/
#include <stdio.h>
#include <windows.h>
#include "truetypes.h"

// Implementation of TTFByteSource that uses FILE from <stdio.h>

class FileSource : public TTFByteSource
{
public:
  FileSource(const char* name)
    : fp(fopen(name, "rb"))
  {
  }
  ~FileSource()
  {
    if (fp) fclose(fp);
  }
  int Error() const { return (fp==0) || ferror(fp); }
  int GetByte() { return getc(fp); }
  unsigned GetCurrentOffset() { return (unsigned)ftell(fp); }
  int Seek(unsigned offset) { return 0==fseek(fp, offset, SEEK_SET); }
  int SeekRelative(unsigned offset) { return 0==fseek(fp, offset, SEEK_CUR); }
private:
  FILE* fp;
};

int main(int argc, char** argv)
{
  if (argc!=2)
  {
    puts("Usage is \"ttfname [somefontfile]\"");
    puts("Note that \\windows\\fonts is often hidden.");
    return 1;
  }
  else
  {
    FileSource f(argv[1]);

    if (f.Error())
    {
      printf("Can't open %s\n", argv[1]);
      return 1;
    }

    TTFDirectory dir;
    dir.Load(f);
    
    for (int i=0; i<dir.GetCount(); i++)
    {
      if (strcmp(dir.GetName(i), "name")==0)
      {
        TTFNameData names;
        f.Seek(dir.GetOffset(i));
        names.Load(f, dir.GetSize(i));
        for (int j=0; j<8; j++)
        {
          wchar_t* test = names.GetWCharsByType(NP_MICROSOFT, NE_UGL, NLMS_US, j);
          if (test)
          {
            // This actually worked in Win95. Hmmm.
            //wprintf(L"I found %s", test);
            wprintf(L"%s", test);
            puts("");
            delete [] test;
          }
        }
        return 0;
      }
    }
  }
  return 0;
}

