addpath('\\hi2crsmb\external\wan4hi\Code\Height_Estimation_v1.1\src');
img_path = '\\hi2crsmb\external\wan4hi\Daten\DemoArea20140623\picture_sequences_700_949\Originale_Bilder_Cam62_700_949\DemoArea20140623_FreeZone_SD_Cam62-00704.png';
xml_file = '\\hi2crsmb\external\wan4hi\Daten\DemoArea20140623\calibration_data\DemoArea20140619_SD_Cam62_CameraPose.xml';

I = imread(img_path);
figure(1)
img = imshow(I,'Border','tight');
res = size(I);
res = res(2:-1:1);

s_pos = ginput(1);
rectangle('Position', [s_pos-2 4 4], 'EdgeColor', 'r', 'LineWidth', 2);

h_pos = ginput(1);
rectangle('Position', [h_pos-2 4 4], 'EdgeColor', 'g', 'LineWidth', 2);

h_esti_array = validation_for_calibration(s_pos, xml_file, res);
rec_esti = zeros(length(h_esti_array),2);
rec_esti = [h_esti_array rec_esti];
rec_esti(:,3) = 4;
rec_esti(:,4) = (150:1:220)';

for i = 1:length(rec_esti(1:10:end,:))
    rectangle('Position', [rec_esti(10*i-9,1:2)-2 4 4], 'EdgeColor', 'y', 'LineWidth', 1);    
end
text(rec_esti(1:10:end,1)+2, rec_esti(1:10:end,2)-2, int2str(rec_esti(1:10:end,4)), 'Color', 'y');

[error, min_index] = min(sum((h_esti_array - h_pos).^2, 2));
error = round(sqrt(error));
h_esti = rec_esti(min_index,4);
info_text = strcat('The height is estimated to be ',int2str(h_esti),'cm. The minimal error is ',int2str(error),'pixels');
text(10,res(2)-25,info_text, 'Color','w', 'BackgroundColor','r');