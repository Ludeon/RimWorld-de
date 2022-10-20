@if (@a==@b) @end /*

@echo off
setlocal

for /f "delims=" %%I in ('cscript /nologo /e:jscript "%~f0"') do (
    set FLDR=%%I
)
if "%FLDR%"=="" (exit)

rd /q /s "%FLDR%\Data\Core\Languages\German (Deutsch)"
rd /q /s "%FLDR%\Data\Royalty\Languages\German (Deutsch)"
rd /q /s "%FLDR%\Data\Ideology\Languages\German (Deutsch)"
rd /q /s "%FLDR%\Data\Biotech\Languages\German (Deutsch)"

xcopy /s /i "Core" "%FLDR%\Data\Core\Languages\German (Deutsch)"
xcopy /s /i "Royalty" "%FLDR%\Data\Royalty\Languages\German (Deutsch)"
xcopy /s /i "Ideology" "%FLDR%\Data\Ideology\Languages\German (Deutsch)"
xcopy /s /i "Biotech" "%FLDR%\Data\Biotech\Languages\German (Deutsch)"

del "%FLDR%\Data\Core\Languages\German (Deutsch).tar"
del "%FLDR%\Data\Royalty\Languages\German (Deutsch).tar"
del "%FLDR%\Data\Ideology\Languages\German (Deutsch).tar"
del "%FLDR%\Data\Biotech\Languages\German (Deutsch).tar"

goto :EOF

:: JScript portion */

var shl = new ActiveXObject("Shell.Application");
var folder = shl.BrowseForFolder(0, "W‰hle den RimWorld-Ordner aus. Standardm‰ﬂig:\nC:\\Programme (x86)\\Steam\\steamapps\\common\\RimWorld", 0, 0x11);
WSH.Echo(folder ? folder.self.path : '');