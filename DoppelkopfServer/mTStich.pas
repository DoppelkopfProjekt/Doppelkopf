unit mTStich;

interface

uses Sysutils, classes, mTSpieler, mTKarte, Dialogs;

type
TStich = class

private
FSpielerListe: TList;
FAktuellerStich: TList;
FAktuellerSieger: TSpieler;
FAktuellBesteKarte: TKarte;
FAktuellerSpieler: TSpieler;
FNummer: Integer;
public
property AktuellerSieger: TSpieler read FAktuellerSieger;
procedure AddSpieler(pSpieler: TSpieler);
procedure LegeKarte(pKarte: TKarte; pLegenderSpieler: TSpieler);
constructor Create(pNummer: Integer);
end;

implementation

constructor TStich.Create(pNummer: Integer);
begin
  FAktuellerSieger := nil;
  FAktuellBesteKarte := nil;
  FAktuellerStich := TList.Create;
  FSpielerListe := TList.Create;
  FNummer := pNummer;
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
  if FAktuellerStich.Count >= 4 then ShowMessage('5 Karten auf einem Stich!?!');

  FAktuellerStich.add(pKarte);
  if not (FSpielerListe[FAktuellerStich.Count-1] = pLegenderSpieler) then ShowMessage('Der falsche Spieler legt die Karte!?!');
  if FAktuellerStich.count = 1 then
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
      if (pKarte.Code = 'HE10') and not (FNummer = 10) then
      begin
        FAktuellerSieger := pLegenderSpieler;
        FAktuellBesteKarte := pKarte;
       end;
     //Ansonsten gewinnt die zuerst gelegte Karte
    end;
  end;
end;

end.
