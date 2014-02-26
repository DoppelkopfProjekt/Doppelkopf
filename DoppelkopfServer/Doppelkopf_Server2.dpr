program Doppelkopf_Server2;

uses
  Forms,
  GUI in 'GUI.pas' {Form1},
  mTDoppelkopfserver in 'mTDoppelkopfserver.pas',
  mTSpieler in 'mTSpieler.pas',
  mTDoppelkopfSpiel in 'mTDoppelkopfSpiel.pas',
  mTStich in 'mTStich.pas',
  mTBlatt in 'mTBlatt.pas',
  mTSpielerManager in 'mTSpielerManager.pas',
  mTKarte in 'mTKarte.pas',
  mTDoppelkopfDeck in 'mTDoppelkopfDeck.pas',
  mTSoloAnfrage in 'mTSoloAnfrage.pas',
  mTSonderkarteEreignis in 'mTSonderkarteEreignis.pas',
  mTServer in 'mTServer.pas',
<<<<<<< HEAD
  mTExpectedTransmissionConfirmation in 'mTExpectedTransmissionConfirmation.pas';
=======
  mTExpectedTransmissionConfirmation in 'mTExpectedTransmissionConfirmation.pas',
  mTSendingNetworkMessage in 'mTSendingNetworkMessage.pas',
  mTConnection in 'mTConnection.pas';
>>>>>>> 659eb36cf6e5f870acfc99b40a34b05d07bb1ff6

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
