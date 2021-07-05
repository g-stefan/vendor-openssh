@echo off
rem Public domain
rem http://unlicense.org/
rem Created by Grigore Stefan <g_stefan@yahoo.com>

echo -^> sign vendor-openssh

pushd temp\openssh
for /r %%i in (*.dll) do call grigore-stefan.sign "openssh" "%%i"
for /r %%i in (*.exe) do call grigore-stefan.sign "openssh" "%%i"
popd
