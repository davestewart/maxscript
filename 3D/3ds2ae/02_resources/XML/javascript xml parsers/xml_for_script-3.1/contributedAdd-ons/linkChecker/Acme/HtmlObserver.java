// HtmlObserver - callback interface for HtmlScanner
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

/// Callback interface for HtmlScanner.
// <P>
// Clients of HtmlScanner implement this in order to get URLs passed back
// to them.
// <P>
// <A HREF="/resources/classes/Acme/HtmlObserver.java">Fetch the software.</A><BR>
// <A HREF="/resources/classes/Acme.tar.gz">Fetch the entire Acme package.</A>
// <P>
// @see HtmlScanner

public interface HtmlObserver
    {

    /// This gets called when the scanner finds an &lt;A HREF=""&gt; URL.
    public void gotAHREF( String urlStr, URL contextUrl, Object clientData );

    /// This gets called when the scanner finds an &lt;IMG SRC=""&gt; URL.
    public void gotIMGSRC( String urlStr, URL contextUrl, Object clientData );

    /// This gets called when the scanner finds an &lt;FRAME SRC=""&gt; URL.
    public void gotFRAMESRC( String urlStr, URL contextUrl, Object clientData );

    /// This gets called when the scanner finds a &lt;BASE HREF=""&gt; URL.
    public void gotBASEHREF( String urlStr, URL contextUrl, Object clientData );

    /// This gets called when the scanner finds a &lt;AREA HREF=""&gt; URL.
    public void gotAREAHREF( String urlStr, URL contextUrl, Object clientData );

    /// This gets called when the scanner finds a &lt;LINK HREF=""&gt; URL.
    public void gotLINKHREF( String urlStr, URL contextUrl, Object clientData );

    /// This gets called when the scanner finds a &lt;BODY BACKGROUND=""&gt; URL.
    public void gotBODYBACKGROUND( String urlStr, URL contextUrl, Object clientData );

    }
