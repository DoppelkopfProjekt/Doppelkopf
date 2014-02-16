unit Kartensortieren;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Image20: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Image14: TImage;
    Image15: TImage;
    Image16: TImage;
    Image17: TImage;
    Image18: TImage;
    Image19: TImage;
    ProgressBar1: TProgressBar;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Button2: TButton;
    procedure Kartenlegen ();
    procedure Image20StartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure Image20MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image20MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image20MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
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
  Kartensort: Array [1..10] of TStringlist;


implementation

{$R *.dfm}

procedure tForm2.kartenlegen();
var
i:integer;
begin
  for i := 0 to 9 do
  begin
    Kartensort[i]:=tStringlist.create;
    Kartensort[i].add(zusortierendeKarten[4*i+0]);
    Kartensort[i].add(zusortierendeKarten[4*i+1]);
    Kartensort[i].add(zusortierendeKarten[4*i+2]);
    Kartensort[i].add(zusortierendeKarten[4*i+3]);
  end;
  for I := 0 to 9 do
  begin
    tImage(FindComponent('image'+Kartensort[i][0])).top:=STRTOINT(Kartensort[i][1]);
    tImage(FindComponent('image'+Kartensort[i][0])).left:=STRTOINT(Kartensort[i][2]);
    tImage(FindComponent('image'+Kartensort[i][0])).picture.loadfromfile('Karten/'+Kartensort[i][3]+'.jpg');
  end;
end;

procedure TForm2.Image20MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  move:=true;
  pos[1]:=Mouse.CursorPos.X-Form2.Left-8-tImage(FindComponent('image'+(Sender as TComponent).Name[6]+(Sender as TComponent).Name[7])).Left;
  pos[2]:=Mouse.CursorPos.Y-Form2.Left-31-tImage(FindComponent('image'+(Sender as TComponent).Name[6]+(Sender as TComponent).Name[7])).top;
end;

procedure TForm2.Image20MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if move then
  begin
    tImage(FindComponent('image'+(Sender as TComponent).Name[6]+(Sender as TComponent).Name[7])).left:=Mouse.CursorPos.X-Form2.Left-8-pos[1];
    tImage(FindComponent('image'+(Sender as TComponent).Name[6]+(Sender as TComponent).Name[7])).top:=Mouse.CursorPos.Y-Form2.Top-31-pos[2];
  end;
end;

procedure TForm2.Image20MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  move:=false;
end;

procedure TForm2.Image20StartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  tImage(FindComponent('image'+(Sender as TComponent).Name[6]+(Sender as TComponent).Name[7])).left:=Mouse.CursorPos.X-Form2.Left;
  tImage(FindComponent('image'+(Sender as TComponent).Name[6]+(Sender as TComponent).Name[7])).top:=Mouse.CursorPos.Y-Form2.Top;
end;




procedure TForm2.Button1Click(Sender: TObject);
var k,i,position,wert: integer;
zahlenfeld:Array [1..10] of Integer;
begin
 Memo1.Clear;
 MEmo2.Clear;
   for i:=1 to 10 do
    Zahlenfeld[i]:=tImage(FindComponent('image'+inttostr(i+10))).top;

   for i:= 1 to 10 do
    Memo1.Lines.add(IntToStr(Zahlenfeld[i]));

   for k:= 1 to 10 do
    begin
      position:= k;
      wert:= Zahlenfeld[k];

      for i:= k to 10 do
       begin
        if Zahlenfeld[i] < wert then
          begin
            wert := Zahlenfeld[i];
            position := i;
          end;
       end;
     Zahlenfeld[position]:= Zahlenfeld[k];
     Zahlenfeld[k]:= wert;
    end;

   for i:= 1 to 10 do
    Memo2.Lines.add(IntToStr(Zahlenfeld[i]));
  end;

procedure TForm2.Button2Click(Sender: TObject);
var i:integer;
begin
  Form2.Close;
  for i := 0 to 9 do
  begin
    zusortierendekarten[4*i+0]:=(Inttostr(i+11));
    zusortierendekarten[4*i+1]:=IntToStr((tImage(FindComponent('image'+Inttostr(i+11))).top));
    zusortierendekarten[4*i+2]:=IntToStr((tImage(FindComponent('image'+Inttostr(i+11))).left));
    zusortierendekarten[4*i+3]:=(zusortierendeKarten[4*i+3]);
  end;
end;

end.
