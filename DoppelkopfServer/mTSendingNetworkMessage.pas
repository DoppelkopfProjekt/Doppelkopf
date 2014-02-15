unit mTSendingNetworkMessage;

interface

uses StringKonstanten;

type

TSendingNetworkMessage = class
private
  msg: string;
  paramCount: Integer;
  function getMsg: string;
public
  constructor Create(pKey: string);
  procedure addParameter(pParameter: string);
  property resultingMessage: string read getmsg;
end;

implementation

constructor TSendingNetworkMessage.Create(pKey: string);
begin
  msg := KEY_STRING + pKey + '#';
  paramCount := 0;
end;

procedure TSendingNetworkMessage.addParameter(pParameter: string);
begin
  inc(paramCount);
  msg := msg + pParameter + '#';
end;

function TSendingNetworkMessage.getMsg;
begin
  result := msg;
  if paramCount = 0 then msg := msg + YES + '#';
end;

end.
