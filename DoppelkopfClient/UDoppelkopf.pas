unit UDoppelkopf;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, StdCtrls, jpeg, ScktComp, Stringkonstanten,
  Kartensortieren, mtSendingNetworkmessage, mmsystem, mtNetworkMessage,
  contnrs, math, mtKartenstapel, strUtils;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Spiel1: TMenuItem;
    NeuesSpiel1: TMenuItem;
    Label1: TLabel;
    Label2: TLabel;
    Karte_auf_stapel_legen: TButton;
    Chat1: TMenuItem;
    openchat: TMenuItem;
    closechat: TMenuItem;
    Terminal1: TMenuItem;
    Terminalstarten1: TMenuItem;
    Konsoleschlieen1: TMenuItem;
    Terminal: TMemo;
    Chat: TMemo;
    Image23: TImage;
    Image22: TImage;
    Image21: TImage;
    Image24: TImage;
    Verbinden1: TMenuItem;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Edit2: TEdit;
    Label7: TLabel;
    verbinden_klein: TButton;
    Ansage_abgeben: TButton;
    Name_geben: TButton;
    verbindung_trennen: TButton;
    Clientsocket1 : tClientsocket;
    Edit3: TEdit;
    Karten_sortieren: TButton;
    ComboBox1: TComboBox;
    Verbinden_gross: TButton;
    Timer1: TTimer;
    Button8: TButton;
    Edit1: TEdit;
    procedure Terminalstarten1Click(Sender: TObject);
    procedure Konsoleschlieen1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Karte_auf_stapel_legenClick(Sender: TObject);
    procedure closechatClick(Sender: TObject);
    procedure openchatClick(Sender: TObject);
    procedure verbinden_kleinClick(Sender: TObject);
    procedure Ansage_abgebenClick(Sender: TObject);
    procedure Name_gebenClick(Sender: TObject);
    procedure verbindung_trennenClick(Sender: TObject);
    procedure Verbinden_grossClick(Sender: TObject);
    procedure Timerblub(sender: Tobject);
    procedure Button8Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure processmessage(pmsg:tnetworkmessage);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);

  private
    FBuffer: string;
    FImages: TObjectList;
    FNamen: TStringList;
    FIsDragging: Boolean;
    FOldPos: TPoint;

    FKartenstapel: TKartenstapel;
    function shouldDeletePicture(var destImage: TImage): Boolean;
  public
  end;

var
  Form1: TForm1;   
  Chatoffen: boolean;
  markiertekarte: integer;
  karten_client: TStringList;
  verbunden: boolean;
  Vorbehalte_Art, Vorbehaltgeber: String;
  //Netzwerknachricht: tReceivingNetworkmessage;
  allespieler: Array  [0..3] of String;
  alleansagenAnsage: Array of String [10];
  alleansagenSpieler: Array of String [10];
  alleansagenNummer: Integer;
  kartensortierung: tStringList;
  fTimer:Ttimer;
  spielerreihenfolge: Array [0..3] of String;
  aktuellerunde: Integer;
  spielhatbegonnen, amzug, bewegung:boolean;
  Name:String;
  n: integer;
  temp: TImage;
  posX: Integer;
  karte_erfolgreiche_gelegt: boolean;
implementation

uses Verbinden;

{$R *.DFM}

procedure TForm1.Terminalstarten1Click(Sender: TObject);
begin
  Terminal.Visible:=true;
  if chatoffen=true then
  begin
    Terminal.height:=225;
    Terminal.Top:=472;
    Terminal.Width:=460;
  end;
  if chatoffen=false then
  begin
    Terminal.height:=117;
    Terminal.Top:=520;
    Terminal.Width:=873;
  end;
end;

procedure TForm1.Konsoleschlieen1Click(Sender: TObject);
begin
  Terminal.Visible:=false;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  I: Integer;
  pKarten: tstringlist;
  width: integer;
