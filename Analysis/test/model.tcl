#  Define the model (2 dimensions, 3 dof 
model basic -ndm 2 -ndf 3 
# define nodes (inches) 
node 1 0.000000 0.000000 
node 2 300.000000 0.000000 
node 3 600.000000 0.000000 
node 4 900.000000 0.000000 
node 5 1200.000000 0.000000 
node 6 1500.000000 0.000000 
node 7 0.000000 198.000000 
node 8 300.000000 198.000000 
node 9 600.000000 198.000000 
node 10 900.000000 198.000000 
node 11 1200.000000 198.000000 
node 12 1500.000000 198.000000 
node 13 0.000000 360.000000 
node 14 300.000000 360.000000 
node 15 600.000000 360.000000 
node 16 900.000000 360.000000 
node 17 1200.000000 360.000000 
node 18 1500.000000 360.000000 
node 19 0.000000 522.000000 
node 20 300.000000 522.000000 
node 21 600.000000 522.000000 
node 22 900.000000 522.000000 
node 23 1200.000000 522.000000 
node 24 1500.000000 522.000000 
node 25 0.000000 684.000000 
node 26 300.000000 684.000000 
node 27 600.000000 684.000000 
node 28 900.000000 684.000000 
node 29 1200.000000 684.000000 
node 30 1500.000000 684.000000 
node 31 0.000000 846.000000 
node 32 300.000000 846.000000 
node 33 600.000000 846.000000 
node 34 900.000000 846.000000 
node 35 1200.000000 846.000000 
node 36 1500.000000 846.000000 
node 37 0.000000 1004.400000 
node 38 300.000000 1004.400000 
node 39 600.000000 1004.400000 
node 40 900.000000 1004.400000 
node 41 1200.000000 1004.400000 
node 42 1500.000000 1004.400000 
# set boundary conditions at each node (3dof) (fix = 1, free = 0) 
fix 1 1 1 1 
fix 2 1 1 1 
fix 3 1 1 1 
fix 4 1 1 1 
fix 5 1 1 1 
fix 6 1 1 1 
fix 7 0 0 0 
fix 8 0 0 0 
fix 9 0 0 0 
fix 10 0 0 0 
fix 11 0 0 0 
fix 12 0 0 0 
fix 13 0 0 0 
fix 14 0 0 0 
fix 15 0 0 0 
fix 16 0 0 0 
fix 17 0 0 0 
fix 18 0 0 0 
fix 19 0 0 0 
fix 20 0 0 0 
fix 21 0 0 0 
fix 22 0 0 0 
fix 23 0 0 0 
fix 24 0 0 0 
fix 25 0 0 0 
fix 26 0 0 0 
fix 27 0 0 0 
fix 28 0 0 0 
fix 29 0 0 0 
fix 30 0 0 0 
fix 31 0 0 0 
fix 32 0 0 0 
fix 33 0 0 0 
fix 34 0 0 0 
fix 35 0 0 0 
fix 36 0 0 0 
fix 37 0 0 0 
fix 38 0 0 0 
fix 39 0 0 0 
fix 40 0 0 0 
fix 41 0 0 0 
fix 42 0 0 0 
# define nodal masses (horizontal) (units?) 
mass 1 0.000000 0. 0. 
mass 2 0.000000 0. 0. 
mass 3 0.000000 0. 0. 
mass 4 0.000000 0. 0. 
mass 5 0.000000 0. 0. 
mass 6 0.000000 0. 0. 
mass 7 0.569948 0. 0. 
mass 8 1.139896 0. 0. 
mass 9 1.139896 0. 0. 
mass 10 1.139896 0. 0. 
mass 11 1.139896 0. 0. 
mass 12 0.569948 0. 0. 
mass 13 0.602332 0. 0. 
mass 14 1.204663 0. 0. 
mass 15 1.204663 0. 0. 
mass 16 1.204663 0. 0. 
mass 17 1.204663 0. 0. 
mass 18 0.602332 0. 0. 
mass 19 0.602332 0. 0. 
mass 20 1.204663 0. 0. 
mass 21 1.204663 0. 0. 
mass 22 1.204663 0. 0. 
mass 23 1.204663 0. 0. 
mass 24 0.602332 0. 0. 
mass 25 0.602332 0. 0. 
mass 26 1.204663 0. 0. 
mass 27 1.204663 0. 0. 
mass 28 1.204663 0. 0. 
mass 29 1.204663 0. 0. 
mass 30 0.602332 0. 0. 
mass 31 0.602332 0. 0. 
mass 32 1.204663 0. 0. 
mass 33 1.204663 0. 0. 
mass 34 1.204663 0. 0. 
mass 35 1.204663 0. 0. 
mass 36 0.602332 0. 0. 
mass 37 0.492228 0. 0. 
mass 38 0.984456 0. 0. 
mass 39 0.984456 0. 0. 
mass 40 0.984456 0. 0. 
mass 41 0.984456 0. 0. 
mass 42 0.492228 0. 0. 
# Linear Transformation 
geomTransf Linear 1 
# Define Elements (columns and beam) 
# element elasticBeamColumn <element id> <start node> <end node> <area sq in> <E ksi> <I in4> <$transfTag> 
element elasticBeamColumn 1 1 7 2304.000000 4030.000000 110592.000000 1 
element elasticBeamColumn 2 2 8 2304.000000 4030.000000 110592.000000 1 
element elasticBeamColumn 3 3 9 2304.000000 4030.000000 110592.000000 1 
element elasticBeamColumn 4 4 10 2304.000000 4030.000000 110592.000000 1 
element elasticBeamColumn 5 5 11 2304.000000 4030.000000 110592.000000 1 
element elasticBeamColumn 6 6 12 2304.000000 4030.000000 110592.000000 1 
element elasticBeamColumn 7 7 13 3264.000000 4030.000000 96640.000000 1 
element elasticBeamColumn 8 8 14 3264.000000 4030.000000 96640.000000 1 
element elasticBeamColumn 9 9 15 3264.000000 4030.000000 96640.000000 1 
element elasticBeamColumn 10 10 16 3264.000000 4030.000000 96640.000000 1 
element elasticBeamColumn 11 11 17 3264.000000 4030.000000 96640.000000 1 
element elasticBeamColumn 12 12 18 3264.000000 4030.000000 96640.000000 1 
element elasticBeamColumn 13 13 19 3264.000000 4030.000000 96640.000000 1 
element elasticBeamColumn 14 14 20 3264.000000 4030.000000 96640.000000 1 
element elasticBeamColumn 15 15 21 3264.000000 4030.000000 96640.000000 1 
element elasticBeamColumn 16 16 22 3264.000000 4030.000000 96640.000000 1 
element elasticBeamColumn 17 17 23 3264.000000 4030.000000 96640.000000 1 
element elasticBeamColumn 18 18 24 3264.000000 4030.000000 96640.000000 1 
element elasticBeamColumn 19 19 25 3264.000000 4030.000000 96640.000000 1 
element elasticBeamColumn 20 20 26 3264.000000 4030.000000 96640.000000 1 
element elasticBeamColumn 21 21 27 3264.000000 4030.000000 96640.000000 1 
element elasticBeamColumn 22 22 28 3264.000000 4030.000000 96640.000000 1 
element elasticBeamColumn 23 23 29 3264.000000 4030.000000 96640.000000 1 
element elasticBeamColumn 24 24 30 3264.000000 4030.000000 96640.000000 1 
element elasticBeamColumn 25 25 31 3264.000000 4030.000000 96640.000000 1 
element elasticBeamColumn 26 26 32 3264.000000 4030.000000 96640.000000 1 
element elasticBeamColumn 27 27 33 3264.000000 4030.000000 96640.000000 1 
element elasticBeamColumn 28 28 34 3264.000000 4030.000000 96640.000000 1 
element elasticBeamColumn 29 29 35 3264.000000 4030.000000 96640.000000 1 
element elasticBeamColumn 30 30 36 3264.000000 4030.000000 96640.000000 1 
element elasticBeamColumn 31 31 37 3264.000000 4030.000000 96640.000000 1 
element elasticBeamColumn 32 32 38 3264.000000 4030.000000 96640.000000 1 
element elasticBeamColumn 33 33 39 3264.000000 4030.000000 96640.000000 1 
element elasticBeamColumn 34 34 40 3264.000000 4030.000000 96640.000000 1 
element elasticBeamColumn 35 35 41 3264.000000 4030.000000 96640.000000 1 
element elasticBeamColumn 36 36 42 3264.000000 4030.000000 96640.000000 1 
element elasticBeamColumn 37 7 8 2880.000000 3605.000000 216000.000000 1 
element elasticBeamColumn 38 8 9 2880.000000 3605.000000 216000.000000 1 
element elasticBeamColumn 39 9 10 2880.000000 3605.000000 216000.000000 1 
element elasticBeamColumn 40 10 11 2880.000000 3605.000000 216000.000000 1 
element elasticBeamColumn 41 11 12 2880.000000 3605.000000 216000.000000 1 
element elasticBeamColumn 42 13 14 2520.000000 3605.000000 370440.000000 1 
element elasticBeamColumn 43 14 15 2520.000000 3605.000000 370440.000000 1 
element elasticBeamColumn 44 15 16 2520.000000 3605.000000 370440.000000 1 
element elasticBeamColumn 45 16 17 2520.000000 3605.000000 370440.000000 1 
element elasticBeamColumn 46 17 18 2520.000000 3605.000000 370440.000000 1 
element elasticBeamColumn 47 19 20 2520.000000 3605.000000 370440.000000 1 
element elasticBeamColumn 48 20 21 2520.000000 3605.000000 370440.000000 1 
element elasticBeamColumn 49 21 22 2520.000000 3605.000000 370440.000000 1 
element elasticBeamColumn 50 22 23 2520.000000 3605.000000 370440.000000 1 
element elasticBeamColumn 51 23 24 2520.000000 3605.000000 370440.000000 1 
element elasticBeamColumn 52 25 26 2520.000000 3605.000000 370440.000000 1 
element elasticBeamColumn 53 26 27 2520.000000 3605.000000 370440.000000 1 
element elasticBeamColumn 54 27 28 2520.000000 3605.000000 370440.000000 1 
element elasticBeamColumn 55 28 29 2520.000000 3605.000000 370440.000000 1 
element elasticBeamColumn 56 29 30 2520.000000 3605.000000 370440.000000 1 
element elasticBeamColumn 57 31 32 2520.000000 3605.000000 370440.000000 1 
element elasticBeamColumn 58 32 33 2520.000000 3605.000000 370440.000000 1 
element elasticBeamColumn 59 33 34 2520.000000 3605.000000 370440.000000 1 
element elasticBeamColumn 60 34 35 2520.000000 3605.000000 370440.000000 1 
element elasticBeamColumn 61 35 36 2520.000000 3605.000000 370440.000000 1 
element elasticBeamColumn 62 37 38 2440.000000 3605.000000 316333.000000 1 
element elasticBeamColumn 63 38 39 2440.000000 3605.000000 316333.000000 1 
element elasticBeamColumn 64 39 40 2440.000000 3605.000000 316333.000000 1 
element elasticBeamColumn 65 40 41 2440.000000 3605.000000 316333.000000 1 
element elasticBeamColumn 66 41 42 2440.000000 3605.000000 316333.000000 1 
