%Program to Process Nanoindentation Data
%Clear variables & close open plots
clear all; %#ok<CLALL>
close all;
clc;

%input analysis parameter file
%{
Input File Format 
TAF c0 \t xxx (^2 usually fixed to 24.5 unless doing shallower indents)
TAF c1 \t xxx (^1)
TAF c2 \t xxx (^1/2)
TAF c3 \t xxx (^1/4)
TAF c4 \t xxx (^1/8)
TAF c5 \t xxx (^1/16)
Fit Start \t xxx (0-1) ex. 0.95 
Fit End \t xxx (0-1) ex 0.2 
Unload Rate (+uN/s) \t xxx 
*The second and third to last are fractions of the unloading depth 
*c3 - c5 left at zero for deep indents 
%}

%store parameter values
[param_file, param_path] = uigetfile('*.txt');
pvals = dlmread(fullfile(param_path, param_file), '\t', 0, 1);
c0 = pvals(1);
c1 = pvals(2);
c2 = pvals(3);
c3 = pvals(4);
c4 = pvals(5);
c5 = pvals(6);
topFit = pvals(7);
bottomFit = pvals(8);
unloadRate = pvals(9);

%Ask user to select files (nanoindentation csv)
[file2, path2] = uigetfile('*.txt', 'MultiSelect', 'on');

