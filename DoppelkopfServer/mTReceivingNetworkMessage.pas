unit mTReceivingNetworkMessage;

interface

uses contNrs, mTNetworkMessage, StringKonstanten, Classes;

type

TReceivingNetworkMessage = class
private
  FMessages: TObjectList;
  function getCount: Integer;
public
  constructor Create(pMessage: string);
  property Count: Integer read getCount;
  function messageForIndex(pIndex: Integer): TNetworkmessage;
end;

implementation

constructor TReceivingNetworkMessage.Create(pMessage: string);
var position: Integer;
    temp: TNetworkMessage;
begin
  FMessages := TObjectList.Create;
  while(pos(KEY_STRING, pMessage) <> 0) do
  begin
    delete(pMessage, 1, length(KEY_STRING));
    position := pos(KEY_STRING, pMessage);
    if position = 0 then
    begin
      temp := TNetworkMessage.Create(pMessage);
      self.FMessages.Add(temp);
    end else
    begin
      temp := TNetworkMessage.Create(copy(pMessage, 1, position-1));
      delete(pMessage, 1, position-1);
      self.FMessages.Add(temp);
    end;
  end;
end;

function TReceivingNetworkMessage.messageForIndex(pIndex: Integer): TNetworkmessage;
begin
  result := TNetworkMessage(self.FMessages[pIndex]);
end;

function TReceivingNetworkMessage.getCount;
begin
  result := FMessages.Count;
end;

end.
