@if (@a==@b) @end /*

@echo off
setlocal

for /f "delims=" %%I in ('cscript /nologo /e:jscript "%~f0"') do (
    set FLDR=%%I
)
rd /q /s "%FLDR%\Core\Languages\German (Deutsch)"
rd /q /s "%FLDR%\Royalty\Languages\German (Deutsch)"
rd /q /s "%FLDR%\Ideology\Languages\German (Deutsch)"
rd /q /s "%FLDR%\Biotech\Languages\German (Deutsch)"

xcopy /s /i "Core" "%FLDR%\Core\Languages\German (Deutsch)"
xcopy /s /i "Royalty" "%FLDR%\Royalty\Languages\German (Deutsch)"
xcopy /s /i "Ideology" "%FLDR%\Ideology\Languages\German (Deutsch)"
xcopy /s /i "Biotech" "%FLDR%\Biotech\Languages\German (Deutsch)"

del "%FLDR%\Core\Languages\German (Deutsch).tar"
del "%FLDR%\Royalty\Languages\German (Deutsch).tar"
del "%FLDR%\Ideology\Languages\German (Deutsch).tar"
del "%FLDR%\Biotech\Languages\German (Deutsch).tar"

goto :EOF

:: JScript portion */

var shl = new ActiveXObject("Shell.Application");
var folder = shl.BrowseForFolder(0, "Choose the 'Data' folder in your RimWorld directory.\nWaehle den Ordner 'Data' in deinem RimWorld-Verzeichnis aus.", 0, 0x00);
WSH.Echo(folder ? folder.self.path : '');