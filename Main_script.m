%% Main script

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   LOADING THE DATA   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loading the data locally
dataFolder = fullfile('C:/Users/gina/Seafile/Cognitive_Science/Bachelor_Thesis/AAB/Behavioral_Data/Experiment_2/Task_F_for_unfold');  

% Loading the data matlabdrive
% dataFolder = matlabdrive;

rtFile   = fullfile(dataFolder,'behavioralReactionTime.mat');                % contains variable "reactionTime"
sideFile = fullfile(dataFolder,'side.mat');                                  % contains variable "side"
frameOnsetLatFile = fullfile(dataFolder,'frameOnsetLatency.mat');            % contains variable "frameOnsetLatency"
latencyFirstFixFile = fullfile(dataFolder,'latencyFirstFixation.mat');       % contains variable "timeFirstFixation"
reactionFile = fullfile(dataFolder,'reactionType.mat');                      % contains variable "actualReaction"
valenceFile = fullfile(dataFolder,'valence.mat');                            % contains variable "valence"
picOnsetFile = fullfile(dataFolder,'pictureOnsetIdx.mat');                   % contains variable "pictureOnsetTimesIndex"
fixCrossOnsetFile = fullfile(dataFolder,'fixationCrossIdx.mat');             % contains variable "fixationCrossTimesIndex"
blockOrderFile = fullfile(dataFolder,'blockOrder.mat');                      % contains variable "blockOrder"
picSequenceFile = fullfile(dataFolder,'pictureSequence.mat');                % contains variable "pictureSequence"
pupilSizeFile = fullfile(dataFolder,'pupilSize.mat');                        % contains variables "pupilSizeLeft" and "pupilSizeRight"
startTaskFile = fullfile(dataFolder,'startTaskIdx.mat');                     % contains variable "startTimeIndex"
startValidTrialsFile = fullfile(dataFolder,'startValidTrialsIdx.mat');       % contains variable "validTrialsStartIndex"
timelineFile = fullfile(dataFolder,'timeVector.mat');                        % contains variable "timeVector"
saccadeOnsetFile = fullfile(dataFolder,'saccadeStartLatency.mat');           % contains variable "saccadeStartTime"
saccadeOffsetFile = fullfile(dataFolder,'saccadeEndLatency.mat');            % contains variable "saccadeEndTime"
noSaccadeMaskFile = fullfile(dataFolder,'noSaccadeMask.mat');                % contains variable "noSaccadeMask"
sacDur0MaskFile = fullfile(dataFolder,'saccadeDuration0Mask.mat');           % contains variable "sacDur0Mask"
%pupilSizeRightFiltFile = fullfile(dataFolder,'pupilSizeRightFilt.mat');  % contains variables "pupilSizeRightFilt"

fprintf('Loading files …\n');

tmp = load(rtFile,'reactionTime');   % tmp.reactionTime is a struct field
reactionTime = tmp.reactionTime;     % now a plain matrix
tmp = load(sideFile,'side'); 
side = tmp.side; 
tmp = load(frameOnsetLatFile,'frameOnsetLatency');
frameOnsetLatency = tmp.frameOnsetLatency;
tmp = load(latencyFirstFixFile,'timeFirstFixation');
timeFirstFixation = tmp.timeFirstFixation;
tmp = load(reactionFile,'actualReaction');
actualReaction = tmp.actualReaction;
tmp = load(valenceFile,'valence');
valence = tmp.valence;
tmp = load(picOnsetFile,'pictureOnsetTimesIndex');
pictureOnsetTimesIndex = tmp.pictureOnsetTimesIndex;
tmp = load (fixCrossOnsetFile, 'fixationCrossTimesIndex');
fixationCrossTimesIndex = tmp.fixationCrossTimesIndex;
tmp = load(blockOrderFile,'blockOrder');
blockOrder = tmp.blockOrder;
tmp = load(picSequenceFile, 'pictureSequence');
pictureSequence = tmp.pictureSequence;
tmp = load(pupilSizeFile,'pupilSizeLeft','pupilSizeRight');
pupilSizeLeft = tmp.pupilSizeLeft;
pupilSizeRight = tmp.pupilSizeRight;
tmp = load(startTaskFile,'startTimeIndex');
startTimeIndex = tmp.startTimeIndex;
tmp = load(startValidTrialsFile,'validTrialsStartIndex');
validTrialsStartIndex = tmp.validTrialsStartIndex;
tmp = load(timelineFile,'timeVector');
timeVector = tmp.timeVector;
tmp = load(saccadeOnsetFile,'saccadeStartTime');
saccadeOnset = tmp.saccadeStartTime;
tmp = load(saccadeOffsetFile,'saccadeEndTime');
saccadeOffset = tmp.saccadeEndTime;
tmp = load(noSaccadeMaskFile, 'noSaccadeMask');
maskNoSaccade = tmp.noSaccadeMask;
tmp = load(sacDur0MaskFile, 'sacDur0Mask');
maskSacDur0 = tmp.sacDur0Mask;
% tmp = load(pupilSizeRightFiltFile, 'pupilSizeRightFilt');
% pupilSizeRightFilt = tmp.pupilSizeRightFilt;

clear tmp;

% Clearing all files from workspace
files = {'dataFolder','rtFile','sideFile','frameOnsetLatFile','latencyFirstFixFile', ...
    'reactionFile','valenceFile','picOnsetFile','fixCrossOnsetFile','blockOrderFile', ...
    'picSequenceFile','pupilSizeFile','startTaskFile','startValidTrialsFile', ...
    'timelineFile','saccadeOnsetFile','saccadeOffsetFile','noSaccadeMaskFile',...
    'sacDur0MaskFile','pupilSizeRightFiltFile'};
clear(files{:});
clear files;

fprintf('All files loaded.\n');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   Participant and Trial Exclusion  + Cleanup of Saccades  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Removing columns
% Removing column 144 because it is an extreme outlier - for the last 20
% trials, the person kept their eyes almost completly shut.
% Removing column 143 as well, because it is from the same person 
% -> to have the same amount of data for each person
% Removing the participant from session 127 and 128, because they had to
% little valid trials (session 127 - 27 valid trials, session 128 - 9 valid
% trials)

colsToDelete_1 = [127,128, 143, 144];
colsToDelete_2 = [127,128];
nSessions = 142;                               % variabel storing the new number of sessions, to be used globally
actualReaction(:,colsToDelete_1) = [];
blockOrder(:,colsToDelete_1) = [];
fixationCrossTimesIndex(:,colsToDelete_1) = [];
frameOnsetLatency(:,colsToDelete_1) = [];
pictureOnsetTimesIndex(:,colsToDelete_1) = [];
pictureSequence(:, :, colsToDelete_1) = [];      % 88x2x146 --> 88x2x142 (3 dimensional matrix)
pupilSizeLeft(:,colsToDelete_1) = [];
pupilSizeRight(:,colsToDelete_1) = [];
reactionTime(:,colsToDelete_1) = [];
saccadeOnset(:,colsToDelete_1) = [];
saccadeOffset(:,colsToDelete_1) = [];
side(:,colsToDelete_1) = [];
startTimeIndex(:,colsToDelete_1) = [];
timeFirstFixation(:,colsToDelete_1) = [];
timeVector(:,colsToDelete_1) = [];
valence(:,colsToDelete_1) = [];
validTrialsStartIndex(colsToDelete_1,:) = [];    % 146x2 --> 142x2 (here the sessions are stored in the rows)
% The two following variables were with size 88x144 (therefore after
% coloumn 143 and 144 were removed. Therefore only coloumn 127 and 128 need
% to be removed from them
maskNoSaccade(:,colsToDelete_2) = [];
maskSacDur0(:,colsToDelete_2) = [];

clear('colsToDelete_1','colsToDelete_2');

fprintf('Column 127 & 128 and 143 & 144 succesfully removed from all variables.\n');

%% Removing test trials from pictureOnsetTimesIndex (cell) and fixationCrossTimesIndex (cell)
% Trial 1-5   = test trials
% Trial 6-49  = first trial block
% Trial 50-54 = test trials
% Trial 55-98 = second trial block

% Changing the cell structure to a matrix --> new variable
picOnsetTimesIdxMat = cell2mat(pictureOnsetTimesIndex.');       % transpose to get a column of cells -> 144x98 double
picOnsetTimesIdxMat = picOnsetTimesIdxMat.';                    % transpose again to get 98x144 double
fixationCrossTimesIdxMat = cell2mat(fixationCrossTimesIndex.');
fixationCrossTimesIdxMat = fixationCrossTimesIdxMat.';

% Removing test trials
keepRows = [6:49 55:98];
picOnsetTimesIdxMat = picOnsetTimesIdxMat(keepRows , :);
fixationCrossTimesIdxMat = fixationCrossTimesIdxMat(keepRows,:);
clear keepRows;

assert(isequal(size(picOnsetTimesIdxMat),size(fixationCrossTimesIdxMat), [88 nSessions]), 'Removing failed');

fprintf('Test trials successfully removed from picOnsetTimesIdxMat and fixationCrossTimesIdxMat.\n');


%% Remove duplicate rows in saccadeOnset and saccadeOffset
% In the original data two adjacent rows are often storing similar values. 
% An explanation for that are glissade eye movements.
% To reduce redundent data, only completly different rows are kept.
% (Always keep first row, only keep second row if all data is different
% from first row)

function [onOut, offOut] = removeSimilarSaccadeRows(onIn, offIn)
% Remove similar saccade rows
%
%   [onOut,offOut] = removeSimilarSaccadeRows(onIn,offIn)
%
%   INPUT
%       onIn  – 1×Ncell cell array, each cell = column vector of saccade‐onset
%       offIn – 1×Ncell cell array, each cell = column vector of saccade‐offset
%                (both cell arrays have the same size, same length per cell)
%
%   OUTPUT
%       onOut  – same layout as onIn, but rows who are 'similar' are removed
%       offOut – matching offsets (same indexing as onOut)
%
%   WHAT IT DOES
%       • The data is already sorted --> identical pairs are always adjacent.
%       • The first row of each session is always kept.
%       • The next row is kept only if BOTH the onset AND the offset
%         differ from the previous row.
%       • This removes similar rows:
%           – exact duplicate rows
%           – rows that only share the onset
%           – rows that only share the offset
%       • The function returns cleaned column vectors in new cell arrays
%         (the original cell arrays are left untouched).
%

    % sanity check
    assert(iscell(onIn) && iscell(offIn), 'Both inputs must be cell arrays.')
    assert(numel(onIn)==numel(offIn), 'Cell arrays must have the same number of sessions.')

    nSess = numel(onIn);               % 144

    % pre‑allocate output cells (same size as input)
    onOut  = cell(1,nSess);
    offOut = cell(1,nSess);

    for sess = 1:nSess                 % loop over sessions 
        onVec  = onIn{sess}(:);        % create column vector
        offVec = offIn{sess}(:);

        % Check for empty cells 
        if isempty(onVec)              % both vectors are empty (they have equal length)
            onOut{sess}  = [];
            offOut{sess} = [];
            continue;                  % end this loop
        end

        % Logical index of rows to keep (mask).
        % 1) Keep always the first row. 
        % 2) Keep the following row only, when BOTH onset and offset differ
        keep = [true; diff(onVec)~=0 & diff(offVec)~=0];

        % Storing of the cleaned vectors 
        onOut{sess}  = onVec(keep);
        offOut{sess} = offVec(keep);
    end
end

% Appling function
[cleanSaccadeOnset, cleanSaccadeOffset] = removeSimilarSaccadeRows(saccadeOnset, saccadeOffset);

fprintf('Only unique rows saved for saccadeOnset and saccadeOffset.\n');


%% Unify times - changing all into seconds(s)
% frameOnsetLatency and timeFirstFixation are in ms, reactionTime is in s
format short

timeFirstFixationS = timeFirstFixation/1000; % from ms into s
frameOnsetLatencyS = frameOnsetLatency/1000; 

timeFirstFixationS = round(timeFirstFixationS,3);
frameOnsetLatencyS = round(frameOnsetLatencyS,3);
reactionTimeS = round(reactionTime,3);

fprintf('All times are changed into seconds.\n');

%% Unify times - changing all into milliseconds(ms)
% frameOnsetLatency and timeFirstFixation are in ms, reactionTime is in s
format short

reactionTimeMS = reactionTime*1000; % from s into ms

timeFirstFixationMS = round(timeFirstFixation,3);
frameOnsetLatencyMS = round(frameOnsetLatency,3);
reactionTimeMS = round(reactionTimeMS,3);

fprintf('All times are changed into milliseconds.\n');

%% Correct reaction matrix
% Correct reaction for each condition:
% - Congruent   block & negative valence --> push
% - Congruent   block & positive valence --> pull
% - Incongruent block & negative valence --> pull
% - Incongruent block & positive valence --> push
% blockOrder: A = Congruent (44 trials) → Incongruent (44 trials); B = Incongruent (44 trials) → Congruent (44 trials)
% valence: 0 = negative picture valence, 1 = positive picture valence

nRowsPerCond = 44;                % 44 Congruent + 44 Incongruent or 44 Inongruent + 44 Congruent= 88 rows
nRowsTotal   = 2 * nRowsPerCond;  % = 88
nCols        = nSessions;         % should be 144
correctReaction = strings(nRowsTotal, nCols); 

for col = 1:nCols                                   % 1:144
    if blockOrder(col) == "A"                       % BlockOrder A: Congruent --> Incongruent
        for row = 1:nRowsPerCond                    % 1:44, Congruent
            if valence(row,col) == 0                % negative
                correctReaction(row,col) = "push";
            else                                    % positive
                correctReaction(row,col) = "pull";
            end
        end
        for row = (nRowsPerCond+1):nRowsTotal       % 45:88, Incongruent
            if valence(row,col) == 0                % negative
                correctReaction(row,col) = "pull";
            else                                    % positive
                correctReaction(row,col) = "push";
            end
        end
    else                                            % BlockOrder B: Incongruent --> Congruent
        for row = 1:nRowsPerCond                    % 1:44, Incongruent
            if valence(row,col) == 0                % negative
                correctReaction(row,col) = "pull";
            else                                    % positive
                correctReaction(row,col) = "push";
            end
        end
        for row = (nRowsPerCond+1):nRowsTotal       % 45:88, Congruent
            if valence(row,col) == 0                % negative
                correctReaction(row,col) = "push";
            else                                    % positive
                correctReaction(row,col) = "pull";
            end
        end
    end
end

clear('nRowsTotal','nRowsPerCond','nCols','col','row')

fprintf('correctReaction matrix constructed.\n');

%% Removing trials
% 1) the frame did not appear
% 2) the reactionTime was <150ms
% 3) the time first fixation <100ms
% 4) 2SD bigger than the mean of time first fixation
% 5) 2SD bigger than the mean of frame onset latency --> participant had too much time to look at both pictures
% 6) trials with incorrect reaction
% 7) trials with no Saccade detected between PictureOnset and FirstFixation (filtered out in the code below, and stored as a file to be used here)
% 8) trials with a frame deciding saccade duration of 0ms (filtered out in the code below, and stored as a file to be used here)

% Information about trials, where the frame did not appear, are in these files:
% - behavioralReactionTime.mat (array: reactionTime): NaN trials - frame did not appear
% - side.mat (array: side): NaN trials - frame did not appear
% - frameOnsetLatency.mat (array: frameOnsetLatency): NaN trials - frame did not appear?
% - latencyFirstFixation.mat (array: timeFirstFixation): Nan trials - no first fixation was detected --> no frame could appear?

% Quick sanity check – the matrices must be the same size.
if ~isequal(size(reactionTime),size(side), size(frameOnsetLatency), size(timeFirstFixation), size(actualReaction), size(valence))    % ~ is logical NOT operat or --> if the size is not equal, than stop and error message
    error('At least one matrix does not have the same dimensions.');
end

fprintf('Relevant matrices for removing trials loaded. Size = %s\n',mat2str(size(reactionTime)));

% % Uncomment, if you only want to see the results for the testSess.
% % Also uncomment in all 8) steps the one session parts and comment the
% % all session parts out
% testSess = 127;

% 1) The frame did not appear
% NaN trials - Building a logical mask 
% "isnan" returns a logical matrix of the same size:
%   true/1   → the entry is NaN
%   false/0  → the entry is a numeric value
% All sessions:
maskNaNRT = isnan(reactionTime);   % true where RT is NaN
fprintf('Found in maskRT %d NaN entries out of %d total (%.2f%%).\n', ...
        nnz(maskNaNRT), numel(maskNaNRT), 100*nnz(maskNaNRT)/numel(maskNaNRT));
n_removed_NaNRT = nnz(maskNaNRT);
% % Uncomment, if you only want to see the results for one session:
% maskNaNRT_1sess = isnan(reactionTime(:,testSess));   % true where RT is NaN
% fprintf('Found in maskRT %d NaN entries out of %d total (%.2f%%).\n', ...
%         nnz(maskNaNRT_1sess), numel(maskNaNRT_1sess), 100*nnz(maskNaNRT_1sess)/numel(maskNaNRT_1sess));
% n_removed_NaNRT = nnz(maskNaNRT_1sess);

% maskSide = isnan(side);           % true where side is NaN
% fprintf('Found in maskSide %d NaN entries out of %d total (%.2f%%).\n', ...
%         nnz(maskSide), numel(maskSide), 100*nnz(maskSide)/numel(maskSide));
% 
% maskFrameOnset   = isnan(frameOnsetLatency);   % true where frameOnsetLatency is NaN
% fprintf('Found in maskFrameOnset %d NaN entries out of %d total (%.2f%%).\n', ...
%         nnz(maskFrameOnset), numel(maskFrameOnset), 100*nnz(maskFrameOnset)/numel(maskFrameOnset));
% 
% maskFirstFix = isnan(timeFirstFixation);           % true where timeFirstFixation is NaN
% fprintf('Found in maskFirstFix %d NaN entries out of %d total (%.2f%%).\n', ...
%         nnz(maskFirstFix), numel(maskFirstFix), 100*nnz(maskFirstFix)/numel(maskFirstFix));
% 
% 
% nanMask = maskRT | maskSide | maskFrameOnset | maskFirstFix;      % logical OR – element‑wise --> trial is considered baf if ANY of the two sources is NaN
% 
% % How many entries are affected? (purely informative)
% fprintf('Found all in all %d NaN entries out of %d total (%.2f%%).\n', ...
%         nnz(nanMask), numel(nanMask), 100*nnz(nanMask)/numel(nanMask));

% Realisation: All affected entries are in reactionTime! 
% 514 NaN entries % out of 12848 total entries (4.00%)


% 2) The reactionTime was <150ms
% RT150 - Building a logical mask 
%   true/1   → the entry is <0.150
%   false/0  → the entry is >=0.150
% All sessions:
maskRT150 = reactionTimeMS < 150;    % reactionTime is in ms
n_removed_RT150 = nnz(maskRT150);
% % Uncomment, if you only want to see the results for one session:
% maskRT150_1sess = reactionTimeMS(:,testSess) < 150;    % reactionTime is in ms
% n_removed_RT150 = nnz(maskRT150_1sess);

% 3) The time first fixation was <100ms
% firstFix - Building a logical mask
%   true/1   → the entry is <0.100
%   false/0  → the entry is >=0.100
% All sessions:
maskFirstFix100 = timeFirstFixationMS < 100; % timeFirstFixation is in ms
n_removed_firstFix100 = nnz(maskFirstFix100);
% % Uncomment, if you only want to see the results for one session:
% maskFirstFix100_1sess = timeFirstFixationMS(:,testSess) < 100; % timeFirstFixation is in ms
% n_removed_firstFix100 = nnz(maskFirstFix100_1sess);


% 4) 2SD bigger than the mean of time first fixation
% All sessions:
timeFirstFixationMS(maskFirstFix100) = NaN;                 % apply mask from 3) to calculate the std with the credible values
mean_FirstFix2SD = mean(timeFirstFixationMS(:), "omitnan");
std_FirstFix2SD  = std(timeFirstFixationMS(:), "omitnan");
mask_FirstFix2SD = timeFirstFixationMS > (mean_FirstFix2SD+(2*std_FirstFix2SD));
n_removed_firstFix2SD = nnz(mask_FirstFix2SD);
% % Uncomment, if you only want to see the results for one session:
% timeFirstFixationMS = timeFirstFixationMS(:,testSess);
% timeFirstFixationMS(maskFirstFix100_1sess) = NaN;                 % apply mask from 3) to calculate the std with the credible values
% mean_FirstFix2SD = mean(timeFirstFixationMS, "omitnan");
% std_FirstFix2SD  = std(timeFirstFixationMS, "omitnan");
% mask_FirstFix2SD_1sess = timeFirstFixationMS > (mean_FirstFix2SD+(2*std_FirstFix2SD));
% n_removed_firstFix2SD = nnz(mask_FirstFix2SD_1sess);

% 5) 2SD bigger than the mean of frame onset latency  --> participant had too much time to look at both pictures
% All sessions:
mean_FrameOnset2SD = mean(frameOnsetLatencyMS(:), "omitnan");
std_FrameOnset2SD = std(frameOnsetLatencyMS(:), "omitnan");
mask_FrameOnset2SD = frameOnsetLatencyMS > (mean_FrameOnset2SD+(2*std_FrameOnset2SD));
n_removed_FrameOnset2SD = nnz(mask_FrameOnset2SD);
% % Uncomment, if you only want to see the results for one session:
% mean_FrameOnset2SD = mean(frameOnsetLatencyMS(:,testSess), "omitnan");
% std_FrameOnset2SD = std(frameOnsetLatencyMS(:,testSess), "omitnan");
% mask_FrameOnset2SD_1sess = frameOnsetLatencyMS(:,testSess) > (mean_FrameOnset2SD+(2*std_FrameOnset2SD));
% n_removed_FrameOnset2SD = nnz(mask_FrameOnset2SD_1sess);


% 6) Remove trials with incorrect reaction
% All sessions:
maskIncorrectTrials = ~(actualReaction == correctReaction);   
% 0 = correct trails --> keep, 1 = incorrect trials --> remove
n_removed_incorrectTrials = nnz(maskIncorrectTrials);
% % Uncomment, if you only want to see the results for one session:
% maskIncorrectTrials_1sess = ~(actualReaction(:,testSess) == correctReaction(:,testSess));   
% % 0 = correct trails --> keep, 1 = incorrect trials --> remove
% n_removed_incorrectTrials = nnz(maskIncorrectTrials_1sess);

% 7) Remove trials without a saccade between PictureOnset and FirstFixation
%    (Participant looked already to a side before the PictureOnset happened)
%    Mask is already finished → only number of affected files is stored
% All sessions:
n_removed_trialsWithoutSaccade = nnz(maskNoSaccade);
% % Uncomment, if you only want to see the results for one session:
% maskNoSaccade_1sess = maskNoSaccade(:,testSess);
% n_removed_trialsWithoutSaccade = nnz(maskNoSaccade_1sess);

