unit UDoppelkopf;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, StdCtrls, jpeg, mtClient;

type
  TForm1 = class(TForm)
    Image1: TImage;
    MainMenu1: TMainMenu;
    Spiel1: TMenuItem;
    NeuesSpiel1: TMenuItem;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Chat1: TMenuItem;
    openchat: TMenuItem;
    closechat: TMenuItem;
    Terminal1: TMenuItem;
    Terminalstarten1: TMenuItem;
    Konsoleschlieen1: TMenuItem;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image0: TImage;
    Verbinden1: TMenuItem;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Image13: TImage;
    Image12: TImage;
    Image11: TImage;
    Image14: TImage;
    Edit1: TEdit;
    Edit2: TEdit;
    procedure Terminalstarten1Click(Sender: TObject);
    procedure Konsoleschlieen1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure closechatClick(Sender: TObject);
    procedure openchatClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Kartemarkieren(Nummer: string);
    procedure NeuesSpiel1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;
  Chatoffen: boolean;
  High: Integer;
  chosencard: Integer;
  markiertekarte: string;
  Client: tClient;

implementation

{$R *.DFM}

procedure TForm1.Terminalstarten1Click(Sender: TObject);
begin
  Memo1.Visible:=true;
  if chatoffen=true then
  begin
    Memo1.height:=225;
    Memo1.Top:=472;
    Memo1.Width:=460;
  end;
  if chatoffen=false then
  begin
    Memo1.height:=117;
    Memo1.Top:=520;
    Memo1.Width:=873;
  end;
end;

procedure TForm1.Konsoleschlieen1Click(Sender: TObject);
begin
  Memo1.Visible:=false;
end;

procedure TForm1.NeuesSpiel1Click(Sender: TObject);
begin
  client:=tclient.create(Edit1.Text, StrToInt(Edit2.Text));
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Form1.ClientHeight:=630;
  Memo1.visible:=true;
  Form1.clientwidth:=895;
  chatoffen:=true;
  High:=226;
  Memo1.Visible:=false;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
Image1.Picture.loadfromfile('Karten/Back.jpg');
Image2.Picture.loadfromfile('Karten/Back.jpg');
Image3.Picture.loadfromfile('Karten/Back.jpg');
Image4.Picture.loadfromfile('Karten/Back.jpg');
Image5.Picture.loadfromfile('Karten/Back.jpg');
Image6.Picture.loadfromfile('Karten/Back.jpg');
Image7.Picture.loadfromfile('Karten/Back.jpg');
Image8.Picture.loadfromfile('Karten/Back.jpg');
Image9.Picture.loadfromfile('Karten/Back.jpg');
Image0.Picture.loadfromfile('Karten/Back.jpg');
Image11.Picture.loadfromfile('Karten/Back.jpg');
Image12.Picture.loadfromfile('Karten/Back.jpg');
Image13.Picture.loadfromfile('Karten/Back.jpg');
Image14.Picture.loadfromfile('Karten/Back.jpg');
end;

procedure TForm1.closechatClick(Sender: TObject);
begin
  if chatoffen=true then
  begin
  Memo2.Visible:=false;
  Memo3.Visible:=false;
  Label2.top:=Label2.top-High;
  Label3.top:=Label3.top-High;
  Label4.top:=Label4.top-High;
  Label5.top:=Label5.top-High;
  Label6.top:=Label6.top-High;
  Image11.top:=Image11.top-High;
  Image12.top:=Image12.top-High;
  Image14.top:=Image14.top-High;
  Image13.top:=Image13.top-High;
  chatoffen:=false;
  Terminalstarten1.Click;
  end;
end;

procedure TForm1.openchatClick(Sender: TObject);
begin
  if chatoffen=false then
  begin
  Memo2.Visible:=true;
  Memo3.Visible:=true;
  Label2.top:=Label2.top+High;
  Label3.top:=Label3.top+High;
  Label4.top:=Label4.top+High;
  Label5.top:=Label5.top+High;
  Label6.top:=Label6.top+High;
  Image11.top:=Image11.top+High;
  Image12.top:=Image12.top+High;
  Image14.top:=Image14.top+High;
  Image13.top:=Image13.top+High;
  chatoffen:=true;
  Terminalstarten1.Click;
  end;
end;

procedure TForm1.Image1Click(Sender: TObject);
begin
Kartemarkieren((Sender as TComponent).Name[6]);
end;

procedure TForm1.Kartemarkieren(Nummer:string);
begin
tImage(FindComponent('image'+nummer)).Height:=tImage(FindComponent('image'+nummer)).Height+6;
tImage(FindComponent('image'+nummer)).width:=tImage(FindComponent('image'+nummer)).width+6;
tImage(FindComponent('image'+nummer)).left:=tImage(FindComponent('image'+nummer)).left-3;
tImage(FindComponent('image'+nummer)).top:=tImage(FindComponent('image'+nummer)).top-3;

if (markiertekarte <> '') then
begin
  tImage(FindComponent('image'+markiertekarte)).Height:=tImage(FindComponent('image'+markiertekarte)).Height-6;
  tImage(FindComponent('image'+markiertekarte)).width:=tImage(FindComponent('image'+markiertekarte)).width-6;
  tImage(FindComponent('image'+markiertekarte)).left:=tImage(FindComponent('image'+markiertekarte)).left+3;
  tImage(FindComponent('image'+markiertekarte)).top:=tImage(FindComponent('image'+markiertekarte)).top+3;
end;
markiertekarte:=nummer;
end;
end.
