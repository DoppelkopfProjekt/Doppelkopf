unit mTDoppelkopfSpiel;

interface

uses mTSpielerManager, mTSpieler, mTStich;

type

TDoppelkopfSpiel = class
private
  FSpielerManager: TSpielerManager;
  FStich: TStich;
public
  constructor Create;

  //TSpielerManager
  function addPlayer(pSpieler: TSpieler): Boolean;
  function playerForIP(pIP: string): TSpieler;
  function playerForName(pName: string): TSpieler;
  function playerForIndex(pIndex: Integer): TSpieler;
  procedure deletePlayerWithIP(pIP: string);
  function countConnectedPlayer: Integer;
end;


implementation

constructor TDoppelkopfSpiel.Create;
begin
  FSpielerManager := TSpielerManager.Create;
  //FStich := TStich.create;
end;

function TDoppelkopfSpiel.addPlayer(pSpieler: TSpieler): Boolean;
begin
  result := self.FSpielerManager.addPlayer(pSpieler);
end;

function TDoppelkopfSpiel.playerForIP(pIP: string): TSpieler;
begin
  result := self.FSpielerManager.playerForIP(pIP);
end;

function TDoppelkopfSpiel.playerForName(pName: string): TSpieler;
begin
  result := self.FSpielerManager.playerForName(pName);
end;

function TDoppelkopfSpiel.playerForIndex(pIndex: Integer): TSpieler;
begin
  result := self.FSpielerManager.playerForIndex(pIndex);
end;

procedure TDoppelkopfSpiel.deletePlayerWithIP(pIP: string);
begin
  self.FSpielerManager.deletePlayerWithIP(pIP);
end;

function TDoppelkopfSpiel.countConnectedPlayer;
begin
  result := self.FSpielerManager.countConnectedPlayer;
end;

end.
