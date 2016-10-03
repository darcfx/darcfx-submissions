VERSION 5.00
Begin VB.Form frmAbout 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "About MyApp"
   ClientHeight    =   3555
   ClientLeft      =   2340
   ClientTop       =   1935
   ClientWidth     =   5730
   ClipControls    =   0   'False
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2453.724
   ScaleMode       =   0  'User
   ScaleWidth      =   5380.766
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmdOK 
      Cancel          =   -1  'True
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   345
      Left            =   4245
      TabIndex        =   0
      Top             =   2625
      Width           =   1260
   End
   Begin VB.CommandButton cmdSysInfo 
      Caption         =   "&System Info..."
      Height          =   345
      Left            =   4260
      TabIndex        =   1
      Top             =   3075
      Width           =   1245
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   120
      Picture         =   "frmAbout.frx":0000
      Top             =   240
      Width           =   480
   End
   Begin VB.Line Line2 
      Index           =   1
      X1              =   957.833
      X2              =   4676.478
      Y1              =   704.022
      Y2              =   704.022
   End
   Begin VB.Line Line2 
      Index           =   0
      X1              =   957.833
      X2              =   4676.478
      Y1              =   414.131
      Y2              =   414.131
   End
   Begin VB.Line Line1 
      BorderColor     =   &H00808080&
      BorderStyle     =   6  'Inside Solid
      Index           =   1
      X1              =   84.515
      X2              =   5309.398
      Y1              =   1687.583
      Y2              =   1687.583
   End
   Begin VB.Label lblDescription 
      Caption         =   "App Description"
      ForeColor       =   &H00000000&
      Height          =   1170
      Left            =   1080
      TabIndex        =   2
      Top             =   1200
      Width           =   3885
   End
   Begin VB.Label lblTitle 
      Caption         =   "Application Title"
      ForeColor       =   &H00000000&
      Height          =   300
      Left            =   1050
      TabIndex        =   4
      Top             =   240
      Width           =   3885
   End
   Begin VB.Line Line1 
      BorderColor     =   &H00FFFFFF&
      BorderWidth     =   2
      Index           =   0
      X1              =   98.6
      X2              =   5309.398
      Y1              =   1697.936
      Y2              =   1697.936
   End
   Begin VB.Label lblVersion 
      Caption         =   "Version"
      Height          =   225
      Left            =   1050
      TabIndex        =   5
      Top             =   720
      Width           =   3885
   End
   Begin VB.Label lblDisclaimer 
      Caption         =   "Warning: ..."
      ForeColor       =   &H00000000&
      Height          =   825
      Left            =   255
      TabIndex        =   3
      Top             =   2625
      Width           =   3870
   End
End
Attribute VB_Name = "frmAbout"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'------------------------------------------------------------
'Define constants
'------------------------------------------------------------
' Reg Key Security Options...
Const READ_CONTROL = &H20000
Const KEY_QUERY_VALUE = &H1
Const KEY_SET_VALUE = &H2
Const KEY_CREATE_SUB_KEY = &H4
Const KEY_ENUMERATE_SUB_KEYS = &H8
Const KEY_NOTIFY = &H10
Const KEY_CREATE_LINK = &H20
Const KEY_ALL_ACCESS = KEY_QUERY_VALUE + KEY_SET_VALUE + _
                       KEY_CREATE_SUB_KEY + KEY_ENUMERATE_SUB_KEYS + _
                       KEY_NOTIFY + KEY_CREATE_LINK + READ_CONTROL
                     
' Reg Key ROOT Types...
Const HKEY_LOCAL_MACHINE = &H80000002
Const ERROR_SUCCESS = 0
Const REG_SZ = 1                         ' Unicode nul terminated string
Const REG_DWORD = 4                      ' 32-bit number

Const gREGKEYSYSINFOLOC = "SOFTWARE\Microsoft\Shared Tools Location"
Const gREGVALSYSINFOLOC = "MSINFO"
Const gREGKEYSYSINFO = "SOFTWARE\Microsoft\Shared Tools\MSINFO"
Const gREGVALSYSINFO = "PATH"

'------------------------------------------------------------
'Function Declarations
'------------------------------------------------------------
Private Declare Function RegOpenKeyEx Lib "advapi32" Alias "RegOpenKeyExA" (ByVal hKey As Long, ByVal lpSubKey As String, ByVal ulOptions As Long, ByVal samDesired As Long, ByRef phkResult As Long) As Long
Private Declare Function RegQueryValueEx Lib "advapi32" Alias "RegQueryValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal lpReserved As Long, ByRef lpType As Long, ByVal lpData As String, ByRef lpcbData As Long) As Long
Private Declare Function RegCloseKey Lib "advapi32" (ByVal hKey As Long) As Long


Private Sub cmdSysInfo_Click()
  Call StartSysInfo
End Sub

Private Sub cmdOK_Click()
  Unload Me
End Sub

