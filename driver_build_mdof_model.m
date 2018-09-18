% Build MDOF Model Databases
clear
close
clc

%% DEFINE INPTUTS
% Primary Inputs
analysis.model_id = 10;

% Secondary Inputs
analysis.nonlinear = 0;
analysis.dead_load = 1.0;
analysis.live_load = 1.0;
analysis.accidental_torsion = 0;

%% Initial Setup
import build_model.fn_build_model

% Load basic model info
model_table = readtable(['inputs' filesep 'model.csv'],'ReadVariableNames',true);
model = model_table(model_table.id == analysis.model_id,:);

%% Start Analysis
% Create Outputs Directory
output_dir = ['outputs/' model.name{1} filesep 'model data'];
if ~exist(output_dir,'dir')
    mkdir(output_dir);
end

%% Build Model
fn_build_model( model, analysis, output_dir )