begin
  karte_erfolgreiche_gelegt:=false;
  width:=100;
  verbunden:=false;
  kartensortierung:=tstringlist.create;
  markiertekarte:=-1;
  Form1.ClientHeight:=730;
  Form1.clientwidth:=960;
  alleansagenNummer:=0;
  amzug:=false;

  self.FKartenStapel := TKartenstapel.Create(self, shouldDeletePicture, 25, 40, width, round(width * (105.0/73)));

  pkarten:=tstringlist.Create;
  pkarten.add('HE10');
  pkarten.add('KR10');
  pkarten.add('KA10');
  pkarten.add('PI10');
  pkarten.add('KRD');
  pkarten.add('HED');
  pkarten.add('KAB');
  pkarten.add('KRB');
  pkarten.add('PIB');
  pkarten.add('HEB');

  fKartenstapel.setKarten(pkarten, false);

  aktuelleRunde:=0;
  image21.Picture.LoadFromFile('Karten/Back.jpg');
  image22.Picture.loadfromfile('Karten/Back.jpg');
  image23.Picture.loadfromfile('Karten/Back.jpg');
  image24.Picture.loadfromfile('Karten/Back.jpg');

end;

procedure TForm1.Karte_auf_stapel_legenclick(Sender: TObject);
var
sendung: String;
begin
 // sendung := Karten_client[markiertekarte];
 // ClientSocket1.Socket.SendText(KEY_STRING+KARTE_LEGEN+TZ+sendung+TZ);
end;

procedure TForm1.verbinden_kleinClick(Sender: TObject);
begin
  ClientSocket1.Host:=Combobox1.text; //Die IP oder der Hostname wird festgelegt
  ClientSocket1.Port:=StrToInt(Edit2.Text); //Der Port wird festgelegt
  ClientSocket1.Open; //Verbindung zum Server wird hergestellt
  Name_geben.Enabled:=true;
end;

procedure TForm1.Ansage_abgebenClick(Sender: TObject);
begin
  ClientSocket1.Socket.SendText(KEY_STRING+ANSAGE + TZ+inputbox('neue Ansage', ANSAGE_RE + ', ' + ANSAGE_KONTRA + ', ' + ANSAGE_KEINENEUN  + ', ' +  ANSAGE_KEINESECHS  + ', ' +  ANSAGE_KEINEDREI  + ', ' + ANSAGE_SCHWARZ,'')+ TZ);
end;

procedure TForm1.Name_gebenClick(Sender: TObject);
begin
  name:=edit3.Text;
  ClientSocket1.Socket.SendText(KEY_STRING+CONNECT + TZ + name +TZ);
end;

procedure TForm1.verbindung_trennenClick(Sender: TObject);
var
  i: Integer;
begin
  clientsocket1.Close;
  for i := 0 to 9 do
  begin
    timage(FImages[i]).Picture.loadfromfile('Karten/Back.jpg');
    Terminal.Lines.Clear;
  end;
  aktuelleRunde:=0;
  verbunden:=false;
  Chat.Lines.Clear;
end;

(*
procedure TForm1.Karten_sortierenClick(Sender: TObject);
var
  Bild: tImage;
  i: Integer;
begin
  Kartemarkieren(-1);
  for i := 0 to 9 do
  begin
    kartensortierung.Add(inttostr(i));
    kartensortierung.Add(inttostr(timage(FImages[i]).top));
    kartensortierung.Add(inttostr(timage(FImages[i]).left));
    kartensortierung.add(karten_client[i]);
  end;
  Form2.meinekarten := kartensortierung;
  Form2.Kartenlegen;
  Form2.ShowModal;
  for I := 0 to 9 do
  begin
    //timage(FImages[Form2.meinekarten[4*i+0]]).top:=(form2.meinekarten[4*i+1]);
  //  timage(FImages[Form2.meinekarten[4*i+0]]).top:=StrToInt(form2.meinekarten[4*i+1]);
 //   timage(FImages[Form2.meinekarten[4*i+0]]).picture.loadfromfile('Karten/'+form2.meinekarten[4*i+3]+'.jpg');
  end;
end;                    *)

