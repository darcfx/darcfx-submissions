VERSION 5.00
Object = "{F141ECB6-B7B1-11D3-A776-00A024CC2E0B}#9.0#0"; "AIMChatScan.ocx"
Begin VB.Form Form1 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Chat Greeter"
   ClientHeight    =   1260
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   3705
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1260
   ScaleWidth      =   3705
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox Text1 
      Height          =   285
      Left            =   60
      TabIndex        =   1
      Text            =   "Welcome [%S] to chat room [%N]."
      Top             =   60
      Width           =   3555
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Enable"
      Height          =   315
      Left            =   2100
      TabIndex        =   0
      Top             =   900
      Width           =   1575
   End
   Begin aimscan.ChatScan ChatScan1 
      Left            =   2100
      Top             =   1860
      _ExtentX        =   7620
      _ExtentY        =   4577
   End
   Begin VB.Label Label1 
      Caption         =   "Insert [%S] where you want the persons name, and [%N] where you want the room name."
      Height          =   435
      Left            =   60
      TabIndex        =   2
      Top             =   360
      Width           =   3555
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub ChatScan1_Change(Who As String, What As String)
If Who = "OnlineHost" And InStr(1, What, " has entered the room.") Then
    thesn = Mid(What, 1, InStr(1, What, " has entered the room.") - 1)
    themsg = Replace(Text1.Text, "[%S]", thesn)
    themsg = Replace(themsg, "[%s]", thesn)
    themsg = Replace(themsg, "[%N]", ChatScan1.ChatName)
    themsg = Replace(themsg, "[%n]", ChatScan1.ChatName)
    ChatScan1.ChatSend (themsg)
End If
End Sub

Private Sub Command1_Click()
If Command1.Caption = "Enable" Then
    ChatScan1.Enabled = True
    Command1.Caption = "Disable"
Else
    ChatScan1.Enabled = False
    Command1.Caption = "Enable"
End If
End Sub