Private Sub Form_Load()

    App.Title = "Pixel Collision Detection"
    
    Me.Caption = "About " & App.Title
    lblVersion.Caption = "Version " & App.Major & "." & App.Minor & "." & App.Revision
    lblTitle.Caption = App.Title
    
    lblDescription.Caption = "This program demonstrates how to performs accurate pixel collision detection"
    
    lblDisclaimer = "Author : Richard Lowe " & vbCrLf & "Contact : riklowe@hotmail.com" & vbCrLf & "(c) 1999 R.Lowe"
    
End Sub

Public Sub StartSysInfo()
'------------------------------------------------------------
'Locate the Sysinfo program and run
'------------------------------------------------------------

On Error GoTo SysInfoErr
  
    Dim rc As Long
    Dim SysInfoPath As String
    
'------------------------------------------------------------
' Try To Get System Info Program Path\Name From Registry...
'------------------------------------------------------------
    If GetKeyValue(HKEY_LOCAL_MACHINE, gREGKEYSYSINFO, gREGVALSYSINFO, SysInfoPath) = False Then
        If GetKeyValue(HKEY_LOCAL_MACHINE, gREGKEYSYSINFOLOC, gREGVALSYSINFOLOC, SysInfoPath) = False Then
            If (Dir(SysInfoPath & "\MSINFO32.EXE") <> "") Then
                SysInfoPath = SysInfoPath & "\MSINFO32.EXE"
            Else
                GoTo SysInfoErr
            End If
        Else
            GoTo SysInfoErr
        End If
    End If
  
'------------------------------------------------------------
'Run Sysinfo
'------------------------------------------------------------
    Call Shell(SysInfoPath, vbNormalFocus)
    
Exit Sub

'------------------------------------------------------------
'Error Handler
'------------------------------------------------------------
SysInfoErr:
    
    MsgBox "System Information Is Unavailable At This Time", vbOKOnly
    
End Sub

Public Function GetKeyValue(KeyRoot As Long, KeyName As String, SubKeyRef As String, ByRef KeyVal As String) As Boolean
'------------------------------------------------------------
'Read Registry
'------------------------------------------------------------

Dim i As Long                                               ' Loop Counter
Dim rc As Long                                              ' Return Code
Dim hKey As Long                                            ' Handle To An Open Registry Key
Dim hDepth As Long                                          '
Dim KeyValType As Long                                      ' Data Type Of A Registry Key
Dim tmpVal As String                                        ' Tempory Storage For A Registry Key Value
Dim KeyValSize As Long                                      ' Size Of Registry Key Variable
    
'------------------------------------------------------------
' Open RegKey Under KeyRoot {HKEY_LOCAL_MACHINE...}
'------------------------------------------------------------
    rc = RegOpenKeyEx(KeyRoot, KeyName, 0, _
                      KEY_ALL_ACCESS, hKey)                 ' Open Registry Key
    
    If (rc <> ERROR_SUCCESS) Then GoTo GetKeyError          ' Handle Error...
    
    tmpVal = String$(1024, 0)                               ' Allocate Variable Space
    KeyValSize = 1024                                       ' Mark Variable Size
    
'------------------------------------------------------------
' Retrieve Registry Key Value...
'------------------------------------------------------------
    rc = RegQueryValueEx(hKey, SubKeyRef, 0, _
                         KeyValType, tmpVal, KeyValSize)    ' Get/Create Key Value
                        
    If (rc <> ERROR_SUCCESS) Then GoTo GetKeyError          ' Handle Errors
    
    If (Asc(Mid(tmpVal, KeyValSize, 1)) = 0) Then           ' Win95 Adds Null Terminated String...
        tmpVal = Left(tmpVal, KeyValSize - 1)               ' Null Found, Extract From String
    Else                                                    ' WinNT Does NOT Null Terminate String...
        tmpVal = Left(tmpVal, KeyValSize)                   ' Null Not Found, Extract String Only
    End If
    
'------------------------------------------------------------
' Determine Key Value Type For Conversion...
'------------------------------------------------------------
    Select Case KeyValType                                  ' Search Data Types...
    Case REG_SZ                                             ' String Registry Key Data Type
        KeyVal = tmpVal                                     ' Copy String Value
    Case REG_DWORD                                          ' Double Word Registry Key Data Type
        For i = Len(tmpVal) To 1 Step -1                    ' Convert Each Bit
            KeyVal = KeyVal + Hex(Asc(Mid(tmpVal, i, 1)))   ' Build Value Char. By Char.
        Next
        KeyVal = Format$("&h" + KeyVal)                     ' Convert Double Word To String
    End Select
    
    GetKeyValue = True                                      ' Return Success
    rc = RegCloseKey(hKey)                                  ' Close Registry Key
    Exit Function                                           ' Exit
    
GetKeyError:
'------------------------------------------------------------
' Cleanup After An Error Has Occured...
'------------------------------------------------------------
    KeyVal = ""                                             ' Set Return Val To Empty String
    GetKeyValue = False                                     ' Return Failure
    rc = RegCloseKey(hKey)                                  ' Close Registry Key
    
End Function

