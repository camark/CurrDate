{------------------------------------------------------------------------------}
{ ��Ԫ����: TrayIcon.pas                                                       }
{                                                                              }
{ ��Ԫ����: savetime (savetime2k@hotmail.com, http://savetime.delphibbs.com)   }
{ ��������: 2004-11-13 12:20:54                                                }
{                                                                              }
{ ���ܽ���:                                                                    }
{   ��װ Shell_NotifyIcon �Ĵ󲿷ֹ���,�����Ӳ��ֳ���Ӧ��                      }
{                                                                              }
{ ʹ��˵��:                                                                    }
{   ��������� OnDblClick �¼�,�� OnClick ����Ӧʱ������� GetDoubleClickTime. }
{   ����, OnClick ��������ִ��.                                                }
{   ���û������ Icon, ��ʹ�� Application ��ͼ��.                              }
{                                                                              }
{ ������ʷ:                                                                    }
{   �����Ҽ��˵�ʱ,�������λ�ò��ܹرոò˵�.�������:                        }
{     �ڵ����˵�֮ǰ����: SetForegroundWindow(FWindow); ����.                  }
{                                                                              }
{ �д�����:                                                                    }
{   ��ʱֻ֧�� Win95 Shell ���, Version 5.0 �¹����Ժ����                    }
{   DoubleClick �ļ��ʱ��Ӧ����ϵͳ���ø��Ķ�����.                            }
{   ��� TrayIcon ʱ,Ӧ�������Ƿ�Ӧ�ó�������ǰ̨.                           }
{                                                                              }
{------------------------------------------------------------------------------}
unit TrayIcon;

interface

uses SysUtils, Classes, Graphics, Controls, Windows, Messages, Forms, Menus,
  ExtCtrls, ShellAPI;

type

//==============================================================================
// TTrayIcon class
//==============================================================================

  TTrayIcon = class(TComponent)
  private
    FWindow: HWND;
    FHint: string;
    FIcon: TIcon;
    FActive: Boolean;
    FOnClick: TNotifyEvent;
    FOnDblClick: TNotifyEvent;
    FPopupMenu: TPopupMenu;
    FClickTimer: TTimer;
    FIconData: TNotifyIconData;
    procedure CheckClickTimer(Sender: TObject);
    procedure SendTrayMessage(MsgID: DWORD; Flags: UINT);
    procedure TrayWndProc(var Message: TMessage);
    procedure SetActive(const Value: Boolean);
    procedure SetIcon(const Value: TIcon);
    procedure SetHint(const Value: string);
    procedure SetPopupMenu(const Value: TPopupMenu);
  protected
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Active: Boolean read FActive write SetActive default False;
    property Hint: string read FHint write SetHint;
    property Icon: TIcon read FIcon write SetIcon;
    property PopupMenu: TPopupMenu read FPopupMenu write SetPopupMenu;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
  end;

  procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('System', [TTrayIcon]);
end;

{ TTrayIcon }

const
  WM_CALLBACKMESSAGE = WM_USER + 100;     // ����ͼ��ص���Ϣ����

procedure TTrayIcon.CheckClickTimer(Sender: TObject);
begin
  FClickTimer.Enabled := False;
  if Assigned(FOnClick) then FOnClick(Self);
end;

constructor TTrayIcon.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FWindow := Classes.AllocateHWnd(TrayWndProc); // ���� TrayIcon ��Ϣ�Ĵ���

  FIcon := TIcon.Create;

  FClickTimer := TTimer.Create(Self);           // ��������˫�����ʱ��Ķ�ʱ��
  FClickTimer.Enabled := False;
  FClickTimer.Interval := GetDoubleClickTime;   // ������������˫�����ʱ��
  FClickTimer.OnTimer := CheckClickTimer;

  FIconData.cbSize := SizeOf(FIconData);        // ��ʼ�� NotifyIconData �ṹ
  FIconData.Wnd := FWindow;
  FIconData.uID := UINT(Self);
  FIconData.uCallbackMessage := WM_CALLBACKMESSAGE;
end;

destructor TTrayIcon.Destroy;
begin
  Active := False;

  FClickTimer.Free;
  FIcon.Free;
  Classes.DeallocateHWnd(FWindow);

  inherited;
end;

procedure TTrayIcon.Loaded;
begin
  inherited;
  if FActive then
    SendTrayMessage(NIM_ADD, NIF_MESSAGE or NIF_ICON or NIF_TIP);
end;

procedure TTrayIcon.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = PopupMenu) then
    PopupMenu := nil;
end;

procedure TTrayIcon.SendTrayMessage(MsgID: DWORD; Flags: UINT);
begin
  if (Flags and NIF_ICON) <> 0 then
  begin
    if FIcon.Handle = 0 then                      // ���δ����ͼ��,��ʹ��ȱʡͼ��
      FIconData.hIcon := Application.Icon.Handle
    else
      FIconData.hIcon := FIcon.Handle;
  end;

  FIconData.uFlags := Flags;
  Shell_NotifyIcon(MsgID, @FIconData);
end;

procedure TTrayIcon.SetActive(const Value: Boolean);
begin
  FActive := Value;

  if (not (csDesigning in ComponentState)) and
     (not (csLoading in ComponentState))  then
  begin
    if Value then
      SendTrayMessage(NIM_ADD, NIF_MESSAGE or NIF_ICON or NIF_TIP)
    else
      SendTrayMessage(NIM_DELETE, 0)
  end;
end;

procedure TTrayIcon.SetHint(const Value: string);
begin
  FHint := Value;
  StrPLCopy(FIconData.szTip, PChar(FHint), SizeOf(FIconData.szTip));

  if (not (csDesigning in ComponentState)) and
     (not (csLoading in ComponentState)) and
     FActive then
  begin
    SendTrayMessage(NIM_MODIFY, NIF_TIP);
  end;
end;

procedure TTrayIcon.SetIcon(const Value: TIcon);
begin
  FIcon.Assign(Value);

  if (FActive and not (csDesigning in ComponentState)) then
    SendTrayMessage(NIM_MODIFY, NIF_ICON);
end;

procedure TTrayIcon.SetPopupMenu(const Value: TPopupMenu);
begin
  FPopupMenu := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

procedure TTrayIcon.TrayWndProc(var Message: TMessage);
var
  PT: TPoint;
begin
  with Message do
  begin
    if Msg = WM_CALLBACKMESSAGE then
    begin
      case LParam of

        WM_LBUTTONDOWN:
        begin
          // ���û���� OnDblClick �¼�,��ֱ�ӵ��� Onclick
          if not Assigned(FOnDblClick) then
          begin
            if Assigned(FOnClick) then FOnClick(Self);
          end
          else  // ����ʹ��ʱ���ж�˫��ʱ���Ƿ񵽴�
            FClickTimer.Enabled := True;
        end;

        WM_LBUTTONDBLCLK:
        begin
          FClickTimer.Enabled := False;
          if Assigned(FOnDblClick) then FOnDblClick(Self);
        end;

        WM_RBUTTONDOWN:
        begin
          if Assigned(FPopupMenu) then
          begin
            SetForegroundWindow(FWindow); // ���һ��Ҫ��,���򵯳��˵������Զ�����
            GetCursorPos(PT);
            FPopupMenu.Popup(PT.X, PT.Y);
          end;
        end;
      end;
    end
    else    // ������Ϣ���� Windows ����
      Result := DefWindowProc(FWindow, Msg, WParam, LParam);
  end;
end;

end.