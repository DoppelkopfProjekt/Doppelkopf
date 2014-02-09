unit mTExpectedTransmissionConfirmation;

interface

uses Sysutils, idglobal;

type

TExpectedTransmissionConfirmation = class
private
  FTime: Integer;
  FExpectedConfirmationMessage: string;
  FOriginalMessage: string;
  FReceiverIP: string;
  function getAlterInSekunden: Integer;
public
  constructor Create(pmsg: string; pconfirmation: string; pReceiverIP: string);
  property Alter: Integer read getAlterInSekunden;
  property ExpectedConfirmationMessage: string read FExpectedConfirmationMessage;
  property OriginalMessage: string read FOriginalMessage;
  property ReceiverIP: string read FReceiverIP;
end;

implementation

constructor TExpectedTransmissionConfirmation.Create(pmsg: string; pconfirmation: string; preceiverIP);
begin
  FTime := Ticks;
  FExpectedConfirmationMessage := pconfirmation;
  FOriginalMessage := pmsg;
  FReceiverIP := pReceiverIP;
end;

function TExpectedTransmissionConfirmation.getAlterInSekunden: Integer;
begin
  result := (Ticks - FTime) * (1 / 24 / 60 / 60 / 1000));
end;

end.
