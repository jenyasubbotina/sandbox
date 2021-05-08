program pas;

uses
    GraphABC;

var
    diapazonX: array [1..6] of integer = (0, 200, 400, 600, 800, 1000);
    diapazonY: array [1..6] of integer = (0, 200, 400, 600, 800, 1000);
    zanyat: array[1..3, 1..3] of string;
    coun: integer;

procedure drawField();
var
    y1 := 0;
    x1 := 0;
begin
    for var i := 1 to 3 do
    begin
        for var j := 1 to 3 do
        begin
            Rectangle(x1, y1, x1 + 200, y1 + 200);
            x1 += 200;
        end;
        y1 += 200; 
        x1 := 0;
    end;
end;


function check() : string;
begin
    Result := 'Никто не выиграл';
    if (zanyat[1][1] = 'X') and (zanyat[2][1] = 'X') and (zanyat[3][1] = 'X') then Result := zanyat[1][1];
    if (zanyat[1][2] = 'X') and (zanyat[2][2] = 'X') and (zanyat[3][2] = 'X') then Result := zanyat[1][2];
    if (zanyat[1][3] = 'X') and (zanyat[2][3] = 'X') and (zanyat[3][3] = 'X') then Result := zanyat[1][3];
    
    if (zanyat[1][1] = 'X') and (zanyat[1][2] = 'X') and (zanyat[1][3] = 'X') then Result := zanyat[1][1];
    if (zanyat[2][1] = 'X') and (zanyat[2][2] = 'X') and (zanyat[2][3] = 'X') then Result := zanyat[2][1];
    if (zanyat[3][1] = 'X') and (zanyat[3][2] = 'X') and (zanyat[3][3] = 'X') then Result := zanyat[3][1];
    
    if (zanyat[1][1] = 'X') and (zanyat[2][2] = 'X') and (zanyat[3][3] = 'X') then Result := zanyat[1][1];
    if (zanyat[3][1] = 'X') and (zanyat[2][2] = 'X') and (zanyat[1][3] = 'X') then Result := zanyat[1][1];
    
    
    if (zanyat[1][1] = 'O') and (zanyat[2][1] = 'O') and (zanyat[3][1] = 'O') then Result := zanyat[1][1];
    if (zanyat[1][2] = 'O') and (zanyat[2][2] = 'O') and (zanyat[3][2] = 'O') then Result := zanyat[1][2];
    if (zanyat[1][3] = 'O') and (zanyat[2][3] = 'O') and (zanyat[3][3] = 'O') then Result := zanyat[1][3];
    
    if (zanyat[1][1] = 'O') and (zanyat[1][2] = 'O') and (zanyat[1][3] = 'O') then Result := zanyat[1][1];
    if (zanyat[2][1] = 'O') and (zanyat[2][2] = 'O') and (zanyat[2][3] = 'O') then Result := zanyat[2][1];
    if (zanyat[3][1] = 'O') and (zanyat[3][2] = 'O') and (zanyat[3][3] = 'O') then Result := zanyat[3][1];
    
    if (zanyat[1][1] = 'O') and (zanyat[2][2] = 'O') and (zanyat[3][3] = 'O') then Result := zanyat[1][1];
    if (zanyat[3][1] = 'O') and (zanyat[2][2] = 'O') and (zanyat[1][3] = 'O') then Result := zanyat[1][1];
end;

procedure click1(x1, y1, mb: integer);
begin
    if mb = 1 then 
    begin
        for var x := 1 to 4 do 
        begin
            for var y := 1 to 4 do
            begin
                var s1 := check();
                if (coun <= 9) and (s1 <> 'Никто не выиграл') then 
                begin
                    ClearWindow;
                    SetBrushColor(clRed);
                    Rectangle(0, 0, WindowWidth, WindowHeight);
                    TextOut(WindowWidth div 2 - 40, WindowHeight div 2, 'Выиграл ' + s1);
                    sleep(1000);
                    ClearWindow;
                    Halt(0);
                end;
                if (y1 > 600) then exit
                else if (x1 >= diapazonX[x]) and (x1 <= diapazonX[x + 1]) and (y1 >= diapazonY[y]) and (y1 <= diapazonY[y + 1]) and (zanyat[x][y] <> 'X') and (zanyat[x][y] <> 'O') then 
                begin
                    coun += 1;
                    if (coun mod 2 = 1) then 
                    begin
                        zanyat[x][y] := 'X';
                        TextOut(WindowWidth div 2 - 2 * FontSize, 650, 'Ходит Х');
                        Line(diapazonX[x], diapazonY[y], diapazonX[x + 1], diapazonY[y + 1]);
                        Line(diapazonX[x], diapazonY[y + 1], diapazonX[x + 1], diapazonY[y]);
                    end
                    else
                    begin
                        zanyat[x][y] := 'O';
                        Ellipse(diapazonX[x], diapazonY[y], diapazonX[x + 1], diapazonY[y + 1]);
                        TextOut(WindowWidth div 2 - 2 * FontSize, 650, 'Ходит O');
                    end;
                end;
            end;
        end;
    end;        
end;

begin
    SetWindowSize(600, 700);
    CenterWindow;
    SetFontSize(20);
    drawField();
    OnMouseDown := click1;
end.   