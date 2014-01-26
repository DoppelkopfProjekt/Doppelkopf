unit mTStich;

interface

uses Sysutils, classes, mTSpieler, mTKarte, Dialogs;

type
TStich = class

private
FSpielerListe: TList;
FKarten: TList;
FAktuellerSieger: TSpieler;
FAktuellBesteKarte: TKarte;
FAktuellerSpieler: TSpieler;
FNummer: Integer;
public
function getIstErsteKarteTrumpf: Boolean;
property AktuellerSieger: TSpieler read FAktuellerSieger;
property IstErsteKarteKarteTrumpf: Boolean read getIstErsteKarteTrumpf;
procedure AddSpieler(pSpieler: TSpieler);
procedure LegeKarte(pKarte: TKarte; pLegenderSpieler: TSpieler);
constructor Create(pNummer: Integer);
end;

implementation

constructor TStich.Create(pNummer: Integer);
begin
  FAktuellerSieger := nil;
  FAktuellBesteKarte := nil;
  FKarten := TList.Create;
  FSpielerListe := TList.Create;
  FNummer := pNummer;
end;

function TStich.getIstErsteKarteTrumpf: Boolean;
begin
  if FKarten.Count = 0 then result := false else result := TKarte(FKarten[0]).IstTrumpf;
end;

procedure TStich.AddSpieler(pSpieler: TSpieler);
begin
if FSpielerListe.count >= 4 then ShowMessage('Zu viele Spieler')
  else
  begin
    FSpielerListe.add(pSpieler);
  end;
end;

procedure TStich.LegeKarte(pKarte: TKarte; pLegenderSpieler: TSpieler);
var Ergebnis: dkErgebnis;
begin
  if FSpielerListe.Count = 4 then ShowMessage('Keine 4 Spieler zum Stich hinzugefügt!');
  if FKarten.count >= 4 then ShowMessage('5 Karten auf einem Stich!?!');

  FKarten.add(pKarte);
  if not (FSpielerListe[FKarten.count-1] = pLegenderSpieler) then ShowMessage('Der falsche Spieler legt die Karte!?!');
  if FKarten.count = 1 then
  begin
    FAktuellerSieger := FSpielerListe[0];
    FAktuellBesteKarte := pKarte;
  end else
  begin
    Ergebnis := FAktuellBesteKarte.kannKarteMichStechen(pKarte);
    if Ergebnis = staerker then
    begin
      FAktuellerSieger := pLegenderSpieler;
      FAktuellBesteKarte := pKarte;
    end;
    if Ergebnis = gleich then
    begin
      if (pKarte.Code = 'HE10') and not (FNummer = 10) and (pKarte.SpielModus = Normal) then
      begin
        FAktuellerSieger := pLegenderSpieler;
        FAktuellBesteKarte := pKarte;
       end;
     //Ansonsten gewinnt die zuerst gelegte Karte
    end;
  end;
end;

end.
