(*
  THIS IS YOUR LIFE
  & IT'S ENDING ONE MINUTE AT A TIME
  (c) Fight Club / Tyler Durden

  ClockWork v1.4 (c) 2001 D.J. NiKe

  Send comments & suggestions 2:
    djnike@omen.ru
    2:5045/66.45@FIDOnet
*)

unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ShellApi;

{
    mTimer: TTimer;
    sTimer: TTimer;
    pTimer: TTimer;
    ForceTimer: TTimer;
}
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mTimerTimer(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure sTimerTimer(Sender: TObject);
    procedure pTimerTimer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ForceTimerTimer(Sender: TObject);
  private
    { Private declarations }
    procedure WMEraseBkgnd(var m: TWMEraseBkgnd); message WM_ERASEBKGND;
    function  InitSkin : boolean;
    procedure PaintSkin;
    procedure PutNum(x,y : integer; Num : byte);
    procedure PutTime;
{    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;{}
    procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
    procedure DoAction;
    function  nHitBtn(hx,hy : integer) : byte;
    procedure InvTimer;
    procedure PushBtn(bt : byte);

  public
    { Public declarations }
  end;

  TControlStyle = set of (csAcceptsControls, csCaptureMouse,
    csDesignInteractive, csClickEvents, csFramed, csSetCaption, csOpaque,
    csDoubleClicks, csFixedWidth, csFixedHeight, csNoDesignVisible,
    csReplicatable, csNoStdEvents, csDisplayDragImage, csReflector,
    csActionClient, csMenuEvents);

type tBtn = record
        x,y : integer;
        w,h : integer;
        sX1,sY1 : integer;
        sX2,sY2 : integer;
        s       : byte;
        t       : byte;
     end;

const ScrollText = 'THIS IS YOUR LIFE & IT''S ENDING ONE MINUTE AT A TIME (c) Fight Club / Tyler Durden : ';
const nBtns = 8;
      aBtns : array [1..nBtns] of tBtn =
      ((x:030;y:100;w:023;h:024;sX1:000;sY1:000;sX2:000;sY2:025;s:0;t:0),
       (x:072;y:100;w:023;h:024;sX1:000;sY1:000;sX2:000;sY2:025;s:0;t:0),
       (x:115;y:100;w:023;h:024;sX1:000;sY1:000;sX2:000;sY2:025;s:0;t:0),
       (x:030;y:153;w:023;h:024;sX1:024;sY1:000;sX2:024;sY2:025;s:0;t:0),
       (x:072;y:153;w:023;h:024;sX1:024;sY1:000;sX2:024;sY2:025;s:0;t:0),
       (x:115;y:153;w:023;h:024;sX1:024;sY1:000;sX2:024;sY2:025;s:0;t:0),
       (x:070;y:184;w:028;h:024;sX1:048;sY1:000;sX2:048;sY2:025;s:0;t:0),
       (x:149;y:187;w:015;h:016;sX1:077;sY1:000;sX2:077;sY2:017;s:0;t:1)
      );
const SkinDir = 'BaseSkin\';
const Wait2Force = 5; {seconds 2 wait until FORCED action is called}


var
  mForm: TmForm;
  bg,
  Clock,
  Ticks,
  Time,
  BigNum,
  Btns,
  Buf : tBitmap;

  mX,mY   : integer;
  Dragged : boolean;

  sct : integer;
  ForceTime,dnBt,thr,tmn,tse,sTT,TimeTicks : integer;

implementation

{$R *.DFM}

procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
var ShiftState: TShiftState;
begin
(*
  with Message do
  begin
    ShiftState := KeyDataToShiftState(KeyData);
    if not (csNoStdEvents in ControlStyle) then
    begin
      KeyDown(CharCode, ShiftState);
      if CharCode = 0 then Exit;
    end;
  end;
  Result := False;
end;

 *)
end;

procedure TmForm.WMEraseBkgnd(var m : TWMEraseBkgnd);
begin
  m.Result := LRESULT(False);
end;

procedure TmForm.PushBtn;
var pb,hr,mn,se,t : integer;
begin
  case Bt of
  1..6: if not mTimer.Enabled then
        begin
          t  := timeticks;
          hr := t div (60*60);
          t  := t mod (60*60);
          se := t mod 60;
          mn := t div 60;
          if hr>99 then hr:=99;
          pb:=0;
          case Bt of
          1: if hr>=99 then hr:=00 else inc(hr);
          2: if mn>=59 then begin mn:=00; pb:=1; end else inc(mn);
          3: if se>=59 then begin se:=00; pb:=2; end else inc(se);
          4: if hr<=00 then hr:=99 else dec(hr);
          5: if mn<=00 then begin mn:=59; pb:=4; end else dec(mn);
          6: if se<=00 then begin se:=59; pb:=5; end else dec(se);
          end;
          if pb>0 then
          begin
            TimeTicks:=hr*(60*60)+mn*(60)+se;
            PushBtn(pb);
          end else TimeTicks:=hr*(60*60)+mn*(60)+se;
        end;
  7: InvTimer;
  8: Application.Terminate;
  end;
end;

procedure TmForm.InvTimer;
begin
  mTimer.Enabled:=not mTimer.Enabled;
  if mTimer.Enabled then
  begin
    sTT:=TimeTicks;
    aBtns[7].s:=1;
  end else
  begin
    aBtns[7].s:=0;
  end;
end;

function TmForm.nHitBtn(hX,hY : integer) : byte;
var i  : integer;
    f  : boolean;
begin
  f:=false;
  for i:=1 to nBtns do with aBtns[i] do
  begin
    if (hX>=x)and(hX<=x+w)and
       (hY>=Y)and(hY<=Y+h) then
       begin
         f:=true;
         break;
       end;
  end;
  if f then Result:=i else Result:=0;
end;

function ExecuteFile(const FileName, Params, DefaultDir: string;
  ShowCmd: Integer): THandle;
var
  zFileName, zParams, zDir: array[0..79] of Char;
begin
  Result := ShellExecute(Application.MainForm.Handle, nil,
    StrPCopy(zFileName, FileName), StrPCopy(zParams, Params),
    StrPCopy(zDir, DefaultDir), ShowCmd);
end;

procedure Normal_PowerOff;
var pcb : pchar;
    s   : string;
begin
  GetMem(pcb,128);
  GetWindowsDirectory(pcb,128);
  s:=string(pcb);
  if length(s)>0 then
  begin
    if s[length(s)]<>'\' then s:=s+'\';
    ExecuteFile(s+'rundll.exe','user.dll,ExitWindows','',sw_hide);
  end;
end;

procedure Force_PowerOff;
begin
  ExitWindowsEx(EWX_FORCE, 0);
  ExitWindowsEx(EWX_SHUTDOWN, 0);
(*
ExitWindowsEx(EWX_LOGOFF, 0);
ExitWindowsEx(EWX_REBOOT, 0);
ExitWindowsEx(EWX_SHUTDOWN, 0);
ExitWindowsEx(EWX_POWEROFF, 0);
ExitWindowsEx(EWX_FORCE, 0);
*)
end;

procedure TmForm.DoAction;
begin
  ForceTime:=Wait2Force;
  ForceTimer.Enabled:=true;
  Normal_PowerOff;
  MessageDlg('Your Time IS OVER!',mtWarning,[mbOK],0);
end;

procedure TmForm.PutNum(x,y : integer; Num : byte);
begin
  if (Num>9) then Num:=0;
  bitblt(Buf.Canvas.Handle,x,y,14,23,
         BigNum.Canvas.Handle,num*14,000,SRCCOPY);
end;

procedure TmForm.PutTime;
var hr,mn,se : byte;
    xx,yy,t : integer;
begin
  t:=timeticks;
  hr:=t div (60*60);
  t:=t mod (60*60);
  se:=t mod 60;
  mn:=t div 60;
  if hr>99 then hr:=99;
  xx:=22+3; yy:=125+2;
  PutNum(xx,yy,hr div 10);
  inc(xx,14);
  PutNum(xx,yy,hr mod 10);
  inc(xx,14);
  inc(xx,14);
  PutNum(xx,yy,mn div 10);
  inc(xx,14);
  PutNum(xx,yy,mn mod 10);
  inc(xx,14);
  inc(xx,14);
  PutNum(xx,yy,se div 10);
  inc(xx,14);
  PutNum(xx,yy,se mod 10);
end;

(* v1.01
procedure TmForm.WMNCHitTest(var Message: TWMNCHitTest);
var pt : tPoint;
begin
  inherited;
  with Message do
  begin
    pt.x:=xpos; pt.y:=ypos;
    pt:=ScreenToClient(pt);
    if sqrt(sqr(154-pt.x)+sqr(10-pt.y))<=5 then
    Result:=htClient else
    begin
      if nHitBtn(pt.x,pt.y)>0 then Result:=htClient else
      begin
        Result:=htCaption;
      end;
    end;
  end;
end;
*)

procedure FileError(filename : string);
begin
  MessageDlg('I/O Error on file "'+filename+'"',mtError,[mbOK],0);
  Application.Terminate;
end;

function TmForm.InitSkin;
var filename : string;
begin
  Result:=false;
  bg:=TBitmap.Create;
  filename:=SkinDir+'opbase.bmp';
  try
    bg.LoadFromFile(filename);
    Clock:=TBitmap.Create;
    filename:=SkinDir+'clock.bmp';
    try
      Clock.LoadFromFile(filename);
      Ticks:=TBitmap.Create;
      filename:=SkinDir+'clocks.bmp';
      try
        Ticks.LoadFromFile(filename);
        Time:=TBitmap.Create;
        filename:=SkinDir+'clocks.bmp';
        try
          Time.LoadFromFile(SkinDir+'Time.bmp');
          BigNum:=TBitmap.Create;
          filename:=SkinDir+'bignum.bmp';
          try
            BigNum.LoadFromFile(filename);
            Btns:=TBitmap.Create;
            filename:=SkinDir+'btns.bmp';
            try
              Btns.LoadFromFile(filename);
              Result:=true;
            except
              FileError(FileName);
            end;
          except
            FileError(FileName);
          end;
        except
          FileError(FileName);
        end;
      except
        FileError(FileName);
      end;
    except
      FileError(FileName);
    end;
  except
    FileError(FileName);
  end;
end;

procedure TmForm.PaintSkin;
var i : integer;
begin
  bitblt(buf.Canvas.Handle,000,000,mForm.ClientWidth,mForm.ClientHeight,
         bg.Canvas.Handle,000,000,SRCCOPY);
  bitblt(buf.Canvas.Handle,032,022,Clock.Width,Clock.Height,
         Clock.Canvas.Handle,000,000,SRCCOPY);
  bitblt(buf.Canvas.Handle,022,125,Time.Width,Time.Height,
         Time.Canvas.Handle,000,000,SRCCOPY);
  if mTimer.Enabled then
  begin
    if stt=0 then i:=0 else i:=round((sTT-TimeTicks)/(sTT/13));
    dec(i);
    if i<0 then i:=0 else if i>12 then i:=12;
    bitblt(buf.Canvas.Handle,037,026,92,55,
           Ticks.Canvas.Handle,000,55*i,SRCCOPY);
  end;
  PutTime;
  for i:=1 to nBtns do
  begin
{    if i in [1..6] then if mTimer.Enabled then continue;{}
    if aBtns[i].s<>0 then
      bitblt(buf.Canvas.Handle,abtns[i].x,abtns[i].y,abtns[i].w,abtns[i].h,
             btns.Canvas.Handle,abtns[i].sx2,abtns[i].sy2,SRCCOPY)
    else
      bitblt(Buf.Canvas.Handle,abtns[i].x,abtns[i].y,abtns[i].w,abtns[i].h,
             btns.Canvas.Handle,abtns[i].sx1,abtns[i].sy1,SRCCOPY);
  end;

  bitblt(mForm.Canvas.Handle,000,000,mForm.ClientWidth,mForm.ClientHeight,
         Buf.Canvas.Handle,000,000,SRCCOPY);
end;

procedure TmForm.FormCreate(Sender: TObject);
begin
  sct:=0;
  dnBt:=0;
  Dragged:=false;
  if not InitSkin then
  begin
    Application.Terminate;
  end else
  begin
    TimeTicks:=60*2;
    buf:=TBitmap.Create;
    buf.Width:=mForm.ClientWidth;
    buf.Height:=mForm.ClientHeight;
  end;
end;

procedure TmForm.FormPaint(Sender: TObject);
begin
  PaintSkin;
end;

procedure TmForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i : integer;
begin
  Dragged:=false;
  if button = mbLeft then
  begin
    for i:=1 to nBtns do aBtns[i].s:=0;
    aBtns[7].s:=byte(mTimer.Enabled);
    if dnBt>0 then
    begin
      i:=nHitBtn(x,y);
      if (i=dnBt) then
      begin
        PushBtn(dnBt);
      end;
    end;
  end;
  dnBt:=0;
  PaintSkin;
end;

procedure TmForm.mTimerTimer(Sender: TObject);
begin
  if mTimer.Enabled then
  begin
    if TimeTicks<=0 then
    begin
      mTimer.Enabled:=false;
      TimeTicks:=0; stt:=0;
      aBtns[7].s:=0;
      PaintSkin;
      DoAction;
    end else dec(TimeTicks);
  end;
  PaintSkin;
end;

procedure TmForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    dnBt:=nHitBtn(x,y);
    if dnBt>0 then
    begin
      if dnBt=7 then
      begin
        aBtns[dnBt].s:=1-byte(mTimer.Enabled);
      end else
      begin
        aBtns[dnBt].s:=1;
        pTimer.Enabled:=true;
        pTimer.Interval:=pTimer.Tag;
      end;
      PaintSkin;
    end else
    begin
      Dragged:=true;
      mX:=X;
      mY:=Y;
    end;
  end;
end;

procedure TmForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var hb : integer;
begin
  if Dragged then
  begin
    Left := Left + X - mX;
    Top  := Top  + Y - mY;
  end;
  hb:=nHitBtn(x,y);
  if dnBt <> 7 then
  begin
    if hb = dnBt then
    begin
      if aBtns[dnBt].s = 0 then
      begin
        aBtns[dnBt].s:=1;
        pTimer.Enabled:=true;
        pTimer.Interval:=pTimer.Tag;
      end;
    end else
    begin
      pTimer.Enabled:=false;
      aBtns[dnBt].s:=0;
    end;
  end else
  begin
    pTimer.Enabled:=false;
    if dnBt=7 then
    begin
      if hb=dnBt then
      begin
        aBtns[7].s:=1-byte(mTimer.Enabled)
      end else aBtns[7].s:=byte(mTimer.Enabled);
    end;
  end;
  PaintSkin;
end;

procedure TmForm.sTimerTimer(Sender: TObject);
begin
  if sct>=length(ScrollText) then sct:=1 else inc(sct);
  Application.Title:=copy(ScrollText,sct,255)+
  copy(ScrollText,1,sct-1);
end;

procedure TmForm.pTimerTimer(Sender: TObject);
begin
  if dnBt in [1..6] then PushBtn(dnBt);
  if pTimer.Interval>50 then pTimer.Interval:=pTimer.Interval-50
   else pTimer.Interval:=50;
  PaintSkin;
end;

procedure TmForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_SPACE) then PushBtn(7) else
  if (key = VK_NUMPAD9)or(key=ord('9'))or(key=33) then PushBtn(3) else
  if (key = VK_NUMPAD8)or(key=ord('8'))or(key=38) then PushBtn(2) else
  if (key = VK_NUMPAD7)or(key=ord('7'))or(key=36) then PushBtn(1) else
  if (key = VK_NUMPAD6)or(key=ord('6'))or(key=39) then PushBtn(6) else
  if (key = VK_NUMPAD5)or(key=ord('5'))or(key=12) then PushBtn(5) else
  if (key = VK_NUMPAD4)or(key=ord('4'))or(key=37) then PushBtn(4) else
  if (key = VK_NUMPAD0)or(key=ord('0'))or(key=45) then if not mTimer.Enabled then TimeTicks:=0;
  PaintSkin;
end;

procedure TmForm.ForceTimerTimer(Sender: TObject);
begin
  if ForceTime<=0 then Force_PowerOff else dec(ForceTime);
end;

end.
