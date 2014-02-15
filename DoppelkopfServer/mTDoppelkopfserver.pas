unit mTDoppelkopfserver;

interface

uses Sysutils, mTBlatt, mTReceivingNetworkMessage, mTSendingNetworkMessage, mTKarte, Types, classes, mTServer, mTNetworkMessage, StdCtrls, mTSpieler, mTDoppelkopfSpiel, StringKonstanten, Contnrs, mTExpectedTransmissionConfirmation, ExtCtrls, dialogs;

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
  FConfirmationSoloCounter: Integer;

  function SucheSpielGewinner: TStringList;

  procedure sendCardsToClientWithIndex(pIndex: Integer);
  procedure processNetworkMessage(msg: TNetworkMessage; pSenderIP: string);

  procedure processConnect(pClientIP: string; pMessage: TNetworkMessage);
  procedure processSpielbeginn(pClientIP: string; pMessage: TNetworkMessage);
  procedure processKarten(pClientIP: string; pMessage: TNetworkMessage);
  procedure processVorbehaltAnmelden (pClientIP: string; pMessage: TNetworkMessage);
  procedure processVorbehalteAbfragen (pClientIP: string; pMessage: TNetworkMessage);
  procedure processSolo (pClientIP: string; pMessage: TNetworkMessage);
  procedure processKarteLegen (pClientIP: string; pMessage: TNetworkMessage);
  procedure processAnsage (pClientIP: string; pMessage: TNetworkMessage);

  procedure processConfirmation(pConfirmationMessage: string; pSenderIP: string);
  procedure processTransmissionConfirmations(sender: TObject);
public
  MeLog: TMemo;

  procedure SendMessage(pMessage: string; pClientIP: string); override;
  procedure SendMessageToAll(pMessage: string); override;

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
  self.FConfirmationSpielbeginnCounter := 0;
  self.FConfirmationKartenCounter := 0;
  self.FConfirmatinVorbehaltAnmeldenCounter := 0;
  self.FConfirmationSoloCounter := 0;
end;

procedure TDoppelkopfserver.SendMessage(pMessage: string; pClientIP: string);
begin
  inherited SendMessage(pMessage, pClientIP);
  self.MeLog.Lines.Add('GESENDET: ' + pMessage + ' an IP: ' + pClientIP);
end;

procedure TDoppelkopfServer.SendMessageToAll(pMessage: string);
begin
  inherited SendMessageToAll(pMessage);
  self.MeLog.Lines.Add('GESENDET AN ALLE: ' + pMessage);
end;

procedure TDoppelkopfServer.ClientHasConnected(pClientIP: string);
begin
  self.MeLog.Lines.Add('Client ' + pClientIP + ' ist verbunden');
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
      self.FTransmissionConfirmations.Add(TExpectedTransmissionConfirmation.Create(temp.OriginalMessage,
                                                                                   temp.ExpectedConfirmationMessage,
                                                                                   temp.ReceiverIP));
      self.SendMessage(temp.OriginalMessage, temp.ReceiverIP);
      MeLog.Lines.Add('Nachricht erneut gesendet: ' + temp.OriginalMessage + ' an IP: ' + temp.ReceiverIP);
    end;
  end;
end;

destructor TDoppelkopfServer.Destroy;
begin
  inherited Destroy;
end;

procedure TDoppelkopfServer.ClientHasDisconnected(pClientIP: string);
begin
  self.MeLog.Lines.Add('Client ' + pClientIP + ' ist getrennt');
end;

procedure TDoppelkopfServer.processConfirmation(pConfirmationMessage: string; pSenderIP: string);
var i: Integer;
    temp: TExpectedTransmissionConfirmation;
begin
  i := 0;
  while i <= self.FTransmissionConfirmations.Count-1 do
  begin
    temp := TExpectedTransmissionConfirmation(self.FTransmissionConfirmations[i]);
    if (temp.ExpectedConfirmationMessage = pConfirmationMessage) and (temp.ReceiverIP = pSenderIP) then
    begin
      self.FTransmissionConfirmations.Remove(temp);
    end;
    inc(i);
  end;
end;

procedure TDoppelkopfServer.processNetworkMessage(msg: TNetworkMessage; pSenderIP: string);
begin
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
  if (msg.key = SOLO) then
  begin
    self.processSolo(pSenderIP, msg);
  end;
  if (msg.key = KARTE_LEGEN) then
  begin
    self.processKarteLegen(pSenderIP, msg);
  end;
