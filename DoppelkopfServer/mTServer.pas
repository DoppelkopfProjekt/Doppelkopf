unit mTServer;

interface

uses ScktComp, dialogs, StringKonstanten, sysutils, windows, contnrs, Classes, strUtils;

type

TConnection = class
  private
    FIP: string;
    FBuffer: string;
  public
    property IP: string read FIP;
    property Buffer: string read FBuffer write FBuffer;
    constructor Create(pIP: string);
end;

TConnectionManager = class
  private
    FConnections: TObjectList;
  public
    function bufferForIP(pIP: string): string;
    procedure setBufferForIP(pIP, newBuffer: string);
    procedure addConnection(pIP: string);
    procedure removeConnection(pIP: string);
    constructor Create;
end;

TServer = class
  private
    FServer: TServerSocket;
    FConnectionManager: TConnectionManager;
    procedure OnServerClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure OnClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure OnClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    function bufferForIP(pIP: string): string;
    procedure setBufferForIP(pIP, newBuffer: string);
  public
    constructor Create(pPort: Integer);

    procedure Activate;
    procedure Deactivate;

    procedure SendMessage(pMessage: string; pClientIP: string); virtual;
    procedure SendMessageToAll(pMessage: string); virtual;


    //Procedures to override
    procedure ProcessMessage(pMessage: string; pSenderIP: string); virtual;
    procedure ClientHasConnected(pClientIP: string); virtual;
    procedure ClientHasDisconnected(pClientIP: string); virtual;
    property Server: TServerSocket read FServer;
end;

implementation

constructor TConnection.Create(pIP: string);
begin
  FIP := pIP;
end;

constructor TConnectionManager.Create;
begin
  FConnections := TObjectList.Create;
end;

procedure TConnectionManager.addConnection(pIP: string);
begin
  self.FConnections.Add(TConnection.Create(pIP));
end;

function TConnectionManager.bufferForIP(pIP: string): string;
var i: Integer;
begin
  for i := 0 to self.FConnections.Count-1 do
  begin
    if TConnection(self.FConnections[i]).IP = pIP then
    begin
      result := TConnection(self.FConnections[i]).Buffer;
      break;
    end;
  end;
end;

procedure TConnectionManager.setBufferForIP(pIP, newBuffer: string);
var i: Integer;
begin
  for i := 0 to self.FConnections.Count-1 do
  begin
    if TConnection(self.FConnections[i]).IP = pIP then
    begin
      TConnection(self.FConnections[i]).Buffer := newBuffer;
      break;
    end;
  end;
end;

procedure TConnectionManager.removeConnection(pIP: string);
var i: Integer;
begin
  for i := 0 to self.FConnections.Count-1 do
  begin
    if TConnection(self.FConnections[i]).IP = pIP then
    begin
      self.FConnections.Delete(i);
      break;
    end;
  end;
end;

constructor TServer.Create(pPort: Integer);
begin
  FServer := TServerSocket.Create(nil);
  FServer.Port := pPort;
  FServer.OnClientRead := OnServerClientRead;
  FServer.OnClientConnect := OnClientConnect;
  FServer.OnClientDisconnect := OnClientDisconnect;
  self.FConnectionManager := TConnectionManager.Create;
end;

function TServer.bufferForIP(pIP: string): string;
begin
  self.FConnectionManager.bufferForIP(pIP);
end;

procedure TServer.setBufferForIP(pIP: string; newBuffer: string);
begin
  self.FConnectionManager.setBufferForIP(pIP, newBuffer);
end;

procedure TServer.OnClientConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  self.ClientHasConnected(socket.RemoteAddress);
  self.FConnectionManager.addConnection(socket.RemoteAddress);
end;

procedure TServer.OnClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  self.FConnectionManager.removeConnection(socket.RemoteAddress);
  self.ClientHasDisconnected(socket.RemoteAddress);
end;

procedure TServer.OnServerClientRead(Sender: TObject; Socket: TCustomWinSocket);
var expectedLength, tempEnd, tempBegin, realLength, lengthBegin, lengthEnd: Integer;
    shouldStop: Boolean;
    IP: string;
    buffer: string;
begin
  IP := socket.RemoteAddress;
  buffer := self.bufferForIP(IP);
  buffer := buffer + string(socket.ReceiveText);
  self.setBufferForIP(IP, buffer);
  shouldStop := False;
  lengthBegin := length(LENGTH_BEGIN);
  lengthEnd := length(LENGTH_END);
  while not shouldStop do
  begin
    tempEnd := posEx(LENGTH_END, buffer, lengthBegin);
    if tempEnd <> 0 then
    begin
      expectedLength := StrToInt(copy(buffer, lengthBegin+1, tempEnd-lengthBegin-1));
      tempBegin := posEx(LENGTH_BEGIN, buffer, tempEnd);
      if tempBegin <> 0 then
      begin
        realLength := tempBegin - lengthBegin - lengthEnd - length(copy(buffer, lengthBegin+1, tempEnd-lengthBegin-1))-1;
      end else
      begin
        realLength := length(buffer) - lengthBegin - lengthEnd - length(copy(buffer, lengthBegin+1, tempEnd-lengthBegin-1));
      end;
      if realLength = expectedLength then
      begin
        delete(buffer, 1, tempEnd+lengthEnd-1);
        self.ProcessMessage(copy(buffer, 1, realLength), socket.RemoteAddress);
        //ShowMessage(copy(buffer, 1, realLength));
        delete(buffer, 1, realLength);
      end else
      begin
        shouldStop := True;
      end;
    end else
    begin
      shouldStop := True;
    end;
  end;
  self.setBufferForIP(IP, buffer);
end;

procedure TServer.Activate;
begin
  FServer.Open;
end;

procedure TServer.Deactivate;
begin
  FServer.Close;
end;

procedure TServer.SendMessage(pMessage: string; pClientIP: string);
var i: Integer;
    temp: TCustomWinSocket;
begin
  pMessage := LENGTH_BEGIN + IntToStr(length(pMessage)) + LENGTH_END + pMessage;
  for i := 0 to FServer.Socket.ActiveConnections-1 do
  begin
    temp := FServer.Socket.Connections[i];
    if temp.RemoteAddress = pClientIP then
      temp.SendText(AnsiString(pMessage));
  end;
end;

procedure TServer.SendMessageToAll(pMessage: string);
var i: Integer;
begin
  pMessage := LENGTH_BEGIN + IntToStr(length(pMessage)) + LENGTH_END + pMessage;
  for i := 0 to FServer.Socket.ActiveConnections-1 do
  begin
    FServer.Socket.Connections[i].SendText(AnsiString(pMessage));
  end;
end;

procedure TServer.ProcessMessage(pMessage: string; pSenderIP: string);
begin

end;

procedure TServer.ClientHasConnected(pClientIP: string);
begin

end;

procedure TServer.ClientHasDisconnected(pClientIP: string);
begin

end;

end.
