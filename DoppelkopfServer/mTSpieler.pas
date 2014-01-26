unit mTSpieler;

interface

uses Classes, SysUtils, mTBlatt, mTKarte, dialogs, mTStich;

type
  TSpieler = class
  private
    FName: string;
    FIP: string;
    FBlatt: TBlatt;
    FGewonneneStiche: TList;
  public
    constructor Create(pIP: string);
    property Name: string read FName write FName;
    property IP: string read FIP;

    procedure gibKarte(pKarte: TKarte);
    function karteLegen(pKartenCode: string; pStich: TStich): Boolean;

    procedure gibGewonnenenStich(pStich: TStich);

    function gewonnenePunkte: Integer;
  end;

implementation

constructor TSpieler.Create(pIP: string);
begin
  FIP := pIP;
  FBlatt := TBlatt.Create;
  FGewonneneStiche := TList.Create;
end;

procedure TSpieler.gibKarte(pKarte: TKarte);
begin
  FBlatt.KarteHinzufuegen(pKarte);
end;

function TSpieler.karteLegen(pKartenCode: string; pStich: TStich): Boolean;
var karte: TKarte;
begin
  karte := self.FBlatt.getKarteMitCode(pKartenCode);
  if karte = nil then ShowMessage('Der Spieler besitzt diese Karte nicht!');

  if not self.FBlatt.istZugLegal(karte, pStich) then
  begin
    result := false;
    exit;
  end;

  self.FBlatt.LegeKarte(karte);
  pStich.LegeKarte(karte, self);
  result := true;
end;

procedure TSpieler.gibGewonnenenStich(pStich: TStich);
begin
  FGewonneneStiche.Add(pStich);
end;

function TSpieler.gewonnenePunkte;
begin
  ShowMessage('Noch nicht implementiert');
end;

end.







