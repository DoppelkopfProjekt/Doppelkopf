unit mTSpieler;

interface

uses Classes, SysUtils, Contnrs;

type
  TSpieler = class
  private
    FName: string;
    FIP: string;
  public
    property Name: string read FName write FName;
    property IP: string read FIP write FIP;
  end;

implementation






end.







