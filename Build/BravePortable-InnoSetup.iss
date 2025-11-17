; Inno Setup Script for BravePortable
; Creates: brave-portable-win64-setup.exe (like Portapps)
; Download Inno Setup from: https://jrsoftware.org/isdl.php

#define MyAppName "Brave Portable"
#define MyAppVersion "1.0"
#define MyAppPublisher "BravePortable"
#define MyAppURL "https://brave.com"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
AppId={{AFE6A462-C574-4B8A-AF43-4CC60DF4563B}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
DefaultDirName=C:\Portables\BravePortable
DisableDirPage=no
DisableProgramGroupPage=yes
OutputDir=.
OutputBaseFilename=brave-portable-setup
Compression=lzma2/ultra64
SolidCompression=yes
; This is a portable app, not a traditional installer
CreateAppDir=yes
; Portable mode - no uninstaller
Uninstallable=no
; Show custom page to explain portable nature
PrivilegesRequired=lowest
; Modern look
WizardStyle=modern
SetupIconFile=..\Source\Assets\brave-icon.ico
WizardImageFile=..\Source\Assets\WizardImage.bmp
WizardSmallImageFile=..\Source\Assets\WizardSmallImage.bmp

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
; Copy files from organized Release folder for clean installation
Source: "..\Release\BravePortable.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Release\config.json"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Release\README.txt"; DestDir: "{app}"; Flags: ignoreversion
; Include extensions folder with CRX files
Source: "..\Release\Extensions\*.crx"; DestDir: "{app}\Extensions"; Flags: ignoreversion
; Include Browser folder with Brave binaries (optional - for full bundle installer)
Source: "..\Release\Browser\*"; DestDir: "{app}\Browser"; Flags: ignoreversion recursesubdirs createallsubdirs skipifsourcedoesntexist
; Create empty Data folder (will be populated on first run)
Source: "..\Release\Data\.gitkeep"; DestDir: "{app}\Data"; Flags: ignoreversion
; Optionally include cleanup scripts in a Tools subfolder
Source: "..\Source\CleanupRegistry.ps1"; DestDir: "{app}\Tools"; Flags: ignoreversion
Source: "..\Source\CleanupRegistry.reg"; DestDir: "{app}\Tools"; Flags: ignoreversion
; Include documentation in Docs subfolder (optional)
Source: "..\Documentation\QUICKSTART.md"; DestDir: "{app}\Docs"; Flags: ignoreversion skipifsourcedoesntexist
Source: "..\Documentation\INSTALLATION.md"; DestDir: "{app}\Docs"; Flags: ignoreversion skipifsourcedoesntexist

[Icons]
; Create desktop shortcut
Name: "{autodesktop}\Brave Portable"; Filename: "{app}\BravePortable.exe"; Tasks: desktopicon
; Create shortcuts to cleanup tools
Name: "{app}\Tools\Clean Registry (PowerShell)"; Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File ""{app}\Tools\CleanupRegistry.ps1"""; IconFilename: "{sys}\shell32.dll"; IconIndex: 16; Comment: "Remove Brave registry traces (detailed output)"
Name: "{app}\Tools\Clean Registry (Quick)"; Filename: "{app}\Tools\CleanupRegistry.reg"; IconFilename: "{sys}\shell32.dll"; IconIndex: 16; Comment: "Remove Brave registry traces (instant)"

[Tasks]
Name: "desktopicon"; Description: "Create a desktop shortcut"; GroupDescription: "Additional icons:"
Name: "cleanregistry"; Description: "Clean up registry traces after closing Brave (recommended for portability)"; GroupDescription: "Maintenance options:"; Flags: unchecked

[Run]
; Optionally run BravePortable after installation
Filename: "{app}\BravePortable.exe"; Description: "Launch Brave Portable"; Flags: postinstall nowait skipifsilent
; Optionally run registry cleanup after installation
Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File ""{app}\Tools\CleanupRegistry.ps1"" -NoProfile"; Description: "Clean up registry traces now"; Flags: postinstall skipifsilent runhidden; Tasks: cleanregistry

[Messages]
WelcomeLabel2=This will extract [name] to a folder of your choice.%n%nThis is a portable application - all your data will be stored in the installation folder, not in AppData or Registry.%n%nYou can move this folder to a USB drive or different computer.%n%nOn first launch, Brave will be downloaded automatically if not included.

[Code]
