VERSION 5.00
Object = "{33155A3D-0CE0-11D1-A6B4-444553540000}#1.0#0"; "SYSTRAY.OCX"
Begin VB.Form Form1 
   BorderStyle     =   0  'None
   Caption         =   "Water Rapids"
   ClientHeight    =   5400
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   3270
   Icon            =   "Form1.frx":0000
   LinkTopic       =   "Form1"
   Picture         =   "Form1.frx":08CA
   ScaleHeight     =   5400
   ScaleWidth      =   3270
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin SysTray.SystemTray SystemTray1 
      Left            =   1440
      Top             =   960
      _ExtentX        =   847
      _ExtentY        =   847
      SysTrayText     =   ""
      IconFile        =   0
   End
   Begin VB.ListBox List2 
      Columns         =   2
      BeginProperty Font 
         Name            =   "Arial Narrow"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   510
      Left            =   120
      TabIndex        =   5
      Top             =   3960
      Width           =   3015
   End
   Begin VB.ListBox List1 
      Columns         =   4
      BeginProperty Font 
         Name            =   "Arial Narrow"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   510
      Left            =   120
      TabIndex        =   4
      Top             =   3360
      Width           =   3015
   End
   Begin VB.TextBox Text1 
      BeginProperty Font 
         Name            =   "Arial Narrow"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   2535
      Left            =   120
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   3
      Top             =   600
      Width           =   3015
   End
   Begin VB.Label Label6 
      BackStyle       =   0  'Transparent
      Caption         =   " Misc."
      BeginProperty Font 
         Name            =   "Ebola"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   2400
      TabIndex        =   8
      Top             =   4920
      Width           =   855
   End
   Begin VB.Label Label5 
      BackStyle       =   0  'Transparent
      Caption         =   " Scroll"
      BeginProperty Font 
         Name            =   "Ebola"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   1200
      TabIndex        =   7
      Top             =   4920
      Width           =   975
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   " File"
      BeginProperty Font 
         Name            =   "Ebola"
         Size            =   14.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   120
      TabIndex        =   6
      Top             =   4920
      Width           =   855
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Water Rapids"
      BeginProperty Font 
         Name            =   "Ebola"
         Size            =   14.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   600
      TabIndex        =   2
      Top             =   120
      Width           =   2175
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   " X"
      BeginProperty Font 
         Name            =   "Ebola"
         Size            =   14.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   2760
      TabIndex        =   1
      Top             =   120
      Width           =   375
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   " _ "
      BeginProperty Font 
         Name            =   "Ebola"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   255
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()
StayOnTop Me
FormPositionMiddleRight Me
List2.AddItem ".��`�.�׷�("
List2.AddItem "� ��(`�-���-�')�� � "
List2.AddItem "�[�]�.���"
List2.AddItem "��+���+���(�"
List2.AddItem "�)��-+���+��"
List2.AddItem "(�`�._.���)"
List2.AddItem "..�::{-(������� "
List2.AddItem ".���`�-"
List2.AddItem "�������`�"
List2.AddItem "[�=--- ^v^ "
List2.AddItem "��v�"
List2.AddItem "��l��"
List2.AddItem "���"
List2.AddItem "�� ���"
List2.AddItem ".��`�."
List2.AddItem "��� "
List2.AddItem "���"
List2.AddItem "�f�"
List2.AddItem "-^v�)-]-� "
List2.AddItem "�-[-(`v^- "
List2.AddItem "������`�"
List2.AddItem "��������"
List2.AddItem "���:�..�:ו"
List2.AddItem "(�`�._.�..���`�..//> "
List2.AddItem "��"
List2.AddItem "����"
List2.AddItem "��"
List2.AddItem "��"
List2.AddItem "�v"
List2.AddItem " v�"
List2.AddItem "�v�"
List2.AddItem "�v^v�"
List2.AddItem "�v^�"
List2.AddItem "�^v�"
List2.AddItem "[|]"
List2.AddItem "[�]"
List2.AddItem "]["
List2.AddItem "|�|"
List2.AddItem "[�]"
List2.AddItem "]�["
List2.AddItem "�[i]�"
List2.AddItem "�[�]�"
List2.AddItem "]���["
List2.AddItem "[���]"
List2.AddItem "��:�["
List2.AddItem "]�:��"
List2.AddItem "��i�i��"
List2.AddItem "�-���-�"
List2.AddItem "�ו"
List2.AddItem "���"
List2.AddItem "ו�"
List2.AddItem "(`�."
List2.AddItem ".��)"
List2.AddItem ".��)(`�."
List2.AddItem ".�:"
List2.AddItem ":�."
List2.AddItem "...��:"
List2.AddItem ":��... "
List2.AddItem ".��"
List2.AddItem "`�."
List2.AddItem "..���`�.."
List2.AddItem "`�....��� "
List2.AddItem "�`�....��"
List2.AddItem ".���`�.���`�."
List2.AddItem "�._.�"
List2.AddItem "�..���`�..�"
List2.AddItem ".���\_.��"
List2.AddItem "��._/�`�."
List2.AddItem "�\_"
List2.AddItem "_/�"
List2.AddItem "���(`��"
List2.AddItem "���)���"
List2.AddItem "(]�[)�v^�"
List2.AddItem "�^v�(]�[)"
List2.AddItem "-�~�'���'�i|�"
List2.AddItem "�|i�'���'�~�-"
List2.AddItem ".��.��(`�"
List2.AddItem "������)��"
List2.AddItem "[{-._.-�"
List2.AddItem "�-._.-}]"
List2.AddItem ".���\_.��"
List2.AddItem "��._/�`�."
List2.AddItem "(�� "
List2.AddItem ")�� "
List2.AddItem "���`�../)"
List2.AddItem "��._.�v��\/`�v�._)"
List2.AddItem "...�::"
List2.AddItem "::�..."
List2.AddItem "(�:���� �:�"
List2.AddItem "�:� ���:�) "
List2.AddItem "���� � ����"
List2.AddItem "� ���"
List2.AddItem "..������-�"
List2.AddItem "����"
List2.AddItem "����"
List2.AddItem "��^v^�"
List2.AddItem "�����`�._.��{"
List2.AddItem "��`v���)"
List2.AddItem "^v^"
List2.AddItem "�o"
List2.AddItem "o�"
List2.AddItem ".-�x"
List2.AddItem "x�-."
List2.AddItem "����"
List2.AddItem "��.�.�-.��"
List2.AddItem "�)-(\��/)(\�-�"
List2.AddItem ". �(��-�"
List2.AddItem "�-��)�."
List2.AddItem "��.� ')"
List2.AddItem "/`�....��� |> "
List2.AddItem "�\_o�� "
List2.AddItem "(' �.��"
List2.AddItem "`�.,��,.���"
List2.AddItem "�`�.,��,.��"
List2.AddItem "���v^v���"
List2.AddItem "��`�.��`� "
List2.AddItem "��`�..�"
List2.AddItem "�..��`�"
List2.AddItem "���(["
List2.AddItem "])���"
List2.AddItem "(.���� "
List2.AddItem "ח����싛"
List2.AddItem "���훋���"
List2.AddItem "����.)"
List2.AddItem "�� �� �� "
List2.AddItem "׷ �� ��"
List2.AddItem "׺���`���� "
List2.AddItem "(�-���^�|[�"
List2.AddItem "((����"
List2.AddItem "����))"
List2.AddItem "�-�-�"
List2.AddItem "���"
List2.AddItem "���"
List2.AddItem "���"
List2.AddItem "FeaR"
List2.AddItem ",.�~�'�������`�.,�.,�.�`��`��'�~�.,�"
List2.AddItem ""
List2.AddItem "�.-�~����'�.�,�..��`�..�,�.�'����~�-.�"
List2.AddItem ""
List2.AddItem "�,.-�~���''��`�.,��,.����''���~�-.,�"
List2.AddItem ""
List2.AddItem "�.-~�*'���`��"
List2.AddItem ""
List2.AddItem "��`���'*�~-.�"
List2.AddItem ""
List2.AddItem "`�,��..-�*�"
List2.AddItem ""
List2.AddItem ",.�~�'����,.�~��`�~�.,�`��'�~�.,"
List2.AddItem ""
List2.AddItem ".�.����`.�.,��,.�.����`.�._."
List2.AddItem ""
List2.AddItem "����~�-.�.�,�.�'`�..��'�.�,�.�.-�~����"
List2.AddItem ""
List2.AddItem "�� ''���~�-.,��,.��`�.,��,.-�~���''��"
List2.AddItem ""
List2.AddItem "�~�.,�.,�.,�,.�`�'��`��..,�,.�,.�~�'"
List2.AddItem ""
List2.AddItem "�����*�`�.����׷,��.״�*�����`"
List2.AddItem ""
List2.AddItem "�����*�`~���.����.���~��*�����`"
List2.AddItem ""
List2.AddItem "� '�~�.,'�~�.,,.�~�,.�~�'�"
List2.AddItem ""
List2.AddItem "_�,.-~����\�/����~-.,�_"
List2.AddItem ""
List2.AddItem ""
List2.AddItem "���`�._.���`�._.���`�._."
List2.AddItem ""
List2.AddItem "��.-�~��������������~�-.��"
List2.AddItem ""
List2.AddItem "_.-~���~-._"
List2.AddItem ""
List2.AddItem "�����*�`�.����.״�*�����`"
List2.AddItem ""
List2.AddItem "�����~-.,�/_\�,.-~�����"
List2.AddItem ""
List2.AddItem "������~�-.����.-�~������"
List2.AddItem ""
List2.AddItem "�`�.,���,.���"
List2.AddItem ""
List2.AddItem "�� '�`���''���'�`��"
List2.AddItem ""
List2.AddItem "��`�'���''���`�'��"
List2.AddItem ""
List2.AddItem "�,.-�~���''��"
List2.AddItem ""
List2.AddItem "�� ''���~�-.,�"
List2.AddItem ""
List2.AddItem "��.-�~����"
List2.AddItem ""
List2.AddItem "`�'�~�-.,�"
List2.AddItem ""
List2.AddItem "��������� , �"
List2.AddItem ""
List2.AddItem "���� , �, ����"
List2.AddItem ""
List2.AddItem "����~�-.�"
List2.AddItem ""
List2.AddItem "�.-�~����"
List2.AddItem ""
List2.AddItem "`�.,�"
List2.AddItem ""
List2.AddItem "� , .��"
List2.AddItem ""
List2.AddItem "���������"
List2.AddItem ""
List2.AddItem ",-�~�-.,�"
List2.AddItem ""
List2.AddItem "�,.-�~�-,"
List2.AddItem ""
List2.AddItem "`���-.,�"
List2.AddItem ""
List2.AddItem "�,.-����"
List2.AddItem ""
List2.AddItem ".� , �.� '"
List2.AddItem ""
List2.AddItem "'�.�,�."
List2.AddItem ""
List2.AddItem "~�- .,�"
List2.AddItem ""
List2.AddItem "�,. -�~"
List2.AddItem ""
List2.AddItem "����������"
List2.AddItem ""
List2.AddItem "�����"
List2.AddItem ""
List2.AddItem "�����"
List1.AddItem "A"
List1.AddItem "B"
List1.AddItem "C"
List1.AddItem "D"
List1.AddItem "E"
List1.AddItem "F"
List1.AddItem "G"
List1.AddItem "H"
List1.AddItem "I"
List1.AddItem "J"
List1.AddItem "K"
List1.AddItem "L"
List1.AddItem "M"
List1.AddItem "N"
List1.AddItem "O"
List1.AddItem "P"
List1.AddItem "Q"
List1.AddItem "R"
List1.AddItem "S"
List1.AddItem "T"
List1.AddItem "U"
List1.AddItem "W"
List1.AddItem "X"
List1.AddItem "Y"
List1.AddItem "Z"
List1.AddItem "a"
List1.AddItem "b"
List1.AddItem "c"
List1.AddItem "d"
List1.AddItem "e"
List1.AddItem "f"
List1.AddItem "g"
List1.AddItem "h"
List1.AddItem "i"
List1.AddItem "j"
List1.AddItem "k"
List1.AddItem "l"
List1.AddItem "m"
List1.AddItem "n"
List1.AddItem "o"
List1.AddItem "p"
List1.AddItem "q"
List1.AddItem "r"
List1.AddItem "s"
List1.AddItem "t"
List1.AddItem "u"
List1.AddItem "v"
List1.AddItem "w"
List1.AddItem "x"
List1.AddItem "y"
List1.AddItem "z"
List1.AddItem "1"
List1.AddItem "2"
List1.AddItem "3"
List1.AddItem "4"
List1.AddItem "5"
List1.AddItem "6"
List1.AddItem "7"
List1.AddItem "8"
List1.AddItem "9"
List1.AddItem "0"
List1.AddItem "~"
List1.AddItem "`"
List1.AddItem "!"
List1.AddItem "@"
List1.AddItem "#"
List1.AddItem "$"
List1.AddItem "%"
List1.AddItem "^"
List1.AddItem "&"
List1.AddItem "*"
List1.AddItem "("
List1.AddItem ")"
List1.AddItem "-"
List1.AddItem "="
List1.AddItem "+"
List1.AddItem "{"
List1.AddItem "}"
List1.AddItem "["
List1.AddItem "]"
List1.AddItem "|"
List1.AddItem "\"
List1.AddItem ":"
List1.AddItem ";"
List1.AddItem "/"
List1.AddItem "?"
List1.AddItem ","
List1.AddItem "<"
List1.AddItem "."
List1.AddItem ">"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
List1.AddItem "�"
ChatSend "" & ("�")
TimeOut 0.3
ChatSend "<font face=""Arial Narrow""></B></I></U></S>" & BlueGreen("     ���������,� Water Rapids ���������,�")
TimeOut 0.3
ChatSend "<font face=""Arial Narrow""></B></I></U></S>" & BlueGreen("     ����,�,����    By FeaR     ����,�,����")
TimeOut 0.3
ChatSend "" & ("�")
End Sub

