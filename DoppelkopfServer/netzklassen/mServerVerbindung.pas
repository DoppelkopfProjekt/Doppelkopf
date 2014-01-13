(*
 * Materialien zu den zentralen Abiturpruefungen
 * im Fach Informatik ab 2012 in Nordrhein-Westfalen.
 *
 * Klasse Serverbindung
 *
 * NW-Arbeitsgruppe:
 * Materialentwicklung zum Zentralabitur im Fach Informatik
 *
 * Version 2011-01-17
 *)
unit mServerVerbindung;

interface

uses
  scktcomp, Winsock;

  type
  ServerVerbindung=class(TServerClientWinsocket)
                      zInhalt:TObject;
                      constructor create(Socket: TSocket; ServerWinSocket: TServerWinSocket);
                      procedure setzeInhalt(pInhalt:TObject);
                      function Inhalt:TObject;
                      function hatInhalt:boolean;
                      destructor destroy;override;
                    end;
implementation

  constructor ServerVerbindung.create(Socket: TSocket; ServerWinSocket: TServerWinSocket);
  begin
    zInhalt:=nil;
    inherited create(Socket,ServerWinSocket);
  end;

  procedure Serververbindung.setzeInhalt(pInhalt:TObject);
  begin
    zInhalt:=pInhalt;
  end;

  function Serververbindung.Inhalt:TObject;
  begin
    result:=zInhalt;
  end;

  function Serververbindung.hatInhalt:boolean;
  begin
    result:=zInhalt<>nil;
  end;

  destructor ServerVerbindung.destroy;
  begin
    if zInhalt<>nil then
      zInhalt.destroy;
    inherited destroy;
  end;

end.
