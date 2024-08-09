@echo off

echo Autodesk Cleanup
echo V1.0 By Joseph Friend

echo -----------------------------

echo Currently Installed Autodesk Applications Are:

echo -----------------------------

for /f "tokens=2*" %%A in (
  'reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Autodesk\UPI2" /V /F ProductName /S /E 2^>nul ^| findstr "ProductName"'
) do (
  echo %%B
)

echo -----------------------------

choice /c yn /m "Would you like to remove all Autodesk products"
IF ERRORLEVEL 2 GOTO Exit
IF ERRORLEVEL 1 GOTO Clean

:Clean
echo -----------------------------

echo Starting Autodesk removal...

for /f "tokens=2*" %%A in (
  'reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Autodesk\UPI2" /V /F ProductCode /S /E 2^>nul ^| findstr "ProductCode"'
) do (
  MsiExec.exe /x %%B /passive
)

for /f "tokens=2*" %%A in (
  'reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /V /F DisplayName /S /E 2^>nul ^| findstr "DisplayName"'
) do (
  for /f "delims=" %%P in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /f "%%B" 2^>nul ^| findstr "HKEY_LOCAL_MACHINE"') do (
    for /f "tokens=2*" %%X in (
      'reg query "%%P" /v "Publisher" 2^>nul ^|findstr "Publisher"'
    ) do (
      for /f "tokens=2*" %%C in (
      'reg query "%%P" /v "UninstallString" 2^>nul ^|findstr "UninstallString"'
      ) do (
       	if "%%Y" == "Autodesk, Inc." (
          for /f "tokens=1* delims=-" %%a in ("%%D") do (
            echo %%B is being Unistalled silently no progress bar will be shown
            "%%a" -%%b -q
          )
	)
      )
    )
  )
)

echo Autodesk removal completed!

:Exit
echo -----------------------------

pause
