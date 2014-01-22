unit mTKarte;

interface

type

dkKartentyp = (Koenig, Zehn, Ass, Bube, Dame);
dkFarbe = (Karo, Herz, Pik, Kreuz);
dkErgebnis = (schwaecher, staerker, gleich);

TKarte = class
private

  FKartentyp: dkKartentyp;
  FFarbe: dkFarbe;
  FIstTrumpf: boolean;

public

  constructor create(pCode: string);
  property Farbe: dkFarbe read FFarbe;
  property Kartentyp: dkKartentyp read FKartentyp;
  property IstTrumpf: Boolean read FIstTrumpf write FIstTrumpf;
  function kannKarteStechen(pKarte: TKarte): dkErgebnis;



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
  if typeString = 'K' then FKartentyp := Koenig;
  if typeString = 'D' then FKartentyp := Dame;
  if typeString = 'B' then FKartentyp := Bube;
  if typeString = 'A' then FKartentyp := Ass;
  FIstTrump = (FKartentyp = Bube or FKartentyp = Dame or FFarbe = Karo 4
    or (FKartentype = Zehn and FFarbe = Herz);
end;

function TKarte.kannKarteMichStechen(pKarte: TKarte): dkErgebnis
begin
  if not self.IstTrumpf and pKarte.IstTrumpf then result := staerker
  else
  begin
    if self.IstTrumpf and not pKarte.IstTrumpf then result := schwaecher
      else
      begin
        if self.IstTrumpf and pKarte.IstTrumpf then
        begin
          if self.Kartentyp < pKarte.Kartentyp then result := staerker;
          if self.Kartentyp > pKarte.Kartentyp then result := schwaecher;
          if self.Kartentyp = pKarte.Kartentyp then
          begin
            if self.Farbe < pKarte.Farbe then result := staerker;
            if self.Farbe > pKarte.Farbe then result := schwaecher;
            if self.Farbe = pKarte.Farbe then result := gleich;
          end;
        end;
        if self.Kartentyp = Zehn and self.Farbe = Herz and not pKarte.Kartentyp = Zehn and not pKarte.Farbe = Herz then result := schwaecher;
        if self.Kartentyp = Zehn and self.Farbe = Herz and pKarte.Kartentyp = Zehn and pKarte.Farbe = Herz then result := gleich;
        if not self.Kartentyp = Zehn and not self.Farbe = Herz and pKarte.Kartentyp = Zehn and pKarte.Farbe = Herz then result := staerker;
      end;
  end;

end;

end.
