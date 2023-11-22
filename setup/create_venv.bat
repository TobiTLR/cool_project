@echo off
TITLE "Install virtual environment"

:start
cls

:: Set Python version
set "python_version=39-32"

:: Check if Python folder name has a period between version and revision number
set "python_folder=C:\Users\%username%\AppData\Local\Programs\Python\Python%python_version%"
if not exist "%python_folder%" (
    set /p "python_version=39" <nul
    set "python_folder=C:\Users\%username%\AppData\Local\Programs\Python\Python%python_version%"
    if not exist "%python_folder%" (
        echo ERROR: Python installation not found!
        goto SETUPFAILERROR
    )
)

:: Set Python path and current directory path
set "pythonpath=%python_folder%\"
set "currentdir=%~dp0"

echo Attempt to install a virtual environment using the following Python installation:
echo "%pythonpath%"
echo.
echo.

:check_python
"%pythonpath%python" -c "print(1)"
if errorlevel 1 goto python_find_error
echo SUCCESS: Found python
goto venv_install

:python_find_error
powershell -Command "Invoke-WebRequest https://www.python.org/ftp/python/%python_version%.10/python-%python_version%.10-amd64.exe -OutFile installer.exe"
if errorlevel 1 goto SETUPFAILERROR
installer.exe
if errorlevel 1 goto SETUPFAILERROR
goto venv_install 

:venv_install
echo -Install virtual environment:
echo ------------------------------------
cd "%currentdir%.."
"%pythonpath%python" -m venv --system-site-packages venv
if errorlevel 1 goto VENVINSTALLERROR
echo SUCCESS: Virtual environment installation successful
goto POSTVENV
:VENVINSTALLERROR
echo FAIL: Venv installation failed or is already completed!
goto SETUPFAILERROR
:POSTVENV
echo.
echo.

echo -Activate virtual environment:
echo ------------------------------------
cd "%currentdir%venv\Scripts"
call "deactivate.bat"
call "activate.bat"
pip install artifacts-keyring
pip install wheel
cd ..
if errorlevel 1 goto VENVACTIVATIONERROR
echo SUCCESS: Virtual environment activated
goto POSTVENVACTIVATION
:VENVACTIVATIONERROR
echo FAIL: Activation of virtual environment failed!
cd "%~dp0"
goto SETUPFAILERROR
:POSTVENVACTIVATION
echo.
echo.

echo -Install latest pip version:
echo ------------------------------------
python -m pip install --upgrade pip
if errorlevel 1 goto PIPUPDATEERROR
echo SUCCESS: Latest pip installed
goto POSTPIPUPDATE
:PIPUPDATEERROR
echo FAIL: Pip installation error
goto SETUPFAILERROR
:POSTPIPUPDATE
echo.
echo.

echo You may close this prompt now.
@pause

:SETUPFAILERROR
echo.
echo ERROR: Setup failed. Press any key to exit...
@pause > nul
exit /b 1