end;

procedure TDoppelkopfServer.ProcessMessage(pMessage: string; pSenderIP: string);
var msg: TReceivingNetworkMessage;
    i: Integer;
begin
  self.MeLog.Lines.Add('EMPFANGEN: ' + pSenderIP + ': ' + pMessage);
  msg := TReceivingNetworkMessage.Create(pMessage);
  for i := 0 to msg.Count-1 do
  begin
    self.processConfirmation(msg.messageStringForIndex(i), pSenderIP);
    self.processNetworkMessage(msg.messageForIndex(i), pSenderIP);
  end;

end;

procedure TDoppelkopfServer.sendCardsToClientWithIndex(pIndex: Integer);
var msg: TSendingNetworkMessage;
    kartenList: TStringList;
    k: Integer;
begin
  msg := TSendingNetworkMessage.Create(KARTEN);
  kartenList := self.FSpiel.getKartenForSpielerWithIndex(pIndex);
  for k := 0 to kartenList.Count-1 do
  begin
    msg.addParameter(kartenList[k]);
  end;
  self.FTransmissionConfirmations.Add(TExpectedTransmissionConfirmation.Create(msg.resultingMessage,
                                                                               msg.confirmationMessage,
                                                                               FSpiel.playerIPForIndex(pIndex)));
  self.sendMessage(msg.resultingMessage, self.FSpiel.playerIPForIndex(pIndex));
end;


procedure TDoppelkopfServer.processSpielbeginn(pClientIP: string;pMessage: TNetworkMessage);
var i: Integer;
begin
  inc(self.FConfirmationSpielbeginnCounter);
  if self.FConfirmationSpielbeginnCounter = 4 then
  begin
    for i := 1 to 4 do
    begin
      self.melog.lines.add('Karten werden an Spieler ' + IntToStr(i) + ' ausgegeben');
      self.sendCardsToClientWithIndex(i);
    end;
  end;
end;

procedure TDoppelkopfServer.processKarten(pClientIP: string;pMessage: TNetworkMessage);
var i: Integer;
    msg: TSendingNetworkMessage;
begin
  inc(self.FConfirmationKartenCounter);
  if (self.FConfirmationKartenCounter = 4) then
  begin
    msg := TSendingNetworkMessage.Create(VORBEHALTE_ABFRAGEN);
    self.SendMessageToAll(msg.resultingMessage);
    for i := 1 to 4 do
    begin
      self.FTransmissionConfirmations.Add(TExpectedTransmissionConfirmation.Create(msg.resultingMessage,
                                                                                   msg.confirmationMessage,
                                                                                   FSpiel.PlayerIPForIndex(i)))
    end;
  end;
end;

procedure TDoppelkopfServer.processVorbehalteAbfragen(pClientIP: string; pMessage: TNetworkMessage);
begin
 //////
end;

procedure TDoppelkopfServer.processVorbehaltAnmelden(pClientIP: string;pMessage: TNetworkMessage);
var i: Integer;
    temp: string;
    msg, confirmation, deniation: TSendingNetworkMessage;
