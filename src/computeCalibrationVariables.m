function [calibration] = computeCalibrationVariables(calibrationIn, imgWidth, imgHeight)

calibration = calibrationIn;

%read image and get image size
calibration.width = imgWidth ;
calibration.height = imgHeight ;

calibration.principalPointX = (calibration.width-1)*0.5;
calibration.principalPointY = (calibration.height-1)*0.5;

factor = 2.0 / imgWidth;
factor = factor*factor;
calibration.radialDistortionK1norm = calibration.radialDistortionK1 * factor;
factor = factor*factor;
calibration.radialDistortionK2norm = calibration.radialDistortionK2 * factor;
        
if (calibration.useRadialDistortion)
    calibration = updateRadialDistortion(calibration); 
end
        
K = [calibration.scaleX,      0,                       calibration.principalPointX; ...
     0,                       calibration.scaleY,      calibration.principalPointY; ...
     0,                       0,                              1];

cx = cos(calibration.tiltAngle + pi/2);   
sx = sin(calibration.tiltAngle + pi/2);   
cy = cos(calibration.panAngle);   
sy = sin(calibration.panAngle);   
cz = cos(calibration.rollAngle);   
sz = sin(calibration.rollAngle);   

R = [cy * cz,   sx * sy * cz - cx * sz,       cx * sy * cz + sx * sz;...
     cy * sz,   sx * sy * sz + cx * cz,       cx * sy * sz - sx * cz;...
     - sy,          sx * cy,                           cx * cy];

 calibration.KR = K*R;
 
 [H t]= generateHomography(calibration.KR,calibration.elevation);
 
 P = [calibration.KR t;...
      0.0 0.0 0.0 1.0];
   
calibration.P = P;
calibration.H = H;



function calibration = updateRadialDistortion(calibration)

DISTORTION_LUT_SIZE = 5000;

l_radImageSqr = calibration.principalPointX * calibration.principalPointX + ...
                calibration.principalPointY * calibration.principalPointY;

l_radMax = DISTORTION_LUT_SIZE;

calibration.distortionLUT = zeros(1,DISTORTION_LUT_SIZE);

l_undistortedRadIndex = 0;
l_oldUndistortedRadIndex = 0;
l_radImage = 0.0;
l_undistortedRad = 0.0;
l_oldUndistortedRad = 0.0;
l_scaleFactor = 1.0;
l_oldScaleFactor = 1.0;

%change index form 0 to one later
calibration.distortionLUT(1) = 1.0;

while (l_undistortedRadIndex <= l_radMax)
    l_oldScaleFactor = l_scaleFactor;

    if (l_undistortedRad > 0.0)
        l_scaleFactor = l_radImage / l_undistortedRad;
    else 
        l_scaleFactor = 1.0;
    end

    diff = l_scaleFactor - l_oldScaleFactor;
    for idx = l_oldUndistortedRadIndex+1:1:l_undistortedRadIndex

        calibration.distortionLUT(idx) = l_oldScaleFactor ...
            + diff * (round(idx) - l_oldUndistortedRad)  ...
            / (l_undistortedRad - l_oldUndistortedRad);
    end

    l_radImage = l_radImage + 0.1; 
    l_radImageSqr = l_radImage * l_radImage;
    l_oldUndistortedRad = l_undistortedRad;
    l_undistortedRad = l_radImage ...
        * (1.0 + calibration.radialDistortionK1norm * l_radImageSqr ...
        + calibration.radialDistortionK2norm * l_radImageSqr * l_radImageSqr);

    l_oldUndistortedRadIndex = l_undistortedRadIndex;
    l_undistortedRadIndex = round(l_undistortedRad);
 end