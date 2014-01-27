unit mTDoppelkopfSpiel;

interface

uses mTSpielerManager, mTSpieler, mTStich, dialogs, mTDoppelkopfDeck, mTBlatt, mTSoloAnfrage, Classes, mTKarte, StringKonstanten;

type

TDoppelkopfSpiel = class
private
  FSpielerManager: TSpielerManager;
  FAktuellerStich: TStich;
  FRundenNummer: Integer;
  FAktuellerSpielerIndex: Integer;
  FSoloAnfragen: TList;

 (* function playerForIP(pIP: string): TSpieler;
  function playerForName(pName: string): TSpieler;
  function playerForIndex(pIndex: Integer): TSpieler;
  procedure deletePlayerWithIP(pIP: string);
  function countConnectedPlayer: Integer; *)
public
  constructor Create;

  function addPlayer(pIP, pName: string): Boolean;

  function aktuellerSpieler: TSpieler;
  function aktuelleSpielerIP: string;

  procedure starteSpiel;
  function legeKarte(pKartenCode: string; pIP:string): Boolean;
  procedure MacheSoloAnsage(pSpielerIP: string; pAnsageCode: string);
 // function EntscheideWelchesSolo: string;
  //procedure MacheAnsage(pIP: string);
  //Saemtliche Soli implementieren

  function getKartenPunkteRePartei: Integer;
  function getKartenPunkteKontraPartei: Integer;
  function getSiegerPartei: dkPartei;
  function getPunkteVonSieger: Integer;

  property AktuellerStich: TStich read FAktuellerStich;
  property RundenNummer: Integer read FRundenNummer;
end;


implementation

constructor TDoppelkopfSpiel.Create;
begin
  FSpielerManager := TSpielerManager.Create;
  FSoloAnfragen := TList.Create;
end;

procedure TDoppelkopfSpiel.MacheSoloAnsage(pSpielerIP: string; pAnsageCode: string);
var Spieler: TSpieler;
    AnsageArt: dkSpielModus;
begin
  AnsageArt := dkNormal;
  spieler := self.FSpielerManager.playerForIP(pSpielerIP);
  if pAnsageCode = FLEISCHLOSER then AnsageArt := dkFleischloser;
  if pAnsageCode = DAMENSOLO then AnsageArt := dkDamensolo;
  if pAnsageCode = BUBENSOLO then AnsageArt := dkBubensolo;
  if AnsageArt = dkNormal then ShowMessage('Zum Normal-Spielen braucht man keine Ansage?!?');

  self.FSoloAnfragen.Add(TSoloAnfrage.Create(AnsageArt, spieler));
end;

function TDoppelkopfSpiel.getKartenPunkteRePartei: Integer;
var i: Integer;
begin
  result := 0;
  for i := 1 to 4 do
  begin
    if self.FSpielerManager.playerForIndex(i).Partei = Re then
    begin
      inc(result, self.FSpielerManager.playerForIndex(i).gewonnenePunkte);
    end;
  end;
end;

function TDoppelkopfSpiel.getKartenPunkteKontraPartei: integer;
begin
  result := 240 - self.getKartenPunkteRePartei;
end;

function TDoppelkopfSpiel.getSiegerPartei;
begin
  if self.FRundenNummer < 10 then
  begin
    ShowMessage('Spiel noch nicht beendet und schon Sieger wissen wollen?!?');
    result := re;
  end
  else
  begin
    result := Re;
    if self.getKartenPunkteRePartei > 120 then result := Kontra;
  end;
end;

function TDoppelkopfSpiel.getPunkteVonSieger: Integer;
var sieger: dkPartei;
    temp: Integer;
begin
  result := 1;  //Punkt fuer gewonnen
  sieger := self.getSiegerPartei;
  if sieger = Kontra then
  begin
    inc(result);//Extrapunkt wenn Kontra gewinnt
    temp := self.getKartenPunkteKontraPartei - 120;
  end else
  begin
    temp := self.getKartenPunkteRePartei - 120;
  end;
  inc(result, (temp-1) div 30);

  //Extra-Punkte hinzufuegen
  //Multiplikatoren hinzufuegen
end;

function TDoppelkopfSpiel.aktuellerSpieler;
begin
  result := self.FSpielerManager.playerForIndex(self.FAktuellerSpielerIndex mod 4);
end;

function TDoppelkopfSpiel.aktuelleSpielerIP;
begin
  result := self.aktuellerSpieler.IP;
end;

function TDoppelkopfSpiel.legeKarte(pKartenCode: string; pIP: string): Boolean;
var //istLegal: Boolean;
    spieler: TSpieler;
begin
  spieler := self.FSpielerManager.playerForIP(pIP);
  result := spieler.karteLegen(pKartenCode, self.FAktuellerStich);
  //Wenn erfolgreich, ist der nächste Spieler dran
  if result then inc(self.FAktuellerSpielerIndex);
  //Wenn Stich voll...
  if self.FAktuellerStich.kartenCount >= 4 then
  begin
  //Gewinner kriegt seinen Stich
    TSpieler(self.FAktuellerStich.AktuellerSieger).gibGewonnenenStich(self.FAktuellerStich);
    //Sonderpunkte muessen noch ausgewertet werden

    inc(self.FRundenNummer);
    self.FAktuellerStich := TStich.Create(self.FRundenNummer);
  end;
end;

procedure TDoppelkopfSpiel.starteSpiel;
var deck: TDoppelkopfDeck;
    i, k: Integer;
    spieler: TSpieler;
begin
  if not self.FSpielerManager.countConnectedPlayer = 4 then ShowMessage('Nicht korrekte Zahl Spieler');

  //Karten austeilen...
  deck := TDoppelkopfDeck.Create;
  for i := 1 to 4 do
  begin
    spieler := self.FSpielerManager.playerForIndex(i-1);
    for k := 1 to 10 do
    begin
      spieler.gibKarte(deck.getRandomCard);
    end;
  end;

  //1. Stich erstellen
  self.FRundenNummer := 1;
  self.FAktuellerStich := TStich.Create(self.FRundenNummer);

  //1. Spieler markieren
  self.FAktuellerSpielerIndex := 1;
end;

function TDoppelkopfSpiel.addPlayer(pIP, pName: string): Boolean;
var spieler: TSpieler;
begin
  spieler := TSpieler.Create(pIP);
  spieler.Name := pName;
  result := self.FSpielerManager.addPlayer(spieler);
end;

(*function TDoppelkopfSpiel.playerForIP(pIP: string): TSpieler;
begin
  result := self.FSpielerManager.playerForIP(pIP);
end;

function TDoppelkopfSpiel.playerForName(pName: string): TSpieler;
begin
  result := self.FSpielerManager.playerForName(pName);
end;

function TDoppelkopfSpiel.playerForIndex(pIndex: Integer): TSpieler;
begin
  result := self.FSpielerManager.playerForIndex(pIndex);
end;

procedure TDoppelkopfSpiel.deletePlayerWithIP(pIP: string);
begin
  self.FSpielerManager.deletePlayerWithIP(pIP);
end;

function TDoppelkopfSpiel.countConnectedPlayer;
begin
  result := self.FSpielerManager.countConnectedPlayer;
end;  *)

end.
