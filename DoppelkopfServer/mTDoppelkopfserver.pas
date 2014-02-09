unit mTDoppelkopfserver;

interface

uses Sysutils, classes, mTServer, mTNetworkMessage, mTSpieler, mTDoppelkopfSpiel, StringKonstanten;

type

TDoppelkopfServer = class(TServer)
private
  procedure processConnect(pClientIP: string; pMessage: TNetworkMessage);
  procedure processSpielbeginn(pClientIP: string; pMessage: TNetworkMessage);
  procedure processKarten(pClientIP: string; pMessage: TNetworkMessage);
  procedure processVorbehalteAbfragen (pClientIP: string; pMessage: TNetworkMessage);
  procedure processDamensolo (pClientIP: string; pMessage: TNetworkMessage);
  procedure processBubensolo (pClientIP: string; pMessage: TNetworkMessage);
  procedure processFleischloser (pClientIP: string; pMessage: TNetworkMessage);
  procedure processHochzeit (pClientIP: string; pMessage: TNetworkMessage);
  procedure processSolo (pClientIP: string; pMessage: TNetworkMessage);
  procedure processSoloBestaetigen (pClientIP: string; pMessage: TNetworkMessage);
  procedure processWelcheKarte (pClientIP: string; pMessage: TNetworkMessage);
  procedure processWelcheKarteBestaetigen (pClientIP: string; pMessage: TNetworkMessage);
  procedure processAktuellerStich (pClientIP: string; pMessage: TNetworkMessage);
  procedure processGewinnerStich (pClientIP: string; pMessage: TNetworkMessage);
  procedure processGewinnerSpiel (pClientIP: string; pMessage: TNetworkMessage);
  procedure processAnsage (pClientIP: string; pMessage: TNetworkMessage);
  procedure processAnsageGemacht (pClientIP: string;pMessage: TNetworkMessage);
  //procedure processUngueltigeKarte (pClientIP: string; pMessage: TNetworkMessage);
public
  constructor Create(pPortNr: Integer);
  destructor Destroy; override;
  procedure ProcessMessage(pMessage: string; pSenderIP: string); override;
  procedure ClientHasConnected(pClientIP: string); override;
  procedure ClientHasDisconnected(pClientIP: string); override;
end;

implementation

constructor TDoppelkopfServer.Create(pPortNr: Integer);
begin
  inherited Create(pPortNr);
  //FSpielerManager := TSpielerManager.Create;
end;

destructor TDoppelkopfServer.Destroy;
begin
//FSpielerManager.Free;
  inherited Destroy;
end;

procedure TDoppelkopfServer.ClientHasConnected(pClientIP: string);
//var spieler: TSpieler;
begin
  //Spieler := TSpieler.create(pClientIP);
  //FSpielerManager.addPlayer(Spieler);
end;

procedure TDoppelkopfServer.ClientHasDisconnected(pClientIP: string);
begin

end;

procedure TDoppelkopfServer.ProcessMessage(pMessage: string; pSenderIP: string);
var msg: TNetworkMessage;
    s: string;
begin
  msg := TNetworkMessage.Create(pMessage);
  if (msg.key = CONNECT) then
  begin
    self.processConnect(pSenderIP, msg);
  end;
  if (msg.key = ANSAGE) then
  begin
    self.processAnsage(pSenderIP, msg);
  end;
  if (msg.key = SPIELBEGINN) then
  begin
    self.processSpielbeginn(pSenderIP, msg);
  end;
  if (msg.key = KARTEN) then
  begin
    self.processKarten(pSenderIP, msg);
  end;
  if (msg.key = VORBEHALTE_ABFRAGEN) then
  begin
    self.processVorbehalteAbfragen(pSenderIP, msg);
  end;
  if (msg.key = VORBEHALT_DAMENSOLO) then
  begin
    self.processDamensolo(pSenderIP, msg);
  end;
  if (msg.key = VORBEHALT_BUBENSOLO) then
  begin
    self.processBubensolo(pSenderIP, msg);
  end;
  if (msg.key = VORBEHALT_FLEISCHLOSER) then
  begin
    self.processFleischloser(pSenderIP, msg);
  end;
  if (msg.key = VORBEHALT_HOCHZEIT) then
  begin
    self.processHochzeit(pSenderIP, msg);
  end;
  if (msg.key = SOLO) then
  begin
    self.processSolo(pSenderIP, msg);
  end;
  if (msg.key = SOLO_BESTAETIGEN) then
  begin
    self.processSoloBestaetigen(pSenderIP, msg);
  end;
  if (msg.key = WELCHE_KARTE) then
  begin
    self.processWelcheKarte(pSenderIP, msg);
  end;
  if (msg.key = WELCHE_KARTE_BESTAETIGEN) then
  begin
    self.processWelcheKarteBestaetigen(pSenderIP, msg);
  end;
  if (msg.key = AKTUELLER_STICH) then
  begin
    self.processAktuellerStich(pSenderIP, msg);
  end;
  if (msg.key = GEWINNER_STICH) then
  begin
    self.processGewinnerStich(pSenderIP, msg);
  end;
  if (msg.key = GEWINNER_SPIEL) then
  begin
    self.processGewinnerSpiel(pSenderIP, msg);
  end;
  if (msg.key = ANSAGE_GEMACHT) then
  begin
    self.processAnsageGemacht(pSenderIP, msg);
  end;
end;


procedure TDoppelkopfServer.processSpielbeginn(pClientIP: string;pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processKarten(pClientIP: string;pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processVorbehalteAbfragen (pClientIP: string;pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processDamensolo (pClientIP: string;pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processBubensolo (pClientIP: string;pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processFleischloser (pClientIP: string;pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processHochzeit (pClientIP: string;pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processSolo (pClientIP: string;pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processWelcheKarte (pClientIP: string;pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processAktuellerStich (pClientIP: string;pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processGewinnerStich (pClientIP: string;pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processGewinnerSpiel (pClientIP: string;pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processAnsage (pClientIP: string;pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processAnsageGemacht (pClientIP: string;pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processConnect(pClientIP: string; pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processSoloBestaetigen(pClientIP: string; pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processWelcheKarteBestaetigen(pClientIP: string; pMessage: TNetworkMessage);
begin

end;



end.
