function [trans2Dimg] = transform3Dto2DforMoreHeights(coord3D, calibration, height)
%res(1),res(2) = u*z and v*z, res(3) = z
trans2Dimg = zeros(size(coord3D));

for ipt=1:size(coord3D,1)
     
    res = Mat4xVec3(calibration.P, [ double(coord3D(ipt,:)) height(ipt) ]);
    trans2Dimg(ipt,:) = [res(1)/res(3) res(2)/res(3)]; 
end

trans2Dimg = round(trans2Dimg);

if (calibration.useRadialDistortion)
   [trans2Dimg(:,1) trans2Dimg(:,2)] = calcDistortedImageCoord(trans2Dimg(:,1),trans2Dimg(:,2),calibration); 
end
