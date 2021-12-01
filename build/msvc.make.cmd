@echo off
rem Public domain
rem http://unlicense.org/
rem Created by Grigore Stefan <g_stefan@yahoo.com>

set ACTION=%1
if "%1" == "" set ACTION=make

echo - %BUILD_PROJECT% ^> %1

goto cmdXDefined
:cmdX
%*
if errorlevel 1 goto cmdXError
goto :eof
:cmdXError
echo "Error: %ACTION%"
exit 1
:cmdXDefined

if not "%ACTION%" == "make" goto :eof

call :cmdX xyo-cc --mode=%ACTION% --source-has-archive openssh

if not exist output\ mkdir output
if not exist temp\ mkdir temp

set INCLUDE=%XYO_PATH_REPOSITORY%\include;%INCLUDE%
set LIB=%XYO_PATH_REPOSITORY%\lib;%LIB%
set WORKSPACE_PATH=%CD%
set WORKSPACE_PATH_OUTPUT=%WORKSPACE_PATH%\output
set WORKSPACE_PATH_BUILD=%WORKSPACE_PATH%\temp

set BUILD_MACHINE=unkwnown
set BUILD_PATH=unkwnown

if "%XYO_PLATFORM%" == "win64-msvc-2022" SET BUILD_PLATFORM=x64&&set BUILD_PATH=x64
if "%XYO_PLATFORM%" == "win32-msvc-2022" SET BUILD_PLATFORM=x86&&set BUILD_PATH=Win32

if "%XYO_PLATFORM%" == "win64-msvc-2019" SET BUILD_PLATFORM=x64&&set BUILD_PATH=x64
if "%XYO_PLATFORM%" == "win32-msvc-2019" SET BUILD_PLATFORM=x86&&set BUILD_PATH=Win32

if "%XYO_PLATFORM%" == "win64-msvc-2017" SET BUILD_PLATFORM=x64&&set BUILD_PATH=x64
if "%XYO_PLATFORM%" == "win32-msvc-2017" SET BUILD_PLATFORM=x86&&set BUILD_PATH=Win32

if exist %WORKSPACE_PATH_BUILD%\build.done.flag goto :eof

pushd "source\contrib\win32\openssh"

msbuild /property:Configuration=Release /property:Platform=%BUILD_PLATFORM% /target:Build Win32-OpenSSH.sln -maxcpucount
if errorlevel 1 goto makeError

goto buildDone

:makeError
popd
echo "Error: make"
exit 1

:buildDone
popd

if not exist %WORKSPACE_PATH_OUTPUT% mkdir %WORKSPACE_PATH_OUTPUT%

copy /Y /B source\bin\%BUILD_PATH%\Release\*.exe %WORKSPACE_PATH_OUTPUT%\*
copy /Y /B source\bin\%BUILD_PATH%\Release\*.ps1 %WORKSPACE_PATH_OUTPUT%\*
copy /Y /B source\bin\%BUILD_PATH%\Release\OpenSSHUtils.* %WORKSPACE_PATH_OUTPUT%\*
copy /Y /B source\bin\%BUILD_PATH%\Release\Openssh-events.man %WORKSPACE_PATH_OUTPUT%\Openssh-events.man
copy /Y /B source\bin\%BUILD_PATH%\Release\sshd_config_default %WORKSPACE_PATH_OUTPUT%\sshd_config_default
copy /Y /B source\contrib\win32\openssh\LibreSSL\bin\desktop\%BUILD_PLATFORM%\libcrypto.dll %WORKSPACE_PATH_OUTPUT%\libcrypto.dll
copy /Y /B source\contrib\win32\openssh\install-sshd.ps1 %WORKSPACE_PATH_OUTPUT%\install-sshd.ps1
copy /Y /B source\contrib\win32\openssh\uninstall-sshd.ps1 %WORKSPACE_PATH_OUTPUT%\uninstall-sshd.ps1
copy /Y /B source\contrib\win32\openssh\FixHostFilePermissions.ps1 %WORKSPACE_PATH_OUTPUT%\FixHostFilePermissions.ps1
copy /Y /B source\contrib\win32\openssh\FixUserFilePermissions.ps1 %WORKSPACE_PATH_OUTPUT%\FixUserFilePermissions.ps1
copy /Y /B source\LICENCE %WORKSPACE_PATH_OUTPUT%\LICENSE
copy /Y /B build\source\OpenSSHUtils.psm1 %WORKSPACE_PATH_OUTPUT%\OpenSSHUtils.psm1

echo done > %WORKSPACE_PATH_BUILD%\build.done.flag

