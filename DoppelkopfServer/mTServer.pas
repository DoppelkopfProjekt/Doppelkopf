unit mTServer;

interface

uses ScktComp, dialogs;

type

TServer = class
  private
    FServer: TServerSocket;
    procedure OnServerClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure OnClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure OnClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
  public
    constructor Create(pPort: Integer);

    procedure Activate;
    procedure Deactivate;

    procedure SendMessage(pMessage: string; pClientIP: string);
    procedure SendMessageToAll(pMessage: string);

    //Procedures to override
    procedure ProcessMessage(pMessage: string; pSenderIP: string); virtual;
    procedure ClientHasConnected(pClientIP: string); virtual;
    procedure ClientHasDisconnected(pClientIP: string); virtual;
end;

implementation

constructor TServer.Create(pPort: Integer);
begin
  FServer := TServerSocket.Create(nil);
  FServer.Port := pPort;
  FServer.OnClientRead := OnServerClientRead;
  FServer.OnClientConnect := OnClientConnect;
  FServer.OnClientDisconnect := OnClientDisconnect;
end;

procedure TServer.OnClientConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  ShowMessage('ClientConnect');
  self.ClientHasConnected(socket.RemoteAddress);
end;

procedure TServer.OnClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  self.ClientHasDisconnected(socket.RemoteAddress);
end;

procedure TServer.OnServerClientRead(Sender: TObject; Socket: TCustomWinSocket);
begin
  self.ProcessMessage(string(socket.ReceiveText), socket.RemoteAddress);
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
