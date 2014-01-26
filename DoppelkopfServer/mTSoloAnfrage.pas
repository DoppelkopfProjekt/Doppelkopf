unit mTSoloAnfrage;

interface

uses mTKarte, mTSpieler;

type

TSoloAnfrage = class
private
  FArt: dkSpielModus;
  FSender: TSpieler;
  FPrioritaet: Integer;
public
  constructor Create(pArt: dkSpielModus; pSender: TSpieler);
  property Art: dkSpielModus read FArt;
  property Sender: TSpieler read FSender;
  property Prioritaet: Integer read FPrioritaet;
end;

implementation

constructor TSoloAnfrage.Create(pArt: dkSpielModus; pSender: TSpieler);
begin
  self.FArt := pArt;
  self.FSender := pSender;
  self.Prioritaet := self.FArt * 100 + self.FSender;
end;

end.
