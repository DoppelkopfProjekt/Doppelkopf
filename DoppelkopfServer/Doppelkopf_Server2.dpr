program Doppelkopf_Server2;

uses
  Forms,
  GUI in 'GUI.pas' {Form1},
  mTNetworkMessage in 'mTNetworkMessage.pas',
  mTDoppelkopfserver in 'mTDoppelkopfserver.pas',
  mServerVerbindung in 'netzklassen\mServerVerbindung.pas',
  mClient in 'netzklassen\mClient.pas',
  mConnection in 'netzklassen\mConnection.pas',
  mList in 'netzklassen\mList.pas',
  mServer in 'netzklassen\mServer.pas',
  mTSpieler in 'mTSpieler.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
