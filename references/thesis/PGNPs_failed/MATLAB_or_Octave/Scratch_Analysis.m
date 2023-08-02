clear all;
close all;
clc;

%input analysis parameter file
%{
Input File Format
scratchSeg \t xxx
pre-traceSeg \t xxx
post-traceSeg \t xxx 
%}

%store parameter values
[param_file, param_path] = uigetfile('*.txt');
pvals = dlmread(fullfile(param_path, param_file), '\t', 0, 1);
scratchSegNum = pvals(1);
preSegNum = pvals(2);
postSegNum = pvals(3);

[file, path] = uigetfile('*.txt', 'MultiSelect', 'on');
numFiles=size(file,2);
whileIndex = numFiles;

solMatrix = cell(numFiles+3, 2);

while whileIndex>0
 
 %Read specified csv
 fileNum = numFiles-whileIndex+1;
 data = dlmread(fullfile(path,file{1,fileNum}), '\t', 4, 0);
 %files must be opened and resaved in excel for blank rows to transfer
 segDiv = [];
 for i =1:size(data, 1)
   if data(i,10)==0
     segDiv = [segDiv i]; %#ok<AGROW>
   end
 end
 
 preStart = segDiv(preSegNum)+1;
 preEnd = segDiv(preSegNum+1)-1;
 scratchStart = segDiv(scratchSegNum)+1;
 scratchEnd = segDiv(scratchSegNum+1)-1;
 postStart = segDiv(postSegNum)+1;
 postEnd = segDiv(postSegNum+1)-1;
 %row indices for ranges of interest
 
 interpRange = data(scratchStart:scratchEnd, 3);
 
 preY = data(preStart:preEnd, 1);
 preX = data(preStart:preEnd, 3);
 [preUnique, preIndex] = unique(preX);
 preInterp = interp1(preUnique, preY(preIndex), interpRange);
 
 postY = data(postStart:postEnd, 1);
 postX = data(postStart:postEnd, 3);
 [postUnique, postIndex] = unique(postX);
 postInterp = interp1(postUnique, postY(postIndex), interpRange);
 %interpolate pre and post trace over range of scratch trace
 
 interpData = [interpRange preInterp data(scratchStart:scratchEnd, 1) postInterp];
 %collect data in one matrix
 
 interpData = [interpData interpData(:, 3)-interpData(:,2)]; 
 interpData = [interpData interpData(:, 4)-interpData(:,2)];
 %subtract pre-profile from scratch and post profiles
 %corrected scratch = row 5; corrected post = row 6
 
 interpData = [interpData (interpData(:,5)-interpData(:,6))./interpData(:,5)]; 
 %calculate recovery at each interpolated point
 
 plot(interpData(:,1),interpData(:,7))
 
 min = input('Start measurement at?');
 max = input('End measurement at?');
 
 i = 1;
 while (interpData(i,1) > max) && (i<size(interpData,1))
   i = i+1;
 end
 j = size(interpData,1);
 while (interpData(j,1) < min) && (j>1)
   j = j-i;
 end
 recovery = mean(interpData(i:j,7));
 solMatrix(fileNum+1,1)={fileNum};
 solMatrix(fileNum+1,2)={recovery};
 whileIndex=whileIndex-1;
end
solMatrix(numFiles+2,2)={mean(cell2mat(solMatrix(2:numFiles+1,2)))};
solMatrix(numFiles+3,2)={std(cell2mat(solMatrix(2:numFiles+1,2)))};
solMatrix(numFiles+2,1)={'Mean'};
solMatrix(numFiles+3,1)={'Std'};
solMatrix(1,1)=file(1,1);
solMatrix(1,2)={'Recovery (fraction)'}; 
solMatrix
 
 % Get the name of the file that the user wants to save.
startingFolder = userpath; % Or whatever folder you want.
defaultFileName = fullfile(startingFolder, '*.*');
[baseFileName, folder] = uiputfile(defaultFileName, 'Specify a file');
if baseFileName == 0
 % User clicked the Cancel button.
 return;
end
saveName = fullfile(folder, baseFileName);
xlswrite(saveName, solMatrix);
