unit mTConnection;

interface

uses contnrs, Classes;

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

end.
