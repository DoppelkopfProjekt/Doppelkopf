unit mTSendingNetworkMessage;

interface

uses StringKonstanten;

type

TSendingNetworkMessage = class
private
  msg: string;
  key: string;
  paramCount: Integer;
  function getMsg: string;
  function getConfirmation: string;
public
  constructor Create(pKey: string);
  procedure addParameter(pParameter: string); overload;
  procedure addParameter(pParameter1, pParameter2: string); overload;
  procedure addParameter(pParameter1, pParameter2, pParameter3: string); overload;
  procedure addParameter(pParameter1, pParameter2, pParameter3, pParameter4: string); overload;
  property resultingMessage: string read getmsg;
  property confirmationMessage: string read getConfirmation;
end;

implementation

constructor TSendingNetworkMessage.Create(pKey: string);
begin
  msg := KEY_STRING + pKey + '#';
  key := pKey;
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
  if paramCount = 0 then msg := msg + YES + '#';
  result := msg;
end;

function TSendingNetworkMessage.getConfirmation;
begin
  result := key + '#' + YES + '#';
end;

end.
