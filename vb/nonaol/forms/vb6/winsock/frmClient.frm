VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Begin VB.Form frmClient 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Client"
   ClientHeight    =   3780
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5895
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3780
   ScaleWidth      =   5895
   StartUpPosition =   2  'CenterScreen
   Begin MSWinsockLib.Winsock tcpClient 
      Left            =   5280
      Top             =   840
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.Frame Frame1 
      Height          =   3855
      Left            =   0
      TabIndex        =   0
      Top             =   -75
      Width           =   5895
      Begin VB.Frame Frame4 
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   500
         Left            =   60
         TabIndex        =   8
         Top             =   3250
         Width           =   5775
         Begin VB.CommandButton cmdSend 
            Caption         =   "Send"
            Enabled         =   0   'False
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   300
            Left            =   5000
            TabIndex        =   11
            Top             =   150
            Width           =   655
         End
         Begin VB.TextBox txtMessage 
            Enabled         =   0   'False
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   315
            Left            =   90
            TabIndex        =   10
            Top             =   140
            Width           =   4815
         End
      End
      Begin VB.Frame Frame3 
         Caption         =   "Chat"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   2610
         Left            =   60
         TabIndex        =   7
         Top             =   650
         Width           =   5775
         Begin VB.TextBox txtChat 
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   2275
            Left            =   90
            Locked          =   -1  'True
            MultiLine       =   -1  'True
            TabIndex        =   9
            Top             =   240
            Width           =   5590
         End
      End
      Begin VB.Frame Frame2 
         Height          =   500
         Left            =   60
         TabIndex        =   1
         Top             =   115
         Width           =   5775
         Begin VB.CommandButton cmdConnect 
            Caption         =   "connect"
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   300
            Left            =   4730
            TabIndex        =   6
            Top             =   150
            Width           =   945
         End
         Begin VB.TextBox txtPort 
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   315
            Left            =   3720
            TabIndex        =   5
            Text            =   "2223"
            Top             =   140
            Width           =   855
         End
         Begin VB.TextBox txtRemoteHost 
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   315
            Left            =   1320
            TabIndex        =   2
            Text            =   "localhost"
            Top             =   140
            Width           =   1695
         End
         Begin VB.Label lblPort 
            Caption         =   "Port #:"
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   8.25
               Charset         =   0
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Left            =   3120
            TabIndex        =   4
            Top             =   180
            Width           =   615
         End
         Begin VB.Label lblRemoteHost 
            Caption         =   "Remote Host:"
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   8.25
               Charset         =   0
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Left            =   120
            TabIndex        =   3
            Top             =   180
            Width           =   1215
         End
      End
   End
End
Attribute VB_Name = "frmClient"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'_____________________________________'
'                                     '
'this is a vb example on how to use   '
'winsock to make a simple client &    '
'server based application...for your  '
'questions & comments please email me '
'at webmaster@plastik.zzn.com..Thanks!'
'_____________________________________'
'

Private Sub cmdConnect_Click()
Select Case cmdConnect.Caption

 Case "connect"
   ' set up local port and wait for connection
   cmdConnect.Caption = "disconnect"
   tcpClient.RemoteHost = txtRemoteHost.Text
   
   If tcpClient.RemoteHost = "" Then
      tcpClient.RemoteHost = "localhost"
   End If
   
   tcpClient.RemotePort = txtPort.Text   ' server port
   Call tcpClient.Connect  ' connect to RemoteHost address
 
 Case "disconnect"
   cmdConnect.Caption = "connect"
   tcpClient.Close
   
End Select
End Sub

Private Sub cmdSend_Click()
   ' send data to server
   Call tcpClient.SendData("CLIENT >>> " & txtMessage.Text)
   txtChat.Text = txtChat.Text & _
      "CLIENT >>> " & txtMessage.Text & vbCrLf
   txtChat.SelStart = Len(txtChat.Text)
   txtMessage.Text = ""
End Sub

Private Sub Form_Terminate()
   Call tcpClient.Close 'if the form terminates close the client
End Sub

Private Sub tcpClient_Close()
   cmdSend.Enabled = False
   Call tcpClient.Close  ' server closed, client should too
   txtChat.Text = _
      txtChat.Text & "Server closed the connection." & vbCrLf
   txtChat.SelStart = Len(txtChat.Text)
End Sub

Private Sub tcpClient_Connect()
   ' when connection occurs, display a message
   cmdSend.Enabled = True
   txtMessage.Enabled = True
   txtChat.Text = "Connected to IP address: " & _
      tcpClient.RemoteHostIP & vbCrLf & "Port #: " & _
      tcpClient.RemotePort & vbCrLf & vbCrLf
End Sub

Private Sub tcpClient_DataArrival(ByVal bytesTotal As Long)
   Dim strMessage As String
   Call tcpClient.GetData(strMessage$)  ' get data from server
   txtChat.Text = txtChat.Text & strMessage$ & vbCrLf
   txtChat.SelStart = Len(txtChat.Text)
End Sub

Private Sub tcpClient_Error(ByVal Number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)
   Dim result As Integer
   result = MsgBox(Source & ": " & Description, _
      vbOKOnly, "TCP/IP Error")
End Sub

Private Sub txtChat_Change()

End Sub

Private Sub txtMessage_KeyDown(KeyCode As Integer, Shift As Integer)
If KeyCode = vbKeyReturn Then
 Call cmdSend_Click
End If
End Sub
