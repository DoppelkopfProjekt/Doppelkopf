unit mTSpielerManager;

interface

uses Classes, SysUtils, mTSpieler, Contnrs;

type

 TSpielerManager = class
  private
    FSpieler: TObjectList;
  public
    function addPlayer(pSpieler: TSpieler): Boolean;
    function playerForIP(pIP: string): TSpieler;
    function playerForName(pName: string): TSpieler;
    function playerForIndex(pIndex: Integer): TSpieler;
    procedure deletePlayerWithIP(pIP: string);
    function countConnectedPlayer: Integer;
    constructor Create;

    procedure setNewGewinnner(pSpieler: TSpieler);
  end;


implementation

constructor TSpielerManager.create;
begin
  FSpieler := TObjectList.create;
  FSpieler.OwnsObjects := False;
end;

procedure TSpielerManager.setNewGewinnner(pSpieler: TSpieler);
var newList: TObjectList;
    index, i: Integer;
begin
  newList := TObjectList.Create;
  newList.OwnsObjects := false;

  newList.Add(pSpieler);
  index := self.FSpieler.IndexOf(pSpieler);
  for i := 1 to 3 do
  begin
    inc(i);
    newList.Add(self.FSpieler[index mod 4])
  end;
  self.FSpieler.Free;
  self.FSpieler := newList;
end;

function TSpielerManager.PlayerForIndex(pIndex: Integer): TSpieler;
begin
  result := (FSpieler[pIndex-1] as TSpieler);
end;

function TSpielerManager.countConnectedPlayer: Integer;
var count, i: Integer;
begin
  count := 0;
  for i := 0 to FSpieler.count-1 do
  begin
    if (FSpieler[i] as TSpieler).name <> '' then
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
    pSpieler.setIndex(FSpieler.IndexOf(pSpieler));
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
      result := (FSpieler[i] as TSpieler);
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
      result := (FSpieler[i] as TSpieler);
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
 