(*
 * Materialien zu den zentralen Abiturpruefungen
 * im Fach Informatik ab 2012 in Nordrhein-Westfalen.
 *
 * Klasse TServer
 *
 * NW-Arbeitsgruppe:
 * Materialentwicklung zum Zentralabitur im Fach Informatik
 *
 * Version 2011-01-17
 *)

unit mServer;

INTERFACE
uses ScktComp, Forms, Windows, Messages, SysUtils, Classes, Graphics, Controls,
      Dialogs, StDCtrls, Winsock,  mList, mserververbindung;
const
     ZEILENENDE=#13#10;

type
  TServer = class
              private
              hatServerSocket:TServerSocket;
              zPort:integer;
              protected
              procedure ServerSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
              procedure ServerSocketGetSocket(Sender: TObject; Socket: TSocket; var ClientSocket: TServerClientWinSocket);
              procedure ServerSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
              procedure ServerSocketClientWrite(Sender: TObject; Socket: TCustomWinSocket);
              procedure ServerSocketClientError(Sender: TObject;Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: integer);
              procedure ServerSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
              public
              constructor create(pPortNr:integer);
              procedure sendToAll(pMessage:string);
              procedure send(pClientIP:string; pClientPort: integer; pMessage:string);overload;
              procedure closeConnection(pCLientIP:string; pClientPort: integer);overload; dynamic;
              function  serverVerbindungVonIP(pClientIP:string; pClientPort: integer):ServerVerbindung;overload;

              procedure processNewConnection(pClientIP:string; pClientPort: integer); dynamic;
              procedure processMessage(pClientIP: string; pClientPort: integer; pMessage:string); overload; dynamic;
              procedure processClosedConnection(pClientIP:string; pClientPort: integer);overload; dynamic;

              destructor Destroy;override;
            end;


IMPLEMENTATION

  constructor TServer.create(pPortNr:integer);
  begin
    zPort:=pPortNr;
    hatServerSocket:=TServerSocket.Create(Application);
    hatServerSocket.Port:=zPort;
    hatServerSocket.ServerType:=stNonBlocking;
    hatServerSocket.OnClientConnect:=ServerSocketConnect;
    hatServerSocket.OnGetSocket:=ServerSocketGetSocket;
    hatServerSocket.OnClientRead:=ServerSocketClientRead;
    hatServerSocket.OnClientError:=ServerSocketClientError;
    hatServerSocket.OnClientDisconnect:=ServerSocketDisconnect;
    hatServerSocket.Open;
  end;


  function TServer.serverVerbindungVonIP(pClientIP: string; pClientPort: integer): ServerVerbindung;
  var lVerbindungsnummer, lZaehler:integer;
  begin
    lVerbindungsnummer:=-1;
    lZaehler:=0;
    while (lVerbindungsNummer<0) and (lZaehler<hatServerSocket.Socket.activeConnections) do
      if (hatServerSocket.socket.connections[lZaehler].remoteAddress=pClientIP) and
         (hatServerSocket.socket.connections[lZaehler].remotePort=pClientPort) then
        lVerbindungsNummer:=lZaehler
      else
        inc(lZaehler);
    if lVerbindungsnummer>=0 then
      result:=Serververbindung(hatServerSocket.socket.connections[lVerbindungsnummer])
    else
       result:=nil;
  end;

   procedure TServer.ServerSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
  begin
       processNewConnection(Socket.RemoteAddress, Socket.RemotePort);
  end;
  procedure TServer.ServerSocketGetSocket(Sender: TObject; Socket: TSocket; var ClientSocket: TServerClientWinSocket);
   begin
    ClientSocket:=Serververbindung.create(Socket,hatServerSocket.socket);
  end;

   procedure TServer.ServerSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
  var
    lNachricht,lEineNachricht:string;
    lPos:integer;
  begin
    lNachricht:=Socket.receiveText;
    repeat
       lPos:=pos(ZEILENENDE,lNachricht);
       lEineNachricht:=copy(lNachricht,1,lPos-1);
       delete(lNachricht,1,lPos-1+length(ZEILENENDE));
       if lEineNachricht<>'' then begin
         processMessage(Socket.RemoteAddress,Socket.RemotePort,lEineNachricht);
       end
     until lEineNachricht='';
  end;
   procedure TServer.ServerSocketClientWrite(Sender: TObject; Socket: TCustomWinSocket);
  begin
  end;

  procedure TServer.ServerSocketClientError(Sender: TObject;Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
                                    var ErrorCode: integer);
  var
    lFehler:string;
  begin
    case ErrorEvent of
    eeGeneral:lFehler:='Unbekannter Fehler';
    eeSend:lFehler:='Der Server konnte nicht senden';
    eeReceive:lFehler:='Der Server konnte keine Nachricht empfangen';
    eeConnect:lFehler:='Der Server konnte keine Verbindung aufbauen';
    eeDisconnect:lFehler:='Die Verbindung konnte nicht geschlossen werden.';
    eeAccept:lFehler:='Der Server konnte keine Verbindung aufbauen';
    end;
    if ErrorEvent<>eeDisconnect then //jd
      Socket.close;
    ErrorCode:=0; // jd: verhindert Asynchronen Socket-Fehler 10053
  end;

  procedure TServer.ServerSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
  begin
    // self.bearbeiteVerbindungsende(Socket.RemoteAddress); ...führt zu Endlosschleifen 
  end;

  procedure TServer.send(pClientIP: string;pClientPort: integer; pMessage: string);
  var lVerbindung:TCustomWinSocket;
  begin
    lVerbindung:=self.serverVerbindungVonIP(pCLientIP, pClientPort);
    if (lVerbindung<>nil) then
        lVerbindung.sendText(pMessage+ZEILENENDE);
  end;
  
  procedure TServer.sendToAll(pMessage:string);
  var
    lVerbindungenZaehler:integer;
    lVerbindung:TCustomWinSocket;
  begin
       for lVerbindungenZaehler:=0 to hatServerSocket.Socket.ActiveConnections-1 do begin
        lVerbindung:=hatServerSocket.socket.connections[lVerbindungenZaehler];
        lVerbindung.sendText(pMessage+ZEILENENDE);
       end;
  end;


   procedure TServer.processMessage(pClientIP: string;pClientPort: integer; pMessage: string);
  begin
  end;

  procedure TServer.processNewConnection(pClientIP: string; pClientPort: integer);
  begin
  end;

  procedure TServer.processClosedConnection(pClientIP: string; pClientPort: integer);
  begin
  end;


  procedure TServer.closeConnection(pCLientIP: string; pClientPort: integer);
  var
    lClientVerbindung:TCustomWinSocket;
  begin
    lClientVerbindung:=self.serverVerbindungVonIP(pClientIP,pClientPort);
    if lClientVerbindung<>nil then begin
      self.processClosedConnection(pClientIP,pClientPort);
      lClientVerbindung.Close;
      lClientVerbindung.free;
    end
  end;


  destructor TServer.destroy;
  begin
    hatServerSocket.Close;
    hatServerSocket.destroy;
  end;

end.
