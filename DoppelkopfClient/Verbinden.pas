unit Verbinden;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm3 = class(TForm)
    Edit2: TEdit;
    Button2: TButton;
    Edit3: TEdit;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Button1: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    private ubergabenachricht: tStringList;
  public
    property Nachricht: tSTringlist read ubergabenachricht write ubergabenachricht;
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
begin
  form3.Close;
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  ubergabenachricht:=tstringlist.create();
  ubergabenachricht.add(Combobox1.Text);
  ubergabenachricht.add(Edit2.Text);
  ubergabenachricht.add(Edit3.Text);
  form3.Close;
end;

end.
