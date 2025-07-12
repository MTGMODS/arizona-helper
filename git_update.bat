@echo off
cd /d "%~dp0"
git add .
git commit -m "Update Files"
git push
