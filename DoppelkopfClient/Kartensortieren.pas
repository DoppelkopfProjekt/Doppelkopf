unit Kartensortieren;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
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
    procedure Kartenlegen ();
    procedure Image1StartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
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
  for I := 0 to 9 do
  begin
    tImage(FindComponent('image'+zusortierendeKarten[3*i+1])).Picture.loadfromfile('Karten/'+ zusortierendeKarten[3*i+2] +'.jpg');
  end;
end;

procedure TForm2.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  move:=true;
  pos[1]:=Mouse.CursorPos.X-Form2.Left-8-Button1.Left;
  pos[2]:=Mouse.CursorPos.Y-Form2.Left-31-Button1.top;
end;

procedure TForm2.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if move then
  begin
    Button1.left:=Mouse.CursorPos.X-Form2.Left-8-pos[1];
    Button1.top:=Mouse.CursorPos.Y-Form2.Top-31-pos[2];
  end;
end;

procedure TForm2.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  move:=false;
end;

procedure TForm2.Image1StartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  Button1.left:=Mouse.CursorPos.X-Form2.Left;
  Button1.top:=Mouse.CursorPos.Y-Form2.Top;
end;

end.
