unit UDoppelkopf;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, StdCtrls, jpeg, mtNetworkMessage, ScktComp, Stringkonstanten,
  Kartensortieren, mtSendingNetworkmessage, mtReceivingNetworkmessage, mmsystem;

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
    Edit2: TEdit;
    Label7: TLabel;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Clientsocket1 : tClientsocket;
    Edit3: TEdit;
    Button6: TButton;
    Edit4: TEdit;
    ComboBox1: TComboBox;
    Button7: TButton;
    Timer1: TTimer;
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
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Timerblub(sender: Tobject);
  private
    { Private-Deklarationen }
  public
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
  Netzwerknachricht: tReceivingNetworkmessage;
  nameistangegeben: Boolean;
  spielhatbegonnen: boolean;
  allespieler: Array  [0..3] of String;
  alleansagenAnsage: Array of String [10];
  alleansagenSpieler: Array of String [10];
  alleansagenNummer: Integer;
  amzug:boolean;
  Vorbehaltabfrage_geglueckt, vorbehaltangemeldet: Boolean;
  kartensortierung: tStringList;
  fTimer:Ttimer;
  spielerreihenfolge: Array [0..3] of String;
  aktuellerunde: Integer;
implementation

uses Verbinden;

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
  Form1.clientwidth:=960;
  //chatoffen:=true;
  High:=226;
  //Memo1.Visible:=false;
  alleansagenNummer:=0;
  amzug:=false;
  for I := 0 to 13 do
  tImage(FindComponent('image'+IntToStr(i))).Picture.loadfromfile('Karten/Back.jpg');
  aktuelleRunde:=0;
  kartensortierung:=tstringlist.create;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
sendung: String;
begin
sendung := Karten_client[strtoint(markiertekarte)];
ClientSocket1.Socket.SendText(KEY_STRING+KARTE_LEGEN+'#'+sendung+'#');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ClientSocket1.Host:=Combobox1.Text; //Die IP oder der Hostname wird festgelegt
  ClientSocket1.Port:=StrToInt(Edit2.Text); //Der Port wird festgelegt
  ClientSocket1.Open; //Verbindung zum Server wird hergestellt
  Button4.Enabled:=true;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  ClientSocket1.Socket.SendText(KEY_STRING+ANSAGE + '#'+inputbox('neue Ansage', ANSAGE_RE + ', ' + ANSAGE_KONTRA + ', ' + ANSAGE_KEINENEUN  + ', ' +  ANSAGE_KEINESECHS  + ', ' +  ANSAGE_KEINEDREI  + ', ' + ANSAGE_SCHWARZ,'')+ '#');
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  ClientSocket1.Socket.SendText(KEY_STRING+CONNECT + '#' + Edit3.Text +'#');
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  i: Integer;
begin
  clientsocket1.Close;
  for i := 0 to 13 do
  begin
    tImage(FindComponent('image'+IntToStr(i))).Picture.loadfromfile('Karten/Back.jpg');
    Memo1.Lines.Clear;
  end;
end;

procedure TForm1.Button6Click(Sender: TObject);
var
Sortieren:tStringlist;

  I: Integer;
begin
  kartensortierung:=tstringlist.Create;
  Form2.meinekarten := kartensortierung;
  Form2.ShowModal;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  Form3.ShowModal;
  ClientSocket1.Host:=Form3.nachricht[0]; //Die IP oder der Hostname wird festgelegt
  ClientSocket1.Port:=StrToInt(Form3.nachricht[1]); //Der Port wird festgelegt
  ClientSocket1.Open; //Verbindung zum Server wird hergestellt
  ftimer:=ttimer.create(nil);
  ftimer.interval:=600;
  ftimer.enabled:=true;
  ftimer.ontimer := TimerBlub;

end;

procedure tform1.Timerblub(sender: Tobject);
begin
  ClientSocket1.Socket.SendText(KEY_STRING+CONNECT + '#' + Form3.Nachricht[2] +'#');
  ftimer.enabled:=false;
end;

procedure TForm1.ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
var
i,n,y,z, Anzahl_keys: Integer;        //wird y gebraucht?
para:String;
begin
Netzwerknachricht:=TreceivingNetworkMessage.Create(Socket.ReceiveText);
anzahl_keys:=Netzwerknachricht.count;
for n := 0 to anzahl_keys - 1 do
begin
para:='';
for i := 0 to Netzwerknachricht.messageForIndex(n).parameter.count - 1 do
begin
  para:=para+', '+Netzwerknachricht.messageForIndex(n).parameter[i];
end;
memo1.lines.add('// '+Netzwerknachricht.messageForIndex(n).key+';'+para);
if Netzwerknachricht.messageForIndex(n).key = CONNECT then                             //connect Verbindnug erstellt
    begin
      if Netzwerknachricht.messageForIndex(n).parameter[0] = 'YES' then
      begin
        verbunden:=true;
        Memo1.Lines.add('zum Server verbunden');
      end
      else if Netzwerknachricht.messageForIndex(n).parameter[0] = 'NO' then
        Memo1.Lines.add('Server ist voll');
    end
