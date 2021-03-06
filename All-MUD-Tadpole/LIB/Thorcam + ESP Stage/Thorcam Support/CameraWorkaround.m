%   Add NET assembly if it does not exist
%   May need to change specific location of library
asm = System.AppDomain.CurrentDomain.GetAssemblies;
if ~any(arrayfun(@(n) strncmpi(char(asm.Get(n-1).FullName), ...
        'uc480DotNet', length('uc480DotNet')), 1:asm.Length))
    NET.addAssembly(...
        'C:\Program Files\Thorlabs\Scientific Imaging\DCx Camera Support\Develop\DotNet\signed\uc480DotNet.dll');
end
%   Create camera object handle
cam = uc480.Camera;
%   Open 1st available camera
%   Returns if unsuccessful
if ~strcmp(char(cam.Init), 'SUCCESS')
    error('Could not initialize camera');
end
%   Set display mode to bitmap (DiB)
if ~strcmp(char(cam.Display.Mode.Set(uc480.Defines.DisplayMode.DiB)), ...
        'SUCCESS')
    error('Could not set display mode');
end
%   Set colormode to 8-bit RAW
if ~strcmp(char(cam.PixelFormat.Set(uc480.Defines.ColorMode.SensorRaw8)), ...
        'SUCCESS')
    error('Could not set pixel format');
end
%   Set trigger mode to software (single image acquisition)
if ~strcmp(char(cam.Trigger.Set(uc480.Defines.TriggerMode.Software)), 'SUCCESS')
    error('Could not set trigger format');
end
%   Allocate image memory
[ErrChk, img.ID] = cam.Memory.Allocate(true);
if ~strcmp(char(ErrChk), 'SUCCESS')
    error('Could not allocate memory');
end
%   Obtain image information
[ErrChk, img.Width, img.Height, img.Bits, img.Pitch] ...
    = cam.Memory.Inquire(img.ID);
if ~strcmp(char(ErrChk), 'SUCCESS')
    error('Could not get image information');
end
%   Acquire image
if ~strcmp(char(cam.Acquisition.Freeze(true)), 'SUCCESS')
    error('Could not acquire image');
end
%   Extract image
[ErrChk, tmp] = cam.Memory.CopyToArray(img.ID); 
if ~strcmp(char(ErrChk), 'SUCCESS')
    error('Could not obtain image data');
end
%   Reshape image
img.Data = reshape(uint8(tmp), [img.Width, img.Height, img.Bits/8]);
%   Draw image
himg = imshow(img.Data, 'Border', 'tight');
%   Acquire & draw 100 times
for n=1:100
    %   Acquire image
    if ~strcmp(char(cam.Acquisition.Freeze(true)), 'SUCCESS')
        error('Could not acquire image');
    end
      %   Extract image
      [ErrChk, tmp] = cam.Memory.CopyToArray(img.ID); 
      if ~strcmp(char(ErrChk), 'SUCCESS')
          error('Could not obtain image data');
      end
      %   Reshape image
      img.Data = reshape(uint8(tmp), [img.Width, img.Height, img.Bits/8]);
      %   Draw image
      set(himg, 'CData', img.Data);
himg = imshow(img.Data, 'Border', 'tight');
  end
%   Close camera
if ~strcmp(char(cam.Exit), 'SUCCESS')
    error('Could not close camera');
end