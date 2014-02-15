object Form1: TForm1
  Left = 209
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 662
  ClientWidth = 1009
  Color = clBtnFace
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
  object Image1: TImage
    Left = 8
    Top = 64
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
    OnClick = Image1Click
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
  object Image2: TImage
    Left = 96
    Top = 64
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
    OnClick = Image1Click
  end
  object Image3: TImage
    Left = 184
    Top = 64
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
    OnClick = Image1Click
  end
  object Image4: TImage
    Left = 272
    Top = 64
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
    OnClick = Image1Click
  end
  object Image5: TImage
    Left = 360
    Top = 64
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
    OnClick = Image1Click
  end
  object Image6: TImage
    Left = 8
    Top = 184
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
    OnClick = Image1Click
  end
  object Image7: TImage
    Left = 96
    Top = 184
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
    OnClick = Image1Click
  end
  object Image8: TImage
    Left = 184
    Top = 184
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
    OnClick = Image1Click
  end
  object Image9: TImage
    Left = 272
    Top = 184
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
    OnClick = Image1Click
  end
  object Image0: TImage
    Left = 360
    Top = 184
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
    OnClick = Image1Click
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
  object Image12: TImage
    Left = 664
    Top = 88
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
  end
  object Image11: TImage
    Left = 559
    Top = 140
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
  end
  object Image10: TImage
    Left = 664
    Top = 224
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
  end
  object Image13: TImage
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
    Top = 295
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
  object Edit1: TEdit
    Left = 521
    Top = 484
    Width = 121
    Height = 21
    TabOrder = 4
    Text = '84.63.62.143'
  end
  object Edit2: TEdit
    Left = 521
    Top = 511
    Width = 121
    Height = 21
    TabOrder = 5
    Text = '45678'
  end
  object Button2: TButton
    Left = 648
    Top = 491
    Width = 119
    Height = 25
    Caption = 'Verbinden'
    TabOrder = 6
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 456
    Top = 304
    Width = 157
    Height = 25
    Caption = 'Ansage abgeben(am Zug)'
    Enabled = False
    TabOrder = 7
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 648
    Top = 435
    Width = 75
    Height = 25
    Caption = 'Name geben'
    Enabled = False
    TabOrder = 8
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 648
    Top = 559
    Width = 177
    Height = 25
    Caption = 'Verbindung trennen'
    TabOrder = 9
    OnClick = Button5Click
  end
  object Edit3: TEdit
    Left = 521
    Top = 439
    Width = 121
    Height = 21
    TabOrder = 10
    Text = 'TESTNAME'
  end
  object Button6: TButton
    Left = 832
    Top = 392
    Width = 75
    Height = 25
    Caption = 'Kartensortieren'
    TabOrder = 11
    OnClick = Button6Click
  end
  object Edit4: TEdit
    Left = 832
    Top = 437
    Width = 121
    Height = 21
    TabOrder = 12
    Text = 'Edit4'
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
    Left = 872
    Top = 58
  end
end
