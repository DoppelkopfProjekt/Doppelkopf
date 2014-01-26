unit mTSpieler;

interface

uses Classes, SysUtils, mTBlatt, mTKarte, dialogs, mTStich;

type
  TSpieler = class
  private
    FSpieltSolo: Boolean;
    FName: string;
    FIP: string;
    FBlatt: TBlatt;
    FGewonneneStiche: TList;
    FExtraPunkte: Integer;
    function getPartei: dkPartei;
  public
    constructor Create(pIP: string);
    property Name: string read FName write FName;
    property IP: string read FIP;
    property ExtraPunkte: Integer read FExtraPunkte;

    procedure gibKarte(pKarte: TKarte);
    function karteLegen(pKartenCode: string; pStich: TStich): Boolean;

    procedure gibGewonnenenStich(pStich: TStich);

    function gewonnenePunkte: Integer;
    procedure gibExtraPunkt;

    property Partei: dkPartei read getPartei;
  end;

implementation

constructor TSpieler.Create(pIP: string);
begin
  FIP := pIP;
  FBlatt := TBlatt.Create;
  FGewonneneStiche := TList.Create;
  FExtraPunkte := 0;
  FSpieltSolo := false;
end;

function TSpieler.getPartei: dkPartei;
begin
  if not FSpieltSolo then result := FBlatt.Partei
    else result := true;
end;

procedure TSpieler.gibExtraPunkt;
begin
  inc(FExtraPunkte);
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

function TSpieler.gewonnenePunkte: Integer;
var i: Integer;
begin
  result := 0;
  for i := 0 to FGewonneneStiche.Count-1 do
  begin
    inc(result, TStich(FGewonneneStiche[i]).getPunkte);
  end;
end;

end.