% 8) Remove trials with a frame deciding saccade duration of 0ms 
%    (Frame deciding saccade = saccade between PictureOnset and FirstFixation
%    (Participant probably looked already to a side before the picOnset happend)
%    Mask is already finished → only number of affected files is stored
% All sessions:
n_removed_trialswithSacDur0 = nnz(maskSacDur0);
% % Uncomment, if you only want to see the results for one session:
% maskSacDur0_1sess = maskSacDur0(:,testSess);
% n_removed_trialswithSacDur0 = nnz(maskSacDur0_1sess);

% Creating a final mask, unifing all masks
% All sessions:
finalMask = maskNaNRT | maskRT150 | maskFirstFix100 | mask_FirstFix2SD | mask_FrameOnset2SD | maskIncorrectTrials | maskNoSaccade | maskSacDur0;      % logical OR – element‑wise --> trial is considered bad if ANY of the two sources is NaN
n_removed_total = nnz(finalMask);
% % Uncomment, if you only want to see the results for one session:
% finalMask = maskNaNRT_1sess | maskRT150_1sess | maskFirstFix100_1sess | mask_FirstFix2SD_1sess | mask_FrameOnset2SD_1sess | maskIncorrectTrials_1sess | maskNoSaccade_1sess | maskSacDur0_1sess;      % logical OR – element‑wise --> trial is considered bad if ANY of the two sources is NaN
% n_removed_total = nnz(finalMask);

% How many entries are affected? (purely informative)
fprintf('---------------------------- Summary removed files --------------------------------\n');
fprintf('Frame did not appear                               - number of removed trials: %d \n', n_removed_NaNRT);
fprintf('Reaction time <150 ms                              - number of removed trials: %d \n', n_removed_RT150');
fprintf('Time first fixation <100 ms                        - number of removed trials: %d \n', n_removed_firstFix100');
fprintf('Time first fixation > 2SD from mean                - number of removed trials: %d \n', n_removed_firstFix2SD');
fprintf('Frame Onset > 2SD from mean                        - number of removed trials: %d \n', n_removed_FrameOnset2SD');
fprintf('Incorrect Trials                                   - number of removed trials: %d \n', n_removed_incorrectTrials');
fprintf('Trials without a saccade                           - number of removed trials: %d \n', n_removed_trialsWithoutSaccade');
fprintf('Trials with frame deciding saccade duration of 0ms - number of removed trials: %d \n', n_removed_trialswithSacDur0');
fprintf('All in all: %d NaN entries out of %d total removed (%.2f%%).\n', ...
        n_removed_total, numel(finalMask), 100*(n_removed_total/numel(finalMask)));
fprintf('---------------------------- Summary over -----------------------------------------\n');

% Applying the final mask to all relevant matrices
reactionTime(finalMask)             = NaN;
reactionTimeS(finalMask)            = NaN;
reactionTimeMS(finalMask)           = NaN;
side(finalMask)                     = NaN;  
frameOnsetLatency(finalMask)        = NaN;
frameOnsetLatencyMS(finalMask)      = NaN;
frameOnsetLatencyS(finalMask)       = NaN;
timeFirstFixation(finalMask)        = NaN;
timeFirstFixationMS(finalMask)      = NaN;
timeFirstFixationS(finalMask)       = NaN;
actualReaction(finalMask)           = NaN;
correctReaction(finalMask)          = NaN;
valence(finalMask)                  = NaN;  
fixationCrossTimesIdxMat(finalMask) = NaN;  
picOnsetTimesIdxMat(finalMask)      = NaN; 

clear ('maskRT150', 'maskNaNRT','maskFirstFix100','mean_FirstFix2SD','std_FirstFix2SD', ...
    'mask_FirstFix2SD', 'mean_FrameOnset2SD','std_FrameOnset2SD','mask_FrameOnset2SD', ...
    'maskIncorrectTrials', 'maskNoSaccade', 'maskSacDur0', ...
    'n_removed_total','n_removed_FrameOnset2SD','n_removed_RT150','n_removed_firstFix100', ...
    'n_removed_firstFix2SD','n_removed_NaNRT','n_removed_incorrectTrials', ...
    'n_removed_trialsWithoutSaccade', 'n_removed_trialswithSacDur0');

fprintf('Invalid trials were successfully removed from  15 matrices.\n');

%% Summary statistics about the valid trials pre session
validTrials.amount_perSess = sum((finalMask==0),1);
validTrials.mean_perSess = mean(validTrials.amount_perSess);
validTrials.std_perSess  = std(validTrials.amount_perSess);
validTrials.min_perSess  = min(validTrials.amount_perSess);
validTrials.max_perSess  = max(validTrials.amount_perSess);

% % Plot
% figure;
% histogram(validTrials.amountPerSess(end,:));
% xlabel("Valid trials per session");
% ylabel("Count");
% title("Amount of valid trials per session");
% grid on;

% Valid trials per participant
sessVec = validTrials.amount_perSess(:).'; % row orientation

if mod(nSessions,2) ~= 0  % make sure the number of sessions is even (pairs)
    warning('Number of sessions (%d) is odd – the last session will be ignored.',nSessions);
    % keep only the first (nSessions‑1) sessions to reshape safely
    sessVec = sessVec(1:end-1);
    nSessions = numel(sessVec);
end

% ---- 3) reshape to a 2‑row matrix and sum across rows ----
%   After reshaping the columns correspond to participants:
%       [ s1  s3  s5  … ]
%       [ s2  s4  s6  … ]
pairMat = reshape(sessVec, 2, []);   % 2 × nParticipants
amountPerParticipant = sum(pairMat,1); % 1 × nParticipants

% Store the results in the structure validTrials
validTrials.amount_perParticipant = amountPerParticipant;
validTrials.mean_perParticipant   = mean(validTrials.amount_perParticipant);
validTrials.std_perParticipant    = std(validTrials.amount_perParticipant);
validTrials.min_perParticipant    = min(validTrials.amount_perParticipant);
validTrials.max_perParticipant    = max(validTrials.amount_perParticipant);
validTrials.SeventyPerc           = 88*2*0.7;
validTrials.EightyPerc            = 88*2*0.8;
validTrials.NintyPerc             = 88*2*0.9;

% % Plot of valid trials per participant
% figure;
% linkdata on;
% grid on;
% bar(validTrials.amount_perParticipant(end,:),YDataSource = 'validTrials.amount_perParticipant(end,:)');
% yline( validTrials.mean_perParticipant, 'r--', sprintf('Mean = %.2f',validTrials.mean_perParticipant), ...
%        'LineWidth',1.5, 'LabelHorizontalAlignment','left', ...
%        'LabelVerticalAlignment','top' );
% yline( validTrials.SeventyPerc, 'p--', sprintf('   70%% = %.2f',validTrials.SeventyPerc), ...
%        'LineWidth',1.5, 'LabelHorizontalAlignment','left', ...
%        'LabelVerticalAlignment','bottom' );
% yline( validTrials.EightyPerc, 'g--', sprintf('80%% = %.2f',validTrials.EightyPerc), ...
%        'LineWidth',1.5, 'LabelHorizontalAlignment','left', ...
%        'LabelVerticalAlignment','bottom' );
% yline( validTrials.NintyPerc, 'b--', sprintf('90%% = %.2f',validTrials.NintyPerc), ...
%        'LineWidth',1.5, 'LabelHorizontalAlignment','left', ...
%        'LabelVerticalAlignment','bottom' );
% ylabel("Amount of valid trials");
% xlabel("Participant")
% title("Amount of valid trials of each participant (both sessions summarised)");
% %legend("show");

clear pairMat amountPerParticipant sessVec
fprintf('Summary statistics about the valid trials per Session and Participant are calculated.\n');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   EXTRACTING EVENT LATENCIES   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% timeVector VALUE based

%% Extracting the values from timeVector for fixationCrossTimesIdXMar and picOnsetTimesIdxMat

nCol = nSessions;
nRow = 88;

% Result arrays, initialsied with NaN to deal with NaN indices
valueFixationCrossOnset = NaN(nRow,nCol);
valuePictureOnset       = NaN(nRow,nCol);

for col = 1:nCol
    % Indices for the current column
    idxFixCross = fixationCrossTimesIdxMat(:,col);
    idxPicOnset = picOnsetTimesIdxMat(:,col);
    
    % Valid indices: not NaN 
    valid = ~isnan(idxFixCross);   % NaN are the same for both variables
    
    % get values for valid trials
    valueFixationCrossOnset(valid,col) = timeVector{col}(idxFixCross(valid));  % vector indexing
    valuePictureOnset(valid,col)       = timeVector{col}(idxPicOnset(valid));  
end

%Cleanup
clear('nCol', 'nRow', 'col', 'valid', 'idxFixCross', 'idxPicOnset');

fprintf('Values from timeVector extracted for fixation cross onset and picture onset.\n');

%% Transforming  timeFirstFixationMS, frameOnsetLatencyMS, reactionTimeMS into the values from timeVector
% Correcting the values AFTER the FINAL addition
% Value of pictureOnset   + first fixation[ms] = Value of first fixation
% value of first fixation + frame onset[ms]    = Value of frame onset
% Value of frame onset    + reaction time[ms]  = Value of the reaction

valueFirstFixationOriginal = valuePictureOnset  + timeFirstFixationMS;
valueFrameOnsetOriginal    = valueFirstFixationOriginal + frameOnsetLatencyMS;
valueReactionOriginal      = valueFrameOnsetOriginal    + reactionTimeMS;

% Round down the values to the closest lower integer
valueFirstFixation = fix(valueFirstFixationOriginal);
valueFrameOnset    = fix(valueFrameOnsetOriginal);
valueReaction      = fix(valueReactionOriginal);

% The values might fall inbetween the numbers in the timeVector, because the timeVector increases by 2ms each row.
% Correction to the lower of the numbers, to make sure the event is not missed.
% If the value is odd, substract 1
oddMaskFirstFixation = ~isnan(valueFirstFixation) & (mod(valueFirstFixation,2) == 1);     % logical mask of odd entries (ignore NaN)
valueFirstFixation(oddMaskFirstFixation) = valueFirstFixation(oddMaskFirstFixation) - 1;  % subtract 1 from odd numbers == where the mask is true
oddMaskFrameOnset    = ~isnan(valueFrameOnset) & (mod(valueFrameOnset,2) == 1); 
valueFrameOnset(oddMaskFrameOnset)       = valueFrameOnset(oddMaskFrameOnset) - 1;     
oddMaskReactionTime  = ~isnan(valueReaction) & (mod(valueReaction,2) == 1); 
valueReaction(oddMaskReactionTime)       = valueReaction(oddMaskReactionTime) - 1;

% Calculate the Offset in ms
% offsetFirstFixation = valueFirstFixationOriginal - valueFirstFixation;
% offsetFrameOnset    = valueFrameOnsetOriginal - valueFrameOnset;
% offsetReaction      = valueReactionOriginal - valueReaction;
 
% fprintf('STATISTICS - Correction of the results - Option 1\n')
% fprintf('Offset First Fixation: Mean = %.3f, Standard Deviation = %.3f\n',...
%     mean(offsetFirstFixation,"all","omitnan"), std(offsetFirstFixation(:), "omitnan") );
% fprintf('Offset Frame Onset: Mean = %.3f, Standard Deviation = %.3f\n',...
%     mean(offsetFrameOnset,"all","omitnan"), std(offsetFrameOnset(:), "omitnan") );
% fprintf('Offset Reaction: Mean = %.3f, Standard Deviation = %.3f\n',...
%     mean(offsetReaction,"all","omitnan"), std(offsetReaction(:), "omitnan") );
clear('oddMaskReactionTime', 'oddMaskFrameOnset', 'oddMaskFirstFixation');
fprintf('timeFirstFixationMS, frameOnsetLatencyMS, reactionTimeMS transformed into values from timeVector.\n');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   NORMALISATION   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
% removing data before session start + transforming timeVector values into latencies
% sampling rate = 500 Hz

% Transform validTrialsStartIndex (col 1) into the corresponding timeVector values -> timeZero
timeZeroIndex = (validTrialsStartIndex(:,1))';    % (1x144)
nCol = nSessions;
for col = 1:nCol
    % Index of the current column
    idxTimeZero = timeZeroIndex(col);
    len = numel(timeVector{col});
    if idxTimeZero > len
        fprintf('Session %d: idx = %d > Length = %d\n',col,idxTimeZero,len);
    end
    % get values for the index from timeVector
    timeZeroValue(col) = timeVector{col}(idxTimeZero);  
end

% Transform key times into latencies
% Formula: (((Event time (ms) - time zero (ms))/1000)*500)+1
% key times: valueFixationCrossOnset, valuePictureOnset,
% valueFirstFixation, valueFrameOnset, valueReaction, saccadeOnset, saccadeOffset
latencyFixationCrossOnset = round(((valueFixationCrossOnset - timeZeroValue)/1000)*500) +1;
latencyPictureOnset       = round(((valuePictureOnset - timeZeroValue)/1000)*500) +1;
latencyFirstFixation      = round(((valueFirstFixation - timeZeroValue)/1000)*500) +1;
latencyFrameOnset         = round(((valueFrameOnset - timeZeroValue)/1000)*500) +1;
latencyReaction           = round(((valueReaction - timeZeroValue)/1000)*500) +1;

% SaccadeOnset and saccadeOffset are cells,
% therefore the formula needs to be applied in a different way
latencySaccadeOnset  = cell(1,nSessions);   % pre-allocade output
latencySaccadeOffset = cell(1,nSessions);

nCol = nSessions;
for sess = 1:nCol
    tz = timeZeroValue(sess);                 % scalar for this session

    % saccadeOnset
    vecOn = cleanSaccadeOnset{sess};          % vector of arbitrary length
    latencySaccadeOnset{sess} = round(((vecOn - tz)/1000) *500) +1;

    % saccadeOffset
    vecOff = cleanSaccadeOffset{sess};
    latencySaccadeOffset{sess} = round(((vecOff - tz)/1000) *500) +1;
    
    % Make sure latencySaccadeOnset and latencySaccadeOffset have the same
    % length, before trimming in the next step
    assert(numel(vecOn)==numel(vecOff), 'Session %d: mismatch lengths', sess);
end


% Remove rows before trial start, start at 0/ positive values
% Transforming timeVector, latencySaccadeOnset, latencySaccadeOffset
for sess = 1:nCol
    timeVector{sess} = timeVector{sess}-timeZeroValue(sess);  % substract the ms value of the start --> values before the start of the actual trials become negative
    vT = timeVector{sess};                 
    keepMask_vT = vT >= 0;                             % true → values >=0
    timeVector{sess} = vT(keepMask_vT);                % keep only the rows with values >=0
    vSOn = latencySaccadeOnset{sess};                   
    keepMask_vSOn = vSOn >= 0;                         % creating one mask -> the same amount of rows will be removed from saccadeOnset and saccadeOffset
    vSOff = latencySaccadeOffset{sess};                 
    latencySaccadeOnset{sess} = vSOn(keepMask_vSOn); 
    latencySaccadeOffset{sess} = vSOff(keepMask_vSOn); 

    assert(numel(latencySaccadeOnset{sess})==numel(latencySaccadeOffset{sess}), 'Session %d: mismatch lengths', sess);
end

% Cutting out all rows before the timeZeroIndex/ start of the valid trials from the pupil size data
% The pupil size data and the timeVector should have the same size per session agian. 
% If not, something went wrong!
for sess = 1:nCol
    pupilSizeRight{sess} = pupilSizeRight{sess}(timeZeroIndex(sess):end); % cut out all the rows below the timeZeroIndex/ start of the valid trials
    pupilSizeLeft{sess}  = pupilSizeLeft{sess}(timeZeroIndex(sess):end);
end

% Cleanup
clear('col','nCol','sess','len','idxTimeZero','tz','vecOn','vecOff','vSOn','keepMask_vT','keepMask_vSOn','vT','vSOn','vSOff');

fprintf('Data successfully normalised. \n');

%% Summary of the durations of all trial parts - summary statistics
% All latency matrices: 88 × 144 matrices
% 
% Duration of:
%  - time between trials:                  latencyFixationCrossOnset(2:end) - latencyReaction(1:end-1)
%  - complete trial:                       latencyReaction - latencyFixationCrossOnset
%  - time between FixCross and PicOnset:   latencyPictureOnset - latencyFixationCrossOnset
%  - time between PicOnset and FirstFix:   latencyFirstFixation - latencyPictureOnset
%  - time between FirstFix and FrameOnset: latencyFrameOnset - latencyFirstFixation
%  - time between FrameOnset and Reaction: latencyReaction - latencyFrameOnset
% 
% Conversation of latency into milliseconds:
%   ms = ((samples – 1) / 500) * 1000;
%
% Results are stored in the structure "TrialTimeSummary" with these fields:
%  - .interTrialDur
%  - .trialDur
%  - .fixCross_to_pic
%  - .pic_to_firstFix
%  - .firstFix_to_frame
%  - .frame_to_react
%  
%  Sub‑structure of all fields (all in ms):
%  - .mean
%  - .std
%  - .min
%  - .max   

% 1) sanity check – all latency matrices must have the same size
if ~isequal(size(latencyFixationCrossOnset),size(latencyPictureOnset),...
           size(latencyFirstFixation),size(latencyFrameOnset),size(latencyReaction))
    error('All latency matrices must have identical dimensions (trials × sessions).');
end

% 2) Compute duration intervals (in latency/sample unit) 
% 2.1  Trial duration  : FixationCrossOnset → Reaction
% latencyRction+1 to include the reactiona as part of the trial
trialDur_samp = (latencyReaction+1) - latencyFixationCrossOnset;      % >0  (samples)

% 2.2  Fixation‑Cross → Picture
fixCross_to_pic_samp = latencyPictureOnset  - latencyFixationCrossOnset;

% 2.3  Picture → First Fixation
pic_to_firstFix_samp = latencyFirstFixation - latencyPictureOnset;

% 2.4  First Fixation → Frame
firstFix_to_frame_samp = latencyFrameOnset  - latencyFirstFixation;

% 2.5  Frame → Reaction
frame_to_react_samp = latencyReaction       - latencyFrameOnset;

% 2.6  Inter‑trial duration: previous Reaction → next Fixation‑Cross
% the interval between trail 44 and 45 is excluded, because between those
% trials the self paced break of the participants took place
interTrialDur_samp = NaN(size(latencyFixationCrossOnset));  % initialise with NaN
nSessions = size(latencyFixationCrossOnset,2);
for sess = 1:nSessions
    % rows 2 … end : FixCross(t) – Reaction(t‑1)
    interTrialDur_samp(2:end,sess) = latencyFixationCrossOnset(2:end,sess) ...
                               - latencyReaction(1:end-1,sess);
    % exclude the interval between trial 44 and 45
    if size(interTrialDur_samp,1) >= 45
        interTrialDur_samp(45,sess) = NaN;
    end
end

% 3) Conversion of latency/ sample unit into milliseconds

% conversion anonymous function (applied element‑wise)
toMs = @(samples) ((samples - 1) / 500) * 1000;   

trialDuration     = toMs(trialDur_samp);
interTrialDur     = toMs(interTrialDur_samp);
fixCross_to_pic   = toMs(fixCross_to_pic_samp);
pic_to_firstFix   = toMs(pic_to_firstFix_samp);
firstFix_to_frame = toMs(firstFix_to_frame_samp);
frame_to_react    = toMs(frame_to_react_samp);

% 4) Computing statistics (over all trials and sessions) (ignoring NaNs) 

% Helper that returns a 1×4 vector [mean std min max] after removing NaNs
function s = fourStats(mat)
    v = mat(:);          % flatten
    v(isnan(v)) = [];    % drop NaNs
    if isempty(v)        % safety net (should never happen)
        s = [NaN NaN NaN NaN];
    else
        s = [mean(v), std(v), min(v), max(v)];
    end
end

% Helper to store the four numbers inside a small sub‑structure
storeStats = @(vec) struct('mean',vec(1), 'std',vec(2), ...
                           'min' ,vec(3), 'max',vec(4));

TrialTimeSummary = struct();   % initialise final container

TrialTimeSummary.trialDur          = storeStats( fourStats(trialDuration) );
TrialTimeSummary.interTrialDur     = storeStats( fourStats(interTrialDur) );
TrialTimeSummary.fixCross_to_pic   = storeStats( fourStats(fixCross_to_pic) );
TrialTimeSummary.pic_to_firstFix   = storeStats( fourStats(pic_to_firstFix) );
TrialTimeSummary.firstFix_to_frame = storeStats( fourStats(firstFix_to_frame) );
TrialTimeSummary.frame_to_react    = storeStats( fourStats(frame_to_react) );

% 4) CLEAN‑UP – delete all temporary variables, keep only the summary
clear trialDur_samp fixCross_to_pic_samp pic_to_firstFix_samp firstFix_to_frame_samp frame_to_react_samp interTrialDur_samp ...
    trialDuration interTrialDur fixCross_to_pic pic_to_firstFix firstFix_to_frame frame_to_react ...
    sess storeStats toMs;

fprintf('Global trial statistics are stored in ''TrialTimeSummary''.\n');

%% Session length - summary statistics

sessionDurSec = zeros(1,nSessions);
sessionDurSam = zeros(1,nSessions);
for sess = 1:nSessions
    curSessDurSam = size(pupilSizeRight{sess},1); % in samples
    sessionDurSam(1,sess) = curSessDurSam;
    curSessDurSec = ((curSessDurSam - 1) / 500);     % converting samples into seconds
    sessionDurSec(1,sess) = curSessDurSec;
end
clear('curSessDurSam', 'curSessDurSec', 'sess');

% Session Duration in Seconds - Summary statistics
sessDurSummarySec = struct();   % initialise final container
sessDurSummarySec.mean = mean(sessionDurSec(1,1:end));
sessDurSummarySec.std  = std(sessionDurSec(1,1:end));
sessDurSummarySec.min  = min(sessionDurSec(1,1:end));
sessDurSummarySec.max  = max(sessionDurSec(1,1:end));

% Plot as barplot
% figure;
% bar(sessionDurSec(end,:),YDataSource = 'sessionDurS(end,:)');
% yline(sessDurSummarySec.mean, '--r');
% xticks(0:10:140);
% ylabel("Duration [seconds]");
% xlabel("Session number");
% title("Duration of each session (trial start to end) in seconds");
% meanStr = sprintf('Mean = %.0f seconds', sessDurSummarySec.mean);
% legend('', meanStr);
% grid on;
% clear meanStr;

% Session Duration in Samples - Summary statistics
sessDurSummarySam = struct();   % initialise final container
sessDurSummarySam.mean = mean(sessionDurSam(1,1:end));
sessDurSummarySam.std  = std(sessionDurSam(1,1:end));
sessDurSummarySam.min  = min(sessionDurSam(1,1:end));
sessDurSummarySam.max  = max(sessionDurSam(1,1:end));

% Plot as barplot
% figure;
% bar(sessionDurSam(end,:),YDataSource = 'sessionDurS(end,:)');
% yline(sessDurSummarySam.mean, '--r');
% xticks(0:10:140);
% ylabel("Duration [samples]");
% xlabel("Session number");
% title("Duration of each session (trial start to end) in samples");
% meanStr = sprintf('Mean = %.0f samples', sessDurSummarySam.mean);
% legend('',meanStr);
% grid on;
% clear meanStr;

fprintf('Session duration in seconds stored.\n');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  INTERPOLATION & FILTERING   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ---------------------------   Interpolation   --------------------------------------------------------------------------------------------------------------------------------------
% Interpolation of artifacts 
% Necessary, otherwise the filtering smears out all the extrem values of
% the artifacts across the complete data

% Copying the raw data
pupilSizeRight_Interpolated = pupilSizeRight; 

% Pre-allocation of a cell array holding all masks
mask_interpolated_artifacts = cell(1, nSessions);

% Loop over all session
for sess = 1:nSessions
    % Data of the session
    pupilData = pupilSizeRight{sess};

    % building a logical mask of the raw artifact values 
    % true (1) where the value is 0 (blink) or > 3000 (lost pupil)
    rawArtifactMask = (pupilData == 0) | (pupilData > 3000);

    % Expand mask by ±3 samples (convolution, safe at edges) 
    winLen = 7;
    expandedArtifMask = conv(double(rawArtifactMask), ones(1,winLen), 'same') > 0;

    % Storing the mask 
    mask_interpolated_artifacts{sess} = expandedArtifMask;  

    % Replace the artifact values by NaN 
    pupilData(expandedArtifMask) = NaN;       

    % Linear Interpolation of the artifac values
    pupilDataInterpolated = fillmissing(pupilData,"linear");

    % Assert, that the number of rows for the row and interpolated data are the same
    assert( isequal( size(pupilDataInterpolated) , size(pupilSizeRight{sess}) ), ...
            sprintf('Row‑size mismatch in session %d: raw = %d rows, interpolated = %d rows.', ...
                    sess, size(pupilSizeRight{sess},1), size(pupilDataInterpolated,1) ) );

    % Writing the interpolated data back into the cell array
    pupilSizeRight_Interpolated{sess} = pupilDataInterpolated;
end

% Amount of samples that were replaced in each session in percent
propArt = cellfun(@(m) (mean(m(:))*100), mask_interpolated_artifacts);
meanPropArt = mean(propArt);

% Amount of samples that were replaced in each session
nArtefacts = cellfun(@(m) sum(m(:)==1), mask_interpolated_artifacts); %in Samples
nArtefactsMS = ((nArtefacts/ 500)* 1000);  % in milliseconds

% % Plot
% figure;
% % One bar for each session
% bar(propArt);
% hold on;
% % horizontal line showing the mean
% yline(meanPropArt,'r--','LineWidth',1.0);
% xticks(0:10:140);
% % Lables 
% xlabel("Session");
% ylabel("Amount of interpolated samples [in %]")
% title("Amount of Interpolated Samples in Percentage per Session");
% meanStr = sprintf('Mean = %.2f %%', meanPropArt);
% legend('', meanStr);
% grid on;
% hold off;
% 
% clear meanStr;
% 
% % Examples plotted 
% 
% % 1. Interpolated artifact example - first blink session 1
% % If you change this, make sure to change the title of the plot as well
% artifactStart = 1412;  
% artifactEnd = 1453;
% session = 1;
% 
% % Plot
% figure
% hold on;
% % Raw data first blink
% plot(pupilSizeRight{session},'o');
% plot(pupilSizeRight_Interpolated{session},':.');
% title('Linear Interpolation of the First Blink of Session 1', FontSize=14, FontWeight='bold');
% ylabel("Pupil Size [Arbitrary Units]", FontSize=12);
% xlabel("Samples", FontSize=12);
% legend('Original data','Interpolated data');
% hold off;
% grid on;
% xlim([(artifactStart - 30) (artifactEnd + 30)]);
% ylim([-100 1400]);
% 
% % Context of that artefact 
% % (4 seconds before and after the artefact included)
% figure;
% plot(pupilSizeRight_Interpolated{session});
% ylabel("Pupil Size [Arbitrary units]");
% xlabel("Samples");
% title("Pupil Size changes - Session 1");
% xlim([artifactStart-1500 artifactEnd+1500]);
% ylim([600 1500]);
% 
% % 2. Interpolated artifact example - lost followed by blink (session 1)
% % If you change this, make sure to change the title of the plot as well
% artifactStart = 11672;  
% artifactEnd = 11750;  
% session = 1;
% 
% % Bottom part (everything below the "gap")
% yBotLow = min(rawData) - 200;        % a little margin
% yBotHigh = 1600;                     % upper edge of the visible bottom part
% 
% % Top part (everything above the "gap")
% yTopLow  = 31000;                    % lower edge of the visible top part
% yTopHigh = max(rawData) + 200;       % a little margin on top
% 
% figure;
% % Bottom part
% subplot(2,1,2);
% plot(pupilSizeRight{session},'o'); 
% hold on; 
% plot(pupilSizeRight_Interpolated{session},':.');
% ylim([yBotLow yBotHigh]); xlim([artifactStart-30 artifactEnd+30]);
% legend('Original data','Interpolated data');
% title('Original vs Interpolated (bottom part)');
% hold off; 
% 
% % Top part
% subplot(2,1,1);
% plot(pupilSizeRight{session},'o'); 
% hold on; 
% plot(pupilSizeRight_Interpolated{session},':.');
% set(gca,'XTickLabel',[]);  % hide x‑labels on top subplot
% ylim([yTopLow yTopHigh]); 
% xlim([artifactStart-30 artifactEnd+30]);
% title('Original vs Interpolated (top part)');
% hold off; 
% 
% % Title
% sgtitle('Linear Interpolation of a Lost Pupil Followed by a Blink – Session 1');
% 
% % Context of that artefact 
% % (4 seconds before and after the artefact included)
% figure;
% plot(pupilSizeRight_Interpolated{session});
% ylabel("Pupil Size [Arbitrary units]");
% xlabel("Samples");
% title("Pupil Size changes - Session 1");
% xlim([artifactStart-1500 artifactEnd+1500]);
% ylim([600 1500]);
% 
% % 3. Interpolated artifact example - undetected outlier and a blink
% % If you change this, make sure to change the title of the plot as well
% artifactStart = 31430;  
% artifactEnd = 31510;
% session = 20;
% 
% % Plot
% figure
% hold on;
% % Raw data first blink
% plot(pupilSizeRight{session},'o');
% plot(pupilSizeRight_Interpolated{session},':.');
% title('Linear Interpolation of an Undetcted Outlier and a Blink (Session 20)', FontSize=14, FontWeight='bold');
% ylabel("Pupil Size [Arbitrary Units]", FontSize=12);
% xlabel("Samples", FontSize=12);
% legend('Original data','Interpolated data');
% hold off;
% grid on;
% xlim([(artifactStart - 30) (artifactEnd + 30)]);
% ylim([-100 3000]);
% 
% % Context of that artefact 
% % (4 seconds before and after the artefact included)
% figure;
% plot(pupilSizeRight_Interpolated{session});
% ylabel("Pupil Size [Arbitrary units]");
% xlabel("Samples");
% title("Pupil Size changes - Session 20");
% xlim([artifactStart-1500 artifactEnd+1500]);
% %ylim([600 1500]);
% 
% % 4. Interpolated artifact example - blink interpolation going well
% % If you change this, make sure to change the title of the plot as well
% artifactStart = 46653;  
% artifactEnd = 46670;
% session = 40;
% 
% % Plot
% figure
% hold on;
% % Raw data first blink
% plot(pupilSizeRight{session},'o');
% plot(pupilSizeRight_Interpolated{session},':.');
% title('Linear Interpolation going well for a isolated blink (Session 40)', FontSize=14, FontWeight='bold');
% ylabel("Pupil Size [Arbitrary Units]", FontSize=12);
% xlabel("Samples", FontSize=12);
% legend('Original data','Interpolated data');
% hold off;
% grid on;
% xlim([(artifactStart - 30) (artifactEnd + 30)]);
% ylim([-100 1600]);
% 
% % Context of that artefact 
% % (3 seconds before and after the artefact included)
% figure;
% plot(pupilSizeRight_Interpolated{session});
% ylabel("Pupil Size [Arbitrary units]");
% xlabel("Samples");
% title("Pupil Size changes - Session 40");
% xlim([artifactStart-1500 artifactEnd+1500]);
% ylim([600 1500]);
%%
clear artifactStart artifactEnd session pupilDataInterpolated pupilData sess winLen meanPropArt;
fprintf("All pupil artifacts interpolated.\n");

%% --------------------------------  Filtering the data  -----------------------------------------------------------------------------------------------------------------------------------
fs   = 500;  % sampling frequency [Hz]
fc_l = 100;  % low‑pass cut‑off frequency [Hz]
fc_h = 0.1;  % high‑pass cut‑off frequency [Hz]
% normalised (to the Nyquist frequency (fs/2)) cut_off frequencies [Hz] 
% --> required for the butter function
norm_fc_l = fc_l/(fs/2);  % = 100/(250) = 0.4
norm_fc_h = fc_h/(fs/2);  % = 0.1/(250) = 4e-4

order = 1;

% Designing 1st-order digital Butterworth filters with normalized cutoff frequencies. 
% Returns the numerator and denominator coefficients of the filter transfer functions.
[bh, ah] = butter(order, norm_fc_h, "high");
[bl, al] = butter(order, norm_fc_l, "low");

% The frequency responses of the filter
Npts = 200000;                  % Number of frequency points over which to evaluate response
[Hh,wh] = freqz(bh,ah,Npts,fs); % High-pass filter
[Hl,wl] = freqz(bl,al,Npts,fs); % Low-pass filter

%% Magnitude and phase plots of the high-pass and low-pass filters
% % Plots for filtering in one direction (--> causal) with order 1 filters
% 
% % High-pass filter (0,1 Hz) - Magnitude and Phase 
% figure;
% freqz(bh,ah,Npts,fs);
% % Magnitude
% subplot(2,1,1)
% xline(fc_h, '--m', '0.1Hz','LabelVerticalAlignment','middle');
% % Add a –3 dB reference line for visual confirmation
% yline(-3, '--k', 'Label','-3 dB','LabelVerticalAlignment','bottom','LabelHorizontalAlignment','left');
% ylim([-40 2])
% xlim([-0.2 2])
% 
% % Phase
% subplot(2,1,2)
% xline(fc_h, '--m','0.1Hz');
% xlim([-0.5 8])
% 
% 
% % Low-pass filter (100 Hz) - Magnitude and Phase 
% figure;
% freqz(bl,al,Npts,fs);
% 
% % Magnitude
% subplot(2,1,1)
% xline(fc_l, '--m', '100Hz','LabelVerticalAlignment','middle');
% % Add a –3 dB reference line for visual confirmation
% yline(-3, '--k', 'Label','-3 dB','LabelVerticalAlignment','bottom','LabelHorizontalAlignment','left');
% xlim([-1 260])
% ylim([-40 2])
% 
% % Phase
% subplot(2,1,2)
% xline(fc_l, '--m', '100Hz');
% xlim([-0.5 260])
% 
% 
% % Plots of the combined filters
% % Magnitude after *filtfilt* = square of the single‑direction magnitude
% mag_hp_filtfilt = abs(Hh).^2;   % → 2nd‑order magnitude (order = 2·1)
% mag_lp_filtfilt = abs(Hl).^2;   % → 2nd‑order magnitude
% 
% % Combined filter = cascade of the two *filtfilt* stages
% %   (multiply the two magnitude responses point‑wise)
% mag_total = mag_hp_filtfilt .* mag_lp_filtfilt;
% mag_total_dB = 20*log10(mag_total);
% 
% figure('Name','Magnitude response of the two‑stage zero‑phase filter','NumberTitle','off');
% 
% % magnitude in dB 
% semilogx(wh, 20*log10(mag_hp_filtfilt), '-b', 'LineWidth',1.5); hold on;
% semilogx(wh, 20*log10(mag_lp_filtfilt), '-r', 'LineWidth',1.5);
% semilogx(wh, mag_total_dB,              '-k', 'LineWidth',2);
% 
% % Reference lines for the cut‑offs
% xline(fc_h, '--b', sprintf('HP cut‑off = %.1f Hz',fc_h), 'LabelVerticalAlignment','bottom');
% xline(fc_l, '--r', sprintf('LP cut‑off = %.0f Hz',fc_l), 'LabelVerticalAlignment','bottom');
% yline(-6, '--m', 'Label', 'Half-power cut-off = -6dB', 'LabelHorizontalAlignment','center', 'LabelVerticalAlignment','bottom');
% 
% % Axis cosmetics
% grid on;
% xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
% title('Zero‑phase (filtfilt) magnitude – HP 0.1 Hz → LP 100 Hz');
% legend('High‑pass (filtfilt)','Low‑pass (filtfilt)','Combined','Location','best');
% xlim([0.01 fs/2]);   % show from ~10 mHz up to Nyquist
% ylim([-80 5]);       % enough headroom to see the steep roll‑offs
% 
% clear mag_lp_filtfilt mag_hp_filtfilt

% %% OLD - Comparison between high and low-pass filtering (filtre vs filtfilt)
% % Data filtered with the high pass filter for one Session
% dataIn = pupilSizeRight_Interpolated{1};
% high_dataOut_Filt = filter(bh,ah,dataIn);
% high_dataOut_FiltFilt = filtfilt(bh,ah,dataIn);
% 
% % Data filtered with the low pass filter for one Session
% low_dataOut_Filt = filter(bl,al,dataIn);
% low_dataOut_FiltFilt = filtfilt(bl,al,dataIn);
% 
% 
% % Comparison plots for the high pass filter
% figure;
% subplot(3,1,1);
% plot(dataIn);
% title("Raw data");
% xlabel("Samples");
% ylabel("Pupil Size (Arbitrary Units)");
% ylim([-500 3500])
% xlim([70400 70600])
% grid on;
% 
% subplot(3,1,2);
% plot(high_dataOut_Filt);
% title("Filtered data with phase shift (filter function)");
% xlabel("Samples");
% ylabel("Pupil Size (Arbitrary Units)");
% ylim([-500 3500])
% xlim([70400 70600])
% grid on;
% 
% subplot(3,1,3);
% plot(high_dataOut_FiltFilt);
% title("Filtered data without phaseshift (filtfilt function)");
% xlabel("Samples");
% ylabel("Pupil Size (Arbitrary Units)");
% ylim([-500 3500])
% xlim([70400 70600])
% grid on;
% 
% sgtitle('Comparison high-pass filter: Raw vs filtered data');
% 
% % Comparison plots for the low pass filter
% figure;
% subplot(3,1,1);
% plot(dataIn);
% title("Raw data");
% xlabel("Samples");
% ylabel("Pupil Size (Arbitrary Units)");
% ylim([0 3500])
% xlim([67000 69000])
% grid on;
% 
% subplot(3,1,2);
% plot(low_dataOut_Filt);
% title("Filtered data with phase shift (filter function)");
% xlabel("Samples");
% ylabel("Pupil Size (Arbitrary Units)");
% ylim([0 3500])
% xlim([67000 69000])
% grid on;
% 
% subplot(3,1,3);
% plot(low_dataOut_FiltFilt);
% title("Filtered data without phaseshift (filtfilt function)");
% xlabel("Samples");
% ylabel("Pupil Size (Arbitrary Units)");
% ylim([0 3500])
% xlim([67000 69000])
% grid on;
% 
% sgtitle('Comparison high-pass filter: Raw vs filtered data');


%% For Manual inspection of data parts
% % % Data filtered with the highpass and the lowpass filter
% session = 1;
% rawData = pupilSizeRight{session};
% dataInterpolated = pupilSizeRight_Interpolated{session};
% high_dataOut_FiltFilt = filtfilt(bh,ah,dataInterpolated);
% low_dataOut_FiltFilt = filtfilt(bl,al,high_dataOut_FiltFilt);
% 
% % % Comparison plots for both filters
% % % Raw data
% % figure;
% % subplot(4,1,1);
% % plot(rawData);
% % title("Raw data");
% % xlabel("Samples");
% % ylabel("Pupil Size (Arbitrary Units)");
% % ylim([0 2500])
% % xlim([0 50000])
% % grid on;
% % 
% % % Interpolated
% % subplot(4,1,2);
% % plot(dataInterpolated);
% % title("Interpolated");
% % xlabel("Samples");
% % ylabel("Pupil Size (Arbitrary Units)");
% % ylim([0 2500])
% % xlim([0 50000])
% % grid on;
% % 
% % % After th high pass filtered data (non - causal)
% % subplot(4,1,3);
% % plot(high_dataOut_FiltFilt);
% % title("High-pass filtered data (1st filter) (filtfilt)");
% % xlabel("Samples");
% % ylabel("Pupil Size (Arbitrary Units)");
% % ylim([-1500 1000])
% % xlim([0 50000])
% % grid on;
% % 
% % % After the high and low pass filtered data (non - causal)
% % subplot(4,1,4);
% % plot(low_dataOut_FiltFilt);
% % title("Low-pass filtered data (on the highpass filtered data) (2nd filter) (filtfilt)");
% % xlabel("Samples");
% % ylabel("Pupil Size (Arbitrary Units)");
% % ylim([-1500 1000])
% % xlim([0 50000])
% % grid on;
% % 
% % sgtitle('Comparison between raw, interpolated, highpass filtered and high- than low-pass filtered data');
% 
% % Inspectig specific snippets in the data
% 
% % Settings you want to inspect
% % The session needs to be changed above at the filtering
% 
% % Session 1 - big part in the beginning
% % segStart = 1;                 % first sample of the window
% % segEnd   = 40000;             % last  sample of the window
% 
% % Session 1 - first blink
% segStart = 1412-30;                
% segEnd   = 1453+30;
% % 
% % % Session 1 - lost follwed by blink
% % segStart = 11672-30;                
% % segEnd   = 11750+30;
% % 
% % Session 20 - undetected outlier and blink
% % segStart = 31430-30;                
% % segEnd   = 31510+30;
% % 
% % % Session 40 - well interpolated blink
% % segStart = 46653-30;                
% % segEnd   = 46670+30;
% 
% 
% % Index vector for the chosen segment
% idx = segStart:segEnd;
% 
% % Plot the three signals together
% figure('Name','Small‑segment comparison','NumberTitle','off');
% hold on;
% 
% % 1) raw data 
% plot(idx, rawData(idx), 'LineWidth',3.5, 'Color', [1 0 1],  'DisplayName','Raw'); %magenta
% 
% % 2) interpolated data 
% plot(idx, dataInterpolated(idx), 'LineWidth',1.0, 'Color', [0 0 0], 'DisplayName','Interpolated'); %black
% 
% % 3) high‑pass filtered (filtfilt) 
% plot(idx, high_dataOut_FiltFilt(idx), 'LineWidth',3.5, 'Color', [1, 0.69, 0], 'DisplayName','High‑pass (filtfilt)'); %orange
% 
% % 4) high‑+‑low‑pass filtered (filtfilt) 
% plot(idx, low_dataOut_FiltFilt(idx), 'LineWidth',1.0, 'Color', [1, 0, 0], 'DisplayName','Low‑pass (after high‑pass) (filtfilt)'); %red
% hold off;
% 
% % Axes
% xlabel('Samples');
% ylabel('Pupil size (a.u.)');
% %title(sprintf('Comparison of raw, interpolated and filtered data for artifacts (Samples %d – %d)', segStart, segEnd));
% title(sprintf('Comparison of data: raw and interpolated for artifacts (Samples %d – %d, Session %d)', segStart, segEnd, session));
% 
% % If you want the same y‑range you used for the full‑length plots:
% ylim([-700 2600]);          % comment this line out for automatic limits
% 
% 
% grid on;
% legend('Location','best');   % automatic placement
% 
% % Context of that artefact 
% % (3 seconds before and after the artefact included)
% figure;
% plot(low_dataOut_FiltFilt);
% ylabel("Pupil Size [Arbitrary units]");
% xlabel("Samples");
% title(sprintf('Pupil Size changes filtered data - Session %d', session));
% %xlim([segStart-1500 segEnd+1500]);
% xlim([20000 40000]);
% % ylim([-800 1700]);
% % ylim([600 1500]);
% 
% clear high_dataOut_FiltFilt low_dataOut_FiltFilt rawData session;

