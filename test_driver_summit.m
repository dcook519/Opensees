%% Test Very Simple Opensees model on summit

clear all
close all
clc

disp('Matlab Open and Starting Opensees ...')
command = ['mpirun -np 1 /projects/duco1061/software/OpenSeesSP/bin/OpenSeesSP ' 'test_run_summit' filesep 'run_analysis.tcl'];
% command = ['opensees ' 'test_run_summit' filesep 'run_analysis.tcl'];
[status,cmdout] = system(command,'-echo');
disp('Opensees Finished')