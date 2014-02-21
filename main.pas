unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TrayIcon, Clipbrd, Buttons, Menus;

type
  TForm1 = class(TForm)
    lbl1: TLabel;
    trycn1: TTrayIcon;
    grp1: TGroupBox;
    rb_SimpleDate: TRadioButton;
    rb_Full_Time: TRadioButton;
    rb_ChinaDate: TRadioButton;
    btnOK: TBitBtn;
    lbl2: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    pm1: TPopupMenu;
    Config1: TMenuItem;
    Exit1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOKClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Config1Click(Sender: TObject);
  private
    { Private declarations }
    Hotkey_id:integer;
    procedure WMHotKey(var Msg: TWMHotKey); message WM_HOTKEY;
    function GetCurDate:string;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  lbl1.Caption := DateTimeToStr(now);
  Hotkey_id := GlobalAddAtom('DateHotKey') -$C000;

  RegisterHotKey(Handle,Hotkey_id,MOD_WIN,VK_F2);

  Hide;
end;

procedure TForm1.WMHotKey(var Msg: TWMHotKey);
begin
  if msg.HotKey=Hotkey_id then
  begin
    if not AttachThreadInput(GetCurrentThreadId, GetWindowThreadProcessId(GetForegroundWindow), true) then
      RaiseLastOSError;

    try
      Clipboard.AsText := GetCurDate;
      SendMessage(GetFocus, WM_PASTE, 0, 0);
    finally
      AttachThreadInput(GetCurrentThreadId, GetWindowThreadProcessId(GetForegroundWindow), false);
    end;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Hide;
end;

procedure TForm1.btnOKClick(Sender: TObject);
begin
  Visible := false;
end;



function TForm1.GetCurDate: string;
begin
  if rb_SimpleDate.Checked then
  begin
    Result := FormatDateTime('yyyy-mm-dd',Now);
  end;

  if rb_Full_Time.Checked then
  begin
    result := DateTimeToStr(now);
  end;

  if rb_ChinaDate.Checked then
  begin
    Result := FormatDateTime('yyyyƒÍmm‘¬dd»’',now);
  end;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  UnregisterHotKey(handle,Hotkey_id);
  Application.Terminate;
end;

procedure TForm1.Config1Click(Sender: TObject);
begin
  if Visible=False then Visible:=true;
end;

end.
