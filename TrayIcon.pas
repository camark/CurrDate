{------------------------------------------------------------------------------}
{ 单元名称: TrayIcon.pas                                                       }
{                                                                              }
{ 单元作者: savetime (savetime2k@hotmail.com, http://savetime.delphibbs.com)   }
{ 创建日期: 2004-11-13 12:20:54                                                }
{                                                                              }
{ 功能介绍:                                                                    }
{   封装 Shell_NotifyIcon 的大部分功能,并增加部分常见应用                      }
{                                                                              }
{ 使用说明:                                                                    }
{   如果设置了 OnDblClick 事件,则 OnClick 的响应时间会增加 GetDoubleClickTime. }
{   否则, OnClick 将会立即执行.                                                }
{   如果没有设置 Icon, 将使用 Application 的图标.                              }
{                                                                              }
{ 更新历史:                                                                    }
{   弹出右键菜单时,点击其他位置不能关闭该菜单.解决方法:                        }
{     在弹出菜单之前加上: SetForegroundWindow(FWindow); 即可.                  }
{                                                                              }
{ 尚存问题:                                                                    }
{   暂时只支持 Win95 Shell 风格, Version 5.0 新功能以后加入                    }
{   DoubleClick 的间隔时间应可随系统设置更改而更新.                            }
{   点击 TrayIcon 时,应可设置是否将应用程序提至前台.                           }
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
  WM_CALLBACKMESSAGE = WM_USER + 100;     // 托盘图标回调消息常量

procedure TTrayIcon.CheckClickTimer(Sender: TObject);
begin
  FClickTimer.Enabled := False;
  if Assigned(FOnClick) then FOnClick(Self);
end;

constructor TTrayIcon.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FWindow := Classes.AllocateHWnd(TrayWndProc); // 处理 TrayIcon 消息的窗口

  FIcon := TIcon.Create;

  FClickTimer := TTimer.Create(Self);           // 处理单击和双击间隔时间的定时器
  FClickTimer.Enabled := False;
  FClickTimer.Interval := GetDoubleClickTime;   // 控制面板中鼠标双击间隔时间
  FClickTimer.OnTimer := CheckClickTimer;

  FIconData.cbSize := SizeOf(FIconData);        // 初始化 NotifyIconData 结构
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
    if FIcon.Handle = 0 then                      // 如果未设置图标,则使用缺省图标
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
          // 如果没设置 OnDblClick 事件,则直接调用 Onclick
          if not Assigned(FOnDblClick) then
          begin
            if Assigned(FOnClick) then FOnClick(Self);
          end
          else  // 否则使用时间判断双击时间是否到达
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
            SetForegroundWindow(FWindow); // 这句一定要加,否则弹出菜单不会自动隐藏
            GetCursorPos(PT);
            FPopupMenu.Popup(PT.X, PT.Y);
          end;
        end;
      end;
    end
    else    // 其他消息交由 Windows 处理
      Result := DefWindowProc(FWindow, Msg, WParam, LParam);
  end;
end;

end.