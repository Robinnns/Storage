@echo off
rem ============================================================
rem  iverilog simulation script - A7-LITE LED blink project
rem  Usage: double-click, or run from command line
rem  Outputs: ..\workspace\top_tb.vvp (compiled) / top_tb.vcd (waveform)
rem  Note: workspace is gitignored, not committed
rem ============================================================

set SCRIPT_DIR=%~dp0
set WORK_DIR=%SCRIPT_DIR%..\workspace
set SRC_DIR=%SCRIPT_DIR%..\..\..\rtl
set SIM_DIR=%SCRIPT_DIR%..\..\..\tb

rem ---- ensure output directory exists ----
if not exist "%WORK_DIR%" mkdir "%WORK_DIR%"

rem ---- compile (VCD dump enabled via DUMP_VCD) ----
iverilog -g2012 -DDUMP_VCD -o "%WORK_DIR%\top_tb.vvp" -s tb_top "%SRC_DIR%\top.v" "%SIM_DIR%\tb_top.v"
if errorlevel 1 (
    echo [ERROR] compilation failed
    exit /b 1
)

rem ---- run simulation (CWD switched to workspace, VCD written here) ----
cd /d "%WORK_DIR%"
vvp top_tb.vvp
if errorlevel 1 (
    echo [ERROR] simulation failed
    exit /b 1
)

echo.
echo [OK] simulation finished
echo      waveform: %WORK_DIR%\top_tb.vcd
echo      open with GTKWave: gtkwave top_tb.vcd
