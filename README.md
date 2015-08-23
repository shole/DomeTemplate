#Using the Unity template project
Open /UnityProject in Unity5.  
**Assets/dometemplate.unity** is an example scene with some simple content ready for use.  
If you have an existing project, **Assets/ProjectorUV/DomeRendering.prefab** is a prefab containing everything necessary you can just drop to your game.  
The dome camera is set at prefab coordinates **0,0,0**, facing **up**.  

###While developing
It's easier to develop with the camera in 'fisheye' mode where you see everything bottom-up.  
Enable "**DomeRendering/Camera: fisheye preview**".  

###For dome projection
Disable "**DomeRendering/Camera: fisheye preview**".  
Build project.  


#16bit UV distortion map creation
Disable all color filtering (interpolation) from the projection software if possible.
A UVmap is a pixel-to-pixel mapping so it should be as accurate as possible.
Any aliasing artefacts you might see on the resulting UV maps gets smoothed out automagically in runtime texture interpolation.
It makes sense to pick a UVmap resolution slightly bigger, but closely matching the final presentation screen resolution.

###Rendering the Base UV map:
If projection software cannot be trusted to not filter the image, it's safest to use one of the upscaled UVmap versions in the prescaled/ folder. (**UVmap_*.png**)
Take the base UV map and save it's warped version.
The save resolution should be a power of 2 square, such as 2048x2048.
(This bitmap is also a standard 8x8bit UVmap.)

###Rendering the Detail UV map:
For optimal quality, take **UVmap_detail_1of128.png**, REPEAT it 128x128 times across the area.
This would give us the theoretical resolution of 65536x65536 to work with.
Do the warp and save the image as a power of 2 square **matching** the Base UV resolution.
If the texture repeat cannot be done or other issues are encountered, pick one of the pre-scaled detail-textures. (**UVmap_detail_*.png**)
Pick as high resolution one as possible, and perform the same procedure as with the base UV map and save to a power of 2 resolution **matching** the Base UV resolution.

To combine the UV maps, put them in the "**combine UVs to single 32bit image**" folder.  
Open a commandline and run "**combineUVs.bat UVmap.png UVmap_detail.png**"

###When importing to the engine, For best quality set these texture settings;  
Texture Type: Advanced  
Generate Mip Maps: off  
Format: RGBA32 or Truecolor        <- this one is especially important

