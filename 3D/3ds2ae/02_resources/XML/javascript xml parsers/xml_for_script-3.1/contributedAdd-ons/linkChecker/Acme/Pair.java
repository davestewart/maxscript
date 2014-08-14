// Pair - trivial Object-pair class
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

/// Trivial Object-pair class.
// <P>
// Sometimes you want to store a pair of values without going to the
// trouble of making a whole new special-purpose class.
// <P>
// <A HREF="/resources/classes/Acme/Pair.java">Fetch the software.</A><BR>
// <A HREF="/resources/classes/Acme.tar.gz">Fetch the entire Acme package.</A>

public class Pair extends Acme.GenericCloneable
    {

    private Object left, right;

    // Constructor.
    public Pair( Object left, Object right )
	{
	this.left = left;
	this.right = right;
	}

    /// Fetch the left object.
    public Object left()
	{
	return left;
	}

    /// Fetch the right object.
    public Object right()
	{
	return right;
	}
    
    /// Equality test.
    public boolean equals( Object o )
	{
	if ( o != null && o instanceof Pair )
	    {
	    Pair p = (Pair) o;
	    return this.left == p.left() && this.right == p.right();
	    }
	return false;
	}

    /// Compute a hash code for the pair.
    public int hashCode()
	{
	return left.hashCode() ^ right.hashCode();
	}
    
    // We'd like to implement a clone method that clones the left and
    // right Objects.  Unfortunately, Object.clone is a protected method
    // and we can't call it.  We have to settle for just copying the
    // references, and therefore we can use GenericCloneable.

    }
