program pas;

uses
    System.Net, System.Net.Sockets, System.Threading, System.IO;

var
    clientList := new List<TcpClient>;
    startPage: string;
    outData: string;
    client : TcpClient;

procedure answerToClient();
begin
    client := clientList[clientList.Count - 1];
    clientList.RemoveAt(clientList.Count - 1);
    var stream := client.GetStream();
    var bytes := new list<byte>();
    repeat
        bytes.Add(stream.ReadByte);
    until not stream.DataAvailable;
    var byteArr := new byte[bytes.Count];
    bytes.CopyTo(0, byteArr, 0, byteArr.Length);
    var getUrlFromClient := encoding.UTF8.GetString(byteArr, 0, byteArr.Length);
    var url := getUrlFromClient.Substring(0, getUrlFromClient.IndexOf(#13#10)).Split(' ')[1];
    outData := ' ';
    if (url = '/') then
      outData += startPage;
    var outstrToBytes := Encoding.UTF8.GetBytes(outData);
    stream.Write(outstrToBytes, 0, outstrToBytes.Length);
    stream.Close;
end;

procedure startServer();
begin
    var server := new TcpListener(IPAddress.Any, 80);
    server.Start();
    while true do
    begin
        var thread1 := new thread(answerToClient);
        clientList.Add(server.AcceptTcpClient());
        thread1.Start();
    end;
end;

function readFromFile(path: string): string;
begin
    var f1: Text;
    var res: string;
    Assign(f1, path);
    Reset(f1);
    while not Eof(f1) do
    begin
        var cur: string;
        Readln(f1, cur);
        res += cur + Chr(10);
    end;
    Result := res;
end;

begin
    startPage := readFromFile('PATH_TO_YOUR_HTML_FILE');  
    startServer;
end.