unit mTSpieler;

interface

uses Classes, SysUtils, mTBlatt, mTKarte, dialogs, mTStich, Contnrs;

type
  TSpieler = class
  private
    FIsIndexSet: Boolean;
    FIndex: Integer;
    FSpieltSolo: Boolean;
    FName: string;
    FIP: string;
    FBlatt: TBlatt;
    FGewonneneStiche: TObjectList;
    FExtraPunkte: Integer;
    function getPartei: dkPartei;
  public
    procedure setIndex(pIndex: Integer);
    constructor Create(pIP: string);
    property Name: string read FName write FName;
    property IP: string read FIP;
    property ExtraPunkte: Integer read FExtraPunkte;
    property SpielerIndex: Integer read FIndex;

    procedure gibKarte(pKarte: TKarte);
    function karteLegen(pKartenCode: string; pStich: TStich): Boolean;

    procedure gibGewonnenenStich(pStich: TStich);

    function gewonnenePunkte: Integer;
    procedure gibExtraPunkt;

    property Partei: dkPartei read getPartei;

    procedure setSpielModus(pModus: dkSpielModus);
    procedure macheZumSolisten;

    function getKarten: TStringList;
  end;

implementation

constructor TSpieler.Create(pIP: string);
begin
  FIndex := -1;
  FIsIndexSet := false;
  FIP := pIP;
  FBlatt := TBlatt.Create;
  FGewonneneStiche := TObjectList.Create;
  FGewonneneStiche.OwnsObjects := False;
  FExtraPunkte := 0;
  FSpieltSolo := false;
end;

function TSpieler.getKarten;
begin
  result := FBlatt.getKarten;
end;

procedure TSpieler.macheZumSolisten;
begin
  self.FSpieltSolo := true;
end;

procedure TSpieler.setIndex(pIndex: Integer);
begin
  if not self.FIsIndexSet then
  begin
    self.FIndex := pIndex;
    self.FIsIndexSet := true;
  end else
  begin
    ShowMessage('Ein SpielerIndex kann kein zweites Mal gesetzt werden!');
  end;
end;

procedure TSpieler.setSpielModus(pModus: dkSpielModus);
begin
  self.FBlatt.setSpielModus(pModus);
end;

function TSpieler.getPartei: dkPartei;
begin
  if not FSpieltSolo then result := FBlatt.Partei
    else result := dkRe;
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







