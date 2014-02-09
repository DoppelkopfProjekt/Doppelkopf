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
  function getAlterInSekunden: double;
public
  constructor Create(pmsg: string; pconfirmation: string; pReceiverIP: string);
  property Alter: double read getAlterInSekunden;
  property ExpectedConfirmationMessage: string read FExpectedConfirmationMessage;
  property OriginalMessage: string read FOriginalMessage;
  property ReceiverIP: string read FReceiverIP;
end;

implementation

constructor TExpectedTransmissionConfirmation.Create(pmsg: string; pconfirmation: string; preceiverIP: string);
begin
  FTime := Ticks;
  FExpectedConfirmationMessage := pconfirmation;
  FOriginalMessage := pmsg;
  FReceiverIP := pReceiverIP;
end;

function TExpectedTransmissionConfirmation.getAlterInSekunden: double;
begin
  result := (Integer(Ticks) - FTime) * (1.0 / 24.0 / 60.0 / 60.0 / 1000.0);
end;

end.
