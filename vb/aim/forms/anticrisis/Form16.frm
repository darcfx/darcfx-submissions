VERSION 5.00
Begin VB.Form Form16 
   BackColor       =   &H80000012&
   BorderStyle     =   0  'None
   Caption         =   "Form16"
   ClientHeight    =   3195
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   5160
   LinkTopic       =   "Form16"
   ScaleHeight     =   3195
   ScaleWidth      =   5160
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame Frame1 
      BackColor       =   &H80000012&
      Height          =   3135
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   5055
      Begin VB.CommandButton Command1 
         Caption         =   "X"
         Height          =   255
         Left            =   4800
         TabIndex        =   7
         Top             =   120
         Width           =   255
      End
      Begin VB.Frame Frame3 
         BackColor       =   &H80000012&
         Height          =   2055
         Left            =   0
         TabIndex        =   4
         Top             =   480
         Width           =   3015
         Begin VB.TextBox Text1 
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   1815
            Left            =   120
            MultiLine       =   -1  'True
            ScrollBars      =   3  'Both
            TabIndex        =   5
            Top             =   240
            Width           =   2775
         End
      End
      Begin VB.Frame Frame2 
         BackColor       =   &H80000012&
         Height          =   2535
         Left            =   3000
         TabIndex        =   1
         Top             =   480
         Width           =   1935
         Begin VB.ListBox List2 
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   1140
            ItemData        =   "Form16.frx":0000
            Left            =   120
            List            =   "Form16.frx":0002
            TabIndex        =   3
            Top             =   1200
            Width           =   1695
         End
         Begin VB.ListBox List1 
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   1140
            ItemData        =   "Form16.frx":0004
            Left            =   120
            List            =   "Form16.frx":0006
            TabIndex        =   2
            Top             =   120
            Width           =   1695
         End
      End
      Begin VB.Label Label2 
         Alignment       =   2  'Center
         BackStyle       =   0  'Transparent
         Caption         =   "Options"
         BeginProperty Font 
            Name            =   "Comic Sans MS"
            Size            =   12
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H8000000E&
         Height          =   375
         Left            =   720
         TabIndex        =   8
         Top             =   2640
         Width           =   1335
      End
      Begin VB.Label Label1 
         Alignment       =   2  'Center
         BackStyle       =   0  'Transparent
         Caption         =   "��� �r�S�S"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   14.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H8000000E&
         Height          =   375
         Left            =   0
         TabIndex        =   6
         Top             =   120
         Width           =   4695
      End
   End
End
Attribute VB_Name = "Form16"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
Do Until Form16.Top <= -5000
Form16.Top = Trim(Str(Int(Form16.Top) - 175))
Loop
Unload Form16
End Sub

Private Sub Command1_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
Label2.ForeColor = "&HFF0000"
End Sub

Private Sub Form_Load()
Call StayOnTop(Form16.hwnd, True)

Label2.ForeColor = "&HFF0000"
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
End Sub

Private Sub Frame1_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
Label2.ForeColor = "&HFF0000"
End Sub

Private Sub Frame2_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
Label2.ForeColor = "&HFF0000"
End Sub

Private Sub Frame3_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
Label2.ForeColor = "&HFF0000"
End Sub

Private Sub Label1_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
Call Form_Move(Me)
End Sub

Private Sub Label2_Click()
PopupMenu Form2.OPTIONS
End Sub

Private Sub Label2_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
Label2.ForeColor = "&H00FF00"
End Sub

Private Sub List1_Click()
Text1 = Text1 + List1
End Sub

Private Sub List1_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
Label2.ForeColor = "&HFF0000"
End Sub

Private Sub List2_Click()
Text1 = Text1 + List2
End Sub

Private Sub List2_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
Label2.ForeColor = "&HFF0000"
End Sub

Private Sub Text1_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
Label2.ForeColor = "&HFF0000"
End Sub
