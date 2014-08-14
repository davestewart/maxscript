// FlexVector - improved version of java.util.Vector
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
//
//
// Original copyright notice:
//
// @(#)Vector.java	1.29 95/12/01  
//
// Copyright (c) 1994 Sun Microsystems, Inc. All Rights Reserved.
//
// Permission to use, copy, modify, and distribute this software
// and its documentation for NON-COMMERCIAL purposes and without
// fee is hereby granted provided that this copyright notice
// appears in all copies. Please refer to the file "copyright.html"
// for further important copyright and licensing information.
//
// SUN MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT THE SUITABILITY OF
// THE SOFTWARE, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
// TO THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
// PARTICULAR PURPOSE, OR NON-INFRINGEMENT. SUN SHALL NOT BE LIABLE FOR
// ANY DAMAGES SUFFERED BY LICENSEE AS A RESULT OF USING, MODIFYING OR
// DISTRIBUTING THIS SOFTWARE OR ITS DERIVATIVES.

package Acme;

import java.util.*;

/// Improved version of java.util.Vector.
// <P>
// Usage is identical to java.util.Vector.  The changes are all internal.
// So far the only change is that removing elements from the beginning
// of the vector is handled much more efficiently.
// <P>
// Note that this can't be a subclass of Vector because Vector is full
// of final methods, which can't be overridden.
// <P>
// <A HREF="/resources/classes/Acme/FlexVector.java">Fetch the software.</A><BR>
// <A HREF="/resources/classes/Acme.tar.gz">Fetch the entire Acme package.</A>

