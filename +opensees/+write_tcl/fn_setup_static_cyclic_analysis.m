function [ ] = fn_setup_static_cyclic_analysis( write_dir, analysis )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
    
%% Write Pushover Analysis File
file_name = [write_dir filesep 'setup_static_cyclic_analysis.tcl'];
fileID = fopen(file_name,'w');

% Clear set up for this analysis
fprintf(fileID,'wipe \n');

% Build Model and Analysis Parameters
fprintf(fileID,'source %s/model.tcl \n', write_dir);
if analysis.run_eigen
    fprintf(fileID,'source %s/eigen.tcl \n', write_dir);
end
fprintf(fileID,'source %s/loads.tcl \n', write_dir);
fprintf(fileID,'source %s/recorders.tcl \n', write_dir);

% ANALYSIS DEFINITION
fprintf(fileID,'wipeAnalysis \n');

% Define Constraints
fprintf(fileID,'constraints Transformation \n');

% Define the DOF_numbered object
fprintf(fileID,'numberer RCM \n');

% Construct Linear Solver and linear SOE Objects
if analysis.summit_SP
    fprintf(fileID,'system Mumps \n'); % Use Mumps for OpenseesSP
else
    fprintf(fileID,'system BandGeneral \n');
end

% Test for Convergence
tolerance = 1e-5;
% fprintf(fileID,'test NormDispIncr %f 1000 \n',tolerance);
fprintf(fileID,'test EnergyIncr %f 100 \n',tolerance);

% Define Solution Algorithm
fprintf(fileID,'algorithm Newton \n');

% Close File
fclose(fileID);


end

