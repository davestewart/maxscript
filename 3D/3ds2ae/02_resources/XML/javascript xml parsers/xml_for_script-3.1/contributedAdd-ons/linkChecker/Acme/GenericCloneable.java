// GenericCloneable - a convenience parent for Cloneable classes
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
import java.awt.*;
import java.awt.image.*;

/// A convenience parent for Cloneable classes.
// <P>
// In the current JDK, the API for cloning is slightly broken.  The intent
// was for classes that didn't need to clone any sub-objects to be able to
// just add an "implements Cloneable" and have everything work.  However,
// as it stands now, such classes still need to implement a clone method.
// <P>
// What's annoying is that all of these no-sub-objects clone methods are
// completely identical.  Every one of them looks like this:
// <BLOCKQUOTE><CODE><PRE>
// public Object clone()
//     {
//     try
//         {
//         return super.clone();
//         }
//     catch ( CloneNotSupportedException e )
//         {
//         // Shouldn't happen.
//         throw new InternalError( e.toString() );
//         }
//     }
// </PRE></CODE></BLOCKQUOTE>
// Well, what this class does is implement that clone method.  If your
// class doesn't need to have anything else as parent (true for "struct"
// classes), then just make GenericCloneable the parent and presto, you're
// cloneable.
// <P>
// <A HREF="/resources/classes/Acme/GenericCloneable.java">Fetch the software.</A><BR>
// <A HREF="/resources/classes/Acme.tar.gz">Fetch the entire Acme package.</A>

public class GenericCloneable implements Cloneable
    {
    public Object clone()
	{
	try
	    {
	    return super.clone();
	    }
	catch ( CloneNotSupportedException e )
	    {
	    // Shouldn't happen.
	    throw new InternalError( e.toString() );
	    }
	}
    }
