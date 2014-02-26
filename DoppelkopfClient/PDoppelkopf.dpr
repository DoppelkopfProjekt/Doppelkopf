program PDoppelkopf;

uses
  Forms,
  UDoppelkopf in 'UDoppelkopf.pas' {Form1},
  Kartensortieren in 'Kartensortieren.pas' {Form2},
  Verbinden in 'Verbinden.pas' {Form3},
  mTKartenstapel in 'mTKartenstapel.pas',
  mTNetworkMessage in '..\Shared\mTNetworkMessage.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
