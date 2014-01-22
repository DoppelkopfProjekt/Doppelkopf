unit mTStich;

interface

uses Sysutils, classes, mTSpieler, mTKarte;

type
TStich = class

private
FSpielerListe: TList;
FAktuellerStich: TList;
FAktuellerSieger: TSpieler;
FAktuellBesteKarte: TKarte;
public
property AktuellerSieger: TSpieler read FAktuellerSieger;
procedure AddSpieler(pSpieler: TSpieler);
procedure LegeKarte(pKarte: TKarte, pLegenderSpieler: TSpieler);
end;

implementation

constructor TStich.Create;
begin
  FAktuellerSieger := nil;
  FAktuellBesteKarte := nil;
  FAktuellerStich := TList.Create;
  FSpielerListe := TList.Create;
end;

procedure TStich.AddSpieler(pSpieler: TSpieler);
begin
if FSpielerListe.count >= 4 then ShowMessage('Zu viele Spieler')
  else
  begin
    FSpielerListe.add(pSpieler);
  end;
end;

procedure TStich.LegeKarte(pKarte: TKarte, pLegenderSpieler: TSpieler)
begin
if FAktuellerStich.Count >= 4 then ShowMessage('5 Karten auf einem Stich!?!);
FAktuellerStich.add(pKarte: TKarte);
if not FAktuellerSpieler[FAktuellerStich.count-1] = pLegenderSpieler then ShowMessage('Der falsche Spieler legt die Karte!?!');
if FAktuellerStich.count = 1 then
begin
  FAktuellerSieger := FSpielerListe[0];
  FAktuellBesteKarte := pKarte;
end;

end;

end.