%% Filtering of all sessions

% Filter pipeline:
% 1. high-pass butterworth filter as a non-causal filter (filtfilt) on the
%    interpolated data
% 2. low-pass butterworth filter as a non-causal filter (filtfilt) on the
%    first high-pass filtered data

% Preallocate output 
pupilSizeRightFilt = cell(1, nSessions);

% Apply filter to each session 
for sess = 1:nSessions
    %fprintf("Session: %d\n", sess);
    dataInterpolated = pupilSizeRight_Interpolated{sess};   % get session data

    if isempty(dataInterpolated)
        warning('Session %d is empty — skipping.', sess);
        pupilSizeRightFilt{sess} = dataInterpolated;
        continue
    end

    % Apply high-pass filter to interpolated data
    high_dataOut_FiltFilt = filtfilt(bh,ah,dataInterpolated);

    % Apply low-pass filter to already high-pass filtered data
    pupilSizeRightFilt{sess} = filtfilt(bl,al,high_dataOut_FiltFilt);

end

% Savin of the Filtered data
%save ("pupilSizeRightFilt.mat","pupilSizeRightFilt");
fprintf("Pupil data has been filtered. \n")

clear ah al bh bl fc_h fc_l fs Hh Hl norm_fc_h norm_fc_l Npts order dataInterpolated high_dataOut_FiltFilt sess wh wl;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   PUPIL ARTIFACTS   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Blinks and lost pupil - length and indicies
% A lost pupil size (> 3000) and a blink (0) are artifacts of the pupil
% data. Containg non trustworthy data.
% 
% Differenciation between 3 types:
% 0 = NOT 0 or > 3000  --> normal pupil size data
% 1 = 0                --> blinks
% 2 = > 3000           --> lost Pupil

% Iterating over all pupilSize data. Creating a mask that stores per
% session the values 0-2 for the above described categories
 
% Store length of blinks and lost pupil.
% Store start and end indicies of blinks and lost pupil value. 

% Initializing storage cells for sequence-length
zeroLengthSeq         = cell(1,nSessions);   % pure 0‑sequence
lostLengthSeq         = cell(1,nSessions);   % pure >3000 ‑ sequence

% Initializing storage cells for start and end indices of each sequence
startIdxZero          = cell(1,nSessions);
endIdxZero            = cell(1,nSessions);
startIdxLost          = cell(1,nSessions);
endIdxLost            = cell(1,nSessions);

maskCell = cell(1,nSessions);   % whole‑sample mask (codes 0‑4)

% Main loop over all sessions
for sess = 1:nSessions
    curVec = pupilSizeRight{sess}(:);   % current vector (column)
    N      = numel(curVec);             % length of current vector

    % 1) Sequence-length encoding
    changeIdx = [true; diff(curVec) ~= 0]; % true at the first element of every sequence
                                           % binary mask; true = beginning of a new sequence
    seqStart  = find(changeIdx);           % 1‑based start index of each sequence
    seqEnd    = [seqStart(2:end)-1; N];    % end index of each sequence
                                           % end of a sequence = 1 index above start of new sequence
    seqVals   = curVec(seqStart);          % constant value inside the sequence
    seqLens   = seqEnd - seqStart + 1;     % length of each sequence
    nRuns     = numel(seqStart);           % number of sequences in this session

    % 2) Detect transitions
    isZero = (seqVals == 0);
    isLost = (seqVals > 3000);

    % 3) Storing sequence length for each type:
    % Blink - pure 0 sequence
    zeroLengthSeq{sess} = seqLens(isZero).';
    % Lost pupil - pure >3000 sequence
    lostLengthSeq{sess} = seqLens(isLost).';
   
    % % 4) Store start and end indicies
    % % a) zero sequences 
    % runIdxAllZero = find(isZero);              
    % zStart = seqStart(runIdxAllZero);
    % zEnd   = seqEnd(runIdxAllZero);
    % startIdxZero{sess} = zStart.';
    % endIdxZero{sess}   = zEnd.';
    % 
    % % b) lost‑pupil sequences 
    % runIdxAllLost = find(isLost);
    % lStart = seqStart(runIdxAllLost);
    % lEnd   = seqEnd(runIdxAllLost);
    % startIdxLost{sess} = lStart.';
    % endIdxLost{sess}   = lEnd.';

    % % 4) Storing start and end indices
    % startIdxZero{sess} = seqStart(isZero);
    % endIdxZero{sess}   = seqEnd(isZero);
    % startIdxLost{sess} = seqStart(isLost);
    % endIdxLost{sess}   = seqEnd(isLost);

    % 4) Storing start and end as EXTENDED INDICES 
    % begin 3 samples earlier and end 3 samples later
    % Clip to the borders of the recording (1 … N)
    startIdxZero{sess} = max(seqStart(isZero) - 3, 1);
    endIdxZero{sess}   = min(seqEnd(isZero)   + 3, N);
    startIdxLost{sess} = max(seqStart(isLost) - 3, 1);
    endIdxLost{sess}   = min(seqEnd(isLost)   + 3, N);


    % 5) Build the mask
    % 0 = normal
    % 1 = pure 0
    % 2 = pure > 3000
    seqMask = zeros(nRuns,1,'uint8');  % Zero = normal data
    
    % a) pure sequences 
    seqMask(isZero) = 1;     % whole pure‑zero sequence gets code 1
    seqMask(isLost) = 2;     % whole pure‑lost‑pupil sequence gets code 2
   
    % ----- expand the per‑sequence mask to a per‑sample mask ----------------
    mask = zeros(N,1,'uint8'); % default = 0 (normal data)
    
    for r = 1:nRuns            % write the code for the whole sequence
        mask(seqStart(r):seqEnd(r)) = seqMask(r);
    end
    
    % store the mask for this session
    maskCell{sess} = mask;
end

% Convert the variable‑length cell arrays to padded matrices
% sessions = columns, rows = k‑th occurrence, NaN = "no more"

makeMatrix = @(C) padcat(C,'NaN');   % helper defined in the next section

lengthZeroMatrix   = makeMatrix(zeroLengthSeq);
lengthLostMatrix   = makeMatrix(lostLengthSeq);

startIdxZeroMatrix = makeMatrix(startIdxZero);
endIdxZeroMatrix   = makeMatrix(endIdxZero);
startIdxLostMatrix = makeMatrix(startIdxLost);
endIdxLostMatrix   = makeMatrix(endIdxLost);

maskMatrix = makeMatrix(maskCell);   % whole‑sample mask


fprintf('Finished marking, counting and indexing 0 and >3000.\n');

clear('changeIdx','curVec','nRuns','N','sess','idx3','idx4','isLost','isZero','isTransition', ...
    'lEnd','lStart','zEnd','zStart','r','makeMatrix','mask','neighbour','type3','type4', ...
    'runIdxAllLost','runIdxAllZero','runMask','seqEnd','seqStart','seqLens','seqVals');

% Local helper: pad a cell array of column vectors with NaN
function M = padcat(cellVec, padVal)
%PADCAT  Take a 1×K cell array where each cell holds a column vector.
%        Return a matrix M (maxLength × K) where the vectors are placed
%        column‑wise and the remaining entries are filled with padVal.
%
%   Example:
%       C = {[2;3],[5],[1;4;6]};
%       M = padcat(C,'NaN')
%       ->  [2 5 1;
%            3 NaN 4;
%           NaN NaN 6]

    K = numel(cellVec);
    maxLen = max(cellfun(@numel,cellVec));
    if strcmpi(padVal,'NaN')            % chosen padVal is NaN
        M = NaN(maxLen, K);             % initialise Matrix maxLen x K with NaN
    else                                % chosen padVal is NOT NaN
        M = repmat(padVal, maxLen, K);  % initialise Matrix maxLen x K with padVal 
    end
    % overwrite the Matrix with the original values of cellVec
    % --> only the otherwise empty rows of the shorter columns are filled with padVal
    for c = 1:K
        v = cellVec{c};
        if ~isempty(v)
            M(1:numel(v),c) = v;
        end
    end
end

%% Samples before and after pupil artifacts
% Getting information about the pupil size changes of the time before blink
% and lost pupil onset and after the offsets 
% --> to define a cutoff value, which time before and after the
%     artifact events needs to be excluded
% NOTE: Unused function, in a POM it was decided that we can not be sure,
% if the samples before and after artefacts might carry a meaning,
% therefore they are included
% 
% function [sessionBefore, sessionAfter] = analysePupilArtifacts(pupilSizeRight, startBlink, endBlink, startLost, endLost, winLen, bufBeforeBlink, bufAfterBlink, bufBeforeLost, bufAfterLost)
% % AnalysePupilArtifacts: Extract pre‑ and post‑ windows around
% %   (1) blink blocks      → event type 1
% %   (2) lost‑pupil blocks → event type 2
% %
% % INPUT
% %   pupilSizeRight : 1×Nsessions cell, each cell = n×1 double (raw pupil)
% %   winLen         : length of the time‑window on each side (default = 100)
% %   startBlink     : 1×Nsessions cell, each cell = n×1 double (start Idx of Blink)
% %   endBlink       : 1×Nsessions cell, each cell = n×1 double (end Idx of Blink)
% %   startLost      : 1×Nsessions cell, each cell = n×1 double (start Idx of Lost pupil)
% %   endLost        : 1×Nsessions cell, each cell = n×1 double (end Idx of Lost pupil)
% %   bufBeforeBlink : length of buffer before a Blink
% %   bufAfterBlink  : length of buffer after a Blink
% %   bufBeforeLost  : length of buffer before a Lost pupil
% %   bufAfterLost   : length of buffer after a Lost pupil
% %
% % OUTPUT
% %   sessionBefore{t}{sess} – M×winLen matrix of the BEFORE windows for
% %                            event type t in session sess (M = #events).
% %   sessionAfter {t}{sess} – same layout for the AFTER windows.
% 
% 
% if nargin < 6, winLen = 100; end   % default window length % nargin = number of argument input
% 
% % Safty check
% nSessions = numel(pupilSizeRight);
% 
% % 1) Pre‑allocate storage containers
% % Four event types (1,2,3,4) × nSessions cells
% sessionBefore = cell(2, nSessions);
% sessionAfter  = cell(2, nSessions);
% 
% % 2) Main loop over all sessions
% for sess = 1:nSessions
%     pupil = pupilSizeRight{sess};   % n×1 double
% 
%     % 2.1) Collect all event types for this session
%     startBlink_sess = startBlink{sess};
%     endBlink_sess   = endBlink{sess};
%     startLost_sess  = startLost{sess};
%     endLost_sess    = endLost{sess};
%     types = [ones(numel(startBlink_sess),1);    % type 1
%             2*ones(numel(startLost_sess),1)];   % type 2
% 
%     % 2.2) Pre-allocate per‑type matrices (rows = events, cols = winLen)
%     preMat  = cell(2,1);
%     postMat = cell(2,1);
%     for t = 1:2
%         preMat{t}  = nan( sum(types==t), winLen );
%         postMat{t} = nan( sum(types==t), winLen );
%     end
% 
%     % 2.5) Blinks - Fill the windows with the pupil size data
%     for e = 1:numel(startBlink_sess)  % going over all events of each type
%         t = 1;                         % blinks are type 1
% 
%         % ---------- samples BEFORE Blink ----------
%         sIdx = startBlink_sess(e) - winLen - bufBeforeBlink;
%         eIdx = startBlink_sess(e) - 1 - bufBeforeBlink;
%         if sIdx < 1                             % pad with NaN if we run out of data
%             nValid = eIdx - max(sIdx,1) + 1;    % Stores the amount of valid data until the start Idx is below 1 (before the session started)
%             % Store all valid data points, the rest stays NaN
%             preMat{t}(e, winLen-nValid+1:winLen) = pupil(max(sIdx,1):eIdx);
%         else                                                   % there are 100 valid samples of data before the event
%             preMat{t}(e, :) = pupil(sIdx:eIdx);   % all are saved
%         end
% 
%         % ---------- samples AFTER Blink ----------
%         sIdx = endBlink_sess(e) + 1 + bufAfterBlink;  
%         eIdx = endBlink_sess(e) + winLen + bufAfterBlink;                
%         if eIdx > numel(pupil)                            % pad with NaN if we run out of data 
%             nValid = min(eIdx,numel(pupil)) - sIdx + 1;   % Stores the amount of valid data until the end Idx is higher than the pupil data idx (end of the session)
%             % Store all valid data points, the rest stays NaN
%             postMat{t}(e,1:nValid) = pupil(sIdx:min(eIdx,numel(pupil)));
%         else                                                   % there are 100 valid samples of data before the event
%             postMat{t}(e, :) = pupil(sIdx:eIdx);  % all are saved
%         end
%     end
% 
%     % 2.6) Lost pupil - Fill the windows with the pupil size data
%     for e = 1:numel(startLost_sess)  % going over all events of each type
%         t = 2;               % lost pupil are type 2
% 
%         % ---------- samples BEFORE Lost ----------
%         sIdx = startLost_sess(e) - winLen - bufBeforeLost;
%         eIdx = startLost_sess(e) - 1 - bufBeforeLost;
%         if sIdx < 1                             % pad with NaN if we run out of data
%             nValid = eIdx - max(sIdx,1) + 1;    % Stores the amount of valid data until the start Idx is below 1 (before the session started)
%             % Store all valid data points, the rest stays NaN
%             preMat{t}(e, winLen-nValid+1:winLen) = pupil(max(sIdx,1):eIdx);
%         else                                              % there are 100 valid samples of data before the event
%             preMat{t}(e, :) = pupil(sIdx:eIdx);   % all are savd
%         end
% 
%         % ---------- samples AFTER Lost----------
%         sIdx = endLost_sess(e) + 1 + bufAfterLost;  
%         eIdx = endLost_sess(e) + winLen + bufAfterLost;                
%         if eIdx > numel(pupil)                            % pad with NaN if we run out of data 
%             nValid = min(eIdx,numel(pupil)) - sIdx + 1;   % Stores the amount of valid data until the end Idx is higher than the pupil data idx (end of the session)
%             % Store all valid data points, the rest stays NaN
%             postMat{t}(e, 1:nValid) = pupil(sIdx:min(eIdx,numel(pupil)));
%         else                                              % there are 100 valid samples of data before the event
%             postMat{t}(e, :) = pupil(sIdx:eIdx);  % all are saved
%         end
%     end
% 
%     % 2.6) Store the per-session results
%     for t = 1:2
%         sessionBefore{t, sess} = preMat{t};
%         sessionAfter {t, sess} = postMat{t};
%     end
% 
% end   % end of session loop
% 
% end   % end of the function

% CALLING THE FUNCTION
% winLen = 100;                     % 100 samples = 0.2 s at 500 Hz
% blinkStartBuffer = 0;
% blinkEndBuffer   = 0;
% lostStartBuffer  = 0;
% lostEndBuffer    = 0;

% % Calling the function on the raw data
%[sessionBefore, sessionAfter] =  analysePupilArtifacts(pupilSizeRight, startIdxZero, endIdxZero, startIdxLost, endIdxLost, winLen, blinkStartBuffer, blinkEndBuffer, lostStartBuffer, lostEndBuffer);

% % Calling the function on the filtered data
%[sessionBeforeFilt, sessionAfterFilt] =  analysePupilArtifacts(pupilSizeRightFilt, startIdxZero, endIdxZero, startIdxLost, endIdxLost, winLen, blinkStartBuffer, blinkEndBuffer, lostStartBuffer, lostEndBuffer);

%clear winLen blinkStartBuffer blinkEndBuffer lostStartBuffer lostEndBuffer;

% fprintf('Stored the samples before and after pupil artifacts.\n')

