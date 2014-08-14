// =========================================================================
//
// LinkChecker.java - A tool to test that all links are valid in a web site
//
// version 3.1
//
// =========================================================================
//
// Copyright (C) 2003 David Joham (djoham@yahoo.com)
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.

// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.

// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//
// Visit the XML for <SCRIPT> home page at http://xmljs.sourceforge.net
//
// This tools uses the Acme.Spider Enumeration class available at
// http://www.acme.com/java/software/Acme.Spider.html
//
// NOTE: The Spider class has been slightly modified to output *all* results
//       to stdout rather than having error messages go to stderror. This makes
//       it easier to pipe the results of the utility to a file
//

import java.net.URL;
import java.net.URLConnection;
import java.util.Enumeration;
import java.io.*;
import Acme.*;

public class LinkChecker {

	public static void main(String args[]) {
		if (args.length > 0) {
        	String URL = args[0];
            LinkChecker linkChecker = new LinkChecker();
            linkChecker.doTest(URL);
        }
        else {
            System.out.println();
            System.out.println();
            System.out.println();
            System.out.println("usage:\n$java LinkChecker <URL to start test> ");
            System.out.println("If you are on a local file system, don't forget");
            System.out.println("to add the file:// protocol in front of your file name.");
            System.out.println();
            System.out.println("For example: java LinkChecker file:///home/user/html/test.html");
            System.out.println();
            System.out.println();
            System.out.println();
        }
    }

    private void doTest(String testURL) {
        //write the "starting test headers"
        System.err.println();
        System.err.println("Starting Test");

        URL thisURL = null;
		try {
	 		Enumeration spider = new Acme.Spider( testURL );
            while ( spider.hasMoreElements() ) {
                System.err.print(".");
                URLConnection conn = (URLConnection) spider.nextElement();
				if (conn == null) {
					//this catches things like 403's on directories and such
					//we don't care about these errors so just continue
					continue;
				}
                thisURL = conn.getURL();
                System.out.println("Testing: " + thisURL.getFile());
                try {
                    InputStream is = conn.getInputStream();
                    is.close();
                }
                catch ( IOException e ) {
					//write a new line to the console and then an error message
		            System.err.println();
					System.err.println("LinkChecker has detected a broken link!");
                }

            }
		}
		catch (Exception e) {
			//no op. The Spider class already spits out an error to stdout
		}

		//we are finished. Write a success message
		System.err.println();
		System.out.println("Test concluded");
    }

}
