@echo on

echo %TagName%

git checkout %TagName%

git log -3 


echo %PluginVersion%
echo %DRMServer%

@REM copy the Plugin to BrandingScript


@REM clean the last build 
if exist %WORKSPACE%\PC\BrandingScript\resource\bin\*.msi (
  rm -rf *.msi
)

if exist %WORKSPACE%\Web\BrandingScript\Win\resource\bin\*.msi (
  rm -rf *.msi
)

@REM Enter BrandingScript folder and clean
cd %WORKSPACE%\%brandingpath%

DIR
if exist Libs (
  rm -rf Libs
)
 
xcopy /e/c/i  %WORKSPACE%\Common\VO\Plugin\Libs %WORKSPACE%\%brandingpath%\Libs

cd resource

@REM delete tmp file
if exist tmp (
  del tmp
  )

for /F "tokens=1,2* delims==" %%A in (config.cmd) do (
   @rem findstr /R ".*%%B.*" *log* > %%A.max_chitid.txt
    if "%%A" == "set PRODUCT_VERSION" (
	    if "%%B" == "@plugin.version@" (
		    echo %%A=%PluginVersion% >> tmp
		)
	) else if "%%A" == "set MSI_NAME" (
	    echo %%A=Ericsson_Player_IE_Plugin_%PluginVersion% >> tmp 
	) else if "%%A" == "set REGISTRY_DRM_SERVER" (
	    echo %%A=%DRMServer% >> tmp
	) else (
	    echo %%A=%%B >> tmp
	)
)

if exist config.cmd (
   del config.cmd
)

rename tmp config.cmd

@REM exit this folder
cd ..

@REM execute the branding script
call build_branded_msi.bat






