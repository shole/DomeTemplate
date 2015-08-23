@echo off
if "%2" == "" goto inputerror

echo Separating UV components...
convert %1 -channel R -separate _separateU.png
convert %1 -channel G -separate _separateV.png
convert %2 -channel R -separate _separateUdetail.png
convert %2 -channel G -separate _separateVdetail.png

echo Combining UVs...
convert _separateU.png _separateV.png _separateUdetail.png _separateVdetail.png -channel RGBA -combine combined_%1
del _separateUdetail.png _separateVdetail.png _separateU.png _separateV.png

echo.
echo Created combined UV file "combined_%1"
echo   from "%1" as primary UV
echo    and "%2" as detail UV.
echo.
echo Remember to set as uncompressed on import!
echo.
goto end

:inputerror
echo.
echo This is a tool to combine two separate 16bit UV images into one 32bit image
echo.
echo Usage: combineUVs UV.png UVdetail.png
echo.

:end
pause
