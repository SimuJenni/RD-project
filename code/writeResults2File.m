function writeResults2File(resultsDir, fileName, roiSize, method, power,...
            freqs, domFreqs  )
%WRITERESULTS2FILE Writes results to a text-file result.txt in resultsDir.
% Each line in the .txt file corresponds to one video and the format of the
% line is as follows:
% FileName Method ROISize MainFreq DomFreq
% Method - Either 'fft' or 'wt' as specified by parameter 'method'
% MainFreq - Dominant Frequency in ROI with maximum activity
% DomFreq - Most frequent dominant per-ROI frequency 

% Drop .mat extension
fileName = fileName(1:end-4);

% Specify the format for the specs: [ Filename Method ROI ]
formatSpecs = '%35s %8s %10s';

% Specify the format of the results: [ Specs MainFreq DomFreq ] 
formatResults = '%s %10.2f %10.2f \n';   

% Check if file already exists and create if not
resultFile = 'results.txt';
if ~exist(resultFile, 'file')
    % File does not exist -> create and add header
    fid = fopen([resultsDir resultFile], 'w');
    modelSpecs = sprintf(formatSpecs, 'Filename', 'Method', 'ROI-Size');
    fprintf(fid, '%s %10s %10s \n', modelSpecs, 'Main-Freq', 'Dom-Freq' );
    fclose(fid);
end

% Read lines from result file
fid = fopen([resultsDir resultFile]);
C = textscan(fid,'%s','delimiter','\n');
fclose(fid);

% Check if results for this model have already been saved
modelSpecs = sprintf(formatSpecs, fileName, method, ['[' num2str(roiSize) ']']);
g = strfind(C{1}, strtrim(modelSpecs));
rows = find(~cellfun('isempty', g));
if ~isempty(rows)
    % Already result computed -> delete previous results
    fid = fopen([resultsDir resultFile], 'w');
    newLines = C{1};
    newLines(rows) = [];
    
    fclose(fid);
end

fid = fopen([resultsDir resultFile], 'a+');
fprintf(fid, formatResults, modelSpecs, 10.0, 20);
fclose(fid);


end

