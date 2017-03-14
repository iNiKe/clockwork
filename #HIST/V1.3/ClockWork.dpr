(*
  THIS IS YOUR LIFE
  & IT'S ENDING ONE MINUTE AT A TIME
  (c) Fight Club / Tyler Durden

  ClockWork v1.3 (c) D.J. NiKe
  djnike@omen.ru
  2:5045/66.45
*)
program ClockWork;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {mForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'THIS IS YOUR LIFE & IT''S ENDING ONE MINUTE AT A TIME (c) Fight Club / Tyler Durden';
  Application.CreateForm(TmForm, mForm);
  Application.Run;
end.
