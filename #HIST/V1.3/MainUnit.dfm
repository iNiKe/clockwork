object mForm: TmForm
  Left = 228
  Top = 176
  BorderIcons = [biSystemMenu]
  BorderStyle = bsNone
  Caption = 'ClockWork'
  ClientHeight = 267
  ClientWidth = 295
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
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
  PixelsPerInch = 120
  TextHeight = 16
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
