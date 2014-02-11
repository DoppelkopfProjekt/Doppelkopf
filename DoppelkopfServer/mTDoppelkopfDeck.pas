unit mTDoppelkopfDeck;

/////////************** An das randomize; denken!!!!!!!!!!!!! *************************///////////////

interface

uses Classes, mTKarte, contnrs;

type

TDoppelkopfDeck = class
private
  FKarten: TObjectList;
public
  constructor Create;
  function getRandomCard: TKarte;
end;

implementation

constructor TDoppelkopfDeck.Create;
begin
  FKarten := TObjectList.Create;

  FKarten.Add(TKarte.create('KA10'));
  FKarten.Add(TKarte.create('KAB'));
  FKarten.Add(TKarte.create('KAD'));
  FKarten.Add(TKarte.create('KAK'));
  FKarten.Add(TKarte.create('KAA'));
  FKarten.Add(TKarte.create('HE10'));
  FKarten.Add(TKarte.create('HEB'));
  FKarten.Add(TKarte.create('HED'));
  FKarten.Add(TKarte.create('HEK'));
  FKarten.Add(TKarte.create('HEA'));
  FKarten.Add(TKarte.create('PI10'));
  FKarten.Add(TKarte.create('PIB'));
  FKarten.Add(TKarte.create('PID'));
  FKarten.Add(TKarte.create('PIK'));
  FKarten.Add(TKarte.create('PIA'));
  FKarten.Add(TKarte.create('KR10'));
  FKarten.Add(TKarte.create('KRB'));
  FKarten.Add(TKarte.create('KRD'));
  FKarten.Add(TKarte.create('KRK'));
  FKarten.Add(TKarte.create('KRA'));
  //ab hier die Karten nochmal
  FKarten.Add(TKarte.create('KA10'));
  FKarten.Add(TKarte.create('KAB'));
  FKarten.Add(TKarte.create('KAD'));
  FKarten.Add(TKarte.create('KAK'));
  FKarten.Add(TKarte.create('KAA'));
  FKarten.Add(TKarte.create('HE10'));
  FKarten.Add(TKarte.create('HEB'));
  FKarten.Add(TKarte.create('HED'));
  FKarten.Add(TKarte.create('HEK'));
  FKarten.Add(TKarte.create('HEA'));
  FKarten.Add(TKarte.create('PI10'));
  FKarten.Add(TKarte.create('PIB'));
  FKarten.Add(TKarte.create('PID'));
  FKarten.Add(TKarte.create('PIK'));
  FKarten.Add(TKarte.create('PIA'));
  FKarten.Add(TKarte.create('KR10'));
  FKarten.Add(TKarte.create('KRB'));
  FKarten.Add(TKarte.create('KRD'));
  FKarten.Add(TKarte.create('KRK'));
  FKarten.Add(TKarte.create('KRA'));
 
  
  //So m�ssen alle 40 Karten erstellt werden...
end;

function TDoppelkopfDeck.getRandomCard: TKarte;
var index: Integer;
begin
  index := random(FKarten.Count);
  result := TKarte(FKarten[index]);
  FKarten.Delete(index);
end;

end.
