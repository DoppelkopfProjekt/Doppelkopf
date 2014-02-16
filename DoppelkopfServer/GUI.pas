unit GUI;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, mTNetworkMessage, mTDoppelkopfServer, mTReceivingNetworkMessage;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    MeLog: TMemo;
    Edit2: TEdit;
    Button3: TButton;
    Label1: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
     FServer: TDoppelkopfServer;
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var msg: TReceivingNetworkMessage;
    i, k: Integer;
begin
  memo1.Clear;
  msg := TReceivingNetworkMessage.Create(edit1.text);
  for k := 0 to msg.count-1 do
  begin
    memo1.Lines.Add('Message ' + IntToStr(k));
    memo1.lines.add(msg.messageForIndex(k).key);
    //memo1.lines.add('');
    for i := 0 to msg.messageForIndex(k).parameter.count-1 do
    begin
      memo1.lines.add(msg.messageForIndex(k).parameter[i]);
    end;
  end;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Button2.Enabled := False;
  self.MeLog.Clear;
  FServer := TDoppelkopfServer.Create(StrToInt(edit2.text));
  FServer.MeLog := MeLog;
  FServer.Activate;
  self.MeLog.Lines.Add('Server ist gestartet...');
  //label1.Caption := FServer.Server.Socket.LocalAddress;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if not (FServer = nil) then
    FServer.Deactivate;
  FServer.Free;
  Button2.Enabled := true;
  self.MeLog.Lines.Add('Server ist beendet...');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  randomize;
  self.Button2Click(nil);
end;

end.
