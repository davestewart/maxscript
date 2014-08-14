// Spider - a web-robot class
//
// Copyright (C) 1996 by Jef Poskanzer <jef@acme.com>.  All rights reserved.
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
import java.net.*;
import java.io.*;

/// A web-robot class.
// <P>
// This is an Enumeration class that traverses the web starting at
// a given URL.  It fetches HTML files and parses them for new
// URLs to look at.  All files it encounters, HTML or otherwise,
// are returned by the nextElement() method as a URLConnection.
// <P>
// The traversal is breadth-first, and by default it is limited to
// files at or below the starting point - same protocol, hostname, and
// initial directory.
// <P>
// Because of the security restrictions on applets, this is currently
// only useful from applications.
// <P>
// Sample code:
// <BLOCKQUOTE><PRE>
// Enumeration spider = new Acme.Spider( "http://some.site.com/whatever/" );
// while ( spider.hasMoreElements() )
//     {
//     URLConnection conn = (URLConnection) spider.nextElement();
//     // Then do whatever you like with conn:
//     URL thisUrl = conn.getURL();
//     String thisUrlStr = thisUrl.toExternalForm();
//     String mimeType = conn.getContentType();
//     long changed = conn.getLastModified();
//     InputStream s = conn.getInputStream();
//     // Etc. etc. etc., your code here.
//     }
// </PRE></BLOCKQUOTE>
// There are also a couple of methods you can override via a subclass, to
// control things like the search limits and what gets done with broken links.
// <P>
// Sample applications that use Acme.Spider:
// <UL>
// <LI> <A HREF="WebList.html">WebList</A> - make a list of the files in a web subtree
// <LI> <A HREF="WebCopy.html">WebCopy</A> - copy a remote web subtree to the local disk
// <LI> <A HREF="WebGrep.html">WebGrep</A> - grep a web subtree for a pattern
// </UL>
// <P>
// <A HREF="/resources/classes/Acme/Spider.java">Fetch the software.</A><BR>
// <A HREF="/resources/classes/Acme.tar.gz">Fetch the entire Acme package.</A>
// <P>
// @see Acme.HtmlScanner
// @see Acme.NoRobots

