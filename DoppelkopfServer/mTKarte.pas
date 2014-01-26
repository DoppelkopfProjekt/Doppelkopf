unit mTKarte;

interface

type

dkKartentyp = (Koenig, Zehn, Ass, Bube, Dame);
dkFarbe = (Karo, Herz, Pik, Kreuz, Keine);
dkErgebnis = (schwaecher, staerker, gleich);
dkSpielModus = (Normal, Bubensolo, Damensolo, Fleischloser);


TKarte = class
private
  FKartentyp: dkKartentyp;
  FFarbe: dkFarbe;
  FIstTrumpf: boolean;
  FCode: string;
  FSpielModus: dkSpielModus;
public
  constructor create(pCode: string);
  procedure setSpielModus(pSpielModus: dkSpielModus);
  property Farbe: dkFarbe read FFarbe;
  property Kartentyp: dkKartentyp read FKartentyp;
  property IstTrumpf: Boolean read FIstTrumpf write FIstTrumpf;
  property Code: string read FCode;
  property SpielModus: dkSpielModus read FSpielModus write setSpielModus;
  function kannKarteMichStechen(pKarte: TKarte): dkErgebnis;
end;

implementation

procedure TKarte.setSpielModus(pSpielModus: dkSpielModus);
begin
  FSpielModus := pSpielModus;
  if self.SpielModus = Normal then
  begin
    FIstTrumpf := (FKartentyp = Bube) or (FKartentyp = Dame) or (FFarbe = Karo) or ((FKartentyp = Zehn) and (FFarbe = Herz));
  end;
  if self.SpielModus = Bubensolo then
  begin
    FIstTrumpf := FKartentyp = Bube;
  end;
  if self.SpielModus = Damensolo then
  begin
    FIstTrumpf := FKartentyp = Dame;
  end;
  if self.SpielModus = Fleischloser then
  begin
    FIstTrumpf := false;
  end;
end;

constructor TKarte.create(pCode: string);
var farbString, typString: string;
begin
  FCode := pCode;
  farbString := copy(pCode, 1, 2);
  typString := copy(pCode, 3, 1);

  if farbString = 'KR' then FFarbe := Kreuz;
  if farbString = 'HE' then FFarbe := Herz;
  if farbString = 'PI' then FFarbe := Pik;
  if farbString = 'KA' then FFarbe := Karo;
  if typString = '10' then FKartentyp := Zehn;
  if typString = 'K' then FKartentyp := Koenig;
  if typString = 'D' then FKartentyp := Dame;
  if typString = 'B' then FKartentyp := Bube;
  if typString = 'A' then FKartentyp := Ass;

  self.SpielModus := Normal;
end;

function TKarte.kannKarteMichStechen(pKarte: TKarte): dkErgebnis;
begin
  result := gleich;
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
        if (self.Kartentyp = Zehn) and (self.Farbe = Herz) and not (pKarte.Kartentyp = Zehn) and not (pKarte.Farbe = Herz) then result := schwaecher;
        if (self.Kartentyp = Zehn) and (self.Farbe = Herz) and (pKarte.Kartentyp = Zehn) and (pKarte.Farbe = Herz) then result := gleich;
        if not (self.Kartentyp = Zehn) and not (self.Farbe = Herz) and (pKarte.Kartentyp = Zehn) and (pKarte.Farbe = Herz) then result := staerker;
      end;
  end;
end;

end.
