; Script generated by the Inno Script Studio Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Git LFS"
#define MyAppVersion "1.1.0.0"
#define MyAppPublisher "GitHub, Inc"
#define MyAppURL "https://git-lfs.github.com/"
#define MyAppExeName "Git-LFS-Installer.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{286391DE-F778-44EA-9375-1B21AAA04FF0}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
LicenseFile=..\..\LICENSE.md
OutputBaseFilename=Git-LFS-Installer
Compression=lzma
SolidCompression=yes
DefaultDirName={code:GetExistingGitInstallation}
UsePreviousAppDir=no
DirExistsWarning=no
DisableReadyPage=True

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: ..\..\git-lfs.exe; DestDir: "{app}"; Flags: ignoreversion; AfterInstall: InstallGitLFS;

[Code]
function GetExistingGitInstallation(Value: string): string;
var
  TmpFileName: String;
  ExecStdOut: AnsiString;
  ResultCode: integer;

begin      
  TmpFileName := ExpandConstant('{tmp}') + '\git_location.txt';
  
  Exec(
    ExpandConstant('{cmd}'),
    '/C "for %i in (git.exe) do @echo. %~$PATH:i > "' + TmpFileName + '"', 
    '', SW_HIDE, ewWaitUntilTerminated, ResultCode
  );

  if LoadStringFromFile(TmpFileName, ExecStdOut) then begin
      if not (Pos('Git\cmd', ExtractFilePath(ExecStdOut)) = 0) then begin
        // Proxy Git path detected
        Result := ExpandConstant('{pf64}')+'\Git\mingw64\bin';
      end else begin
        Result := ExtractFilePath(ExecStdOut);
      end;

      DeleteFile(TmpFileName);
  end;
end;

procedure InstallGitLFS();
var
  ResultCode: integer;

begin
  Exec(
    ExpandConstant('{cmd}'),
    '/C "git lfs install"', 
    '', SW_HIDE, ewWaitUntilTerminated, ResultCode
  );
end;
