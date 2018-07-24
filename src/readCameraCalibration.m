%only read the SaveResearch Calibration file
%does not include calculation of P, KR, H, ...
function [calibration] = readCameraCalibration(filename)

xmlDoc = parseXML(filename);
%read values from camera_pose.xml file
calibration.tiltAngle = str2num(findXMLTag(xmlDoc,'tiltAngle'));
calibration.rollAngle = str2num(findXMLTag(xmlDoc,'rollAngle'));
calibration.panAngle =  str2num(findXMLTag(xmlDoc,'panAngle'));
calibration.elevation = str2num(findXMLTag(xmlDoc,'elevation'));
calibration.scaleX = str2num(findXMLTag(xmlDoc,'scaleX'));
calibration.scaleY = str2num(findXMLTag(xmlDoc,'scaleY'));

radK1 = findXMLTag(xmlDoc,'radialDistortionK1');
if isempty(radK1)
    calibration.radialDistortionK1 = 0;
else
    calibration.radialDistortionK1 = str2num(radK1);
end

radK2 = findXMLTag(xmlDoc,'radialDistortionK2');
if isempty(radK2)
    calibration.radialDistortionK2 = 0;
else
    calibration.radialDistortionK2 = str2num(radK2);
end

if  calibration.radialDistortionK2 == 0 &&  calibration.radialDistortionK1 == 0
     calibration.useRadialDistortion = false;
else
     calibration.useRadialDistortion = true;
end

calibration.focalLengthXPixel = calibration.scaleX;
calibration.focalLengthYPixel = calibration.scaleY;


function data = findXMLTag(xmlFile,tag) 
data = [];
 %disp(strcat('Check node = ',xmlFile.Name));
if ~strcmp(xmlFile.Name,tag)
    for ichild = 1:length(xmlFile.Children)
        %disp(strcat('Recursive call child node = ',xmlFile.Children(ichild).Name));
        data2 = findXMLTag(xmlFile.Children(ichild),tag);
        if ~isempty(data2)
           data = data2; 
        end
    end
else
    %disp(strcat('---> Node found(',xmlFile.Name,')'));
    data = xmlFile.Children.Data;
end

if ~exist('data')
    data = [];
end
    
    
%The following codes can be found in Matlab built-in help docs



function theStruct = parseXML(filename)
% PARSEXML Convert XML file to a MATLAB structure.
try
   tree = xmlread(filename);
catch
   error('Failed to read XML file %s.',filename);
end

% Recurse over child nodes. This could run into problems 
% with very deeply nested trees.
try
   theStruct = parseChildNodes(tree);
catch
   error('Unable to parse XML file %s.',filename);
end




function children = parseChildNodes(theNode)
% Recurse over node children.
children = [];
if theNode.hasChildNodes
   childNodes = theNode.getChildNodes;
   numChildNodes = childNodes.getLength;
   allocCell = cell(1, numChildNodes);

   children = struct(             ...
      'Name', allocCell, 'Attributes', allocCell,    ...
      'Data', allocCell, 'Children', allocCell);

    for count = 1:numChildNodes
        theChild = childNodes.item(count-1);
        children(count) = makeStructFromNode(theChild);
    end
end


% ----- Subfunction MAKESTRUCTFROMNODE -----
function nodeStruct = makeStructFromNode(theNode)
% Create structure of node info.

nodeStruct = struct(                        ...
   'Name', char(theNode.getNodeName),       ...
   'Attributes', parseAttributes(theNode),  ...
   'Data', '',                              ...
   'Children', parseChildNodes(theNode));

if any(strcmp(methods(theNode), 'getData'))
   nodeStruct.Data = char(theNode.getData); 
else
   nodeStruct.Data = '';
end

% ----- Subfunction PARSEATTRIBUTES -----
function attributes = parseAttributes(theNode)
% Create attributes structure.

attributes = [];
if theNode.hasAttributes
   theAttributes = theNode.getAttributes;
   numAttributes = theAttributes.getLength;
   allocCell = cell(1, numAttributes);
   attributes = struct('Name', allocCell, 'Value', ...
                       allocCell);

   for count = 1:numAttributes
      attrib = theAttributes.item(count-1);
      attributes(count).Name = char(attrib.getName);
      attributes(count).Value = char(attrib.getValue);
   end
end