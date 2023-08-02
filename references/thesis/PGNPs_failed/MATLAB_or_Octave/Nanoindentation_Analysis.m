%Program to Process Nanoindentation Data with Depth Controlled Indents
%Clear variables & close open plots
clear all; %#ok<CLALL>
close all;
clc;

%MANUALLY ENTER PARAMETER VALUES BELOW
%tip area function values
c0 = 24.5; %fixed
c1 = 824.7; 
c2 = 0; 
c3 = 0;
c4 = 0;
c5 = 0;
topFit = 0.95;% portion of data (vertical/load) to fit from unload segment
bottomFit = 0.20;
unloadRate = 50;%in nm/s, positive
indentDepth = 750; %in nm
relaxDelay = 10; %ignore this many initial sec of relaxation data for fit
relaxLength = 30; %total length in sec

%Ask user to select files (nanoindentation csv)
[file2, path2] = uigetfile('*.txt', 'MultiSelect', 'on');

%will display relax and unload curves and power fits
f1 = figure('Name', 'Power Jump Stress Relax Fit');
f3 = figure('Name', 'Power Jump Withdraw Fit');
axf1 = axes('Parent', f1);
axf3 = axes('Parent', f3);
%also display original curves for identifying problems
f2 = figure('Name', 'Indentation');
axf2 = axes('Parent', f2);
numFiles2=size(file2,2);
whileIndex2 = numFiles2;

while whileIndex2>0 %plot all curves to check data quality
 %Read specified csv
 fileNum = numFiles2-whileIndex2+1;
 data = dlmread(fullfile(path2,file2{1,fileNum}), '\t', 6, 0);
 %tab delimiter and 6 header lines in hysitron txt export
 %column indices: 1=depth (nm), 2=load (uN), and 3=time (s)
 %If segment separation persist, remove it
 %i.e. if file opened in excel
 segDiv = [];
 for i =1:size(data, 1)
 if data(i,3)==0 %blank row
 segDiv = [segDiv i]; %#ok<AGROW>
 end
 end
 
 for j = 1:size(segDiv,2)
 data(segDiv(j),:) = []; %remove blank rows
 end
 
 figx2 = data(:,1); 
 figy2 = data(:,2); 
 plot(axf2, figx2, figy2, 'DisplayName', num2str(fileNum)); %plot load vs depth for full file
 legend;
 hold(axf2, 'on');
 whileIndex2 = whileIndex2-1;
end
%Ask user to select files (nanoindentation csv)
%has opportunity to unselect any bad data
[file, path] = uigetfile('*.txt', 'MultiSelect', 'on');
numFiles=size(file,2);
whileIndex = numFiles;
solMatrix = cell(numFiles+3, 3); %contains modulus and hardness data
errMatrix = cell(numFiles+3, 5); %contains quality of fit data
while whileIndex>0
 %Read specified csv
 fileNum = numFiles-whileIndex+1;
 data = dlmread(fullfile(path,file{1,fileNum}), '\t', 6, 0);
 %tab delimiter and 6 header lines in Hysitron txt export
 %column indices: 1=depth (nm), 2=load (uN), and 3=time (s)
 %If segment separation persist, remove it
 %i.e. if file opened in excel
 segDiv = [];
 for i =1:size(data, 1)
 if data(i,3)==0
 segDiv = [segDiv i]; %#ok<AGROW>
 end
 end
 
 for j = 1:size(segDiv,2)
 data(segDiv(j),:) = []; 
 end
 
 %calculate time btw entries, used for data trimming later
 tStep = data(17,3)-data(16,3);
 
 if fileNum == 1 
 hold(axf2, 'off'); %reset original data plot
 end
 
 figx2 = data(:,1);
 figy2 = data(:,2);
 plot(axf2, figx2, figy2, 'DisplayName', num2str(fileNum)); %plot load vs depth
 legend;
 hold(axf2, 'on');
 
 %Identify Relaxation Segment
 [maxVals, maxPoss] = max(data);
 
 startRelaxR = maxPoss(2); %find max load row, use position for start of relax segment
 endRelaxR = startRelaxR + round(relaxLength/tStep) -1; %initial end of relax segment based on 