procedure TForm1.Verbinden_grossClick(Sender: TObject);
begin
  Form3.ShowModal;
  ClientSocket1.Host:=Form3.nachricht[0]; //Die IP oder der Hostname wird festgelegt
  ClientSocket1.Port:=StrToInt(Form3.nachricht[1]); //Der Port wird festgelegt
  ClientSocket1.Open; //Verbindung zum Server wird hergestellt
  ftimer:=ttimer.create(nil);
  ftimer.interval:=600;
  ftimer.enabled:=true;
  ftimer.ontimer := TimerBlub;
  name:=Form3.Nachricht[2];
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  ClientSocket1.Socket.SendText(KEY_STRING+CHAT_SENDEN+TZ+name+TZ+Edit3.Text+TZ);
end;

procedure TForm1.ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
var expectedLength, tempEnd, tempBegin, realLength, lengthBegin, lengthEnd: Integer;
    shouldStop: Boolean;
    networkMessage: TNetworkMessage;
    IP: string;
    buffer: string;
begin
  IP := socket.RemoteAddress;
  self.Fbuffer := self.fbuffer + string(socket.ReceiveText);
  buffer := self.FBuffer;
  shouldStop := False;
  lengthBegin := length(LENGTH_BEGIN);
  lengthEnd := length(LENGTH_END);
  while not shouldStop do
  begin
    tempEnd := posEx(LENGTH_END, buffer, lengthBegin);
    if tempEnd <> 0 then
    begin
      expectedLength := StrToInt(copy(buffer, lengthBegin+1, tempEnd-lengthBegin-1));
      tempBegin := posEx(LENGTH_BEGIN, buffer, tempEnd);
      if tempBegin <> 0 then
      begin
        realLength := tempBegin - lengthBegin - lengthEnd - length(copy(buffer, lengthBegin+1, tempEnd-lengthBegin-1))-1;
      end else
      begin
        realLength := length(buffer) - lengthBegin - lengthEnd - length(copy(buffer, lengthBegin+1, tempEnd-lengthBegin-1));
      end;
      if realLength = expectedLength then
      begin
        delete(buffer, 1, tempEnd+lengthEnd-1);
        //self.ProcessMessage(copy(buffer, 1, realLength), socket.RemoteAddress);
        networkMessage := TnetworkMessage.Create(copy(buffer, 1, realLength));
        self.processmessage(networkMessage);
        //ShowMessage(copy(buffer, 1, realLength));
        delete(buffer, 1, realLength);
      end else
      begin
        shouldStop := True;
      end;
    end else
    begin
      shouldStop := True;
    end;
  end;
  self.FBuffer := buffer;
end;

procedure tform1.Timerblub(sender: Tobject);
begin
  ClientSocket1.Socket.SendText(KEY_STRING+CONNECT + TZ + name +TZ);
  ftimer.enabled:=false;
end;

procedure TForm1.processmessage(pmsg:tnetworkmessage);
var
i,n,z, Anzahl_keys: Integer;
para:String;
pkarten:tstringlist;
msg:tsendingnetworkmessage;
begin
  for i := 0 to pmsg.parameter.count - 1 do
  begin
    para:=para+', '+pmsg.parameter[i];
  end;
  Terminal.lines.add('// '+pmsg.key+';'+para);
if pmsg.key = CONNECT then                             //connect Verbindnug erstellt
    begin
      if pmsg.parameter[0] = YES then
      begin
        verbunden:=true;
        Terminal.Lines.add('zum Server verbunden');
      end
      else if pmsg.parameter[0] = NO then
        Terminal.Lines.add('Server ist voll');
    end
else if pmsg.key = SPIELBEGINN then                          //Spielbeginn Name der Spieler werden geschickt
    begin
      msg:=tsendingnetworkmessage.create(SPIELBEGINN);
      msg.addParameter(YES);                                  ///HIER ETWAS �BERALL �NDERN
      ClientSocket1.Socket.SendText(msg.resultingMessage);
        for i := 0 to 3  do
        begin
          allespieler[i]:=pmsg.parameter[i];
          tLabel(FindComponent('Label'+inttostr(i+3))).caption:=allespieler[i];
        end;
    end
