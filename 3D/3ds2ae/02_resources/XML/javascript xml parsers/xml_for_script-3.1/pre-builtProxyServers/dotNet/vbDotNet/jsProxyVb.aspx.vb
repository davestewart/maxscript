' =========================================================================
'
' jsProxy.vb - Visual Basic.NET reference implementation for xmljsProxy
'
' version 3.1
'
' =========================================================================
'
' Copyright (C) 2003 Brent Brown (elitusprime@yahoo.com)
'
' This library is free software; you can redistribute it and/or
' modify it under the terms of the GNU Lesser General Public
' License as published by the Free Software Foundation; either
' version 2.1 of the License, or (at your option) any later version.

' This library is distributed in the hope that it will be useful,
' but WITHOUT ANY WARRANTY; without even the implied warranty of
' MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
' Lesser General Public License for more details.

' You should have received a copy of the GNU Lesser General Public
' License along with this library; if not, write to the Free Software
' Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
'
' Visit the XML for <SCRIPT> home page at http://xmljs.sourceforge.net
'

Imports System.Web.UI
Imports System.Net
Imports System.IO

Public Class jsProxyVb
    Inherits Page

    Private errorString As New String(Nothing)

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        Dim resourceURLs(3) As String
        Dim serverAuthenticationCode As New String("authentication code not set")

        'Uncomment out the following line if you would like to run this proxy through the test suite
        'Dim serverAuthenticationCode As New String("password")

        Dim resourceIDString As New String(Request.Params("resourceID"))
        Dim guid As New String(Request.Params("guid"))
        Dim callbackFunction As New String(Request.Params("callbackFunction"))
        Dim clientAuthenticationCode As New String(Request.Params("authenticationCode"))
        Dim okToProxy As Boolean = True

        '*********************************************************************
        '                TEST SUITE VARIABLES - uncomment if you
        '					want to run this proxy through
        '							the test suite
        '
        'resourceURLs(0) = "http://xmljs.sourceforge.net/testSuites/proxyTest/remoteXML.xml" 'will return the file
        'resourceURLs(1) = "http://xmljs.sourceforge.net/tools/xmlIOProxy/idontexist.xml"    'will return a 404
        'resourceURLs(2) = "http://unknown.host.exception"                                   'will return unknown host
        '*********************************************************************

        '*****************************************************************
        '			EXAMPLES of RSS News Feeds
        'resourceURLs[0] = "http://rss.com.com/2547-12-0-5.xml"; //news.com
        'resourceURLs[1] = "http://slashdot.org/slashdot.rdf"; //slashdot
        'resourceURLs[2] = "http://www.kde.org/dotkdeorg.rdf"; //KDE News
        '*****************************************************************

        '*****************************************************************
        '           AUTHENTICATION - ensures the proxy can't be used without knowing the
        '                 authentication code. For full security, use the proxy with SSL
        '                 security turned on.
        '
        '	        NOTE! The proxy WILL NOT WORK if the authentication
        '                 code is left unchanged
        '
        '           NOTE! The serverAuthenticationCode cannot contain spaces
        '                 unless you want to manually URL Encode the spaces
        '                 when you call the proxy through the xmlIOLoadXML functions
        '*****************************************************************

        Response.ContentType = "text/html"

        If (IsNothing(resourceIDString)) Or (resourceIDString.Equals("")) Then
            okToProxy = False
            resourceIDString = New String("-1")
            errorString = "The required parameter 'resourceID' was not found."
        End If

        If (IsNothing(guid)) Or (guid.Equals("")) Then
            okToProxy = False
            errorString = "The required parameter 'guid' was not found."
        End If

        If (IsNothing(callbackFunction)) Or (callbackFunction.Equals("")) Then
            okToProxy = False
            errorString = "The required parameter 'callbackFunction' was not found."
        End If

        If (IsNothing(clientAuthenticationCode)) Or (clientAuthenticationCode.Equals("")) Then
            okToProxy = False
            errorString = "The required parameter 'authenticationCode' was not found."
        End If

        'check for okToProxy here because if the clientAuthenticationCode is null or "", the following will be caught as well and we don't want it to
        If (okToProxy = True) And (Not clientAuthenticationCode.Equals(serverAuthenticationCode)) Then
            okToProxy = False
            errorString = "Authentication failure."
        End If

        'check for okToProxy here because if the resourceIDString is null, the following will throw an exception which we don't want
        If ((okToProxy = True) And (CInt(resourceIDString) > resourceURLs.Length - 1 Or CInt(resourceIDString) < 0)) Then
            okToProxy = False
            errorString = "The resourceID passed in was not valid."
        End If

        If serverAuthenticationCode.Equals("authentication code not set") Then
            okToProxy = False
            errorString = "The authentication code on the proxy has not been set. The proxy can not function until the authentication code is set."
        End If

        'make sure we have all the params we need and that the resourceID exists in our list
        If okToProxy = True Then

            Dim url As New String(resourceURLs(CInt(resourceIDString)))
            Dim line As New String(Nothing)
            Dim ret As New String("")
            Dim okRead As Boolean = True
            Dim Req As WebRequest = WebRequest.Create(url)
            Dim Resp As WebResponse
            Dim netStream As StreamReader

            Try
                Resp = Req.GetResponse
                netStream = New StreamReader(Resp.GetResponseStream)
                Do
                    line = netStream.ReadLine()
                    If Not IsNothing(line) Then
                        ret += line & vbCrLf
                    End If
                Loop While (IsNothing(line) = False)
            Catch exc As Exception
                okRead = False
                errorString = New String("The requested URL (" & url & ") was not found.")
            End Try

            If okRead = True Then
                'change the HTML into something the browser cannot parse into a DOM tree. The makes 
                'the client side rendering faster as well as helps to avoid any potential for abuse
                ret = ret.Replace("<", "«")  'String.charAt(171)
                ret = ret.Replace(">", "»")  'String.charAt(187)
                ret = ret.Replace("&", "§")  'String.charAt(167)
                writeBeginningHTML(guid, callbackFunction, "success")
                Response.Write(ret)
            Else
                'this is probably a 404 or timeout error
                writeBeginningHTML(guid, callbackFunction, "error")
                Response.Write(errorString)
            End If

            writeEndHTML()

        Else
            'Something went wrong before we could even proxy. Write an error
            Dim errCallbackFunction As String
            Dim errGuid As String
            If callbackFunction.Equals("") Then
                errCallbackFunction = "unknown"
            Else
                errCallbackFunction = callbackFunction
            End If

            If guid.Equals("") Then
                errGuid = "unknown"
            Else
                errGuid = guid
            End If

            writeBeginningHTML(errGuid, errCallbackFunction, "error")

            'write the error string
            Response.Write(errorString)

            'end the HTML
            writeEndHTML()
        End If

    End Sub

    Private Sub writeBeginningHTML(ByVal guid As String, ByVal callBackFunction As String, ByVal returnCode As String)
        Response.Write("<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01//EN"" ""http://www.w3.org/TR/html4/strict.dtd"">" & vbCrLf)
        Response.Write("<head>" & vbCrLf)
        Response.Write("<title>" & vbCrLf)
        Response.Write("Proxy Data" & vbCrLf)
        Response.Write("</title>" & vbCrLf)
        Response.Write("<meta HTTP-EQUIV=""Content-Type"" CONTENT=""text/html; charset=UTF-8"">" & vbCrLf)
        Response.Write("</head>" & vbCrLf)
        Response.Write("<body onload=""top.__getXMLFromIFrame('" & guid & "', '" & callBackFunction & "', '" & returnCode & "', document.getElementById('xmlData').value)"">" & vbCrLf)
        'Response.Write("<body onload=""alert(document.getElementById('xmlData').value)"">" & vbCrLf)
        Response.Write("<div style=""position: absolute; left: -2000px;"">" & vbCrLf)
        Response.Write("<textarea id=""xmlData"" rows=""1"" cols=""1"">" & vbCrLf)
    End Sub


    Private Sub writeEndHTML()
        Response.Write("</textarea>" & vbCrLf)
        Response.Write("</div>" & vbCrLf)
        Response.Write("</body>" & vbCrLf)
        Response.Write("</html>" & vbCrLf)
    End Sub


End Class

