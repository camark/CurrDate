program CurDate;

uses
  Forms,
  Windows,
  main in 'main.pas' {Form1};

{$R *.res}

var
  Mutex:THandle;
begin

  Mutex := CreateMutex(nil,False,'CurrDate');

  if GetLastError<>ERROR_ALREADY_EXISTS then
  begin
      Application.Initialize;
      Application.CreateForm(TForm1, Form1);
      //Application.ShowMainForm := false;
      Application.Run;
  end
  else
  begin
    MessageBox(Application.Handle,'系统已经运行，按下Win+F2在当前位置输入日期','提示',MB_OK or MB_ICONWARNING);
    Application.Terminate;
  end;

  ReleaseMutex(Mutex);
end.
