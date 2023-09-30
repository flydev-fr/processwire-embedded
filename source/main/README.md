BrowserWindow

# Notes

Compile with FPC/Trunk. Require submodules CEF4 and mORMot-2.1.

TCEFWorkScheduler feeds the CEF messageloop by calling DoMessageLoopWork(). On Mac this is currently the only way to run the CEF messageloop.

# Setup

** Windows
1) Download the CEF framework and place the content of the "Release" folder into the same folder as the exe.
   Alternatively point "GlobalCEFApp.FrameworkDirPath" to the location with the libraries.
2) Run the project

** Linux
1) Download the CEF framework and place the content of the "Release" folder into the same folder as the executable.
   Alternatively point "GlobalCEFApp.FrameworkDirPath" to the location with the libraries.
2) Run the project

Note:
- For Linux project we must modify the project source (lpr) and add "InitSubProcess" to the "uses" clause, so that it is in the list *before* the unit "Interfaces".
- The call to "DestroyGlobalCEFApp" must be in a unit *not* used by "unit InitSubProcess" (including not used in any nested way).


** Mac
1) Go to "project options" and create the "App Bundle"
2) Download the CEF framework and place the content of the "Release" folder into ProcessWireStudio.app/Contents/Frameworks/Chromium Embedded Framework.framework
The tree should be:
  Chromium Embedded Framework
  Libraries/*
  Resources/*
3) Open project "AppHelper", create App Bundle and compile the AppHelper.
   Run create_mac_helper.sh
4) Open project ProcessWireStudio, compile and run


