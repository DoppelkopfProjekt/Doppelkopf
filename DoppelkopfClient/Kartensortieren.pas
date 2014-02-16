unit Kartensortieren;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Image0: TImage;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    procedure Kartenlegen ();
    procedure Image0StartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure Image0MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image0MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image0MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
  private
  zusortierendeKarten: tStringlist;
    { Private-Deklarationen }
  public
    property meinekarten: tStringlist read zusortierendeKarten write zusortierendeKarten;
  end;

var
  Form2: TForm2;
  move:boolean;
  pos:array [1..2] of integer;

implementation

{$R *.dfm}

procedure tForm2.kartenlegen();
var
i:integer;
begin
  for i := 0 to 9 do
  begin
    tImage(FindComponent('image'+zusortierendeKarten[3*i+1])).Picture.loadfromfile('Karten/'+ zusortierendeKarten[3*i+2] +'.jpg');
  end;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
self.kartenlegen();
end;

procedure TForm2.Image0MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  move:=true;
  pos[1]:=Mouse.CursorPos.X-Form2.Left-8-tImage(FindComponent('image'+(Sender as TComponent).Name[6])).Left;
  pos[2]:=Mouse.CursorPos.Y-Form2.Left-31-tImage(FindComponent('image'+(Sender as TComponent).Name[6])).top;
end;

procedure TForm2.Image0MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if move then
  begin
    tImage(FindComponent('image'+(Sender as TComponent).Name[6])).left:=Mouse.CursorPos.X-Form2.Left-8-pos[1];
   tImage(FindComponent('image'+(Sender as TComponent).Name[6])).top:=Mouse.CursorPos.Y-Form2.Top-31-pos[2];
  end;
end;

procedure TForm2.Image0MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  move:=false;
end;

procedure TForm2.Image0StartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  tImage(FindComponent('image'+(Sender as TComponent).Name[6])).left:=Mouse.CursorPos.X-Form2.Left;
  tImage(FindComponent('image'+(Sender as TComponent).Name[6])).top:=Mouse.CursorPos.Y-Form2.Top;
end;

end.
