unit UDoppelkopf;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, StdCtrls, jpeg, mtNetworkMessage, UVorbehaltabfrage,
  ScktComp, Stringkonstanten;

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
    Image12: TImage;
    Image11: TImage;
    Image10: TImage;
    Image13: TImage;
    Edit1: TEdit;
    Edit2: TEdit;
    Label7: TLabel;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Clientsocket1 : tClientsocket;
    Edit3: TEdit;
    procedure Terminalstarten1Click(Sender: TObject);
    procedure Konsoleschlieen1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure closechatClick(Sender: TObject);
    procedure openchatClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Kartemarkieren(Nummer: string);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure Button5Click(Sender: TObject);
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
  karten_client: TStringList;
  verbunden: boolean;
  Vorbehalte_Art, Vorbehaltgeber: String;
  Netzwerknachricht: tNetworkmessage;
  nameistangegeben: Boolean;
  spielhatbegonnen: boolean;
  allespieler: Array  [0..3] of String;
  alleansagenAnsage: Array of String [10];
  alleansagenSpieler: Array of String [10];
  alleansagenNummer: Integer;
  amzug:boolean;
  Vorbehaltabfrage: UVorbehaltabfrage.TForm2;
  Vorbehaltabfrage_geglueckt, vorbehaltangemeldet: Boolean;
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

procedure TForm1.FormCreate(Sender: TObject);
var
i:Integer;
begin
  Form1.ClientHeight:=630;
  //Memo1.visible:=true;
  Form1.clientwidth:=895;
  //chatoffen:=true;
  High:=226;
  //Memo1.Visible:=false;
  alleansagenNummer:=0;
  amzug:=false;

  Vorbehaltabfrage:=UVorbehaltabfrage.TForm2.Create(Form2);
  for I := 0 to 13 do
  tImage(FindComponent('image'+IntToStr(i))).Picture.loadfromfile('Karten/Back.jpg');
end;

procedure TForm1.Button1Click(Sender: TObject);
var
sendung: String;
begin
sendung := Karten[strtoint(markiertekarte)];
ClientSocket1.Socket.SendText(KARTE_LEGEN+'#'+sendung+'#');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ClientSocket1.Host:=Edit1.Text; //Die IP oder der Hostname wird festgelegt
  ClientSocket1.Port:=StrToInt(Edit2.Text); //Der Port wird festgelegt
  ClientSocket1.Open; //Verbindung zum Server wird hergestellt
  Button4.Enabled:=true;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  ClientSocket1.Socket.SendText(ANSAGE + '#' + inputbox('neue Ansage', ANSAGE_RE + ', ' + ANSAGE_KONTRA + ', ' + ANSAGE_KEINENEUN  + ', ' +  ANSAGE_KEINESECHS  + ', ' +  ANSAGE_KEINEDREI  + ', ' + ANSAGE_SCHWARZ,'')+ '#');
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  ClientSocket1.Socket.SendText(CONNECT + '#' + Edit3.Text +'#');
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  clientsocket1.Close;
end;

procedure TForm1.ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
var
i: Integer;
begin
Netzwerknachricht:=tNetworkmessage.Create(Socket.ReceiveText);
memo1.lines.add('// '+Netzwerknachricht.key+';'+Netzwerknachricht.parameter[0]);
if Netzwerknachricht.key = CONNECT then                             //connect Verbindnug erstellt
    begin
      if Netzwerknachricht.parameter[0] = 'YES' then
      begin
        verbunden:=true;
        Memo1.Lines.add('zum Server verbunden');
      end
      else if Netzwerknachricht.parameter[0] = 'NO' then
        Memo1.Lines.add('Server ist voll');
    end
else if Netzwerknachricht.key = SPIELBEGINN then                          //Name der Spieler werden geschickt
    begin
      ClientSocket1.Socket.SendText(SPIELBEGINN+ '#YES#');
        for i := 0 to 3  do
        begin
          allespieler[i]:=Netzwerknachricht.parameter[i];
          tLabel(FindComponent('Label'+inttostr(i+3))).caption:=allespieler[i];
        end;
    end
else if Netzwerknachricht.key = KARTEN then                        //Karten Spieler bekommt die Karten geschickt
    begin
      ClientSocket1.Socket.SendText(KARTEN+'#YES#');
      spielhatbegonnen:=true;
      Karten_client.Clear;
      Karten_client := Netzwerknachricht.parameter;
      for i := 0 to 9 do
        tImage(FindComponent('image'+IntToStr(i))).Picture.assign(nil);
      for i := 0 to Karten_client.Count-1 do
      begin
        tImage(FindComponent('image'+IntToStr(i))).picture.loadfromfile(Netzwerknachricht.parameter[i]);
      end;
    end