%% Unfiltere data - Calculate grand means of the pupil size changes before and after all event types
% 
% % Overarching goal: Figure out the time windows before and after blinks,
% % lost pupil, in which the pupil size is already changing because of the 
% % closing and opening of the eyelid or eyetracer problems. 
% % That is unreliable data and should be removed from the analysis.
% % 
% % Fore EACH SESSION we have:
% % - 2 different event types
% % - a variying amount of event appearence for each event type in each
% %   session (e.g. session 1 has 101 events f type 1 and session 2 only 53...)
% % - for each event type the 100 samples before the event, and after the event
% % --> 4x100 values per session
% %
% % The goal is to calculate the grand mean (along dimension 1) over all sessions for each of the
% % 4 different variables --> Result 4 variabeles each 100 coloumns.
% 
% % But Blinks and Lost pupil events often are in close proximity.
% % Therefore for each of the 4 different variables we want to have these
% % means:
% % - plain mean: Data of each session is taken as it is
% % - mean without 0/blinks: In each session for each event type all 0 values
% %   are filtered out
% % - mean without >3000/ lost pupil: In each session for each event type all 
% %   >3000 values are filtered out
% % - mean without >3000 and 0 values: In each session for each event type 
% %   all >3000 and 0 values are filtered out
% 
% % Steps:
% % Step 1: calculate the 4 different types of means for each event type
% %         before and after the event for each session! 
% %         (Important because only in the session data the 0 and >3000 
% %         values can be filtered out successfully)
% % Step 2: Calculate the grand means over all sessions for all different
% %         means calculated for each session 
% % 
% % Result: 2 (event types) x 2 (before and after) x 4 (different means) 
% %         = 16 different grand means
% 
% % Needed (output of analysePupilArtifacts): 
% %   - sessionBefore{t}{s}  – pre‑artifact windows
% %   - sessionAfter{t}{s}   – post‑artifact windows
% % 
% % The 2 event types:
% %   - Type 1: Blink (pupilSize = 0)
% %   - Type 2: Lost pupil (pupilSize > 3000)
% 
% %  Basic sanity check
% if ~exist('sessionBefore','var') || ~exist('sessionAfter','var')
%     error('sessionBefore / sessionAfter not found in the workspace.');
% end
% 
% % Window length
% winLen = size(sessionBefore{1,1},2);   % should be 100 (defined in the analysePupilArtifacts function call)
% 
% 
% %  STEP 1 – per‑session column‑wise means (four filtering strategies)
% 
% % Pre‑allocate all PER_SESSION result containers (4 event types × nSessions)
% % The four filtering strategies are stored in four different cell arrays.
% % The first index = event type (1-2), the second index = session.
% meanPre_plain       = cell(2,nSessions);
% meanPre_no0         = cell(2,nSessions);
% meanPre_no3000     = cell(2,nSessions);
% meanPre_no0or3000  = cell(2,nSessions);
% 
% meanPost_plain      = cell(2,nSessions);
% meanPost_no0        = cell(2,nSessions);
% meanPost_no3000    = cell(2,nSessions);
% meanPost_no0or3000 = cell(2,nSessions);
% 
% for sess = 1:nSessions     % Main loop over all sessions
%     for type = 1:2         % loop over the four event types
% 
%         % ----------  BEFORE ----------
%         sessVec = sessionBefore{type,sess};    % #events × winLen matrix
% 
%         % plain mean (ignore NaNs that may already be present)
%         meanPre_plain{type,sess} = mean(sessVec,1,'omitnan');
% 
%         % filter out zeros
%         sessVec_no0 = sessVec;
%         sessVec_no0(sessVec_no0==0) = NaN;
%         meanPre_no0{type,sess} = mean(sessVec_no0,1,'omitnan');
% 
%         % filter out >3000
%         sessVec_no3000 = sessVec;
%         sessVec_no3000(sessVec_no3000==3000) = NaN;
%         meanPre_no3000{type,sess} = mean(sessVec_no3000,1,'omitnan');
% 
%         % filter out both 0 and >3000
%         sessVec_no0or3000 = sessVec;
%         sessVec_no0or3000(sessVec_no0or3000==0 | sessVec_no0or3000 > 3000) = NaN;
%         meanPre_no0or3000{type,sess} = mean(sessVec_no0or3000,1,'omitnan');
% 
%         % ----------  AFTER ----------
%         sessVec = sessionAfter{type,sess};
% 
%         % plain mean (ignore NaNs that may already be present)
%         meanPost_plain{type,sess} = mean(sessVec,1,'omitnan');
% 
%         % filter out zeros
%         sessVec_no0 = sessVec;
%         sessVec_no0(sessVec_no0==0) = NaN;
%         meanPost_no0{type,sess} = mean(sessVec_no0,1,'omitnan');
% 
%         % filter out >3000
%         sessVec_no3000 = sessVec;
%         sessVec_no3000(sessVec_no3000 > 3000) = NaN;
%         meanPost_no3000{type,sess} = mean(sessVec_no3000,1,'omitnan');
% 
%         % filter out both 0 and >3000
%         sessVec_no0or3000 = sessVec;
%         sessVec_no0or3000(sessVec_no0or3000==0 | sessVec_no0or3000 > 3000) = NaN;
%         meanPost_no0or3000{type,sess} = mean(sessVec_no0or3000,1,'omitnan');
%     end
% end
% 
% %  STEP 2 – grand means across all sessions
% 
% % Each grand‑mean is a 1 × winLen vector (average over the session dimension).
% grandPre_plain      = cell(2,1);
% grandPre_no0        = cell(2,1);
% grandPre_no3000     = cell(2,1);
% grandPre_no0or3000  = cell(2,1);
% 
% grandPost_plain      = cell(2,1);
% grandPost_no0        = cell(2,1);
% grandPost_no3000     = cell(2,1);
% grandPost_no0or3000  = cell(2,1);
% 
% for type = 1:2
%     % ---------- PRE ----------
%     % concatenate the 1×winLen vectors of all sessions into an
%     % nSessions × winLen matrix, then take the mean across sessions
%     mat_pre_plain      = cat(1, meanPre_plain{type,:});          % nSess × winLen
%     mat_pre_no0        = cat(1, meanPre_no0{type,:});
%     mat_pre_no3000     = cat(1, meanPre_no3000{type,:});
%     mat_pre_no0or3000  = cat(1, meanPre_no0or3000{type,:});
% 
%     grandPre_plain{type}      = mean(mat_pre_plain,      1, 'omitnan');
%     grandPre_no0{type}        = mean(mat_pre_no0,        1, 'omitnan');
%     grandPre_no3000{type}    = mean(mat_pre_no3000,    1, 'omitnan');
%     grandPre_no0or3000{type} = mean(mat_pre_no0or3000, 1, 'omitnan');
% 
%     % ---------- POST ----------
%     % concatenate the 1×winLen vectors of all sessions into an
%     % nSessions × winLen matrix, then take the mean across sessions
%     mat_post_plain      = cat(1, meanPost_plain{type,:});
%     mat_post_no0        = cat(1, meanPost_no0{type,:});
%     mat_post_no3000     = cat(1, meanPost_no3000{type,:});
%     mat_post_no0or3000  = cat(1, meanPost_no0or3000{type,:});
% 
%     grandPost_plain{type}      = mean(mat_post_plain,      1, 'omitnan');
%     grandPost_no0{type}        = mean(mat_post_no0,        1, 'omitnan');
%     grandPost_no3000{type}    = mean(mat_post_no3000,    1, 'omitnan');
%     grandPost_no0or3000{type} = mean(mat_post_no0or3000, 1, 'omitnan');
% end
% 
% clear mat* sessVec type sess
% 
% fprintf("Grand means are calculated. \n");
% 
% %% Unfiltered data - Plotting the grand mean results
% % ------- Blink - Type 1 ---------
% % ------- BEFORE and AFTER - all 4 types of averages
% figure('Position', [100, 100, 1600, 500]);  % Wide figure for 2 subplots
% 
% % Before (Left subplot)
% subplot(1, 2, 1);
% hold on;
% plot(grandPre_plain{1,1}(end,:),      Color='blue',    LineWidth=1.5);
% plot(grandPre_no0{1,1}(end,:),        Color='red',     LineWidth=1.5);
% plot(grandPre_no3000{1,1}(end,:),    Color='green',   LineWidth=1.5);
% plot(grandPre_no0or3000{1,1}(end,:), Color='magenta', LineWidth=1.5);
% ylabel("Pupil Size", FontSize=12);
% xlabel("Samples", FontSize=12);
% title("Before a Blink", FontSize=14, FontWeight='bold');
% legend('Plain average','Removed 0 values','Removed >3000 values','Removed 0 and >3000 values', Location='best');
% grid on;
% ylim([500 3800]);
% hold off;
% 
% % After (Right subplot)
% subplot(1, 2, 2);
% hold on;
% plot(grandPost_plain{1,1}(end,:),      Color='blue',    LineWidth=1.5);
% plot(grandPost_no0{1,1}(end,:),        Color='red',     LineWidth=1.5);
% plot(grandPost_no3000{1,1}(end,:),    Color='green',   LineWidth=1.5);
% plot(grandPost_no0or3000{1,1}(end,:), Color='magenta', LineWidth=1.5);
% ylabel("Pupil Size", FontSize=12);
% xlabel("Samples", FontSize=12);
% title("After a Blink", FontSize=14, FontWeight='bold');
% legend('Plain average','Removed 0 values','Removed >3000 values','Removed 0 and >3000 values', Location='best');
% grid on;
% ylim([500 3800]);
% hold off;
% 
% % Overall title
% sgtitle("Pupil Size Changes Around Blinks - Averages Across All Sessions", FontSize=16, FontWeight='bold');
% 
% % ------- BEFORE and AFTER - Plotting only the mean corrected for 0 and >3000 values
% figure('Position', [100, 100, 1400, 500]);  % Wide figure for 2 subplots
% 
% % Before (Left subplot)
% subplot(1, 2, 1);
% plot(grandPre_no0or3000{1,1}(end,:), Color = 'magenta', LineWidth=1.5);
% ylabel("Pupil Size");
% xlabel("Samples")
% title("Before a Blink", FontSize=14, FontWeight='bold');
% grid on;
% ylim([800 1300]);
% 
% % After (Right subplot)
% subplot(1, 2, 2);
% plot(grandPost_no0or3000{1,1}(end,:), Color = 'magenta', LineWidth=1.5);
% linkdata on;
% ylabel("Pupil Size");
% xlabel("Samples")
% title("After a Blink", FontSize=14, FontWeight='bold');
% grid on;
% ylim([800 1300]);
% 
% % Overall title
% sgtitle("Pupil Size Changes Around Blinks - Clean averages", FontSize=16, FontWeight='bold');
% 
% % ------- Lost Pupil - Type 2 ---------
% % ------- BEFORE and AFTER - all 4 types of averages
% figure('Position', [100, 100, 1400, 500]);  % Wide figure for 2 subplots
% 
% % Before (Left subplot)
% subplot(1, 2, 1);
% hold on;
% plot(grandPre_plain{2,1}(end,:),      Color = 'blue',    LineWidth=1.5);
% plot(grandPre_no0{2,1}(end,:),        Color = 'red',     LineWidth=1.5);
% plot(grandPre_no3000{2,1}(end,:),    Color = 'green',   LineWidth=1.5);
% plot(grandPre_no0or3000{2,1}(end,:), Color = 'magenta', LineWidth=1.5);
% linkdata on;
% ylabel("Pupil Size");
% xlabel("Samples")
% title("Before a Lost pupil event", FontSize=14, FontWeight='bold');
% legend("show");
% legend('Plain average','Removed 0 values','Removed >3000 values','Removed 0 and >3000 values');
% grid on;
% ylim([500 3000]);
% 
% % After (Right subplot)
% subplot(1, 2, 2);
% hold on;
% plot(grandPost_plain{2,1}(end,:),      Color = 'blue',    LineWidth=1.5);
% plot(grandPost_no0{2,1}(end,:),        Color = 'red',     LineWidth=1.5);
% plot(grandPost_no3000{2,1}(end,:),    Color = 'green',   LineWidth=1.5);
% plot(grandPost_no0or3000{2,1}(end,:), Color = 'magenta', LineWidth=1.5);
% linkdata on;
% ylabel("Pupil Size");
% xlabel("Samples")
% title("After a Lost pupil event", FontSize=14, FontWeight='bold');
% legend("show");
% legend('Plain average','Removed 0 values','Removed >3000 values','Removed 0 and >3000 values');
% grid on;
% ylim([500 3000]);
% 
% % Overall title
% sgtitle("Pupil Size Changes Around Lost Pupil events - Averages Across All Sessions", FontSize=16, FontWeight='bold');
% 
% % ------- BEFORE and AFTER - Plotting only the mean corrected for 0 and >3000 values
% figure('Position', [100, 100, 1400, 500]);  % Wide figure for 2 subplots
% 
% % Before (Left subplot)
% subplot(1, 2, 1);
% plot(grandPre_no0or3000{2,1}(end,:), Color = 'magenta', LineWidth=1.5);
% linkdata on;
% ylabel("Pupil Size");
% xlabel("Samples")
% title("Before a Lost pupil event", FontSize=14, FontWeight='bold');
% grid on;
% ylim([1000 1900]);
% 
% % After (Right subplot)
% subplot(1, 2, 2);
% plot(grandPost_no0or3000{2,1}(end,:), Color = 'magenta', LineWidth=1.5);
% linkdata on;
% ylabel("Pupil Size");
% xlabel("Samples")
% title("After a Lost pupil event", FontSize=14, FontWeight='bold');
% grid on;
% ylim([1000 1900]);
% 
% % Overall title
% sgtitle("Pupil Size Changes Around Lost pupil events - Clean averages", FontSize=16, FontWeight='bold');
% 
% fprintf("Grand means are plotted.\n");
% 
% %% Filtered data - Calculate grand means of the pupil size changes before and after all event types
% 
% % Overarching goal: Figure out the time windows before and after blinks,
% % lost pupil, in which the pupil size is already changing because of the 
% % closing and opening of the eyelid or eyetracer problems. 
% % That is unreliable data and should be removed from the analysis.
% % 
% % Fore EACH SESSION we have:
% % - 2 different event types
% % - a variying amount of event appearence for each event type in each
% %   session (e.g. session 1 has 101 events f type 1 and session 2 only 53...)
% % - for each event type the 100 samples before the event, and after the event
% % --> 4x100 values per session
% %
% % The goal is to calculate the grand mean (along dimension 1) over all sessions for each of the
% % 4 different variables --> Result 4 variabeles each 100 coloumns.
% 
% % But Blinks and Lost pupil events often are in close proximity.
% % Therefore for each of the 4 different variables we want to have these
% % means:
% % - plain mean: Data of each session is taken as it is
% % - mean without 0/blinks: In each session for each event type all 0 values
% %   are filtered out
% % - mean without >3000/ lost pupil: In each session for each event type all 
% %   >3000 values are filtered out
% % - mean without >3000 and 0 values: In each session for each event type 
% %   all >3000 and 0 values are filtered out
% 
% % Steps:
% % Step 1: calculate the 4 different types of means for each event type
% %         before and after the event for each session! 
% %         (Important because only in the session data the 0 and >3000 
% %         values can be filtered out successfully)
% % Step 2: Calculate the grand means over all sessions for all different
% %         means calculated for each session 
% % 
% % Result: 2 (event types) x 2 (before and after) x 4 (different means) 
% %         = 16 different grand means
% 
% % Needed (output of analysePupilArtifacts): 
% %   - sessionBefore{t}{s}  – pre‑artifact windows
% %   - sessionAfter{t}{s}   – post‑artifact windows
% % 
% % The 2 event types:
% %   - Type 1: Blink (pupilSize = 0)
% %   - Type 2: Lost pupil (pupilSize = >3000)
% 
% %  Basic sanity check
% if ~exist('sessionBeforeFilt','var') || ~exist('sessionAfterFilt','var')
%     error('sessionBeforeFilt / sessionAfterFilt not found in the workspace.');
% end
% 
% % Window length
% winLen = size(sessionBeforeFilt{1,1},2);   % should be 100 (defined in the analysePupilArtifacts function call)
% 
% 
% %  STEP 1 – per‑session column‑wise means (four filtering strategies)
% 
% % Pre‑allocate all PER_SESSION result containers (2 event types × nSessions)
% % The four filtering strategies are stored in four different cell arrays.
% % The first index = event type (1‑2), the second index = session.
% meanPre_plain_Filt       = cell(2,nSessions);
% meanPre_no0_Filt         = cell(2,nSessions);
% meanPre_no3000_Filt      = cell(2,nSessions);
% meanPre_no0or3000_Filt   = cell(2,nSessions);
% 
% meanPost_plain_Filt      = cell(2,nSessions);
% meanPost_no0_Filt        = cell(2,nSessions);
% meanPost_no3000_Filt     = cell(2,nSessions);
% meanPost_no0or3000_Filt  = cell(2,nSessions);
% 
% for sess = 1:nSessions     % Main loop over all sessions
%     for type = 1:2         % loop over the four event types
% 
%         % ----------  BEFORE ----------
%         sessVec = sessionBeforeFilt{type,sess}; % #events × winLen matrix
% 
%         % plain mean (ignore NaNs that may already be present)
%         meanPre_plain_Filt{type,sess} = mean(sessVec,1,'omitnan');
% 
%         % filter out zeros
%         sessVec_no0 = sessVec;
%         sessVec_no0(sessVec_no0 < -800) = NaN;
%         meanPre_no0_Filt{type,sess} = mean(sessVec_no0,1,'omitnan');
% 
%         % filter out >3000
%         sessVec_no3000 = sessVec;
%         sessVec_no3000(sessVec_no3000 > 3000) = NaN;
%         meanPre_no3000_Filt{type,sess} = mean(sessVec_no3000,1,'omitnan');
% 
%         % filter out both 0 and >3000
%         sessVec_no0or3000 = sessVec;
%         sessVec_no0or3000(sessVec_no0or3000 < -800 | sessVec_no0or3000 > 3000) = NaN;
%         meanPre_no0or3000_Filt{type,sess} = mean(sessVec_no0or3000,1,'omitnan');
% 
%         % ----------  AFTER ----------
%         sessVec_After = sessionAfterFilt{type,sess}; % #events × winLen matrix
% 
%         % plain mean (ignore NaNs that may already be present)
%         meanPost_plain_Filt{type,sess} = mean(sessVec_After,1,'omitnan');
% 
%         % filter out zeros
%         sessVec_no0_After = sessVec_After;
%         sessVec_no0_After(sessVec_no0_After < -800) = NaN;
%         meanPost_no0_Filt{type,sess} = mean(sessVec_no0_After,1,'omitnan');
% 
%         % filter out >3000
%         sessVec_no3000_After = sessVec_After;
%         sessVec_no3000_After(sessVec_no3000_After > 3000) = NaN;
%         meanPost_no3000_Filt{type,sess} = mean(sessVec_no3000_After,1,'omitnan');
% 
%         % filter out both 0 and >3000
%         sessVec_no0or3000_After = sessVec_After;
%         sessVec_no0or3000_After(sessVec_no0or3000_After < -800| sessVec_no0or3000_After > 3000) = NaN;
%         meanPost_no0or3000_Filt{type,sess} = mean(sessVec_no0or3000_After,1,'omitnan');
%     end
% end
% 
% %  STEP 2 – grand means across all sessions
% 
% % Each grand‑mean is a 1 × winLen vector (average over the session dimension).
% grandPre_plain_Filt      = cell(2,1);
% grandPre_no0_Filt        = cell(2,1);
% grandPre_no3000_Filt     = cell(2,1);
% grandPre_no0or3000_Filt  = cell(2,1);
% 
% grandPost_plain_Filt      = cell(2,1);
% grandPost_no0_Filt        = cell(2,1);
% grandPost_no3000_Filt     = cell(2,1);
% grandPost_no0or3000_Filt  = cell(2,1);
% 
% for type = 1:2
%     % ---------- PRE ----------
%     % concatenate the 1×winLen vectors of all sessions into an
%     % nSessions × winLen matrix, then take the mean across sessions
%     mat_pre_plain_Filt      = cat(1, meanPre_plain_Filt{type,:});          % nSess × winLen
%     mat_pre_no0_Filt        = cat(1, meanPre_no0_Filt{type,:});
%     mat_pre_no3000_Filt     = cat(1, meanPre_no3000_Filt{type,:});
%     mat_pre_no0or3000_Filt  = cat(1, meanPre_no0or3000_Filt{type,:});
% 
%     grandPre_plain_Filt{type}      = mean(mat_pre_plain_Filt,    1, 'omitnan');
%     grandPre_no0_Filt{type}        = mean(mat_pre_no0_Filt,      1, 'omitnan');
%     grandPre_no3000_Filt{type}    = mean(mat_pre_no3000_Filt,    1, 'omitnan');
%     grandPre_no0or3000_Filt{type} = mean(mat_pre_no0or3000_Filt, 1, 'omitnan');
% 
%     % ---------- POST ----------
%     % concatenate the 1×winLen vectors of all sessions into an
%     % nSessions × winLen matrix, then take the mean across sessions
%     mat_post_plain_Filt      = cat(1, meanPost_plain_Filt{type,:});
%     mat_post_no0_Filt        = cat(1, meanPost_no0_Filt{type,:});
%     mat_post_no3000_Filt     = cat(1, meanPost_no3000_Filt{type,:});
%     mat_post_no0or3000_Filt  = cat(1, meanPost_no0or3000_Filt{type,:});
% 
%     grandPost_plain_Filt{type}      = mean(mat_post_plain_Filt,    1, 'omitnan');
%     grandPost_no0_Filt{type}        = mean(mat_post_no0_Filt,      1, 'omitnan');
%     grandPost_no3000_Filt{type}    = mean(mat_post_no3000_Filt,    1, 'omitnan');
%     grandPost_no0or3000_Filt{type} = mean(mat_post_no0or3000_Filt, 1, 'omitnan');
% end
% 
% clear mat* sessVec type sess
% 
% fprintf("Grand means of filtered data are calculated. \n");
% 
% %% Filtered data - Plotting the grand mean results
% % ------- Blink - Type 1 ---------
% % ------- BEFORE and AFTER - all 4 types of averages
% figure('Position', [100, 100, 1400, 500]);  % Wide figure for 2 subplots
% 
% % Before (Left subplot)
% subplot(1, 2, 1);
% hold on;
% plot(grandPre_plain_Filt{1,1}(end,:),      Color='blue',    LineWidth=1.5);
% plot(grandPre_no0_Filt{1,1}(end,:),        Color='red',     LineWidth=1.5);
% plot(grandPre_no3000_Filt{1,1}(end,:),    Color='green',   LineWidth=1.5);
% plot(grandPre_no0or3000_Filt{1,1}(end,:), Color='magenta', LineWidth=1.5);
% ylabel("Pupil Size", FontSize=12);
% xlabel("Samples", FontSize=12);
% title("Before a Blink", FontSize=14, FontWeight='bold');
% legend('Plain average','Removed 0 values','Removed >3000 values','Removed 0 and >3000 values', Location='best');
% grid on;
% ylim([-500 3000]);
% hold off;
% 
% % After (Right subplot)
% subplot(1, 2, 2);
% hold on;
% plot(grandPost_plain_Filt{1,1}(end,:),      Color='blue',    LineWidth=1.5);
% plot(grandPost_no0_Filt{1,1}(end,:),        Color='red',     LineWidth=1.5);
% plot(grandPost_no3000_Filt{1,1}(end,:),    Color='green',   LineWidth=1.5);
% plot(grandPost_no0or3000_Filt{1,1}(end,:), Color='magenta', LineWidth=1.5);
% ylabel("Pupil Size", FontSize=12);
% xlabel("Samples", FontSize=12);
% title("After a Blink", FontSize=14, FontWeight='bold');
% legend('Plain average','Removed 0 values','Removed >3000 values','Removed 0 and >3000 values', Location='best');
% grid on;
% ylim([-500 3000]);
% hold off;
% 
% % Overall title
% sgtitle("Pupil Size Changes Around Blinks - Averages Across All Sessions - Filtered data", FontSize=16, FontWeight='bold');
% 
% % ------- BEFORE and AFTER - Plotting only the mean corrected for 0 and >3000 values
% figure('Position', [100, 100, 1400, 500]);  % Wide figure for 2 subplots
% 
% % Before (Left subplot)
% subplot(1, 2, 1);
% plot(grandPre_no0or3000_Filt{1,1}(end,:), Color = 'magenta', LineWidth=1.5);
% ylabel("Pupil Size");
% xlabel("Samples")
% title("Before a Blink", FontSize=14, FontWeight='bold');
% grid on;
% ylim([-300 200]);
% 
% % After (Right subplot)
% subplot(1, 2, 2);
% plot(grandPost_no0or3000_Filt{1,1}(end,:), Color = 'magenta', LineWidth=1.5);
% linkdata on;
% ylabel("Pupil Size");
% xlabel("Samples")
% title("After a Blink", FontSize=14, FontWeight='bold');
% grid on;
% ylim([-300 200]);
% 
% % Overall title
% sgtitle("Pupil Size Changes Around Blinks - Clean averages - Filtered data", FontSize=16, FontWeight='bold');
% 
% % ------- Lost Pupil - Type 2 ---------
% % ------- BEFORE and AFTER - all 4 types of averages
% figure('Position', [100, 100, 1400, 500]);  % Wide figure for 2 subplots
% 
% % Before (Left subplot)
% subplot(1, 2, 1);
% hold on;
% plot(grandPre_plain_Filt{2,1}(end,:),      Color = 'blue',    LineWidth=1.5);
% plot(grandPre_no0_Filt{2,1}(end,:),        Color = 'red',     LineWidth=1.5);
% plot(grandPre_no3000_Filt{2,1}(end,:),    Color = 'green',   LineWidth=1.5);
% plot(grandPre_no0or3000_Filt{2,1}(end,:), Color = 'magenta', LineWidth=1.5);
% linkdata on;
% ylabel("Pupil Size");
% xlabel("Samples")
% title("Before a Lost pupil event", FontSize=14, FontWeight='bold');
% legend("show");
% legend('Plain average','Removed 0 values','Removed >3000 values','Removed 0 and >3000 values');
% grid on;
% ylim([-1000 2000]);
% 
% % After (Right subplot)
% subplot(1, 2, 2);
% hold on;
% plot(grandPost_plain_Filt{2,1}(end,:),      Color = 'blue',    LineWidth=1.5);
% plot(grandPost_no0_Filt{2,1}(end,:),        Color = 'red',     LineWidth=1.5);
% plot(grandPost_no3000_Filt{2,1}(end,:),    Color = 'green',   LineWidth=1.5);
% plot(grandPost_no0or3000_Filt{2,1}(end,:), Color = 'magenta', LineWidth=1.5);
% linkdata on;
% ylabel("Pupil Size");
% xlabel("Samples")
% title("After a Lost pupil event", FontSize=14, FontWeight='bold');
% legend("show");
% legend('Plain average','Removed 0 values','Removed >3000 values','Removed 0 and >3000 values');
% grid on;
% ylim([-1000 2000]);
% 
% % Overall title
% sgtitle("Pupil Size Changes Around Lost Pupil events - Averages Across All Sessions - Filtered data", FontSize=16, FontWeight='bold');
% 
% % ------- BEFORE and AFTER - Plotting only the mean corrected for 0 and >3000 values
% figure('Position', [100, 100, 1400, 500]);  % Wide figure for 2 subplots
% 
% % Before (Left subplot)
% subplot(1, 2, 1);
% plot(grandPre_no0or3000_Filt{2,1}(end,:), Color = 'magenta', LineWidth=1.5);
% linkdata on;
% ylabel("Pupil Size");
% xlabel("Samples")
% title("Before a Lost pupil event", FontSize=14, FontWeight='bold');
% grid on;
% ylim([-300 50]);
% 
% % After (Right subplot)
% subplot(1, 2, 2);
% plot(grandPost_no0or3000_Filt{2,1}(end,:), Color = 'magenta', LineWidth=1.5);
% linkdata on;
% ylabel("Pupil Size");
% xlabel("Samples")
% title("After a Lost pupil event", FontSize=14, FontWeight='bold');
% grid on;
% ylim([-300 50]);
% 
% % Overall title
% sgtitle("Pupil Size Changes Around Lost pupil events - Clean averages - Filtered data", FontSize=16, FontWeight='bold');
% 
% fprintf("Grand means of filtered data are plotted.\n");

%% Transforming the duration of the artifacts from latencies into milliseconds
% Hz = 500
% xy-1 --> start at correct value, (xy-1)/500 --> from latencies into seconds, s*1000 --> from seconds into milliseconds
lengthZeroMatrix         = ((lengthZeroMatrix-1)/500)*1000;
lengthLostMatrix         = ((lengthLostMatrix-1)/500)*1000;

%% Summary statistics of blinks and lost pupil values 
% calculate summary statistics and store results in a structure
summaryBlink        = summary(lengthZeroMatrix,1, Statistics=["min" "max" "sum" "mean" "std"]);    % dim 1 --> summarise columns. Each column/ session summed up and summary statistics calculated from that
summaryLostPupil    = summary(lengthLostMatrix,1, Statistics=["min" "max" "sum" "mean" "std"]);
%summaryZeroThenLost = summary(lengthZeroThenLostMatrix,1, Statistics=["min" "max" "sum" "mean" "std"]);
%summaryLostThenZero = summary(lengthLostThenZeroMatrix,1, Statistics=["min" "max" "sum" "mean" "std"]);
% Transforming the summary into a table for easier readability/ overview
% 1) Removed two irrelevant fields (of different size) to be able to transpose all fields of the structure 
to_remove = {'Size','Type'};                            
summaryBlink        = rmfield(summaryBlink,to_remove);
summaryLostPupil    = rmfield(summaryLostPupil,to_remove);
%summaryZeroThenLost = rmfield(summaryZeroThenLost,to_remove);
%summaryLostThenZero = rmfield(summaryLostThenZero,to_remove);
% 2) Transpose all fields --> one column in the table is one summary
% statistics. Indexes are session numbers
summaryBlink         = structfun(@transpose,summaryBlink,'UniformOutput',false);
summaryLostPupil    = structfun(@transpose,summaryLostPupil,'UniformOutput',false);
%summaryZeroThenLost = structfun(@transpose,summaryZeroThenLost,'UniformOutput',false);
%summaryLostThenZero = structfun(@transpose,summaryLostThenZero,'UniformOutput',false);
% 3) Turn structure into table
summaryBlinkTable        = struct2table(summaryBlink);
summaryLostPupilTable    = struct2table(summaryLostPupil);
%summaryZeroThenLostTable = struct2table(summaryZeroThenLost);
%summaryLostThenZeroTable = struct2table(summaryLostThenZero);

% Calculate mean and std for all blink and lostPupil values
meanAllBlinks       = mean(lengthZeroMatrix, "all", "omitnan");
stdAllBlinks        =  std(lengthZeroMatrix(:), "omitnan");
meanAllLostPupil    = mean(lengthLostMatrix, "all", "omitnan");
stdAllLostPupil     =  std(lengthLostMatrix(:), "omitnan");
% meanAllZeroThenLost = mean(lengthZeroThenLostMatrix, "all", "omitnan");
% stdAllZeroThenLost  =  std(lengthZeroThenLostMatrix(:), "omitnan");
% meanAllLostThenZero = mean(lengthLostThenZeroMatrix, "all", "omitnan");
% stdAllLostThenZero  =  std(lengthLostThenZeroMatrix(:), "omitnan");

blink_lost_Stats_all_Trials = struct( ...
    'mean_AllBlinks',       meanAllBlinks, ...
    'std_AllBlinks',        stdAllBlinks, ...
    'mean_AllLostPupil',    meanAllLostPupil, ...
    'std_AllLostPupil',     stdAllLostPupil);

clear('to_remove','summaryZeroThenLost','summaryLostThenZero','summaryLostPupil','summaryBlink', ...
    'meanAllBlinks','stdAllBlinks','meanAllLostPupil','stdAllLostPupil', ...
    'meanAllZeroThenLost','stdAllZeroThenLost','meanAllLostThenZero','stdAllLostThenZero');

fprintf('Summary statistics for blinks and lostpupil are calculated.\n');

%% Plots 
% % Blink
% figure;
% histogram(summaryBlinkTable.Mean);
% xlabel("Mean [ms]");
% title("Mean - Blink");
% legend("show");
% figure;
% histogram(summaryBlinkTable.Std);
% xlabel("Std [ms]");
% title("Standard deviation - Blink");
% legend("show");
% figure
% histogram(lengthZeroMatrix(:,:));
% xlabel("ms");
% title("Blink duration distribution");
% % Lost Pupil
% figure;
% histogram(summaryLostPupilTable.Mean);
% xlabel("Mean [ms]");
% title("Mean - Lost pupil");
% legend("show");
% figure;
% histogram(summaryLostPupilTable.Std);
% xlabel("Std [ms]");
% title("Standard deviation - Lost pupil");
% legend("show");
% figure
% histogram(lengthLostMatrix(:,:));
% xlabel("ms");
% title("Lost pupil duration distribution");
% legend("show");


%% Blinks and lost pupil inside and outside trials

% 1) Pre-allocate the outputs 
[nTrials,nSessions] = size(latencyFixationCrossOnset);   % 88 × 144

% inside‑trials
nBlink          = zeros(nTrials,nSessions);   % number blinks intersecting each trial
durBlink        = zeros(nTrials,nSessions);   % TOTAL blink time inside each trial (if two blinks they are summarised)
nLost           = zeros(nTrials,nSessions);   % number lost‑pupil intervals intersecting each trial
durLost         = zeros(nTrials,nSessions);   % TOTAL lost‑pupil time inside each trial

trialDur        = zeros(nTrials,nSessions);   % raw trial length (including reaction)
cleanTrialDur   = zeros(nTrials,nSessions);   % trial length minus any event
edgeTrialFlag   = false(nTrials,nSessions);   % true if trial start OR end falls inside an event
nEdgeTrials     = zeros(1,nSessions);         % number of such trials per session

% between‑trial statistics (cell arrays, because length varies)
% rows = gaps (1 … nTrials‑1), columns = sessions
% Example: Row 1 = The time between trial 1 and trial 2
blinkCountBetween = cell(nTrials-1, nSessions);    % number of blinks in each gap between trials
blinkDurBetween   = cell(nTrials-1, nSessions);    % duration of EACH blink in each gap between trials
lostCountBetween  = cell(nTrials-1, nSessions);    % number of lost pupil in each gap between trials
lostDurBetween    = cell(nTrials-1, nSessions);    % duration of EACH lost pupil in each gap between trials

% containers for index variables
insideBlinkStart  = cell(nTrials,nSessions);
insideBlinkEnd    = cell(nTrials,nSessions);
insideLostStart   = cell(nTrials,nSessions);
insideLostEnd     = cell(nTrials,nSessions);
outsideBlinkStart = cell(1,nSessions);   % one cell per session - gap storage lead to a lot of problems
outsideBlinkEnd   = cell(1,nSessions);
outsideLostStart  = cell(1,nSessions);
outsideLostEnd    = cell(1,nSessions);

% 2) Main Loop – over each session
for sess = 1:nSessions

    % 3) Event vectors for the current session (column vectors)
    blinkStart = startIdxZero{sess}(:);   % may be empty
    blinkEnd   = endIdxZero{sess}(:);
    lostStart  = startIdxLost{sess}(:);
    lostEnd    = endIdxLost{sess}(:);

    % 4) Trial vectors for the current session (column vectors)
    trStart = latencyFixationCrossOnset(:,sess);   % 88×1
    trEnd   = latencyReaction(:,sess)+1;           % 88×1, +1 to include the reaction as part of the trial
    trialDur(:,sess) = trEnd - trStart;            % raw length

    % 5) Basic overlap (any part of the event touches the trial)
    if ~isempty(blinkStart)
        blinkOverlap = (blinkEnd > trStart.') & (blinkStart < trEnd.');
    else
        blinkOverlap = false(0,nTrials);
    end
    if ~isempty(lostStart)
        lostOverlap = (lostEnd > trStart.') & (lostStart < trEnd.');
    else
        lostOverlap = false(0,nTrials);
    end

    % 6) Special rules
    % 6a) start‑collision --> store event start and event end as OUTSIDE
    % Definition start-collision: eventStart < trialStart  &&  eventEnd > trialStart  &&  eventEnd < trialEnd
    blinkStartCollision = (blinkStart < trStart.') & ...
                          (blinkEnd   > trStart.') & ...
                          (blinkEnd   < trEnd.');
    lostStartCollision  = (lostStart  < trStart.') & ...
                          (lostEnd    > trStart.') & ...
                          (lostEnd    < trEnd.');

    % 6b) end‑collision --> store event start and event end as INSIDE
    % we do not exclude it, we only need to make sure the start‑collision rule does not remove it.
    % Definition end-collision: eventStart > trialStart && eventEnd > trialEnd && eventStart < trialEnd)
    blinkEndCollision = (blinkStart > trStart.') & ...
                        (blinkEnd   > trEnd.')   & ...
                        (blinkStart < trEnd.');
    lostEndCollision  = (lostStart > trStart.') & ...
                        (lostEnd   > trEnd.')   & ...
                        (lostStart < trEnd.');

    % -------------------------------------------------
    % Inside‑mask: any overlap except start‑collision.
    % End‑collision is automatically kept inside because it is NOT a start‑collision.
    blinkInsideMask = blinkOverlap & ~blinkStartCollision;
    lostInsideMask  = lostOverlap  & ~lostStartCollision;

    % -------------------------------------------------
    % Outside‑mask: (never overlaps any trial)  OR  (only a start‑collision)
    blinkOutsideMask = ~any(blinkOverlap,2) | any(blinkStartCollision,2);
    lostOutsideMask  = ~any(lostOverlap,2)  | any(lostStartCollision,2);

    % 7)  Fill the INSIDE cell arrays (per trial)
    for tr = 1:nTrials
        idx = blinkInsideMask(:,tr);                     % blinks belonging to this trial
        insideBlinkStart{tr,sess} = blinkStart(idx);
        insideBlinkEnd{tr,sess}   = blinkEnd(idx);

        idx = lostInsideMask(:,tr);
        insideLostStart{tr,sess} = lostStart(idx);
        insideLostEnd{tr,sess}   = lostEnd(idx);
    end

    % 8)  Store the OUTSIDE events (per gap)
    % % First, collect the indices of all events that are outside
    % outsideBlinkIdx = find(blinkOutsideMask);   % indices (row numbers) in blinkStart/End
    % outsideLostIdx  = find(lostOutsideMask);    % same for lost‑pupil
    % 
    % % Assign for each gap the events whose start lies inside that gap
    % for g = 1:nTrials-1
    %     gapStart = trEnd(g);
    %     gapEnd   = trStart(g+1);
    % 
    %     % Blinks
    %     idx = outsideBlinkIdx( (blinkStart(outsideBlinkIdx) >= gapStart) & ...
    %                            (blinkStart(outsideBlinkIdx) <  gapEnd) );
    %     outsideBlinkStart{g,sess} = blinkStart(idx);
    %     outsideBlinkEnd{g,sess}   = blinkEnd(idx);
    % 
    %     % Lost pupil
    %     idx = outsideLostIdx( (lostStart(outsideLostIdx) >= gapStart) & ...
    %                           (lostStart(outsideLostIdx) <  gapEnd) );
    %     outsideLostStart{g,sess} = lostStart(idx);
    %     outsideLostEnd{g,sess}   = lostEnd(idx);
    % end
    
    % 8)  Store the OUTSIDE events in one cell per session
    outsideBlinkStart{sess} = blinkStart(blinkOutsideMask);
    outsideBlinkEnd{sess}   = blinkEnd(blinkOutsideMask);
    
    outsideLostStart{sess}  = lostStart(lostOutsideMask);
    outsideLostEnd{sess}    = lostEnd(lostOutsideMask);

    % 9)  Inside‑trial numeric statistics
    if ~isempty(blinkStart)
        [nBlink(:,sess), durBlink(:,sess), ~] = intervalOverlap(blinkStart, blinkEnd, trStart, trEnd);
    end
    if ~isempty(lostStart)
        [nLost(:,sess),  durLost(:,sess),  ~] = intervalOverlap(lostStart,  lostEnd,  trStart, trEnd);
    end

    % 10)  Clean‑trial duration (trial minus any event)
    cleanTrialDur(:,sess) = trialDur(:,sess) - (durBlink(:,sess) + durLost(:,sess));

    % 11)  Edge‑trial flag – does a trial start (Fixation Cross Onset) or end (Raction) fall inside any event (blink or lost pupil)?
    allEvtStart = [blinkStart; lostStart];
    allEvtEnd   = [blinkEnd;   lostEnd];
    if ~isempty(allEvtStart)
        % logical matrix (event × trial)
        startsInside = (allEvtStart <= trStart.') & (allEvtEnd >= trStart.');   % TRIAL starts inside an event, but does not end inside
        endsInside   = (allEvtStart <= trEnd.')   & (allEvtEnd >= trEnd.');     % TRIAL ends inside an event, but has not started inside
        edgeTrialFlag(:,sess) = any(startsInside | endsInside,1).';             % single flag per event (start or the end of trial i (in session sess) falls inside any blink or lost‑pupil interval.)
        nEdgeTrials(sess)     = sum(edgeTrialFlag(:,sess));
    else
        edgeTrialFlag(:,sess) = false;   % session has no blinks or lost pupil events  (unlikly)
    end

    % 12)  Between-trial statistics
    % There are (nTrials‑1) gaps: gap i = [ trEnd(i) , trStart(i+1) ]
    % Example: row 1 is the gap between trial 1 and trial 2
    for g = 1:nTrials-1
        gapStart = trEnd(g);
        gapEnd   = trStart(g+1);

        %  blinks that lie completely inside the gap 
        if ~isempty(blinkStart)
            insideIdx = (blinkStart >= gapStart) & (blinkEnd <= gapEnd);
            blinkCountBetween{g,sess} = sum(insideIdx);
            blinkDurBetween{g,sess}   = (blinkEnd(insideIdx) - blinkStart(insideIdx));  % vector of durations
        else
            blinkCountBetween{g,sess} = 0;
            blinkDurBetween{g,sess}   = [];     % empty vector
        end

        %  lost‑pupil intervals completely inside the gap 
        if ~isempty(lostStart)
            insideIdx = (lostStart >= gapStart) & (lostEnd <= gapEnd);
            lostCountBetween{g,sess} = sum(insideIdx);
            lostDurBetween{g,sess}   = (lostEnd(insideIdx) - lostStart(insideIdx));
        else
            lostCountBetween{g,sess} = 0;
            lostDurBetween{g,sess}   = [];
        end
    end

    % 13) Sanity check - All lost pupil and blink event from the beginning (startIdxZero, etc.) 
    % are also included in the end files
    % ---- Blinks ---------------------------------------------------------
    totalBlinkEvents = numel(blinkStart);
    insideBlinkEvents = sum(any(blinkInsideMask,2));   % at least one trial
    outsideBlinkEvents = sum(blinkOutsideMask);       % defined above
    assert(totalBlinkEvents == insideBlinkEvents + outsideBlinkEvents, ...
           'Some blink events are missing!')
    
    % ---- Lost pupil ------------------------------------------------------
    totalLostEvents = numel(lostStart);
    insideLostEvents = sum(any(lostInsideMask,2));
    outsideLostEvents = sum(lostOutsideMask);
    assert(totalLostEvents == insideLostEvents + outsideLostEvents, ...
           'Some lost‑pupil events are missing!')

end   % end of session loop 


clear('idx','tr','nTrials','sess','blinkStart','blinkEnd','lostStart','lostEnd','lostInside','trStart','trEnd', ...
     'allEvtStart','allEvtEnd','startsInside','endsInside','g','gapEnd','gapStart','insideIdx','edgeTrialFlag', ...
     'totalBlinkEvents','insideBlinkEvents','outsideBlinkEvents','totalLostEvents','insideLostEvents','outsideLostEvents');

% Convert the count cells (scalar in every cell) to matrices
blinkCountBetweenMat = cell2mat(blinkCountBetween);   % 87 × 144 numeric matrix
lostCountBetweenMat  = cell2mat(lostCountBetween);

% 14) Statistics
% Sum the duration vectors that are stored in the cells
blinkDurSumMat  = cellfun(@sum, blinkDurBetween);   % 87×144 double  (total blink time per gap)
lostDurSumMat   = cellfun(@sum, lostDurBetween);    % 87×144 double  (total lost‑pupil time per gap)
totalDurBetween = blinkDurSumMat + lostDurSumMat;

% total number of events that occur between trials (summing over all gaps)
totalBlinkBetween = sum(cellfun(@sum, blinkCountBetween));
totalLostBetween  = sum(cellfun(@sum, lostCountBetween));
totalCountBetween = totalBlinkBetween + totalLostBetween;

% 15) Transforming the duration from latencies into milliseconds
% Hz = 500
% xy --> duration in latencies, xy/500 --> from latencies into seconds, s*1000 --> from seconds into milliseconds
function [ms] = latency2ms(x)
    ms = ((x/500)*1000);