%will display relax and unload curves and power fits
f1 = figure('Name', 'Power Jump Relax Fit');
f3 = figure('Name', 'Power Jump Withdraw Fit');
axf1 = axes('Parent', f1);
axf3 = axes('Parent', f3);
%also display original curves for identifying problrms
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
 %If segment serperations persist, remove it
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
 plot(axf2, figx2, figy2, 'DisplayName', num2str(fileNum)); %plot hold step load vs time
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
errMatrix = cell(numFiles+3, 3); %contains quality of fit data
while whileIndex>0
 %Read specified csv
 fileNum = numFiles-whileIndex+1;
 data = dlmread(fullfile(path,file{1,fileNum}), '\t', 6, 0);
 %tab delimiter and 6 header lines in hysitron txt export
 %column indices: 1=depth (nm), 2=load (uN), and 3=time (s)
 %If segment separations persist, remove them
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
 
 %calculate time btw entries, used for data triming later
 tStep = data(17,3)-data(16,3);
 
 if fileNum == 1 
   hold(axf2, 'off'); %resent original data plot
 end
 
 figx2 = data(:,1);
 figy2 = data(:,2);
 plot(axf2, figx2, figy2, 'DisplayName', num2str(fileNum)); %plot hold step load vs time legend;
 hold(axf2, 'on');
 
 %Identify Creep Segment
 [maxVals, maxPoss] = max(data);
 holdLoad = round(maxVals(2),2); %determine load during creep (constant load) segment
 endTestValue = maxPoss(1); %find max depth row, initial guess for end of creep segment
 
 %adjust end of creep segment until load is 10 uN below hold value
 %avoids errors with drift near end of hold segment
 while (holdLoad-data(endTestValue,2)) < 10
   endTestValue = endTestValue + 1;
 end

 endRelaxR = endTestValue; %end of creep segment
 
 testValue = round(endRelaxR-5/tStep,1); %initial point to search for start of creep segment
 
 %from initial guess, step backward until load is 10uN below hold value
 while data(testValue,2) > holdLoad-10 || data(testValue-10,2) > holdLoad-10 
 testValue = testValue - 1; 
 end
 
 startRelaxR = testValue +1; %start of creep segment
 
 %extract time, depth, load of relax segment to new matrix
 relaxData = data(startRelaxR:endRelaxR, 1:3);
 
 fitStart = round(30/tStep)+1; %cutoff initial portion (30s) for fit purposes (relax seg 90s total)
 %might want to just fit last part to a line
 
 %Fit creep and get fit values
 c_initPre = 0.005; %initial guess at power law exponent
 b_initPre = relaxData(fitStart,3); %initial guess for b in pfit to time data
 d_initPre = relaxData(fitStart,1)-5;
 twindowPre = 10; %window in time for fitting b
 a_initPre = (relaxData(end,1)-d_initPre)/((relaxData(end,3)-b_initPre)^c_initPre); %initial guess for a in pfit to time data
 
 %Fit unload region with power fxn relative to time for jump method
 [jumpfitRelax, jfrerror,jfrout]=fit(relaxData(fitStart:end, 3), relaxData(fitStart:end,1), 'a*(x-b)^c+d', 
'StartPoint', [a_initPre, b_initPre, c_initPre, d_initPre],'MaxFunEvals', 6000, 'MaxIter', 1500, 'Lower', [0, b_initPre-twindowPre, 0, -d_initPre], 'Upper', 
[a_initPre*1000, relaxData(fitStart,3)-1, 0.3, 2*d_initPre],'TolFun', 10^(-17),'Robust','LAR'); 
 
 preJumpRate = differentiate(jumpfitRelax, relaxData(end,3)); %used for contact stiffness calculation
 
 figx = relaxData(:,3);
 figyPre = relaxData(:,1);
 plot(axf1, figx, figyPre); %plot hold step depth vs time (actual)
 hold(axf1, 'on');
 plot(axf1, relaxData(fitStart:end,3), jumpfitRelax(relaxData(fitStart:end,3))); %plot power fit
 
 %unload data starts where relaxation data ends
 testIndex = endRelaxR+1;
 
 %truncate data to portion with positive loads
 while data(testIndex, 2)>10
 testIndex = testIndex + 1;
 end
 
 %separate withdrawal segment data
 unloadData = data((endRelaxR+1):(testIndex-1), 1:3);

 figt = unloadData(:,3);
 figyO = unloadData(:, 1); %actual unload depth
 
 finish = round(size(unloadData,1)*(1-bottomFit)); % row index for fit (vertical percentage)
 start = round(size(unloadData,1)*(1-topFit)); %row index for fit (vertical percentage)
 
 dD = unloadData(1, 1); %depth for differentiation (E and H calcs)
 
 c_init = 0.33; %initial guess at power law exponent
 b_init = unloadData(end,3); %initial guess for b in pfit to time data
 twindow = 30; %window in time for fitting b
 a_init = unloadData(1,1)/((b_init-unloadData(1,3))^c_init); %initial guess for a in pfit to time data
 
 plot(axf3, figt, figyO); %plot withdraw load vs time
 hold(axf3, 'on');
 
 %Fit unload region with power fxn relative to time for jump method
 [jumpFitPostP, pjerror,pjout]=fit(unloadData(start:finish, 3), unloadData(start:finish,1), 'a*(b-x)^c', 
'StartPoint', [a_init, b_init, c_init], 'MaxFunEvals', 6000, 'MaxIter', 1500, 'Lower', [0, b_init-twindow, 0.1], 'Upper', [a_init*10, b_init+twindow, 1],'TolFun', 10^(-17),'Robust','LAR'); 
 
 plot(axf3, figt, jumpFitPostP(unloadData(:,3))); %plot fit for withdraw step
 
 postJumpRateP = differentiate(jumpFitPostP, unloadData(1, 3)); %differentiate power fit with respect to time
 
 SPJ = (0-unloadRate)/(postJumpRateP - preJumpRate); %contact stiffness from jump method
 Snorm = SPJ*(dD/unloadData(1,2)); %normalized contact stiffness to determine appropriate contact assumption
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
 errMatrix{fileNum+1,2}=pjerror.rsquare;
 errMatrix{fileNum+1,3}=pjerror.rmse;
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
%calculate fit data stdevs
errMatrix(numFiles+3,2)={std(cell2mat(errMatrix(2:numFiles,2)))};
errMatrix(numFiles+3,3)={std(cell2mat(errMatrix(2:numFiles,3)))};
 
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
errMatrix(1,2)={'Power Jump Fit R2'};
errMatrix(1,3)={'Power Jump Fit RMS'};
 
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
xlswrite(saveName, solMatrix);