public class Spider implements Acme.HtmlObserver, Enumeration
    {

    // Used only in the default error-reporting routines.  If you override
    // them, this is not used at all.
    /*private*/ protected PrintStream err;

    // The spider's state.
    /*private*/ protected Queue todo = new Queue();
    private int todoLimit = 0;
    /*private*/ protected Hashtable done;

    // Temporary state used only between when hasMoreElements and
    // nextElement are called.  Multi-threaded callers should be careful.
    // This seems to be an inherent problem with using Enumeration in
    // a multi-threaded context.
    private SpiderItem item;
    private URL thisUrl;

    // The optional authorization cookie.
    private String auth_cookie = null;

    // The list of Acme.HtmlObservers to add to the HtmlScanner.
    private Vector observers = new Vector();

    // The user-agent name of this spider.
    private final String spiderName = "Acme.Spider";

    // The Robot Exclusion checker.
    private Acme.NoRobots noRobots = new Acme.NoRobots( spiderName );


    /// Constructor with no size limits.
    // @param err the error stream
    public Spider( PrintStream err )
	{
	this.err = err;
	done = new Hashtable();
	}

    /// Constructor with no size limits, and the default error stream.
    public Spider()
	{
	this( System.out );
	}

    /// Constructor with a single URL and no size limits.
    // @param urlStr the URL to start off the enumeration
    // @param err the error stream
    public Spider( String urlStr, PrintStream err ) throws MalformedURLException
	{
	this( err );
	addUrl( urlStr );
	}

    /// Constructor with a single URL and no size limits, and the default
    // error stream.
    // @param urlStr the URL to start off the enumeration
    public Spider( String urlStr ) throws MalformedURLException
	{
	this( urlStr, System.out );
	}

    /// Constructor with size limits.
    // This version lets you specify limits on the todo queue and the
    // done hash-table.  If you are using Spider for a large, multi-site
    // traversal, then you may need to set these limits to avoid running
    // out of memory.  Note that setting a todoLimit means the traversal
    // will not be complete - you may skip some URLs.  And setting the
    // doneLimit means it may re-visit some pages.
    // <P>
    // Guesses at good values for an unlimited traversal: 200000 and 20000.
    // You want the doneLimit pretty small because the hash-table gets checked
    // for every URL, so it will be mostly in memory; the todo queue, on the
    // other hand, is only accessed at the front and back, and so will be
    // mostly paged out.
    // @param urlStr the URL to start off the enumeration
    // @param todoLimit maximum number of URLs to queue for examination
    // @param doneLimit maximum number of URLs to remember having done already
    // @param err the error stream
    public Spider( int todoLimit, int doneLimit, PrintStream err )
	{
	this.err = err;
	this.todoLimit = todoLimit;
	if ( doneLimit == 0 )
	    done = new Hashtable();
	else
	    done = new Acme.LruHashtable( doneLimit );
	}

    /// Constructor with size limits.
    // @param urlStr the URL to start off the enumeration
    // @param todoLimit maximum number of URLs to queue for examination
    // @param doneLimit maximum number of URLs to remember having done already
    public Spider( int todoLimit, int doneLimit )
	{
	this( todoLimit, doneLimit, System.out );
	}


    /// Add a URL to the to-do list.
    public synchronized void addUrl( String urlStr ) throws MalformedURLException
	{
	URL url = Acme.Utils.plainUrl( urlStr );
	String thisUrlStr = url.toExternalForm();
	String baseUrlStr = Acme.Utils.baseUrlStr( thisUrlStr );
	todo.addBack( new SpiderItem( thisUrlStr, null, 0, baseUrlStr ) );
	}

    /// Set the authorization cookie.
    // <P>
    // Syntax is userid:password.
    public synchronized void setAuth( String auth_cookie )
	{
	this.auth_cookie = auth_cookie;
	}

    /// Add an extra observer to the scanners we make.  Multiple observers
    // get called in the order they were added.
    // <P>
    // Alternatively, if you want to add a different observer to each
    // scanner, you can cast the input stream to a scanner and call
    // its add routine, like so:
    // <BLOCKQUOTE><CODE><PRE>
    // InputStream s = conn.getInputStream();
    // Acme.HtmlScanner scanner = (Acme.HtmlScanner) s;
    // scanner.addObserver( this );
    // </PRE></CODE></BLOCKQUOTE>
    public synchronized void addObserver( Acme.HtmlObserver observer )
	{
	observers.addElement( observer );
	}


    /// This method can be overridden by a subclass if you want to change
    // the search policy.  The default version only does URLs that start
    // with the same string as the base URL.  An alternate version might
    // instead go by the search depth.
    protected boolean doThisUrl( String thisUrlStr, int depth, String baseUrlStr )
	{
	if ( thisUrlStr.startsWith( baseUrlStr ) )
	    return true;
	return false;
	}

    /// This method can be overridden by a subclass if you want to change
    // the broken link policy.  The default version reports the broken
    // link on the error stream.  An alternate version might attempt to
    // send mail to the owner of the page with the broken link.
    protected void brokenLink( String fromUrlStr, String toUrlStr, String errmsg )
	{
	err.println( "Broken link in " + fromUrlStr );
	err.println( "    pointing to " +toUrlStr );
	err.println( "    " + errmsg );
	}

    /// This method can be overridden by a subclass if you want to change
    // the error reporting policy.  The default version reports the error
    // link on the error stream.  An alternate version might ignore the error.
    protected void reportError( String fromUrlStr, String toUrlStr, String errmsg )
	{
	err.println( "Error in " + fromUrlStr );
	err.println( "    pointing to " +toUrlStr );
	err.println( "    " + errmsg );
	}

    
    private boolean gotOne = false;

    // Get the next file, if possible.
    private synchronized void getOne()
	{
	while ( ! todo.isEmpty() )
	    {
	    item = (SpiderItem) todo.getFront();

	    // Check again if we've already done this one.
	    if ( ! done.containsKey( item.thisUrlStr ) )
		{
		done.put( item.thisUrlStr, item.thisUrlStr );
		try
		    {
		    thisUrl = new URL( item.thisUrlStr );
		    if ( ! noRobots.ok( thisUrl ) )
			continue;
		    gotOne = true;
		    return;
		    }
		catch ( MalformedURLException e )
		    {
		    String msg = e.getMessage();
		    if ( checkMalformedURL( msg ) )
			brokenLink(
			    myUrlToString( item.fromUrl ), item.thisUrlStr,
			    msg );
		    }
		catch ( Exception e )
		    {
		    reportError(
			myUrlToString( item.fromUrl ), item.thisUrlStr,
			e.toString() );
		    }
		}

	    }

	gotOne = false;
	return;
	}
    
    private static boolean checkMalformedURL( String msg )
	{
	// Java is missing protocol handlers for many common
	// protocols.  Ignore those errors.
	if ( msg.startsWith( "unknown protocol: " ) )
	    {
	    String protocol = msg.substring( msg.lastIndexOf( ' ' ) + 1 );
	    if ( protocol.equalsIgnoreCase( "gopher" ) ||
	         protocol.equalsIgnoreCase( "ftp" ) ||
	         protocol.equalsIgnoreCase( "file" ) ||
	         protocol.equalsIgnoreCase( "telnet" ) ||
	         protocol.equalsIgnoreCase( "news" ) ||
	         protocol.equalsIgnoreCase( "mailto" ) ||
	         protocol.equalsIgnoreCase( "javascript" ) )
		return false;
	    }
	return true;
	}

    /// Standard Enumeration method.
    public synchronized boolean hasMoreElements()
	{
	if ( ! gotOne )
	    getOne();
	return gotOne;
	}


    /// Standard Enumeration method.
    public synchronized Object nextElement()
	{
	if ( ! gotOne )
	    getOne();
	if ( ! gotOne )
	    return null;
	gotOne = false;

	// Make local copies of the temporary global state variables, so the
	// window for overwriting them is smaller.
	SpiderItem localItem = item;
	URL localThisUrl = thisUrl;

	try
	    {
	    URLConnection uc = localThisUrl.openConnection();
	    uc.setRequestProperty( "User-Agent", spiderName );
	    if ( auth_cookie != null )
		uc.setRequestProperty( "Authorization", "Basic " + Acme.Utils.base64Encode( auth_cookie ) );
	    uc.connect();
	    InputStream s = uc.getInputStream();
	    String contentType = uc.getContentType();
	    if ( contentType != null && contentType.startsWith( "text/html" ) )
		{
		// Make a scanner, and pass in the SpiderItem as the clientData.
		HtmlScanner scanner = new HtmlScanner(
		    s, localThisUrl, this, localItem );

		// Add any extra observers.
		Enumeration en = observers.elements();
		while ( en.hasMoreElements() )
		    {
		    Acme.HtmlObserver observer =
			(Acme.HtmlObserver) en.nextElement();
		    scanner.addObserver( observer );
		    }

		// And make a URLConnection that uses this scanner.
		SpiderConnection asc = new SpiderConnection( uc, scanner );
		return asc;
		}
	    else
		{
		// If it's not HTML we don't have to interpose our parser.
		return uc;
		}
	    }
	catch ( FileNotFoundException e )
	    {
	    brokenLink(
		myUrlToString( localItem.fromUrl ), localItem.thisUrlStr,
		e.getMessage() );
	    }
	catch ( UnknownHostException e )
	    {
	    brokenLink(
		myUrlToString( localItem.fromUrl ), localItem.thisUrlStr,
		"unknown host -- " + e.getMessage() );
	    }
	catch ( Exception e )
	    {
	    reportError(
		myUrlToString( localItem.fromUrl ), localItem.thisUrlStr,
		e.toString() );
	    }
	return null;
	}
    

    private String myUrlToString( URL url )
	{
	if ( url == null )
	    return "an initial URL";
	else
	    return url.toExternalForm();
	}


    /// Acme.HtmlObserver callback.
    public void gotAHREF( String urlStr, URL contextUrl, Object clientData )
	{
	add( urlStr, contextUrl, (SpiderItem) clientData );
	}

    /// Acme.HtmlObserver callback.
    public void gotIMGSRC( String urlStr, URL contextUrl, Object clientData )
	{
	add( urlStr, contextUrl, (SpiderItem) clientData );
	}

    /// Acme.HtmlObserver callback.
    public void gotFRAMESRC( String urlStr, URL contextUrl, Object clientData )
	{
	add( urlStr, contextUrl, (SpiderItem) clientData );
	}

    /// Acme.HtmlObserver callback.
    public void gotBASEHREF( String urlStr, URL contextUrl, Object clientData )
	{
	// Nothing.
	}

    /// Acme.HtmlObserver callback.
    public void gotAREAHREF( String urlStr, URL contextUrl, Object clientData )
	{
	add( urlStr, contextUrl, (SpiderItem) clientData );
	}

    /// Acme.HtmlObserver callback.
    public void gotLINKHREF( String urlStr, URL contextUrl, Object clientData )
	{
	add( urlStr, contextUrl, (SpiderItem) clientData );
	}

    /// Acme.HtmlObserver callback.
    public void gotBODYBACKGROUND( String urlStr, URL contextUrl, Object clientData )
	{
	add( urlStr, contextUrl, (SpiderItem) clientData );
	}

    private void add( String urlStr, URL contextUrl, SpiderItem item )
	{
	try
	    {
	    // Convert to no-ref, canonical form.
	    URL url = Acme.Utils.plainUrl( contextUrl, urlStr );
	    urlStr = url.toExternalForm();
	    // Add it.
	    addOne( urlStr, contextUrl, item );
	    // Also add all parent directories up to the root.  We'll get
	    // a lot of duplicates this way, but the hashtable will filter
	    // them out.
	    String rootUrlStr =
		( new URL( new URL( urlStr ), "/" ) ).toExternalForm();
	    while ( urlStr.length() > rootUrlStr.length() )
		{
		int lastSlash = urlStr.lastIndexOf( '/', urlStr.length() - 2 );
		urlStr = urlStr.substring( 0, lastSlash + 1 );
		addOne( urlStr, contextUrl, item );
		}
	    }
	catch ( MalformedURLException e )
	    {
	    String msg = e.getMessage();
	    if ( checkMalformedURL( msg ) )
		brokenLink( myUrlToString( contextUrl ), urlStr, msg );
	    }
	}
    
    private void addOne( String urlStr, URL contextUrl, SpiderItem item )
	{
	// Check if we've already done this one.
	if ( ! done.containsKey( urlStr ) )
	    {
	    // Check if we should do this one.
	    if ( doThisUrl( urlStr, item.depth + 1, item.baseUrlStr ) )
		{
		// Yes.
		if ( todoLimit == 0 || todo.size() < todoLimit )
		    todo.addBack( new SpiderItem(
			urlStr, contextUrl, item.depth + 1,
			item.baseUrlStr ) );
		}
	    }
	}


    /// Test program.  Shows URLs, file sizes, etc. at the ACME Java site.
    public static void main( String[] args )
	{
	if ( args.length != 1 )
	    {
	    System.err.println( "usage: Spider URL" );
	    return;
	    }
	Enumeration as;
	try
	    {
	    // as = new Spider( args[0] );
	    as = new Spider( args[0], System.out );
	    }
	catch ( MalformedURLException e )
	    {
	    System.out.println( e );
	    return;
	    }

	while ( as.hasMoreElements() )
	    {
	    URLConnection uc = (URLConnection) as.nextElement();
	    URL thisUrl = uc.getURL();
	    String thisUrlStr = thisUrl.toExternalForm();
	    String mimeType = uc.getContentType();
	    int bytes = 0;
	    try
		{
		InputStream s = uc.getInputStream();
		while ( s.read() != -1 )
		    ++bytes;
		s.close();
		}
	    catch ( IOException e ) {}
	    System.out.println( thisUrlStr + " " + mimeType + " " + bytes );
	    }
	}

    }


