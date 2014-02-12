object Form1: TForm1
  Left = 225
  Top = 279
  Caption = 'Form1'
  ClientHeight = 258
  ClientWidth = 1066
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 152
    Top = 212
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Edit1: TEdit
    Left = 56
    Top = 32
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
  end
  object Button1: TButton
    Left = 216
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 56
    Top = 63
    Width = 185
    Height = 89
    Lines.Strings = (
      'Memo1')
    TabOrder = 2
  end
  object Button2: TButton
    Left = 56
    Top = 176
    Width = 75
    Height = 25
    Caption = 'Server starten'
    TabOrder = 3
    OnClick = Button2Click
  end
  object MeLog: TMemo
    Left = 304
    Top = 32
    Width = 721
    Height = 193
    ScrollBars = ssVertical
    TabOrder = 4
  end
  object Edit2: TEdit
    Left = 152
    Top = 176
    Width = 121
    Height = 21
    TabOrder = 5
    Text = '45678'
  end
  object Button3: TButton
    Left = 56
    Top = 207
    Width = 75
    Height = 25
    Caption = 'Server beenden'
    TabOrder = 6
    OnClick = Button3Click
  end
end
