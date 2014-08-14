// Utils - assorted static utility routines
//
// Copyright (C)1996,1998 by Jef Poskanzer <jef@acme.com>.  All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
// OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
// HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
// LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
// OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
// SUCH DAMAGE.
//
// Visit the ACME Labs Java page for up-to-date versions of this and other
// fine Java utilities: http://www.acme.com/java/

package Acme;

import java.util.*;
import java.io.*;
import java.net.*;

/// Assorted static utility routines.
// <P>
// Whenever I come up with a static routine that might be of general use,
// I put it here.  So far the class includes:
// <UL>
// <LI> some string routines that were left out of java.lang.String
// <LI> a general array-to-string routine
// <LI> a fixed version of java.io.InputStream's byte-array read routine
// <LI> a bunch of URL-hacking routines
// <LI> some easy-to-use wrappers for Runtime.exec
// <LI> a debugging routine to dump the current call stack
// <LI> a URLDecoder to match java.net.URLEncoder
// </UL>
// and lots more.
// <P>
// <A HREF="/resources/classes/Acme/Utils.java">Fetch the software.</A><BR>
// <A HREF="/resources/classes/Acme.tar.gz">Fetch the entire Acme package.</A>

public class Utils
    {

    /// Returns a date string formatted in Unix ls style - if it's within
    // six months of now, Mmm dd hh:ss, else Mmm dd  yyyy.
    public static String lsDateStr( Date date )
        {
	Calendar cal = new GregorianCalendar();
	cal.setTime( date );
        long dateTime = date.getTime();
	if ( dateTime == -1L )
	    return "------------";
        long nowTime = (new Date()).getTime();
        String[] months = {
            "Jan", "Feb", "Mar", "Apr", "May", "Jun",
            "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };
        String part1 =
	    months[cal.get(Calendar.MONTH)] +
	    Fmt.fmt( cal.get(Calendar.DATE), 3 );
        if ( Math.abs( nowTime - dateTime ) < 183L * 24L * 60L * 60L * 1000L )
            return part1 + Fmt.fmt( cal.get(Calendar.HOUR_OF_DAY), 3 ) + ":" +
                Fmt.fmt( cal.get(Calendar.MINUTE), 2, Fmt.ZF );
        else
            return part1 + Fmt.fmt( cal.get(Calendar.YEAR), 6 );
        }


    /// Returns "s" for numbers other than one, and "" for one.
    public static String pluralStr( long n )
	{
	if ( n == 1 )
	    return "";
	else
	    return "s";
	}


    // Various interval constants.  Some are only approximate.
    public static final long INT_SECOND = 1000L;
    public static final long INT_MINUTE = INT_SECOND * 60L;
    public static final long INT_HOUR = INT_MINUTE * 60L;
    public static final long INT_DAY = INT_HOUR * 24L;
    public static final long INT_WEEK = INT_DAY * 7L;
    public static final long INT_MONTH = INT_DAY * 30L;
    public static final long INT_YEAR = INT_DAY * 365L;
    public static final long INT_DECADE = INT_DAY * 3652L;

    /// Returns a string approximately describing a given time interval.
    // @param interval the interval, in milliseconds
    public static String intervalStr( long interval )
	{
	long decades, years, months, weeks, days, hours, minutes, seconds, millis;

	decades = interval / INT_DECADE;
	interval -= decades * INT_DECADE;
	years = interval / INT_YEAR;
	interval -= years * INT_YEAR;
	months = interval / INT_MONTH;
	interval -= months * INT_MONTH;
	weeks = interval / INT_WEEK;
	interval -= weeks * INT_WEEK;
	days = interval / INT_DAY;
	interval -= days * INT_DAY;
	hours = interval / INT_HOUR;
	interval -= hours * INT_HOUR;
	minutes = interval / INT_MINUTE;
	interval -= minutes * INT_MINUTE;
	seconds = interval / INT_SECOND;
	interval -= seconds * INT_SECOND;
	millis = interval;

	if ( decades > 0 )
	    if ( years == 0 )
		return decades + " decade" + pluralStr( decades );
	    else
		return
		    decades + " decade" + pluralStr( decades ) + ", " +
		    years + " years" + pluralStr( years );
	else if ( years > 0 )
	    if ( months == 0 )
		return years + " year" + pluralStr( years );
	    else
		return
		    years + " year" + pluralStr( years ) + ", " +
		    months + " month" + pluralStr( months );
	else if ( months > 0 )
	    if ( weeks == 0 )
		return months + " month" + pluralStr( months );
	    else
		return
		    months + " month" + pluralStr( months ) + ", " +
		    weeks + " week" + pluralStr( weeks );
	else if ( weeks > 0 )
	    if ( days == 0 )
		return weeks + " week" + pluralStr( weeks );
	    else
		return
		    weeks + " week" + pluralStr( weeks ) + ", " +
		    days + " day" + pluralStr( days );
	else if ( days > 0 )
	    if ( hours == 0 )
		return days + " day" + pluralStr( days );
	    else
		return
		    days + " day" + pluralStr( days ) + ", " +
		    hours + " hour" + pluralStr( hours );
	else if ( hours > 0 )
	    if ( minutes == 0 )
		return hours + " hour" + pluralStr( hours );
	    else
		return
		    hours + " hour" + pluralStr( hours ) + ", " +
		    minutes + " minute" + pluralStr( minutes );
	else if ( minutes > 0 )
	    if ( seconds == 0 )
		return minutes + " minute" + pluralStr( minutes );
	    else
		return
		    minutes + " minute" + pluralStr( minutes ) + ", " +
		    seconds + " second" + pluralStr( seconds );
	else if ( seconds > 0 )
	    if ( millis == 0 )
		return seconds + " second" + pluralStr( seconds );
	    else
		return
		    seconds + " second" + pluralStr( seconds ) + ", " +
		    millis + " millisecond" + pluralStr( millis );
	else
	    return millis + " millisecond" + pluralStr( millis );
	}


    /// Returns the length of the initial segment of str which consists
    // entirely of characters from charSet.
    public static int strSpan( String str, String charSet )
	{
	return strSpan( str, charSet, 0 );
	}

    /// Returns the length of the initial segment of str which consists
    // entirely of characters from charSet, starting at the given index.
    public static int strSpan( String str, String charSet, int fromIdx )
	{
	int i;
	for ( i = fromIdx; i < str.length(); ++i )
	    if ( charSet.indexOf( str.charAt( i ) ) == -1 )
		break;
	return i - fromIdx;
	}

    /// Returns the length of the initial segment of str which consists
    // entirely of characters NOT from charSet.
    public static int strCSpan( String str, String charSet )
	{
	return strCSpan( str, charSet, 0 );
	}

    /// Returns the length of the initial segment of str which consists
    // entirely of characters NOT from charSet, starting at the given index.
    public static int strCSpan( String str, String charSet, int fromIdx )
	{
	int i;
	for ( i = fromIdx; i < str.length(); ++i )
	    if ( charSet.indexOf( str.charAt( i ) ) != -1 )
		break;
	return i - fromIdx;
	}

    /// Checks whether a string matches a given wildcard pattern.
    // Only does ? and *, and multiple patterns separated by |.
    public static boolean match( String pattern, String string )
	{
	for ( int p = 0; ; ++p )
	    {
	    for ( int s = 0; ; ++p, ++s )
		{
		boolean sEnd = ( s >= string.length() );
		boolean pEnd = ( p >= pattern.length() ||
				 pattern.charAt( p ) == '|' );
		if ( sEnd && pEnd )
		    return true;
		if ( sEnd || pEnd )
		    break;
		if ( pattern.charAt( p ) == '?' )
		    continue;
		if ( pattern.charAt( p ) == '*' )
		    {
		    int i;
		    ++p;
		    for ( i = string.length(); i >= s; --i )
			if ( match(
			       pattern.substring( p ),
			       string.substring( i ) ) )  /* not quite right */
			    return true;
		    break;
		    }
		if ( pattern.charAt( p ) != string.charAt( s ) )
		    break;
		}
	    p = pattern.indexOf( '|', p );
	    if ( p == -1 )
		return false;
	    }
	}

//    /// Finds the maximum length of a string that matches a given wildcard
//    // pattern.  Only does ? and *, and multiple patterns separated by |.
//    public static int matchSpan( String pattern, String string )
//	{
//	// !!!
//	return 0;
//	}

    /// Returns the length of the initial segment of str1 that equals str2.
    public static int sameSpan( String str1, String str2 )
	{
	int i;
	for ( i = 0;
	      i < str1.length() && i < str2.length() &&
		str1.charAt( i ) == str2.charAt( i );
	      ++i )
	    ;
	return i;
	}

    /// Returns the number of times the given character appears in the string.
    public static int charCount( String str, char c )
	{
	int n = 0;
	for ( int i = 0; i < str.length(); ++i )
	    if ( str.charAt( i ) == c )
		++n;
	return n;
	}


    /// Turns a String into an array of Strings, by using StringTokenizer
    // to split it up at whitespace.
    public static String[] splitStr( String str )
	{
	StringTokenizer st = new StringTokenizer( str );
	int n = st.countTokens();
	String[] strs = new String[n];
	for ( int i = 0; i < n; ++i )
	    strs[i] = st.nextToken();
	return strs;
	}

    /// Turns a String into an array of Strings, by splitting it at
    // the specified character.  This does not use StringTokenizer,
    // and therefore can handle empty fields.
    public static String[] splitStr( String str, char delim )
	{
	int n = 1;
	int index = -1;
	while ( true )
	    {
	    index = str.indexOf( delim, index + 1 );
	    if ( index == -1 )
		break;
	    ++n;
	    }
	String[] strs = new String[n];
	index = -1;
	for ( int i = 0; i < n - 1; ++i )
	    {
	    int nextIndex = str.indexOf( delim, index + 1 );
	    strs[i] = str.substring( index + 1, nextIndex );
	    index = nextIndex;
	    }
	strs[n - 1] = str.substring( index + 1 );
	return strs;
	}

    /// Turns an array of Strings into a single String, with the components
    // separated by spaces.
    public static String flattenStrarr( String[] strs )
	{
	StringBuffer sb = new StringBuffer();
	for ( int i = 0; i < strs.length; ++i )
	    {
	    if ( i > 0 )
		sb.append( ' ' );
	    sb.append( strs[i] );
	    }
	return sb.toString();
	}

    /// Sorts an array of Strings.
    // Java currently has no general sort function.  Sorting Strings is
    // common enough that it's worth making a special case.
    public static void sortStrings( String[] strings )
	{
	// Just does a bubblesort.
	for ( int i = 0; i < strings.length - 1; ++i )
	    {
	    for ( int j = i + 1; j < strings.length; ++j )
		{
		if ( strings[i].compareTo( strings[j] ) > 0 )
		    {
		    String t = strings[i];
		    strings[i] = strings[j];
		    strings[j] = t;
		    }
		}
	    }
	}
    
    /// Locates a String in an array of Strings.
    // Returns -1 if the String is not found.
    public static int indexOfString( String[] strings, String string )
	{
	for ( int i = 0; i < strings.length; ++i )
	    if ( string.equals( strings[i] ) )
		return i;
	return -1;
	}

    /// Locates a String in an array of Strings, ignoring case.
    // Returns -1 if the String is not found.
    public static int indexOfStringIgnoreCase( String[] strings, String string )
	{
	for ( int i = 0; i < strings.length; ++i )
	    if ( string.equalsIgnoreCase( strings[i] ) )
		return i;
	return -1;
	}
    
    /// Compares two arrays of Strings for equality.
    public static boolean equalsStrings( String[] strings1, String[] strings2 )
	{
	if ( strings1.length != strings2.length )
	    return false;
	for ( int i = 0; i < strings1.length; ++i )
	    if ( ! strings1[i].equals( strings2[i] ) )
		return false;
	return true;
	}


    /// Returns the number a raised to the power of b.  Long version
    // of Math.pow().  Throws ArithmeticException if b is negative.
    public static long pow( long a, long b ) throws ArithmeticException
	{
	if ( b < 0 )
	    throw new ArithmeticException();
	long r = 1;
	while ( b != 0 )
	    {
	    if ( odd( b ) )
		r *= a;
	    b >>>= 1;
	    a *= a;
	    }
	return r;
	}


    /// Parse an integer, returning a default value on errors.
    public static int parseInt( String str, int def )
	{
	try
	    {
	    return Integer.parseInt( str );
	    }
	catch ( Exception e )
	    {
	    return def;
	    }
	}

    /// Parse a long, returning a default value on errors.
    public static long parseLong( String str, long def )
	{
	try
	    {
	    return Long.parseLong( str );
	    }
	catch ( Exception e )
	    {
	    return def;
	    }
	}


    /// An array-to-String routine.  Handles arrays of arbitrary
    // type, including nested arrays.  Sample output:
    // <BLOCKQUOTE><CODE><PRE>
    // byte[]:    { (byte)0, (byte)1, (byte)2 }
    // char[]:    { '0', '1', '2' }
    // short[]:   { (short)0, (short)1, (short)2 }
    // int[]:     { 0, 1, 2 }
    // long[]:    { 0L, 1L, 2L }
    // float[]:   { 0F, 1F, 2F }
    // double[]:  { 0D, 1D, 2D }
    // String[]:  { "0", "1", "2" }
    // int[][]:   { { 0, 1, 2 }, { 3, 4, 5 } }
    // </PRE></CODE></BLOCKQUOTE>
    public static String arrayToString( Object o )
	{
	if ( o == null )
	    return "null";
	String cl = o.getClass().getName();
	if ( ! cl.startsWith( "[" ) )
	    // It's not an array; just call its toString method.
	    return o.toString();
	StringBuffer sb = new StringBuffer( "{ " );
	if ( o instanceof byte[] )
	    {
	    byte[] ba = (byte[]) o;
	    for ( int i = 0; i < ba.length; ++i )
		{
		if ( i > 0 ) sb.append( ", " );
		sb.append( "(byte)" );
		sb.append( ba[i] );
		}
	    }
	else if ( o instanceof char[] )
	    {
	    char[] ca = (char[]) o;
	    for ( int i = 0; i < ca.length; ++i )
		{
		if ( i > 0 ) sb.append( ", " );
		sb.append( "'" );
		sb.append( ca[i] );
		sb.append( "'" );
		}
	    }
	else if ( o instanceof short[] )
	    {
	    short[] sa = (short[]) o;
	    for ( int i = 0; i < sa.length; ++i )
		{
		if ( i > 0 ) sb.append( ", " );
		sb.append( "(short)" );
		sb.append( sa[i] );
		}
	    }
	else if ( o instanceof int[] )
	    {
	    int[] ia = (int[]) o;
	    for ( int i = 0; i < ia.length; ++i )
		{
		if ( i > 0 ) sb.append( ", " );
		sb.append( ia[i] );
		}
	    }
	else if ( o instanceof long[] )
	    {
	    long[] la = (long[]) o;
	    for ( int i = 0; i < la.length; ++i )
		{
		if ( i > 0 ) sb.append( ", " );
		sb.append( la[i] );
		sb.append( "L" );
		}
	    }
	else if ( o instanceof float[] )
	    {
	    float[] fa = (float[]) o;
	    for ( int i = 0; i < fa.length; ++i )
		{
		if ( i > 0 ) sb.append( ", " );
		sb.append( fa[i] );
		sb.append( "F" );
		}
	    }
	else if ( o instanceof double[] )
	    {
	    double[] da = (double[]) o;
	    for ( int i = 0; i < da.length; ++i )
		{
		if ( i > 0 ) sb.append( ", " );
		sb.append( da[i] );
		sb.append( "D" );
		}
	    }
	else if ( o instanceof String )
	    {
	    // Special-case Strings so we can surround them with quotes.
	    String[] sa = (String[]) o;
	    for ( int i = 0; i < sa.length; ++i )
		{
		if ( i > 0 ) sb.append( ", " );
		sb.append( "\"" );
		sb.append( sa[i] );
		sb.append( "\"" );
		}
	    }
	else if ( cl.startsWith( "[L" ) )
	    {
	    // Some random class.
	    Object[] oa = (Object[]) o;
	    for ( int i = 0; i < oa.length; ++i )
		{
		if ( i > 0 ) sb.append( ", " );
		sb.append( oa[i] );
		}
	    }
	else if ( cl.startsWith( "[[" ) )
	    {
	    // Nested arrays.
	    Object[] aa = (Object[]) o;
	    for ( int i = 0; i < aa.length; ++i )
		{
		if ( i > 0 ) sb.append( ", " );
		sb.append( arrayToString( aa[i] ) );
		}
	    }
	else
	    sb.append( "(unknown array type)" );
	sb.append( " }" );
	return sb.toString();
	}


    /// Check if an object extends a given class or one of its superclasses.
    // An instanceof that works on Class objects at runtime, instead
    // of type descriptors at compile time.
    public static boolean instanceOf( Object o, Class cl )
	{
	// Null check.
	if ( o == null || cl == null )
	    return false;
	Class ocl = o.getClass();
	// Check if they are the same class.
	if ( ocl.equals( cl ) )
	    return true;
	// If the class is not itself an interface, then check its interfaces.
	if ( ! cl.isInterface() )
	    {
	    Class ifs[] = cl.getInterfaces();
	    for ( int i = 0; i < ifs.length; ++i )
		if ( instanceOf( o, ifs[i] ) )
		    return true;
	    }
	// And check supeclasses.
	Class scl = cl.getSuperclass();
	if ( scl != null )
	    if ( instanceOf( o, scl ) )
		return true;
	// Guess not.
	return false;
	}


    /// Test is a number is even.
    public static boolean even( long n )
	{
	return ( n & 1 ) == 0;
	}

    /// Test is a number is odd.
    public static boolean odd( long n )
	{
	return ( n & 1 ) != 0;
	}


    /// Count the number of 1-bits in a byte.
    public static int countOnes( byte n )
	{
	return countOnes( n & 0xffL );
	}

    /// Count the number of 1-bits in an int.
    public static int countOnes( int n )
	{
	return countOnes( n & 0xffffffffL );
	}

    /// Count the number of 1-bits in a long.
    public static int countOnes( long n )
	{
	// There are faster ways to do this, all the way up to looking
	// up bytes in a 256-element table.  But this is not too bad.
	int count = 0;
	while ( n != 0 )
	    {
	    if ( odd( n ) )
		++count;
	    n >>>= 1;
	    }
	return count;
	}


    /// A fixed version of java.io.InputStream.read(byte[], int, int).  The
    // standard version catches and ignores IOExceptions from below.
    // This version sends them on to the caller.
    public static int read( InputStream in, byte[] b, int off, int len ) throws IOException
        {
        if ( len <= 0 )
            return 0;
        int c = in.read();
        if ( c == -1 )
            return -1;
        if ( b != null )
            b[off] = (byte) c;
        int i;
        for ( i = 1; i < len ; ++i )
            {
            c = in.read();
            if ( c == -1 )
                break;
            if ( b != null )
                b[off + i] = (byte) c;
            }
        return i;
        }

    /// A version of read that reads the entire requested block, instead
    // of sometimes terminating early.
    // @return -1 on EOF, otherwise len
    public static int readFully( InputStream in, byte[] b, int off, int len ) throws IOException
        {
	int l, r;
	for ( l = 0; l < len; )
	    {
	    r = read( in, b, l, len - l );
	    if ( r == -1 )
		return -1;
	    l += r;
	    }
	return len;
	}


    /// Make a URL with no ref part and no query string.  Also, if it's
    // a directory then make sure there's a trailing slash.
    public static URL plainUrl( URL context, String urlStr ) throws MalformedURLException
	{
	URL url = new URL( context, urlStr );
	String fileStr = url.getFile();
	int i = fileStr.indexOf( '?' );
	if ( i != -1 )
	    fileStr = fileStr.substring( 0, i );
	url = new URL(
	    url.getProtocol(), url.getHost(), url.getPort(), fileStr );
	if ( ( ! fileStr.endsWith( "/" ) ) &&
	     urlStrIsDir( url.toExternalForm() ) )
	    {
	    fileStr = fileStr + "/";
	    url = new URL(
		url.getProtocol(), url.getHost(), url.getPort(), fileStr );
	    }
	return url;
	}

    /// Make a URL with no ref part and no query string.  Also, if it's
    // a directory then make sure there's a trailing slash.
    public static URL plainUrl( String urlStr ) throws MalformedURLException
	{
        return plainUrl( null, urlStr );
        }

    /// Figure out the base URL for a given URL.  What this means is
    // if the URL points to a directory, you get that directory; if the
    // URL points to a file, you get the directory the file is in.
    public static String baseUrlStr( String urlStr )
	{
	if ( urlStr.endsWith( "/" ) )
	    return urlStr;
	if ( urlStrIsDir( urlStr ) )
	    return urlStr + "/";
	return urlStr.substring( 0, urlStr.lastIndexOf( '/' ) + 1 );
	}

    /// Makes sure if a URL is a directory, it ends with a slash.
    public static String fixDirUrlStr( String urlStr )
	{
	if ( urlStr.endsWith( "/" ) )
	    return urlStr;
	if ( urlStrIsDir( urlStr ) )
	    return urlStr + "/";
	return urlStr;
	}

    /// Figures out whether a URL points to a directory or not.
    // Web servers are lenient and accept directory-URLs without
    // the trailing slash.  What they actually do is return a
    // redirect to the same URL with the trailing slash appended.
    // Unfortunately, Java doesn't let us see that such a redirect
    // happened.  Instead we have to figure out it's a directory
    // indirectly and heuristically.
    public static boolean urlStrIsDir( String urlStr )
	{
	// If it ends with a slash, it's probably a directory.
	if ( urlStr.endsWith( "/" ) )
	    return true;

	// If the last component has a dot, it's probably not a directory.
	int lastSlash = urlStr.lastIndexOf( '/' );
	int lastPeriod = urlStr.lastIndexOf( '.' );
	if ( lastPeriod != -1 && ( lastSlash == -1 || lastPeriod > lastSlash ) )
	    return false;

	// Otherwise, append a slash and try to connect.  This is
	// fairly expensive.
	String urlStrWithSlash = urlStr + "/";
	try
	    {
	    URL url = new URL( urlStrWithSlash );
	    InputStream f = url.openStream();
	    f.close();
	    // Worked fine - it's probably a directory.
	    return true;
	    }
	catch ( Exception e )
	    {
	    // Got an error - must not be a directory.
	    return false;
	    }
	}


    // Figures out whether a URL is absolute or not.
    public static boolean urlStrIsAbsolute( String urlStr )
	{
	if ( urlStr.startsWith( "/" ) || urlStr.indexOf( ":/" ) != -1 )
	    return true;
	// Should handle :8000/ and such too.
	return false;
	}

    // Returns an equivalent URL string that is guaranteed to be absolute.
    public static String absoluteUrlStr( String urlStr, URL contextUrl ) throws MalformedURLException
	{
	URL url = new URL( contextUrl, urlStr );
	return url.toExternalForm();
	}
    

    /// URLDecoder to go along with java.net.URLEncoder.  Why there isn't
    // already a decoder in the standard library is a mystery to me.
    public static String urlDecoder( String encoded )
	{
	StringBuffer decoded = new StringBuffer();
	int len = encoded.length();
	for ( int i = 0; i < len; ++i )
	    {
	    if ( encoded.charAt( i ) == '%' && i + 2 < len )
		{
		int d1 = Character.digit( encoded.charAt( i + 1 ), 16 );
		int d2 = Character.digit( encoded.charAt( i + 2 ), 16 );
		if ( d1 != -1 && d2 != -1 )
		    decoded.append( (char) ( ( d1 << 4 ) + d2 ) );
		i += 2;
		}
	    else if ( encoded.charAt( i ) == '+' )
		decoded.append( ' ' );
	    else
		decoded.append( encoded.charAt( i ) );
	    }
	return decoded.toString();
	}
    

    /// A base-64 encoder, necessary for doing the client side of Basic
    // Authentication.  This encodes binary data as printable ASCII
    // characters.  Three 8-bit binary bytes are turned into four 6-bit
    // values, like so:
    //
    //   [11111111]  [22222222]  [33333333]
    //
    //   [111111] [112222] [222233] [333333]
    //
    // Then the 6-bit values are represented using the characters "A-Za-z0-9+/".
    public static String base64Encode( byte[] src )
	{
	StringBuffer encoded = new StringBuffer();
	int i, phase = 0;
	char c = 0;

	for ( i = 0; i < src.length; ++i )
	    {
	    switch ( phase )
		{
		case 0:
		c = b64EncodeTable[( src[i] >> 2 ) & 0x3f];
		encoded.append( c );
		c = b64EncodeTable[( src[i] & 0x3 ) << 4];
		encoded.append( c );
		++phase;
		break;
		case 1:
		c = b64EncodeTable[
		    ( b64DecodeTable[c] | ( src[i] >> 4 ) ) & 0x3f];
		encoded.setCharAt( encoded.length() - 1, c );
		c = b64EncodeTable[( src[i] & 0xf ) << 2];
		encoded.append( c );
		++phase;
		break;
		case 2:
		c = b64EncodeTable[
		    ( b64DecodeTable[c] | ( src[i] >> 6 ) ) & 0x3f];
		encoded.setCharAt( encoded.length() - 1, c );
		c = b64EncodeTable[src[i] & 0x3f];
		encoded.append( c );
		phase = 0;
		break;
		}
	    }
	/* Pad with ='s. */
	while ( phase++ < 3 )
	    encoded.append( '=' );
	return encoded.toString();
	}

    private static char b64EncodeTable[] = {
	'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',  // 00-07
	'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',  // 08-15
	'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',  // 16-23
	'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',  // 24-31
	'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',  // 32-39
	'o', 'p', 'q', 'r', 's', 't', 'u', 'v',  // 40-47
	'w', 'x', 'y', 'z', '0', '1', '2', '3',  // 48-55
	'4', '5', '6', '7', '8', '9', '+', '/'   // 56-63
	};

    private static int b64DecodeTable[] = {
	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,  // 00-0F
	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,  // 10-1F
	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,62,-1,-1,-1,63,  // 20-2F
	52,53,54,55,56,57,58,59,60,61,-1,-1,-1,-1,-1,-1,  // 30-3F
	-1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,  // 40-4F
	15,16,17,18,19,20,21,22,23,24,25,-1,-1,-1,-1,-1,  // 50-5F
	-1,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,  // 60-6F
	41,42,43,44,45,46,47,48,49,50,51,-1,-1,-1,-1,-1,  // 70-7F
	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,  // 80-8F
	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,  // 90-9F
	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,  // A0-AF
	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,  // B0-BF
	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,  // C0-CF
	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,  // D0-DF
	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,  // E0-EF
	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1   // F0-FF
	};

    /// A base-64 encoder that takes a String, for convenience.
    public static String base64Encode( String srcString )
	{
	byte[] src = new byte[srcString.length()];
	srcString.getBytes( 0, src.length, src, 0 );
	return base64Encode( src );
	}


    /// Check if an array contains a given element.
    public static boolean arraycontains( Object[] array, Object element )
	{
	for ( int i = 0; i < array.length; ++i )
	    if ( array[i].equals( element ) )
		return true;
	return false;
	}


    /// Run a program on the host system.
    // <P>
    // This routine runs the specified command, waits for it to
    // finish, and returns the exit status.
    // This is like the Unix system() routine.  Unlike the Unix version,
    // though, stdout and stderr get thrown away unless you redirect them.
    public static int system( String cmd )
	{
	try
	    {
	    return runCommand( cmd ).waitFor();
	    }
	catch ( IOException e )
	    {
	    return -1;
	    }
	catch ( InterruptedException e )
	    {
	    return -1;
	    }
	}

    /// Run a program on the host system, and capture the output.
    // <P>
    // This routine runs the specified command, and returns an InputStream
    // for reading the output of the program.
    // <P>
    // <B>WARNING:</B> In JDK1.0.2 there is a serious bug in the process
    // IO routines, such that reading all the way to the end of a process's
    // output will invariably get you an IOException( "read error" ).
    // In some cases you will also <B>lose</B> the last bufferload of
    // the output.  The workaround is to add a " ; sleep 1" to the end of
    // your command, and to ignore the "read error" IOException.
    public static InputStream popenr( String cmd )
	{
	try
	    {
	    return runCommand( cmd ).getInputStream();
	    }
	catch ( IOException e )
	    {
	    return null;
	    }
	}

    /// Run a program on the host system, and send it some input.
    // <P>
    // This routine runs the specified command, and returns an OutputStream
    // for writing the program's input.
    public static OutputStream popenw( String cmd )
	{
	try
	    {
	    return runCommand( cmd ).getOutputStream();
	    }
	catch ( IOException e )
	    {
	    return null;
	    }
	}

    /// Run a program on the host system.
    // <P>
    // This routine runs the specified command, and returns a Process
    // object so you can do what you like with it.
    // <P>
    // <B>WARNING:</B> In JDK1.0.2 there is a serious bug in the process
    // IO routines, such that reading all the way to the end of a process's
    // output will invariably get you an IOException( "read error" ).
    // In some cases you will also <B>lose</B> the last bufferload of
    // the output.  The workaround is to add a " ; sleep 1" to the end of
    // your command, and to ignore the "read error" IOException.
    public static Process runCommand( String cmd ) throws IOException
	{
	Runtime runtime = Runtime.getRuntime();
	String[] shCmd = new String[3];
	shCmd[0] = "/bin/sh";
	shCmd[1] = "-c";
	shCmd[2] = cmd;
	return runtime.exec( shCmd );
	}


    /// Copy the input to the output until EOF.
    public static void copyStream( InputStream in, OutputStream out ) throws IOException
	{
	byte[] buf = new byte[4096];
	int len;
	while ( ( len = in.read( buf ) ) != -1 )
	    out.write( buf, 0, len );
	}

    /// Copy the input to the output until EOF.
    public static void copyStream( Reader in, Writer out ) throws IOException
	{
	char[] buf = new char[4096];
	int len;
	while ( ( len = in.read( buf ) ) != -1 )
	    out.write( buf, 0, len );
	}

    /// Copy the input to the output until EOF.
    public static void copyStream( InputStream in, Writer out ) throws IOException
	{
	byte[] buf1 = new byte[4096];
	char[] buf2 = new char[4096];
	int len, i;
	while ( ( len = in.read( buf1 ) ) != -1 )
	    {
	    for ( i = 0; i < len; ++i )
		buf2[i] = (char) buf1[i];
	    out.write( buf2, 0, len );
	    }
	}

    /// Copy the input to the output until EOF.
    public static void copyStream( Reader in, OutputStream out ) throws IOException
	{
	char[] buf1 = new char[4096];
	byte[] buf2 = new byte[4096];
	int len, i;
	while ( ( len = in.read( buf1 ) ) != -1 )
	    {
	    for ( i = 0; i < len; ++i )
		buf2[i] = (byte) buf1[i];
	    out.write( buf2, 0, len );
	    }
	}


    /// Dump out the current call stack.
    public static void dumpStack( PrintStream p )
	{
	(new Throwable()).printStackTrace( p );
	}

    /// Dump out the current call stack onto System.err.
    public static void dumpStack()
	{
	(new Throwable()).printStackTrace();
	}

    }
