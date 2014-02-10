unit mTDoppelkopfserver;

interface

uses Sysutils, mTKarte, Types, classes, mTServer, mTNetworkMessage, StdCtrls, mTSpieler, mTDoppelkopfSpiel, StringKonstanten, Contnrs, mTExpectedTransmissionConfirmation, ExtCtrls, dialogs;

const TimeOut = 0.3;

type

TDoppelkopfServer = class(TServer)
private
  FSpiel: TDoppelkopfSpiel;
  FTransmissionConfirmations: TObjectList;
  FTimer: TTimer;
  FConfirmationSpielbeginnCounter: Integer;
  FConfirmationKartenCounter: Integer;
  FConfirmatinVorbehaltAnmeldenCounter: Integer;

  procedure sendCardsToClientWithIndex(pIndex: Integer);

  procedure processConnect(pClientIP: string; pMessage: TNetworkMessage);
  procedure processSpielbeginn(pClientIP: string; pMessage: TNetworkMessage);
  procedure processKarten(pClientIP: string; pMessage: TNetworkMessage);
  procedure processVorbehaltAnmelden (pClientIP: string; pMessage: TNetworkMessage);
  procedure processVorbehalteAbfragen (pClientIP: string; pMessage: TNetworkMessage);
  (*procedure processDamensolo (pClientIP: string; pMessage: TNetworkMessage);
  procedure processBubensolo (pClientIP: string; pMessage: TNetworkMessage);
  procedure processFleischloser (pClientIP: string; pMessage: TNetworkMessage);
  procedure processHochzeit (pClientIP: string; pMessage: TNetworkMessage); *)
  procedure processSolo (pClientIP: string; pMessage: TNetworkMessage);
  procedure processSoloBestaetigen (pClientIP: string; pMessage: TNetworkMessage);
  procedure processWelcheKarte (pClientIP: string; pMessage: TNetworkMessage);
  procedure processKarteLegen (pClientIP: string; pMessage: TNetworkMessage);
  procedure processAktuellerStich (pClientIP: string; pMessage: TNetworkMessage);
  procedure processGewinnerStich (pClientIP: string; pMessage: TNetworkMessage);
  procedure processGewinnerSpiel (pClientIP: string; pMessage: TNetworkMessage);
  procedure processAnsage (pClientIP: string; pMessage: TNetworkMessage);
  procedure processAnsageGemacht (pClientIP: string;pMessage: TNetworkMessage);

  procedure processConfirmation(pConfirmationMessage: string; pSenderIP: string);
  procedure processTransmissionConfirmations(sender: TObject);
public
  MeLog: TMemo;

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
  FSpiel := TDoppelkopfSpiel.Create;
  FTransmissionConfirmations := TObjectList.Create;
  FTimer := TTimer.Create(nil);
  FTimer.Interval := 100;
  FTimer.Enabled := True;
  FTimer.Enabled := False;
  FTimer.OnTimer := processTransmissionConfirmations;
  self.FConfirmationSpielbeginnCounter := 1;
  self.FConfirmationKartenCounter := 1;
  self.FConfirmatinVorbehaltAnmeldenCounter := 1;
end;

procedure TDoppelkopfServer.ClientHasConnected(pClientIP: string);
begin
  ShowMessage('Client-IP ist ' + pClientIP);
end;

procedure TDoppelkopfServer.processTransmissionConfirmations(sender: TObject);
var i: Integer;
    temp: TExpectedTransmissionConfirmation;
begin
  for i := 0 to self.FTransmissionConfirmations.Count-1 do
  begin
    temp := TExpectedTransmissionConfirmation(self.FTransmissionConfirmations[i]);
    if temp.alter > TimeOut then
    begin
      self.FTransmissionConfirmations.Remove(temp);
      self.FTransmissionConfirmations.Add(TExpectedTransmissionConfirmation.Create(temp.OriginalMessage, temp.ExpectedConfirmationMessage, temp.ReceiverIP));
      self.SendMessageToAll(temp.OriginalMessage);
    end;
  end;
end;

destructor TDoppelkopfServer.Destroy;
begin
//FSpielerManager.Free;
  inherited Destroy;
end;