else if pmsg.key = KARTEN then                        //Karten Spieler bekommt die Karten geschickt
    begin
      ClientSocket1.Socket.SendText(KEY_STRING+KARTEN+TZ+YES+TZ);
      spielhatbegonnen:=true;
      Karten_client.free;
      Karten_client.create;
      Karten_client := pmsg.parameter;
      for i := 0 to 9 do
        timage(FImages[i]).Picture.assign(nil);
      for i := 0 to Karten_client.Count-1 do
      begin
          pkarten.free;
          pkarten:=tstringlist.Create;
          pkarten.add(pmsg.parameter[i]);
      end;
    fKartenstapel.setKarten(pkarten, false);
    end
else if pmsg.key = VORBEHALTE_ABFRAGEN then              //Vorbehaltabfrage Hat der Spieler einen Vorbahlt?
    begin
      ClientSocket1.Socket.SendText(KEY_STRING+VORBEHALTE_ABFRAGEN + TZ+YES+TZ);
      ClientSocket1.Socket.SendText(KEY_STRING+VORBEHALT_ANMELDEN+ TZ+VORBEHALT_NICHTS+TZ); // inputbox('Vorbehalte', (VORBEHALT_DAMENSOLO +', '+ VORBEHALT_BUBENSOLO +', '+ VORBEHALT_FLEISCHLOSER +', '+ VORBEHALT_HOCHZEIT +', '+ VORBEHALT_NICHTS), 'hier eingeben')+TZ);
    end
else if pmsg.key = VORBEHALT_ANMELDEN then
    begin
      if pmsg.parameter[0] = YES then
      //if Netzwerknachricht.parameter[0] = NO then
      //  ClientSocket1.Socket.SendText(VORBEHALT_ANMELDEN +TZ + inputbox('Vorbehalte', (VORBEHALT_DAMENSOLO +', '+ VORBEHALT_BUBENSOLO +', '+ VORBEHALT_FLEISCHLOSER +', '+ VORBEHALT_HOCHZEIT +', '+ VORBEHALT_NICHTS), 'hier eingeben')+TZ);
    end
else if pmsg.key = SOLO then                     //Vorbehalt Ein Spieler hat einen g�ltigen Vorbehalt gelegt
    begin
    if pmsg.parameter.count = 2 then
      begin
        Vorbehalte_Art := pmsg.parameter[1];
        Vorbehaltgeber := pmsg.parameter[0];
      end;
      ClientSocket1.Socket.SendText(KEY_STRING+SOLO+ TZ+YES+TZ);
    end
else if pmsg.key = WELCHE_KARTE then            //Welche Karte legen Spieler bekommt die Anweisung, dass er am Zug ist
    begin
      ClientSocket1.Socket.SendText(KEY_STRING+WELCHE_KARTE+ TZ+YES+TZ);                        //hier mit YES antworten
      Terminal.Lines.add('WELCHE KARTEN SOLL GESPIELT WERDEN?');
      amzug:=true;
    end
else if pmsg.key = ANSAGE_GEMACHT then                 //Ansageanfrage
    begin
      if pmsg.parameter[0] = YES then showmessage ('deine Ansage ist gegl�ckt');
      if pmsg.parameter[0] = NO then showmessage ('deine Ansage ist fehlgeschlagen')
      else
      begin
        alleansagenNummer:=alleansagenNummer+1;
        alleansagenAnsage[alleansagenNummer] := pmsg.parameter[1];
        alleansagenSpieler[alleansagenNummer] := pmsg.parameter[0];
        Terminal.lines.add('Spieler '+ alleansagenSpieler[alleansagenNummer] + ' hat folgende Ansage gemacht: ' + alleansagenAnsage[alleansagenNummer]);
        ClientSocket1.Socket.SendText(KEY_STRING+ANSAGE_GEMACHT + TZ+YES+TZ)
      end;
    end
