function [ ] = fn_solution_algorithm( fileID, analysis, write_dir, analysis_length, step_length, primary_nodes, story_ht, control_node, control_dof )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% Set Solution Algorithm Parameters
min_tolerance_steps = 10;
mid_tolerance_steps = 50;
max_tolerance_steps = 500;

% Set loop factors
if analysis.type == 1 % Dynamic
    step_reduction = [1,10,20,100];
else
    step_reduction = [1,10,20,100];
end
algorithm_typs = { 'NewtonLineSearch', 'SecantNewton', 'KrylovNewton'};
% tolerance = [1e-5, 1e-4 0.001, 0.01, 0.1, 1];
tolerance = [0.00001, 0.0001, 0.001, 0.01];
% tolerance = [0.1, 1];

%% Set up Log Files
log_file = [write_dir '/converge_tol_file.txt'];
fprintf(fileID,'set converge_tol_file [open %s w] \n', log_file);
convergence_file = [write_dir '/converge_file.txt'];
fprintf(fileID,'set converge_file [open %s w] \n', convergence_file);

%% Set up some extra loop functionality for running cyclic motions
if analysis.type == 3
    analysis_lengths_cyclic = analysis_length*analysis.cyclic_pushover_peak_drifts;
    cycle_leg_vec = [1,-1,0];
else
    analysis_lengths_cyclic = analysis_length;
    cycle_leg_vec = 1;
end

for i = 1:length(analysis_lengths_cyclic)
for j = 1:length(cycle_leg_vec)
    analysis_length = analysis_lengths_cyclic(i)*cycle_leg_vec(j);
    if j == 2
        step_length = -step_length;
        % While loop through each step of the ground motion
        fprintf(fileID,'while {$ok == 0 && $currentStep > %f && $collapse_check == 0 && $singularity_check == 0} { \n',analysis_length);
    elseif analysis_length < 0
        % While loop through each step of the ground motion
        fprintf(fileID,'while {$ok == 0 && $currentStep > %f && $collapse_check == 0 && $singularity_check == 0} { \n',analysis_length);
    else
        % While loop through each step of the ground motion
        fprintf(fileID,'while {$ok == 0 && $currentStep < %f && $collapse_check == 0 && $singularity_check == 0} { \n',analysis_length);
    end

%% While loop through each step of the ground motion
% fprintf(fileID,'while {$ok == 0 && $currentStep < %f && $collapse_check == 0 && $singularity_check == 0} { \n',analysis_length);

% Output current time progress
if ~analysis.suppress_outputs
    fprintf(fileID,'puts "Progress: $currentStep out of %f" \n',analysis_length);
end

% Run analysis step with basic props
fprintf(fileID,'set tol %f \n', tolerance(1));
fprintf(fileID,'test NormDispIncr $tol %i \n', min_tolerance_steps);
% fprintf(fileID,'test EnergyIncr $tol %i \n', min_tolerance_steps);
fprintf(fileID,'algorithm %s \n',analysis.algorithm);
if analysis.type == 1 % Dynamic
    fprintf(fileID,'set dt_reduce %f \n', 1);
    fprintf(fileID,'set dt [expr %f/$dt_reduce] \n', step_length);
    fprintf(fileID,'set dt_max %f \n', step_length);
    fprintf(fileID,'set dt_min [expr %f/($dt_reduce*100)] \n', step_length);
    fprintf(fileID,'set ok [analyze 1 $dt $dt_min $dt_max] \n');
elseif analysis.type == 2 || analysis.type == 3 % Pushover or Cyclic
    fprintf(fileID,'set step_size %f \n', step_length);
    fprintf(fileID,'integrator DisplacementControl %i %i $step_size \n', control_node, control_dof);
    fprintf(fileID,'set ok [analyze 1] \n');
end
% fprintf(fileID,'puts "analysis failure = $ok " \n');

% Loop Through Tolerance
for tol = 1:length(tolerance)

    % Loop Though dt
    for t = 1:length(step_reduction)

        % Loop Through Algorithms
%         for a = 1:length(algorithm_typs)
            fprintf(fileID,'if {$ok != 0} { \n');
%             fprintf(fileID,'puts "analysis failed, try try tolerance = %f, step_length/%f, and algorithm = %s" \n', tolerance(tol), step_reduction(t), algorithm_typs{1});
%             fprintf(fileID,'puts "analysis failed, try try tolerance = %f, step_length/%f" \n', tolerance(tol), step_reduction(t));
            fprintf(fileID,'set tol %f \n', tolerance(tol));
            if tol <= 2
                fprintf(fileID,'test NormDispIncr $tol %i \n', min_tolerance_steps);
%                 fprintf(fileID,'test EnergyIncr $tol %i \n', min_tolerance_steps);
            elseif tol <=3
                fprintf(fileID,'test NormDispIncr $tol %i \n', mid_tolerance_steps);
%                 fprintf(fileID,'test EnergyIncr $tol %i \n', mid_tolerance_steps);
            else
                fprintf(fileID,'test NormDispIncr $tol %i \n', max_tolerance_steps);
%                 fprintf(fileID,'test EnergyIncr $tol %i \n', max_tolerance_steps);
            end
