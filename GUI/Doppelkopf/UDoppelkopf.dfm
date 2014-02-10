object Form1: TForm1
  Left = 209
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 605
  ClientWidth = 900
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
    Left = 624
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
    Left = 656
    Top = 64
    Width = 41
    Height = 13
    Caption = 'Spieler 1'
  end
  object Label4: TLabel
    Left = 488
    Top = 180
    Width = 41
    Height = 13
    Caption = 'Spieler 4'
  end
  object Label5: TLabel
    Left = 832
    Top = 180
    Width = 41
    Height = 13
    Caption = 'Spieler 2'
  end
  object Label6: TLabel
    Left = 656
    Top = 344
    Width = 41
    Height = 13
    Caption = 'Spieler 3'
  end
  object Image13: TImage
    Left = 640
    Top = 88
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
  end
  object Image12: TImage
    Left = 535
    Top = 140
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
  end
  object Image11: TImage
    Left = 640
    Top = 224
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
  end
  object Image14: TImage
    Left = 744
    Top = 140
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Stretch = True
  end
  object Button1: TButton
    Left = 8
    Top = 308
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
    Top = 392
    Width = 465
    Height = 305
    Lines.Strings = (
      '//Terminal gestartet')
    TabOrder = 1
  end
  object Memo2: TMemo
    Left = 8
    Top = 703
    Width = 417
    Height = 113
    TabOrder = 2
  end
  object Memo3: TMemo
    Left = 8
    Top = 823
    Width = 417
    Height = 25
    Lines.Strings = (
      'Nachricht eingeben')
    TabOrder = 3
  end
  object Edit1: TEdit
    Left = 656
    Top = 480
    Width = 121
    Height = 21
    TabOrder = 4
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 656
    Top = 507
    Width = 121
    Height = 21
    TabOrder = 5
    Text = 'Edit2'
  end
  object MainMenu1: TMainMenu
    Left = 288
    Top = 8
    object Spiel1: TMenuItem
      Caption = 'Spiel'
      object NeuesSpiel1: TMenuItem
        Caption = 'Neues Spiel'
        OnClick = NeuesSpiel1Click
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
end
