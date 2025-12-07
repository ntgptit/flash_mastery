@echo off
REM Run build_runner watch with polling to avoid Windows file watcher crashes.
cd /d "%~dp0.."
dart run build_runner watch --delete-conflicting-outputs --use-polling-watcher

