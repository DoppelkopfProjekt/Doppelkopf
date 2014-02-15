program PDoppelkopf;

uses
  Forms,
  UDoppelkopf in 'UDoppelkopf.pas' {Form1},
  mTNetworkMessage in 'mTNetworkMessage.pas',
  StringKonstanten in 'StringKonstanten.pas',
  Kartensortieren in 'Kartensortieren.pas' {Form2};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
