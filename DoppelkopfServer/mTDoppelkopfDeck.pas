unit mTDoppelkopfDeck;

/////////************** An das randomize; denken!!!!!!!!!!!!! *************************///////////////

interface

uses Classes, mTKarte;

type

TDoppelkopfDeck = class
private
  FKarten: TList;
public
  constructor Create;
  function getRandomCard: TKarte;
end;

implementation

constructor TDoppelkopfDeck.Create;
begin
  FKarten.Add(TKarte.create('KAK'));
  //So müssen alle 40 Karten erstellt werden...
end;

function TDoppelkopfDeck.getRandomCard: TKarte;
var index: Integer;
begin
  index := random(FKarten.Count)-1;
  result := FKarten[index];
  FKarten.Delete(index);
end;

end.
