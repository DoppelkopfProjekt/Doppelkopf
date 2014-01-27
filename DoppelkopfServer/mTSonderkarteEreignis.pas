unit mTSonderkarteEreignis;

interface

uses mtKarte;

type

TSonderKarteEreignis = class
private
  FSpieler: Pointer;
  FKarte: TKarte;
public
  constructor Create(pKarte: TKarte; pSpieler: Pointer);
  property Spieler: Pointer read FSpieler;
  property Karte: TKarte read FKarte;
end;

implementation

constructor TSonderKarteEreignis.Create(pKarte: TKarte; pSpieler: Pointer);
begin
  FSpieler := pSpieler;
  FKarte := pKarte;
end;

end.
