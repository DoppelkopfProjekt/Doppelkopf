unit mTBlatt;

interface

uses classes, sysutils, mTKarte, mTStich, dialogs, types, contnrs;

type

dkPartei = (dkRe, dkKontra);

TBlatt = class
private
  FKarten: TObjectList;
  FPartei: dkPartei;
  function istTrumpfInBlatt: Boolean;
  function getAnzahlTrumpfInBlatt: Integer;
  function istFehlfarbeInBlatt(pFarbe: dkFarbe): Boolean;
  function getAnzahlFehlfarbeInBlatt(pFarbe: dkFarbe): Integer;
  procedure bestimmePartei: dkPartei;
public
  constructor Create;
  function getKarteMitCode(pCode: string): TKarte;
  function istZugLegal(pKarte: TKarte; pStich: TStich): Boolean;
  procedure KarteHinzufuegen(pKarte: TKarte);
  procedure LegeKarte(pKarte: TKarte);
  property Partei: dkPartei read FPartei;
  procedure setSpielModus(pModus: dkSpielModus);
  function getKarten: TStringList;
end;

implementation

constructor TBlatt.Create;
begin
  FKarten := TObjectList.Create;
  FKarten.OwnsObjects := False;
end;

function TBlatt.getKarten: TStringList;
var i: Integer;
begin
  result := TStringList.Create;
  for i := 0 to 9 do
  begin
    result.add(TKarte(FKarten[i]).Code);
  end;
end;

procedure TBlatt.setSpielModus(pModus: dkSpielModus);
var i: Integer;
begin
  if not self.FKarten.Count = 10 then ShowMessage('Kein Solo wenn Spiel l�uft');

  for i := 0 to 9 do
  begin
    TKarte(FKarten[i]).SpielModus := pModus;
  end;
end;

procedure TBlatt.bestimmePartei;
var i: Integer;
begin
  self.FPartei := dkKontra;
  //Partei muss bestimmt werden, wenn alle Karten da sind
  for i := 0 to 9 do
  begin
    if TKarte(FKarten[i]).Code = 'KRD' then self.FPartei := dkRe;
  end;
end;

function TBlatt.getKarteMitCode(pCode: string): TKarte;
var i: Integer;
begin
  result := nil;
  for i := 0 to FKarten.Count -1 do
  begin
    if TKarte(FKarten[i]).Code = pCode then
    begin
      result := TKarte(FKarten[i]);
      break;
    end;
  end;
end;

procedure TBlatt.LegeKarte(pKarte: TKarte);
begin
  FKarten.Remove(pKarte);
end;

function TBlatt.getAnzahlTrumpfInBlatt: Integer;
var i, count: Integer;
begin
  count := 0;
  for i := 0 to FKarten.Count -1 do
  begin
    if TKarte(FKarten[i]).IstTrumpf then
    begin
      inc(count);
    end;
  end;
  result := count;
end;

function TBlatt.getAnzahlFehlfarbeInBlatt(pFarbe: dkFarbe): Integer;
var i, count: Integer;
    karte: TKarte;
begin
  count := 0;
  for i := 0 to FKarten.Count -1 do
  begin
    karte := TKarte(FKarten[i]);
    if not karte.IstTrumpf and (karte.Farbe = pFarbe) then
    begin
      inc(count);
    end;
  end;
  result := count;
end;

function TBlatt.istTrumpfInBlatt: Boolean;
begin
  result := false;
  if self.getAnzahlTrumpfInBlatt > 0 then result := true;
end;

function TBlatt.istFehlfarbeInBlatt(pFarbe: dkFarbe): Boolean;
begin
  result := false;
  if self.getAnzahlFehlfarbeInBlatt(pFarbe) > 0 then result := true;
end;

function TBlatt.istZugLegal(pKarte: TKarte; pStich: TStich): Boolean;
begin
  result := true;
  if pStich.istErsteKarteTrumpf and not pKarte.IstTrumpf and self.istTrumpfInBlatt then result := false;
  if not pStich.istErsteKarteTrumpf and not (pStich.getFarbeVonErsterKarte = dkKeine) then
  begin
    if ((pStich.getFarbeVonErsterKarte <> pKarte.Farbe) or pKarte.IstTrumpf)
      and self.istFehlfarbeInBlatt(pStich.getFarbeVonErsterKarte) then result := false;
  end;
end;

procedure TBlatt.KarteHinzufuegen(pKarte: TKarte);
begin
  FKarten.Add(pKarte);
  if FKarten.Count > 10 then ShowMessage('Zu viele Karten ausgeteilt!');
  if self.FKarten.Count = 10 then self.bestimmePartei;
end;

end.
