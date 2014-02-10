program PDoppelkopf;

uses
  Forms,
  UDoppelkopf in 'UDoppelkopf.pas' {Form1},
  mtClient in 'mtClient.pas',
  mConnection in 'mConnection.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