end
durBlink        = latency2ms(durBlink);
durLost         = latency2ms(durLost);
trialDur        = latency2ms(trialDur);
cleanTrialDur   = latency2ms(cleanTrialDur);
blinkDurBetween = cellfun(@latency2ms,blinkDurBetween,'UniformOutput',false); 
lostDurBetween  = cellfun(@latency2ms,lostDurBetween,'UniformOutput',false); 
blinkDurSumMat  = latency2ms(blinkDurSumMat);
lostDurSumMat   = latency2ms(lostDurSumMat);
totalDurBetween = latency2ms(totalDurBetween);


% -------------------------------------------------------------------------
%  LOCAL helper: overlap between two sets of intervals
function [nInside,durInside,totalInside] = intervalOverlap(evStart,evEnd,trStart,trEnd)
%   evStart, evEnd : column vectors (numEvents × 1)
%   trStart, trEnd : column vectors (numTrials × 1)
%
%   nInside       – number of events that intersect each trial (numTrials × 1)
%   durInside     – total overlap time per trial  (numTrials × 1)
%   totalInside   – total time of each event that lies inside ANY trial (numEvents × 1)

    % logical matrix (event × trial) – true where the two intervals overlap
    mask = (evEnd > trStart.') & (evStart < trEnd.');

    % number of events that intersect each trial
    nInside = sum(mask,1).';               % column vector

    % start / end of the overlap for every (event,trial) pair
    ovStart = max(evStart, trStart.');
    ovEnd   = min(evEnd,   trEnd.');

    % duration of the overlap (zero where mask==false)
    durPair = (ovEnd - ovStart) .* mask;

    % total overlap duration per trial
    durInside = sum(durPair,1).';          % column vector

    % total overlap duration per event (sum across all trials)
    totalInside = sum(durPair,2);          % column vector
end

fprintf('Computed blinks and lost pupil events for inside and outside trials, and how long they are.\n');

%% Mean and standard deviation of various variables

% ----------------- Blinks - INSIDE trials -----------------------
% number of Blink inside Trial
mean_nBlink = mean(nBlink, "all");   
std_nBlink  = std(nBlink(:));        
sum_nBlink  = sum(nBlink);           
mean_sum_nBlink = mean(sum_nBlink);
std_sum_nBlink  = std(sum_nBlink);

% Duration of Blinks inside trials
sum_durBlink  = sum(durBlink);
mean_durBlink = mean(nonzeros(durBlink));
std_durBlink  = std(nonzeros(durBlink));
mean_sum_durBlink = mean(sum_durBlink, "all");
std_sum_durBlink  = std(sum_durBlink(:));
% Without session 144 -> session 143 and 144 now removed
%col_w144 = [1:143,145:146];
%mean_durBlink_w144 = mean(nonzeros(durBlink(:,col_w144)));
%std_durBlink_w144  = std(nonzeros(durBlink(:,col_w144)));
%mean_sum_durBlink_w144 = mean(sum_durBlink(:,col_w144), "all");
%std_sum_durBlink_w144  = std(reshape(sum_durBlink(:,col_w144),[],1) );

blinkStats = struct( ...
    'sum_nBlink',        sum_nBlink, ...        % amount of blinks in total in the 88 trials
    'mean_nBlink',       mean_nBlink, ...       % mean amount of blinks inside the 88 trials
    'std_nBlink',        std_nBlink, ...        % std of the mean amount of blinks inside of trials
    'mean_sum_nBlink',   mean_sum_nBlink, ...   % mean amount of blinks inside all trials computed over all sessions
    'std_sum_nBlink',    std_sum_nBlink, ...    % std of the mean boe
    'sum_durBlink',      sum_durBlink, ...      % duration (in ms) of each blink inside the trials
    'mean_durBlink',     mean_durBlink, ...     % mean length of a single blink
    'std_durBlink',      std_durBlink, ...      % std of the blink length
    'mean_sum_durBlink', mean_sum_durBlink, ... % mean total amount of blinks inside all trials
    'std_sum_durBlink',  std_sum_durBlink);     % std of the mean above

    % 'excludedCol',       144, ...
    % 'mean_durBlink_without144',     mean_durBlink_w144, ...
    % 'std_durBlink_without144',      std_durBlink_w144, ...
    % 'mean_sum_durBlink_without144', mean_sum_durBlink_w144, ...
    % 'std_sum_durBlink_without144',  std_sum_durBlink_w144

% Show the results
%disp(blinkStats);

% ----------------- Lost Pupil - INSIDE trials -----------------------
% number of Lost Pupil inside Trial
mean_nLost  = mean(nLost, "all");
std_nLost   = std(nLost(:));
sum_nLost  = sum(nLost);
mean_sum_nLost = mean(sum_nLost);
std_sum_nLost  = std(sum_nLost);

% Duration of Lost Pupil inside trials
sum_durLost  = sum(durLost);
mean_durLost = mean(nonzeros(durLost));
std_durLost  = std(nonzeros(durLost));
mean_sum_durLost = mean(sum_durLost, "all");
std_sum_durLost  = std(sum_durLost(:));

lostPupilStats = struct( ...
    'sum_nLost',       sum_nLost, ...
    'mean_nLost',       mean_nLost, ...
    'std_nLost',        std_nLost, ...
    'mean_sum_nLost',   mean_sum_nLost, ...
    'std_sum_nLost',    std_sum_nLost, ...
    'sum_durLost',      sum_durLost, ...
    'mean_durLost',     mean_durLost, ...
    'std_durLost',      std_durLost, ...
    'mean_sum_durLost', mean_sum_durLost, ...
    'std_sum_durLost',  std_sum_durLost);

% Show the results
%disp(lostPupilStats);


% ----------------- Blinks - OUTSIDE trials -----------------------
% number of Blink between trials/ outside of trials
mean_nBlink_out = mean(blinkCountBetweenMat, "all");
std_nBlink_out  = std(blinkCountBetweenMat(:));
sum_nBlink_out  = sum(blinkCountBetweenMat);
mean_sum_nBlink_out = mean(sum_nBlink_out);
std_sum_nBlink_out  = std(sum_nBlink_out);
% Comparison without time between trial 44 and 45 --> row 44
row_w44 = [1:43,45:87];
mean_nBlinks_out_44 = mean(blinkCountBetweenMat(44,:)); % The time between trial 44 and 45 is the big selfpaced break between blocks
std_nBlinks_out_44 = std(blinkCountBetweenMat(44,:));
blinkCountBetween_w44 = blinkCountBetweenMat(row_w44,:);
mean_nBlinks_out_w44 = mean(blinkCountBetween_w44,'all'); % The time between trial 44 and 45 is the big selfpaced break between blocks
std_nBlinks_out_w44 = std(blinkCountBetween_w44(:));

% Duration of Blinks outside trials
sum_durBlink_out  = sum(blinkDurSumMat);
mean_durBlink_out = mean(cell2mat( reshape(blinkDurBetween, [], 1) ));
std_durBlink_out  = std(cell2mat( reshape(blinkDurBetween, [], 1) ));
mean_sum_durBlink_out = mean(sum_durBlink_out, "all");
std_sum_durBlink_out  = std(sum_durBlink_out(:));

%helper = cell2mat( reshape(blinkDurBetween(row_w44,:), [], 1) );

blinkStats_Outside = struct( ...
    'sum_nBlink_out',        sum_nBlink_out, ...
    'mean_nBlink_out',       mean_nBlink_out, ...
    'std_nBlink_out',        std_nBlink_out, ...
    'mean_sum_nBlink_out',   mean_sum_nBlink_out, ...
    'std_sum_nBlink_out',    std_sum_nBlink_out, ...
    'mean_nBlinks_out_44',   mean_nBlinks_out_44, ...
    'std_nBlinks_out_44',    std_nBlinks_out_44, ...
    'mean_nBlinks_out_w44',  mean_nBlinks_out_w44, ...
    'std_nBlinks_out_w44',   std_nBlinks_out_w44, ...
    'sum_durBlink_out',      sum_durBlink_out, ...
    'mean_durBlink_out',     mean_durBlink_out, ...
    'std_durBlink_out',      std_durBlink_out, ...
    'mean_sum_durBlink_out', mean_sum_durBlink_out, ...
    'std_sum_durBlink_out',  std_sum_durBlink_out);

% Show the results
%disp(blinkStats_Outside);

% ----------------- Lost Pupil - OUTSIDE trials -----------------------
% number of lost pupil outside Trial
mean_nLost_out  = mean(lostCountBetweenMat, "all");
std_nLost_out   = std(lostCountBetweenMat(:));
mean_sum_nLost_out = mean(totalLostBetween);
std_sum_nLost_out  = std(totalLostBetween);

% Duration of lost pupil outside trials
sum_durLost_out  = sum(lostDurSumMat);
mean_durLost_out = mean(cell2mat( reshape(lostDurBetween, [], 1) ));
std_durLost_out  = std(cell2mat( reshape(lostDurBetween, [], 1) ));
mean_sum_durLost_out = mean(sum_durLost_out, "all");
std_sum_durLost_out  = std(sum_durLost_out(:));

lostPupilStats_Outside = struct( ...
    'mean_nLost_out',       mean_nLost_out, ...
    'std_nLost_out',        std_nLost_out, ...
    'mean_sum_nLost_out',   mean_sum_nLost_out, ...
    'std_sum_nLost_out',    std_sum_nLost_out, ...
    'sum_durLost_out',      sum_durLost_out, ...
    'mean_durLost_out',     mean_durLost_out, ...
    'std_durLost_out',      std_durLost_out, ...
    'mean_sum_durLost_out', mean_sum_durLost_out, ...
    'std_sum_durLost_out',  std_sum_durLost_out);

% Show the results
%disp(lostPupilStats_Outside);

% ----------------- Trial Duration -----------------------
uncleanTrialDur  = trialDur - cleanTrialDur;  % The amount of ms that is cut out in each trial because of blinks or lost pupil
mean_rawTrialDur = mean(trialDur(:), 'omitnan');
std_rawTrialDur  = std(trialDur(:), 'omitnan');
min_rawTrialDur  = min(trialDur,[], 'all', 'omitnan');
max_rawTrialDur  = max(trialDur,[], 'all', 'omitnan');
mean_cleanTrialDur = mean(cleanTrialDur(:), 'omitnan');
std_cleanTrialDur  = std(cleanTrialDur(:), 'omitnan');
min_cleanTrialDur  = min(cleanTrialDur,[], 'all', 'omitnan');
max_cleanTrialDur  = max(cleanTrialDur,[], 'all', 'omitnan');

% session 143 and 144 removed
% cleanTrialDurNo144 = cleanTrialDur(:, setdiff(1:size(cleanTrialDur,2),144));
% cleanTrialDurNo144 = cleanTrialDurNo144(:);
% cleanTrialDurNo144 = cleanTrialDurNo144(~isnan(cleanTrialDurNo144));

% mean_cleanTrialDurNo144 = mean(cleanTrialDurNo144(:), 'omitnan');
% std_cleanTrialDurNo144  = std(cleanTrialDurNo144(:), 'omitnan');
% min_cleanTrialDurNo144  = min(cleanTrialDurNo144,[], 'all', 'omitnan');
% max_cleanTrialDurNo144  = max(cleanTrialDurNo144,[], 'all', 'omitnan');

mean_uncleanTrialDur = mean(uncleanTrialDur(:), 'omitnan');
std_uncleanTrialDur  = std(uncleanTrialDur(:), 'omitnan');
min_uncleanTrialDur  = min(uncleanTrialDur,[], 'all', 'omitnan');
max_uncleanTrialDur  = max(uncleanTrialDur,[], 'all', 'omitnan');

% uncleanTrialDurNo144 = uncleanTrialDur(:, setdiff(1:size(cleanTrialDur,2),144));
% uncleanTrialDurNo144 = uncleanTrialDurNo144(:);
% uncleanTrialDurNo144 = uncleanTrialDurNo144(~isnan(cleanTrialDurNo144));

% mean_uncleanTrialDurNo144 = mean(uncleanTrialDurNo144(:), 'omitnan');
% std_uncleanTrialDurNo144  = std(uncleanTrialDurNo144(:), 'omitnan');
% min_uncleanTrialDurNo144  = min(uncleanTrialDurNo144,[], 'all', 'omitnan');
% max_uncleanTrialDurNo144  = max(uncleanTrialDurNo144,[], 'all', 'omitnan');

trialDurationStats = struct( ...
    'mean_rawTrialDur',          mean_rawTrialDur, ...
    'std_rawTrialDur',           std_rawTrialDur, ...
    'min_rawTrialDur',           min_rawTrialDur, ...
    'max_rawTrialDur',           max_rawTrialDur, ...
    'mean_cleanTrialDur',        mean_cleanTrialDur, ...
    'std_cleanTrialDur',         std_cleanTrialDur, ...
    'min_cleanTrialDur',         min_cleanTrialDur, ...
    'max_cleanTrialDur',         max_cleanTrialDur, ...
    'mean_uncleanTrialDur',      mean_uncleanTrialDur, ...
    'std_uncleanTrialDur',       std_uncleanTrialDur, ...
    'min_uncleanTrialDur',       min_uncleanTrialDur, ...
    'max_uncleanTrialDur',       max_uncleanTrialDur);
    % 'mean_cleanTrialDurNo144',   mean_cleanTrialDurNo144, ...
    % 'std_cleanTrialDurNo144',    std_cleanTrialDurNo144, ...
    % 'min_cleanTrialDurNo144',    min_cleanTrialDurNo144, ...
    % 'max_cleanTrialDurNo144',    max_cleanTrialDurNo144, ...
    % 'mean_uncleanTrialDurNo144', mean_uncleanTrialDurNo144, ...
    % 'std_uncleanTrialDurNo144',  std_uncleanTrialDurNo144, ...
    % 'min_uncleanTrialDurNo144',  min_uncleanTrialDurNo144, ...
    % 'max_uncleanTrialDurNo144',  max_uncleanTrialDurNo144

%disp(trialDurationStats);

% % Plots blinks and lost pupil values inside and outside
% % -------------------- Blinks - INSIDE trials -------------------------------
% % Amount of blinks per Trial
% figure;
% histogram(nBlink(:,:));
% xlabel("Amount of blinks per Trial");
% title("Amount of blinks per Trial (inside Trial)");
% grid on;
% % Amount of blinks per Session
% figure;
% bar(sum_nBlink(end,:),YDataSource = 'sum_nBlink(end,:)');
% yline( mean_sum_nBlink, 'r--', sprintf('                   Mean = %.2f',mean_sum_nBlink), ...
%        'LineWidth',1.5, 'LabelHorizontalAlignment','left', ...
%        'LabelVerticalAlignment','bottom' );
% ylabel("Amount of blinks per Session");
% xlabel("Session")
% title("Amount of blinks per Session (inside trial)");
% linkdata on;
% grid on;
% % Summarized duration of all blinks per Session in milliseconds
% figure;
% bar(sum_durBlink(end,:),YDataSource = 'sum_durBlink(end,:)');
% linkdata on;
% ylabel("Summarized duration of all blinks [ms]");
% xlabel("Session")
% title("Summarized duration of all blinks per Session in milliseconds (inside Trial)");
% grid on;
% % Summarized duration of all blinks per Session in milliseconds - WITHOUT Session 144
% % figure
% % bar(sum_durBlink(end,[1:143,145:end]),YDataSource = 'sum_durBlink(end,[1:143,145:end])'); % without session 144
% % yline( mean_sum_durBlink_w144, 'r--', sprintf('                                                       Mean = %.2f',mean_sum_durBlink_w144), ...
% %        'LineWidth',1.5, 'LabelHorizontalAlignment','left', ...
% %        'LabelVerticalAlignment','top' );
% % linkdata on;
% % ylabel("Summarized duration of all blinks [ms]");
% % xlabel("Session")
% % title("Summarized duration of all blinks per Session in milliseconds - WITHOUT Session 144");
% % grid on;
% % Distribution of blink duration
% figure
% histogram(nonzeros(durBlink));
% ylabel("Amount of Blinks");
% xlabel("Milliseconds")
% title("Distribution of blink duration (inside trial)");
% grid on;
% % Distribution of blink duration - WITHOUT session 144
% % figure
% % histogram(nonzeros(durBlink(:,[1:143,145:end])));
% % ylabel("Amount of Blinks");
% % xlabel("Milliseconds")
% % title("Distribution of blink duration - WITHOUT session 144");
% % grid on;
% 
% % Plots
% % -------------------- Blinks - OUTSIDE trials -------------------------------
% % Amount of blinks per Trial
% figure;
% histogram(blinkCountBetweenMat(:,:));
% xlabel("Amount of blinks between trials");
% title("Amount of blinks between trials (outside)");
% grid on;
% % Amount of blinks per Session
% figure;
% bar(sum_nBlink_out(end,:),YDataSource = 'sum_nBlink_out(end,:)');
% yline( mean_sum_nBlink_out, 'r--', sprintf('                                                              Mean = %.2f',mean_sum_nBlink_out), ...
%        'LineWidth',1.5, 'LabelHorizontalAlignment','left', ...
%        'LabelVerticalAlignment','bottom' );
% ylabel("Amount (counts)");
% xlabel("Session")
% title("Amount of blinks outside trials per Session");
% linkdata on;
% grid on;
% % Summarized duration of all blinks per Session in milliseconds
% figure;
% bar(sum_durBlink_out(end,:),YDataSource = 'sum_durBlink_out(end,:)');
% yline( mean_sum_durBlink_out, 'r--', sprintf('                                                              Mean = %.2f',mean_sum_durBlink_out), ...
%        'LineWidth',1.5, 'LabelHorizontalAlignment','left', ...
%        'LabelVerticalAlignment','top' );
% linkdata on;
% ylabel("Summarized duration [ms]");
% xlabel("Session")
% title("Summarized duration of all blinks OUTSIDE trials per Session in milliseconds");
% grid on;
% 
% % Distribution of blink duration
% figure
% histogram(cell2mat( reshape(blinkDurBetween, [], 1) ));
% ylabel("Amount of blinks");
% xlabel("Milliseconds")
% title("Distribution of blink duration outside trials");
% grid on;
% 
% % ------------------- Lost Pupil - OUTSIDE trials ------------------------------
% % Amount of lost pupil events per Trial
% figure;
% histogram(lostCountBetweenMat(:,:));
% xlabel("Amount of lost pupil events between trials");
% title("Amount of lost pupil events between trials (outside)");
% grid on;
% % Amount of lost pupil events per Session
% figure;
% bar(totalLostBetween(:),YDataSource = 'totalLostBetween(:)');
% yline( mean_sum_nLost_out, 'r--', sprintf('         Mean = %.2f',mean_sum_nLost_out), ...
%        'LineWidth',1.5, 'LabelHorizontalAlignment','left', ...
%        'LabelVerticalAlignment','top' );
% ylabel("Amount of lost pupil events (Count)");
% xlabel("Session")
% title("Amount of lost pupil events outside of trials per Session");
% linkdata on;
% grid on;
% % Summarized duration of all lost pupil events per Session in milliseconds
% figure;
% bar(sum_durLost_out(:),YDataSource = 'sum_durLost_out(:)');
% yline( mean_sum_durLost_out, 'r--', sprintf('       Mean = %.2f',mean_sum_durLost_out), ...
%        'LineWidth',1.5, 'LabelHorizontalAlignment','left', ...
%        'LabelVerticalAlignment','top' );
% linkdata on;
% ylabel("Summarized duration [ms]");
% xlabel("Session")
% title("Summarized duration of all lost pupil events outside of trials per Session in milliseconds");
% grid on;
% % Distribution of lost pupil event duration
% figure
% histogram(cell2mat( reshape(lostDurBetween, [], 1) ));
% ylabel("Amount of lost pupil event");
% xlabel("Milliseconds")
% title("Distribution of lost pupil event duration outside of trials");
% grid on;
% 
% % ------------------- Lost Pupil - INSIDE trials ------------------------------
% % Amount of lost pupil events per Trial
% figure;
% histogram(nLost(:,:));
% xlabel("Amount of lost pupil events per Trial");
% title("Amount of lost pupil events per Trial (inside)");
% grid on;
% % Amount of lost pupil events per Session
% figure;
% bar(sum_nLost(end,:),YDataSource = 'sum_nLost(end,:)');
% yline( mean_sum_nLost, 'r--', sprintf('         Mean = %.2f',mean_sum_nLost), ...
%        'LineWidth',1.5, 'LabelHorizontalAlignment','left', ...
%        'LabelVerticalAlignment','bottom' );
% ylabel("Amount of lost pupil events per Session");
% xlabel("Session")
% title("Amount of lost pupil events per Session");
% linkdata on;
% grid on;
% 
% % Summarized duration of all lost pupil events per Session in milliseconds
% figure;
% bar(sum_durLost(end,:),YDataSource = 'sum_durLost(end,:)');
% yline( mean_sum_durLost, 'r--', sprintf('       Mean = %.2f',mean_sum_durLost), ...
%        'LineWidth',1.5, 'LabelHorizontalAlignment','left', ...
%        'LabelVerticalAlignment','top' );
% linkdata on;
% ylabel("Summarized duration of all lost pupil events [ms]");
% xlabel("Session")
% title("Summarized duration of all lost pupil events per Session in milliseconds");
% grid on;
% 
% % Distribution of lost pupil event duration
% figure
% histogram(nonzeros(durLost));
% ylabel("Amount of lost pupil event");
% xlabel("Milliseconds")
% title("Distribution of lost pupil event duration");
% grid on;
% 
% % ----------------------- Clean vs Raw trial duration ------------------------
% %  1)  Remove NaNs and reshape matrices to column vectors
% % raw trial durations (all sessions)
% rawVals   = trialDur(:);
% rawVals   = rawVals(~isnan(rawVals));
% 
% % clean trial durations (all sessions)
% cleanVals = cleanTrialDur(:);
% cleanVals = cleanVals(~isnan(cleanVals));
% 
% 
% %  2)  Define common bin edges – fixed width of 50 units
% % Determine the global min and max across the three data sets
% % globalMin = min([rawVals; cleanVals; cleanTrialDurNo144]);
% % globalMax = max([rawVals; cleanVals; cleanTrialDurNo144]);
% 
% % Session 143 and 144 were removed
% globalMin = min([rawVals; cleanVals]);
% globalMax = max([rawVals; cleanVals]);
% 
% 
% % Create edges that start at the nearest lower multiple of 50 and end at a
% % multiple of 50 that is >= globalMax
% edgeStart = floor(globalMin/50)*50;
% edgeEnd   = ceil (globalMax/50)*50;
% edges = edgeStart : 50 : edgeEnd;   % bin width = 50
% 
% %  3)  Plot the three overlapping histograms (counts)
% figure('Color','w');               % white background
% grid on;
% hold on;
% 
% % a) raw trial durations 
% hRaw = histogram(rawVals, edges, ...
%     'FaceColor',[0.2 0.6 0.9], ... % blue
%     'EdgeColor','none', ...
%     'FaceAlpha',0.5);              % 50 % transparent
% 
% % b) clean trial durations (all sessions) 
% hCleanAll = histogram(cleanVals, edges, ...
%     'FaceColor',[0.9 0.3 0.2], ... % orange‑red
%     'EdgeColor','none', ...
%     'FaceAlpha',0.5);
% 
% % Session 143 and 144 were removed
% % % c) clean trial durations without session 144 
% % hCleanNo144 = histogram(cleanTrialDurNo144, edges, ...
% %     'FaceColor',[0.4 0.8 0.4], ... % green
% %     'EdgeColor','none', ...
% %     'FaceAlpha',0.5);
% 
% %  4)  Compute means (ignoring NaNs) and plot vertical lines
% meanRaw        = mean(rawVals,       'omitnan');
% meanCleanAll   = mean(cleanVals,     'omitnan');
% %meanCleanNo144 = mean(cleanTrialDurNo144,'omitnan');  % Session 143 and 144 were removed
% 
% % Get current y‑limits (in counts) so the lines reach the top of the plot
% yl = ylim;
% 
% % vertical lines: raw (blue), clean all (red), clean without 144 (green)
% plot([meanRaw        meanRaw],        [0 yl(2)], 'b--', 'LineWidth',2);
% plot([meanCleanAll   meanCleanAll],   [0 yl(2)], 'r--', 'LineWidth',2);
% %plot([meanCleanNo144 meanCleanNo144], [0 yl(2)], 'g--', 'LineWidth',2);   % Session 143 and 144 were removed
% 
% %  5)  Finish the figure (labels, legend, grid)
% xlabel('Trial duration (milliseconds)');   
% ylabel('Number of trials (count)');
% title('Raw vs. Clean trial durations (bin width = 50)');
% 
% legend({ ...
%     'Raw trial duration', ...
%     'Clean trial duration (all sessions)', ...
%     sprintf('Mean raw = %.2f',meanRaw), ...
%     sprintf('Mean clean (all) = %.2f',meanCleanAll)}, ...
%     'Location','best')
% 
% grid on;
% box on;
% hold off;
% 
% % unclean trial duration
% figure
% histogram(uncleanTrialDur(:,:));
% xlabel("Milliseconds");
% ylabel('Number of trials (count)');
% title("Time duration removed from trials because of blinks or lost pupil events");
% grid on;
% box on;
% hold off;
% 
% % figure
% % histogram(uncleanTrialDurNo144(:,:));
% % xlabel("Milliseconds");
% % ylabel('Number of trials (count)');
% % title("Time duration removed from trials because of blinks or lost pupil events - WITHOUT session 144");
% % grid on;
% % box on;
% % hold off;

%% Relation between the interpolated data and inside trial events
% Plot comparing residuals with filtered data.
figure('Name','Interpolated data and inside trial artifacts','NumberTitle','off');

% 2) Blink time inside trials (ms)
blinkTime   = blinkStats.sum_durBlink(:);   % column vector

% 3) Lost‑pupil time inside trials (ms)
lostTime    = lostPupilStats.sum_durLost(:);% column vector

hold on;
% 1) Filtered + Artifacts to 0 
bar(nArtefactsMS,'BarWidth',1,'FaceColor',[0 0.447 0.741]);   % in ms, color blue

stackData = [blinkTime, lostTime];          % nSessions × 2 matrix               % shift right
bar(stackData, 'stacked', 'BarWidth',1);
hold off;

% Cosmetics
xlabel('Session','FontSize',12);
ylabel('Time (ms)','FontSize',12);
title('Comparison: Inside trial artefacts duration vs. duration of all interpolated artefacts','FontSize',14);
grid on;

% X‑ticks – show every 10th one
xticks = 0:10:nSessions;
set(gca,'XTick',xticks,'FontSize',10);

% Legend – order must match the plotted objects
legend({'Interpolated Artefacts','Blinks (in‑trial)','Lost pupil (in‑trial)'}, ...
       'Location','best');

