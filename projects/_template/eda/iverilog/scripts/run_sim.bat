@echo off
rem ============================================================
rem  iverilog simulation script - template
rem  Usage: double-click, or run from command line
rem  Edit: change TOP below if your testbench module name differs
rem  Outputs: ..\workspace\*_tb.vvp / *_tb.vcd (gitignored)
rem ============================================================

set TOP=tb_top

set SCRIPT_DIR=%~dp0
set WORK_DIR=%SCRIPT_DIR%..\workspace
set RTL_DIR=%SCRIPT_DIR%..\..\..\rtl
set TB_DIR=%SCRIPT_DIR%..\..\..\tb

rem ---- ensure output directory exists ----
if not exist "%WORK_DIR%" mkdir "%WORK_DIR%"

rem ---- compile (VCD dump enabled via DUMP_VCD) ----
iverilog -g2012 -DDUMP_VCD -o "%WORK_DIR%\%TOP%.vvp" -s %TOP% "%RTL_DIR%\top.v" "%TB_DIR%\%TOP%.v"
if errorlevel 1 (
    echo [ERROR] compilation failed
    exit /b 1
)

rem ---- run simulation (CWD switched to workspace, VCD written here) ----
cd /d "%WORK_DIR%"
vvp %TOP%.vvp
if errorlevel 1 (
    echo [ERROR] simulation failed
    exit /b 1
)

echo.
echo [OK] simulation finished
echo      waveform: %WORK_DIR%\%TOP%.vcd
echo      open with GTKWave: gtkwave %TOP%.vcd
