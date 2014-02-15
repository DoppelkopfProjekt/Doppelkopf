object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Form3'
  ClientHeight = 150
  ClientWidth = 349
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 88
    Top = 80
    Width = 173
    Height = 13
    Caption = '1. Alle Daten eingeben 2. Verbinden'
  end
  object Edit2: TEdit
    Left = 8
    Top = 43
    Width = 145
    Height = 21
    TabOrder = 0
    Text = '45678'
  end
  object Button2: TButton
    Left = 104
    Top = 110
    Width = 145
    Height = 25
    Caption = 'Verbinden'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Edit3: TEdit
    Left = 208
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'TESTNAME'
  end
  object ComboBox1: TComboBox
    Left = 8
    Top = 8
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 3
    Text = '84.63.62.143'
    Items.Strings = (
      '84.63.62.143'
      '192.168.0.26'
      '127.0.0.1')
  end
end
