unit mTDoppelkopfSpiel;

interface

uses mTSpielerManager, mTSpieler, mTStich, dialogs, mTDoppelkopfDeck;

type

TDoppelkopfSpiel = class
private
  FSpielerManager: TSpielerManager;
  FAktuellerStich: TStich;
  FRundenNummer: Integer;
  FAktuellerSpielerIndex: Integer;

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
end;


implementation

constructor TDoppelkopfSpiel.Create;
begin
  FSpielerManager := TSpielerManager.Create;
end;

function TDoppelkopfSpiel.aktuellerSpieler;
begin
  result := self.FSpielerManager.playerForIndex(self.FAktuellerSpielerIndex mod 4);
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
    //Sonderpunkte müssen noch ausgewertet werden

    inc(self.FRundenNummer);
    self.FAktuellerStich := TStich.Create(self.FRundenNummer);
  end;
end;

function TDoppelkopfSpiel.aktuelleSpielerIP;
begin
  result := self.aktuellerSpieler.IP;
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
