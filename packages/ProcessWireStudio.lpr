program ProcessWireStudio;

{$mode objfpc}{$H+}
{$I cef.inc}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  {$IFDEF LINUX}
  InitSubProcess, // On Linux this unit must be used *before* the "interfaces" unit.
  {$ENDIF}
  Interfaces,
  Forms,
  uBrowserWindowEx, GlobalCefApplication
  // ...
  ;

{$R *.res}

{$IFDEF WIN32}
  // CEF needs to set the LARGEADDRESSAWARE ($20) flag which allows 32-bit processes to use up to 3GB of RAM.
  {$SetPEFlags $20}
{$ENDIF}

begin
  RequireDerivedFormResource:=True;
  Application.Title := 'ProcessWireStudio';
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

