unit mTStich;

interface

uses Sysutils, classes, mTKarte, Dialogs, mTSonderkarteEreignis, Contnrs;

type

TStich = class

private
  FSpielerListe: TObjectList;
  FKarten: TObjectList;
  FAktuellerSieger: TObject;
  FAktuellBesteKarte: TKarte;
  //FAktuellerSpieler: TObject;
  FNummer: Integer;
 // FReSonderPunkte: Integer;//Kann negativ werden
  FSonderkarten: TObjectList;

  procedure erkenneSonderKarten(pNeueKarte: TKarte; pSpieler: TObject);
  procedure verarbeiteSonderPunkte;
public
  function istErsteKarteTrumpf: Boolean;
  function getFarbeVonErsterKarte: dkFarbe;
  function kartenCount: Integer;
  property AktuellerSieger: TObject read FAktuellerSieger;
  procedure AddSpieler(pSpieler: TObject);
  procedure LegeKarte(pKarte: TKarte; pLegenderSpieler: TObject);
  constructor Create(pNummer: Integer);

  function getGelegteKarten: TStringList;

  function getPunkte: Integer;
end;

implementation

uses mTSpieler;

constructor TStich.Create(pNummer: Integer);
begin
  FSonderkarten := TObjectList.Create;
  FSonderkarten.OwnsObjects := False;
  FAktuellerSieger := nil;
  FAktuellBesteKarte := nil;
  FKarten := TObjectList.Create;
  FKarten.OwnsObjects := False;
  FSpielerListe := TObjectList.Create;
  FSpielerListe.OwnsObjects := False;
  FNummer := pNummer;
end;

function TStich.getGelegteKarten;
var i: Integer;
begin
  result := TStringList.Create;
  for i := 0 to self.FKarten.Count-1 do
  begin
    result.Add(TKarte(self.FKarten[i]).Code);
  end;
end;

procedure TStich.erkenneSonderKarten(pNeueKarte: TKarte; pSpieler: Tobject);
begin
  //Fuchs
  if pNeueKarte.Code = 'KAA' then self.FSonderkarten.Add(TSonderkarteEreignis.Create(pNeueKarte, pSpieler));
  //Karlchen
  if (self.FNummer = 10) and (pNeueKarte.Code = 'KRB') then self.FSonderkarten.Add(TSonderkarteEreignis.Create(pNeueKarte, pSpieler));
end;

procedure TStich.verarbeiteSonderPunkte;
var i, counter: Integer;
    SonderkarteEreignis: TSonderKarteEreignis;
    karte: TKarte;
    spieler: TSpieler;
begin
  for i := 0 to self.FSonderkarten.Count-1 do
  begin
    SonderkarteEreignis := TSonderkarteEreignis(FSonderkarten[i]);
    karte := sonderkarteEreignis.Karte;
    spieler := sonderkarteEreignis.spieler;
    //Fuchs verarbeiten
    if karte.Code = 'KAA' then
    begin
      if not (karte = self.FAktuellBesteKarte) and not (spieler.partei = TSpieler(self.FaktuellerSieger).partei) then
      begin
        TSpieler(self.FAktuellerSieger).gibExtraPunkt;
      end;
    end;
    //Karlchen verarbeiten
    if karte.Code = 'KRB' then
    begin
      if (karte = self.FAktuellerSieger) then
      begin
        TSpieler(self.FAktuellerSieger).gibExtraPunkt;
      end;
      if not (karte = self.FAktuellBesteKarte) and (spieler.partei = TSpieler(self.FaktuellerSieger).partei) then
      begin
        TSpieler(self.FAktuellerSieger).gibExtraPunkt;
      end;
    end;
  end;
  //Doppelk�pfe erkennen
  counter := 0;
  for i := 0 to 3 do
  begin
    karte := TKarte(self.FKarten[i]);
    inc(counter, karte.Punkte);
  end;
  if counter >= 40 then
  begin
    TSpieler(self.FAktuellerSieger).gibExtraPunkt;
  end;
end;

function TStich.kartenCount: Integer;
begin
  result := self.FKarten.Count;
end;

function TStich.getPunkte: integer;
var i: Integer;
begin
  result := 0;
  for i := 0 to FKarten.Count-1 do
  begin
    inc(result, TKarte(FKarten[i]).Punkte);
  end;
end;

function TStich.istErsteKarteTrumpf: Boolean;
begin
  if FKarten.Count = 0 then result := false else result := TKarte(FKarten[0]).IstTrumpf;
end;

function TStich.getFarbeVonErsterKarte: dkFarbe;
begin
  if FKarten.Count = 0 then result := dkKeine else result := TKarte(FKarten[0]).farbe;
end;

procedure TStich.AddSpieler(pSpieler: TObject);
begin
if FSpielerListe.count >= 4 then ShowMessage('Zu viele Spieler')
  else
  begin
    FSpielerListe.add(pSpieler);
  end;
end;

procedure TStich.LegeKarte(pKarte: TKarte; pLegenderSpieler: TObject);
var Ergebnis: dkErgebnis;
begin
  if FSpielerListe.Count = 4 then ShowMessage('Keine 4 Spieler zum Stich hinzugef�gt!');
  if FKarten.count >= 4 then ShowMessage('5 Karten auf einem Stich!?!');

  FKarten.add(pKarte);
  self.erkenneSonderKarten(pKarte, pLegenderSpieler);
  if not (FSpielerListe[FKarten.count-1] = pLegenderSpieler) then ShowMessage('Der falsche Spieler legt die Karte!?!');
  if FKarten.count = 1 then
  begin
    FAktuellerSieger := FSpielerListe[0];
    FAktuellBesteKarte := pKarte;
  end else
  begin
    Ergebnis := FAktuellBesteKarte.kannKarteMichStechen(pKarte);
    if Ergebnis = dkstaerker then
    begin
      FAktuellerSieger := pLegenderSpieler;
      FAktuellBesteKarte := pKarte;
    end;
    if Ergebnis = dkgleich then
    begin
      if (pKarte.Code = 'HE10') and not (FNummer = 10) and (pKarte.SpielModus = dkNormal) then
      begin
        FAktuellerSieger := pLegenderSpieler;
        FAktuellBesteKarte := pKarte;
       end;
     //Ansonsten gewinnt die zuerst gelegte Karte
    end;
  end;
  if self.FKarten.Count = 4 then self.verarbeiteSonderPunkte;
end;

end.
