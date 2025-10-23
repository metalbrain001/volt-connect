@echo off
REM Git pre-commit hook for VoltConnect (Windows)
bash Scripts\tools\pre_commit.sh
if %errorlevel% neq 0 exit /b %errorlevel%