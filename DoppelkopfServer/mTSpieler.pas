unit mTSpieler;

interface

uses Classes, SysUtils, mTBlatt;

type
  TSpieler = class
  private
    FName: string;
    FIP: string;
    FBlatt: TBlatt;
  public
    property Name: string read FName write FName;
    property IP: string read FIP write FIP;
  end;

implementation

end.