%             fprintf(fileID,'algorithm %s \n', algorithm_typs{a});
            if analysis.type == 1 % Dynamic
                fprintf(fileID,'set step_reduce %f \n', step_reduction(t));
                fprintf(fileID,'set dt [expr %f/$step_reduce] \n', step_length);
                fprintf(fileID,'set ok [analyze 1 $dt] \n');
            elseif analysis.type == 2 || analysis.type == 3 % Pushover or Static Cyclic
                fprintf(fileID,'set step_size %f \n', step_length/step_reduction(t));
                fprintf(fileID,'integrator DisplacementControl %i %i $step_size \n', control_node, control_dof);
                fprintf(fileID,'set ok [analyze 1] \n');
            end
            fprintf(fileID,'} \n');
%         end
    end
end

% Output time
if analysis.type == 1 % Dynamic
    fprintf(fileID,'set currentStep [getTime] \n');
elseif analysis.type == 2 || analysis.type == 3 % Pushover or Cyclic
    fprintf(fileID,'set currentStep [expr $currentStep + $step_size] \n');
end

% Save info to log file
fprintf(fileID,'set converge_tol_log "$currentStep $tol" \n');
fprintf(fileID,'puts $converge_tol_file $converge_tol_log \n');

%% Check for singularity and collapse
fprintf(fileID,'if {$ok == 0} { \n');
for s = 1:length(primary_nodes)
    % Define Displacements
    fprintf(fileID,'set node_at_floor_%s %i \n', num2str(s), primary_nodes(s));
    fprintf(fileID,'set height_floor_%s %f \n', num2str(s), story_ht(s));
    fprintf(fileID,'set floor_displ_%s_x "[nodeDisp $node_at_floor_%s 1]" \n', num2str(s), num2str(s));
    fprintf(fileID,'set floor_displ_%s_z "[nodeDisp $node_at_floor_%s 3]" \n', num2str(s), num2str(s));
    if s == 1
        fprintf(fileID,'set floor_drift_%s_x [expr $floor_displ_%s_x/$height_floor_%s] \n', num2str(s), num2str(s), num2str(s));
        fprintf(fileID,'set floor_drift_%s_z [expr $floor_displ_%s_z/$height_floor_%s] \n', num2str(s), num2str(s), num2str(s));
    else
        fprintf(fileID,'set floor_drift_%s_x [expr ($floor_displ_%s_x - $floor_displ_%s_x)/$height_floor_%s] \n', num2str(s), num2str(s), num2str(s-1), num2str(s));
        fprintf(fileID,'set floor_drift_%s_z [expr ($floor_displ_%s_z - $floor_displ_%s_z)/$height_floor_%s] \n', num2str(s), num2str(s), num2str(s-1), num2str(s));
    end
    
    % Check for Singularity in x direction
    fprintf(fileID,'set check_QNAN_1 [string first QNAN $floor_displ_%s_x 1] \n', num2str(s));
    fprintf(fileID,'set check_IND_1 [string first IND $floor_displ_%s_x 1] \n', num2str(s));
    fprintf(fileID,'if {([expr abs($floor_displ_%s_x)] > 1000000) || ($check_QNAN_1 != -1) || ($check_IND_1 != -1)} { \n', num2str(s));
    fprintf(fileID,'set singularity_check 1 \n');
    fprintf(fileID,'} \n');
    
    % Check for Singularity in z direction
    fprintf(fileID,'set check_QNAN_1 [string first QNAN $floor_displ_%s_z 1] \n', num2str(s));
    fprintf(fileID,'set check_IND_1 [string first IND $floor_displ_%s_z 1] \n', num2str(s));
    fprintf(fileID,'if {([expr abs($floor_displ_%s_z)] > 1000000) || ($check_QNAN_1 != -1) || ($check_IND_1 != -1)} { \n', num2str(s));
    fprintf(fileID,'set singularity_check 1 \n');
    fprintf(fileID,'} \n');

    % Check for Collapse
    if analysis.collapse_drift > 0
        % Collapse in x direction
        fprintf(fileID,'if {[expr abs($floor_drift_%s_x)] > %f} { \n', num2str(s), analysis.collapse_drift);
        fprintf(fileID,'set collapse_check 1 \n');
        fprintf(fileID,'puts "Collapse on story %i in the x direction" \n', s);
        fprintf(fileID,'} \n');
        % Collapse in z direction
        fprintf(fileID,'if {[expr abs($floor_drift_%s_z)] > %f} { \n', num2str(s), analysis.collapse_drift);
        fprintf(fileID,'set collapse_check 1 \n');
        fprintf(fileID,'puts "Collapse on story %i in the z direction" \n', s);
        fprintf(fileID,'} \n');
    end
end
fprintf(fileID,'} \n');
fprintf(fileID,'} \n');

end
end

%% Check if Model Fully Converged
if analysis.type == 1 % Dynamic
    fprintf(fileID,'if {$currentStep > %f || $singularity_check == 1 || $collapse_check == 1} { \n',0.98*analysis_length); % 98 percent of the way through the analysis
    fprintf(fileID,'puts "Analysis Fully Converged" \n');
    fprintf(fileID,'puts $converge_file 1 \n');
    fprintf(fileID,'} else { \n');
    fprintf(fileID,'puts "Analysis NOT FULLY Converged" \n');
    fprintf(fileID,'puts $converge_file 0 \n');
    fprintf(fileID,'} \n');
end

%% Close Log Files
fprintf(fileID,'close $converge_tol_file \n');
fprintf(fileID,'close $converge_file \n');
end

