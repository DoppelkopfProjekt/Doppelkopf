unit UDoppelkopf;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, StdCtrls, jpeg, mtNetworkMessage, ScktComp, Stringkonstanten,
  Kartensortieren, mtSendingNetworkmessage, mtReceivingNetworkmessage, mmsystem, contnrs, math;

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
    Edit4: TEdit;
    procedure Terminalstarten1Click(Sender: TObject);
    procedure Konsoleschlieen1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Karte_auf_stapel_legenClick(Sender: TObject);
    procedure closechatClick(Sender: TObject);
    procedure openchatClick(Sender: TObject);
    procedure SelectImageClick(Sender: TObject);
    procedure Kartemarkieren(Nummer: integer);
    procedure verbinden_kleinClick(Sender: TObject);
    procedure Ansage_abgebenClick(Sender: TObject);
    procedure Name_gebenClick(Sender: TObject);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure verbindung_trennenClick(Sender: TObject);
    procedure Karten_sortierenClick(Sender: TObject);
    procedure Verbinden_grossClick(Sender: TObject);
    procedure Timerblub(sender: Tobject);
    procedure DoubleImageClick(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure Karten_erstellen(pKarte: String);

    //Images werdern erstellt

    procedure MoveImage(x: Integer; n: Integer);
    function CanMoveImage(x, n: Integer): Boolean;
    procedure OnStartDrag(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OnDrag(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure OnEndDrag(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    FImages: TObjectList;
    FNamen: TStringList;
    FIsDragging: Boolean;
    FOldPos: TPoint;
  public
  end;

var
  Form1: TForm1;   
  Chatoffen: boolean;
  markiertekarte: integer;
  karten_client: TStringList;
  verbunden: boolean;
  Vorbehalte_Art, Vorbehaltgeber: String;
  Netzwerknachricht: tReceivingNetworkmessage;
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

procedure TForm1.Karten_erstellen(pKarte: string);
begin
  if n=0 then
  begin
    self.DoubleBuffered := true;
    FNamen := TStringList.Create;
    FImages := TObjectList.Create;
    FImages.OwnsObjects := False;
    posX := 25;
    FIsDragging := False;
  end;



    FNamen.Add(pKarte);
    temp := TImage.Create(self);
   // temp.Height := round(105*1.5);
    temp.Width :=120;
    temp.Height := round(temp.Width * 105.0/73);
    temp.Picture.LoadFromFile('Karten/' + FNamen[n] + '.jpg');
    temp.Visible := true;
    temp.Parent := self;
    temp.Stretch := true;
    temp.Left := posX;
    temp.Top := 40;
    temp.OnClick := SelectImageClick;
    temp.OnDblClick := DoubleImageClick;
    posX := posX + round((1/6) * temp.Width);
    FImages.Add(temp);
    inc(n);


 if n=10 then
 begin
    // self.Width := posX + 25 + TImage(FImages[0]).width;
    //self.Height := round(TImage(FImages[0]).height+100);
    temp := TImage(self.FImages[self.FImages.Count-1]);
    temp.cursor := crHandPoint;
    temp.OnMouseDown := OnStartDrag;
    temp.OnMouseMove := OnDrag;
    temp.OnMouseUp := OnEndDrag;
 end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  I: Integer;
  pKarten: tstringlist;
begin
  verbunden:=false;
  kartensortierung:=tstringlist.create;
  markiertekarte:=-1;
  Form1.ClientHeight:=730;
  Form1.clientwidth:=960;
  alleansagenNummer:=0;
  amzug:=false;
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

  for I := 0 to 9 do
  begin
    Karten_erstellen(pkarten[n]);
  end;
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
end;

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

procedure tform1.Timerblub(sender: Tobject);
begin
  ClientSocket1.Socket.SendText(KEY_STRING+CONNECT + TZ + name +TZ);
  ftimer.enabled:=false;
end;

procedure TForm1.ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
var
i,n,z, Anzahl_keys: Integer;
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
  Terminal.lines.add('// '+Netzwerknachricht.messageForIndex(n).key+';'+para);
if Netzwerknachricht.messageForIndex(n).key = CONNECT then                             //connect Verbindnug erstellt
    begin
      if Netzwerknachricht.messageForIndex(n).parameter[0] = YES then
      begin
        verbunden:=true;
        Terminal.Lines.add('zum Server verbunden');
      end
      else if Netzwerknachricht.messageForIndex(n).parameter[0] = NO then
        Terminal.Lines.add('Server ist voll');
    end
else if Netzwerknachricht.messageForIndex(n).key = SPIELBEGINN then                          //Spielbeginn Name der Spieler werden geschickt
    begin
      ClientSocket1.Socket.SendText(KEY_STRING+SPIELBEGINN+ TZ+YES+TZ);
        for i := 0 to 3  do
        begin
          allespieler[i]:=Netzwerknachricht.messageForIndex(n).parameter[i];
          tLabel(FindComponent('Label'+inttostr(i+3))).caption:=allespieler[i];
        end;
    end
else if Netzwerknachricht.messageForIndex(n).key = KARTEN then                        //Karten Spieler bekommt die Karten geschickt
    begin
      ClientSocket1.Socket.SendText(KEY_STRING+KARTEN+TZ+YES+TZ);
      spielhatbegonnen:=true;
      Karten_client.free;
      Karten_client.create;
      Karten_client := Netzwerknachricht.messageForIndex(n).parameter;
      for i := 0 to 9 do
        timage(FImages[i]).Picture.assign(nil);
      for i := 0 to Karten_client.Count-1 do
      begin
        timage(FImages[i]).picture.loadfromfile('Karten/'+Netzwerknachricht.messageForIndex(n).parameter[i]+'.jpg');
        timage(FImages[i]).enabled:=true;
      end;
    end
else if Netzwerknachricht.messageForIndex(n).key = VORBEHALTE_ABFRAGEN then              //Vorbehaltabfrage Hat der Spieler einen Vorbahlt?
    begin
      ClientSocket1.Socket.SendText(KEY_STRING+VORBEHALTE_ABFRAGEN + TZ+YES+TZ);
      ClientSocket1.Socket.SendText(KEY_STRING+VORBEHALT_ANMELDEN+ TZ+VORBEHALT_NICHTS+TZ); // inputbox('Vorbehalte', (VORBEHALT_DAMENSOLO +', '+ VORBEHALT_BUBENSOLO +', '+ VORBEHALT_FLEISCHLOSER +', '+ VORBEHALT_HOCHZEIT +', '+ VORBEHALT_NICHTS), 'hier eingeben')+TZ);
    end
else if Netzwerknachricht.messageForIndex(n).key = VORBEHALT_ANMELDEN then
    begin
      if Netzwerknachricht.messageForIndex(n).parameter[0] = YES then
      //if Netzwerknachricht.parameter[0] = NO then
      //  ClientSocket1.Socket.SendText(VORBEHALT_ANMELDEN +TZ + inputbox('Vorbehalte', (VORBEHALT_DAMENSOLO +', '+ VORBEHALT_BUBENSOLO +', '+ VORBEHALT_FLEISCHLOSER +', '+ VORBEHALT_HOCHZEIT +', '+ VORBEHALT_NICHTS), 'hier eingeben')+TZ);
    end
else if Netzwerknachricht.messageForIndex(n).key = SOLO then                     //Vorbehalt Ein Spieler hat einen gültigen Vorbehalt gelegt
    begin
    if Netzwerknachricht.messageForIndex(n).parameter.count = 2 then
      begin
        Vorbehalte_Art := Netzwerknachricht.messageForIndex(n).parameter[1];
        Vorbehaltgeber := Netzwerknachricht.messageForIndex(n).parameter[0];
      end;
      ClientSocket1.Socket.SendText(KEY_STRING+SOLO+ TZ+YES+TZ);
    end
else if Netzwerknachricht.messageForIndex(n).key = WELCHE_KARTE then            //Welche Karte legen Spieler bekommt die Anweisung, dass er am Zug ist
    begin
      ClientSocket1.Socket.SendText(KEY_STRING+WELCHE_KARTE+ TZ+YES+TZ);                        //hier mit YES antworten
      Terminal.Lines.add('WELCHE KARTEN SOLL GESPIELT WERDEN?');
      amzug:=true;
    end
else if Netzwerknachricht.messageForIndex(n).key = ANSAGE_GEMACHT then                 //Ansageanfrage
    begin
      if Netzwerknachricht.messageForIndex(n).parameter[0] = YES then showmessage ('deine Ansage ist geglückt');
      if Netzwerknachricht.messageForIndex(n).parameter[0] = NO then showmessage ('deine Ansage ist fehlgeschlagen')
      else
      begin
        alleansagenNummer:=alleansagenNummer+1;
        alleansagenAnsage[alleansagenNummer] := Netzwerknachricht.messageForIndex(n).parameter[1];
        alleansagenSpieler[alleansagenNummer] := Netzwerknachricht.messageForIndex(n).parameter[0];
        Terminal.lines.add('Spieler '+ alleansagenSpieler[alleansagenNummer] + ' hat folgende Ansage gemacht: ' + alleansagenAnsage[alleansagenNummer]);
        ClientSocket1.Socket.SendText(KEY_STRING+ANSAGE_GEMACHT + TZ+YES+TZ)
      end;
    end
else if Netzwerknachricht.messageForIndex(n).key = KARTE_LEGEN then           //welche Karten testen gelegte Karte wird getestet
      begin
        if Netzwerknachricht.messageForIndex(n).parameter[0] = YES then
        begin
          Terminal.Lines.add ('Karte erfolgreich gelegt');
          timage(FImages[markiertekarte]).Picture.loadfromfile('Karten/Back.jpg');
          timage(FImages[markiertekarte]).enabled:=false;
          amzug:=false;
          Kartemarkieren(-1);
        end;
        if Netzwerknachricht.messageForIndex(n).parameter[0] = NO then
          showmessage('neue Karte legen');
      end
else if Netzwerknachricht.messageForIndex(n).key = AKTUELLER_STICH then               //aktueller Stich gibt den kompletten momentanen Stich
      begin
        ClientSocket1.Socket.SendText(KEY_STRING+AKTUELLER_STICH+TZ+YES+TZ);
        for I := aktuellerunde to Netzwerknachricht.messageForIndex(n).parameter.count-1+aktuellerunde do
        begin
          if i-aktuellerunde=0 then
          for z := 21 to 24 do
          begin
            timage(FImages[i]).picture.loadfromfile('Karten/Back.jpg');
          end;
          if i>3 then
          timage(FImages[i-4]).Picture.loadfromfile('Karten/'+Netzwerknachricht.messageForIndex(n).parameter[i-aktuellerunde]+'.jpg')
          else
          timage(FImages[i]).Picture.loadfromfile('Karten/'+Netzwerknachricht.messageForIndex(n).parameter[i-aktuellerunde]+'.jpg');
        end;
      end
else if Netzwerknachricht.messageForIndex(n).key = 'SpielerReihenfolge' then           //aktuelle Spielerreihenfolge
      begin
        ClientSocket1.Socket.SendText(KEY_STRING+SPIELER_REIHENFOLGE+TZ+YES+TZ);
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
        ClientSocket1.Socket.SendText(KEY_STRING+GEWINNER_STICH+TZ+YES+TZ);
        aktuelleRunde:=0;
        Terminal.lines.Add(Netzwerknachricht.messageForIndex(n).parameter[0]);
      end
else if Netzwerknachricht.messageForIndex(n).key = GEWINNER_SPIEL then                      //Gewinner Sieger werden genannt
      begin
        ClientSocket1.Socket.SendText(KEY_STRING+GEWINNER_SPIEL+TZ+YES+TZ);
        Terminal.Lines.add('Team: ' + Netzwerknachricht.messageForIndex(n).parameter[0] + ' hat ' + Netzwerknachricht.messageForIndex(n).parameter[1] + ' Punkte.');
      end
else if Netzwerknachricht.messageForIndex(n).key = 'aktueller Punktestand' then         //aktueller Punktestand Liste mit den Punkten der vielen Spieler wird gegeben
      begin
        ClientSocket1.Socket.SendText(KEY_STRING+'Gewinner, YES');
        for I := 0 to 3 do
          Terminal.Lines.add(Netzwerknachricht.messageForIndex(n).parameter[2*i] + ' hat ' + Netzwerknachricht.messageForIndex(n).parameter[2*i+1] + ' Punkte.');
      end
else if Netzwerknachricht.messageForIndex(n).key = CHAT_EMPFANGEN then
      begin
        Chat.Lines.add(Netzwerknachricht.messageForIndex(n).parameter[0]+': '+Netzwerknachricht.messageForIndex(n).parameter[1]);
      end;
     
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

procedure TForm1.SelectImageClick(Sender: TObject);
begin
Kartemarkieren(self.FImages.indexof(sender));
sleep(20);
end;

procedure TForm1.DoubleImageClick(Sender: TObject);
var
  y1,y2,y3,x1,x2,x3:double;
  a,b,c:double;
  z1,z2:double;
  I: Integer;
  entfernenBildFertig:boolean;
  k, kmax: integer;
  verschiebenbilderfertig:boolean;
begin
    x1 := timage(FImages[markiertekarte]).left;
    x2 := image21.Left;
    x3 := abs(x3-x1) / 2;
    y1 := timage(FImages[markiertekarte]).top;
    y2 := image21.Top;
    y3 := 200;

    entfernenbildfertig:=false;
    k:=0;

    a := y1;
    b := (y2-y1)/(x2-x1);
    c := ((y3-y2)/(x3-x2)- (y2-y1)/(x2-x1))/(x3-x1);

    kmax:=image21.Left-timage(FImages[markiertekarte]).left;

    while not entfernenBildFertig  do
    begin
      timage(FImages[markiertekarte]).top := round(a + b*(timage(FImages[markiertekarte]).left-x1) + c*(timage(FImages[markiertekarte]).left-x1)*(timage(FImages[markiertekarte]).left-x2));
      timage(FImages[markiertekarte]).left := timage(FImages[markiertekarte]).left + 1;
      inc(k, 1);
      if k > kMax then
      begin
        entfernenBildFertig := true;
      end;
      application.ProcessMessages;
      sleep(12);
      inc(i);
    end;

 (* x1:=timage(FImages[markiertekarte]).left;
  y1:=timage(FImages[markiertekarte]).top;
  x3:=Image21.left;
  y3:=Image21.top;
  x2:=((x3-x1)) / 2 + x1;
  y2:=y1-20;


                                   //
  a:= ((y3-y1)-((y2-y1)*(x3-x1)/(x2-x1)))/((sqr(x3)-sqr(x1))-((sqr(x2)-sqr(x1))*(x3-x1)/(x2-x1)));
  b:= ((y2-y1)-((sqr(x2)-sqr(x1))*a))/(x2-x1);
  c:= y1-(sqr(x1)*a)-(x1-b);

  edit4.text:=FloatToStrF(a, ffFixed, 8, 2)+' '+ FloatToStrF(b, ffFixed, 8, 2) +' '+ FloatToStrF(c, ffFixed, 8, 2);

  for I := 1 to 50 do
  begin
    timage(FImages[markiertekarte]).left:= round(((x3-x1)/50*i)+x1);
    timage(FImages[markiertekarte]).top := round((a*sqr((x3-x1)/50*i) + b*(x3-x1)/50*i + c/50*i));
    sleep(10);
    application.ProcessMessages;
  end;                          *)

//  Kartemarkieren(self.FImages.indexof(sender));
  self.Karte_auf_stapel_legen.Click;
end;

procedure TForm1.Kartemarkieren(Nummer:integer);
var
  I,s,p: Integer;
begin
  if bewegung =false then
  begin
    sndPlaySound(pChar('Sound.wav'),SND_ASYNC);
    for I := 0 to 30 do
    begin
      bewegung:=true;
      s:=timage(FImages[nummer]).top;
      if markiertekarte <> -1 then
      p:=timage(fimages[markiertekarte]).top;
      if nummer <> -1 then
      begin
        timage(FImages[nummer]).top:=s-round((power (power(30, (1/30)), 30-i))/7);
      end;
      if (markiertekarte <> -1) then
      begin
        timage(FImages[markiertekarte]).top:=p+round((power (power(30, (1/30)), 30-i))/7);
      end;
    sleep(5);
    application.ProcessMessages;
    end;
  if markiertekarte <> nummer then
  markiertekarte:=nummer
  else markiertekarte := -1;
  end;
  bewegung:=false;
end;




//Images werden erstellt




procedure TForm1.OnStartDrag(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  self.FIsDragging := True;
  getCursorPos(FOldPos);
  OutputdebugString('Start drag');
end;

procedure TForm1.OnDrag(Sender: TObject; Shift: TShiftState; X,Y: Integer);
var
    NewPos: TPoint;
begin
  if bewegung=false then
  if self.FIsDragging then
  begin
    getCursorPos(newPos);
    if abs(NewPos.X - FOldPos.X) >= 2 then
    begin
      OutputdebugString('Moving');
      self.MoveImage(NewPos.X - FOldPos.X, self.FImages.Count-1);
      FOldPos := NewPos;
    end;
  end;

end;

procedure TForm1.OnEndDrag(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  self.FIsDragging := False;
  OutputdebugString('Stop Drag');

end;

function TForm1.CanMoveImage(x, n: Integer): Boolean;
var actualImage, previousImage: TImage;
    place: Integer;
begin
  if x = 0 then result := false
  else
  begin
    if (n >= 1) then
    begin
      actualImage := TImage(self.FImages[n]);
      previousImage := TImage(self.FImages[n-1]);
        if n = 0 then
        begin
          result := false;
        end else
        begin
          if x <= 0 then
          begin
           place := 20;
          end;
          if x > 0  then
          begin
            place := 65;
          end;
          result := ((abs(actualImage.Left - previousImage.Left) < place) and (x > 0)) or
             ((abs(actualImage.Left - previousImage.Left) > place) and (x < 0)) or
             self.CanMoveImage(x, n-1);
        end;
    end else
    begin
      result := false;
    end;
  end;
end;

procedure TForm1.MoveImage(x: Integer; n: Integer);
var actualImage, previousImage: TImage;
    factor: double;
    place: Integer;
begin
  x := round(x * 1);
  if (n >= 1) then
  begin
    actualImage := TImage(self.FImages[n]);
    previousImage := TImage(self.FImages[n-1]);
    if x <= 0 then
    begin
      factor := 0.25;
      place := 20;
    end;
    if x > 0  then
    begin
      factor := 0.25;
      place := 65;
    end;
    if ((abs(actualImage.Left - previousImage.Left) < place) and (x > 0)) or
      ((abs(actualImage.Left - previousImage.Left) > place) and (x < 0)) then
    begin
      if ((actualImage.Left + x - previousImage.Left) > place) and (x > 0) then
      begin
        x := 65 - actualImage.Left + previousImage.Left;
      end;
      if ((actualImage.Left + x - previousImage.Left) < place) and (x < 0) then
      begin
        x := 20 - actualImage.Left + previousImage.Left;
      end;
      TImage(self.FImages[n]).Left := TImage(self.FImages[n]).Left + x;
      self.MoveImage(round(factor*x), n-1);
    end else
    begin
      if self.CanMoveImage(x, n-1) then
      begin
        self.MoveImage(x, n-1);
        if ((actualImage.Left + x - previousImage.Left) > place) and (x > 0) then
        begin
          x := 65 - actualImage.Left + previousImage.Left;
        end;
        if ((actualImage.Left + x - previousImage.Left) < place) and (x < 0) then
        begin
          x := 20 - actualImage.Left + previousImage.Left;
        end;
        TImage(self.FImages[n]).Left := TImage(self.FImages[n]).Left + x;
      end;
    end;
  end;
end;






end.
