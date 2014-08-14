#!/usr/bin/perl
## =========================================================================
##
## perlProxy.pl - mod_perl reference implementation for xmljsProxy
##
##	Version 3.1
##
## =========================================================================
##
## Copyright (C) 2003 Brandon Zehm (caspian@dotconf.net) and David Joham (djoham@yahoo.com)
##
## This library is free software; you can redistribute it and/or
## modify it under the terms of the GNU Lesser General Public
## License as published by the Free Software Foundation; either
## version 2.1 of the License, or (at your option) any later version.

## This library is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## Lesser General Public License for more details.

## You should have received a copy of the GNU Lesser General Public
## License along with this library; if not, write to the Free Software
## Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

## visit the XML for <SCRIPT> website at http://xmljs.sourceforge.net

use strict;
use IO::Socket;
my $CRLF = "\r\n";
my $socket;
$| = 1;


####################################################################
##  function:   doGet
##
##  Author: caspian@dotconf.net
##
##  Description:
##  This function goes out to the net and downloads the requested URL, and returns the data back to the client.
####################################################################
sub doGet () {

    ## Get variables from the GET request
    my %query = ();
    my $query = $ENV{'QUERY_STRING'};
    foreach (split(/[&;]/,$query)) {
        (my $key, my $val) = split(/=/, $_);
        $key =~ s/%(..)/pack("c",hex($1))/ge;
        $val =~ s/%(..)/pack("c",hex($1))/ge;
        $query{$key} = $val if ($key);
    }



    ##*********************************************************************
    ##  RESOURCES - this ties resourceID's to URLS
    ##  put your own resources here and replace the ones listed
    ##*********************************************************************
    my @resourceURLs = ();

    ##*********************************************************************
    ##                TEST SUITE VARIABLES - uncomment if you
    ##					want to run this proxy through
    ##							the test suite
	##
    ##	$resourceURLs[0] = "http://xmljs.sourceforge.net/testSuites/proxyTest/remoteXML.xml";  ##will return the file
    ##	$resourceURLs[1] = "http://xmljs.sourceforge.net/tools/xmlIOProxy/idontexist.xml";     ##will return a 404
    ##	$resourceURLs[2] = "http://unknown.host.exception";    ##will return unknown host
    ##*********************************************************************


    ##*********************************************************************
    ##                EXAMPLES of RSS News Feeds
    ##  $resourceURLs[0] = "http://rss.com.com/2547-12-0-5.xml"; ##news.com
    ##  $resourceURLs[1] = "http://slashdot.org/slashdot.rdf"; ##slashdot
    ##  $resourceURLs[2] = "http://www.kde.org/dotkdeorg.rdf"; ##KDE News
    ##*********************************************************************



    ##*********************************************************************************
    ##  AUTHENTICATION - ensures the proxy can't be used without knowing the
    ##                   authentication code. For full security, use the proxy with SSL
    ##                   security turned on.
    ##
    ##            NOTE! The proxy WILL NOT WORK if the authentication
    ##                  code is left unchanged
    ##
    ##            NOTE! The serverAuthenticationCode cannot contain spaces
    ##                  unless you want to manually URL Encode the spaces
    ##                  when you call the proxy through the xmlIOLoadXML functions
    ##
    ##*********************************************************************************

	my $serverAuthenticationCode = "authentication code not set";

    # Uncomment the following line if you would like to run this proxy through the test suite
    #my $serverAuthenticationCode = "password";



    #####################################################################
    ##  If this script needs to know about a proxy server to see the
    ##  internet, uncomment out the following lines, set the parameters
    ##  as appropriate
    #####################################################################
    my $proxy = "";
    my $proxyport = "";
    ## $proxy = "myProxyServer.com";
    ## $proxyport = "myProxyPort";

    ## Check to see if we're a go for proxying
    my $okToProxy = 1;
    my $errorString = "";

    if ($query{'resourceID'} eq "") {
        $okToProxy = 0;
        $errorString = "The required parameter 'resourceID' was not found.";
    }

    elsif (!$query{'guid'}) {
        $okToProxy = 0;
        $errorString = "The required parameter 'guid' was not found.";
    }

    elsif (!$query{'callbackFunction'}) {
        $okToProxy = 0;
        $errorString = "The required parameter 'callbackFunction' was not found.";
    }

    elsif (!$query{'authenticationCode'}) {
        $okToProxy = 0;
        $errorString = "The required parameter 'authenticationCode' was not found.";
    }

    elsif ($query{'authenticationCode'} ne $serverAuthenticationCode) {
        $okToProxy = 0;
        $errorString = "Authentication failure.";
    }

    elsif (!(($query{'resourceID'} >= 0) and ($query{'resourceID'} < (scalar(@resourceURLs))) and ($resourceURLs[$query{'resourceID'}])) ) {
        $okToProxy = 0;
        $errorString = "The resourceID passed in was not valid.";
    }

    elsif ($serverAuthenticationCode eq "authentication code not set") {
        $okToProxy = 0;
        $errorString = "The authentication code on the proxy has not been set. The proxy can not function until the authentication code is set.";
    }

    ## Make sure we have all the params we need and that the resourceID exists in our list
    if ($okToProxy) {
        my $url = $resourceURLs[$query{'resourceID'}];
        my $server = "";
        my $serverName = "";
        my $port = "";
        my $ret;
        my $okRead = 1;

        ## Break URL into server/port/file
        $url =~ s/^http:\/\///;
        while ( ($url =~ s/^.//) and ($& ne "/") ) {
          $server .= $&;
        }
        $url = "/" . $url;

        if ($server =~ /\:/) {
          ($server, $port) = split(":", $server);
        }
        else {
            $port = 80;
        }
        $serverName = $server;

        ## Use proxy server if defined
        $server = $proxy if ($proxy);
        $port = $proxyport if ($proxyport);

        ## Connect to webserver
        $socket = IO::Socket::INET->new(        PeerAddr  => $server,
                                                PeerPort  => $port,
                                                Proto     => 'tcp',
                                                Autoflush => 1,
                                                Blocking  => 1,
        ) or $errorString = "Connection to $server:$port failed.  Error was: $!";


        ## Request the page we want
        $ret = getPage($serverName, $url) unless ($errorString);

        ## Disconnect from webserver
        $socket->close() or $errorString = "Disconnecting from $server:$port failed.  Error was: $!" unless ($errorString);


        ## Display this error if anything goes wrong
        if ( !$ret or $errorString) {
            $errorString = "The requested URL ($resourceURLs[$query{'resourceID'}]) was not found.";
            writeBeginningHTML($query{'guid'}, $query{'callbackFunction'}, "error");
            print($errorString . "\n");
        }
		else {
            ##change the HTML into something the browser cannot parse into a DOM tree. The makes
            ##the client side rendering faster as well as helps to avoid any potential for abuse
            $ret =~ s/\</\«/g; ##String.charAt(171)
            $ret =~ s/\>/\»/g; ##String.charAt(187)
            $ret =~ s/\&/\§/g; ##String.charAt(167)
            writeBeginningHTML($query{'guid'}, $query{'callbackFunction'}, "success");
            print($ret);
        }

        writeEndHTML();

    }
    else {

        ## Something went wrong before we could even proxy. Write an error.
        my $errCallbackFunction;
        my $errGuid;
        if (!$query{'callbackFunction'}) {
            $errCallbackFunction = "unknown";
        }
        else {
            $errCallbackFunction = $query{'callbackFunction'};
        }

        if (!$query{'guid'}) {
            $errGuid = "unknown";
        }
        else {
            $errGuid = $query{'guid'};
        }

        writeBeginningHTML($errGuid, $errCallbackFunction, "error");

        ##write the error string
        print($errorString);

        ##end the HTML
        writeEndHTML();
    }


} ## end doGet


sub writeBeginningHTML () {
    (my $guid, my $callbackFunction, my $returnCode) = @_;
    print("Content-type: text/html\n\n");
    print("<!DOCTYPE HTML PUBLIC \"-\/\/W3C\/\/DTD HTML 4.01\/\/EN\" \"http:\/\/www.w3.org/TR/html4/strict.dtd\">\n");
    print("<head>\n");
    print("<title>\n");
    print("Proxy Data\n");
    print("</title>\n");
    print("<meta HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=UTF-8\">\n");
    print("</head>\n");
    print("<body onload=\"top.__getXMLFromIFrame('$guid', '$callbackFunction', '$returnCode', document.getElementById('xmlData').value)\">\n");
    print("<div style=\"position: absolute; left: -2000px;\">\n");
    print("<textarea id=\"xmlData\" rows=\"1\" cols=\"1\">\n");

} ## end writeBeginningHTML


sub writeEndHTML (){
    print("</textarea>\n");
    print("</div>\n");
    print("</body>\n");
    print("</html>\n");
}



######################################################################
## Function: getPage($socketRef, $server, $page)
##           $socketRef is a reference to the socket that's
##           already connected to a web server.
##
##           $server is the name of the webserver we're connected to
##
##           $page is a url, it should not contain http://
##           or www.blah.com, it shoul look like this:
##             /site/index.html?name=value&blah=test
##
##           Returns a string of lines retrieved
##           from the web server (i.e. the web page).
##
######################################################################
sub getPage {

    my %incoming = ();
    ## Get incoming variables
    (
        $incoming{'server'},
        $incoming{'page'},
    ) = @_;
    chomp $incoming{'page'};

    ## Generate Request
    my $tmp = "";

    $tmp =  "GET $incoming{'page'} HTTP/1.0$CRLF" .
                        "Accept: \*\/\*$CRLF" .
                        "Host: $incoming{'server'}$CRLF" .
                        "User-Agent: XML for SCRIPT Perl Proxy (Written by Brandon Zehm)$CRLF";
    $tmp .= "$CRLF";

    ## Request Page
    print $socket $tmp;

    ## Get page from server
    my @tmp = ();

    ## discard the HTML header - but put each line into $headers so we can check the response code
    $tmp[0] = 'blah';
    my $headers;
    until ($tmp[0] =~ /^[\r\n]+$/) {
        $headers .= $tmp[0];
        $tmp[0] = <$socket>;
    }

	#if there is a 404 in the headers, do not return the HTML returned
    #by the web server
    my $my404;
    if ( $headers =~ /404/g ) {
        return $my404;
    }


    @tmp = ();

    ## Get the rest of the data
    $tmp = "";
    while (<$socket>) {
        $tmp .= $_;
    }

    ## Return the data
    return($tmp);
}




## Run the program
doGet();
