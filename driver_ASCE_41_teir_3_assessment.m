%% Clear the Workspace
clear
close
clc
fclose('all');

%% Description: Method to build an Opensees model and run a ASCE 41-17 teir 3 seismic assessment.

% Created By: Dustin Cook
% Date Created: 1/2/2019

% Inputs:

% Outputs:

% Assumptions:

%% User Inputs (Think about changing this to a file read and command line execution)
analysis.model_id = 11;
analysis.proceedure = 'NDP'; % LDP or NDP or test
analysis.id = 23; % ID of the analysis for it to create its own directory
analysis.summit = 1; % Write tcl files to be run on summit and change location of opensees call
analysis.gm_seq_id = 12; % Maybe also make this part ot the defaults or model?

%% Initial Setup
import asce_41.main_ASCE_41

%% Secondary Inputs
[ analysis ] = fn_analysis_options( analysis );

%% Initiate Analysis
tic
main_ASCE_41( analysis )
toc