else if Netzwerknachricht.messageForIndex(n).key = SPIELBEGINN then                          //Spielbeginn Name der Spieler werden geschickt
    begin
      ClientSocket1.Socket.SendText(KEY_STRING+SPIELBEGINN+ '#YES#');
        for i := 0 to 3  do
        begin
          allespieler[i]:=Netzwerknachricht.messageForIndex(n).parameter[i];
          tLabel(FindComponent('Label'+inttostr(i+3))).caption:=allespieler[i];
        end;
    end
else if Netzwerknachricht.messageForIndex(n).key = KARTEN then                        //Karten Spieler bekommt die Karten geschickt
    begin
      ClientSocket1.Socket.SendText(KEY_STRING+KARTEN+'#YES#');
      spielhatbegonnen:=true;
      Karten_client.free;
      Karten_client := Netzwerknachricht.messageForIndex(n).parameter;
      for i := 0 to 9 do
        tImage(FindComponent('image'+IntToStr(i))).Picture.assign(nil);
      for i := 0 to Karten_client.Count-1 do
      begin
        tImage(FindComponent('image'+IntToStr(i))).picture.loadfromfile('Karten/'+Netzwerknachricht.messageForIndex(n).parameter[i]+'.jpg');
        kartensortierung.add(IntTostr(i));
        kartensortierung.add(IntTostr(i));
        kartensortierung.add(Netzwerknachricht.messageForIndex(n).parameter[i]);
      end;
    end
else if Netzwerknachricht.messageForIndex(n).key = VORBEHALTE_ABFRAGEN then              //Vorbehaltabfrage Hat der Spieler einen Vorbahlt?
    begin
      ClientSocket1.Socket.SendText(KEY_STRING+VORBEHALTE_ABFRAGEN + '#Yes#');
      ClientSocket1.Socket.SendText(KEY_STRING+VORBEHALT_ANMELDEN+ '#nichts#'); // inputbox('Vorbehalte', (VORBEHALT_DAMENSOLO +', '+ VORBEHALT_BUBENSOLO +', '+ VORBEHALT_FLEISCHLOSER +', '+ VORBEHALT_HOCHZEIT +', '+ VORBEHALT_NICHTS), 'hier eingeben')+'#');
    end
else if Netzwerknachricht.messageForIndex(n).key = VORBEHALT_ANMELDEN then
    begin
      if Netzwerknachricht.messageForIndex(n).parameter[0] = YES then
        vorbehaltangemeldet:=true;
      //if Netzwerknachricht.parameter[0] = NO then
      //  ClientSocket1.Socket.SendText(VORBEHALT_ANMELDEN +'#' + inputbox('Vorbehalte', (VORBEHALT_DAMENSOLO +', '+ VORBEHALT_BUBENSOLO +', '+ VORBEHALT_FLEISCHLOSER +', '+ VORBEHALT_HOCHZEIT +', '+ VORBEHALT_NICHTS), 'hier eingeben')+'#');
    end
else if Netzwerknachricht.messageForIndex(n).key = SOLO then                     //Vorbehalt Ein Spieler hat einen g�ltigen Vorbehalt gelegt
    begin
    if Netzwerknachricht.messageForIndex(n).parameter.count = 2 then
      begin
        Vorbehalte_Art := Netzwerknachricht.messageForIndex(n).parameter[1];
        Vorbehaltgeber := Netzwerknachricht.messageForIndex(n).parameter[0];
      end;
      ClientSocket1.Socket.SendText(KEY_STRING+SOLO+ '#YES#');
    end
else if Netzwerknachricht.messageForIndex(n).key = WELCHE_KARTE then            //Welche Karte legen Spieler bekommt die Anweisung, dass er am Zug ist
    begin
      ClientSocket1.Socket.SendText(KEY_STRING+WELCHE_KARTE+ '#YES#');                        //hier mit YES antworten
      Memo1.Lines.add('WELCHE KARTEN SOLL GESPIELT WERDEN?');
      amzug:=true;
    end
else if Netzwerknachricht.messageForIndex(n).key = ANSAGE_GEMACHT then                 //Ansageanfrage
    begin
      if Netzwerknachricht.messageForIndex(n).parameter[0] = 'YES' then showmessage ('deine Ansage ist gegl�ckt');
      if Netzwerknachricht.messageForIndex(n).parameter[0] = 'NO' then showmessage ('deine Ansage ist fehlgeschlagen')
      else
      begin
        alleansagenNummer:=alleansagenNummer+1;
        alleansagenAnsage[alleansagenNummer] := Netzwerknachricht.messageForIndex(n).parameter[1];
        alleansagenSpieler[alleansagenNummer] := Netzwerknachricht.messageForIndex(n).parameter[0];
        Memo1.lines.add('Spieler '+ alleansagenSpieler[alleansagenNummer] + ' hat folgende Ansage gemacht: ' + alleansagenAnsage[alleansagenNummer]);
        ClientSocket1.Socket.SendText(KEY_STRING+ANSAGE_GEMACHT + '#YES#')
      end;
    end
