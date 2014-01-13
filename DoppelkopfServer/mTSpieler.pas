unit mTSpieler;

interface

uses Classes, SysUtils;

type
  TSpieler = class
  private
    FName: string;
    FIP: string;
  public
    property Name: string read FName write FName;
    property IP: string read FIP write FIP;
  end;

  TSpielerManager = class
  private
    FSpieler: TList;
  public
    function addPlayer(pSpieler: TSpieler): Boolean;
    function playerForIP(pIP: string): TSpieler;
    function playerForName(pName: string): TSpieler;
    function PlayerForIndex(pIndex: Integer): TSpieler;
    procedure deletePlayerWithIP(pIP: string);
    function countConnectedPlayer: Integer;
    constructor Create;
  end;

implementation

constructor TSpielerManager.create;
begin
  FSpieler := TList.create;
end;

function TSpielerManager.PlayerForIndex(pIndex: Integer): TSpieler;
begin
  result := FSpieler[pIndex];
end;

function TSpielerManager.countConnectedPlayer: Integer;
var count, i: Integer;
begin
  count := 0;
  for i := 0 to FSpieler.count-1 do
  begin
    if TSpieler(FSpieler[i]).name <> '' then
    begin
      inc(count);
    end;
  end;
  result := count;
end;

function TSpielerManager.addPlayer(pSpieler: TSpieler): Boolean;
begin
  if FSpieler.count >= 4 then
  begin
    result := false;
  end else
  begin
    result := true;
    FSpieler.Add(pSpieler);
  end;
end;

function TSpielerManager.playerForIP(pIP: string): TSpieler;
var i: integer;
begin
  result := nil;
  for i:= 0 to FSpieler.Count-1 do
  begin
    if TSpieler(FSpieler[i]).IP = pIP then
    begin
      result := FSpieler[i];
      break;
    end;
  end;
end;


function TSpielerManager.playerForName(pName: String): TSpieler;
var i: integer;
begin
  result := nil;
  for i:= 0 to FSpieler.Count-1 do
  begin
    if TSpieler(FSpieler[i]).Name = pName then
    begin
      result := FSpieler[i];
      break;
    end;
  end;
end;

procedure TSpielerManager.deletePlayerWithIP(pIP: string);
var i:integer;
begin
  for i:= 0 to FSpieler.Count-1 do
  begin
    if TSpieler(FSpieler[i]).IP = pIP then
    begin
      FSpieler.delete(i);
      break;
    end;
  end;
end;






end.







