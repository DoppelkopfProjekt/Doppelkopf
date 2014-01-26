unit GUI;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, mTNetworkMessage;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var msg: TNetworkMessage;
    i: Integer;
begin
  msg := TNetworkMessage.Create(edit1.text);

  memo1.lines.add(msg.key);
  memo1.lines.add('');
  for i := 0 to msg.parameter.count-1 do
  begin
    memo1.lines.add(msg.parameter[i]);
  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  randomize;
end;

end.
