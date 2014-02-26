object Form1: TForm1
  Left = 209
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 735
  ClientWidth = 1335
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
  object Label1: TLabel
    Left = 8
    Top = 8
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
    Left = 665
    Top = 64
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
  object Label3: TLabel
    Left = 699
    Top = 375
    Width = 41
    Height = 13
    Caption = 'Spieler 1'
  end
  object Label4: TLabel
    Left = 521
    Top = 224
    Width = 41
    Height = 13
    Caption = 'Spieler 4'
  end
  object Label5: TLabel
    Left = 697
    Top = 109
    Width = 41
    Height = 13
    Caption = 'Spieler 2'
  end
  object Label6: TLabel
    Left = 883
    Top = 224
    Width = 41
    Height = 13
    Caption = 'Spieler 3'
  end
  object Image23: TImage
    Left = 681
    Top = 128
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
  end
  object Image22: TImage
    Left = 586
    Top = 180
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
  end
  object Image21: TImage
    Left = 681
    Top = 264
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
  end
  object Image24: TImage
    Left = 785
    Top = 180
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
  end
  object Label7: TLabel
    Left = 8
    Top = 481
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
  object Karte_auf_stapel_legen: TButton
    Left = 8
    Top = 434
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
    OnClick = Karte_auf_stapel_legenClick
  end
  object Terminal: TMemo
    Left = 8
    Top = 511
    Width = 465
    Height = 153
    Lines.Strings = (
      '//Terminal gestartet')
    TabOrder = 1
  end
  object Chat: TMemo
    Left = 960
    Top = 26
    Width = 361
    Height = 113
    ReadOnly = True
    TabOrder = 2
  end
  object Edit2: TEdit
    Left = 504
    Top = 587
    Width = 121
    Height = 21
    TabOrder = 3
    Text = '45678'
  end
  object verbinden_klein: TButton
    Left = 655
    Top = 548
    Width = 119
    Height = 25
    Caption = 'Verbinden'
    TabOrder = 4
    OnClick = verbinden_kleinClick
  end
  object Ansage_abgeben: TButton
    Left = 776
    Top = 480
    Width = 157
    Height = 25
    Caption = 'Ansage abgeben(am Zug)'
    Enabled = False
    TabOrder = 5
    OnClick = Ansage_abgebenClick
  end
  object Name_geben: TButton
    Left = 655
    Top = 519
    Width = 75
    Height = 25
    Caption = 'Name geben'
    Enabled = False
    TabOrder = 6
    OnClick = Name_gebenClick
  end
  object verbindung_trennen: TButton
    Left = 655
    Top = 579
    Width = 119
    Height = 29
    Caption = 'Verbindung trennen'
    TabOrder = 7
    OnClick = verbindung_trennenClick
  end
  object Edit3: TEdit
    Left = 504
    Top = 523
    Width = 121
    Height = 21
    TabOrder = 8
    Text = 'TESTNAME'
  end
  object Karten_sortieren: TButton
    Left = 776
    Top = 449
    Width = 157
    Height = 25
    Caption = 'Kartensortieren'
    TabOrder = 9
  end
  object ComboBox1: TComboBox
    Left = 504
    Top = 550
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 10
    Text = '87.67.69.82'
    Items.Strings = (
      '84.63.62.143'
      '127.0.0.1'
      '87.67.69.82')
  end
  object Verbinden_gross: TButton
    Left = 448
    Top = 670
    Width = 202
    Height = 25
    Caption = 'Verbinden'
    TabOrder = 11
    OnClick = Verbinden_grossClick
  end
  object Button8: TButton
    Left = 1216
    Top = 154
    Width = 105
    Height = 25
    Caption = 'Senden'
    TabOrder = 12
    OnClick = Button8Click
  end
  object Edit1: TEdit
    Left = 960
    Top = 154
    Width = 250
    Height = 21
    TabOrder = 13
    Text = 'Edit1'
    OnClick = Edit1Click
  end
  object MainMenu1: TMainMenu
    Left = 696
    Top = 640
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
    Left = 736
    Top = 642
  end
  object Timer1: TTimer
    Enabled = False
    Left = 768
    Top = 640
  end
end
