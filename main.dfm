object Form1: TForm1
  Left = 336
  Top = 327
  BorderStyle = bsDialog
  Caption = #24037#20855
  ClientHeight = 278
  ClientWidth = 608
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 88
    Top = 48
    Width = 16
    Height = 13
    Caption = 'lbl1'
  end
  object lbl2: TLabel
    Left = 32
    Top = 216
    Width = 73
    Height = 32
    AutoSize = False
    Caption = #25353#19979
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 112
    Top = 216
    Width = 90
    Height = 32
    AutoSize = False
    Caption = 'Win+F2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -27
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 224
    Top = 216
    Width = 217
    Height = 32
    AutoSize = False
    Caption = #36755#20837#24403#21069#26085#26399
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 472
    Top = 152
    Width = 97
    Height = 17
    Caption = 'QQ:787935636'
  end
  object grp1: TGroupBox
    Left = 32
    Top = 24
    Width = 417
    Height = 169
    Caption = ' '#36873#25321#26102#38388#26684#24335
    TabOrder = 0
    object rb_SimpleDate: TRadioButton
      Left = 40
      Top = 32
      Width = 249
      Height = 17
      Caption = #31616#21333#26085#26399#26684#24335' 2014-2-4'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object rb_Full_Time: TRadioButton
      Left = 40
      Top = 72
      Width = 209
      Height = 17
      Caption = #23436#25972#26684#24335' 2014/2/4 11:30:15'
      TabOrder = 1
    end
    object rb_ChinaDate: TRadioButton
      Left = 40
      Top = 112
      Width = 113
      Height = 17
      Caption = #20013#25991#26085#26399#26684#24335' 2014'#24180'2'#26376'21'#26085
      TabOrder = 2
    end
  end
  object btnOK: TBitBtn
    Left = 472
    Top = 32
    Width = 105
    Height = 57
    Caption = #21518#21488#36816#34892
    TabOrder = 1
    OnClick = btnOKClick
    Kind = bkOK
  end
  object chk_autorun: TCheckBox
    Left = 472
    Top = 112
    Width = 113
    Height = 17
    Caption = #24320#26426#33258#21160#36816#34892
    TabOrder = 2
    OnClick = chk_autorunClick
  end
  object trycn1: TTrayIcon
    Active = True
    Hint = #25353#19979'Win+F2'#33719#21462#24403#21069#26085#26399
    Icon.Data = {
      0000010001002020100000000000E80200001600000028000000200000004000
      0000010004000000000080020000000000000000000000000000000000000000
      000000008000008000000080800080000000800080008080000080808000C0C0
      C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF009999
      99999999999999999999999999999CC00000000000000000000000000CC99CC0
      00000000B00000000B0000000CC99CC00000000040000800040008080CC99CC0
      0000000030000000030000000CC99CC008080000C00000000C0008080CC99CC0
      00000000C00008080C0000000CC99CC008080800C00000000C0000000CC99CC0
      00000000C0080C00CC0000000CC99CCCC00C0000C0000C00CC0000000CC99CCC
      C00C0000C0000C00CC00000CCCC99CCCC00C0000C0000CCCCC00000CCCC99CCC
      CCCC0000C0030CCCCC00000CCCC99CCCCCCC0300C0000CCCCC00000CCCC99CCC
      CC9C0000CC00CCCCCC00000CCCC99CCCCCCC0300CCCCCCCCCC00000CCCC99CCC
      CCCC0000CCCFCCCCCC00080CCCC99CCCFCCC0808CCCCCCCCCCCC000CCCC99CCC
      CCCC0000CCCCCCCCFCCC080CCCC99CCCCCCC0808CCCCCCCCCCCC000CCFC99CCC
      CCCC0000CCCCCCCCCCCCC0CCCCC99CCCCCCC0808CCCCCCCCCCCCC0CCCCC99CCC
      CCCC0000CCCCFCCCCCCCC0CCCCC99CCCCCCCC00CCCCCCCCCCCCCCCCCCCC99CCC
      FCCCC00CCCCCCCCCFCCCCCCCCCC99CCCCCCCCCCCCCCCCCCCCCCCCC9CCCC99CCC
      CCCCCCCCCCCCCFCCCCCCCCCCCCC99CCCCCCCCCCCCCCCCCCCCFCCCCCCCCC99CCC
      CCCC6FCCCCCCCCCCCCCCCCCCFCC99CCCCCCCCCCCCCCCCCCCCCCCCCCCCCC99CCC
      CCCCCCCCCCCCCCCCCCCCCCCCCCC9999999999999999999999999999999990000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000}
    PopupMenu = pm1
    Left = 296
    Top = 88
  end
  object pm1: TPopupMenu
    Left = 464
    Top = 208
    object Config1: TMenuItem
      Caption = 'Config'
      OnClick = Config1Click
    end
    object Exit1: TMenuItem
      Caption = 'Exit'
      OnClick = Exit1Click
    end
  end
  object tmr1: TTimer
    Interval = 3000
    OnTimer = tmr1Timer
    Left = 528
    Top = 168
  end
end
