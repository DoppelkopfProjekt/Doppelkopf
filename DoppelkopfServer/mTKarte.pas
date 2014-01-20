unit mTKarte;

interface

type

dkKArtentyp = (Zehn, Bube, Dame, König, Ass);
dkFarbe = (Pik, Karo, Kreuz, Herz);

TKarte = class
private

  FKartentyp: dkKartentyp;
  FFarbe: dkFarbe;
  FIstTrumpf: boolean;

public

  constructor create(pCode: string);
  property Farbe: dkFarbe read FFarbe write FFarbe;
  property IstTrumpf: Boolean read FIstTrumpf write FIstTrumpf;



end;

implementation

constructor TKarte.create(pCode: string);
var farbString, typString: string;
begin
  farbString = copy(pCode, 1, 2);
  typeString = copy(pCode, 3, 1);

  if farbString = 'KR' then FFarbe := Kreuz;
  if farbString = 'HE' then FFarbe := Herz;
  if farbString = 'PI' then FFarbe := Pik;
  if farbString = 'KA' then FFarbe := Karo;
  if typeString = '10' then FKartentyp := Zehn;
  if typeString = 'K' then FKartentyp := König;
  if typeString = 'D' then FKartentyp := Dame;
  if typeString = 'B' then FKartentyp := Bube;
  if typeString = 'A' then FKartentyp := Ass;
  FIstTrump = (FKartentyp = Bube or FKartentyp = Dame or FFarbe = Karo 4
    or (FKartentype = Zehn and FFarbe = Herz);





end;

end.