begin
  confirmation := TSendingNetworkMessage.Create(pMessage.key);
  deniation := TSendingNetworkMessage.Create(pMessage.key);
  deniation.addParameter(NO);
  if pMessage.parameter[0] = VORBEHALT_NICHTS then
  begin
    self.SendMessage(confirmation.resultingMessage, pClientIP);
  end else
  if pMessage.parameter[0] = VORBEHALT_DAMENSOLO then
  begin
    self.FSpiel.MacheSoloAnsage(pClientIP, VORBEHALT_DAMENSOLO);
    self.SendMessage(confirmation.resultingMessage, pClientIP);
  end else
  if pMessage.parameter[0] = VORBEHALT_BUBENSOLO then
  begin
    self.FSpiel.MacheSoloAnsage(pClientIP, VORBEHALT_BUBENSOLO);
    self.SendMessage(confirmation.resultingMessage, pClientIP);
  end else
  if pMessage.parameter[0] = VORBEHALT_FLEISCHLOSER then
  begin
    self.FSpiel.MacheSoloAnsage(pClientIP, VORBEHALT_FLEISCHLOSER);
    self.SendMessage(confirmation.resultingMessage, pClientIP);
  end else
  if pMessage.parameter[0] = VORBEHALT_HOCHZEIT then
  begin
    self.FSpiel.MacheSoloAnsage(pClientIP, VORBEHALT_HOCHZEIT);
    self.SendMessage(deniation.resultingMessage, pClientIP);
  end else
  begin
    self.SendMessage(deniation.resultingMessage, pClientIP);
  end;

  inc(self.FConfirmatinVorbehaltAnmeldenCounter);
  if (self.FConfirmatinVorbehaltAnmeldenCounter = 4) then
  begin
    msg := TSendingNetworkMessage.Create(SOLO);
    self.FSpiel.EntscheideWelchesSolo;
    if self.FSpiel.SpielModus = dkNormal then temp := VORBEHALT_NICHTS;
    if self.FSpiel.SpielModus = dkDamensolo then temp := VORBEHALT_DAMENSOLO;
    if self.FSpiel.SpielModus = dkBubensolo then temp := VORBEHALT_BUBENSOLO;
    if self.FSpiel.SpielModus = dkFleischloser then temp := VORBEHALT_FLEISCHLOSER;
    if self.FSpiel.SpielModus = dkHochzeit then ShowMessage('Hochzeit nicht implementiert');

    msg.addParameter(FSpiel.SolistName, temp);
    self.SendMessageToAll(msg.resultingMessage);
    for i := 1 to 4 do
    begin
      self.FTransmissionConfirmations.Add(TExpectedTransmissionConfirmation.Create(msg.resultingMessage,
                                                                                   msg.confirmationMessage,
                                                                                   FSpiel.PlayerIPForIndex(i)))
    end;
  end;
end;

procedure TDoppelkopfServer.processSolo (pClientIP: string;pMessage: TNetworkMessage);
var msg: TSendingNetworkMessage;
begin
  inc(self.FConfirmationSoloCounter);
  if (self.FConfirmationSoloCounter = 4) then
  begin
    msg := TSendingNetworkMessage.Create(WELCHE_KARTE);
    self.SendMessage(msg.resultingMessage, self.FSpiel.aktuelleSpielerIP);
    self.FTransmissionConfirmations.Add(TExpectedTransmissionConfirmation.Create(msg.resultingMessage,
                                                                                 msg.resultingMessage,
                                                                                 self.FSpiel.aktuelleSpielerIP))
  end;
end;

procedure TDoppelkopfServer.processAnsage (pClientIP: string;pMessage: TNetworkMessage);
begin
  ShowMessage('Im Moment sind Ansagen nicht unterstützt!');
end;

procedure TDoppelkopfServer.processConnect(pClientIP: string; pMessage: TNetworkMessage);
var msg: TSendingNetworkMessage;
    i: Integer;
    temp: TSendingNetworkMessage;
begin
  if FSpiel.addPlayer(pClientIP, pMessage.parameter[0]) then
  begin
    self.SendMessage(TSendingNetworkMessage.Create(CONNECT).resultingMessage, pClientIP);
  end else
  begin
    temp := TSendingNetworkMessage.Create(CONNECT);
    temp.addParameter(NO);
    self.SendMessage(temp.resultingMessage, pClientIP);
  end;
  if FSpiel.CountConnectedPlayer = 4 then
  begin
    self.FSpiel.starteSpiel;
    msg := TSendingNetworkMessage.Create(SPIELBEGINN);
    msg.addParameter(FSpiel.PlayerNameForIndex(1), FSpiel.PlayerNameForIndex(2), FSpiel.PlayerNameForIndex(3), FSpiel.PlayerNameForIndex(4));

    for i := 1 to 4 do
    begin
      self.FTransmissionConfirmations.Add(TExpectedTransmissionConfirmation.Create(msg.resultingMessage,
                                                                                   msg.confirmationMessage,
                                                                                   FSpiel.playerIPForIndex(i)));
    end;
    self.SendMessageToAll(msg.resultingMessage);
  end;
end;

procedure TDoppelkopfServer.processKarteLegen(pClientIP: string; pMessage: TNetworkMessage);
var success: Boolean;
    counter, i: Integer;
    msg: TSendingNetworkMessage;
    karten, gewinner: TStringList;
    temp: string;
