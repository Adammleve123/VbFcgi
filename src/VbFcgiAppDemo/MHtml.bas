Attribute VB_Name = "MHtml"
Option Explicit

Public Function htmlMarkupPlaintext(ByVal p_PlainText As String) As String
   Dim la_Lines() As String
   Dim ii As Long
   Dim l_InUnorderedList As Boolean
   Dim l_InOrderedList As Boolean
   Dim l_Line As String
   
   ' ********** Start of procedure
   
   On Error GoTo ErrorHandler

   la_Lines = Split(p_PlainText, vbNewLine)
   
   For ii = LBound(la_Lines) To UBound(la_Lines)
      la_Lines(ii) = htmlEscape(la_Lines(ii))
      l_Line = la_Lines(ii)
      la_Lines(ii) = ""
      
      If Not stringIsEmptyOrWhitespaceOnly(l_Line) Then
         Select Case Left$(l_Line, 2)
         Case "* "
            ' Bullet list
            
            If l_InOrderedList Then
               l_InOrderedList = False
               
               la_Lines(ii) = "</ol><ul>"
            Else
               If Not l_InUnorderedList Then
                  l_InUnorderedList = True
                  la_Lines(ii) = "<ul>"
               End If
               
            End If
            
            la_Lines(ii) = la_Lines(ii) & vbNewLine & "<li>" & Mid$(l_Line, 3) & "</li>"
         
         Case "# "
            ' Ordered list
            If l_InUnorderedList Then
               l_InUnorderedList = False
               
               la_Lines(ii) = "</ul><ol>"
            Else
               If Not l_InOrderedList Then
                  l_InOrderedList = True
                  la_Lines(ii) = "<ol>"
               End If
            End If
            
            la_Lines(ii) = "<li>" & Mid$(l_Line, 3) & "</li>"
         
         Case Else
            ' Plain paragraph
            If l_InUnorderedList Then
               la_Lines(ii) = "</ul>"
            ElseIf l_InOrderedList Then
               la_Lines(ii) = "</ol>"
            End If
            
            l_InUnorderedList = False
            l_InOrderedList = False
            
            la_Lines(ii) = la_Lines(ii) & "<p>" & l_Line & "</p>"
            
         End Select
      End If
   Next ii
   
   
   htmlMarkupPlaintext = Join$(la_Lines, vbNewLine)

   If l_InOrderedList Then
      htmlMarkupPlaintext = htmlMarkupPlaintext & vbNewLine & "</ol>"
   ElseIf l_InUnorderedList Then
      htmlMarkupPlaintext = htmlMarkupPlaintext & vbNewLine & "</ul>"
   End If
   
   Exit Function

ErrorHandler:
   Debug.Assert False
   Err.Raise Err.Number, Err.Source, Err.Description
End Function

