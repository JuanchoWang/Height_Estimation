function coords3D = transform2DimgTo3DWorld(coord2D,calibration,height)
% res(1),res(2) = Xi/z and Eta/z, res(3) = 1/z
if (calibration.useRadialDistortion)
   [coord2D(:,1) coord2D(:,2)] = calcUndistortedImageCoord(coord2D(:,1),coord2D(:,2),calibration); 
end

coords3D = zeros(size(coord2D));

H = generateHomography(calibration.KR,calibration.elevation-height);
for ipt=1:size(coord2D,1)
    res = H\[coord2D(ipt,:) 1]';
    coords3D(ipt,:) = [res(1)/res(3) res(2)/res(3)];
end
