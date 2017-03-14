object mForm: TmForm
  Left = 453
  Top = 176
  BorderIcons = [biSystemMenu]
  BorderStyle = bsNone
  Caption = 'ClockWork'
  ClientHeight = 217
  ClientWidth = 240
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object mTimer: TTimer
    Enabled = False
    OnTimer = mTimerTimer
  end
  object sTimer: TTimer
    Interval = 250
    OnTimer = sTimerTimer
    Left = 32
  end
  object pTimer: TTimer
    Tag = 300
    Enabled = False
    Interval = 300
    OnTimer = pTimerTimer
    Left = 64
  end
  object ForceTimer: TTimer
    Enabled = False
    OnTimer = ForceTimerTimer
    Left = 96
  end
end
