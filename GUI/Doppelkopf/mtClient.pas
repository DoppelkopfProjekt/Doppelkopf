unit mtClient;

interface
uses
  mConnection;
type
TClient = class(tconnection)

public
constructor create (Ipadresse:string; Port:Integer);
function empfangeNachricht(): String;

end;
implementation
Constructor TClient.create (Ipadresse:string; Port:Integer);
begin
   inherited create(ipadresse, port);
end;

function tclient.empfangeNachricht: String;
begin

end;
end.