else if Netzwerknachricht.key = VORBEHALTE_ABFRAGEN then              //Vorbehaltabfrage Hat der Spieler einen Vorbahlt?
    begin
      ClientSocket1.Socket.SendText(VORBEHALTE_ABFRAGEN + '#Yes#');
      ClientSocket1.Socket.SendText(VORBEHALT_ANMELDEN +'#' + inputbox('Vorbehalte', (VORBEHALT_DAMENSOLO +', '+ VORBEHALT_BUBENSOLO +', '+ VORBEHALT_FLEISCHLOSER +', '+ VORBEHALT_HOCHZEIT +', '+ VORBEHALT_NICHTS), 'hier eingeben')+'#');
    end
else if Netzwerknachricht.key = VORBEHALT_ANMELDEN then
    begin
      if Netzwerknachricht.parameter[0] = YES then
        vorbehaltangemeldet:=true;
    end
else if Netzwerknachricht.key = SOLO then                     //Vorbehalt Ein Spieler hat einen gültigen Vorbehalt gelegt
    begin
      ClientSocket1.Socket.SendText(SOLO+ '#YES#');
      Vorbehalte_Art := Netzwerknachricht.parameter[1];
      Vorbehaltgeber := Netzwerknachricht.parameter[0];
    end
else if Netzwerknachricht.key = WELCHE_KARTE then            //Welche Karte legen Spieler bekommt die Anweisung, dass er am Zug ist
    begin
      ClientSocket1.Socket.SendText(WELCHE_KARTE+ '#YES#');                        //hier mit YES antworten
      Showmessage ('Welche Karte soll gespielt werden?');
      amzug:=true;
    end
else if Netzwerknachricht.key = ANSAGE_GEMACHT then                 //Ansageanfrage
    begin
      if Netzwerknachricht.parameter[0] = 'YES' then showmessage ('deine Ansage ist geglückt');
      if Netzwerknachricht.parameter[0] = 'NO' then showmessage ('deine Ansage ist fehlgeschlagen')
      else
      begin
        alleansagenNummer:=alleansagenNummer+1;
        alleansagenAnsage[alleansagenNummer] := Netzwerknachricht.parameter[1];
        alleansagenSpieler[alleansagenNummer] := Netzwerknachricht.parameter[0];
        Memo1.lines.add('Spieler '+ alleansagenSpieler[alleansagenNummer] + ' hat folgende Ansage gemacht: ' + alleansagenAnsage[alleansagenNummer]);
        ClientSocket1.Socket.SendText(ANSAGE_GEMACHT + '#YES#')
      end;
    end
else if Netzwerknachricht.key = KARTE_LEGEN then           //welche Karten testen gelegte Karte wird getestet
      begin
        if Netzwerknachricht.parameter[0] = 'YES' then
        begin
          Memo1.Lines.add ('Karte erfolgreich gelegt');
          amzug:=false
        end;
        if Netzwerknachricht.parameter[0] = 'NO' then
          showmessage('neue Karte legen');
      end
else if Netzwerknachricht.key = AKTUELLER_STICH then               //aktueller Stich gibt den kompletten momentanen Stich
      begin
        ClientSocket1.Socket.SendText(AKTUELLER_STICH+'#YES#');
        for I := 0 to Netzwerknachricht.parameter.count-1 do
        begin
          tImage(FindComponent('image'+IntToStr(i+10))).Picture.loadfromfile('Karten/'+Netzwerknachricht.parameter[i]+'.jpg');
        end;
      end
else if Netzwerknachricht.key = GEWINNER_STICH then
      begin
        ClientSocket1.Socket.SendText(GEWINNER_STICH+'#YES#');
        Memo1.lines.Add(Netzwerknachricht.parameter[0])
      end
else if Netzwerknachricht.key = GEWINNER_SPIEL then                      //Gewinner Sieger werden genannt
      begin
        ClientSocket1.Socket.SendText(GEWINNER_SPIEL+'#YES#');
        Memo1.Lines.add('Team: ' + Netzwerknachricht.parameter[0] + ' hat ' + Netzwerknachricht.parameter[1] + ' Punkte.');
      end
else if Netzwerknachricht.key = 'aktueller Punktestand' then         //aktueller Punktestand Liste mit den Punkten der vielen Spieler wird gegeben
      begin
        ClientSocket1.Socket.SendText('Gewinner, YES');
        for I := 0 to 3 do
          Memo1.Lines.add(Netzwerknachricht.parameter[2*i] + ' hat ' + Netzwerknachricht.parameter[2*i+1] + ' Punkte.');
      end;
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
  Image10.top:=Image10.top-High;
  Image11.top:=Image11.top-High;
  Image12.top:=Image12.top-High;
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
  Image10.top:=Image10.top+High;
  Image11.top:=Image11.top+High;
  Image12.top:=Image12.top+High;
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