procedure TDoppelkopfServer.ClientHasDisconnected(pClientIP: string);
begin

end;

procedure TDoppelkopfServer.processConfirmation(pConfirmationMessage: string; pSenderIP: string);
var i: Integer;
    temp: TExpectedTransmissionConfirmation;
begin
  for i := 0 to self.FTransmissionConfirmations.Count-1 do
  begin
    temp := TExpectedTransmissionConfirmation(self.FTransmissionConfirmations[i]);
    if (temp.ExpectedConfirmationMessage = pConfirmationMessage) and (temp.ReceiverIP = pSenderIP) then
    begin
      self.FTransmissionConfirmations.Remove(temp);
    end;
  end;
end;

procedure TDoppelkopfServer.ProcessMessage(pMessage: string; pSenderIP: string);
var msg: TNetworkMessage;
begin
  self.MeLog.Lines.Add(pSenderIP + ': ' + pMessage);
  self.processConfirmation(pMessage, pSenderIP);
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
  if (msg.key = VORBEHALT_ANMELDEN) then
  begin
    self.processVorbehaltAnmelden(pSenderIP, msg);
  end;
 (* if (msg.key = VORBEHALT_DAMENSOLO) then
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
  end;  *)
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
  if (msg.key = KARTE_LEGEN) then
  begin
    self.processKarteLegen(pSenderIP, msg);
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

procedure TDoppelkopfServer.sendCardsToClientWithIndex(pIndex: Integer);
var msg: string;
    kartenList: TStringList;
    k: Integer;
begin
  msg := KARTEN + '#';
  kartenList := self.FSpiel.getKartenForSpielerWithIndex(pIndex);
  for k := 0 to kartenList.Count-1 do
  begin
    msg := msg + kartenList[k] + '#';
  end;
  self.FTransmissionConfirmations.Add(TExpectedTransmissionConfirmation.Create(msg, KARTEN + '#' + YES + '#', FSpiel.playerIPForIndex(pIndex)));
  self.sendMessage(msg, self.FSpiel.playerIPForIndex(pIndex));
end;


procedure TDoppelkopfServer.processSpielbeginn(pClientIP: string;pMessage: TNetworkMessage);
var msg: string;
    i, k: Integer;
    kartenList: TStringList;
begin
  inc(self.FConfirmationSpielbeginnCounter);
  if self.FConfirmationSpielbeginnCounter = 4 then
  begin
    for i := 1 to 4 do
    begin
      self.sendCardsToClientWithIndex(i);
    end;
  end;
end;

procedure TDoppelkopfServer.processKarten(pClientIP: string;pMessage: TNetworkMessage);
var i: Integer;
    msg: string;
begin
  inc(self.FConfirmationKartenCounter);
  if (self.FConfirmationKartenCounter = 4) then
  begin
    msg := VORBEHALTE_ABFRAGEN + '#';
    self.SendMessageToAll(msg);
    for i := 1 to 4 do
    begin
      self.FTransmissionConfirmations.Add(TExpectedTransmissionConfirmation.Create(msg, msg + YES + '#', FSpiel.PlayerIPForIndex(i)))
    end;
  end;
end;

