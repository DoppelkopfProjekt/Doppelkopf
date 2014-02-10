unit mTKarte;

interface

type

dkKartentyp = (dkKoenig, dkZehn, dkAss, dkBube, dkDame);
dkFarbe = (dkKaro, dkHerz, dkPik, dkKreuz, dkKeine);
dkErgebnis = (dkschwaecher, dkstaerker, dkgleich);
dkSpielModus = (dkDamensolo, dkBubensolo, dkFleischloser, dkNormal, dkHochzeit);


TKarte = class
private
  FKartentyp: dkKartentyp;
  FFarbe: dkFarbe;
  FIstTrumpf: boolean;
  FCode: string;
  FSpielModus: dkSpielModus;
  FPunkte: Integer;
public
  constructor create(pCode: string);
  procedure setSpielModus(pSpielModus: dkSpielModus);
  property Farbe: dkFarbe read FFarbe;
  property Kartentyp: dkKartentyp read FKartentyp;
  property IstTrumpf: Boolean read FIstTrumpf write FIstTrumpf;
  property Code: string read FCode;
  property SpielModus: dkSpielModus read FSpielModus write setSpielModus;
  property Punkte: Integer read FPunkte;
  function kannKarteMichStechen(pKarte: TKarte): dkErgebnis;
end;

implementation

procedure TKarte.setSpielModus(pSpielModus: dkSpielModus);
begin
  FSpielModus := pSpielModus;
  if self.SpielModus = dkNormal then
  begin
    FIstTrumpf := (FKartentyp = dkBube) or (FKartentyp = dkDame) or (FFarbe = dkKaro) or ((FKartentyp = dkZehn) and (FFarbe = dkHerz));
  end;
  if self.SpielModus = dkBubensolo then
  begin
    FIstTrumpf := FKartentyp = dkBube;
  end;
  if self.SpielModus = dkDamensolo then
  begin
    FIstTrumpf := FKartentyp = dkDame;
  end;
  if self.SpielModus = dkFleischloser then
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

  if farbString = 'KR' then FFarbe := dkKreuz;
  if farbString = 'HE' then FFarbe := dkHerz;
  if farbString = 'PI' then FFarbe := dkPik;
  if farbString = 'KA' then FFarbe := dkKaro;
  if typString = '10' then
  begin
    FKartentyp := dkZehn;
    FPunkte := 10;
  end;
  if typString = 'K' then
  begin
    FKartentyp := dkKoenig;
    FPunkte := 4;
  end;
  if typString = 'D' then
  begin
    FKartentyp := dkDame;
    FPunkte := 3;
  end;
  if typString = 'B' then
  begin
    FKartentyp := dkBube;
    FPunkte := 2;
  end;
  if typString = 'A' then
  begin
    FKartentyp := dkAss;
    FPunkte := 11;
  end;

  self.SpielModus := dkNormal;
end;

function TKarte.kannKarteMichStechen(pKarte: TKarte): dkErgebnis;
begin
  result := dkgleich;
  if not self.IstTrumpf and pKarte.IstTrumpf then result := dkstaerker
  else
  begin
    if self.IstTrumpf and not pKarte.IstTrumpf then result := dkschwaecher
      else
      begin
        if self.IstTrumpf and pKarte.IstTrumpf then
        begin
          if self.Kartentyp < pKarte.Kartentyp then result := dkstaerker;
          if self.Kartentyp > pKarte.Kartentyp then result := dkschwaecher;
          if self.Kartentyp = pKarte.Kartentyp then
          begin
            if self.Farbe < pKarte.Farbe then result := dkstaerker;
            if self.Farbe > pKarte.Farbe then result := dkschwaecher;
            if self.Farbe = pKarte.Farbe then result := dkgleich;
          end;
        end;
        if (self.Kartentyp = dkZehn) and (self.Farbe = dkHerz) and not (pKarte.Kartentyp = dkZehn) and not (pKarte.Farbe = dkHerz) then result := dkschwaecher;
        if (self.Kartentyp = dkZehn) and (self.Farbe = dkHerz) and (pKarte.Kartentyp = dkZehn) and (pKarte.Farbe = dkHerz) then result := dkgleich;
        if not (self.Kartentyp = dkZehn) and not (self.Farbe = dkHerz) and (pKarte.Kartentyp = dkZehn) and (pKarte.Farbe = dkHerz) then result := dkstaerker;
      end;
  end;
end;

end.