Private Sub Form_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
MvFrm Me
End Sub

Private Sub Label1_Click()
SystemTray1.icon = Val(Form1.icon)
SystemTray1.SysTrayText = "Water Rapids"
SystemTray1.Action = sys_Add
Form1.Hide
End Sub

Private Sub Label1_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
Label1.ForeColor = "&H00FF00"
Label2.ForeColor = "&H000000"
Label3.ForeColor = "&H000000"
Label4.ForeColor = "&H000000"
Label5.ForeColor = "&H000000"
Label6.ForeColor = "&H000000"
End Sub

Private Sub Label2_Click()
End
End Sub

Private Sub Label2_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
Label2.ForeColor = "&H00FF00"
Label1.ForeColor = "&H000000"
Label3.ForeColor = "&H000000"
Label4.ForeColor = "&H000000"
Label5.ForeColor = "&H000000"
Label6.ForeColor = "&H000000"
End Sub

Private Sub Label3_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
Label3.ForeColor = "&H00FF00"
Label1.ForeColor = "&H000000"
Label2.ForeColor = "&H000000"
Label4.ForeColor = "&H000000"
Label5.ForeColor = "&H000000"
Label6.ForeColor = "&H000000"
End Sub

Private Sub Label4_Click()
PopupMenu Form2.File
End Sub