%% Clearing of the blinks and lost pupil variabels
% Clear blink inside variables
clear('sum_nBlink','mean_nBlink','std_nBlink','mean_sum_nBlink','std_sum_nBlink', ...
      'sum_durBlink','mean_durBlink','std_durBlink','mean_sum_durBlink','std_sum_durBlink','excludedCol', ...
      'mean_durBlink_w144','std_durBlink_w144','mean_sum_durBlink_w144','std_sum_durBlink_w144');

% Clear lost pupil inside varibales
clear('sum_nLost','mean_nLost','std_nLost','mean_sum_nLost','std_sum_nLost','mean_durLost', ...
      'sum_durLost','std_durLost','mean_sum_durLost','std_sum_durLost');

% Clear blink outside variables
clear('row_w44','sum_nBlink_out','mean_nBlink_out','std_nBlink_out','mean_sum_nBlink_out','std_sum_nBlink_out', ...
      'mean_nBlinks_out_44','std_nBlinks_out_44','mean_nBlinks_out_w44','std_nBlinks_out_w44', ...
      'sum_durBlink_out','mean_durBlink_out','std_durBlink_out','mean_sum_durBlink_out','std_sum_durBlink_out');

% Clear lost pupil outside variables
clear('mean_nLost_out','std_nLost_out','mean_sum_nLost_out','std_sum_nLost_out', ...
      'sum_durLost_out','mean_durLost_out','std_durLost_out','mean_sum_durLost_out','std_sum_durLost_out');

% Clear trial duration variables
clear('mean_rawTrialDur','std_rawTrialDur','min_rawTrialDur','max_rawTrialDur', ... 
      'mean_cleanTrialDur','std_cleanTrialDur','min_cleanTrialDur','max_cleanTrialDur', ...
      'mean_cleanTrialDurNo144','std_cleanTrialDurNo144','min_cleanTrialDurNo144','max_cleanTrialDurNo144', ...
      'mean_uncleanTrialDur','std_uncleanTrialDur','min_uncleanTrialDur','max_uncleanTrialDur', ...
      'mean_uncleanTrialDurNo144','std_uncleanTrialDurNo144','min_uncleanTrialDurNo144','max_uncleanTrialDurNo144');


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   SACCADES   %%%%%%%%%%%%%555555555555%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Saccades inside Trials 
% For unfold we want only to figure out the changes in pupil size inside
% the trials that are based on saccade preparations.

% pre-allocade output
insideLatencySaccadeOnset = cell(1,nSessions);  
insideLatencySaccadeOffset = cell(1,nSessions);

for sess = 1:nSessions
    % all trial start and end values for this session
    trStart = latencyFixationCrossOnset(:,sess);   % 88×1
    trEnd   = latencyReaction(:,sess)+1;

    % saccade‑onset latencies for this session 
    valsOn = latencySaccadeOnset{sess};              % vector (any length, may be empty(in theory))
    valsOff = latencySaccadeOffset{sess};       

    % If there are no saccades in this session we can skip the test (unrealistic)
    if isempty(valsOn)
        insideLatencySaccadeOnset{sess} = [];      % keep empty
        continue;
    end

    % Testing each latency against ALL trials 
    % Goal: logical vector L (size = numVals×1), where
    %       L(i) = true  if  there exists at least one trial j such that
    %       trStart(j) < vals(i) < trEnd(j)

    % The expression (vals(:) > trStart.') builds an (numVals × nTrials) matrix:
    %   row i  → comparison of vals(i) with every trial start
    %   column j → comparison with trial j
    insideMask = any( (valsOn(:) > trStart.') & (valsOn(:) < trEnd.'), 2 );

    % Keep only the "inside" latencies
    insideLatencySaccadeOnset{sess} = valsOn(insideMask);
    insideLatencySaccadeOffset{sess} = valsOff(insideMask);    % keep all Offset values, for the Onset values inside trials
end

% Keep only unique values for marking in the event file
insideLatencySaccadeOnset = cellfun(@(v) unique(v,'stable'), insideLatencySaccadeOnset, 'UniformOutput', false);

clear('sess','valsOn', 'valsOff','insideMask','trStart','trEnd')

%% Frame side deciding saccade
% Storing the saccade, which is the first one following after picture Onset
% --> decides the frame side 

% Window = The time from PictureOnset until FirstFixation

% get size
[nTrials, ~] = size(latencyPictureOnset);   % 88 × 144

% 1) Pre-Allocations
% Pre-Allocation of Output structure
saccadeInWindow = struct('picture',      cell(nTrials,nSessions), ...
                         'onset',        cell(nTrials,nSessions), ...
                         'offset',       cell(nTrials,nSessions), ...
                         'n_saccade',    zeros(nTrials,nSessions), ...
                         'firstFix',     cell(nTrials,nSessions), ...
                         'durPic2OnMs',  zeros(nTrials,nSessions), ...
                         'durSaccadeMs', zeros(nTrials,nSessions), ...
                         'durOff2FixMs', zeros(nTrials,nSessions));

% Pre-Allocation of storage containers:
%   Storing the Onset values of all frame side deciding saccadeOnset
%   Each cell: 1 coloumn and 88 rows (for each trial one value)
frameDecidingSaccadeOnset = cell(1, nSessions);
%   Storing the trial numbers of the trials, that have NO inWindow Saccade (n==0)
trialsWithoutSaccade = cell(1, nSessions);
%   Storing the trial numbers of the trials, that have a saccade duration of 0 (durSaccadeMs==0)
trialsWithSacDur0 = cell(1, nSessions);


% 2) Create the saccadeInWindow Structure
for sess = 1:nSessions      % loop over sessions
    
    % saccade vector of the session
    onVec = latencySaccadeOnset{sess}(:);
    offVec = latencySaccadeOffset{sess}(:);
    % Sanity check: they must have the same length
    assert(numel(onVec) == numel(offVec), sprintf('On/offset length mismatch in session %d.',sess));

    % For safty (highly unlikly):
    % If the session contains no saccades, skip the session – everything stays empty
    if isempty(onVec)
        continue;
    end

    for trial = 1:nTrials          % loop over trials
        winStart = latencyPictureOnset(trial,sess);
        winEnd   = latencyFirstFixation(trial,sess);
        
        % Trials with NaN  for pictureOnset and FirstFixation
        if isnan(winStart) || isnan(winEnd)
            % keep the pre‑allocated empty fields
            saccadeInWindow(trial,sess).picture      = NaN;
            saccadeInWindow(trial,sess).onset        = [];
            saccadeInWindow(trial,sess).offset       = [];
            saccadeInWindow(trial,sess).n_saccade    = NaN;
            saccadeInWindow(trial,sess).firstFix     = NaN;
            saccadeInWindow(trial,sess).durPic2OnMs  = [];
            saccadeInWindow(trial,sess).durSaccadeMs = [];
            saccadeInWindow(trial,sess).durOff2FixMs = [];
            continue;   % go to next trial
        end
    
        % Logical mask: Which saccade(s) belong(s) to this trial?
        mask = (winStart < onVec) & (offVec < winEnd);
        
        % Store the results (could be 0, 1 or >1 rows)
        saccadeInWindow(trial,sess).picture      = winStart;
        saccadeInWindow(trial,sess).onset        = onVec(mask);
        saccadeInWindow(trial,sess).offset       = offVec(mask);
        saccadeInWindow(trial,sess).n_saccade    = sum(mask);
        saccadeInWindow(trial,sess).firstFix     = winEnd;
        saccadeInWindow(trial,sess).durPic2OnMs  = (((onVec(mask) - winStart) - 1) / 500) * 1000;
        saccadeInWindow(trial,sess).durSaccadeMs = (((offVec(mask) - onVec(mask)) - 1) / 500) * 1000;
        saccadeInWindow(trial,sess).durOff2FixMs = (((winEnd - offVec(mask)) - 1) / 500) * 1000;
    end
end

% 3) Calculate the additional values
for sess = 1:nSessions
    % 3.1  Gathering the SaccadeOnset vectors for all trials of this session
    onsetCell = {saccadeInWindow(:, sess).onset};   % 1×nTrials cell
    
    % store the whole cell‑array inside the 1×nSessions container
    frameDecidingSaccadeOnset{sess} = onsetCell';    
    
    % 3.2  Identifing trials with zero in‑window saccades (n == 0)
    nVec = [saccadeInWindow(:, sess).n_saccade];  % numeric vector length nTrials
    zeroN_Idx = find(nVec == 0);                  % trial numbers (row indices)
    trialsWithoutSaccade{sess} = zeroN_Idx; 

    % 3.3  Identifing trials with saccade duration of 0 ms (durSaccadeMs == 0)
    durCell = {saccadeInWindow(:, sess).durSaccadeMs};  % keeps the empty cells
    durVec = cellfun(@empty2nan, durCell);              % [] → NaN, numbers stay
    zeroDur_Idx = find(durVec == 0);                    % real trial numbers (row indices)
    trialsWithSacDur0{sess} = zeroDur_Idx;
end

clear sess trial nTrials winStart winEnd mask onsetCell nVec zeroN_Idx durVec ...
    zeroDur_Idx offVec onVec

% fprintf('Finished. Summary per session:\n');
% for sess = 1:nSessions
%     nTrialsWithZero = sum([saccadeInWindow(:,sess).n] == 0);
%     nTrialsWithMany = sum([saccadeInWindow(:,sess).n] > 1);
%     fprintf('  Session %3d – %2d trials empty, %2d trials with >1 saccade.\n', ...
%         sess, nTrialsWithZero, nTrialsWithMany);
% end

% Helper function: Trnasforms empty cells to NaN
function y = empty2nan(x)
    % Convert [] → NaN, keep numeric values unchanged
    if isempty(x)
        y = NaN;
    else
        y = x;
    end
end

fprintf('Frame deciding saccade is stored.\n');

%% Summary statistics frame side deciding saccade
% Compute and store summary statistics of the frame side deciding saccade in a structure

% Function collectNumeric:
%  extracts the requested field from every element of saccadeInWindow
%  removes empty cells (trials without an in‑window saccade)
%  concatenates the remaining numeric vectors into ONE column vector
function vec = collectNumeric(saccadeStruct, fld)
    % Return a column vector that contains all numeric values of the given field
    C    = {saccadeStruct.(fld)};                % 1×N cell array
    mask = ~cellfun('isempty', C);                % keep only non‑empty cells
    vec  = cat(1, C{mask});                       % concatenate numbers
end
    
% Three (long) vectors that hold all duration values (of all trials)
allPic2OnMs  = collectNumeric(saccadeInWindow,'durPic2OnMs');   % picture → saccade onset
allSaccDurMs = collectNumeric(saccadeInWindow,'durSaccadeMs');  % saccade onset → offset
allOff2FixMs = collectNumeric(saccadeInWindow,'durOff2FixMs');   % offset → first fixation

% Storing the statstical results in the 'durationStatsframeSaccade' Structure
durationStatsFrameSaccade.PicOn2SaccOn.mean = mean(allPic2OnMs);
durationStatsFrameSaccade.PicOn2SaccOn.std  = std (allPic2OnMs);
durationStatsFrameSaccade.PicOn2SaccOn.min  = min (allPic2OnMs);
durationStatsFrameSaccade.PicOn2SaccOn.max  = max (allPic2OnMs);

durationStatsFrameSaccade.SaccadeDur.mean = mean(allSaccDurMs);
durationStatsFrameSaccade.SaccadeDur.std  = std (allSaccDurMs);
durationStatsFrameSaccade.SaccadeDur.min  = min (allSaccDurMs);
durationStatsFrameSaccade.SaccadeDur.max  = max (allSaccDurMs);

durationStatsFrameSaccade.SaccOff2FirstFix.mean = mean(allOff2FixMs);
durationStatsFrameSaccade.SaccOff2FirstFix.std  = std (allOff2FixMs);
durationStatsFrameSaccade.SaccOff2FirstFix.min  = min (allOff2FixMs);
durationStatsFrameSaccade.SaccOff2FirstFix.max  = max (allOff2FixMs);

% Plots
% figure;
% histogram(allPic2OnMs(:,end));
% xlabel("Milliseconds");
% ylabel("Amount");
% title("Duration distribution of the time between Picture Onset and Saccade Onset");
% grid on;
% 
% figure;
% histogram(allSaccDurMs(:,end));
% xlabel("Milliseconds");
% ylabel("Amount");
% title("Duration distribution of the frame side deciding Saccade");
% grid on;
% 
% figure;
% histogram(allOff2FixMs(:,end));
% xlabel("Milliseconds");
% ylabel("Amount");
% title("Duration distribution of the time between Saccade Offset and First Fixation");
% grid on;

fprintf('Summary statistics of frame side deciding saccade are stored.\n');

%% Saccade duration (all saccades)

% All saccades
saccadeDurationAll = cell(1,nSessions);       % pre‑allocate output

for sess = 1:nSessions
    onset  = latencySaccadeOnset{sess};
    offset = latencySaccadeOffset{sess};

    % make them column vectors (more tidy)
    onset  = onset(:);
    offset = offset(:);

    % length check for safty
    if isempty(onset) || isempty(offset)
        saccadeDurationAll{sess} = [];        % nothing to compute
        continue;
    end

    % keep only the pairs that actually exist (onset and offset should have
    % the same length, so this is also for safty)
    nPairs = min(numel(onset),numel(offset));
    saccadeDurationAll{sess} = offset(1:nPairs) - onset(1:nPairs);
end

% Transforming the latencies into milliseconds
saccadeDurationAll = cellfun(@(vec) ((vec-1)*500)/1000 , ...
                            saccadeDurationAll, 'UniformOutput',false);

fprintf('Duration of all saccades are stored.\n');

% Preparing the data for plotting and summary statistics
%  Converting every cell to a column vector (ensures consistent orientation)
tmpCol   = cellfun(@(x) x(:), saccadeDurationAll, 'UniformOutput', false);
%  Concatenating them
allDurations = vertcat(tmpCol{:});   % final big column vector

% Calculating and storing sumary statistics (mean, std, max, min)
durationStatsAllSaccades.mean = mean(allDurations);      % arithmetic mean
durationStatsAllSaccades.std  = std(allDurations);   % 0 → normalizing by N‑1 (sample std)
durationStatsAllSaccades.min  = min(allDurations);
durationStatsAllSaccades.max  = max(allDurations);

% Plots
% % Plot - all values
% figure;
% histogram(allDurations, 'BinWidth', 1);   % choose BinWidth or nBins as you like
% xlabel('Saccade duration (ms)');   % adjust the label to your units
% ylabel("Amount")
% title('Distribution of all saccade durations');
% 
% % Plot - X-axis 0 to 100 ms
% figure;
% histogram(allDurations,'BinWidth',1);   
% xlim([0 100]);                         % limits the x‑axis
% xlabel('Saccade duration (ms)');
% ylabel('Count');
% title('Distribution of all saccade durations (0‑100 ms)');

clear('sess','onset','offset','nPairs','tmpCol','allDurations');

fprintf('Plot of all saccade durations is constructed, mean and std are calculated.\n');

%% Transforming the 1x144 cell structure trialsWithoutSaccade into a logical mask + saving
% % The trials without a valid saccade between Picture Onset and first
% % fixation are invalid trials, because the participants looked already to
% % one side. 
% % Therefore the goal is to create a logical mask out of the data stored in
% % trialsWithoutSaccade, save it and use it when removing invalid trials
% % above
% % CAUTION: DO NOT RUN, when the mask created in here is already used in
% % the removing of invalid trials above. In a second run, no trials without
% % a saccade exist, because they are already removed
% 
% % Pre-allocating a matrix filled with 0
% nTrials = 88;
% noSaccadeMat = zeros(nTrials,nSessions);
% 
% % Fill the matrix
% % All row numbers stored in trialsWithoutSaccade become 1
% for sess = 1:nSessions
%     % trial numbers of the trials without any in-window saccade (for this
%     % session)
%     trialIdx = trialsWithoutSaccade{sess};
% 
%     % If the cell is completly empty, it will be skipped
%     if ~isempty(trialIdx)
%         noSaccadeMat(trialIdx, sess) = 1; % Set the rows to 1
%     end
% end
% 
% % Convert to a logical
% noSaccadeMask = logical(noSaccadeMat);

% % Saving the mask as a file to be used in the removing of invalid trials
% % in the code above
% save ("noSaccadeMask.mat","noSaccadeMask");

% clear sess trialIdx nTrials

%% Transforming the 1x144 cell structure trialsWithSacDur0 into a logical mask + saving
% % The trials with a frame deciding saccade (between Picture Onset and first
% % fixation) duration of 0ms are invalid trials, because the saccade onset
% % and offset are only one sample apart, and to short to be a saccade away
% % from the fixation cross location.
% % Therefore the goal is to create a logical mask out of the data stored in
% % trialsWithSacDur0, save it and use it when removing invalid trials
% % above
% % CAUTION: DO NOT RUN when the mask created in here, is already used in
% % the removing of invalid trials above. In a second run, no trials without
% % a saccade exist, because they are already removed
% 
% % Pre-allocating a matrix filled with 0
% nTrials = 88;
% sacDur0Mat = zeros(nTrials,nSessions);
% 
% % Fill the matrix
% % All row numbers stored in trialsWithSacDur0 become 1
% for sess = 1:nSessions
%     % trial numbers of the trials with a saccade duration of 0 (for this
%     % session)
%     trialIdx = trialsWithSacDur0{sess};
% 
%     % If the cell is completly empty, it will be skipped
%     if ~isempty(trialIdx)
%         sacDur0Mat(trialIdx, sess) = 1; % Set the rows to 1
%     end
% end
% 
% % Convert to a logical
% sacDur0Mask = logical(sacDur0Mat);
% 
% % Saving the mask as a file to be used in the removing of invalid trials
% % in the code above
% save ("saccadeDuration0Mask.mat","sacDur0Mask");
% 
% clear sess trialIdx nTrials sacDur0Mat sacDur0Mask



%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   PREPARATIONS FOR THE EVENT FILE   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Creating Congruency file
% Creating a file, that contains for each trial the information, if it was
% a trial under the Conguent or Incongruent condition
% blockOrder: A = Congruent (44 trials), Incongruent (44 trials); B = Incongruent (44 trials), Congruent (44 trials)
nRowsPerCond = 44;                % 44 Congruent + 44 Incongruent or 44 Inongruent + 44 Congruent= 88 rows
nRowsTotal   = 2 * nRowsPerCond;  % = 88
nCols        = nSessions;         % should be 144

colCong  = repmat({'Congruent'},   nRowsPerCond,1);  % 44×1 cell
colIncon = repmat({'Incongruent'}, nRowsPerCond,1);  % 44×1 cell

% Full pattern for an "A" block
patternA = [colCong; colIncon];   % Congruent → Incongruent
% Full pattern for a "B" block
patternB = [colIncon; colCong];   % Incongruent → Congruent

congruencyCell = cell(nRowsTotal, nCols);   % 88 × 144

for col2 = 1:nCols
    if blockOrder(col2) == "A"          % double quotes for string comparison
        congruencyCell(:,col2) = patternA;
    else                             
        congruencyCell(:,col2) = patternB;
    end
end

% Keep only the valid trials
congruencyCell(finalMask) = {NaN};      

clear ('nRowsPerCond', 'nRowsTotal', 'nCols', 'colCong', 'colIncon', 'patternA', 'patternB', 'col2');

fprintf('Congruency matrix was build.\n');

%% Transforming the values in the valence matrix, into strings
% valence: 0 = negative picture;  1 = positive picture
valenceCell = cell(size(valence));  % Create a matrix in the same size as the original % 88x144
% fill it with the two possible strings 
valenceCell(valence==0) = {'Negative'};   % logical index for all zeros
valenceCell(valence==1) = {'Positive'};   % logical index for all ones
valenceCell(finalMask)  = {NaN};

fprintf('Valence string cell was build.\n');

%% Transforming the values in the side matrix, into strings
% side of the presented frame: 0 = left;  1 = right
sideCell = cell(size(side));  % Create a matrix in the same size as the original % 88x144
% fill it with the two possible strings 
sideCell(side==0)   = {'Left'};    % logical index for all zeros
sideCell(side==1)   = {'Right'};   % logical index for all ones
sideCell(finalMask) = {NaN};

fprintf('Side string cell was build.\n');
fprintf('Preperations for the eventfile are done.\n');

%% Removing values from insideLatencySaccadeOnset 
% % Removing the values from insideLatencySaccadeOnset, which are also 
% % included in frameDecidingSaccadeOnset, to avoid repetition and double marking
% for sess = 1:numel(insideLatencySaccadeOnset)
%     insideVec = insideLatencySaccadeOnset{sess}(:);   % stored as double
%     frameCell = frameDecidingSaccadeOnset{sess};      % stored as cell
%     % Concatenate all inner vectors into ONE numeric column vector for the session
%     frameVec = cat(1, frameCell{:});  
%     frameVec = frameVec(:);      % ensure column orientation
%     % Store only the values in insideLatencySaccadeOnset, that are not
%     % included in frameDecidingSaccadeOnset
%     insideLatencySaccadeOnset{sess} = setdiff(insideVec, frameVec, 'stable');
% end
% 
% clear sess insideVec frameCell frameVec

%% Transform frameDecidingSaccadeOnset from a cell into a double matrix
nTrials = 88;
% Pre‑allocation of a matrix filled with NaN (means "no frame‑deciding saccade")
frameDecidingSacMatrix = NaN(nTrials, nSessions);
for session = 1:nSessions
    innerCell = frameDecidingSaccadeOnset{session};   % 1×nTrials cell

    % Loop over trials only for the sessions that actually contain data
    for tr = 1:numel(innerCell)
        trialVec = innerCell{tr};               % numeric vector (may be empty)
        if ~isempty(trialVec)
            % Store the saccade onset of that trial.
            frameDecidingSacMatrix(tr, session) = trialVec(1);
        end
    end
end

clear session nTrials innerCell trialVec tr

%% ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% ---------------------------   Running EEGLAB and unfold over one session   -------------------------------------------------------------------------------------------
%% ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%
% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   Running EEGLAB   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Building the event file 
% % Index = data sample number
% % Variable - 'Event'
% %  1) latencyFixationCrossOnset (88×144)     - 'Fixation Cross Onset'
% %  2) latencyPictureOnset (88×144)           - 'Picture Onset'
% %  3) latencyFirstFixation (88×144)          - 'First Fixation'
% %  4) latencyFrameOnset (88×144)             - 'Frame Onset'
% %  5) latencyReaction (88×144)               - 'Reaction'
% %  6) insideBlinkStart (88×144 cell)         - 'Inside Blink Start'
% %  7) insideBlinkEnd (88×144 cell)           - 'Inside Blink End'
% %  8) outsideBlinkStart (87×144 cell)        - 'Outside Blink Start'
% %  9) outsideBlinkEnd (87×144 cell)          - 'Outside Blink End'
% % 10) insideLostStart (88×144 cell)          - 'Inside Lost Pupil Start'
% % 11) insideLostEnd (88×144 cell)            - 'Inside Lost Pupil End'
% % 12) outsideLostStart (87×144 cell)         - 'Outside Lost Pupil Start'
% % 13) outsideLostEnd (87×144 cell)           - 'Outside Lost Pupil End'
% % 14) frameDecidingSaccadeOnset (1x144 cell) - 'Frame Saccade Onset'
% 
% % "Event latencies may be in seconds, milliseconds, or samples in the text file, 
% % although they are always stored in EEGLAB in samples." --> Trying out latency
% % order: A = Congruent (44 trials), Incongruent (44 trials); B = Incongruent (44 trials), Congruent (44 trials)
% % Output: Col 1 = latency, Col 2 = type, Col 3 = valence, Col 4 = congruency, Col 5 = side
% 
% % Selecting one specific column (session) of each EVENT variable
% sessEEGLAB = 1;
% 
% colFix   = latencyFixationCrossOnset(:,sessEEGLAB);   % 88×1
% colPic   = latencyPictureOnset(:,sessEEGLAB);         % 88×1
% colFirst = latencyFirstFixation(:,sessEEGLAB);        % 88×1
% colFrame = latencyFrameOnset(:,sessEEGLAB);           % 88×1
% colReact = latencyReaction(:,sessEEGLAB);             % 88×1
% colFrameSacOnset = frameDecidingSacMatrix(:,sessEEGLAB); % 88×1
% % in each session the following variables have a different size
% colInBlinksStart  = (cell2mat(insideBlinkStart(:,sessEEGLAB)));
% colInBlinksEnd    = (cell2mat(insideBlinkEnd(:,sessEEGLAB)));
% colInLostStart    = (cell2mat(insideLostStart(:,sessEEGLAB)));
% colInLostEnd      = (cell2mat(insideLostEnd(:,sessEEGLAB)));
% colOutBlinksStart = (cell2mat(outsideBlinkStart(:,sessEEGLAB)));
% colOutBlinksEnd   = (cell2mat(outsideBlinkEnd(:,sessEEGLAB)));
% colOutLostStart   = (cell2mat(outsideLostStart(:,sessEEGLAB)));
% colOutLostEnd     = (cell2mat(outsideLostEnd(:,sessEEGLAB)));
% 
% allNumbers = vertcat(colFix, colPic, colFirst, colFrame, colReact, ... % 440×1 cell
%     colInBlinksStart, colInBlinksEnd, colInLostStart, colInLostEnd, ...
%     colOutBlinksStart, colOutBlinksEnd, colOutLostStart, colOutLostEnd,...
%     colFrameSacOnset); 
% 
% % Type labes
% lblFix           = repmat({'Fixation Cross Onset'}, numel(colFix),1);
% lblPic           = repmat({'Picture Onset'},        numel(colPic),1);
% lblFirst         = repmat({'First Fixation'},       numel(colFirst),1);
% lblFrame         = repmat({'Frame Onset'},          numel(colFrame),1);
% lblReact         = repmat({'Reaction'},             numel(colReact),1);
% lblInBlinkStart  = repmat({'Inside Blink Start'},   numel(colInBlinksStart),1);
% lblInBlinkEnd    = repmat({'Inside Blink End'},     numel(colInBlinksEnd),1);
% lblInLostStart   = repmat({'Inside Lost Start'},    numel(colInLostStart),1);
% lblInLostEnd     = repmat({'Inside Lost End'},      numel(colInLostEnd),1);
% lblOutBlinkStart = repmat({'Outside Blink Start'}, numel(colOutBlinksStart),1);
% lblOutBlinkEnd   = repmat({'Outside Blink End'},   numel(colOutBlinksEnd),1);
% lblOutLostStart  = repmat({'Outside Lost Start'},  numel(colOutLostStart),1);
% lblOutLostEnd    = repmat({'Outside Lost End'},    numel(colOutLostEnd),1);
% lblFrameSacOnset = repmat({'Frame Saccade Onset'}, numel(colFrameSacOnset),1);
% 
% allTypes = vertcat(lblFix, lblPic, lblFirst, lblFrame, lblReact, ... % 440×1 cell
%    lblInBlinkStart, lblInBlinkEnd, lblInLostStart, lblInLostEnd, ...
%    lblOutBlinkStart, lblOutBlinkEnd, lblOutLostStart, lblOutLostEnd, lblFrameSacOnset);   
% 
% % Empty versions of each variable
% emptyFix           = repmat({[]}, numel(colFix),1);
% %emptyPic          = repmat({[]}, numel(colPic),1);   % not necessary
% emptyFirst         = repmat({[]}, numel(colFirst),1);
% emptyFrame         = repmat({[]}, numel(colFrame),1);
% emptyReact         = repmat({[]}, numel(colReact),1);
% emptyInBlinkStart  = repmat({[]}, numel(colInBlinksStart),1);
% emptyInBlinkEnd    = repmat({[]}, numel(colInBlinksEnd),1);
% emptyInLostStart   = repmat({[]}, numel(colInLostStart),1);
% emptyInLostEnd     = repmat({[]}, numel(colInLostEnd),1);
% emptyOutBlinkStart = repmat({[]}, numel(colOutBlinksStart),1);
% emptyOutBlinkEnd   = repmat({[]}, numel(colOutBlinksEnd),1);
% emptyOutLostStart  = repmat({[]}, numel(colOutLostStart),1);
% emptyOutLostEnd    = repmat({[]}, numel(colOutLostEnd),1);
% emptyFrameSacOnset = repmat({[]}, numel(colFrameSacOnset),1);
% 
% % Valence
% % Should be stored next to Picture Onset, First Fixation, Reaction
% allValence = vertcat(emptyFix, valenceCell(:, sessEEGLAB), valenceCell(:, sessEEGLAB), emptyFrame, valenceCell(:, sessEEGLAB), ...  % 440×1 cell
%     emptyInBlinkStart, emptyInBlinkEnd, emptyInLostStart, emptyInLostEnd, ...
%     emptyOutBlinkStart, emptyOutBlinkEnd, emptyOutLostStart, emptyOutLostEnd, ...
%     emptyFrameSacOnset);
% 
% % Congruency
% % Should be stored next to Picture Onset and Reaction
% allCongruency =  vertcat(emptyFix, congruencyCell(:, sessEEGLAB), emptyFirst, emptyFrame, congruencyCell(:, sessEEGLAB), ... % 440×1 cell
%     emptyInBlinkStart, emptyInBlinkEnd, emptyInLostStart, emptyInLostEnd, ...
%     emptyOutBlinkStart, emptyOutBlinkEnd, emptyOutLostStart, emptyOutLostEnd, ...
%     emptyFrameSacOnset);
% 
% % Side
% % Should be stored next to Picture Onset, First Fixation, Frame Onset and Reaction
% allSide =  vertcat(emptyFix, sideCell(:, sessEEGLAB), sideCell(:, sessEEGLAB), sideCell(:, sessEEGLAB), sideCell(:, sessEEGLAB), ... % 440×1 cell
%     emptyInBlinkStart, emptyInBlinkEnd, emptyInLostStart, emptyInLostEnd, ...
%     emptyOutBlinkStart, emptyOutBlinkEnd, emptyOutLostStart, emptyOutLostEnd, ...
%     emptyFrameSacOnset);
% 
% % Creating one cell array
% %   C(:,1) -> numbers   (type double)
% %   C(:,2) -> strings   (type cell‑string)
% events_unsorted = [allTypes, num2cell(allNumbers), allValence, allCongruency, allSide];   % 440‑by‑4 cell array
% 
% % Sort by the numeric column, keep the strings together 
% % (the whole row is moved to its correct position)
% % All NaN end up at the bottom, after all numbers
% [sortedNums, sortIdx] = sort(allNumbers,'ascend');   % sort indices
% events_sorted = events_unsorted(sortIdx,:);          % re‑order all rows
% 
% % Removing rows containing NaNs
% % Flag every cell that is a NaN (numeric NaN inside a cell)
% isNaNcell = cellfun(@(x) isequaln(x,NaN), events_sorted);   % logical matrix
% % "bad" row = it contains a NaN in any column
% badRow    = any(isNaNcell,2);                     % 2 = dimension (any(A,2) works on successive elements in the rows of A and returns a column vector of logical values.)
% % keep only the rows that are not bad
% events_sorted_clean = events_sorted(~badRow,:);   % keep rows without NaN
% 
% % Creating Table 
% eventTable = cell2table(events_sorted_clean, ...
%     'VariableNames', {'type','latency','valence','congruency','side'});
% 
% % Clean up
% clear ('colFix', 'colPic', 'colFirst', 'colFrame', 'colReact', ...
%     'colInBlinksStart', 'colInBlinksEnd', 'colInLostStart', 'colInLostEnd', ...
%     'colOutBlinksStart', 'colOutBlinksEnd', 'colOutLostStart', 'colOutLostEnd', 'colFrameSacOnset', ...
%     'lblReact','lblFrame','lblFirst','lblPic','lblFix', ...
%     'lblInBlinkStart','lblInBlinkEnd','lblInLostStart','lblInLostEnd', ...
%     'lblOutBlinkStart', 'lblOutBlinkEnd', 'lblOutLostStart', 'lblOutLostEnd', 'lblFrameSacOnset', ...
%     'emptyReact','emptyFrame','emptyFirst','emptyPic','emptyFix', ...
%     'emptyInBlinkStart', 'emptyInBlinkEnd', 'emptyInLostStart', 'emptyInLostEnd', ...
%     'emptyOutBlinkStart', 'emptyOutBlinkEnd', 'emptyOutLostStart', 'emptyOutLostEnd', 'emptyFrameSacOnset', ...
%     'isNaNcell','badRow');
% 
% fprintf('Event file for session %d was build. (TimeVector value based)\n',sessEEGLAB);
% 
% %% EEGLAB
% % path matlab local
% addpath 'C:\Users\gina\Seafile\Cognitive_Science\Bachelor_Thesis\eeglab_current\eeglab2026.0.0'
% % path matlab Online
% % % addpath '/MATLAB Drive/eeglab_current/eeglab2026.0.0'
% 
% eeglab;
% pupilSizeSession = (pupilSizeRightFilt{1,sessEEGLAB})';  % same session as the session for the event file
% 
% %EEG.etc.eeglabvers = '2026.0.0'; % this tracks which version of EEGLAB is being used, you may ignore it
% 
% % Create EEG structure and import pupil size data
% EEG = pop_importdata('dataformat','array','nbchan',1,'data','pupilSizeSession','setname','Pupil Size Right Session 2','srate',500,'pnts',384088,'xmin',0);
% % Import eventfile
% EEG.event = importevent(events_sorted_clean,[],500,'fields',{'type','latency','valence','congruency','side'},'timeunit',NaN);
% 
% %% Plot
% pop_eegplot(EEG, 1, 1, 1);
% x = size(pupilSizeSession); % [1, 338027]
% y = x(1,2);                 % 338027
% clear('x','y');
% 
% fprintf('EEGLAB finished! \n\n');
% 
% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   RUNNING UNFOLD   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fprintf('Starting UNFOLD \n\n');
% 
% addpath 'C:\Users\gina\Seafile\Cognitive_Science\Bachelor_Thesis\unfold-main'
% init_unfold
% 
% %% Preparations
% % Exclude Blink and Lost Pupil artifacts
% % The time during the blinks or lost pupil events are invalid data. 
% % The pupil size can not be measured reliablly ("measuring" 0 or >3000), 
% % therefore these times need to be excluded from the analysis.
% % Relevant events: inside and outside blinks, inside and outside lost pupil
% 
% % 1) Extracting all START-times for the sessEEGLAB
% startBlink = cellfun(@(x) x(:), startIdxZero(:,sessEEGLAB), 'UniformOutput', false);
% startBlink = cat(1, startBlink{:});  % column vector
% startBlink = startBlink - 3;         % 3 samples before the Blink are also excluded (as in the interpolation)
% startLost  = cellfun(@(x) x(:), startIdxLost(:,sessEEGLAB), 'UniformOutput', false);
% startLost  = cat(1, startLost{:});   % column vector
% startLost  = startLost - 3;          % 3 samples before the Lost pupil event are also excluded (as in the interpolation)
% 
% % 2) Extracting all END-times for the sessEEGLAB
% endBlink = cellfun(@(x) x(:), endIdxZero(:,sessEEGLAB), 'UniformOutput', false);
% endBlink = cat(1, endBlink{:});      % column vector
% endBlink = endBlink + 3;             % 3 samples after the Blink are also excluded (as in the interpolation)
% endLost  = cellfun(@(x) x(:), endIdxLost(:,sessEEGLAB), 'UniformOutput', false);
% endLost  = cat(1, endLost{:});       % column vector
% endLost = endLost + 3;               % 3 samples after the Lost pupil are also excluded (as in the interpolation)
% 
% % 3) Concatenate everything into two long column vectors
% allStarts = [ startBlink; startLost ];
% allEnds   = [ endBlink;   endLost;  ];
% 
% % 4) Remove empty / NaN entries (they appear when a trial had no event)
% validMask = ~isnan(allStarts) & ~isnan(allEnds);
% allStarts = allStarts(validMask);
% allEnds   = allEnds(validMask);
% 
% % 5) Sort by start‑time and reorder the end‑times accordingly
% [sortedStarts, sortIdx] = sort(allStarts);
% sortedEnds = allEnds(sortIdx);
% 
% % 6) Final n×2 matrix for the sessEEGLAB
% artifactEvents = [sortedStarts, sortedEnds];
% 
% % 7) Checking boundries 
% % Ensure artifact times are within valid data range
% % Bigger than 1 and smaller than the number of samples for each session
% maxSamples = numel(pupilSizeRightFilt{sessEEGLAB});
% 
% % 7.1) Clip start times: ensure they are >= 1
% nStartClipped = artifactEvents(:, 1) < 1;
% artifactEvents(nStartClipped, 1) = 1;
% 
% % 7.2) Clip end times: ensure they are <= maxSamples
% nEndClipped = artifactEvents(:, 2) > maxSamples;
% artifactEvents(nEndClipped, 2) = maxSamples;
% 
% % 7.3 Warning messages
% if sum(nStartClipped) > 0
%     fprintf('⚠ Session %d: %d artifact start times were < 1, clipped to 1\n', sessEEGLAB, sum(nStartClipped));
% end
% 
% if sum(nEndClipped) > 0
%     fprintf('⚠ Session %d: %d artifact end times exceeded data length (%d), clipped to %d\n', ...
%         sessEEGLAB, sum(nEndClipped), maxSamples, maxSamples);
% end
% 
% clear nStartClipped nEndCliped maxSamples
% 
% fprintf("All artifact event pairs are stored (Amount: %s events)\n", size(artifactEvents,1));
% 
% %% Building the model 
% 
% % Design matrix basic
% cfgDesign = [];
% cfgDesign.codingschema = 'effects';
% cfgDesign.eventtypes = {'Fixation Cross Onset','Picture Onset','Frame Saccade Onset','First Fixation','Reaction'};
% cfgDesign.formula = {'y ~ 1','y ~ 1','y ~ 1','y ~ 1','y ~ 1'};
% EEG = uf_designmat(EEG,cfgDesign);
% 
% % Plot
% uf_plotDesignmat(EEG,'sort',1,'figure',1)
% %uf_plotEventHistogram(EEG)
% 
% % Time expansion
% cfgTimeshift = [];
% cfgTimeshift.timelimits = [-0.3,2];  % time unit: seconds!
% EEG = uf_timeexpandDesignmat(EEG,cfgTimeshift); % default method is 'stick'
% % EEG_afterTimeExpan = EEG;  % only relevant for comparing the designmatrix before and after excluding the artifacts
% 
% % Rejecting the artifactEvents in the design matrix
% cfgReject = [];
% cfgReject.winrej = artifactEvents;
% EEG = uf_continuousArtifactExclude(EEG,cfgReject);
% 
% % Plot Designmatrix
% uf_plotDesignmat(EEG,'timeexpand',1)
% 
% 
% % Fit the model
% EEG = uf_glmfit(EEG,'lsmriterations',5000); % this method is fast but needs lots of ram
% 
% % Interesting facts:
% X = EEG.unfold.X;
% fprintf("The design matrix has rank %d and size %d \n",rank(X),size(X,2));
% 
% % Plot the results
% % Returns an "ufresult"-structure that contains the predictor betas over time
% % and accompanying information.
% ufresult = uf_condense(EEG); 
% ufresult.effects = ufresult.beta * 2; % only when doing effect coding!
% cfg = [];
% cfg.channel = 1;
% ax = uf_plotParam(ufresult,cfg);
% 
% fprintf('FINISHED\n');
% 
% %% Model comparison (AIC) and Model fit (Residuals)
% 
% % -------------------------------------- Preperation ----------------------
% % Creating pupil size data for the session, in which all data parts included
% % in the artifacts are changed to 0. Because that is what is happening with the
% % design matrix, because of the uf_continuousArtifactExclude. To calculate
% % the residulas correctly (which are also needed in the AIC) the data needs
% % to be set to 0 at theses places aswell. 
% % CAUTION This needs to be expanded to the blinks, once the cutoff value is
% % defined and trials before blinks and lost pupil onset and after their
% % offset are set to 0 as well!
% 
% % Input: 
% %  - startIdxLost and endIdxLost store all values for lost pupil events
% %    in a cell per session
% %  - pupilSizeRight stores the pupil size data for each session in a cell
% 
% % 1) extract the data for this session
% curPupil = pupilSizeRightFilt{sessEEGLAB};  
% curStart = artifactEvents(:,1);
% curEnd   = artifactEvents(:,2); 
% 
% % 2) Zero‑out each interval
% for k = 1:numel(curStart)               % loop over the K pairs
%     % In case the start index is larger than the end index (corrupted data)
%     % we simply skip that pair.
%     if curStart(k) > curEnd(k)
%         warning('Session %d, pair %d: start > end – skipping.', sessEEGLAB, k);
%         continue;
%     end
%     curPupil( curStart(k) : curEnd(k) ) = 0;
% end
% 
% % 3) Write the modified vector to a new variable
% pupilSizeRight_artifactsTo0 = curPupil;
% 
% clear k curPupil curStart curEnd
% 
% fprintf ('All artifact events are changed to 0.\n')
% 
% % --------------------------------- AIC -----------------------------------
% % INPUT:  'ufresult' structure that contains the Unfold results for the session 
% %         'pupilSizeRight_artifactsTo0' n x 1 double variable containing
% %          the adjustd PupilSize values for the session
% 
% % For clarity:
% % Parts of the code including the formulas are from KIWI AI. 
% % But to ensure correct calculations the formulas were checked by me and
% % are fitting to the ones which are given at:
% % https://www.geeksforgeeks.org/machine-learning/maximum-likelihood-estimation-of-gaussian-parameters/
% 
% % 1)  Raw pupil data (dependent variable)
% y = pupilSizeRight_artifactsTo0(:);   % column vector N_obs×1
% 
% % 2)  Time‑expanded design matrix that was used for fitting 
% %     Artifacts are set to 0 in the matrix
% X = ufresult.unfold.Xdc;              % sparse N_obs × Ncol
% 
% % 3)  Beta-coefficient vector that matches Xdc
% betaVec = ufresult.unfold.beta_dc(:); % Ncol × 1
% 
% % 4)  Calculating the predicted signal and residuals
% yhat  = X * betaVec;                  % Nobs × 1 (sparse × dense → dense)
% residuals = y - yhat;                 % residuals (still Nobs × 1)
% 
% % 5)  Keep only the samples that were actually used (non‑NaN)
% valid = ~isnan(residuals);            % Should not exist --> for safty
% N   = sum(valid);                     % effective sample size
% RSS = sum(residuals(valid).^2);       % Residual sum of squares, 
%                                       % the amount of variance that is not
%                                       % explained by the model
% 
% if N == 0
%     warning('All samples are NaN after cleaning – AIC left as NaN.\n');
% end
% 
% % 6)  Gaussian log‑likelihood (restricted maximum‑likelihood)
% % Gaussian normal distribution is used for continuous data
% sigma2 = RSS / N;                     % ML estimate of error variance
% logL   = -0.5 * N * ( log(2*pi) + log(sigma2) + 1 );
% 
% % 7)  Number of free parameters (effective rank of X)
% k = sprank(X);   % rank() runs out of memory
% 
% % 8)  AIC for this session
% AICsess = 2*k - 2*logL;               % standard definition
% 
% % 9)  Progress report
% fprintf('Session %3d: N = %6d, k = %4d, logL = % .2f, AIC = % .2f\n', ...
%         sessEEGLAB, N, k, logL, AICsess);
% fprintf('AIC calculated.\n');
% 
% clear y X betaVec yhat valid N RSS sigma2 logL k 
% 
% % --------------------------------- Residuals -----------------------------
% % summary statistics
% residualsSummary.residuals = residuals;
% residualsSummary.mean = mean(residuals);
% residualsSummary.std  = std(residuals);
% residualsSummary.min  = min(residuals);
% residualsSummary.max  = max(residuals);
% 
% % Plot for the session
% figure;
% plot(residuals(:,end),YDataSource = 'residuals(:,end)');
% yline( residualsSummary.mean, 'r--', sprintf('Mean = %.2f',residualsSummary.mean), ...
%        'LineWidth',1.5, 'LabelHorizontalAlignment','left', ...
%        'LabelVerticalAlignment','top' );
% linkdata on;
% ylabel("Residual Size");
% title('Residuals for the session plotted');
% xlabel("Time (in samples)");
% legend("show");
% legend('Residual data','Mean');
% grid on;
% 
% fprintf('Residuals finished.\n');
% %clear residuals

%% ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% --------------------------   Running EEGLAB and unfold over all sessions   -------------------------------------------------------------------------------------------
%% ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

% Add toolboxes to the the MATLAB path
addpath(genpath('C:\Users\gina\Seafile\Cognitive_Science\Bachelor_Thesis\eeglab_current\eeglab2026.0.0'));   % EEGLAB
addpath(genpath('C:\Users\gina\Seafile\Cognitive_Science\Bachelor_Thesis\unfold-main')); 


% Start EEGLAB (withouth the GUI so it runs faster)
[~, ~] = eeglab('nogui');   % returns two outputs, we discard them

% Initalise Unfold
init_unfold;

% Pre allocation of containers to store the results of all sessions
PS_all       = cell(1,nSessions);   % will store the full EEGLAB structure
ufResult_all = cell(1,nSessions);   % will store a condensed ufresult struct

artifactsExclude_allSess    = cell(1,nSessions);   % will store all artifact to exclude pairs
pupilSizeRight_artifactsTo0 = cell(1,nSessions);   % will store the pupilSize data in which all artifacts are corrected to 0
eventTable_allSess          = cell(1,nSessions);   % will store the eventTable of each Session

% placeholders – they will be filled after the first session
betaAll    = [];   % will become channel×time×parameter/events×subject/session
effectsAll = [];   % optional, same size as betaAll
timeVec    = [];   % 1×time – stored once (identical for all subjects)

% Per session loop
for sessEEGLAB = 1:nSessions
    % 1) ----------------- Building the event table -----------------------

    % Index = data sample number
    % Variable - 'Event'
    %  1) latencyFixationCrossOnset (88×144)     - 'Fixation Cross Onset'
    %  2) latencyPictureOnset (88×144)           - 'Picture Onset'
    %  3) latencyFirstFixation (88×144)          - 'First Fixation'
    %  4) latencyFrameOnset (88×144)             - 'Frame Onset'
    %  5) latencyReaction (88×144)               - 'Reaction'
    %  6) insideBlinkStart (88×144 cell)         - 'Inside Blink Start'
    %  7) insideBlinkEnd (88×144 cell)           - 'Inside Blink End'
    %  8) outsideBlinkStart (87×144 cell)        - 'Outside Blink Start'
    %  9) outsideBlinkEnd (87×144 cell)          - 'Outside Blink End'
    % 10) insideLostStart (88×144 cell)          - 'Inside Lost Pupil Start'
    % 11) insideLostEnd (88×144 cell)            - 'Inside Lost Pupil End'
    % 12) outsideLostStart (87×144 cell)         - 'Outside Lost Pupil Start'
    % 13) outsideLostEnd (87×144 cell)           - 'Outside Lost Pupil End'
    % 14) frameDecidingSacMatrix (88x144 double) - 'Frame Saccade Onset'

    % order: A = Congruent (44 trials), Incongruent (44 trials); B = Incongruent (44 trials), Congruent (44 trials)
    % Output: Col 1 = latency, Col 2 = type, Col 3 = valence, Col 4 = congruency, Col 5 = side

    % 1.1 Extract the column that belongs to the current session 
    %     from every EVENT latency / cell matrix.

    % numeric latency vectors (88 × 1) 
    colFix   = latencyFixationCrossOnset(:,sessEEGLAB);   % 88×1
    colPic   = latencyPictureOnset(:,sessEEGLAB);
    colFirst = latencyFirstFixation(:,sessEEGLAB);
    colFrame = latencyFrameOnset(:,sessEEGLAB);
    colReact = latencyReaction(:,sessEEGLAB);
    colFrameSacOnset = frameDecidingSacMatrix(:,sessEEGLAB); % 88×1

    % cell‑arrays that have variable length per session
    colInBlinksStart  = cell2mat(insideBlinkStart(:,sessEEGLAB));
    colInBlinksEnd    = cell2mat(insideBlinkEnd(:,sessEEGLAB));
    colInLostStart    = cell2mat(insideLostStart(:,sessEEGLAB));
    colInLostEnd      = cell2mat(insideLostEnd(:,sessEEGLAB));
    colOutBlinksStart = cell2mat(outsideBlinkStart(:,sessEEGLAB));
    colOutBlinksEnd   = cell2mat(outsideBlinkEnd(:,sessEEGLAB));
    colOutLostStart   = cell2mat(outsideLostStart(:,sessEEGLAB));
    colOutLostEnd     = cell2mat(outsideLostEnd(:,sessEEGLAB));

    % 1.2 Building of the event table

    % Concatenating all Latencies
    allLatencies = vertcat(colFix, colPic, colFirst, colFrame, colReact, ... % 440×1 cell
        colInBlinksStart, colInBlinksEnd, colInLostStart, colInLostEnd, ...
        colOutBlinksStart, colOutBlinksEnd, colOutLostStart, colOutLostEnd,...
        colFrameSacOnset); 

    % Event type labels
    lblFix           = repmat({'Fixation Cross Onset'}, numel(colFix),1);
    lblPic           = repmat({'Picture Onset'},        numel(colPic),1);
    lblFirst         = repmat({'First Fixation'},       numel(colFirst),1);
    lblFrame         = repmat({'Frame Onset'},          numel(colFrame),1);
    lblReact         = repmat({'Reaction'},             numel(colReact),1);
    lblInBlinkStart  = repmat({'Inside Blink Start'},   numel(colInBlinksStart),1);
    lblInBlinkEnd    = repmat({'Inside Blink End'},     numel(colInBlinksEnd),1);
    lblInLostStart   = repmat({'Inside Lost Start'},    numel(colInLostStart),1);
    lblInLostEnd     = repmat({'Inside Lost End'},      numel(colInLostEnd),1);
    lblOutBlinkStart = repmat({'Outside Blink Start'}, numel(colOutBlinksStart),1);
    lblOutBlinkEnd   = repmat({'Outside Blink End'},   numel(colOutBlinksEnd),1);
    lblOutLostStart  = repmat({'Outside Lost Start'},  numel(colOutLostStart),1);
    lblOutLostEnd    = repmat({'Outside Lost End'},    numel(colOutLostEnd),1);
    lblFrameSacOnset = repmat({'Frame Saccade Onset'}, numel(colFrameSacOnset),1);

    allTypes = vertcat(lblFix, lblPic, lblFirst, lblFrame, lblReact, ... % 440×1 cell
       lblInBlinkStart, lblInBlinkEnd, lblInLostStart, lblInLostEnd, ...
       lblOutBlinkStart, lblOutBlinkEnd, lblOutLostStart, lblOutLostEnd, lblFrameSacOnset);    

    % Empty placeholder cells of each variable for optional columns
    emptyFix           = repmat({[]}, numel(colFix),1);
    %emptyPic          = repmat({[]}, numel(colPic),1);   % not necessary
    emptyFirst         = repmat({[]}, numel(colFirst),1);
    emptyFrame         = repmat({[]}, numel(colFrame),1);
    emptyReact         = repmat({[]}, numel(colReact),1);
    emptyInBlinkStart  = repmat({[]}, numel(colInBlinksStart),1);
    emptyInBlinkEnd    = repmat({[]}, numel(colInBlinksEnd),1);
    emptyInLostStart   = repmat({[]}, numel(colInLostStart),1);
    emptyInLostEnd     = repmat({[]}, numel(colInLostEnd),1);
    emptyOutBlinkStart = repmat({[]}, numel(colOutBlinksStart),1);
    emptyOutBlinkEnd   = repmat({[]}, numel(colOutBlinksEnd),1);
    emptyOutLostStart  = repmat({[]}, numel(colOutLostStart),1);
    emptyOutLostEnd    = repmat({[]}, numel(colOutLostEnd),1);
    emptyFrameSacOnset = repmat({[]}, numel(colFrameSacOnset),1);

    % Creating columns for valence, congruency and side,in which the
    % information is stored in the same row as the relevant event type

    % Valence
    % Should be stored next to Picture Onset, First Fixation, Reaction
    allValence = vertcat(emptyFix, valenceCell(:, sessEEGLAB), valenceCell(:, sessEEGLAB), emptyFrame, valenceCell(:, sessEEGLAB), ...  % 440×1 cell
        emptyInBlinkStart, emptyInBlinkEnd, emptyInLostStart, emptyInLostEnd, ...
        emptyOutBlinkStart, emptyOutBlinkEnd, emptyOutLostStart, emptyOutLostEnd, ...
        emptyFrameSacOnset);

    % Congruency
    % Should be stored next to Picture Onset and Reaction
    allCongruency =  vertcat(emptyFix, congruencyCell(:, sessEEGLAB), emptyFirst, emptyFrame, congruencyCell(:, sessEEGLAB), ... % 440×1 cell
        emptyInBlinkStart, emptyInBlinkEnd, emptyInLostStart, emptyInLostEnd, ...
        emptyOutBlinkStart, emptyOutBlinkEnd, emptyOutLostStart, emptyOutLostEnd, ...
        emptyFrameSacOnset);

    % Side
    % Should be stored next to Picture Onset, First Fixation, Frame Onset and Reaction
    allSide =  vertcat(emptyFix, sideCell(:, sessEEGLAB), sideCell(:, sessEEGLAB), sideCell(:, sessEEGLAB), sideCell(:, sessEEGLAB), ... % 440×1 cell
        emptyInBlinkStart, emptyInBlinkEnd, emptyInLostStart, emptyInLostEnd, ...
        emptyOutBlinkStart, emptyOutBlinkEnd, emptyOutLostStart, emptyOutLostEnd, ...
        emptyFrameSacOnset);

    % Assembling unsorted event table (type, latency, valence, congruency, side)
    events_unsorted = [allTypes, num2cell(allLatencies), allValence, allCongruency, allSide];   % 440‑by‑4 cell array

    % Sort by the numeric latency (ascending), keep the strings together 
    % (the whole row is moved to its correct position)
    % All NaN end up at the bottom, after all numbers
    [sortedNums, sortIdx] = sort(allLatencies,'ascend');   % sort indices
    events_sorted = events_unsorted(sortIdx,:);            % re‑order all rows

    % Removing rows containing NaNs (in any column)
    % Flag every cell that is a NaN (numeric NaN inside a cell)
    isNaNcell = cellfun(@(x) isequaln(x,NaN), events_sorted);   % logical matrix
    % "bad" row = it contains a NaN in any column
    badRow    = any(isNaNcell,2);                     % 2 = dimension (any(A,2) works on successive elements in the rows of A and returns a column vector of logical values.)
    % keep only the rows that are not bad
    events_sorted_clean = events_sorted(~badRow,:);   % keep rows without NaN
    % Since the same trials are marked as NaN for 'Fixation Cross Onset', 
    % 'Picture Onset', 'First Fixation', 'Frame Onset' and 'Reaction'
    % only complete trials are removed

    % Storing the eventTable
    eventTable_allSess{sessEEGLAB} = events_sorted_clean;

    % 2) ------------------------ EEGLAB ----------------------------------
    % Building the EEGLAB dataset for current session

    % CHANGE HERE WHICH DATA IS USED
    pupilSizeSession = (pupilSizeRightFilt{1,sessEEGLAB})';  % same session as the session for the event file

    % Create a EEGLAB structure (1 channel = pupil size)
    % Named PS for Pupil Size (not EEG as usually)
    PS = pop_importdata('dataformat','array','nbchan',1,'data','pupilSizeSession', ...
        'setname',sprintf('PupilSize_Right_Sess%02d',sessEEGLAB),'srate',500, ...
        'pnts',numel(pupilSizeSession),'xmin',0);

    % Attach the sorted event table 
    % EEGLAB need the event field to ba a structure --> converted by helper importevent
    PS.event = importevent(events_sorted_clean,[],500, ...
        'fields',{'type','latency','valence','congruency','side'},'timeunit',NaN);


    % 3) ----------------------- Unfold -----------------------------------
    % Running Unfold for the current session

    % 3.1) Preperations 
    % Exclude Blink and Lost Pupil artifacts
    % The time during the blinks or lost pupil events are invalid data. 
    % The pupil size can not be measured reliablly ("measuring" 0 or >3000), 
    % therefore these times need to be excluded from the analysis.
    % In addition to that 3 samples before and after are excluded as well
    % Relevant events: inside and outside blinks, inside and outside lost pupil

    % 3.1.1) Extracting all START-times for the sessEEGLAB
    startBlink = cellfun(@(x) x(:), startIdxZero(:,sessEEGLAB), 'UniformOutput', false);
    startBlink = cat(1, startBlink{:});  % column vector
    %startBlink = startBlink - 3;         % 3 samples before the Blink are also excluded (as in the interpolation)
    startLost  = cellfun(@(x) x(:), startIdxLost(:,sessEEGLAB), 'UniformOutput', false);
    startLost  = cat(1, startLost{:});   % column vector
    %startLost  = startLost - 3;          % 3 samples before the Lost pupil event are also excluded (as in the interpolation)

    % 3.1.2) Extracting all END-times for the sessEEGLAB
    endBlink = cellfun(@(x) x(:), endIdxZero(:,sessEEGLAB), 'UniformOutput', false);
    endBlink = cat(1, endBlink{:});      % column vector
    %endBlink = endBlink + 3;             % 3 samples after the Blink are also excluded (as in the interpolation)
    endLost  = cellfun(@(x) x(:), endIdxLost(:,sessEEGLAB), 'UniformOutput', false);
    endLost  = cat(1, endLost{:});       % column vector
    %endLost = endLost + 3;               % 3 samples after the Lost pupil are also excluded (as in the interpolation)

    % 3.1.3) Concatenate everything into two long column vectors
    allStarts = [ startBlink; startLost ];
    allEnds   = [ endBlink;   endLost;  ];

    % 3.1.4) Remove empty / NaN entries (they appear when a trial had no event)
    validMask = ~isnan(allStarts) & ~isnan(allEnds);
    allStarts = allStarts(validMask);
    allEnds   = allEnds(validMask);

    % 3.1.5) Sort by start‑time and reorder the end‑times accordingly
    [sortedStarts, sortIdx] = sort(allStarts);
    sortedEnds = allEnds(sortIdx);

    % 3.1.6) Final n×2 matrix for the sessEEGLAB
    artifactEvents = [sortedStarts, sortedEnds];

    % 3.1.7) Checking boundries 
    % Ensure artifact times are within valid data range
    % Bigger than 1 and smaller than the number of samples for each session
    maxSamples = numel(pupilSizeRightFilt{sessEEGLAB});

    % Clip start times: ensure they are >= 1
    nStartClipped = artifactEvents(:, 1) < 1;
    artifactEvents(nStartClipped, 1) = 1;

    % Clip end times: ensure they are <= maxSamples
    nEndClipped = artifactEvents(:, 2) > maxSamples;
    artifactEvents(nEndClipped, 2) = maxSamples;

    % Warning messages
    if sum(nStartClipped) > 0
        fprintf('⚠ Session %d: %d artifact start times were < 1, clipped to 1\n', sessEEGLAB, sum(nStartClipped));
    end

    if sum(nEndClipped) > 0
        fprintf('⚠ Session %d: %d artifact end times exceeded data length (%d), clipped to %d\n', ...
            sessEEGLAB, sum(nEndClipped), maxSamples, maxSamples);
    end


    % 3.1.7)
    artifactsExclude_allSess{sessEEGLAB} = artifactEvents;

    % NOTE:
    % Because of the buffers around the blinks and lost pupil values, some
    % artifact times overlap. E.g. the buffer adjusted start of a lost event,
    % falls into the artifact time of the blink before (the end of an artifact
    % is bigger than the start of the next artifact). At the moment this code
    % does not correct that. This should not be an issue, because the
    % uf_continuousArtifactExclude function creates a list that includes every
    % index, which should be set to 0, and afterwards sets these to 0, thereore
    % some indexes are included twice (or more) in the list, and will be set to
    % 0 twice (or three times, etc), which should not cause a problem.
    %
    % Relevant Code of uf_continuousArtifactExclude (https://github.com/unfoldtoolbox/unfold/blob/main/src/uf_toolbox/uf_continuousArtifactExclude.m)
    % [...]
    % for k = 1:size(cfg.winrej,1)
    %    rej = [rej cfg.winrej(k,1):cfg.winrej(k,2)];
    % end
    % [...]
    % EEG.unfold.Xdc(round(rej),:) = 0;

    fprintf("All artifact event pairs are stored (Amount: %s events)\n", size(artifactEvents,1));

    clear nStartClipped nEndCliped maxSamples

    % 3.2) Artifacts to 0 for residual caluclations 
    % Creating pupil size data for the session, in which all data parts included
    % in the artifacts are changed to 0. Because that is what is happening with the
    % design matrix, because of the uf_continuousArtifactExclude. To calculate
    % the residulas correctly (which are also needed in the AIC) the data needs
    % to be set to 0 at theses places aswell. 
    % CAUTION This needs to be expanded to the blinks, once the cutoff value is
    % defined and trials before blinks and lost pupil onset and after their
    % offset are set to 0 as well!

    % Input: 
    %  - startIdxLost and endIdxLost store all values for lost pupil events
    %    in a cell per session
    %  - pupilSizeRight stores the pupil size data for each session in a cell

    % 3.2.1) extract the data for this session
    curPupil = pupilSizeRightFilt{sessEEGLAB};  
    curStart = artifactEvents(:,1);
    curEnd   = artifactEvents(:,2); 

    % 3.2.2) Zero‑out each interval
    for k = 1:numel(curStart)               % loop over the K pairs
        % In case the start index is larger than the end index (corrupted data)
        % we simply skip that pair.
        if curStart(k) > curEnd(k)
            warning('Session %d, pair %d: start > end – skipping.', sessEEGLAB, k);
            continue;
        end
        curPupil( curStart(k) : curEnd(k) ) = 0;
    end

    % 3.2.3) Write the modified vector to a new variable
    pupilSizeRight_artifactsTo0{sessEEGLAB} = curPupil;

    clear k curPupil curStart curEnd

    % 3.3) Preparing the Design Matrix
    cfgDesign = [];
    cfgDesign.codingschema = 'effects';     % Effect Coding (If changing to dummy coding, disable the code in 'Condense the result' section!)
    cfgDesign.eventtypes = {'Fixation Cross Onset','Picture Onset','Frame Saccade Onset','First Fixation','Reaction'};
    cfgDesign.formula = {'y ~ 1','y ~ 1','y ~ 1','y ~ 1','y ~ 1'};

    % 3.4) Creating the design matrix
    PS = uf_designmat(PS,cfgDesign);

    % 3.5) Timeexpansion of the design matrix (stick function)
    cfgTimeshift = [];
    cfgTimeshift.timelimits = [-0.3,2];  % time unit: seconds!
    PS = uf_timeexpandDesignmat(PS,cfgTimeshift); % default method is 'stick'

    % 3.6) Rejecting the artifactEvents in the design matrix 
    cfgReject = [];
    cfgReject.winrej = artifactEvents;
    PS = uf_continuousArtifactExclude(PS,cfgReject);

    % 3.7) Fit the GLM
    PS = uf_glmfit(PS,'lsmriterations',5000); % this method is fast but needs lots of ram

    % 3.8) Interesting facts:
    X = PS.unfold.X;
    fprintf("The design matrix has rank %d and size %d \n",rank(X),size(X,2));

    % 3.9) Condense the results
    % Returns an "ufresult"-structure that contains the predictor betas over time
    % and accompanying information.
    ufresult = uf_condense(PS); 
    ufresult.effects = ufresult.beta * 2; % only when doing effect coding!

    % 3.10) Only after the first session
    if sessEEGLAB == 1
        %   Determine the exact dimensions of the β‑matrix
        % ufresult.beta has size  CHANNEL × TIME × PREDICTOR
        [nChan, nTime, nParam] = size(ufresult.beta);

        % Pre‑allocate the 4‑D containers for *all* sessions
        betaAll    = nan(nChan, nTime, nParam, nSessions);
        effectsAll = nan(nChan, nTime, nParam, nSessions);   % optional

        % Store the time vector once (identical for every subject)
        % ufresult.times is a column vector; we store it as a row vector
        timeVec = ufresult.times(:)';      % 1 × TIME
    end

    % 4) -------------------- Storing the results -------------------------
    PS_all{sessEEGLAB}       = PS;          % full EEGLAB structure (contains the design matrix, the fitted betas, etc.)
    ufResult_all{sessEEGLAB} = ufresult;     % condensed betas only – usually much smaller

    betaAll(:, :, :, sessEEGLAB)    = ufresult.beta;          % CHAN×TIME×PARAM×SUBJ
    effectsAll(:, :, :, sessEEGLAB) = ufresult.effects;       % same size

    % Small progress report
     fprintf('--- Session %02d / %d finished (%.1f s) ---\n', ...
            sessEEGLAB, nSessions, toc);   % you may also use `tic` before the loop

    clear col* lbl* empty* all* events_* eventTable pupilSizeSession PS ufresult artifactEvents;

