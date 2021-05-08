program pas;

uses
    GraphABC;

const
    Rows = 7;
    Columns = 7;
    W = 720;
    H = 720;
    radius = 40;

type
    cell = class
        x: integer;
        y: integer;
        choosed: boolean;
        color1: integer;
        open1: boolean;
        constructor Create(x1, y1: integer; ch1: boolean; cl1: integer);
        begin
            x := x1;
            y := y1;
            choosed := ch1;
            color1 := cl1;
        end;
    end;
    

var
    map: array [0..Rows, 0..Columns] of integer;
    coords: array [0..Rows, 0..Columns] of cell;
    offset := W div 8;
    whichChoosed: KeyValuePair<integer, integer>;
    whichChoosedColor: integer;
    whichDelete: KeyValuePair<integer, integer>;
    whichDeleteColor: integer;
    firstPlayer := true;
    canMove := true;
    delete1 := false;
    count := 0;

procedure fillMap();
begin
    for var i := 0 to Rows div 2 - 1 do
    begin
        for var j := 0 to Columns do
        begin
            if (i mod 2 = 0) and (j mod 2 = 1) or (i mod 2 = 1) and (j mod 2 = 0) then map[i][j] := 2;
        end;
    end;
    for var i := Rows downto Rows div 2 + 2 do
    begin
        for var j := 0 to Columns do
        begin
            if (i mod 2 = 1) and (j mod 2 = 0) or (i mod 2 = 0) and (j mod 2 = 1) then map[i][j] := 1;
        end;
    end;
end;

procedure fillNull();
begin
    var x := 0;
    var y := 0;
    for var i := 0 to Rows do
    begin
        for var j := 0 to Columns do
        begin
            var cur := new cell(x, y, false, map[i][j]);
            coords[i][j] := cur;
            x += offset;
        end;
        y += offset;
        x := 0;
    end;
end;

procedure fillCoords();
begin
    var x := 0;
    var y := 0;
    for var i := 0 to Rows do
    begin
        for var j := 0 to Columns do
        begin
            var cur := new cell(x, y, coords[i][j].choosed, map[i][j]);
            coords[i][j] := cur;
            x += offset;
        end;
        y += offset;
        x := 0;
    end;
end;

procedure drawField();
begin
    var x := 0;
    var y := 0;
    for var i := 0 to Rows do
    begin
        for var j := 0 to Columns do
        begin
            if (i mod 2 = 0) and (j mod 2 = 1) or (i mod 2 = 1) and (j mod 2 = 0) then 
            begin
                SetPenColor(clBrown);
                coords[i][j].open1 := true;
            end;
            if (i mod 2 = 0) and (j mod 2 = 0) or (i mod 2 = 1) and (j mod 2 = 1) then 
            begin
                SetPenColor(clBurlyWood);
                coords[i][j].open1 := false;
            end;
            if (coords[i][j].choosed) and (whichChoosed.Key = i) and (whichChoosed.Value = j) then
            begin
                SetPenColor(clGreen);
            end;
            SetBrushColor(PenColor);
            Rectangle(x, y, x + offset, y + offset);
            if coords[i][j].color1 = 1 then SetBrushColor(clWhite)
            else if coords[i][j].color1 = 2 then SetBrushColor(clBlack)
            else if coords[i][j].color1 = 0 then SetBrushColor(PenColor);
            Circle(coords[i][j].x + offset div 2, coords[i][j].y + offset div 2, radius);
            x += offset;
        end;
        y += offset;
        x := 0;
    end;
end;

procedure writeMap();
begin
    for var i := 0 to Rows do
    begin
        for var j := 0 to Columns do
        begin
            Write(map[i][j], ' ');
        end;
        Writeln;
    end;
end;

procedure deleteChecker(x1, y1 : integer);
begin
    map[x1][y1] := 0;
end;

function canMove1(y1, x1, colorOfChecker, y2, x2: integer): boolean;
begin
    Result := false;
    delete1 := false;
    if colorOfChecker = 1 then
    begin
        if (y1 - y2 = 1) and ((x2 - x1 = 1) or (x1 - x2 = 1)) then 
            Result := true;
        if (x1 - x2 = -2) then
        begin
            writeMap;
            Writeln(x1, ' ', y1, ' ', map[x1 + 1][y1 - 1]);
            if (map[x1][y1] = 2) then
            begin
                whichDelete := new KeyValuePair<integer,integer>(x2, y2);
                whichDeleteColor := 2;
                delete1 := true;
                Result := true;
            end;
        end;
    end;
    if colorOfChecker = 2 then
    begin
        if (y2 - y1 = 1) and ((x2 - x1 = 1) or (x1 - x2 = 1)) then 
            Result := true
    end;
end;

procedure mousedown1(x1, y1, mb: integer);
begin
    if mb = 2 then
    begin
        whichChoosed := new KeyValuePair<integer,integer>(-1, -1);
        for var i := 0 to Rows do
        begin
            for var j := 0 to Columns do
            begin
                if (x1 >= coords[i][j].x) and (x1 <= coords[i][j].x + offset) and (y1 >= coords[i][j].y) and (y1 <= coords[i][j].y + offset) then
                begin
                    if (count mod 2 = 1) and (coords[i][j].color1 = 2) or (count mod 2 = 0) and (coords[i][j].color1 = 1) then
                    begin
                        whichChoosed := new KeyValuePair<integer, integer>(i, j);
                        Writeln(whichChoosed);
                        whichChoosedColor := map[i][j];
                        coords[whichChoosed.Key][whichChoosed.Value].choosed := false;
                        coords[i][j].choosed := true;
                        map[whichChoosed.Key][whichChoosed.Value] := 0;
                        canMove := true;
                        //Writeln(whichChoosed);
                    end;
                end;
            end;
        end;
    end;
    if mb = 1 then
    begin
        for var i := 0 to Rows do
        begin
            for var j := 0 to Columns do
            begin
                if (coords[i][j].color1 = 0) and (x1 >= coords[i][j].x) and (x1 <= coords[i][j].x + offset) and (y1 >= coords[i][j].y) and (y1 <= coords[i][j].y + offset) 
                and canMove1(whichChoosed.Key, whichChoosed.Value, whichChoosedColor, i, j) and (coords[i][j].open1) and (canMove) then
                begin
                    coords[whichChoosed.Key][whichChoosed.Value].choosed := false;
                    map[whichChoosed.Key][whichChoosed.Value] := 0;
                    Writeln(whichChoosed);
                    map[i][j] := whichChoosedColor;
                    if delete1 then
                    begin
                        if (whichDelete.Key <> -1) and (whichDelete.Value <> -1) then map[whichDelete.Key][whichDelete.Value] := 0;
                        whichDelete := new KeyValuePair<integer,integer>(-1, -1);
                    end;
                    fillCoords;
                    canMove := false;
                    firstPlayer := not firstPlayer;
                    count += 1;
                end;
            end;
        end;
    end;
end;

begin
    SetConsoleIO;
    fillMap;
    fillNull;
    OnMouseDown := mousedown1;
    SetWindowSize(W, H);
    CenterWindow;
    SetWindowCaption('Шашки');
    LockDrawing;
    while true do
    begin
        drawField;
        Redraw;
        Sleep(900);
    end;
end.