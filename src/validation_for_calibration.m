function headtop_estimation = validation_for_calibration(standpoint_0, filename, resolution)

height_array = 1.5:0.01:2.2;
caliIn = readCameraCalibration(filename);
caliEx = computeCalibrationVariables(caliIn, resolution(1), resolution(2));

sp_cam = transform2DimgTo3DWorld(standpoint_0, caliEx, 0);
headtop_array = zeros(length(height_array), 3);
headtop_array(:,1:2) = repmat(sp_cam, length(height_array), 1);
headtop_array(:,3) = height_array;
headtop_estimation = transform3Dto2DforMoreHeights(headtop_array(:,1:2), caliEx, headtop_array(:,3));

