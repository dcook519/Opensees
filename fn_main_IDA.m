function [ exit_status ] = fn_main_IDA(analysis, model, story, element, node, hinge, gm_set_table, gm_idx, scale_factor, building_period, tcl_dir)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

import opensees.write_tcl.*

% Defin gms for this run
ground_motion.x = gm_set_table(gm_idx,:);
ground_motion.x.eq_dir = {['ground_motions' '/' analysis.gm_set '/' ground_motion.x.eq_name{1}]};
ground_motion.x.eq_name = {[ground_motion.x.eq_name{1} '.tcl']};
ground_motion.z = gm_set_table(gm_set_table.set_id == ground_motion.x.set_id & gm_set_table.pair ~= ground_motion.x.pair,:);
ground_motion.z.eq_dir = {['ground_motions' '/' analysis.gm_set '/' ground_motion.z.eq_name{1}]};
ground_motion.z.eq_name = {[ground_motion.z.eq_name{1} '.tcl']};

% Load spectral info and save Sa
spectra_table = readtable([ground_motion.x.eq_dir{1} filesep 'spectra.csv'],'ReadVariableNames',true);
summary.sa_x = interp1(spectra_table.period,spectra_table.psa_5,building_period.ew)*scale_factor;
spectra_table = readtable([ground_motion.z.eq_dir{1} filesep 'spectra.csv'],'ReadVariableNames',true);
summary.sa_z = interp1(spectra_table.period,spectra_table.psa_5,building_period.ns)*scale_factor;

% Write Recorders File
file_name = [opensees_outputs_dir filesep 'recorders.tcl'];
fileID = fopen(file_name,'w');
fprintf(fileID,'puts "Defining Recorders ..."\n');
fprintf(fileID,'setMaxOpenFiles 2000\n');
for n = 1:height(node)
   if node.record_disp(n)
        fprintf(fileID,'recorder Node -xml %s/nodal_disp_%s.xml -time -node %i -dof 1 3 disp\n',opensees_outputs_dir,num2str(node.id(n)),node.id(n));
   end
end
if analysis.nonlinear ~= 0 && ~isempty(hinge)
    for i = 1:height(hinge)
        hinge_y = node.y(node.id == hinge.node_1(i));
        if hinge_y == 0 && strcmp(hinge.direction{i},'primary')
            hinge_id = element.id(end) + hinge.id(i);
%             fprintf(fileID,'recorder Element %s %s/hinge_force_%s.%s -time -ele %s -dof 1 3 4 6 force \n', file_type, write_dir, num2str(hinge_id), file_ext, num2str(hinge_id));
            fprintf(fileID,'recorder Element -xml %s/hinge_deformation_%s.xml -time -ele %s deformation \n', opensees_outputs_dir, num2str(hinge_id), num2str(hinge_id));
        end
    end
end
fclose(fileID);

% Write Loads file
fn_define_loads( opensees_outputs_dir, analysis, node, model.dimension, story, 0, 0, ground_motion )

% Write Analysis Files
first_story_node = node.id(node.primary_story == 1);
fn_setup_analysis( opensees_outputs_dir, tcl_dir, analysis, first_story_node, story )
fn_define_analysis( opensees_outputs_dir, ground_motion, first_story_node, story.story_ht, analysis, story )

% Call Opensees
fprintf('Running Opensess... \n')
if analysis.summit
    command = ['/projects/duco1061/software/OpenSeesSP/bin/OpenSeesSP ' opensees_outputs_dir filesep 'run_analysis.tcl'];
else
    command = ['openseesSP ' opensees_outputs_dir filesep 'run_analysis.tcl'];
end
if analysis.suppress_outputs
    [status,cmdout] = system(command);
else
    [status,cmdout] = system(command,'-echo');
end

% test for analysis failure and terminate Matlab
exit_status = 0;
if contains(cmdout,'Analysis Failure: Collapse')
    summary.collapse = 1; % Collapse triggered by drift limit
    fprintf('Model Reached Collapse Limit \n')
elseif contains(cmdout,'Analysis Failure: Singularity')
    summary.collapse = 2; % Collapse triggered by singularity issue
    fprintf('Unexpected Opensees failure \n')
    fprintf('Model Experienced a Singularity Failure (Treat as collapsed)')
elseif contains(cmdout,'Analysis Failure: Convergence')
    summary.collapse = 3; % Collapse triggered by convergence
    fprintf('Unexpected Opensees failure \n')
    fprintf('Model Experienced a Convergence Failure (Treat as collapsed)')
elseif status ~= 0
    summary.collapse = 4; % Unexpected Opensees failure (shouldnt get here)
    fprintf('UNHANDLED OPENSEES FAILURE \n')
    exit_status = 1;
else
    summary.collapse = 0;
    fprintf('Model Ran Successfully \n')
end

fprintf('Opensees Completed \n')

% Save summary data
save([ida_outputs_dir filesep 'summary_results.mat'],'summary')
end