else if Netzwerknachricht.messageForIndex(n).key = KARTE_LEGEN then           //welche Karten testen gelegte Karte wird getestet
      begin
        if Netzwerknachricht.messageForIndex(n).parameter[0] = 'YES' then
        begin
          Memo1.Lines.add ('Karte erfolgreich gelegt');
          tImage(FindComponent('image'+markiertekarte)).Picture.loadfromfile('Karten/Back.jpg');
          amzug:=false
        end;
        if Netzwerknachricht.messageForIndex(n).parameter[0] = 'NO' then
          showmessage('neue Karte legen');
      end
else if Netzwerknachricht.messageForIndex(n).key = AKTUELLER_STICH then               //aktueller Stich gibt den kompletten momentanen Stich
      begin
        ClientSocket1.Socket.SendText(KEY_STRING+AKTUELLER_STICH+'#YES#');
        for I := aktuellerunde to Netzwerknachricht.messageForIndex(n).parameter.count-1+aktuellerunde do
        begin
          if i-aktuellerunde=0 then
          for z := 0 to 3 do
          begin
            tImage(FindComponent('image'+IntToStr(z+10))).picture.loadfromfile('Karten/Back.jpg');
          end;
          if i>3 then
          tImage(FindComponent('image'+IntToStr(i+10-4))).Picture.loadfromfile('Karten/'+Netzwerknachricht.messageForIndex(n).parameter[i-aktuellerunde]+'.jpg')
          else
          tImage(FindComponent('image'+IntToStr(i+10))).Picture.loadfromfile('Karten/'+Netzwerknachricht.messageForIndex(n).parameter[i-aktuellerunde]+'.jpg');
        end;
      end
else if Netzwerknachricht.messageForIndex(n).key = 'SpielerReihenfolge' then           //aktuelle Spielerreihenfolge
      begin
        ClientSocket1.Socket.SendText(KEY_STRING+SPIELER_REIHENFOLGE+'#YES#');
        for I := 0 to 3 do
        begin
          spielerreihenfolge[i]:= Netzwerknachricht.messageForIndex(n).parameter[i];
          if Spielerreihenfolge[0] = alleSpieler[i] then
          aktuelleRunde:=i;
          //showmessage(inttostr(aktuellerunde));
        end;

      end
else if Netzwerknachricht.messageForIndex(n).key = GEWINNER_STICH then               //Gewinnerstich
      begin
        ClientSocket1.Socket.SendText(KEY_STRING+GEWINNER_STICH+'#YES#');
        aktuelleRunde:=0;
        Memo1.lines.Add(Netzwerknachricht.messageForIndex(n).parameter[0]);
      end
else if Netzwerknachricht.messageForIndex(n).key = GEWINNER_SPIEL then                      //Gewinner Sieger werden genannt
      begin
        ClientSocket1.Socket.SendText(KEY_STRING+GEWINNER_SPIEL+'#YES#');
        Memo1.Lines.add('Team: ' + Netzwerknachricht.messageForIndex(n).parameter[0] + ' hat ' + Netzwerknachricht.messageForIndex(n).parameter[1] + ' Punkte.');
      end
else if Netzwerknachricht.messageForIndex(n).key = 'aktueller Punktestand' then         //aktueller Punktestand Liste mit den Punkten der vielen Spieler wird gegeben
      begin
        ClientSocket1.Socket.SendText(KEY_STRING+'Gewinner, YES');
        for I := 0 to 3 do
          Memo1.Lines.add(Netzwerknachricht.messageForIndex(n).parameter[2*i] + ' hat ' + Netzwerknachricht.messageForIndex(n).parameter[2*i+1] + ' Punkte.');
      end;
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
var
  I: Integer;
begin
  sndPlaySound(pChar('Sound.wav'),SND_ASYNC);
  for I := 1 to 10 do
  begin
    tImage(FindComponent('image'+nummer)).Height:=tImage(FindComponent('image'+nummer)).Height+2;
    tImage(FindComponent('image'+nummer)).width:=tImage(FindComponent('image'+nummer)).width+2;
    tImage(FindComponent('image'+nummer)).left:=tImage(FindComponent('image'+nummer)).left-1;
    tImage(FindComponent('image'+nummer)).top:=tImage(FindComponent('image'+nummer)).top-1;

    if (markiertekarte <> '') then
    begin
      tImage(FindComponent('image'+markiertekarte)).Height:=tImage(FindComponent('image'+markiertekarte)).Height-2;
      tImage(FindComponent('image'+markiertekarte)).width:=tImage(FindComponent('image'+markiertekarte)).width-2;
      tImage(FindComponent('image'+markiertekarte)).left:=tImage(FindComponent('image'+markiertekarte)).left+1;
      tImage(FindComponent('image'+markiertekarte)).top:=tImage(FindComponent('image'+markiertekarte)).top+1;
    end;
  sleep(10);
  application.ProcessMessages;
  end;
  markiertekarte:=nummer;
end;
end.
