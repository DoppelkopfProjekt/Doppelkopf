unit mTDoppelkopfSpiel;

interface

uses mTSpielerManager, mTSpieler, mTStich, dialogs, mTDoppelkopfDeck, mTBlatt, mTSoloAnfrage, Classes, mTKarte, StringKonstanten;

type

dkAnsage = (dkSchwarz, dkKeine3, dkKeine6, dkKeine9, dkRe, dkKontra);

TDoppelkopfSpiel = class
private
  FSpielerManager: TSpielerManager;
  FAktuellerStich: TStich;
  FRundenNummer: Integer;
  FAktuellerSpielerIndex: Integer;
  FSoloAnfragen: TList;

  FSpielModus: dkSpielModus;
  FSolistIP: string;
  FZahlGelegteKarten: Integer;

  procedure setSpielModus(pModus: dkSpielModus);
  function countConnectedPlayer: Integer;

  function aktuellerSpieler: TSpieler;
public
  constructor Create;

  function addPlayer(pIP, pName: string): Boolean;

  function aktuellerSpielerName: string;
  function aktuelleSpielerIP: string;
  function NameForSpielerIP(pIP: string): string;
  function SpielerIPForName(pName: string): string;

  procedure starteSpiel;
  function legeKarte(pKartenCode: string; pIP:string): Boolean;
  procedure MacheSoloAnsage(pSpielerIP: string; pAnsageCode: string);
  procedure EntscheideWelchesSolo;
  //procedure MacheAnsage(pIP: string, pArt: dkAnsage);

  function getKartenPunkteRePartei: Integer;
  function getKartenPunkteKontraPartei: Integer;
  function getSiegerPartei: dkPartei;
  function getPunkteVonSieger: Integer;

  property AktuellerStich: TStich read FAktuellerStich;
  property RundenNummer: Integer read FRundenNummer;
  property SpielModus: dkSpielModus read FSpielModus;
  property SolistIP: string read FSolistIP; //Gibt '' zurueck wenn kein Solo gespielt wird
  property ZahlGelegteKarten: Integer read FZahlGelegteKarten;
end;


implementation

constructor TDoppelkopfSpiel.Create;
begin
  FSpielerManager := TSpielerManager.Create;
  FSoloAnfragen := TList.Create;
  FSolistIP := '';
  FSpielModus := dkNormal;
  self.FZahlGelegteKarten := 0;
end;

procedure TDoppelkopfSpiel.setSpielModus(pModus: dkSpielModus);
var i: Integer;
begin
  for i := 1 to 4 do
  begin
    self.FSpielerManager.playerForIndex(i).setSpielModus(pModus);
  end;
end;

procedure TDoppelkopfSpiel.EntscheideWelchesSolo;
var i: Integer;
    anfrage, wichtigsteAnfrage: TSoloAnfrage;
begin
  if self.FZahlGelegteKarten > 0 then
  begin
    ShowMessage('Zu sp�t um Solo zu bestimmen');
    exit;
  end;
  if self.FSoloAnfragen.Count > 1 then
  begin
    wichtigsteAnfrage := self.FSoloAnfragen[0];
    for i := 1 to self.FSoloAnfragen.Count-1 do
    begin
      anfrage := self.FSoloAnfragen[i];
      if anfrage.Prioritaet > wichtigsteAnfrage.Prioritaet then
      begin
        wichtigsteAnfrage := anfrage;
      end;
    end;
    self.setSpielModus(wichtigsteAnfrage.Art);
    self.FSolistIP := wichtigsteAnfrage.Sender.IP;
    wichtigsteAnfrage.Sender.macheZumSolisten;
  end;
end;

procedure TDoppelkopfSpiel.MacheSoloAnsage(pSpielerIP: string; pAnsageCode: string);
var Spieler: TSpieler;
    AnsageArt: dkSpielModus;
begin
  if self.FZahlGelegteKarten > 0 then
  begin
    ShowMessage('Zu sp�t um Solo anzusagen');
    exit;
  end;
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

function TDoppelkopfSpiel.getSiegerPartei: dkPartei;
begin
  if (self.FRundenNummer < 10) and (self.ZahlGelegteKarten < 40) then
  begin
    ShowMessage('Spiel noch nicht beendet und schon Sieger wissen wollen?!?');
    result := Re;
  end
  else
  begin
    result := Re;getSiegerPartei;
    if self.getKartenPunkteKontraPartei >= 120 then result := Kontra;
  end;
end;

function TDoppelkopfSpiel.getPunkteVonSieger: Integer;
var sieger: dkPartei;
    temp, i: Integer;
    spieler: TSpieler;
begin
  result := 1;  //Punkt fuer gewonnen
  sieger := self.getSiegerPartei;
  if sieger = Kontra then
  begin
    inc(result);//Extrapunkt wenn Kontra gewinnt
    temp := self.getKartenPunkteRePartei;
  end else
  begin
    temp := self.getKartenPunkteKontraPartei;
  end;
  inc(result, (temp-1) div 30);

  //Extrapunkte
  for i := 1 to 4 do
  begin
    spieler := self.FSpielerManager.playerForIndex(i);
    if spieler.Partei = sieger then
    begin
      inc(result, spieler.ExtraPunkte);
    end else
    begin
      dec(result, spieler.ExtraPunkte);
    end;
  end;
  //Multiplikatoren hinzufuegen
end;

function TDoppelkopfSpiel.aktuellerSpieler: TSpieler;
begin
  result := self.FSpielerManager.playerForIndex(self.FAktuellerSpielerIndex mod 4);
end;

function TDoppelkopfSpiel.aktuellerSpielerName:string;
begin
  result := self.aktuellerSpieler.Name;
end;

function TDoppelkopfSpiel.aktuelleSpielerIP:string;
begin
  result := self.aktuellerSpieler.IP;
end;

function TDoppelkopfSpiel.NameForSpielerIP(pIP: string): string;
begin
  result := self.FSpielerManager.playerForIP(pIP).Name;
end;

function TDoppelkopfSpiel.SpielerIPForName(pName: string): string;
begin
  result := self.FSpielerManager.playerForName(pName).Name;
end;

function TDoppelkopfSpiel.legeKarte(pKartenCode: string; pIP: string): Boolean;
var //istLegal: Boolean;
    spieler: TSpieler;
begin
  spieler := self.FSpielerManager.playerForIP(pIP);
  result := spieler.karteLegen(pKartenCode, self.FAktuellerStich);
  //Wenn erfolgreich, ist der n�chste Spieler dran
  if result then
  begin
    inc(self.FAktuellerSpielerIndex);
    inc(self.FZahlGelegteKarten);
  end;
  //Wenn Stich voll...
  if self.FAktuellerStich.kartenCount >= 4 then
  begin
  //Gewinner kriegt seinen Stich
    TSpieler(self.FAktuellerStich.AktuellerSieger).gibGewonnenenStich(self.FAktuellerStich);

    inc(self.FRundenNummer);
    self.FAktuellerStich := TStich.Create(self.FRundenNummer);
  end;
end;

procedure TDoppelkopfSpiel.starteSpiel;
var deck: TDoppelkopfDeck;
    i, k: Integer;
    spieler: TSpieler;
begin
  if not self.FSpielerManager.countConnectedPlayer = 4 then
  begin
    ShowMessage('Nicht korrekte Zahl Spieler');
    exit;
  end;

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

function TDoppelkopfSpiel.countConnectedPlayer;
begin
  result := self.FSpielerManager.countConnectedPlayer;
end;

end.