procedure TDoppelkopfServer.processVorbehalteAbfragen(pClientIP: string; pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processVorbehaltAnmelden(pClientIP: string;pMessage: TNetworkMessage);
var i: Integer;
    msg, confirmation, temp: string;
begin
  confirmation := pMessage.key + '#' + YES + '#';
  if pMessage.parameter[0] = VORBEHALT_NICHTS then
  begin
    self.SendMessage(confirmation, pClientIP);
  end else
  if pMessage.parameter[0] = VORBEHALT_DAMENSOLO then
  begin
    self.FSpiel.MacheSoloAnsage(pClientIP, VORBEHALT_DAMENSOLO);
    self.SendMessage(confirmation, pClientIP);
  end else
  if pMessage.parameter[0] = VORBEHALT_BUBENSOLO then
  begin
    self.FSpiel.MacheSoloAnsage(pClientIP, VORBEHALT_BUBENSOLO);
    self.SendMessage(confirmation, pClientIP);
  end else
  if pMessage.parameter[0] = VORBEHALT_FLEISCHLOSER then
  begin
    self.FSpiel.MacheSoloAnsage(pClientIP, VORBEHALT_FLEISCHLOSER);
    self.SendMessage(confirmation, pClientIP);
  end else
  if pMessage.parameter[0] = VORBEHALT_HOCHZEIT then
  begin
    self.FSpiel.MacheSoloAnsage(pClientIP, VORBEHALT_HOCHZEIT);
    self.SendMessage(pMessage.key + '#' + NO + '#', pClientIP);
  end else
  begin
    self.SendMessage(pMessage.key + '#' + NO + '#', pClientIP);
  end;

  inc(self.FConfirmatinVorbehaltAnmeldenCounter);
  if (self.FConfirmatinVorbehaltAnmeldenCounter = 4) then
  begin
    msg := SOLO + '#';
    self.FSpiel.EntscheideWelchesSolo;
    if self.FSpiel.SpielModus = dkNormal then temp := VORBEHALT_NICHTS;
    if self.FSpiel.SpielModus = dkDamensolo then temp := VORBEHALT_DAMENSOLO;
    if self.FSpiel.SpielModus = dkBubensolo then temp := VORBEHALT_BUBENSOLO;
    if self.FSpiel.SpielModus = dkFleischloser then temp := VORBEHALT_FLEISCHLOSER;
    if self.FSpiel.SpielModus = dkHochzeit then ShowMessage('Hochzeit nicht implementiert');

    msg := msg + FSpiel.SolistName + '#' + temp + '#';
    self.SendMessageToAll(msg);
    for i := 1 to 4 do
    begin
      self.FTransmissionConfirmations.Add(TExpectedTransmissionConfirmation.Create(msg, SOLO + '#' + YES + '#', FSpiel.PlayerIPForIndex(i)))
    end;
  end;
end;

(*procedure TDoppelkopfServer.processDamensolo (pClientIP: string;pMessage: TNetworkMessage);
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

end; *)

procedure TDoppelkopfServer.processSolo (pClientIP: string;pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processWelcheKarte (pClientIP: string;pMessage: TNetworkMessage);
begin
 ///////
end;

procedure TDoppelkopfServer.processAktuellerStich (pClientIP: string;pMessage: TNetworkMessage);
begin
 ////////
end;

procedure TDoppelkopfServer.processGewinnerStich (pClientIP: string;pMessage: TNetworkMessage);
begin
 ///////
end;

procedure TDoppelkopfServer.processGewinnerSpiel (pClientIP: string;pMessage: TNetworkMessage);
begin
 ///////
end;

procedure TDoppelkopfServer.processAnsage (pClientIP: string;pMessage: TNetworkMessage);
begin
  ShowMessage('Im Moment sind Ansagen nicht unterstützt!');
end;

procedure TDoppelkopfServer.processAnsageGemacht (pClientIP: string;pMessage: TNetworkMessage);
begin
 //////
end;

procedure TDoppelkopfServer.processConnect(pClientIP: string; pMessage: TNetworkMessage);
var msg: string;
    i: Integer;
begin
  if FSpiel.addPlayer(pClientIP, pMessage.parameter[0]) then
  begin
    self.SendMessage(CONNECT + '#' + YES + '#', pClientIP);
  end else
  begin
    self.SendMessage(CONNECT + '#' + NO + '#', pClientIP);
  end;
  if FSpiel.CountConnectedPlayer = 4 then
  begin
    msg := SPIELBEGINN + '#' + FSpiel.PlayerNameForIndex(1) + '#' + FSpiel.PlayerNameForIndex(2) + '#' + FSpiel.PlayerNameForIndex(3) + '#' + FSpiel.PlayerNameForIndex(4) + '#';
    for i := 1 to 4 do
    begin
      self.FTransmissionConfirmations.Add(TExpectedTransmissionConfirmation.Create(msg, SPIELBEGINN + '#' + YES + '#', FSpiel.playerIPForIndex(i)));
    end;
    self.SendMessageToAll(msg);
  end;
end;

procedure TDoppelkopfServer.processSoloBestaetigen(pClientIP: string; pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processKarteLegen(pClientIP: string; pMessage: TNetworkMessage);
begin

end;



end.
