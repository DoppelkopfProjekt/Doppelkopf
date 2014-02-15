unit Kartensortieren;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image0: TImage;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  zusortierendeKarten:tstringlist;
    { Private-Deklarationen }
  public
    property meinekarten: tStringlist read zusortierendeKarten write zusortierendeKarten;
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
var
i:integer;
begin
  zusortierendekarten.clear;
  for I := 0 to 9 do
  begin
    zusortierendekarten.Add('Image'+inttostr(i));
  //  zusortierendekarten.add(Karten_client[strtoint(i)])
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
var
i:integer;
begin
  for I := 0 to 9 do
  begin
//    tImage(FindComponent(zusortierendekarten[i*2])).picture.loadfromfile('Karten/'+zusortierendekarten[i*2+1]+'.jpg');
  end;
end;

end.
