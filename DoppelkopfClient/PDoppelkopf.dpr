program PDoppelkopf;

uses
  Forms,
  UDoppelkopf in 'UDoppelkopf.pas' {Form1},
  mTNetworkMessage in 'mTNetworkMessage.pas',
  Kartensortieren in 'Kartensortieren.pas' {Form2},
  mTReceivingNetworkMessage in 'mTReceivingNetworkMessage.pas',
  mTSendingNetworkMessage in 'mTSendingNetworkMessage.pas',
  StringKonstanten in 'StringKonstanten.pas',
  Verbinden in 'Verbinden.pas' {Form3};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