segment length
 
 testDepth = data(endRelaxR,1); 
 while testDepth > (indentDepth-0.1) %increase position until at least 0.1 nm below target depth
 endRelaxR = endRelaxR + 1;
 testDepth = data(endRelaxR, 1);
 end
 
 
 %extract time, depth, load of relax segment to new matrix
 relaxData = data(startRelaxR:endRelaxR, 1:3); 
 
 fitStart = round(relaxDelay/tStep)+1; %cutoff initial portion for fit purposes (relax seg 30s total)
 fitEnd = round(size(relaxData,1)*0.99);
 
 %Fit relaxation and get fit values
 c_initPre = 2; %initial guess at power law exponent
 b_initPre = relaxData(end,3); %initial guess for b in pfit to time data (time at end of relax seg)
 d_initPre = relaxData(end,2); %initial guess at d for pfit (load at end of relax seg)
 twindowPre = 20; %window in time for fitting b
 a_initPre = (relaxData(1,2)-d_initPre)/((b_initPre-relaxData(1,3))^c_initPre); %initial guess for a in 
pfit to time data calculated from other initial parameters at start of fit window
 %a must be positive, shouldn't be an issue
 if a_initPre < 0
 a_initPre = 0.001;
 end
 
 %Fit relax segment with power fxn relative (load vs time) for jump method
 [jumpfitRelax, jfrerror,jfrout]=fit(relaxData(fitStart:fitEnd, 3), relaxData(fitStart:fitEnd,2), 'a*(bx)^c+d', 'StartPoint', [a_initPre, b_initPre, c_initPre, d_initPre],...
 'MaxFunEvals', 6000, 'MaxIter', 1500, 'Lower', [0, b_initPre, 1, 0], 'Upper', [a_initPre*10, 
b_initPre+twindowPre, 4, 2*d_initPre]...
 ,'TolFun', 10^(-10),'Robust','LAR'); 
 
 preJumpRate = differentiate(jumpfitRelax, relaxData(end,3)); %used for contact stiffness calculation
 
 figx = relaxData(:,3);
 figyPre = relaxData(:,2);
 plot(axf1, figx, figyPre); %plot relax segment load vs time (actual)
 hold(axf1, 'on');
 plot(axf1, relaxData(fitStart:end,3), jumpfitRelax(relaxData(fitStart:end,3))); %plot power fit over fit 
region
 
 %unload data starts where relaxation data ends
 testIndex = endRelaxR+1;
 
 %truncate data to portion with positive loads
 while data(testIndex, 2)>0
 testIndex = testIndex + 1;
 end
 
 %separate withdrawal segment data
 unloadData = data((endRelaxR+1):(testIndex-1), 1:3);
 
 figt = unloadData(:,3); %unload time
 figyO = unloadData(:, 2); %unload load
 
 %trim fit region to selected portion vertically (proportion of load at start of unload)
 unloadStart = topFit*unloadData(1,2); %upper load limit for fit
 unloadFinish = bottomFit*unloadData(1,2); %lower load limit for fit
 
 %find indices within upper and lower limit
 startIndex = 1;
 while unloadData(startIndex,2)>unloadStart
 startIndex = startIndex + 1;
 end
 
 finishIndex = startIndex;
 while unloadData(finishIndex, 2)>unloadFinish
 finishIndex = finishIndex + 1;
 end
 
 start = startIndex;
 finish = finishIndex-1; 
 
 dD = unloadData(1, 1); %depth for differentiation (E and H calcs)
 
 c_init = 2; %initial guess at power law exponent
 b_init = unloadData(end,3); %initial guess for b is time when unload to zero
 twindow = 10; %window in time for fitting b
 a_init = unloadData(1,2)/((b_init-unloadData(1,3))^c_init); %calculate initial guess for a from other 
parameters
 %d fixed to zero (load goes to zero)
 
 plot(axf3, figt, figyO); %plot withdraw load vs time
 hold(axf3, 'on');
 
 %Fit unload region with power fxn relative to time for jump method
 [jumpFitPostP, pjerror,pjout]=fit(unloadData(start:finish, 3), unloadData(start:finish,2), 'a*(b-x)^c', 
'StartPoint', [a_init, b_init, c_init],...
 'MaxFunEvals', 6000, 'MaxIter', 1500, 'Lower', [0, b_init-twindow, 1], 'Upper', [a_init*10, 
b_init+twindow, 4]...
 ,'TolFun', 10^(-10),'Robust','LAR'); 
 
 plot(axf3, unloadData(1:finish,3), jumpFitPostP(unloadData(1:finish,3))); %plot fit for withdraw step 
for fit region
 
 postJumpRateP = differentiate(jumpFitPostP, unloadData(1, 3)); %differentiate power fit with respect 
to time
 
 SPJ = (postJumpRateP - preJumpRate)/(0-unloadRate); %contact stiffness from jump method
 Snorm = SPJ*(dD/unloadData(1,2)); %normalized contact stiffness to determine appropriate contact 
