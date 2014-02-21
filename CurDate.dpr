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
    MessageBox(Application.Handle,'ϵͳ�Ѿ����У�����Win+F2�ڵ�ǰλ����������','��ʾ',MB_OK or MB_ICONWARNING);
    Application.Terminate;
  end;

  ReleaseMutex(Mutex);
end.
