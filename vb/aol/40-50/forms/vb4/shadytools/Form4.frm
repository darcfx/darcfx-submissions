VERSION 4.00
Begin VB.Form Form4 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "�tt�n��n"
   ClientHeight    =   375
   ClientLeft      =   1140
   ClientTop       =   1515
   ClientWidth     =   2220
   Height          =   780
   Left            =   1080
   LinkTopic       =   "Form4"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   375
   ScaleWidth      =   2220
   ShowInTaskbar   =   0   'False
   Top             =   1170
   Width           =   2340
   Begin VB.TextBox Text1 
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   390
      Left            =   720
      TabIndex        =   1
      Top             =   0
      Width           =   1455
   End
   Begin Threed.SSPanel SSPanel1 
      Height          =   375
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   735
      _Version        =   65536
      _ExtentX        =   1296
      _ExtentY        =   661
      _StockProps     =   15
      Caption         =   "start"
      BackColor       =   12632064
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BevelOuter      =   1
      BevelInner      =   2
      FloodColor      =   8388608
      Font3D          =   3
   End
End
Attribute VB_Name = "Form4"
Attribute VB_Creatable = False
Attribute VB_Exposed = False
Private Sub Form_Load()
Me.Move (Screen.Width - Me.ScaleWidth) / 2, (Screen.Height - Me.ScaleHeight) / 2
Call FormOnTop(Me)
End Sub

Private Sub SSPanel1_Click()
Call FormOnTop(Me)
Call ChatSend("��'�`v� <B>s</B>h�dy <B>t</B>��lz�")
Pause ".6"
Call ChatSend("��'�`v� <I>" & Text1.Text & "")
Pause ".6"
Call ChatSend("��'�`v� <B>s</B>h�dy <B>t</B>��lz�")
End Sub


