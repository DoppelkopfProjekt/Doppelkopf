object Form1: TForm1
  Left = 209
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 715
  ClientWidth = 1009
  Color = clActiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image11: TImage
    Left = 8
    Top = 73
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
    OnClick = Image11Click
    OnDblClick = Image12DblClick
  end
  object Label1: TLabel
    Left = 8
    Top = 24
    Width = 188
    Height = 20
    Caption = 'Karten auf deiner Hand'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 648
    Top = 24
    Width = 109
    Height = 20
    Caption = 'gelegt Karten'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Image12: TImage
    Left = 96
    Top = 73
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
    OnClick = Image11Click
    OnDblClick = Image12DblClick
  end
  object Image13: TImage
    Left = 184
    Top = 73
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
    OnClick = Image11Click
    OnDblClick = Image12DblClick
  end
  object Image14: TImage
    Left = 272
    Top = 73
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
    OnClick = Image11Click
    OnDblClick = Image12DblClick
  end
  object Image15: TImage
    Left = 360
    Top = 73
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
    OnClick = Image11Click
    OnDblClick = Image12DblClick
  end
  object Image16: TImage
    Left = 8
    Top = 192
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
    OnClick = Image11Click
    OnDblClick = Image12DblClick
  end
  object Image17: TImage
    Left = 96
    Top = 192
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
    OnClick = Image11Click
    OnDblClick = Image12DblClick
  end
  object Image18: TImage
    Left = 184
    Top = 192
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
    OnClick = Image11Click
    OnDblClick = Image12DblClick
  end
  object Image19: TImage
    Left = 272
    Top = 192
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
    OnClick = Image11Click
    OnDblClick = Image12DblClick
  end
  object Image20: TImage
    Left = 360
    Top = 192
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
    OnClick = Image11Click
    OnDblClick = Image12DblClick
  end
  object Label3: TLabel
    Left = 682
    Top = 335
    Width = 41
    Height = 13
    Caption = 'Spieler 1'
  end
  object Label4: TLabel
    Left = 504
    Top = 184
    Width = 41
    Height = 13
    Caption = 'Spieler 4'
  end
  object Label5: TLabel
    Left = 680
    Top = 69
    Width = 41
    Height = 13
    Caption = 'Spieler 2'
  end
  object Label6: TLabel
    Left = 866
    Top = 184
    Width = 41
    Height = 13
    Caption = 'Spieler 3'
  end
  object Image23: TImage
    Left = 664
    Top = 88
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
  end
  object Image22: TImage
    Left = 569
    Top = 140
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
  end
  object Image21: TImage
    Left = 664
    Top = 224
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
  end
  object Image24: TImage
    Left = 768
    Top = 140
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
  end
  object Label7: TLabel
    Left = 64
    Top = 362
    Width = 56
    Height = 24
    Caption = 'Label7'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Button1: TButton
    Left = 8
    Top = 315
    Width = 425
    Height = 41
    Caption = 'ausgew'#228'hlte Karte legen'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 400
    Width = 465
    Height = 153
    Lines.Strings = (
      '//Terminal gestartet')
    TabOrder = 1
  end
  object Memo2: TMemo
    Left = 8
    Top = 575
    Width = 417
    Height = 113
    Enabled = False
    TabOrder = 2
    Visible = False
  end
  object Memo3: TMemo
    Left = 8
    Top = 711
    Width = 417
    Height = 25
    Lines.Strings = (
      'Nachricht eingeben')
    TabOrder = 3
  end
  object Edit2: TEdit
    Left = 521
    Top = 599
    Width = 121
    Height = 21
    TabOrder = 4
    Text = '45678'
  end
  object Button2: TButton
    Left = 682
    Top = 560
    Width = 119
    Height = 25
    Caption = 'Verbinden'
    TabOrder = 5
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 448
    Top = 324
    Width = 157
    Height = 25
    Caption = 'Ansage abgeben(am Zug)'
    Enabled = False
    TabOrder = 6
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 648
    Top = 523
    Width = 75
    Height = 25
    Caption = 'Name geben'
    Enabled = False
    TabOrder = 7
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 664
    Top = 599
    Width = 177
    Height = 25
    Caption = 'Verbindung trennen'
    TabOrder = 8
    OnClick = Button5Click
  end
  object Edit3: TEdit
    Left = 521
    Top = 527
    Width = 121
    Height = 21
    TabOrder = 9
    Text = 'TESTNAME'
  end
  object Button6: TButton
    Left = 866
    Top = 384
    Width = 75
    Height = 25
    Caption = 'Kartensortieren'
    TabOrder = 10
    OnClick = Button6Click
  end
  object Edit4: TEdit
    Left = 866
    Top = 429
    Width = 121
    Height = 21
    TabOrder = 11
    Text = 'Edit4'
  end
  object ComboBox1: TComboBox
    Left = 521
    Top = 562
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 12
    Text = '84.63.62.143'
    Items.Strings = (
      '84.63.62.143'
      '192.168.0.26'
      '127.0.0.1')
  end
  object Button7: TButton
    Left = 521
    Top = 398
    Width = 202
    Height = 25
    Caption = 'Verbinden'
    TabOrder = 13
    OnClick = Button7Click
  end
  object MainMenu1: TMainMenu
    Left = 288
    Top = 8
    object Spiel1: TMenuItem
      Caption = 'Spiel'
      object NeuesSpiel1: TMenuItem
        Caption = 'Neues Spiel'
      end
      object Verbinden1: TMenuItem
        Caption = 'Verbinden'
      end
    end
    object Chat1: TMenuItem
      Caption = 'Chat'
      object openchat: TMenuItem
        Caption = 'Chat '#246'ffnen'
        OnClick = openchatClick
      end
      object closechat: TMenuItem
        Caption = 'Chat verbergen'
        OnClick = closechatClick
      end
    end
    object Terminal1: TMenuItem
      Caption = 'Terminal'
      object Terminalstarten1: TMenuItem
        Caption = 'Konsole starten'
        OnClick = Terminalstarten1Click
      end
      object Konsoleschlieen1: TMenuItem
        Caption = 'Konsole schlie'#223'en'
        OnClick = Konsoleschlieen1Click
      end
    end
  end
  object ClientSocket1: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnRead = ClientSocket1Read
    Left = 328
    Top = 10
  end
  object Timer1: TTimer
    Enabled = False
    Left = 360
    Top = 8
  end
end