end

% Helper function for different event formulas
function fm = formula_for_event(evName)
% Returns the formula string that that should be used for a specific
% unfold event.
    switch evName
        % Picture Onset, First Fixation and reaction are the events that will
        % get more coplex formulas
        case 'Picture Onset'
            fm = 'y ~ 1';
            % Relevant when the formulas become more complex and side gets
            % included

            % sideCell = {PS.event.side};
            % sideCat = categorical(sideCell);
            % if numel(categories(sideCat)) > 1
            %     fm = 'y ~ 1 + cat(valence) + cat(side) + cat(congruency)';
            % else
            %     fm = 'y ~ 1 + cat(valence) + cat(congruency)';
            % end
        case 'First Fixation'
            fm = 'y ~ 1';   
        case 'Reaction'
            fm = 'y ~ 1';                
        otherwise
            % Default: only an intercept
            fm = 'y ~ 1';
    end
end

% Saving the results
% CAUTION: Might make MatLab crash (unsure why)
%saveFolder = 'C:\Users\gina\Seafile\Cognitive_Science\Bachelor_Thesis\Unfold_Results';
%if ~exist(saveFolder,'dir'), mkdir(saveFolder); end
%save(fullfile(saveFolder,'All_sessions_V1_effect.mat'),'PS_all','ufResult_all','-v7.3');

% Clean up - Event Table
clear ('colFix', 'colPic', 'colFirst', 'colFrame', 'colReact', ...
    'colInBlinksStart', 'colInBlinksEnd', 'colInLostStart', 'colInLostEnd', ...
    'colOutBlinksStart', 'colOutBlinksEnd', 'colOutLostStart', 'colOutLostEnd', 'colFrameSacOnset', ...
    'lblReact','lblFrame','lblFirst','lblPic','lblFix', ...
    'lblInBlinkStart','lblInBlinkEnd','lblInLostStart','lblInLostEnd', ...
    'lblOutBlinkStart', 'lblOutBlinkEnd', 'lblOutLostStart', 'lblOutLostEnd', 'lblFrameSacOnset', ...
    'emptyReact','emptyFrame','emptyFirst','emptyPic','emptyFix', ...
    'emptyInBlinkStart', 'emptyInBlinkEnd', 'emptyInLostStart', 'emptyInLostEnd', ...
    'emptyOutBlinkStart', 'emptyOutBlinkEnd', 'emptyOutLostStart', 'emptyOutLostEnd', 'emptyFrameSacOnset', ...
    'isNaNcell','badRow');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   GROUP LEVEL ANALYSIS (2nd level)   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Building one structure for average beta results
% If wanted: Average beta plot for every predictor
% User settings
chanToPlot = 1;      % which channel - pupil size = only one channel
timeShift  = -0.3;   % start of the time window (seconds)
makeFigures = true;  % set to False if only the data structure is needed

% Basic check
if ~exist('PS_all','var') || isempty(PS_all)
    error('Variable PS_all not found or empty. Load your Unfold results first.');
end
nSess = numel(PS_all);                     % number of sessions
fprintf('Number of sessions in PS_all: %d\n', nSess);

% 1) Building a union of all predictor names across sessions
% new name = eventtype + '_' + '(' + variabletype + ')'
allVarNames = {};
for sess = 1:nSessions
    % a) get the raw event‑type and variable‑type cells 
    %   In a PS structure they are stored as 1×N cells,
    %   each cell itself contains a 1×1 cell with the string.
    evRaw  = PS_all{sess}.unfold.eventtypes;   % 1×N cell, each = { 'Fixation Cross Onset' }
    varRaw = PS_all{sess}.unfold.variabletypes; % 1×N cell, each = 'Intercept' (or other)

    % b) pull the inner string out of the double cell  
    evFlat  = cellfun(@(c) c{1}, evRaw,  'UniformOutput',false);   % → {'Fixation Cross Onset', …}
    varFlat = varRaw;                                              % already simple strings

    % c) build the combined label for this session 
    sessNames = cellfun(@(e,v) sprintf('%s\\_(%s)', e, v), ...
                        evFlat, varFlat, 'UniformOutput',false);

    %  d) add them to the global union 
    allVarNames = union(allVarNames, sessNames);
end
nPred = numel(allVarNames);
fprintf('Found %d distinct predictors in the whole data set.\n', nPred);

% 2) Common dimensions
% Find the first session that actually contains a beta matrix (safety check)
firstIdx = find(cellfun(@(x) ~isempty(x.unfold.beta_dc), PS_all),1,'first');
if isempty(firstIdx)
    error('No session contains a beta matrix – cannot continue.');
end
[ nChan, nTime, ~ ] = size( PS_all{firstIdx}.unfold.beta_dc );
srate = PS_all{firstIdx}.srate;      % Hz (identical for all sessions)

% 3) Pre allocation of containers for the sum of betas and session counters
sumBeta   = zeros(nChan, nTime, nPred);    % accumulator for betas
nContrib  = zeros(1, nPred);               % how many sessions contributed per predictor

% 4) Loop over sessions and add the betas of the predictors that exist
for sess = 1:nSess
    % the combined*names for this session (identical to step 1a‑c)
    evRaw  = PS_all{sess}.unfold.eventtypes;
    varRaw = PS_all{sess}.unfold.variabletypes;
    evFlat  = cellfun(@(c) c{1}, evRaw,  'UniformOutput',false);
    varFlat = varRaw;
    sessNames = cellfun(@(e,v) sprintf('%s\\_(%s)', e, v), evFlat, varFlat, ...
                        'UniformOutput',false);   % 1×nPredSess cell

    % the β‑matrix of this session 
    sessBeta  = PS_all{sess}.unfold.beta_dc;           % chan × time × nPred (for this session)

    for p = 1:numel(sessNames)          % loop over predictors present in this session
        % Find the index of this predictor in the global list
        globalIdx = find(strcmp(allVarNames, sessNames{p}),1,'first');
        if isempty(globalIdx)
            error('Predictor %s from session %d not found in global list.', sessNames{p}, sess);
        end

        % Add the entire channel×time slice to the running sum
        sumBeta(:, :, globalIdx) = sumBeta(:, :, globalIdx) + sessBeta(:, :, p);

        % Increment the contribution counter for this predictor
        nContrib(globalIdx) = nContrib(globalIdx) + 1;
    end
end

% 5) Compute the grand‑average βs (divide only where we have contributions)
meanBetas = zeros(nChan, nTime, nPred);
valid = nContrib > 0;                        % logical index of predictors that exist
% Safe division (works on all MATLAB releases)
divisor = reshape(nContrib(valid), [1 1 numel(nContrib(valid))]);   % 1×1×K
meanBetas(:, :, valid) = sumBeta(:, :, valid) ./ divisor;

% 6) Build the time vector (includes the requested shift)
timeVector = (0:nTime-1)' / srate + timeShift;   % column vector, starts at -0.3 s

% 7) Assemble everything into ONE structure
GroupResult = struct();
GroupResult.unfold = struct();
GroupResult.unfold.varNames   = allVarNames;    % 1 × nPred cell
GroupResult.unfold.meanBetas  = meanBetas;      % chan × time × pred
GroupResult.unfold.nContrib   = nContrib;       % 1 × nPred numeric
GroupResult.unfold.time       = timeVector;     % nTime × 1 numeric
GroupResult.unfold.srate      = srate;          % scalar
GroupResult.unfold.description = sprintf(...
    ['GroupResult created from %d sessions. ',...
     'Channel %d kept, time window starts at %.3f s. ',...
     'Mean betas stored as channel×time×predictor.'],...
    nSess, chanToPlot, timeShift);

% % 8) Optional: Generate a figure for each predictor
% if makeFigures
%     for p = 1:nPred
%         % 8.1 Preperations
% 
%         % Skip predictors that never occurred (nContrib == 0)
%         if nContrib(p) == 0, continue; end
% 
%         predName = allVarNames{p};                          % name of the current predictor
%         % Extract the mean β‑trace for the chosen channel
%         meanTrace = squeeze(meanBetas(chanToPlot, :, p));   % 1 × nTime row
% 
%         % Recollect the raw β‑traces for this predictor:
%         % To obtain SEM we have to re‑collect the individual session traces.
%         % This is a small overhead but necessary for the confidence band.
%         % We will rebuild a matrix (time × nValidSessions) on‑the‑fly
%         betaMatrix = [];   % time × nValidSessions
%         for sess = 1:nSess
%             sessNames = PS_all{sess}.unfold.colnames;
%             idx = find(strcmp(sessNames, predName), 1, 'first');   % scalar or []
%             if isempty(idx), continue; end                       % predictor missing → skip
%             thisBeta = squeeze( PS_all{sess}.unfold.beta_dc(chanToPlot, :, idx) );
%             betaMatrix = [betaMatrix, thisBeta(:)];               % column per session
%         end
% 
%         nValid = size(betaMatrix,2);
%         if nValid == 0
%             % No data for this predictor – we already know nContrib(p)>0, 
%             % but just in case something went wrong, skip the CI.
%             warning('Predictor %s has no contributing sessions for channel %d; skipping CI.', ...
%                     predName, chanToPlot);
%             continue;
%         end
% 
%         % SEM and 95 % CI 
%         sem    = std(betaMatrix,0,2,'omitnan') ./ sqrt(nValid);   % column (nTime×1)
% 
%         % make sure both operands are column vectors
%         meanTrace = meanTrace(:);
%         sem       = sem(:);
% 
%         ciLow  = meanTrace - 1.96*sem;
%         ciHigh = meanTrace + 1.96*sem;
% 
%         % 8.2 Plot PLOT 
%         fig = figure('Color','w','Position',[200 200 800 400]); hold on;
% 
%         % shaded confidence band (light‑blue)
%         xFill = [timeVector; flipud(timeVector)];
%         yFill = [ciLow;      flipud(ciHigh)];
%         fill(xFill, yFill, [0.8 0.8 1], 'EdgeColor','none');
% 
%         % mean line (solid blue)
%         plot(timeVector, meanTrace, 'b', 'LineWidth',2);
% 
%         % emphasized zero lines
%         xline(0,'--k','LineWidth',1.5);   % vertical line at x = 0
%         yline(0,'--k','LineWidth',1.5);   % horizontal line at y = 0
% 
%         % cosmetics
%         xlabel('Time (s)','FontSize',12);
%         ylabel('Mean β (pupil‑size units)','FontSize',12);
%         title(['Average time‑course of ', predName],'FontSize',14,'FontWeight','bold');
%         grid on; box off;
%         legend({'Mean β','95 % CI'},'Location','best');
% 
%     end
% end
% 
% fprintf('All predictor figures have been created.\n');

% uf_plot2nd(betaAll,'channel',1);

%% Summary plots from the already‑computed GroupResult

% 2.1 Identify intercepts (any predictor containing the word "intercept")
isIntercept = cellfun(@(c) contains(lower(c),'intercept'), GroupResult.unfold.varNames);
isCondition = ~isIntercept;                     % everything else

% 2.2 Common variables for plotting
tVec   = GroupResult.unfold.time;                % nTime × 1 column vector
meanB  = GroupResult.unfold.meanBetas;           % chan × time × pred
chan   = chanToPlot;                             % we kept only one channel
nPred  = numel(GroupResult.unfold.varNames);
colMap = lines(max(2,nPred));    % generate a colormap with at least 2 colours

% 2.3 Helper function that safely draws a line for a given predictor
function safePlot(ax, predIdx, tVec, meanB, chan, colour, varNames)
    % safety check (should never fire because we filtered first) 
    if predIdx < 1 || predIdx > size(meanB,3)
        warning('Predictor index %d out of bounds – skipping.', predIdx);
        return;
    end
    % extract the mean trace (time × 1 column)
    y = squeeze(meanB(chan,:,predIdx));   % 1 × nTime row
    y = y(:);                             % make it a column to match tVec
    % plot
    plot(ax, tVec, y, 'Color', colour, 'LineWidth',2, ...
         'DisplayName', varNames{predIdx});
end

% 2.4  Figure 1 – All Intercepts together
if any(isIntercept)
    figInt = figure('Color','w','Position',[100 100 1000 400]); hold on;
    axInt = gca;
    intIdxList = find(isIntercept);
    for kk = 1:numel(intIdxList)
        safePlot(axInt, intIdxList(kk), tVec, meanB, chan, colMap(kk,:), GroupResult.unfold.varNames);
    end

    % ----- zero lines – hide them from the legend -----------------
    if exist('xline','file') && exist('yline','file')
        hZeroX = xline(0,'--k','LineWidth',1.5,'HandleVisibility','off');
        hZeroY = yline(0,'--k','LineWidth',1.5,'HandleVisibility','off');
    else
        % older MATLAB versions: use plot(), then set visibility off
        hZeroX = plot([0 0], ylim, '--k','LineWidth',1.5);
        hZeroY = plot(xlim, [0 0], '--k','LineWidth',1.5);
        set([hZeroX, hZeroY], 'HandleVisibility','off');
    end

    xlabel('Time (s)','FontSize',12);
    ylabel('Mean β (pupil‑size units)','FontSize',12);
    title('Mean β – Intercepts','FontSize',14,'FontWeight','bold');
    legend('show','Location','best');   % zero lines are not listed
    grid on; box off;
    saveas(figInt, 'MeanBeta_Intercepts.png');
else
    warning('No intercept predictors found – Intercept figure not created.');
end

% 2.5  Figure 2 – All Condition Effects together
if any(isCondition)
    figCond = figure('Color','w','Position',[100 600 1000 400]); hold on;
    axCond = gca;
    condIdxList = find(isCondition);
    for kk = 1:numel(condIdxList)
        safePlot(axCond, condIdxList(kk), tVec, meanB, chan, colMap(kk,:), GroupResult.unfold.varNames);
    end

    % zero lines – hide them from the legend 
    if exist('xline','file') && exist('yline','file')
        hZeroX = xline(0,'--k','LineWidth',1.5,'HandleVisibility','off');
        hZeroY = yline(0,'--k','LineWidth',1.5,'HandleVisibility','off');
    else
        hZeroX = plot([0 0], ylim, '--k','LineWidth',1.5);
        hZeroY = plot(xlim, [0 0], '--k','LineWidth',1.5);
        set([hZeroX, hZeroY], 'HandleVisibility','off');
    end

    xlabel('Time (s)','FontSize',12);
    ylabel('Mean β (pupil‑size units)','FontSize',12);
    title('Mean β – Condition Effects','FontSize',14,'FontWeight','bold');
    legend('show','Location','best');   % zero lines are not listed
    grid on; box off;
   % saveas(figCond, 'MeanBeta_ConditionEffects.png');
else
    fprintf('No condition predictors found – Condition Effects figure not created.');
end

fprintf('Summary plots (Intercepts & Condition Effects) have been saved.\n\n');

%% Computing the AIC for each session
% INPUT:  PS_all  – cell array that contains the Unfold results for every session (e.g. 142 elements)
% WARNING: This calculation works and is in theory, but the results are at the moment
% unreliable. THe data is not epoched, it is continous. The prediction is
% only creating data for the trials. Therefore, the huge residuals in the
% time between the trials, distorts the residual values and the AIC values in consequence massivly.

% pre‑allocate AIC vector (one value per session)
AICsess = nan(1, nSessions); 
Residuals_abs_sess = cell (1, nSessions);
RSS_sess  = cell (1, nSessions);
Predicted_sess = cell (1, nSessions);

for sess = 1:nSess
    PS = PS_all{sess};

    % 1)  Raw pupil data (dependent variable)
    y = pupilSizeRight_artifactsTo0{sess};   % column vector N_obs×1

    % 2)  Time‑expanded design matrix that was used for fitting 
    %     Artifacts are set to 0 in the matrix
    X = PS.unfold.Xdc;                  % sparse N_obs × Ncol
 
    % 3)  Global Beta-coefficient vector that matches Xdc
    % Order of the Betas is similar to the order of events!
    % No reordering necessary
    betaVec = PS.unfold.beta_dc(:);   % Ncol × 1

    % 4)  Calculating the predicted signal and residuals
    yhat  = X * betaVec;                    % Nobs × 1 (sparse × dense → dense)
    resid = y - yhat;                       % residuals (still Nobs × 1)
    % Careful! D not interpret the sum of residuals, here positive and
    % negative values cancel eachther out!
    % Use: resid_abs or the RSS instead!
    resid_abs = abs(y - yhat);

    % 5)  Keep only the samples that were actually used (non‑NaN)
    valid = ~isnan(resid);
    N   = sum(valid);                       % effective sample size
    RSS = sum( resid(valid).^2 );           % Residual sum of squares, 
                                            % the amount of variance that 
                                            % is not explained by the model

    if N == 0
        warning('Session %d: all samples NaN after cleaning – AIC left as NaN.', sess);
        continue;
    end

    % 6)  Gaussian log‑likelihood (restricted maximum‑likelihood)
    sigma2 = RSS / N;                       % ML estimate of error variance
    logL   = -0.5 * N * ( log(2*pi) + log(sigma2) + 1 );

    % 7)  Number of free parameters (effective rank of X)
    k = sprank(X);   % rank() runs out of memory

    % 8)  AIC for this session
    AICsess(sess) = 2*k - 2*logL;               % standard definition

    % 9) Storing the residuals of the session
    Residuals_abs_sess{sess} = resid_abs;

    % 10) Storing the predicted data of the session
    Predicted_sess{sess} = yhat;

    % 11) Storing the RSS of the session
    RSS_sess{sess} = RSS;

    % 11)  Progress report
    fprintf('Session %3d / %d : N = %6d, k = %4d, logL = % .2f, AIC = % .2f\n', ...
            sess, nSess, N, k, logL, AICsess(sess));
end

%clear y X betaVec yhat resid valid N RSS sigma2 logL k;

%  Summary
fprintf('\n--- Finished computing AIC and residuals for all %d sessions ---\n', nSess);
fprintf('AIC range:  %.2f  –  %.2f\n', min(AICsess), max(AICsess));

% Distribution of the AIC for each model
figure;
histogram(AICsess, 20);
xlabel('AIC');
ylabel('Number of sessions');
title('Distribution of per‑session AIC (pupil‑size Unfold models)');

% Summary statistics about the AIC
AIC_interceptModel.AIC_sum = sum(AICsess,'omitnan');
AIC_interceptModel.mean    = mean(AICsess,'omitnan');
AIC_interceptModel.std     = std(AICsess,'omitnan');
AIC_interceptModel.min     = min(AICsess);
AIC_interceptModel.max     = max(AICsess);

%% Residuals
% Calculating the mean of each session
mean_Residuals = cellfun(@(x) mean(x, 'omitnan'), Residuals_abs_sess);

% Distribution of the Residuals for each model
figure;
histogram(mean_Residuals, 20);
xlabel('Residual Size');
ylabel('Number of sessions');
title('Distribution of per‑session mean residual value');
grid on;

% Summary statistics about the Residuals
Residuals_interceptModel.mean = mean(mean_Residuals,'omitnan');
Residuals_interceptModel.std = std(mean_Residuals,'omitnan');
Residuals_interceptModel.min = min(mean_Residuals);
Residuals_interceptModel.max = max(mean_Residuals);

%% Plot of Real data vs predicted for the session vs predicted with global mena betas
sess = 1;

% Predicted with the mean betas
PS_sess = PS_all{sess};

% 2)  Time‑expanded design matrix that was used for fitting 
%     Artifacts are set to 0 in the matrix
X_sess = PS_sess.unfold.Xdc;                             % sparse N_obs × Ncol

% 3)  Global Beta-coefficient vector that matches Xdc
% Order of the Betas for the different events inside the GroupResult.unfold.meanBetas
% they are sorted alphabetically and not in the order of the events!
% 1×1150×5 double (: , : , 1) = First Fixation
% 1×1150×5 double (: , : , 2) = Fixation Cross Onset
% 1×1150×5 double (: , : , 3) = Frame Saccade Onset
% 1×1150×5 double (: , : , 4) = Picture Onset
% 1×1150×5 double (: , : , 5) = Reaction

% Right order of the events, in the way they are stored in the sparse design matrix:
% Col    1-1150 = Fixation Corss Onset
% Col 1151-2300 = Picture Onset
% Col 2301-3450 = Frame Saccade Onset
% Col 3451-4600 = Picture Onset
% Col 4601-5750 = Frame Saccade Onset

% Wanted order of the layers from  GroupResult.unfold.meanBetas to match
% the order of the events: [2, 4, 3, 1, 5]

% Other option: Change code when creating the GroupBeta Results, so it put
% the events in the crrect order there.

% The global mean betas need to be put in the right order!
meanBetas_reordered = GroupResult.unfold.meanBetas(:, :, [2, 4, 3, 1, 5]);  %put in the right order
betaVec_global = meanBetas_reordered(:);   % Ncol × 1

% 4)  Calculating the predicted signal of sess and the group betas
predicted_sess_global  = X_sess * betaVec_global;   % Nobs × 1 (sparse × dense → dense)


% Plot comparing residuals with filtered data.
figure('Name','Comparison of data: Original vs predicted data','NumberTitle','off');

hold on;
% % 1) Filtered data 
% plot(pupilSizeRightFilt{sess}, 'LineWidth',1.5, 'Color', [1 0 1],  'DisplayName','Filtered'); %magenta

% 2) Filtered + Artifacts to 0 
p = plot(pupilSizeRight_artifactsTo0{sess}, 'Color', [0.722, 0.718, 0.659], 'LineWidth', 1.0, 'DisplayName','Filt + Artifacts = 0'); %magenta
p.Color(4) = 0.4;  % Set alpha to 0.4

% % 3) Residuals
% plot(Residuals_sess{sess}, 'LineWidth',1.0, 'Color', [0 0 0], 'DisplayName','Residuals'); %black

% 4) Predicted data
plot(Predicted_sess{sess}, 'LineWidth',1.0, 'Color', [0 0 0], 'DisplayName','Predicted - betas of session 1'); %black

% 5) Predicted data with gloabl Betas
plot(predicted_sess_global, 'LineWidth',1.0, 'Color', [0 0 1], 'DisplayName','Predicted - global betas'); %blue

% The events of the session (until 30000)
% Trial 1
xline(1158, '--k', 'Label','Fix Cross Onset','LabelVerticalAlignment','top','LabelHorizontalAlignment','left','HandleVisibility','off');
xline(1883, '--c', 'Label','Picture Onset','LabelVerticalAlignment','top','LabelHorizontalAlignment','left','HandleVisibility','off');
xline(1957, '--b', 'Label','Frame Saccade Onset','LabelVerticalAlignment','top','LabelHorizontalAlignment','left','HandleVisibility','off');
xline(1981, '--r', 'Label','First Fixation','LabelVerticalAlignment','top','LabelHorizontalAlignment','right','HandleVisibility','off');
xline(2768, '--g', 'Label','Reaction','LabelVerticalAlignment','top','LabelHorizontalAlignment','left','HandleVisibility','off');
% Blinks inside Trial 1
% xline(1409, '--m', 'Label','Blink Start','LabelVerticalAlignment','top','LabelHorizontalAlignment','left','HandleVisibility','off');
% xline(1456, '--m', 'Label','Blink End','LabelVerticalAlignment','top','LabelHorizontalAlignment','right','HandleVisibility','off');
% Trial 2
xline(9450, '--k', 'Label','Fix Cross Onset','LabelVerticalAlignment','top','LabelHorizontalAlignment','left','HandleVisibility','off');
xline(10192, '--c', 'Label','Picture Onset','LabelVerticalAlignment','top','LabelHorizontalAlignment','left','HandleVisibility','off');
xline(10225, '--b', 'Label','Frame Saccade Onset','LabelVerticalAlignment','top','LabelHorizontalAlignment','left','HandleVisibility','off');
xline(10245, '--r', 'Label','First Fixation','LabelVerticalAlignment','top','LabelHorizontalAlignment','right','HandleVisibility','off');
xline(11131, '--g', 'Label','Reaction','LabelVerticalAlignment','top','LabelHorizontalAlignment','left','HandleVisibility','off');
% Blinks inside Trial 2
% xline(9771, '--m', 'Label','Blink Start','LabelVerticalAlignment','top','LabelHorizontalAlignment','left','HandleVisibility','off');
% xline(9786, '--m', 'Label','Blink End','LabelVerticalAlignment','top','LabelHorizontalAlignment','right','HandleVisibility','off');
% Trial 3
xline(12642, '--k', 'Label','Fix Cross Onset','LabelVerticalAlignment','top','LabelHorizontalAlignment','left','HandleVisibility','off');
xline(13242, '--c', 'Label','Picture Onset','LabelVerticalAlignment','top','LabelHorizontalAlignment','left','HandleVisibility','off');
xline(13359, '--b', 'Label','Frame Saccade Onset','LabelVerticalAlignment','top','LabelHorizontalAlignment','left','HandleVisibility','off');
xline(13369, '--r', 'Label','First Fixation','LabelVerticalAlignment','top','LabelHorizontalAlignment','right','HandleVisibility','off');
xline(13658, '--g', 'Label','Reaction','LabelVerticalAlignment','top','LabelHorizontalAlignment','left','HandleVisibility','off');
% Trial 4
xline(15084, '--k', 'Label','Fix Cross Onset','LabelVerticalAlignment','top','LabelHorizontalAlignment','left','HandleVisibility','off');
xline(15692, '--c', 'Label','Picture Onset','LabelVerticalAlignment','top','LabelHorizontalAlignment','left','HandleVisibility','off');
xline(15827, '--b', 'Label','Frame Saccade Onset','LabelVerticalAlignment','top','LabelHorizontalAlignment','left','HandleVisibility','off');
xline(15833, '--r', 'Label','First Fixation','LabelVerticalAlignment','top','LabelHorizontalAlignment','right','HandleVisibility','off');
xline(16151, '--g', 'Label','Reaction','LabelVerticalAlignment','top','LabelHorizontalAlignment','left','HandleVisibility','off');
% Blinks inside Trial 4
% xline(15333, '--m', 'Label','Blink Start','LabelVerticalAlignment','top','LabelHorizontalAlignment','left','HandleVisibility','off');
% xline(15390, '--m', 'Label','Blink End','LabelVerticalAlignment','top','LabelHorizontalAlignment','right','HandleVisibility','off');
% % Lost inside Trial 4
% xline(15314, '--m', 'Label','Lost Start','LabelVerticalAlignment','top','LabelHorizontalAlignment','left','HandleVisibility','off');
% xline(15330, '--m', 'Label','Lost End','LabelVerticalAlignment','top','LabelHorizontalAlignment','right','HandleVisibility','off');


hold off;

% Axes
xlabel('Time [in latency]');
ylabel('Pupil size (a.u.)');
title('Comparison: Original vs predicted data');

% If you want the same y‑range you used for the full‑length plots:
xlim([700 18000]);  % comment this line out for whole data view

grid on;
legend('Location','best');   % automatic placement
clear sess;
%%
% PS_1 = PS_all{1,1};
% uf_erpimage(PS_1,'channel',1)
fprintf('FINISHED\n');

%% 
fprintf ('End of Code reached!\n')