Public Function htmlEscape(p_UnescapedString As String) As String
   Dim l_InsertPos As Long
   Dim l_CopyFromPos As Long
   Dim l_CopyLen As Long
   Dim l_BufferLen As Long
   Dim ii As Long
   Dim l_Char As String
   Dim l_Replace As String
   Dim l_NeverReplaced As Boolean
   
   If LenB(Trim$(p_UnescapedString)) = 0 Then Exit Function

   l_NeverReplaced = True

   l_BufferLen = Len(p_UnescapedString) * 3
   If l_BufferLen < 256 Then
      l_BufferLen = 256
   End If
   htmlEscape = Space$(l_BufferLen)

   For ii = 1 To Len(p_UnescapedString)
      l_Char = Mid$(p_UnescapedString, ii, 1)
      
      Select Case l_Char
      Case "<"
         l_Replace = "&lt;"
      Case ">"
         l_Replace = "&gt;"
      Case "&"
         l_Replace = "&amp;"
      Case "'"
         l_Replace = "&apos;"
      Case """"
         l_Replace = "&quot;"
'      Case "�"
'         l_Replace = "&oacute;"
'      Case "�"
'         l_Replace = "&aacute;"
'      Case "�"
'         l_Replace = "&eacute;"
'      Case "�"
'         l_Replace = "&iacute;"
'      Case "�"
'         l_Replace = "&uacute;"
'      Case "�"
'         l_Replace = "&Aacute;"
'      Case "�"
'         l_Replace = "&Eacute;"
'      Case "�"
'         l_Replace = "&Iacute;"
'      Case "�"
'         l_Replace = "&Oacute;"
'      Case "�"
'         l_Replace = "&Uacute;"
'      Case "�"
'         l_Replace = "&iexcl;"
'      Case "�"
'         l_Replace = "&cent;"
'      Case "�"
'         l_Replace = "&pound;"
'      Case "�"
'         l_Replace = "&curren;"
'      Case "�"
'         l_Replace = "&yen;"
'      Case "�"
'         l_Replace = "&brvbar;"
'      Case "�"
'         l_Replace = "&sect;"
'      Case "�"
'         l_Replace = "&uml;"
'      Case "�"
'         l_Replace = "&copy;"
'      Case "�"
'         l_Replace = "&ordf;"
'      Case "�"
'         l_Replace = "&laquo;"
'      Case "�"
'         l_Replace = "&not;"
'      Case "�"
'         l_Replace = "&reg;"
'      Case "�"
'         l_Replace = "&macr;"
'      Case "�"
'         l_Replace = "&deg;"
'      Case "�"
'         l_Replace = "&plusmn;"
'      Case "�"
'         l_Replace = "&sup2;"
'      Case "�"
'         l_Replace = "&sup3;"
'      Case "�"
'         l_Replace = "&acute;"
'      Case "�"
'         l_Replace = "&micro;"
'      Case "�"
'         l_Replace = "&para;"
'      Case "�"
'         l_Replace = "&middot;"
'      Case "�"
'         l_Replace = "&cedil;"
'      Case "�"
'         l_Replace = "&sup1;"
'      Case "�"
'         l_Replace = "&ordm;"
'      Case "�"
'         l_Replace = "&raquo;"
'      Case "�"
'         l_Replace = "&frac14;"
'      Case "�"
'         l_Replace = "&frac12;"
'      Case "�"
'         l_Replace = "&frac34;"
'      Case "�"
'         l_Replace = "&iquest;"
'      Case "�"
'         l_Replace = "&times;"
'      Case "�"
'         l_Replace = "&divide;"
'      Case "�"
'         l_Replace = "&Agrave;"
'      Case "�"
'         l_Replace = "&Acirc;"
'      Case "�"
'         l_Replace = "&Atilde;"
'      Case "�"
'         l_Replace = "&Auml;"
'      Case "�"
'         l_Replace = "&Aring;"
'      Case "�"
'         l_Replace = "&AElig;"
'      Case "�"
'         l_Replace = "&Ccedil;"
'      Case "�"
'         l_Replace = "&Egrave;"
'      Case "�"
'         l_Replace = "&Ecirc;"
'      Case "�"
'         l_Replace = "&Euml;"
'      Case "�"
'         l_Replace = "&Igrave;"
'      Case "�"
'         l_Replace = "&Icirc;"
'      Case "�"
'         l_Replace = "&Iuml;"
'      Case "�"
'         l_Replace = "&ETH;"
'      Case "�"
'         l_Replace = "&Ntilde;"
'      Case "�"
'         l_Replace = "&Ograve;"
'      Case "�"
'         l_Replace = "&Ocirc;"
'      Case "�"
'         l_Replace = "&Otilde;"
'      Case "�"
'         l_Replace = "&Ouml;"
'      Case "�"
'         l_Replace = "&Oslash;"
'      Case "�"
'         l_Replace = "&Ugrave;"
'      Case "�"
'         l_Replace = "&Ucirc;"
'      Case "�"
'         l_Replace = "&Uuml;"
'      Case "�"
'         l_Replace = "&Yacute;"
'      Case "�"
'         l_Replace = "&THORN;"
'      Case "�"
'         l_Replace = "&szlig;"
'      Case "�"
'         l_Replace = "&agrave;"
'      Case "�"
'         l_Replace = "&acirc;"
'      Case "�"
'         l_Replace = "&atilde;"
'      Case "�"
'         l_Replace = "&auml;"
'      Case "�"
'         l_Replace = "&aring;"
'      Case "�"
'         l_Replace = "&aelig;"
'      Case "�"
'         l_Replace = "&ccedil;"
'      Case "�"
'         l_Replace = "&egrave;"
'      Case "�"
'         l_Replace = "&ecirc;"
'      Case "�"
'         l_Replace = "&euml;"
'      Case "�"
'         l_Replace = "&igrave;"
'      Case "�"
'         l_Replace = "&icirc;"
'      Case "�"
'         l_Replace = "&iuml;"
'      Case "�"
'         l_Replace = "&eth;"
'      Case "�"
'         l_Replace = "&ntilde;"
'      Case "�"
'         l_Replace = "&ograve;"
'      Case "�"
'         l_Replace = "&ocirc;"
'      Case "�"
'         l_Replace = "&otilde;"
'      Case "�"
'         l_Replace = "&ouml;"
'      Case "�"
'         l_Replace = "&oslash;"
'      Case "�"
'         l_Replace = "&ugrave;"
'      Case "�"
'         l_Replace = "&ucirc;"
'      Case "�"
'         l_Replace = "&uuml;"
'      Case "�"
'         l_Replace = "&yacute;"
'      Case "�"
'         l_Replace = "&thorn;"
'      Case "�"
'         l_Replace = "&yuml;"
      Case Else
         Select Case AscW(l_Char)
         Case &HA0
            ' Non-breaking space
            l_Replace = "&nbsp;"
         Case Is < 32
            ' Unprintable
            l_Replace = " "
         Case Else
            If l_Replace <> "" Or l_NeverReplaced Then
               l_CopyFromPos = ii
               l_NeverReplaced = False
               l_Replace = ""
            End If
         End Select
      End Select
   
      If Len(l_Replace) > 0 Then
         l_NeverReplaced = False
         
         CopyToBuffer htmlEscape, p_UnescapedString, l_Replace, l_InsertPos, l_BufferLen, l_CopyFromPos, ii
      End If
   Next ii

   If l_CopyFromPos > 0 Then
      CopyToBuffer htmlEscape, p_UnescapedString, "", l_InsertPos, l_BufferLen, l_CopyFromPos, ii
   End If
    
   htmlEscape = Left$(htmlEscape, l_InsertPos)
End Function

Private Sub CopyToBuffer(p_Buffer As String, p_FullSourceString As String, p_CopySourceString As String, p_ZeroBasedInsertPos As Long, p_BufferLen As Long, p_PreCopyFromPos As Long, ByVal p_CurrentPos As Long)
   Dim l_ReplaceLen As Long
   Dim l_CopyLen As Long

   On Error GoTo ErrorHandler

   If p_PreCopyFromPos > 0 Then
      l_CopyLen = p_CurrentPos - p_PreCopyFromPos

      If p_ZeroBasedInsertPos + l_CopyLen > p_BufferLen Then
         p_Buffer = p_Buffer & Space$(p_BufferLen)
         p_BufferLen = p_BufferLen + p_BufferLen
      End If

      Mid$(p_Buffer, p_ZeroBasedInsertPos + 1, l_CopyLen) = Mid$(p_FullSourceString, p_PreCopyFromPos, l_CopyLen)
      p_ZeroBasedInsertPos = p_ZeroBasedInsertPos + l_CopyLen

      p_PreCopyFromPos = 0
   End If

   l_ReplaceLen = Len(p_CopySourceString)
   If l_ReplaceLen > 0 Then
      If p_ZeroBasedInsertPos + l_ReplaceLen > p_BufferLen Then
         p_Buffer = p_Buffer & Space$(p_BufferLen)
         p_BufferLen = p_BufferLen + p_BufferLen
      End If

      Mid$(p_Buffer, p_ZeroBasedInsertPos + 1, l_ReplaceLen) = p_CopySourceString
      p_ZeroBasedInsertPos = p_ZeroBasedInsertPos + l_ReplaceLen
   End If

   Exit Sub

ErrorHandler:
   apiOutputDebugString "Error" & Err.Description & ", Line #" & Erl
End Sub

