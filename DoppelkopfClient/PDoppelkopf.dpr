program PDoppelkopf;

uses
  Forms,
  UDoppelkopf in 'UDoppelkopf.pas' {Form1},
  mTNetworkMessage in 'mTNetworkMessage.pas',
  StringKonstanten in 'StringKonstanten.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
