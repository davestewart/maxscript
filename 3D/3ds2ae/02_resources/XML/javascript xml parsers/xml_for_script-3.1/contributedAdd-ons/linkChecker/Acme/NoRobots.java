// NoRobots - implements the Robot Exclusion Standard
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

package Acme;

import java.net.*;
import java.util.*;
import java.io.*;

/// Implements the Robot Exclusion Standard.
// <P>
// The basic idea of the Robot Exclusion Standard is that each web server
// can set up a single file called "/robots.txt" which contains pathnames
// that robots should not look at.  See
// <A HREF="http://www.robotstxt.org/wc/norobots.html">the full spec</A>
// for details.  Using this class is very simple - you create the object
// using your robot's name, and then you call ok() on each URL.  For
// efficiency, the class caches entries for servers you've visited recently.
// <P>
// <A HREF="/resources/classes/Acme/NoRobots.java">Fetch the software.</A><BR>
// <A HREF="/resources/classes/Acme.tar.gz">Fetch the entire Acme package.</A>
// <P>
// @see Acme.Spider

public class NoRobots
    {

    // The file with the robot rules in it.
    private static final String robotFile = "/robots.txt";

    // The name of this robot.
    private String robotName;

    // A table of all the servers we have visited recently.
    private Hashtable servers = new Acme.LruHashtable( 500 );


    /// Constructor.
    public NoRobots( String robotName )
	{
	this.robotName = robotName;
	}


    /// Check whether it's ok for this robot to fetch this URL.
    public boolean ok( URL url )
	{
	String protocol = url.getProtocol();
	String host = url.getHost();
	int port = url.getPort();
	if ( port == -1 )
	    port = 80;
	String file = url.getFile();
	Vector disallows = getDisallows( protocol, host, port );
	Enumeration en = disallows.elements();
	while ( en.hasMoreElements() )
	    {
	    String pattern = (String) en.nextElement();
	    if ( file.startsWith( pattern ) )
		return false;
	    }
	return true;
	}


    /// Get the disallows list for the given server.  If it's not
    // already in the servers hash table, we fetch it, parse it, and
    // save it.
    private Vector getDisallows( String protocol, String host, int port )
	{
	String key = protocol + "://" + host + ":" + port;
	Vector disallows = (Vector) servers.get( key );
	if ( disallows != null )
	    return disallows;

	disallows = new Vector();
	try
	    {
	    URL robotUrl = new URL( protocol, host, port, robotFile );
	    try
		{
		// DataInputStream robotStream =
		//     new DataInputStream( robotUrl.openStream() );
		BufferedReader robotReader =
		  new BufferedReader(
		    new InputStreamReader( robotUrl.openStream() ) );
		boolean userAgentIsMe = false;
		while ( true )
		    {
		    String line = robotReader.readLine();
		    if ( line == null )
			break;
		    line = line.trim();

		    // Completely ignore lines that are just a comment - they
		    // don't even separate records.
		    if ( line.startsWith( "#" ) )
			continue;

		    // Trim off any other comments.
		    int cmt = line.indexOf( '#' );
		    if ( cmt != -1 )
			line = line.substring( 0, cmt ).trim();

		    if ( line.length() == 0 )
			userAgentIsMe = false;
		    else if ( line.toLowerCase().startsWith( "user-agent:" ) )
			{
			if ( ! userAgentIsMe )
			    {
			    String value = line.substring( 11 ).trim();
			    if ( Acme.Utils.match( value, robotName ) )
				userAgentIsMe = true;
			    }
			}
		    else if ( line.toLowerCase().startsWith( "disallow:" ) )
			{
			if ( userAgentIsMe )
			    {
			    String value = line.substring( 9 ).trim();
			    disallows.addElement( value );
			    }
			}
		    }
		}
	    catch ( IOException ignore ) {}
	    }
	catch ( MalformedURLException ignore ) {}

	servers.put( key, disallows );
	return disallows;
	}

    }
