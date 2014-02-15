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
  procedure addParameter(pParameter: string); overload;
  procedure addParameter(pParameter1, pParameter2: string); overload;
  procedure addParameter(pParameter1, pParameter2, pParameter3: string); overload;
  procedure addParameter(pParameter1, pParameter2, pParameter3, pParameter4: string); overload;
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

procedure TSendingNetworkMessage.addParameter(pParameter1: string; pParameter2: string);
begin
  inc(paramCount, 2);
  msg := msg + pParameter1 + '#' + pParameter2 + '#';
end;

procedure TSendingNetworkMessage.addParameter(pParameter1: string; pParameter2: string; pParameter3: string);
begin
  inc(paramCount, 3);
  msg := msg + pParameter1 + '#' + pParameter2 + '#' + pParameter3 + '#';
end;

procedure TSendingNetworkMessage.addParameter(pParameter1: string; pParameter2: string; pParameter3: string; pParameter4: string);
begin
  inc(paramCount, 4);
  msg := msg + pParameter1 + '#' + pParameter2 + '#' + pParameter3 + '#' + pParameter4 + '#';;
end;

function TSendingNetworkMessage.getMsg;
begin
  result := msg;
  if paramCount = 0 then msg := msg + YES + '#';
end;

end.
