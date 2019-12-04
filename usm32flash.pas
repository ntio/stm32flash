unit usm32flash;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, process, FileUtil, UTF8Process, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, AsyncProcess;

type

  { TSTM32FLASH_2 }

  TSTM32FLASH_2 = class(TForm)
    btdispositivo: TButton;
    btCargar: TButton;
    btgrabar: TButton;
    btborrar: TButton;
    btleer: TButton;
    edpuerto: TEdit;
    edarchivohex: TEdit;
    Image1: TImage;
    Label1: TLabel;
    mmlog: TMemo;
    opabrir: TOpenDialog;
    procedure btborrarClick(Sender: TObject);
    procedure btCargarClick(Sender: TObject);
    procedure btdispositivoClick(Sender: TObject);
    procedure btgrabarClick(Sender: TObject);
    procedure btleerClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  STM32FLASH_2: TSTM32FLASH_2;
  puerto: String;
  codehex: String;

implementation

{$R *.frm}

{ TSTM32FLASH_2 }

procedure TSTM32FLASH_2.btdispositivoClick(Sender: TObject);
var
AStringList,S: TStringList;
//s:AnsiString;
Proceso:TProcess;

begin
      ShowMessage('Debe colocar BOOT0 en 1 y pulsar RST');
      puerto :=edpuerto.Text;
      Proceso:=TProcess.Create(Nil);
      AStringList := TStringList.Create;
      S:= TStringList.Create;
       Proceso.Options:= Proceso.Options + [poWaitOnExit,poUsePipes];
      Proceso.Executable := 'stm32flash';
      Proceso.Parameters.Add(puerto);
      Proceso.Execute;

      AStringList.LoadFromStream(Proceso.Output);
      S.LoadFromStream(Proceso.Stderr);
      // Save the output to a file and clean up the TStringList.
      AStringList.AddStrings(S,False);
      AStringList.SaveToFile('output.txt');
      AStringList.Free;
      S.Free;
       mmlog.Lines.LoadFromFile('output.txt');





end;

procedure TSTM32FLASH_2.btgrabarClick(Sender: TObject);
var
AStringList,S: TStringList;
Proceso:TProcess;
begin
        ShowMessage('Debe colocar BOOT0 en 1 y pulsar RST');
       puerto :=edpuerto.Text;
       Proceso:=TProcess.Create(Nil);
       S:= TStringList.Create;
      AStringList := TStringList.Create;
       Proceso.Options:= [poWaitOnExit,poUsePipes];
      Proceso.Executable := 'stm32flash';
      Proceso.Parameters.Add('-w');
      Proceso.Parameters.Add(codehex);
      Proceso.Parameters.Add('-v');
      Proceso.Parameters.Add('-g');
      Proceso.Parameters.Add('0x0');
      Proceso.Parameters.Add(puerto);
      Proceso.Execute;

      AStringList.LoadFromStream(Proceso.Output);
      S.LoadFromStream(Proceso.Stderr);
      AStringList.AddStrings(S,False);  //añade los errores
      AStringList.SaveToFile('output.txt');//lo guarda
      AStringList.Free;   //libera
      S.Free;//libera
      mmlog.Lines.LoadFromFile('output.txt');  //lee



end;

procedure TSTM32FLASH_2.btleerClick(Sender: TObject);
var
AStringList,S: TStringList;
Proceso:TProcess;
begin
       ShowMessage('Debe colocar BOOT0 en 1 y pulsar RST');
      ShowMessage('Si tarda demasiado tiempo cierre la aplicacion');
      puerto :=edpuerto.Text;
       Proceso:=TProcess.Create(Nil);

        AStringList := TStringList.Create;
        S:= TStringList.Create;
       Proceso.Options:= [poWaitOnExit,poUsePipes];
      Proceso.Executable := 'stm32flash';
      Proceso.Parameters.Add('-r');
      Proceso.Parameters.Add('archivo.hex');

      Proceso.Parameters.Add(puerto);
      Proceso.Execute;

      AStringList.LoadFromStream(Proceso.Output);
      S.LoadFromStream(Proceso.Stderr);
      AStringList.AddStrings(S,False);  //añade los errores
      AStringList.SaveToFile('output.txt');//lo guarda
      AStringList.Free;   //libera
      S.Free;//libera
      mmlog.Lines.LoadFromFile('output.txt');  //lee



end;

procedure TSTM32FLASH_2.FormShow(Sender: TObject);
begin
  ShowMessage('introdusca el puerto normalmente: /dev/ttyUSB0');
end;

procedure TSTM32FLASH_2.btCargarClick(Sender: TObject);
begin
  if opabrir.Execute then
    begin
      codehex:=opabrir.FileName;
    end;
   edarchivohex.Text:=codehex;
end;

procedure TSTM32FLASH_2.btborrarClick(Sender: TObject);
var
AStringList,S: TStringList;
Proceso:TProcess;
begin
       ShowMessage('Debe colocar BOOT0 en 1 y pulsar RST');
      puerto :=edpuerto.Text;
       Proceso:=TProcess.Create(Nil);

      AStringList := TStringList.Create;
      S:=TStringList.Create;
       Proceso.Options:= [poWaitOnExit,poUsePipes];
      Proceso.Executable := 'stm32flash';
      Proceso.Parameters.Add('-o');

      Proceso.Parameters.Add(puerto);
      Proceso.Execute;

      AStringList.LoadFromStream(Proceso.Output);
      S.LoadFromStream(Proceso.Stderr);
      AStringList.AddStrings(S,False);  //añade los errores
      AStringList.SaveToFile('output.txt');//lo guarda
      AStringList.Free;   //libera
      S.Free;//libera
      mmlog.Lines.LoadFromFile('output.txt');  //lee


end;

end.

