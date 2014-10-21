@echo off

Rem clear all cache
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 4351

set isIE=0

Rem check the IE process available 
for /f %%i in ('tasklist') do (
    if %%i == iexplore.exe (
         rem if found IE process, change the isIE variable
         set isIE=1
    )
)

if %isIE% == 1 (
   echo "Find IE process,kill them"
   TASKKILL /F /IM iexplore.exe
) else (
   echo "NO IE process"
)


REM uninstall 
cd c:/VO/Plugins
echo install the plugin 
REM msiexec /x Ericsson_Player_IE_Plugin_3.12.0.msi /qb

echo uninstall
msiexec /x Ericsson_Player_IE_Plugin_3.9.10.msi /qb

echo uninstall
msiexec /x Ericsson_Player_IE_Plugin_3.10.8.msi /qb

echo uninstall
msiexec /x Ericsson_Player_IE_Plugin_3.11.11.msi /qb

Rem Add new plugin uninstall
echo unistall
msiexec /x EricssonBrowserPlugin_3.12.20_debug /qb



REM install
echo install
Rem msiexec /i Ericsson_Player_IE_Plugin_3.12.0.msi /qb

msiexec /i EricssonBrowserPlugin_3.12.0_debug.msi /qb

echo install successful

echo modify register DRM address -> 10.170.78.65:80
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\VisualOn\BrowserPlugin\DRMVerification\Verimatrix /v server /t REG_SZ /d 10.170.78.65:80 /f

copy /Y c:\VO\Plugins\volog.cfg C:\ProgramData\VisualOn\BrowserPlugin

echo %date% %time%
start /max "C:\Program Files (x86)\Internet Explorer\iexplore.exe" "http://10.170.78.136:8499/portal-root-war/index_mock.html"
echo %date% %time%
