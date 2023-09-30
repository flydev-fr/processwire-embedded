unit GlobalCefApplication;

{$mode ObjFPC}{$H+}
{$I cef.inc}

{.$DEFINE USE_MULTI_THREAD_LOOP} // Only Windows/Linux
{.$DEFINE USE_APP_HELPER}        // Optional on Windows/Linux

{$IFDEF MACOSX}
  {$UNDEF  USE_MULTI_THREAD_LOOP} // Will fail on Mac
  {$DEFINE USE_APP_HELPER}        // Required on Mac
{$ENDIF}

interface

uses
  uCEFApplication, uCEFWorkScheduler, FileUtil;

procedure CreateGlobalCEFApp;

implementation

procedure GlobalCEFApp_OnScheduleMessagePumpWork(const aDelayMS : int64);
begin
  if (GlobalCEFWorkScheduler <> nil) then GlobalCEFWorkScheduler.ScheduleMessagePumpWork(aDelayMS);
end;

procedure CreateGlobalCEFApp;
begin
  if GlobalCEFApp <> nil then
    exit;

  {$IFnDEF USE_MULTI_THREAD_LOOP}
  // TCEFWorkScheduler will call cef_do_message_loop_work when
  // it's told in the GlobalCEFApp.OnScheduleMessagePumpWork event.
  // GlobalCEFWorkScheduler needs to be created before the
  // GlobalCEFApp.StartMainProcess call.
  GlobalCEFWorkScheduler := TCEFWorkScheduler.Create(nil);
  {$ENDIF}

  GlobalCEFApp                           := TCefApplication.Create;
  {$IFDEF USE_MULTI_THREAD_LOOP}
  // On Windows/Linux CEF can use threads for the message-loop
  GlobalCEFApp.MultiThreadedMessageLoop  := True;
  {$ELSE}
  // use External Pump for message-loop
  GlobalCEFApp.ExternalMessagePump       := True;
  GlobalCEFApp.MultiThreadedMessageLoop  := False;
  GlobalCEFApp.OnScheduleMessagePumpWork := @GlobalCEFApp_OnScheduleMessagePumpWork;
  {$ENDIF}

  //GlobalCEFApp.CheckCEFFiles := false;

  {$IFnDEF MACOSX}
  {$IFDEF USE_APP_HELPER}
  (* Use AppHelper as subprocess, instead of the main exe *)
  GlobalCEFApp.BrowserSubprocessPath := 'AppHelper' + GetExeExt;
  {$ENDIF}
  {$ENDIF}

  {$IFDEF MACOSX}
  (* Enable the below to prevent being asked for permission to access "Chromium Safe Storage"
     If set to true, Cookies will not be encrypted.
  *)
  GlobalCEFApp.UseMockKeyChain := True; {debug}
  {$ENDIF}
  {$IFDEF LINUX}
  // This is a workaround for the 'GPU is not usable error' issue :
  // https://bitbucket.org/chromiumembedded/cef/issues/2964/gpu-is-not-usable-error-during-cef
  GlobalCEFApp.DisableZygote := True; // this property adds the "--no-zygote" command line switch
  {$ENDIF}
  {
  GlobalCEFApp.LogFile     := 'cef.log';
  GlobalCEFApp.LogSeverity := LOGSEVERITY_VERBOSE;
  }
end;

end.