public class FlexVector implements Cloneable
    {

    /// The buffer where elements are stored.
    /*private*/ protected Object elementData[];

    /// The number of elements in the buffer.
    /*private*/ protected int elementCount;

    /// The offset for the first element.
    /*private*/ protected int elementOffset;

    /// The size of the increment. If it is 0 the size of the
    // the buffer is doubled everytime it needs to grow.
    /*private*/ protected int capacityIncrement;

    /// Constructs an empty vector with the specified storage
    // capacity and the specified capacityIncrement.
    // @param initialCapacity the initial storage capacity of the vector
    // @param capacityIncrement how much to increase the element's 
    // size by.
    public FlexVector( int initialCapacity, int capacityIncrement )
	{
	elementData = new Object[initialCapacity];
	elementCount = 0;
	elementOffset = 0;
	this.capacityIncrement = capacityIncrement;
	}

    /// Constructs an empty vector with the specified storage capacity.
    // @param initialCapacity the initial storage capacity of the vector
    public FlexVector( int initialCapacity )
	{
	this( initialCapacity, 0 );
	}

    /// Constructs an empty vector.
    public FlexVector()
	{
	this( 10 );
	}


    /// Copies the elements of this vector into the specified array.
    // @param anArray the array where elements get copied into
    public final synchronized void copyInto( Object anArray[] )
	{
	for ( int i = 0; i < elementCount; ++i )
	    anArray[i] = elementData[elementOffset + i];
	}

    /// Trims the vector's capacity down to size. Use this operation to
    // minimize the storage of a vector. Subsequent insertions will
    // cause reallocation.
    public final synchronized void trimToSize()
	{
	int oldCapacity = elementData.length;
	if ( elementCount < oldCapacity )
	    {
	    Object oldData[] = elementData;
	    elementData = new Object[elementCount];
	    System.arraycopy(
		oldData, elementOffset, elementData, 0, elementCount );
	    elementOffset = 0;
	    }
	}

    /// Ensures that the vector has at least the specified capacity.
    // @param minCapacity the desired minimum capacity
    public final synchronized void ensureCapacity( int minCapacity )
	{
	int oldTotalCapacity = elementData.length;
	int oldUsableCapacity = oldTotalCapacity - elementOffset;
	if ( oldUsableCapacity < minCapacity )
	    {
	    if ( oldTotalCapacity >= minCapacity )
		{
		// Don't have to make a new object, we can just compactify.
		System.arraycopy(
		    elementData, elementOffset, elementData, 0, elementCount );
		for ( int i = elementCount;
		      i < elementCount + elementOffset; ++i )
		    elementData[i] = null;
		}
	    else
		{
		Object oldData[] = elementData;
		int newCapacity = ( capacityIncrement > 0 ) ?
		    ( oldTotalCapacity + capacityIncrement ) :
		    ( oldTotalCapacity * 2 );
		if ( newCapacity < minCapacity )
		    newCapacity = minCapacity;
		elementData = new Object[newCapacity];
		System.arraycopy(
		    oldData, elementOffset, elementData, 0, elementCount );
		}
	    elementOffset = 0;
	    }
	}

    /// Sets the size of the vector. If the size shrinks, the extra elements
    // (at the end of the vector) are lost; if the size increases, the
    // new elements are set to null.
    // @param newSize the new size of the vector
    public final synchronized void setSize( int newSize )
	{
	if ( newSize > elementCount )
	    ensureCapacity( newSize );
	else
	    for ( int i = newSize ; i < elementCount ; ++i )
		elementData[elementOffset + i] = null;
	elementCount = newSize;
	if ( elementCount == 0 )
	    elementOffset = 0;
	}

    /// Returns the current capacity of the vector.
    public final int capacity()
	{
	return elementData.length;
	}

    /// Returns the number of elements in the vector.
    // Note that this is not the same as the vector's capacity.
    public final int size()
	{
	return elementCount;
	}

    /// Returns true if the collection contains no values.
    public final boolean isEmpty()
	{
	return elementCount == 0;
	}

    /// Returns an enumeration of the elements. Use the Enumeration methods on
    // the returned object to fetch the elements sequentially.
    public final synchronized Enumeration elements()
	{
	return new FlexVectorEnumerator( this );
	}
    
    /// Returns true if the specified object is a value of the collection.
    // @param elem the desired element
    public final boolean contains( Object elem )
	{
	return indexOf( elem, 0 ) >= 0;
	}

    /// Searches for the specified object, starting from the first position
    // and returns an index to it.
    // @param elem the desired element
    // @return the index of the element, or -1 if it was not found.
    public final int indexOf( Object elem )
	{
	return indexOf( elem, 0 );
	}

    /// Searches for the specified object, starting at the specified 
    // position and returns an index to it.
    // @param elem the desired element
    // @param index the index where to start searching
    // @return the index of the element, or -1 if it was not found.
    public final synchronized int indexOf( Object elem, int index )
	{
	for ( int i = index ; i < elementCount ; ++i )
	    if ( elem.equals( elementData[elementOffset + i] ) )
		return i;
	return -1;
	}

    /// Searches backwards for the specified object, starting from the last
    // position and returns an index to it. 
    // @param elem the desired element
    // @return the index of the element, or -1 if it was not found.
    public final int lastIndexOf( Object elem )
	{
	return lastIndexOf( elem, elementCount );
	}

    /// Searches backwards for the specified object, starting from the specified
    // position and returns an index to it. 
    // @param elem the desired element
    // @param index the index where to start searching
    // @return the index of the element, or -1 if it was not found.
    public final synchronized int lastIndexOf( Object elem, int index )
	{
	for ( int i = index ; --i >= 0 ; )
	    if ( elem.equals( elementData[elementOffset + i] ) )
		return i;
	return -1;
	}

    /// Returns the element at the specified index.
    // @param index the index of the desired element
    // @exception ArrayIndexOutOfBoundsException If an invalid 
    // index was given.
    public final synchronized Object elementAt( int index )
	{
	if ( index >= elementCount )
	    throw new ArrayIndexOutOfBoundsException(
		index + " >= " + elementCount );
	// Since try/catch is free, except when the exception is thrown,
	// put in this extra try/catch to catch negative indexes and
	// display a more informative error message.  This might not
	// be appropriate, especially if we have a decent debugging
	// environment - JPayne.
	try
	    {
	    return elementData[elementOffset + index];
	    }
	catch ( ArrayIndexOutOfBoundsException e )
	    {
	    throw new ArrayIndexOutOfBoundsException( index + " < 0" );
	    }
	}

    /// Returns the first element of the sequence.
    // @exception NoSuchElementException If the sequence is empty.
    public final synchronized Object firstElement()
	{
	if ( elementCount == 0 )
	    throw new NoSuchElementException();
	return elementData[elementOffset];
	}

    /// Returns the last element of the sequence.
    // @exception NoSuchElementException If the sequence is empty.
    public final synchronized Object lastElement()
	{
	if ( elementCount == 0 )
	    throw new NoSuchElementException();
	return elementData[elementOffset + elementCount - 1];
	}

    /// Sets the element at the specified index to be the specified object.
    // The previous element at that position is discarded.
    // @param obj what the element is to be set to
    // @param index the specified index
    // @exception ArrayIndexOutOfBoundsException If the index was invalid.
    public final synchronized void setElementAt( Object obj, int index )
	{
	if ( index >= elementCount )
	    throw new ArrayIndexOutOfBoundsException(
		index + " >= " + elementCount );
	elementData[elementOffset + index] = obj;
	}

    /// Deletes the element at the specified index. Elements with an index
    // greater than the current index are moved down.
    // @param index the element to remove
    // @exception ArrayIndexOutOfBoundsException If the index was invalid.
    public final synchronized void removeElementAt( int index )
	{
	if ( index == 0 )
	    {
	    // Special case for removing the first element.
	    elementData[elementOffset] = null;			// for gc
	    ++elementOffset;
	    --elementCount;
	    }
	else
	    {
	    if ( index >= elementCount )
		throw new ArrayIndexOutOfBoundsException(
		    index + " >= " + elementCount );
	    int j = elementCount - index - 1;
	    if ( j > 0 )
		System.arraycopy(
		    elementData, elementOffset + index + 1,
		    elementData, elementOffset + index, j );
	    --elementCount;
	    elementData[elementOffset + elementCount] = null;	// for gc
	    if ( elementCount == 0 )
		elementOffset = 0;
	    }
	}

    /// Inserts the specified object as an element at the specified index.
    // Elements with an index greater or equal to the current index 
    // are shifted up.
    // @param obj the element to insert
    // @param index where to insert the new element
    // @exception ArrayIndexOutOfBoundsException If the index was invalid.
    public final synchronized void insertElementAt( Object obj, int index )
	{
	if ( index >= elementCount + 1 )
	    throw new ArrayIndexOutOfBoundsException(
		index + " >= " + elementCount + 1);
	if ( index == 0 && elementOffset > 0 )
	    {
	    // Special case for inserting at the beginning.
	    --elementOffset;
	    elementData[elementOffset] = obj;
	    }
	else
	    {
	    ensureCapacity( elementCount + 1 );
	    System.arraycopy(
		elementData, elementOffset + index,
		elementData, elementOffset + index + 1, elementCount - index );
	    elementData[elementOffset + index] = obj;
	    }
	++elementCount;
	}

    /// Adds the specified object as the last element of the vector.
    // @param obj the element to be added
    public final synchronized void addElement( Object obj )
	{
	ensureCapacity( elementCount + 1 );
	elementData[elementOffset +  elementCount] = obj;
	++elementCount;
	}

    /// Removes the element from the vector. If the object occurs more
    // than once, only the first is removed. If the object is not an
    // element, returns false.
    // @param obj the element to be removed
    // @return true if the element was actually removed; false otherwise.
    public final synchronized boolean removeElement( Object obj )
	{
	int i = indexOf( obj );
	if ( i == -1 )
	    return false;
	removeElementAt( i );
	return true;
	}

    /// Removes all elements of the vector. The vector becomes empty.
    public final synchronized void removeAllElements()
	{
	for ( int i = 0; i < elementCount; ++i )
	    elementData[elementOffset + i] = null;
	elementCount = 0;
	elementOffset = 0;
	}

    /// Clones this vector. The elements are <strong>not</strong> cloned.
    public synchronized Object clone()
	{
	try
	    { 
	    FlexVector fv = (FlexVector) super.clone();
	    fv.elementData = new Object[elementCount];
	    fv.elementOffset = 0;
	    System.arraycopy(
		elementData, elementOffset, fv.elementData, 0, elementCount );
	    return fv;
	    }
	catch ( CloneNotSupportedException e )
	    {
	    // This shouldn't happen, since we are Cloneable.
	    throw new InternalError();
	    }
	}

    /// Converts the vector to a string. Useful for debugging.
    public final synchronized String toString()
	{
	int max = size() - 1;
	StringBuffer buf = new StringBuffer();
	Enumeration e = elements();
	buf.append( "[" );

	for ( int i = 0 ; i <= max ; ++i )
	    {
	    String s = e.nextElement().toString();
	    buf.append( s );
	    if ( i < max )
		buf.append( ", " );
	    }
	buf.append( "]" );
	return buf.toString();
	}
    }

final class FlexVectorEnumerator implements Enumeration
    {
    FlexVector flexvector;
    int count;

    FlexVectorEnumerator( FlexVector fv )
	{
	flexvector = fv;
	count = 0;
	}

    public boolean hasMoreElements()
	{
	return count < flexvector.size();
	}

    public Object nextElement()
	{
	synchronized ( flexvector )
	    {
	    if ( count < flexvector.size() )
		return flexvector.elementAt( count++ );
	    }
	throw new NoSuchElementException( "FlexVectorEnumerator" );
	}
    }