begin
  MeLog.Lines.Add('Karte gelegt');

  success := self.FSpiel.legeKarte(pMessage.parameter[0], pClientIP);
  if not success then
  begin
    msg := TSendingNetworkMessage.Create(KARTE_LEGEN);
    msg.addParameter(NO);
    self.SendMessage(msg.resultingMessage, pClientIP);
  end else
  begin
    self.SendMessage(TSendingNetworkMessage.Create(KARTE_LEGEN).resultingMessage, pClientIP);
   // self.sendCardsToClientWithIndex(self.FSpiel.play);
    counter := self.FSpiel.ZahlGelegteKarten;
    msg := TSendingNetworkMessage.Create(AKTUELLER_STICH);
    karten := self.FSpiel.AktuellerStich.getGelegteKarten;
    //Aktuellen Stich an alle schicken
    for i := 0 to karten.Count-1 do
    begin
      msg.addParameter(karten[i]);
    end;
    for i := 1 to 4 do
    begin
      self.FTransmissionConfirmations.Add(TExpectedTransmissionConfirmation.Create(msg.resultingMessage,
                                                                                   msg.confirmationMessage,
                                                                                   FSpiel.playerIPForIndex(i)));
    end;
    self.SendMessageToAll(msg.resultingMessage);
    //Wenn der Stich voll ist
    if (counter mod 4) = 0 then
    begin
      msg := TSendingNetworkMessage.Create(GEWINNER_STICH);
      msg.addParameter(TSpieler(self.FSpiel.AktuellerStich.AktuellerSieger).Name);
      self.SendMessageToAll(msg.resultingMessage);
      for i := 1 to 4 do
      begin
        self.FTransmissionConfirmations.Add(TExpectedTransmissionConfirmation.Create(msg.resultingMessage,
                                                                                     msg.confirmationMessage,
                                                                                     FSpiel.playerIPForIndex(i)));
      end;
      //Wenn Stich fertig, Gewinner an alle schicken und neue Reihenfolge schicken
      msg := TSendingNetworkMessage.Create(SPIELER_REIHENFOLGE);
      for i := 1 to 4 do
      begin
        msg.addParameter(FSpiel.PlayerNameForIndex(i));
      end;
      for i := 1 to 4 do
      begin
        self.FTransmissionConfirmations.Add(TExpectedTransmissionConfirmation.Create(msg.resultingMessage,
                                                                                   msg.confirmationMessage,
                                                                                   FSpiel.playerIPForIndex(i)));
      end;
      self.SendMessageToAll(msg.resultingMessage);
    end;
    //Wenn Spiel zuende, Sieger mitteilen
    if (counter = 40) then
    begin
      msg := TSendingNetworkMessage.Create(GEWINNER_SPIEL);
      gewinner := self.SucheSpielGewinner;
      for i := 0 to gewinner.Count-1 do
      begin
        msg.addParameter(gewinner[i]);
      end;
      msg.addParameter(IntToStr(FSpiel.getPunkteVonSieger));
      //msg.addParameter('Sag ich später', '10');
      self.SendMessageToAll(msg.resultingMessage);
      for i := 1 to 4 do
      begin
        self.FTransmissionConfirmations.Add(TExpectedTransmissionConfirmation.Create(msg.resultingMessage,
                                                                                     msg.confirmationMessage,
                                                                                     FSpiel.playerIPForIndex(i)));
      end;
    end else
    begin
      msg := TSendingNetworkMessage.Create(WELCHE_KARTE);
      self.SendMessage(msg.resultingMessage, self.FSpiel.aktuelleSpielerIP);
      self.FTransmissionConfirmations.Add(TExpectedTransmissionConfirmation.Create(msg.resultingMessage,
                                                                                   msg.confirmationMessage,
                                                                                   self.FSpiel.aktuelleSpielerIP))
    end;
  end;
end;

function TDoppelkopfServer.SucheSpielGewinner: TStringList;
var siegerPartei: dkPartei;
    i: integer;
begin
  siegerPartei := FSpiel.getSiegerPartei;
  for i := 1 to 4 do
  begin
    if FSpiel.PlayerForIndex(i).Partei = siegerPartei then result.Add(FSpiel.PlayerNameForIndex(i));
  end;
end;



end.
