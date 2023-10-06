@echo off
REM Converts an animated gif to a spritesheet using ImageMagick
set file_name=%~n1
magick montage %1 -tile x1 -geometry "1x1+0+0<" -alpha On -background "rgba(0, 0, 0, 0.0)" -quality 100 %file_name%.png
echo Converted %1 to %file_name%.png

REM wait for user input
pause