// A struct class to hold info on a queued URL.
class SpiderItem
    {
    String thisUrlStr;
    URL fromUrl;
    int depth;
    String baseUrlStr;

    public SpiderItem(
	String thisUrlStr, URL fromUrl, int depth, String baseUrlStr )
	{
	this.thisUrlStr = thisUrlStr;
	this.fromUrl = fromUrl;
	this.depth = depth;
	this.baseUrlStr = baseUrlStr;
	}
    }


// SpiderConnection - utility class for Spider
//
// A SpiderConnection is the type returned by Spider.  It's a
// URLConnection, slightly modified internally to work with Spider.

class SpiderConnection extends URLConnection
    {
    private URLConnection uc;
    protected InputStream s;

    public SpiderConnection( URLConnection uc ) throws IOException
	{
	super( uc.getURL() );
	this.uc = uc;
	this.s = uc.getInputStream();
	}

    public SpiderConnection( URLConnection uc, InputStream s )
	{
	super( uc.getURL() );
	this.uc = uc;
	this.s = s;
	}

    public InputStream getInputStream() throws IOException
	{
	return s;
	}

    // The rest just forward to uc's methods.
    final public void connect() throws IOException
	{
	uc.connect();
	}
    final public URL getURL()
	{
	return uc.getURL();
	}
    final public int getContentLength()
	{
	return uc.getContentLength();
	}
    final public String getContentType()
	{
	return uc.getContentType();
	}
    final public String getContentEncoding()
	{
	return uc.getContentEncoding();
	}
    final public long getExpiration()
	{
	return uc.getExpiration();
	}
    final public long getDate()
	{
	return uc.getDate();
	}
    final public long getLastModified()
	{
	return uc.getLastModified();
	}
    final public String getHeaderField( String name )
	{
	return uc.getHeaderField( name );
	}
    final public int getHeaderFieldInt( String name, int Default )
	{
	return uc.getHeaderFieldInt( name, Default );
	}
    final public long getHeaderFieldDate( String name, long Default )
	{
	return uc.getHeaderFieldDate( name, Default );
	}
    final public String getHeaderFieldKey( int n )
	{
	return uc.getHeaderFieldKey( n );
	}
    final public String getHeaderField( int n )
	{
	return uc.getHeaderField( n );
	}
    final public Object getContent() throws IOException
	{
	return uc.getContent();
	}
    final public OutputStream getOutputStream() throws IOException
	{
	return uc.getOutputStream();
	}
    final public String toString()
	{
	return uc.toString();
	}
    final public void setDoInput( boolean doinput )
	{
	uc.setDoInput( doinput );
	}
    final public boolean getDoInput()
	{
	return uc.getDoInput();
	}
    final public void setDoOutput( boolean dooutput )
	{
	uc.setDoOutput( dooutput );
	}
    final public boolean getDoOutput()
	{
	return uc.getDoOutput();
	}
    final public void setAllowUserInteraction( boolean allowuserinteraction )
	{
	uc.setAllowUserInteraction( allowuserinteraction );
	}
    final public boolean getAllowUserInteraction()
	{
	return uc.getAllowUserInteraction();
	}
    final public static void setDefaultAllowUserInteraction(
	boolean defaultallowuserinteraction )
	{
	URLConnection.setDefaultAllowUserInteraction(
	    defaultallowuserinteraction );
	}
    final public static boolean getDefaultAllowUserInteraction()
	{
	return URLConnection.getDefaultAllowUserInteraction();
	}
    final public void setUseCaches( boolean usecaches )
	{
	uc.setUseCaches( usecaches );
	}
    final public boolean getUseCaches()
	{
	return uc.getUseCaches();
	}
    final public void setIfModifiedSince( long ifmodifiedsince )
	{
	uc.setIfModifiedSince( ifmodifiedsince );
	}
    final public long getIfModifiedSince()
	{
	return uc.getIfModifiedSince();
	}
    final public boolean getDefaultUseCaches()
	{
	return uc.getDefaultUseCaches();
	}
    final public void setDefaultUseCaches( boolean defaultusecaches )
	{
	uc.setDefaultUseCaches( defaultusecaches );
	}
    final public void setRequestProperty( String key, String value )
	{
	uc.setRequestProperty( key, value );
	}
    final public String getRequestProperty( String key )
	{
	return uc.getRequestProperty( key );
	}
    final public static void setDefaultRequestProperty(
	String key, String value )
	{
	URLConnection.setDefaultRequestProperty( key, value );
	}
    final public static String getDefaultRequestProperty( String key )
	{
	return URLConnection.getDefaultRequestProperty( key );
	}
    final public static void setContentHandlerFactory(
	ContentHandlerFactory fac )
	{
	URLConnection.setContentHandlerFactory( fac );
	}
    }
