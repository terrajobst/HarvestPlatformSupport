@echo off
setlocal

:: Use VSINSTALLDIR if present

if not "%VSINSTALLDIR%" == "" goto setmsbuild

:: Use vswhere to find an install of VS 2017

set VSWHERE="%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if not exist %VSWHERE% goto error
for /f "tokens=*" %%i in ('%VSWHERE% -property installationPath -prerelease') do set VSINSTALLDIR=%%i

:setmsbuild

set MSBuild="%VSINSTALLDIR%\MSBuild\Current\Bin\MSBuild.exe"
if exist %MSBuild% goto build

:error

if exist %MSBuild% goto build
echo ERROR: You need Visual Studio 2017 to build.
exit /B -1

:build

setlocal
set OutDir="%~dp0bin"

if not exist %OutDir% mkdir %OutDir%
pushd "%~dp0src"
%MSBuild% /nologo /m /v:m /nr:false /bl:%~dp0\msbuild.binlog /t:Restore /t:Build /p:OutDir=%OutDir% %*
popd
