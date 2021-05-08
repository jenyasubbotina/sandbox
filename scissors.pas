{$apptype windows}
{$reference 'System.Windows.Forms.dll'}
{$reference 'System.Drawing.dll'}

uses
  System, System.Drawing, System.Windows.Forms;

const
  opacity = 0.1;
  WM_NCLBUTTONDOWN = 161;
  HTCAPTION = 2;

var
  f: Form;

function SendMessage(hWnd: IntPtr; Msg: integer; wParam: integer; lParam: integer): integer;
external 'user32.dll' name 'SendMessage';
  

function ReleaseCapture(): boolean;
external 'user32.dll' name 'ReleaseCapture';

procedure WndProc(msg: Message);
begin
  WndProc(msg);
end;

procedure panelDrag_MouseDown(sender: object; e: MouseEventArgs);
begin
  if (e.Button = MouseButtons.Left) then
  begin
    ReleaseCapture();
    SendMessage(F.Handle, WM_NCLBUTTONDOWN, HTCAPTION, 0);
  end;
end;

procedure save(x, y, w, h: integer; s: Size);
begin
  var rect := new Rectangle(x, y, w, h);
  var bmp := new Bitmap(rect.Width, rect.Height, System.Drawing.Imaging.PixelFormat.Format32bppArgb);
  var g := Graphics.FromImage(bmp);
  g.CopyFromScreen(rect.Left, rect.Top, 0, 0, s, CopyPixelOperation.SourceCopy);
  bmp.Save('C:\screen.jpeg', System.Drawing.Imaging.ImageFormat.Jpeg);
end;

procedure catchScreen(sender: Object; e: EventArgs);
begin
  f.Hide();
  save(f.Location.X, f.Location.Y, f.Width, f.Height, f.Size);
end;

begin
  f := new Form();
  f.StartPosition := FormStartPosition.CenterScreen;
  var catch := new Button();
  catch.Text := 'Catch screen';
  catch.AutoSize := true;
  catch.Location := new System.Drawing.Point(f.Width div 2 - catch.Width div 2,
    f.Height div 2 - catch.Height);
  f.Controls.Add(catch);
  f.AutoSize := true;
  f.Cursor := System.Windows.Forms.Cursors.SizeAll;
  f.Opacity := opacity;
  catch.Click += catchScreen;
  Application.Run(f);
end.
