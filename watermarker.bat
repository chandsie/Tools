@ECHO OFF

REM Written by: Shreyas Chand
REM Written on: 11/2/2011
REM Version: 1.0
REM Email: shreyas.chand@gmail.com
REM Website: shreyaschand.com
REM ImageMagick script to watermark all images in current directory

ECHO Working....
ECHO.
ECHO.
ECHO Now creating the watermark.

REM Create the watermark base
convert -size 3010x500 xc:grey30 -font Arial -pointsize 200 -gravity center -draw "fill grey70  text 0,0  '[INSERT WATERMARK TEXT HERE]'" _im_stamp_fgnd.png


REM Create a transperency mask for watermark
convert -size 3010x500 xc:black -font Arial -pointsize 200 -gravity center -draw "fill white  text  1,1  '[INSERT WATERMARK TEXT HERE]' text  0,0  '[INSERT WATERMARK TEXT HERE]' fill grey70 text -1,-1 '[INSERT WATERMARK TEXT HERE]'" +matte _im_stamp_mask.png


REM Overlay watermark parts and create a stamp
composite -compose CopyOpacity  _im_stamp_mask.png  _im_stamp_fgnd.png  _im_stamp.png
mogrify -trim +repage _im_stamp.png

ECHO.
ECHO Watermark created.
ECHO.
ECHO Stamping images with watermark...
ECHO This may take some time.
ECHO.


REM Stamp all pictures with watermark and place them in subdirectory 'marked'
MKDIR marked
FOR /f %%a IN ('dir /b *.jpg') DO (
ECHO Stamping file: %%~na%%~xa
ECHO. 
composite -gravity south -geometry +0+10 _im_stamp.png %%~na%%~xa marked/%%~na-wm%%~xa
)

ECHO Done!
ECHO.
ECHO Cleaning up now.

REM Cleanup
DEL _im_*.png

ECHO. 
ECHO Cleaned.
ECHO.
ECHO Goodbye!
