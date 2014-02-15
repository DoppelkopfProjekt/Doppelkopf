unit mTNetworkMessage;

interface

uses Sysutils, Classes;

type

TNetworkMessage = class(TObject)
private
  FKey: string;
  FParameter: TStringList;
  FCreationString: string;
public
  constructor Create(s: string);
  destructor Destroy; override;
  property key: string read FKey;
  property parameter: TStringList read FParameter;
  property CreationString: string read FCreationString;
end;
implementation

function PosEx(const Substr: string; const S: string; Offset: Integer): Integer;
begin
  if Offset <= 0 then Result := 0
  else
    Result := Pos(Substr, Copy(S, Offset, Length(S)));

  if Result <> 0 then
    Result := Result + Offset - 1;
end;

constructor TNetworkMessage.Create(s: string);
var posEndKey, posComma, i: Integer;
    temp: string;
begin
  FCreationString := s;
  FParameter := TStringlist.Create;
  posEndKey := pos('#', s);
  FKey := copy(s, 1, posEndKey-1);
  for i:=posEndKey to length(s) do
  begin
    if (s[i] = '#') and (i <> length(s)) then
    begin
      posComma := posEx('#', s, i+1);
      temp := copy(s, i+1, posComma-i-1);
      self.parameter.add(temp);
    end;
  end;
  //self.parameter.delete(self.parameter.count-1);
end;

destructor TNetworkmessage.Destroy;
begin
  self.parameter.Free;
end;

end.
 