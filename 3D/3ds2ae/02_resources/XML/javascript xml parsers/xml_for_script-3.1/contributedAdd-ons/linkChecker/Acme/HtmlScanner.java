// HtmlScanner - a fast HTML scanning class
//
// Copyright (C)1996,1998,1999 by Jef Poskanzer <jef@acme.com>.
// All rights reserved.
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

/// A fast HTML scanning class.
// <P>
// This is a FilterInputStream that lets you read an HTML file, and at
// the same time scans it for URLs.  You get the full text of the file
// through the normal read() calls, and you also get special callbacks
// with the URL strings.
// <P>
// The scanning is done by a hand-built finite-state machine.
// <P>
// <A HREF="/resources/classes/Acme/HtmlScanner.java">Fetch the software.</A><BR>
// <A HREF="/resources/classes/Acme.tar.gz">Fetch the entire Acme package.</A>

public class HtmlScanner extends FilterInputStream
    {

    /// Used for maintaining correct context, even with <BASE>.
    private URL contextUrl;

    // The list of HtmlObservers to call, paired with clientDatas.
    private Vector observers = new Vector();

    /// Constructor.  If the client is not interested in getting called back
    // with URLs, observer can be null (but then there's not much point in
    // using this class).
    public HtmlScanner( InputStream s, URL thisUrl, Acme.HtmlObserver observer )
	{
	this( s, thisUrl, observer, null );
	}

    /// Constructor with clientData.  If the client is not interested in
    // getting called back with URLs, observer can be null (but then there's
    // not much point in using this class).
    public HtmlScanner( InputStream s, URL thisUrl, Acme.HtmlObserver observer, Object clientData )
	{
	super( s );
	try
	    {
	    contextUrl = Acme.Utils.plainUrl( thisUrl.toString() );
	    }
	catch ( MalformedURLException e ) {}
	if ( observer != null )
	    addObserver( observer, clientData );
	}

    /// Add an extra observer to this scanner.  Multiple observers get called
    // in the order they were added.
    public void addObserver( Acme.HtmlObserver observer )
	{
	addObserver( observer, null );
	}

    /// Add an extra observer to this scanner.  Multiple observers get called
    // in the order they were added.
    public void addObserver( Acme.HtmlObserver observer, Object clientData )
	{
	observers.addElement( new Acme.Pair( observer, clientData ) );
	}

    /// Special version of read() that runs all data through the HTML scanner.
    public int read( byte[] b, int off, int len ) throws IOException
	{
	int r = in.read( b, off, len );
	if ( r != -1 )
	    {
	    r += interpret( b, off, r );
	    if ( r < 0 )
		r = 0;	// not right
	    }
	return r;
	}

    private boolean closed = false;

    /// Override close() with one that makes sure the entire file gets
    // read, so that all its URLs get extracted, even if the caller isn't
    // interested in the data.
    public void close() throws IOException
	{
	if ( ! closed )	// protect against double closes
	    {
	    byte[] b = new byte[4096];
	    int len;
	    while ( ( len = read( b, 0, b.length ) ) != -1 )
		{}
	    in.close();
	    closed = true;
	    }
	}

    /// Add a finalize method to try and make sure that our
    // jiggered close() gets called.
    // @exception java.lang.Throwable if there's a problem
    protected void finalize() throws java.lang.Throwable
	{
	try
	    {
	    close();
	    }
	catch ( IOException e )
	    {}
	super.finalize();
	}

    /// Override to make sure this goes through the above
    // read( byte[], int, int) method.
    public int read() throws IOException
	{
	byte[] b = new byte[1];
	int r = read( b, 0, 1 );
	if ( r == -1 )
	    return -1;
	else
	    return b[0];
	}

    /// Override to make sure this goes through the above
    // read( byte[], int, int) method.
    public int read( byte[] b ) throws IOException
	{
	return read( b, 0, b.length );
	}

    /// Override to make sure this goes through the above
    // read( byte[], int, int) method.
    public long skip( long n ) throws IOException
	{
	byte[] b = new byte[(int) n];	// mildly bogus
	return read( b, 0, (int) n );
	}

    /// Disallow mark()/reset().
    public boolean markSupported()
	{
	return false;
	}

    // And here's the fun part - a finite-state-machine HTML scanner.
    //
    // Knows about: <!-- --> <A HREF=""> <IMG SRC=""> <FRAME SRC="">
    // <BASE HREF=""> <AREA HREF=""> <LINK HREF=""> <BODY BACKGROUND="">
    // <INPUT TYPE="image" SRC="">
    //
    // This is a big mess-o-code and not very maintainable or extendable, but
    // it's fast and doesn't compile to as much object code as you'd think.

    private final static int ST_GROUND =		0;
    private final static int ST_LT =			1;
    private final static int ST_LTJUNK =		2;
    private final static int ST_LT_BANG =		3;
    private final static int ST_LT_BANG_DASH =		4;
    private final static int ST_COMMENT =		5;
    private final static int ST_COMMENT_DASH =		6;
    private final static int ST_COMMENT_DASH_DASH =	7;
    private final static int ST_LT_A =			8;
    private final static int ST_A =			9;
    private final static int ST_A_QUOTE =		10;
    private final static int ST_A_H =			11;
    private final static int ST_A_HR =			12;
    private final static int ST_A_HRE =			13;
    private final static int ST_A_HREF =		14;
    private final static int ST_A_HREF_EQUAL =		15;
    private final static int ST_AHREF_Q =		16;
    private final static int ST_AHREF_NQ =		17;
    private final static int ST_LT_I =			18;
    private final static int ST_LT_IM =			19;
    private final static int ST_LT_IMG =		20;
    private final static int ST_IMG =			21;
    private final static int ST_IMG_QUOTE =		22;
    private final static int ST_IMG_S =			23;
    private final static int ST_IMG_SR =		24;
    private final static int ST_IMG_SRC =		25;
    private final static int ST_IMG_SRC_EQUAL =		26;
    private final static int ST_IMGSRC_Q =		27;
    private final static int ST_IMGSRC_NQ =		28;
    private final static int ST_LT_F =			29;
    private final static int ST_LT_FR =			30;
    private final static int ST_LT_FRA =		31;
    private final static int ST_LT_FRAM =		32;
    private final static int ST_LT_FRAME =		33;
    private final static int ST_FRAME =			34;
    private final static int ST_FRAME_QUOTE =		35;
    private final static int ST_FRAME_S =		36;
    private final static int ST_FRAME_SR =		37;
    private final static int ST_FRAME_SRC =		38;
    private final static int ST_FRAME_SRC_EQUAL =	39;
    private final static int ST_FRAMESRC_Q =		40;
    private final static int ST_FRAMESRC_NQ =		41;
    private final static int ST_LT_B =			42;
    private final static int ST_LT_BA =			43;
    private final static int ST_LT_BAS =		44;
    private final static int ST_LT_BASE =		45;
    private final static int ST_BASE =			46;
    private final static int ST_BASE_QUOTE =		47;
    private final static int ST_BASE_H =		48;
    private final static int ST_BASE_HR =		49;
    private final static int ST_BASE_HRE =		50;
    private final static int ST_BASE_HREF =		51;
    private final static int ST_BASE_HREF_EQUAL =	52;
    private final static int ST_BASEHREF_Q =		53;
    private final static int ST_BASEHREF_NQ =		54;
    private final static int ST_LT_AR =			55;
    private final static int ST_LT_ARE =		56;
    private final static int ST_LT_AREA =		57;
    private final static int ST_AREA =			58;
    private final static int ST_AREA_QUOTE =		59;
    private final static int ST_AREA_H =		60;
    private final static int ST_AREA_HR =		61;
    private final static int ST_AREA_HRE =		62;
    private final static int ST_AREA_HREF =		63;
    private final static int ST_AREA_HREF_EQUAL =	64;
    private final static int ST_AREAHREF_Q =		65;
    private final static int ST_AREAHREF_NQ =		66;
    private final static int ST_LT_L =			67;
    private final static int ST_LT_LI =			68;
    private final static int ST_LT_LIN =		69;
    private final static int ST_LT_LINK =		70;
    private final static int ST_LINK =			71;
    private final static int ST_LINK_QUOTE =		72;
    private final static int ST_LINK_H =		73;
    private final static int ST_LINK_HR =		74;
    private final static int ST_LINK_HRE =		75;
    private final static int ST_LINK_HREF =		76;
    private final static int ST_LINK_HREF_EQUAL =	77;
    private final static int ST_LINKHREF_Q =		78;
    private final static int ST_LINKHREF_NQ =		79;
    private final static int ST_LT_BO =			80;
    private final static int ST_LT_BOD =		81;
    private final static int ST_LT_BODY =		82;
    private final static int ST_BODY =			83;
    private final static int ST_BODY_QUOTE =		84;
    private final static int ST_BODY_B =		85;
    private final static int ST_BODY_BA =		86;
    private final static int ST_BODY_BAC =		87;
    private final static int ST_BODY_BACK =		88;
    private final static int ST_BODY_BACKG =		89;
    private final static int ST_BODY_BACKGR =		90;
    private final static int ST_BODY_BACKGRO =		91;
    private final static int ST_BODY_BACKGROU =		92;
    private final static int ST_BODY_BACKGROUN =	93;
    private final static int ST_BODY_BACKGROUND =	94;
    private final static int ST_BODY_BACKGROUND_EQUAL =	95;
    private final static int ST_BODYBACKGROUND_Q =	96;
    private final static int ST_BODYBACKGROUND_NQ =	97;
    private final static int ST_LT_IN =			98;
    private final static int ST_LT_INP =		99;
    private final static int ST_LT_INPU =		100;
    private final static int ST_LT_INPUT =		101;
    private final static int ST_INPUT =			102;
    private final static int ST_INPUT_QUOTE =		103;
    private final static int ST_INPUT_S =		104;
    private final static int ST_INPUT_SR =		105;
    private final static int ST_INPUT_SRC =		106;
    private final static int ST_INPUT_SRC_EQUAL =	107;
    private final static int ST_INPUTSRC_Q =		108;
    private final static int ST_INPUTSRC_NQ =		109;

    private int state = ST_GROUND;
    private StringBuffer urlBuf = new StringBuffer( 100 );

    /// Whether the interpreter is currently accumulating a URL.
    protected boolean gettingUrl = false;

    // Shared with substitute().
    private byte[] interpBuf;
    private int interpIndex;
    private int interpEnd;
    private int interpDelta;

    /// Run the finite-state machine on a buffer-load.
    private int interpret( byte[] b, int off, int len )
	{
	interpBuf = b;
	interpDelta = 0;
	interpEnd = off + len;
	for ( interpIndex = off; interpIndex < interpEnd; ++interpIndex )
	    {
	    char ch = (char) b[interpIndex];
	    switch ( state )
		{
		case ST_GROUND:
		switch ( ch )
		    {
		    case '<': state = ST_LT; break;
		    default: break;
		    }
		break;
		case ST_LT:
		switch ( ch )
		    {
		    case '!': state = ST_LT_BANG; break;
		    case 'A': case 'a': state = ST_LT_A; break;
		    case 'B': case 'b': state = ST_LT_B; break;
		    case 'F': case 'f': state = ST_LT_F; break;
		    case 'I': case 'i': state = ST_LT_I; break;
		    case 'L': case 'l': state = ST_LT_L; break;
		    case '>': state = ST_GROUND; break;
		    default: state = ST_LTJUNK; break;
		    }
		break;
		case ST_LTJUNK:
		switch ( ch )
		    {
		    case '>': state = ST_GROUND; break;
		    default: break;
		    }
		break;
		case ST_LT_BANG:
		switch ( ch )
		    {
		    case '-': state = ST_LT_BANG_DASH; break;
		    case '>': state = ST_GROUND; break;
		    default: state = ST_LTJUNK; break;
		    }
		break;
		case ST_LT_BANG_DASH:
		switch ( ch )
		    {
		    case '-': state = ST_COMMENT; break;
		    case '>': state = ST_GROUND; break;
		    default: state = ST_LTJUNK; break;
		    }
		break;
		case ST_COMMENT:
		switch ( ch )
		    {
		    case '-': state = ST_COMMENT_DASH; break;
		    default: break;
		    }
		break;
		case ST_COMMENT_DASH:
		switch ( ch )
		    {
		    case '-': state = ST_COMMENT_DASH_DASH; break;
		    default: break;
		    }
		break;
		case ST_COMMENT_DASH_DASH:
		switch ( ch )
		    {
		    case '>': state = ST_GROUND; break;
		    default: break;
		    }
		break;
		case ST_LT_A:
		switch ( ch )
		    {
		    case ' ': case '\t': case '\n': case '\r':
		    state = ST_A; break;
		    case 'R': case 'r': state = ST_LT_AR; break;
		    case '>': state = ST_GROUND; break;
		    default: state = ST_LTJUNK; break;
		    }
		break;
		case ST_A:
		switch ( ch )
		    {
		    case '>': state = ST_GROUND; break;
		    case '"': state = ST_A_QUOTE; break;
		    case 'H': case 'h': state = ST_A_H; break;
		    default: break;
		    }
		break;
		case ST_A_QUOTE:
		switch ( ch )
		    {
		    case '"': state = ST_A; break;
		    default: break;
		    }
		break;
		case ST_A_H:
		switch ( ch )
		    {
		    case 'R': case 'r': state = ST_A_HR; break;
		    case '"': state = ST_A_QUOTE; break;
		    default: state = ST_A; break;
		    }
		break;
		case ST_A_HR:
		switch ( ch )
		    {
		    case 'E': case 'e': state = ST_A_HRE; break;
		    case '"': state = ST_A_QUOTE; break;
		    default: state = ST_A; break;
		    }
		break;
		case ST_A_HRE:
		switch ( ch )
		    {
		    case 'F': case 'f': state = ST_A_HREF; break;
		    case '"': state = ST_A_QUOTE; break;
		    default: state = ST_A; break;
		    }
		break;
		case ST_A_HREF:
		switch ( ch )
		    {
		    case ' ': case '\t': case '\n': case '\r': break;
		    case '=': state = ST_A_HREF_EQUAL; break;
		    case '"': state = ST_A_QUOTE; break;
		    default: state = ST_A; break;
		    }
		break;
		case ST_A_HREF_EQUAL:
		// Start accumulating a URL.
		gettingUrl = true;
		urlBuf.setLength( 0 );
		switch ( ch )
		    {
		    case ' ': case '\t': case '\n': case '\r': break;
		    case '"': state = ST_AHREF_Q; break;
		    default:
		    // Accumulate the URL.
		    urlBuf.append( ch );
		    state = ST_AHREF_NQ;
		    break;
		    }
		break;
		case ST_AHREF_Q:
		switch ( ch )
		    {
		    case '"':
		    // Got a complete URL.
		    callAHREF( urlBuf.toString() );
		    gettingUrl = false;
		    state = ST_A;
		    break;
		    default:
		    // Accumulate the URL.
		    urlBuf.append( ch );
		    break;
		    }
		break;
		case ST_AHREF_NQ:
		switch ( ch )
		    {
		    case '>':
		    case ' ': case '\t': case '\n': case '\r':
		    // Got a complete URL.
		    callAHREF( urlBuf.toString() );
		    gettingUrl = false;
		    state = ( ch == '>' ? ST_GROUND : ST_A );
		    break;
		    default:
		    // Accumulate the URL.
		    urlBuf.append( ch );
		    break;
		    }
		break;
		case ST_LT_I:
		switch ( ch )
		    {
		    case 'M': case 'm': state = ST_LT_IM; break;
		    case 'N': case 'n': state = ST_LT_IN; break;
		    case '>': state = ST_GROUND; break;
		    default: state = ST_LTJUNK; break;
		    }
		break;
		case ST_LT_IM:
		switch ( ch )
		    {
		    case 'G': case 'g': state = ST_LT_IMG; break;
		    case '>': state = ST_GROUND; break;
		    default: state = ST_LTJUNK; break;
		    }
		break;
		case ST_LT_IMG:
		switch ( ch )
		    {
		    case ' ': case '\t': case '\n': case '\r':
		    state = ST_IMG; break;
		    case '>': state = ST_GROUND; break;
		    default: state = ST_LTJUNK; break;
		    }
		break;
		case ST_IMG:
		switch ( ch )
		    {
		    case '>': state = ST_GROUND; break;
		    case '"': state = ST_IMG_QUOTE; break;
		    case 'S': case 's': state = ST_IMG_S; break;
		    default: break;
		    }
		break;
		case ST_IMG_QUOTE:
		switch ( ch )
		    {
		    case '"': state = ST_IMG; break;
		    default: break;
		    }
		break;
		case ST_IMG_S:
		switch ( ch )
		    {
		    case 'R': case 'r': state = ST_IMG_SR; break;
		    case '"': state = ST_IMG_QUOTE; break;
		    default: state = ST_IMG; break;
		    }
		break;
		case ST_IMG_SR:
		switch ( ch )
		    {
		    case 'C': case 'c': state = ST_IMG_SRC; break;
		    case '"': state = ST_IMG_QUOTE; break;
		    default: state = ST_IMG; break;
		    }
		break;
		case ST_IMG_SRC:
		switch ( ch )
		    {
		    case ' ': case '\t': case '\n': case '\r': break;
		    case '=': state = ST_IMG_SRC_EQUAL; break;
		    case '"': state = ST_IMG_QUOTE; break;
		    default: state = ST_IMG; break;
		    }
		break;
		case ST_IMG_SRC_EQUAL:
		// Start accumulating a URL.
		urlBuf.setLength( 0 );
		gettingUrl = true;
		switch ( ch )
		    {
		    case ' ': case '\t': case '\n': case '\r': break;
		    case '"': state = ST_IMGSRC_Q; break;
		    default:
		    // Accumulate the URL.
		    urlBuf.append( ch );
		    state = ST_IMGSRC_NQ;
		    break;
		    }
		break;
		case ST_IMGSRC_Q:
		switch ( ch )
		    {
		    case '"':
		    // Got a complete URL.
		    callIMGSRC( urlBuf.toString() );
		    gettingUrl = false;
		    state = ST_IMG;
		    break;
		    default:
		    // Accumulate the URL.
		    urlBuf.append( ch );
		    break;
		    }
		break;
		case ST_IMGSRC_NQ:
		switch ( ch )
		    {
		    case '>':
		    case ' ': case '\t': case '\n': case '\r':
		    // Got a complete URL.
		    callIMGSRC( urlBuf.toString() );
		    gettingUrl = false;
		    state = ( ch == '>' ? ST_GROUND : ST_IMG );
		    break;
		    default:
		    // Accumulate the URL.
		    urlBuf.append( ch );
		    break;
		    }
		break;
		case ST_LT_F:
		switch ( ch )
		    {
		    case 'R': case 'r': state = ST_LT_FR; break;
		    case '>': state = ST_GROUND; break;
		    default: state = ST_LTJUNK; break;
		    }
		break;
		case ST_LT_FR:
		switch ( ch )
		    {
		    case 'A': case 'a': state = ST_LT_FRA; break;
		    case '>': state = ST_GROUND; break;
		    default: state = ST_LTJUNK; break;
		    }
		break;
		case ST_LT_FRA:
		switch ( ch )
		    {
		    case 'M': case 'm': state = ST_LT_FRAM; break;
		    case '>': state = ST_GROUND; break;
		    default: state = ST_LTJUNK; break;
		    }
		break;
		case ST_LT_FRAM:
		switch ( ch )
		    {
		    case 'E': case 'e': state = ST_LT_FRAME; break;
		    case '>': state = ST_GROUND; break;
		    default: state = ST_LTJUNK; break;
		    }
		break;
		case ST_LT_FRAME:
		switch ( ch )
		    {
		    case ' ': case '\t': case '\n': case '\r':
		    state = ST_FRAME; break;
		    case '>': state = ST_GROUND; break;
		    default: state = ST_LTJUNK; break;
		    }
		break;
		case ST_FRAME:
		switch ( ch )
		    {
		    case '>': state = ST_GROUND; break;
		    case '"': state = ST_FRAME_QUOTE; break;
		    case 'S': case 's': state = ST_FRAME_S; break;
		    default: break;
		    }
		break;
		case ST_FRAME_QUOTE:
		switch ( ch )
		    {
		    case '"': state = ST_FRAME; break;
		    default: break;
		    }
		break;
		case ST_FRAME_S:
		switch ( ch )
		    {
		    case 'R': case 'r': state = ST_FRAME_SR; break;
		    case '"': state = ST_FRAME_QUOTE; break;
		    default: state = ST_FRAME; break;
		    }
		break;
		case ST_FRAME_SR:
		switch ( ch )
		    {
		    case 'C': case 'c': state = ST_FRAME_SRC; break;
		    case '"': state = ST_FRAME_QUOTE; break;
		    default: state = ST_FRAME; break;
		    }
		break;
		case ST_FRAME_SRC:
		switch ( ch )
		    {
		    case ' ': case '\t': case '\n': case '\r': break;
		    case '=': state = ST_FRAME_SRC_EQUAL; break;
		    case '"': state = ST_FRAME_QUOTE; break;
		    default: state = ST_FRAME; break;
		    }
		break;
		case ST_FRAME_SRC_EQUAL:
		// Start accumulating a URL.
		urlBuf.setLength( 0 );
		gettingUrl = true;
		switch ( ch )
		    {
		    case ' ': case '\t': case '\n': case '\r': break;
		    case '"': state = ST_FRAMESRC_Q; break;
		    default:
		    // Accumulate the URL.
		    urlBuf.append( ch );
		    state = ST_FRAMESRC_NQ;
		    break;
		    }
		break;
		case ST_FRAMESRC_Q:
		switch ( ch )
		    {
		    case '"':
		    // Got a complete URL.
		    callFRAMESRC( urlBuf.toString() );
		    gettingUrl = false;
		    state = ST_FRAME;
		    break;
		    default:
		    // Accumulate the URL.
		    urlBuf.append( ch );
		    break;
		    }
		break;
		case ST_FRAMESRC_NQ:
		switch ( ch )
		    {
		    case '>':
		    case ' ': case '\t': case '\n': case '\r':
		    // Got a complete URL.
		    callFRAMESRC( urlBuf.toString() );
		    gettingUrl = false;
		    state = ( ch == '>' ? ST_GROUND : ST_FRAME );
		    break;
		    default:
		    // Accumulate the URL.
		    urlBuf.append( ch );
		    break;
		    }
		break;
		case ST_LT_B:
		switch ( ch )
		    {
		    case 'A': case 'a': state = ST_LT_BA; break;
		    case 'O': case 'o': state = ST_LT_BO; break;
		    case '>': state = ST_GROUND; break;
		    default: state = ST_LTJUNK; break;
		    }
		break;
		case ST_LT_BA:
		switch ( ch )
		    {
		    case 'S': case 's': state = ST_LT_BAS; break;
		    case '>': state = ST_GROUND; break;
		    default: state = ST_LTJUNK; break;
		    }
		break;
		case ST_LT_BAS:
		switch ( ch )
		    {
		    case 'E': case 'e': state = ST_LT_BASE; break;
		    case '>': state = ST_GROUND; break;
		    default: state = ST_LTJUNK; break;
		    }
		break;
		case ST_LT_BASE:
		switch ( ch )
		    {
		    case ' ': case '\t': case '\n': case '\r':
		    state = ST_BASE; break;
		    case '>': state = ST_GROUND; break;
		    default: state = ST_LTJUNK; break;
		    }
		break;
		case ST_BASE:
		switch ( ch )
		    {
		    case '>': state = ST_GROUND; break;
		    case '"': state = ST_BASE_QUOTE; break;
		    case 'H': case 'h': state = ST_BASE_H; break;
		    default: break;
		    }
		break;
		case ST_BASE_QUOTE:
		switch ( ch )
		    {
		    case '"': state = ST_BASE; break;
		    default: break;
		    }
		break;
		case ST_BASE_H:
		switch ( ch )
		    {
		    case 'R': case 'r': state = ST_BASE_HR; break;
		    case '"': state = ST_BASE_QUOTE; break;
		    default: state = ST_BASE; break;
		    }
		break;
		case ST_BASE_HR:
		switch ( ch )
		    {
		    case 'E': case 'e': state = ST_BASE_HRE; break;
		    case '"': state = ST_BASE_QUOTE; break;
		    default: state = ST_BASE; break;
		    }
		break;
		case ST_BASE_HRE:
		switch ( ch )
		    {
		    case 'F': case 'f': state = ST_BASE_HREF; break;
		    case '"': state = ST_BASE_QUOTE; break;
		    default: state = ST_BASE; break;
		    }
		break;
		case ST_BASE_HREF:
		switch ( ch )
		    {
		    case ' ': case '\t': case '\n': case '\r': break;
		    case '=': state = ST_BASE_HREF_EQUAL; break;
		    case '"': state = ST_BASE_QUOTE; break;
		    default: state = ST_BASE; break;
		    }
		break;
		case ST_BASE_HREF_EQUAL:
		// Start accumulating a URL.
		urlBuf.setLength( 0 );
		gettingUrl = true;
		switch ( ch )
		    {
		    case ' ': case '\t': case '\n': case '\r': break;
		    case '"': state = ST_BASEHREF_Q; break;
		    default:
		    // Accumulate the URL.
		    urlBuf.append( ch );
		    state = ST_BASEHREF_NQ;
		    break;
		    }
		break;
		case ST_BASEHREF_Q:
		switch ( ch )
		    {
		    case '"':
		    // Got a complete URL.
		    callBASEHREF( urlBuf.toString() );
		    gettingUrl = false;
		    // Make it the new context.
		    try
			{
			contextUrl = Acme.Utils.plainUrl(
			    contextUrl, urlBuf.toString() );
			}
		    catch ( MalformedURLException e ) {}
		    state = ST_BASE;
		    break;
		    default:
		    // Accumulate the URL.
		    urlBuf.append( ch );
		    break;
		    }
		break;
		case ST_BASEHREF_NQ:
		switch ( ch )
		    {
		    case '>':
		    case ' ': case '\t': case '\n': case '\r':
		    // Got a complete URL.
		    callBASEHREF( urlBuf.toString() );
		    gettingUrl = false;
		    // Make it the new context.
		    try
			{
			contextUrl = Acme.Utils.plainUrl(
			    contextUrl, urlBuf.toString() );
			}
		    catch ( MalformedURLException e ) {}
		    state = ( ch == '>' ? ST_GROUND : ST_BASE );
		    break;
		    default:
		    // Accumulate the URL.
		    urlBuf.append( ch );
		    break;
		    }
		break;
		case ST_LT_AR:
		switch ( ch )
		    {
		    case 'E': case 'e': state = ST_LT_ARE; break;
		    case '>': state = ST_GROUND; break;
		    default: state = ST_LTJUNK; break;
		    }
		break;
		case ST_LT_ARE:
		switch ( ch )
		    {
		    case 'A': case 'a': state = ST_LT_AREA; break;
		    case '>': state = ST_GROUND; break;
		    default: state = ST_LTJUNK; break;
		    }
		break;
		case ST_LT_AREA:
		switch ( ch )
		    {
		    case ' ': case '\t': case '\n': case '\r':
		    state = ST_AREA; break;
		    case '>': state = ST_GROUND; break;
		    default: state = ST_LTJUNK; break;
		    }
		break;
		case ST_AREA:
		switch ( ch )
		    {
		    case '>': state = ST_GROUND; break;
		    case '"': state = ST_AREA_QUOTE; break;
		    case 'H': case 'h': state = ST_AREA_H; break;
		    default: break;
		    }
		break;
		case ST_AREA_QUOTE:
		switch ( ch )
		    {
		    case '"': state = ST_AREA; break;
		    default: break;
		    }
		break;
		case ST_AREA_H:
		switch ( ch )
		    {
		    case 'R': case 'r': state = ST_AREA_HR; break;
		    case '"': state = ST_AREA_QUOTE; break;
		    default: state = ST_AREA; break;
		    }
		break;
		case ST_AREA_HR:
		switch ( ch )
		    {
		    case 'E': case 'e': state = ST_AREA_HRE; break;
		    case '"': state = ST_AREA_QUOTE; break;
		    default: state = ST_AREA; break;
		    }
		break;
		case ST_AREA_HRE:
		switch ( ch )
		    {
		    case 'F': case 'f': state = ST_AREA_HREF; break;
		    case '"': state = ST_AREA_QUOTE; break;
		    default: state = ST_AREA; break;
		    }
		break;
		case ST_AREA_HREF:
		switch ( ch )
		    {
		    case ' ': case '\t': case '\n': case '\r': break;
		    case '=': state = ST_AREA_HREF_EQUAL; break;
		    case '"': state = ST_AREA_QUOTE; break;
		    default: state = ST_AREA; break;
		    }
		break;
		case ST_AREA_HREF_EQUAL:
		// Start accumulating a URL.
		urlBuf.setLength( 0 );
		gettingUrl = true;
		switch ( ch )
		    {
		    case ' ': case '\t': case '\n': case '\r': break;
		    case '"': state = ST_AREAHREF_Q; break;
		    default:
		    // Accumulate the URL.
		    urlBuf.append( ch );
		    state = ST_AREAHREF_NQ;
		    break;
		    }
		break;
		case ST_AREAHREF_Q:
		switch ( ch )
		    {
		    case '"':
		    // Got a complete URL.
		    callAREAHREF( urlBuf.toString() );
		    gettingUrl = false;
		    state = ST_AREA;
		    break;
		    default:
		    // Accumulate the URL.
		    urlBuf.append( ch );
		    break;
		    }
		break;
		case ST_AREAHREF_NQ:
		switch ( ch )
		    {
		    case '>':
		    case ' ': case '\t': case '\n': case '\r':
		    // Got a complete URL.
		    callAREAHREF( urlBuf.toString() );
		    gettingUrl = false;
		    state = ( ch == '>' ? ST_GROUND : ST_AREA );
		    break;
		    default:
		    // Accumulate the URL.
		    urlBuf.append( ch );
		    break;
		    }
		break;
		case ST_LT_L:
		switch ( ch )
		    {
		    case 'I': case 'i': state = ST_LT_LI; break;
		    case '>': state = ST_GROUND; break;
		    default: state = ST_LTJUNK; break;
		    }
		break;
		case ST_LT_LI:
		switch ( ch )
		    {
		    case 'N': case 'n': state = ST_LT_LIN; break;
		    case '>': state = ST_GROUND; break;
		    default: state = ST_LTJUNK; break;
		    }
		break;
		case ST_LT_LIN:
		switch ( ch )
		    {
		    case 'K': case 'k': state = ST_LT_LINK; break;
		    case '>': state = ST_GROUND; break;
		    default: state = ST_LTJUNK; break;
		    }
		break;
		case ST_LT_LINK:
		switch ( ch )
		    {
		    case ' ': case '\t': case '\n': case '\r':
		    state = ST_LINK; break;
		    case '>': state = ST_GROUND; break;
		    default: state = ST_LTJUNK; break;
		    }
		break;
		case ST_LINK:
		switch ( ch )
		    {
		    case '>': state = ST_GROUND; break;
		    case '"': state = ST_LINK_QUOTE; break;
		    case 'H': case 'h': state = ST_LINK_H; break;
		    default: break;
		    }
		break;
		case ST_LINK_QUOTE:
		switch ( ch )
		    {
		    case '"': state = ST_LINK; break;
		    default: break;
		    }
		break;
		case ST_LINK_H:
		switch ( ch )
		    {
		    case 'R': case 'r': state = ST_LINK_HR; break;
		    case '"': state = ST_LINK_QUOTE; break;
		    default: state = ST_LINK; break;
		    }
		break;
		case ST_LINK_HR:
		switch ( ch )
		    {
		    case 'E': case 'e': state = ST_LINK_HRE; break;
		    case '"': state = ST_LINK_QUOTE; break;
		    default: state = ST_LINK; break;
		    }
		break;
		case ST_LINK_HRE:
		switch ( ch )
		    {
		    case 'F': case 'f': state = ST_LINK_HREF; break;
		    case '"': state = ST_LINK_QUOTE; break;
		    default: state = ST_LINK; break;
		    }
		break;
		case ST_LINK_HREF:
		switch ( ch )
		    {
		    case ' ': case '\t': case '\n': case '\r': break;
		    case '=': state = ST_LINK_HREF_EQUAL; break;
		    case '"': state = ST_LINK_QUOTE; break;
		    default: state = ST_LINK; break;
		    }
		break;
		case ST_LINK_HREF_EQUAL:
		// Start accumulating a URL.
		urlBuf.setLength( 0 );
		gettingUrl = true;
		switch ( ch )
		    {
		    case ' ': case '\t': case '\n': case '\r': break;
		    case '"': state = ST_LINKHREF_Q; break;
		    default:
		    // Accumulate the URL.
		    urlBuf.append( ch );
		    state = ST_LINKHREF_NQ;
		    break;
		    }
		break;
		case ST_LINKHREF_Q:
		switch ( ch )
		    {
		    case '"':
		    // Got a complete URL.
		    callLINKHREF( urlBuf.toString() );
		    gettingUrl = false;
		    state = ST_LINK;
		    break;
		    default:
		    // Accumulate the URL.
		    urlBuf.append( ch );
		    break;
		    }
		break;
		case ST_LINKHREF_NQ:
		switch ( ch )
		    {
		    case '>':
		    case ' ': case '\t': case '\n': case '\r':
		    // Got a complete URL.
		    callLINKHREF( urlBuf.toString() );
		    gettingUrl = false;
		    state = ( ch == '>' ? ST_GROUND : ST_LINK );
		    break;
		    default:
		    // Accumulate the URL.
		    urlBuf.append( ch );
		    break;
		    }
		break;
		case ST_LT_BO:
		switch ( ch )
		    {
		    case 'D': case 'd': state = ST_LT_BOD; break;
		    case '>': state = ST_GROUND; break;
		    default: state = ST_LTJUNK; break;
		    }
		break;
		case ST_LT_BOD:
		switch ( ch )
		    {
		    case 'Y': case 'y': state = ST_LT_BODY; break;
		    case '>': state = ST_GROUND; break;
		    default: state = ST_LTJUNK; break;
		    }
		break;
		case ST_LT_BODY:
		switch ( ch )
		    {
		    case ' ': case '\t': case '\n': case '\r':
		    state = ST_BODY; break;
		    case '>': state = ST_GROUND; break;
		    default: state = ST_LTJUNK; break;
		    }
		break;
		case ST_BODY:
		switch ( ch )
		    {
		    case '>': state = ST_GROUND; break;
		    case '"': state = ST_BODY_QUOTE; break;
		    case 'B': case 'b': state = ST_BODY_B; break;
		    default: break;
		    }
		break;
		case ST_BODY_QUOTE:
		switch ( ch )
		    {
		    case '"': state = ST_BODY; break;
		    default: break;
		    }
		break;
		case ST_BODY_B:
		switch ( ch )
		    {
		    case 'A': case 'a': state = ST_BODY_BA; break;
		    case '"': state = ST_BODY_QUOTE; break;
		    default: state = ST_BODY; break;
		    }
		break;
		case ST_BODY_BA:
		switch ( ch )
		    {
		    case 'C': case 'c': state = ST_BODY_BAC; break;
		    case '"': state = ST_BODY_QUOTE; break;
		    default: state = ST_BODY; break;
		    }
		break;
		case ST_BODY_BAC:
		switch ( ch )
		    {
		    case 'K': case 'k': state = ST_BODY_BACK; break;
		    case '"': state = ST_BODY_QUOTE; break;
		    default: state = ST_BODY; break;
		    }
		break;
		case ST_BODY_BACK:
		switch ( ch )
		    {
		    case 'G': case 'g': state = ST_BODY_BACKG; break;
		    case '"': state = ST_BODY_QUOTE; break;
		    default: state = ST_BODY; break;
		    }
		break;
		case ST_BODY_BACKG:
		switch ( ch )
		    {
		    case 'R': case 'r': state = ST_BODY_BACKGR; break;
		    case '"': state = ST_BODY_QUOTE; break;
		    default: state = ST_BODY; break;
		    }
		break;
		case ST_BODY_BACKGR:
		switch ( ch )
		    {
		    case 'O': case 'o': state = ST_BODY_BACKGRO; break;
		    case '"': state = ST_BODY_QUOTE; break;
		    default: state = ST_BODY; break;
		    }
		break;
		case ST_BODY_BACKGRO:
		switch ( ch )
		    {
		    case 'U': case 'u': state = ST_BODY_BACKGROU; break;
		    case '"': state = ST_BODY_QUOTE; break;
		    default: state = ST_BODY; break;
		    }
		break;
		case ST_BODY_BACKGROU:
		switch ( ch )
		    {
		    case 'N': case 'n': state = ST_BODY_BACKGROUN; break;
		    case '"': state = ST_BODY_QUOTE; break;
		    default: state = ST_BODY; break;
		    }
		break;
		case ST_BODY_BACKGROUN:
		switch ( ch )
		    {
		    case 'D': case 'd': state = ST_BODY_BACKGROUND; break;
		    case '"': state = ST_BODY_QUOTE; break;
		    default: state = ST_BODY; break;
		    }
		break;
		case ST_BODY_BACKGROUND:
		switch ( ch )
		    {
		    case ' ': case '\t': case '\n': case '\r': break;
		    case '=': state = ST_BODY_BACKGROUND_EQUAL; break;
		    case '"': state = ST_BODY_QUOTE; break;
		    default: state = ST_BODY; break;
		    }
		break;
		case ST_BODY_BACKGROUND_EQUAL:
		// Start accumulating a URL.
		urlBuf.setLength( 0 );
		gettingUrl = true;
		switch ( ch )
		    {
		    case ' ': case '\t': case '\n': case '\r': break;
		    case '"': state = ST_BODYBACKGROUND_Q; break;
		    default:
		    // Accumulate the URL.
		    urlBuf.append( ch );
		    state = ST_BODYBACKGROUND_NQ;
		    break;
		    }
		break;
		case ST_BODYBACKGROUND_Q:
		switch ( ch )
		    {
		    case '"':
		    // Got a complete URL.
		    callBODYBACKGROUND( urlBuf.toString() );
		    gettingUrl = false;
		    state = ST_BODY;
		    break;
		    default:
		    // Accumulate the URL.
		    urlBuf.append( ch );
		    break;
		    }
		break;
		case ST_BODYBACKGROUND_NQ:
		switch ( ch )
		    {
		    case '>':
		    case ' ': case '\t': case '\n': case '\r':
		    // Got a complete URL.
		    callBODYBACKGROUND( urlBuf.toString() );
		    gettingUrl = false;
		    state = ( ch == '>' ? ST_GROUND : ST_BODY );
		    break;
		    default:
		    // Accumulate the URL.
		    urlBuf.append( ch );
		    break;
		    }
		break;
		case ST_LT_IN:
		switch ( ch )
		    {
		    case 'P': case 'p': state = ST_LT_INP; break;
		    case '>': state = ST_GROUND; break;
		    default: state = ST_LTJUNK; break;
		    }
		break;
		case ST_LT_INP:
		switch ( ch )
		    {
		    case 'U': case 'u': state = ST_LT_INPU; break;
		    case '>': state = ST_GROUND; break;
		    default: state = ST_LTJUNK; break;
		    }
		break;
		case ST_LT_INPU:
		switch ( ch )
		    {
		    case 'T': case 't': state = ST_LT_INPUT; break;
		    case '>': state = ST_GROUND; break;
		    default: state = ST_LTJUNK; break;
		    }
		break;
		case ST_LT_INPUT:
		switch ( ch )
		    {
		    case ' ': case '\t': case '\n': case '\r':
		    state = ST_INPUT; break;
		    case '>': state = ST_GROUND; break;
		    default: state = ST_LTJUNK; break;
		    }
		break;
		case ST_INPUT:
		switch ( ch )
		    {
		    case '>': state = ST_GROUND; break;
		    case '"': state = ST_INPUT_QUOTE; break;
		    case 'S': case 's': state = ST_INPUT_S; break;
		    default: break;
		    }
		break;
		case ST_INPUT_QUOTE:
		switch ( ch )
		    {
		    case '"': state = ST_INPUT; break;
		    default: break;
		    }
		break;
		case ST_INPUT_S:
		switch ( ch )
		    {
		    case 'R': case 'r': state = ST_INPUT_SR; break;
		    case '"': state = ST_INPUT_QUOTE; break;
		    default: state = ST_INPUT; break;
		    }
		break;
		case ST_INPUT_SR:
		switch ( ch )
		    {
		    case 'C': case 'c': state = ST_INPUT_SRC; break;
		    case '"': state = ST_INPUT_QUOTE; break;
		    default: state = ST_INPUT; break;
		    }
		break;
		case ST_INPUT_SRC:
		switch ( ch )
		    {
		    case ' ': case '\t': case '\n': case '\r': break;
		    case '=': state = ST_INPUT_SRC_EQUAL; break;
		    case '"': state = ST_INPUT_QUOTE; break;
		    default: state = ST_INPUT; break;
		    }
		break;
		case ST_INPUT_SRC_EQUAL:
		// Start accumulating a URL.
		urlBuf.setLength( 0 );
		gettingUrl = true;
		switch ( ch )
		    {
		    case ' ': case '\t': case '\n': case '\r': break;
		    case '"': state = ST_INPUTSRC_Q; break;
		    default:
		    // Accumulate the URL.
		    urlBuf.append( ch );
		    state = ST_INPUTSRC_NQ;
		    break;
		    }
		break;
		case ST_INPUTSRC_Q:
		switch ( ch )
		    {
		    case '"':
		    // Got a complete URL.
		    callIMGSRC( urlBuf.toString() );
		    gettingUrl = false;
		    state = ST_INPUT;
		    break;
		    default:
		    // Accumulate the URL.
		    urlBuf.append( ch );
		    break;
		    }
		break;
		case ST_INPUTSRC_NQ:
		switch ( ch )
		    {
		    case '>':
		    case ' ': case '\t': case '\n': case '\r':
		    // Got a complete URL.
		    callIMGSRC( urlBuf.toString() );
		    gettingUrl = false;
		    state = ( ch == '>' ? ST_GROUND : ST_INPUT );
		    break;
		    default:
		    // Accumulate the URL.
		    urlBuf.append( ch );
		    break;
		    }
		break;
		}
	    }
	return interpDelta;
	}

    private void callAHREF( String urlStr )
	{
	Enumeration en = observers.elements();
	while ( en.hasMoreElements() )
	    {
	    Acme.Pair pair = (Acme.Pair) en.nextElement();
	    Acme.HtmlObserver observer = (HtmlObserver) pair.left();
	    Object clientData = pair.right();
	    observer.gotAHREF( urlStr, contextUrl, clientData );
	    }
	}

    private void callIMGSRC( String urlStr )
	{
	Enumeration en = observers.elements();
	while ( en.hasMoreElements() )
	    {
	    Acme.Pair pair = (Acme.Pair) en.nextElement();
	    Acme.HtmlObserver observer = (HtmlObserver) pair.left();
	    Object clientData = pair.right();
	    observer.gotIMGSRC( urlStr, contextUrl, clientData );
	    }
	}

    private void callFRAMESRC( String urlStr )
	{
	Enumeration en = observers.elements();
	while ( en.hasMoreElements() )
	    {
	    Acme.Pair pair = (Acme.Pair) en.nextElement();
	    Acme.HtmlObserver observer = (HtmlObserver) pair.left();
	    Object clientData = pair.right();
	    observer.gotFRAMESRC( urlStr, contextUrl, clientData );
	    }
	}

    private void callBASEHREF( String urlStr )
	{
	Enumeration en = observers.elements();
	while ( en.hasMoreElements() )
	    {
	    Acme.Pair pair = (Acme.Pair) en.nextElement();
	    Acme.HtmlObserver observer = (HtmlObserver) pair.left();
	    Object clientData = pair.right();
	    observer.gotBASEHREF( urlStr, contextUrl, clientData );
	    }
	}

    private void callAREAHREF( String urlStr )
	{
	Enumeration en = observers.elements();
	while ( en.hasMoreElements() )
	    {
	    Acme.Pair pair = (Acme.Pair) en.nextElement();
	    Acme.HtmlObserver observer = (HtmlObserver) pair.left();
	    Object clientData = pair.right();
	    observer.gotAREAHREF( urlStr, contextUrl, clientData );
	    }
	}

    private void callLINKHREF( String urlStr )
	{
	Enumeration en = observers.elements();
	while ( en.hasMoreElements() )
	    {
	    Acme.Pair pair = (Acme.Pair) en.nextElement();
	    Acme.HtmlObserver observer = (HtmlObserver) pair.left();
	    Object clientData = pair.right();
	    observer.gotLINKHREF( urlStr, contextUrl, clientData );
	    }
	}

    private void callBODYBACKGROUND( String urlStr )
	{
	Enumeration en = observers.elements();
	while ( en.hasMoreElements() )
	    {
	    Acme.Pair pair = (Acme.Pair) en.nextElement();
	    Acme.HtmlObserver observer = (HtmlObserver) pair.left();
	    Object clientData = pair.right();
	    observer.gotBODYBACKGROUND( urlStr, contextUrl, clientData );
	    }
	}

    /// Can be used to change the scan buffer in the middle of a scan.
    // Black Magic!  Dangerous!  Be careful!  For use only by
    // HtmlEditScanner - any other use voids warranty.
    protected void substitute( int oldLen, String newStr )
	{
	int newLen = newStr.length();
	int d = newLen - oldLen;
	System.arraycopy(
	    interpBuf, interpIndex, interpBuf, interpIndex + d,
	    interpEnd - interpIndex );
	// newStr.getBytes( 0, newLen, interpBuf, interpIndex - oldLen );
	byte[] newBytes = newStr.getBytes();
	System.arraycopy(
	    newBytes, 0, interpBuf, interpIndex - oldLen, newLen );
	interpIndex += d;
	interpEnd += d;
	interpDelta += d;
	}

    }
