unit mTReceivingNetworkMessage;

interface

uses contNrs, mTNetworkMessage, System, StringKonstanten;

type

TReceivingNetworkMessage = class
private
  FMessages: TObjectList;
  function getCount: Integer;
public
  constructor Create(pMessage: string);
  property Count: Integer read getCount;
  property Messages: TObjectList read FMessages;
end;

implementation

constructor TReceivingNetworkMessage.Create(pMessage: string);
var position, i: Integer;
begin
  while(pos(KEY_STRING, pMessage) <> 0) do
  begin
    delete(pMessage, 1, length(KEY_STRING));
    position := pos(KEY_STRING, pMessage);
    if position = 0 then
    begin
      self.FMessages.Add(TNetworkMessage.Create(pMessage));
    end else
    begin
      self.FMessages.Add(TNetworkMessage.Create(copy(pMessage, 1, position-1)));
    end;
  end;
end;

function TReceivingNetworkMessage.getCount;
begin
  result := FMessages.Count;
end;

end.
