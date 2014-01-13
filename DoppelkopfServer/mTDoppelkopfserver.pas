unit mTDoppelkopfserver;

interface

uses Sysutils, classes, mServer, mTNetworkMessage, mTSpieler, mTDoppelkopfSpiel;

type

TDoppelkopfServer = class(TServer)
private
  procedure processSpielbeginn(pClientIP: string; pClientPort: integer; pMessage: TNetworkMessage);
  procedure processKarten(pClientIP: string; pClientPort: integer; pMessage: TNetworkMessage);
  procedure processVorbehalteAbfragen (pClientIP: string; pClientPort: integer; pMessage: TNetworkMessage);
  procedure processDamensolo (pClientIP: string; pClientPort: integer; pMessage: TNetworkMessage);
  procedure processBubensolo (pClientIP: string; pClientPort: integer; pMessage: TNetworkMessage);
  procedure processFleischloser (pClientIP: string; pClientPort: integer; pMessage: TNetworkMessage);
  procedure processHochzeit (pClientIP: string; pClientPort: integer; pMessage: TNetworkMessage);
  procedure processSolo (pClientIP: string; pClientPort: integer; pMessage: TNetworkMessage);
  procedure processWelcheKarte (pClientIP: string; pClientPort: integer; pMessage: TNetworkMessage);
  procedure processAktuellerStich (pClientIP: string; pClientPort: integer; pMessage: TNetworkMessage);
  procedure processGeweinnerStich (pClientIP: string; pClientPort: integer; pMessage: TNetworkMessage);
  procedure processGewinnerSpiel (pClientIP: string; pClientPort: integer; pMessage: TNetworkMessage);
  procedure processAnsage (pClientIP: string; pClientPort: integer; pMessage: TNetworkMessage);
  procedure processAnsageGemacht (pClientIP: string; pClientPort: integer; pMessage: TNetworkMessage);
  procedure processUngueltigeKarte (pClientIP: string; pClientPort: integer; pMessage: TNetworkMessage);
public
  constructor Create(pPortNr: Integer);
  destructor Destroy; override;
  procedure closeConnection(pClientIP: string; pClientPort: integer); override;
  procedure processMessage(pClientIP: string; pClientPort: integer; pMessage: string); override;
  procedure processNewConnection(pClientIP: string; pClientPort: integer); override;
end;

implementation

const SPIELBEGINN = 'Spielbeginn';
      KARTEN = 'Karten';
      VORBEHALTE = 'Vorbehalte';
      DAMENSOLO = 'Damensolo';
      BUBENSOLO = 'Bubensolo';
      FLEISCHLOSER = 'Fleischloser';
      HOCHZEIT = 'Hochzeit';
      SOLO = 'Solo';
      WECHELKARTELEGEN = 'WelcheKarte';
      AKTUELLERSTICH = 'AktuellerStich';
      GEWINNERSTICH = 'GewinnerStich';
      GEWINNERSPIEL = 'GewinnerSpiel';
      ANSAGE = 'Ansage';
      ANSAGEGEMACHT = 'AnsageGemacht';
      UNGUELTIGEKARTE = 'UngültigeKarte';

      //Auf Client antworten
      CONNECT = 'Connect';
      ANSAGEMACHEN = 'AnsageMachen';

      KARO_ZEHN = 'ZRK';
      KARO_BUBE = 'BRK';
      KARO_DAME = 'DRK';
      KARO_KOENIG = 'KRK';
      KARO_ASS = 'ARK';
      HERZ_ZEHN = 'ZRH';
      HERZ_BUBE = 'BRH';
      HERZ_DAME = 'DRH';
      HERZ_KOENIG = 'KRH';
      HERZ_ASS = 'ARH';
      PIK_ZEHN = 'ZSP';
      PIK_BUBE = 'BSP';
      PIK_DAME = 'DSP';
      PIK_KOENIG = 'KSP';
      PIK_ASS = 'ASP';
      KREUZ_ZEHN = 'ZSK';
      KREUZ_BUBE = 'BSK';
      KREUZ_DAME = 'DSK';
      KREUZ_KOENIG = 'KSK';
      KREUZ_ASS = 'ASK';
      ANSAGE_RE = 'Re';
      ANSAGE_KONTRA = 'Ko';
      ANSAGE_KEINENEUN = 'K9';
      ANSAGE_KEINESECHS = 'K6';
      ANSAGE_KEINEDREI = 'K3';
      ANSAGE_SCHWARZ = 'K0';
      ANSAGE_KEINE = 'No';



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

procedure TDoppelkopfServer.processNewConnection(pClientIP: string; pClientPort: integer);
var spieler: TSpieler;
begin
  Spieler := TSpieler.create;
  Spieler.IP := pClientIP;
  //FSpielerManager.addPlayer(Spieler);
end;

procedure TDoppelkopfServer.closeConnection(pClientIP: string; pClientPort: integer);
begin
  inherited closeConnection(pClientIP, pClientPort);
end;

procedure TDoppelkopfServer.processMessage(pClientIP: string; pClientPort: integer; pMessage: string);
var msg: TNetworkMessage;
    player: TSpieler;
    s: string;
    i: Integer;
begin
  msg := TNetworkMessage.Create(pMessage);
  if (msg.key = CONNECT) then
  begin
    //player := FSpielerManager.playerForIP(pClientIP);
    player.Name := msg.parameter[0];
    self.send(pClientIP, pClientPort, msg.key + '#YES#');

    s := SPIELBEGINN;
    //for i := 0 to FSpielerManager.countConnectedPlayer-1 do
    begin
   //   s := s + '#' + FSpielerManager.PlayerForIndex(i).name;
    end;
    s := s + '#';
    //if FSpielerManager.countConnectedPlayer = 4 then
    begin
      Self.sendToAll(s);
    end;
  end;
end;


procedure TDoppelkopfServer.processSpielbeginn(pClientIP: string; pClientPort: integer; pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processKarten(pClientIP: string; pClientPort: integer; pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processVorbehalteAbfragen (pClientIP: string; pClientPort: integer; pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processDamensolo (pClientIP: string; pClientPort: integer; pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processBubensolo (pClientIP: string; pClientPort: integer; pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processFleischloser (pClientIP: string; pClientPort: integer; pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processHochzeit (pClientIP: string; pClientPort: integer; pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processSolo (pClientIP: string; pClientPort: integer; pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processWelcheKarte (pClientIP: string; pClientPort: integer; pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processAktuellerStich (pClientIP: string; pClientPort: integer; pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processGeweinnerStich (pClientIP: string; pClientPort: integer; pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processGewinnerSpiel (pClientIP: string; pClientPort: integer; pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processAnsage (pClientIP: string; pClientPort: integer; pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processAnsageGemacht (pClientIP: string; pClientPort: integer; pMessage: TNetworkMessage);
begin

end;

procedure TDoppelkopfServer.processUngueltigeKarte (pClientIP: string; pClientPort: integer; pMessage: TNetworkMessage);
begin

end;



end.
