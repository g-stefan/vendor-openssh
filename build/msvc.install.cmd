@echo off
rem Public domain
rem http://unlicense.org/
rem Created by Grigore Stefan <g_stefan@yahoo.com>

echo - %BUILD_PROJECT% ^> install

set INSTALL_PATH=%XYO_PATH_REPOSITORY%
set INSTALL_PATH_BIN=%XYO_PATH_REPOSITORY%\opt\openssh
set INSTALL_PATH_DEV=%INSTALL_PATH_BIN%

rem // ---

call build\msvc.install.sub.cmd
