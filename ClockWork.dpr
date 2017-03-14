(*
  THIS IS YOUR LIFE
  & IT'S ENDING ONE MINUTE AT A TIME
  (c) Fight Club / Tyler Durden

  ClockWork v1.4 (c) D.J. NiKe
  djnike@omen.ru
  2:5045/66.45
*)
program ClockWork;

uses Windows, Messages;

{$R *.RES}

const fc_st_life = 'THIS IS YOUR LIFE & IT''S ENDING ONE MINUTE AT A TIME (c) Fight Club / Tyler Durden';

var WinClass: TWndClassA;
    Inst, Handle, Button1, Label1, Edit1: Integer;
    Msg: TMsg;
    hFont: Integer;

function WindowProc(hWnd, uMsg, wParam, lParam: Integer): Integer; stdcall;
begin
  Result := DefWindowProc(hWnd, uMsg, wParam, lParam);
  { Checks for messages }
  if (lParam = Button1) and (uMsg = WM_COMMAND) then
//    CheckPassword;
  if uMsg = WM_DESTROY then
    Halt;
end;

procedure CreateMainWindow;
begin
  Inst := hInstance;
  with WinClass do
  begin
    style              := CS_CLASSDC or CS_PARENTDC;
    lpfnWndProc        := @WindowProc;
    hInstance          := Inst;
    hbrBackground      := color_btnface + 1;
    lpszClassname      := 'CLOCKWORK_MWND';
    hCursor            := LoadCursor(0, IDC_ARROW);
  end; { with }
  RegisterClass(WinClass);

  { ** Create Main Window ** }
  Handle := CreateWindowEx(WS_EX_WINDOWEDGE, 'AG_TESTWINDOW', 'ClockWork',
                           WS_VISIBLE or WS_SIZEBOX or WS_CAPTION or WS_SYSMENU,
                           363, 278, 305, 65, 0, 0, Inst, nil);
end;

procedure Run;
begin
  while (GetMessage(Msg, Handle, 0, 0)) do
  begin
    TranslateMessage(msg);
    DispatchMessage(msg);
  end; { with }
end;

begin

  CreateMainWindow;
  Run;
end.
