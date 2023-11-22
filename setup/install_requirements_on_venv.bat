@echo off
TITLE "Activate virtual environment and install requirements"

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

echo Attempt to activate the virtual environment using the following Python installation:
echo "%pythonpath%"
echo.
echo.

:check_python
"%pythonpath%python" -c "print(1)"
if errorlevel 1 goto python_find_error
echo SUCCESS: Found python
goto venv_activate

:python_find_error
echo ERROR: Python not found!
goto SETUPFAILERROR

:venv_activate
echo -Activate virtual environment:
echo ------------------------------------
cd "%currentdir%..\venv\Scripts"
call "deactivate.bat"
call "activate.bat"
if errorlevel 1 goto VENVACTIVATIONERROR
echo SUCCESS: Virtual environment activated
goto install_requirements

:VENVACTIVATIONERROR
echo FAIL: Activation of virtual environment failed!
cd "%~dp0"
goto SETUPFAILERROR

:install_requirements
echo.
echo.

echo -Install packages from requirements.txt:
echo ------------------------------------
pip install -r "%currentdir%..\requirements.txt"
if errorlevel 1 goto REQUIREMENTSERROR
echo SUCCESS: Packages from requirements.txt installed
goto POSTINSTALL

:REQUIREMENTSERROR
echo FAIL: Error installing packages from requirements.txt
goto SETUPFAILERROR

:POSTINSTALL
echo.
echo.

echo You may close this prompt now.
@pause

:SETUPFAILERROR
echo.
echo ERROR: Setup failed. Press any key to exit...
@pause > nul
exit /b 1