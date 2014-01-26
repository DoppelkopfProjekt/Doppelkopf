unit mTBlatt;

interface

uses classes, sysutils, mTKarte, mTStich, dialogs, types;

type

TBlatt = class
private
  FKarten: TList;

  function istTrumpfInBlatt: Boolean;
  function getAnzahlTrumpfInBlatt: Integer;
  function istFehlfarbeInBlatt(pFarbe: dkFarbe): Boolean;
  function getAnzahlFehlfarbeInBlatt(pFarbe: dkFarbe): Integer;
public
  constructor Create;
  function istZugLegal(pKarte: TKarte; pStich: TStich): Boolean;
  procedure KarteHinzufuegen(pKarte: TKarte);
  procedure LegeKarte(pKarte: TKarte);
end;

implementation

constructor TBlatt.Create;
begin
  FKarten.Create;
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
  if not pStich.istErsteKarteTrumpf and not (pStich.getFarbeVonErsterKarte = Keine) then
  begin
    if (not (pStich.getFarbeVonErsterKarte = pKarte.Farbe))
      and self.istFehlfarbeInBlatt(pStich.getFarbeVonErsterKarte) then result := false;
  end;
end;

procedure TBlatt.KarteHinzufuegen(pKarte: TKarte);
begin
  FKarten.Add(pKarte);
  if FKarten.Count > 10 then ShowMessage('Zu viele Karten ausgeteilt!');
end;

end.
