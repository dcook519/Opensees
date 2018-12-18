% Run Tcl file in opensees5
clear
close
clc

%% DEFINE INPTUTS
% Primary Inputs
analysis.model_id = 9;
analysis.gm_seq_id = 6;
analysis.name = 'test';

% Secondary Inputs
analysis.type = 1; % 1 = dynamic, 2 = pushover % 3 = static cyclic
analysis.model_type = 2; % 1 = SDOF, 2 = MDOF
analysis.pushover_drift = 0.015;
analysis.pushover_num_steps = 500;
analysis.pushover_direction = 'x';
analysis.ground_motion_scale_factor = 10;
analysis.nonlinear = 1; % 1 = IMK Rotational Hinge, 2 = strain hardening hinges
analysis.dead_load = 1.0;
analysis.live_load = 1.0;
analysis.accidental_torsion = 0;
analysis.damping = 'rayleigh';
analysis.damp_ratio = 0.05;
analysis.hinge_stiff_mod = 10;
analysis.play_movie = 1;
analysis.movie_scale = 1;
analysis.run_eigen = 1;
analysis.run_opensees = 1;
analysis.initial_timestep_factor = 1;
analysis.solution_algorithm = 1;
analysis.collapse_drift = 0.25;  
analysis.joint_model = 2; % 1 = elastic elements, 2 = joint 3D
analysis.full_recorders = 0; % 0 = simple recorders, 1 = full recorders
analysis.rigid_diaphram = 1;

%% Initial Setup
import opensees.main_opensees_analysis

%% Run Opensees Analysis
main_opensees_analysis( analysis )