Private Sub Label4_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
Label3.ForeColor = "&H000000"
Label1.ForeColor = "&H000000"
Label2.ForeColor = "&H000000"
Label4.ForeColor = "&H00FF00"
Label5.ForeColor = "&H000000"
Label6.ForeColor = "&H000000"
End Sub

Private Sub Label5_Click()
ChatSend "" & ("�")
TimeOut 0.3
ChatSend "<font face=""Arial Narrow""></B></I></U></S>" & BlueGreen("     ���������,� Water Rapids ���������,�")
TimeOut 0.3
ChatSend "<font face=""Arial Narrow""></B></I></U></S>" & BlueGreen("     ����,�,����Incoming Ascii����,�,����")
TimeOut 0.3
ChatSend "" & ("�")
mi = ShowWindow(hwnd, SW_MINIMIZE)
phrig$ = Text1.text
Z = 0

TimeOut (0.7)
Do
Z = Z + 1
newz = InStr(Z, phrig$, Chr(13))
TimeOut (0.7)
If newz = 0 Then
TimeOut (0.7)
ez$ = Mid$(phrig$, Z)
ChatSend (ez$)
TimeOut (0.7)
mi = ShowWindow(hwnd, SW_RESTORE)
Exit Sub
End If
F = newz - Z
r$ = Mid$(phrig$, Z, F)
If newz <> 0 Then: ChatSend (r$)
Z = newz + 1
Loop
End Sub

Private Sub Label5_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
Label3.ForeColor = "&H000000"
Label1.ForeColor = "&H000000"
Label2.ForeColor = "&H000000"
Label4.ForeColor = "&H000000"
Label5.ForeColor = "&H00FF00"
Label6.ForeColor = "&H000000"
End Sub

Private Sub Label6_Click()
PopupMenu Form2.Options
End Sub

Private Sub Label6_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
Label3.ForeColor = "&H000000"
Label1.ForeColor = "&H000000"
Label2.ForeColor = "&H000000"
Label4.ForeColor = "&H000000"
Label5.ForeColor = "&H000000"
Label6.ForeColor = "&H00FF00"
End Sub

Private Sub List1_DblClick()
Text1 = Text1 + List1
End Sub

Private Sub List2_DblClick()
Text1 = Text1 + List2
End Sub

Private Sub SystemTray1_MouseDblClk(ByVal Button As Integer)
Form1.Show
End Sub