assumption
 if Snorm < 2.25 %elastic contact
 alpha = 1; %technically 1.05 for berk
 eps = 0.75; %assumes reasonable value of power fit exponent (1.5-2)
 else %elastic perfectly-plastic contact w/ 'pileup'
 alpha = 1.2;
 eps = 1;
 disp('Plastic Contact');
 end
 
 hDcPJ = alpha*dD*(1-eps/Snorm); %corrected contact depth using jump method
 
 %calculate contact area using corrected depth
 derivAreaPJ = c0*hDcPJ^2 + c1*hDcPJ + c2*hDcPJ^0.5...
 +c3*hDcPJ^0.25+c4*hDcPJ^0.125+c5*hDcPJ^0.0625;
 
 ErPJ=((3.14159)^0.5)/2*SPJ/(derivAreaPJ^0.5)*1000; %GPa reduced modulus power fit, jump method
 HPJ = unloadData(1,2)/derivAreaPJ*10^6; %MPa hardness from power fit, jump method
 
 %enter results into the solution matrix
 solMatrix(fileNum+1,1)={fileNum};
 solMatrix(fileNum+1,2)={ErPJ};
 solMatrix(fileNum+1,3)={HPJ};
 %enter fit data into error matrix
 errMatrix(fileNum+1,1)={fileNum};
 errMatrix{fileNum+1,2}=jfrerror.rsquare; %error from relax step
 errMatrix{fileNum+1,3}=jfrerror.rmse;
 errMatrix{fileNum+1,4}=pjerror.rsquare; %error from unload step
 errMatrix{fileNum+1,5}=pjerror.rmse;
 whileIndex=whileIndex-1; %increment to next file
end
%calculate solution averages
solMatrix(numFiles+2,2)={mean(cell2mat(solMatrix(2:numFiles+1,2)))};
solMatrix(numFiles+2,3)={mean(cell2mat(solMatrix(2:numFiles+1,3)))};
%calculate solution stdevs
solMatrix(numFiles+3,2)={std(cell2mat(solMatrix(2:numFiles+1,2)))};
solMatrix(numFiles+3,3)={std(cell2mat(solMatrix(2:numFiles+1,3)))};
%calculate fit data averages
errMatrix(numFiles+2,2)={mean(cell2mat(errMatrix(2:numFiles+1,2)))};
errMatrix(numFiles+2,3)={mean(cell2mat(errMatrix(2:numFiles+1,3)))};
errMatrix(numFiles+2,4)={mean(cell2mat(errMatrix(2:numFiles+1,4)))};
errMatrix(numFiles+2,5)={mean(cell2mat(errMatrix(2:numFiles+1,5)))};
%calculate fit data stdevs
errMatrix(numFiles+3,2)={std(cell2mat(errMatrix(2:numFiles,2)))};
errMatrix(numFiles+3,3)={std(cell2mat(errMatrix(2:numFiles,3)))};
errMatrix(numFiles+3,4)={std(cell2mat(errMatrix(2:numFiles,4)))};
errMatrix(numFiles+3,5)={std(cell2mat(errMatrix(2:numFiles,5)))};
 
%add header to solution data
solMatrix(numFiles+2,1)={'Mean'};
solMatrix(numFiles+3,1)={'Std'};
solMatrix(1,1)=file(1,1);
solMatrix(1,2)={'Power Jump Fit Er (GPa)'};
solMatrix(1,3)={'Power Jump Fit H (MPa)'};
%add header to fit data
errMatrix(numFiles+2,1)={'Mean'};
errMatrix(numFiles+3,1)={'Std'};
errMatrix(1,1)=file(1,1);
errMatrix(1,2)={'Relax Seg Fit R2'};
errMatrix(1,3)={'Relax Seg Fit RMS'};
errMatrix(1,4)={'Unload Seg Fit R2'};
errMatrix(1,5)={'Unload Seg Fit RMS'};
 
solMatrix %#ok<NOPTS> %display results
errMatrix %#ok<NOPTS>
beep on
beep
% Get the name of the file that the user wants to save.
startingFolder = userpath; % Or whatever folder you want.
defaultFileName = fullfile(startingFolder, '*.*');
[baseFileName, folder] = uiputfile(defaultFileName, 'Specify a file');
if baseFileName == 0
 % User clicked the Cancel button.
 return;
end
saveName = fullfile(folder, baseFileName);
xlswrite(saveName, cat(2,solMatrix, errMatrix));