else if pmsg.key = KARTE_LEGEN then           //welche Karten testen gelegte Karte wird getestet
      begin
        if pmsg.parameter[0] = YES then
        begin
          Terminal.Lines.add ('Karte erfolgreich gelegt');
          karte_erfolgreiche_gelegt:=true;
          amzug:=false;
        end;
        if pmsg.parameter[0] = NO then
          showmessage('neue Karte legen');
      end
else if pmsg.key = AKTUELLER_STICH then               //aktueller Stich gibt den kompletten momentanen Stich
      begin
        ClientSocket1.Socket.SendText(KEY_STRING+AKTUELLER_STICH+TZ+YES+TZ);
        for I := aktuellerunde to pmsg.parameter.count-1+aktuellerunde do
        begin
          if i-aktuellerunde=0 then
          for z := 21 to 24 do
          begin
            timage(FImages[i]).picture.loadfromfile('Karten/Back.jpg');
          end;
          if i>3 then
          timage(FImages[i-4]).Picture.loadfromfile('Karten/'+pmsg.parameter[i-aktuellerunde]+'.jpg')
          else
          timage(FImages[i]).Picture.loadfromfile('Karten/'+pmsg.parameter[i-aktuellerunde]+'.jpg');
        end;
      end
else if pmsg.key = 'SpielerReihenfolge' then           //aktuelle Spielerreihenfolge
      begin
        ClientSocket1.Socket.SendText(KEY_STRING+SPIELER_REIHENFOLGE+TZ+YES+TZ);
        for I := 0 to 3 do
        begin
          spielerreihenfolge[i]:= pmsg.parameter[i];
          if Spielerreihenfolge[0] = alleSpieler[i] then
          aktuelleRunde:=i;
          //showmessage(inttostr(aktuellerunde));
        end;

      end
else if pmsg.key = GEWINNER_STICH then               //Gewinnerstich
      begin
        ClientSocket1.Socket.SendText(KEY_STRING+GEWINNER_STICH+TZ+YES+TZ);
        aktuelleRunde:=0;
        Terminal.lines.Add(pmsg.parameter[0]);
      end
else if pmsg.key = GEWINNER_SPIEL then                      //Gewinner Sieger werden genannt
      begin
        ClientSocket1.Socket.SendText(KEY_STRING+GEWINNER_SPIEL+TZ+YES+TZ);
        Terminal.Lines.add('Team: ' + pmsg.parameter[0] + ' hat ' + pmsg.parameter[1] + ' Punkte.');
      end
else if pmsg.key = 'aktueller Punktestand' then         //aktueller Punktestand Liste mit den Punkten der vielen Spieler wird gegeben
      begin
        ClientSocket1.Socket.SendText(KEY_STRING+'Gewinner, YES');
        for I := 0 to 3 do
          Terminal.Lines.add(pmsg.parameter[2*i] + ' hat ' + pmsg.parameter[2*i+1] + ' Punkte.');
      end
else if pmsg.key = CHAT_EMPFANGEN then
      begin
        Chat.Lines.add(pmsg.parameter[0]+': '+pmsg.parameter[1]);
      end;
     
end;

procedure TForm1.closechatClick(Sender: TObject);
begin
  if chatoffen=true then
    Form1.Width:=960;
  chatoffen:=false
end;

procedure TForm1.Edit1Click(Sender: TObject);
begin
  edit1.text:='';
end;

procedure TForm1.openchatClick(Sender: TObject);
begin
  if chatoffen=false then
    Form1.Width:=1335;
  chatoffen:=true;
end;

function TForm1.shouldDeletePicture(var destImage: TImage): Boolean;
var startzeit : integer;
begin
  destImage := image21; //hier muss das Bild variabel sein, NOCH MACHEN
  startzeit:=gettickcount;
  while (gettickcount-startzeit < DELAY) and not karte_erfolgreiche_gelegt do
  begin
    application.ProcessMessages;
  end;
   result := karte_erfolgreiche_gelegt;
   result := true;
   karte_erfolgreiche_gelegt:=false;
end;

end.
