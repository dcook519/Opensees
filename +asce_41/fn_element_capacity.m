function [ ele, ele_TH, ele_PM ] = fn_element_capacity( story, ele, ele_prop, ele_TH, nonlinear )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Import Packages
import asce_41.*
import aci_318.*

% Preallocate Variables
ele_PM = [];
if sum(strcmp('P_grav',ele.Properties.VariableNames)) == 0
    ele.P_grav = 0;
end
if sum(strcmp('Pmax',ele.Properties.VariableNames)) == 0
    ele.Pmax = ele.P_grav;
end

ele.Mn_grav_pos_1 = NaN;
ele.Mn_grav_pos_2 = NaN;
ele.Mn_grav_neg_1 = NaN;
ele.Mn_grav_neg_2 = NaN;
ele.P_max_idx = 0;

%% Calc Axial Capacity
% Axial Compression Capacity per ACI (use lower bound strength since assuming axial is force controlled)
[ ~, ele.Pn_c, ~, ~ ] = fn_aci_axial_capacity( ele_prop.fc_n, ele_prop.a, ele_prop.As, ele_prop.fy_n );

% Axial Tension Capacity per ACI (use expected strength since tension is deformation controlled)
[ ~, ~, ~, ele.Pn_t ] = fn_aci_axial_capacity( ele_prop.fc_e, ele_prop.a, ele_prop.As, ele_prop.fy_e );

% Axial Capacity Time History
if ~isempty(ele_TH)
    for i = 1:length(ele_TH.P_TH)
        % Axial Capacity
        if ele_TH.P_TH(i) >= 0 
            ele_TH.Pn(i) = ele.Pn_c; % Compressive Capacity is the same for each timestep
            [ ele_TH.P_TH_linear(i) ] = fn_force_controlled_action( ele_TH.P_TH(i), ele.P_grav, 'cp', 'high', 1, 1 ); % Use force controlled axial loads for linear procedures
        else
            ele_TH.Pn(i) = ele.Pn_t; % Tensile Capacity is the same for each timestep
            ele_TH.P_TH_linear(i) = ele_TH.P_TH(i); % Tensile Capacity for linear procedures is not force controlled
        end
    end
end

for i = 1:2 % Calc properiteis on each side of the element
    %% Calc Moment Capacity
    if contains(ele_prop.description,'rigid')
        ele.(['Mn_pos_' num2str(i)]) = inf;
        ele.(['Mn_neg_' num2str(i)]) = inf;
        ele.(['Mn_oop_' num2str(i)]) = inf;
        ele.(['Mp_pos_' num2str(i)]) = inf;
        ele.(['Mp_neg_' num2str(i)]) = inf;
        ele.(['Mp_oop_' num2str(i)]) = inf;
        if ~isempty(ele_TH)
            ele_TH.(['Mn_pos_' num2str(i)]) = inf;
            ele_TH.(['Mn_neg_' num2str(i)]) = inf;
            ele_TH.(['Mn_oop_' num2str(i)]) = inf;
            ele_TH.(['Mp_pos_' num2str(i)]) = inf;
            ele_TH.(['Mp_neg_' num2str(i)]) = inf;
            ele_TH.(['Mp_oop_' num2str(i)]) = inf;
            ele_TH.(['Mn_pos_linear_' num2str(i)]) = inf;
            ele_TH.(['Mn_neg_linear_' num2str(i)]) = inf;
        end
    else
        if strcmp(ele.type,'beam') % beams
            % Moment Capcity per ACI (assume no axial loads for beams)
            [ ~, ele.(['Mn_pos_' num2str(i)]) ] = fn_aci_moment_capacity( 'pos', ele_prop.fc_e, ele_prop.w, ele_prop.h, ele_prop.As, ele_prop.As_d, ele_prop.fy_e, ele_prop.Es, 0, ele_prop.slab_depth, ele_prop.b_eff );
            [ ~, ele.(['Mn_neg_' num2str(i)]) ] = fn_aci_moment_capacity( 'neg', ele_prop.fc_e, ele_prop.w, ele_prop.h, ele_prop.As, ele_prop.As_d, ele_prop.fy_e, ele_prop.Es, 0, ele_prop.slab_depth, ele_prop.b_eff );
            [ ~, ele.(['Mn_oop_' num2str(i)]) ] = fn_aci_moment_capacity( 'oop', ele_prop.fc_e, ele_prop.h, ele_prop.w, ele_prop.As, ele_prop.As_d, ele_prop.fy_e, ele_prop.Es, 0, 0, 0 );
            [ ~, ele.(['Mp_pos_' num2str(i)]) ] = fn_aci_moment_capacity( 'pos', ele_prop.fc_e*1.15, ele_prop.w, ele_prop.h, ele_prop.As, ele_prop.As_d, ele_prop.fy_e*1.15, ele_prop.Es, 0, ele_prop.slab_depth, ele_prop.b_eff );
            [ ~, ele.(['Mp_neg_' num2str(i)]) ] = fn_aci_moment_capacity( 'neg', ele_prop.fc_e*1.15, ele_prop.w, ele_prop.h, ele_prop.As, ele_prop.As_d, ele_prop.fy_e*1.15, ele_prop.Es, 0, ele_prop.slab_depth, ele_prop.b_eff );
            [ ~, ele.(['Mp_oop_' num2str(i)]) ] = fn_aci_moment_capacity( 'oop', ele_prop.fc_e*1.15, ele_prop.h, ele_prop.w, ele_prop.As, ele_prop.As_d, ele_prop.fy_e*1.15, ele_prop.Es, 0, 0, 0 );
            % Moment Capacity Time History
            if ~isempty(ele_TH)
                ele_TH.(['Mn_pos_' num2str(i)]) = ones(1,length(ele_TH.P_TH))*ele.(['Mn_pos_' num2str(i)]);
                ele_TH.(['Mn_neg_' num2str(i)]) = ones(1,length(ele_TH.P_TH))*ele.(['Mn_neg_' num2str(i)]);
                ele_TH.(['Mn_oop_' num2str(i)]) = ones(1,length(ele_TH.P_TH))*ele.(['Mn_oop_' num2str(i)]);
                ele_TH.(['Mp_pos_' num2str(i)]) = ones(1,length(ele_TH.P_TH))*ele.(['Mp_pos_' num2str(i)]);
                ele_TH.(['Mp_neg_' num2str(i)]) = ones(1,length(ele_TH.P_TH))*ele.(['Mp_neg_' num2str(i)]);
                ele_TH.(['Mp_oop_' num2str(i)]) = ones(1,length(ele_TH.P_TH))*ele.(['Mp_oop_' num2str(i)]);
                ele_TH.(['Mn_pos_linear_' num2str(i)]) = ele_TH.(['Mn_pos_' num2str(i)]);
                ele_TH.(['Mn_neg_linear_' num2str(i)]) = ele_TH.(['Mn_neg_' num2str(i)]);
            end
        else % columns and walls
            % PM Interactions
            if ~isempty(ele_TH)
                vector_P = linspace(-0.9*ele.Pn_t,ele.Pn_c,25); % axial force range
                for j = 1:length(vector_P) % Currently Assumes Column has uniform strength in each directions (ie symmetric layout)
                    [ ~, vector_M(j) ] = fn_aci_moment_capacity( 'pos', ele_prop.fc_e, ele_prop.w, ele_prop.h, ele_prop.As, ele_prop.As_d, ele_prop.fy_e, ele_prop.Es, vector_P(j), 0, 0 );
                    [ ~, vector_Mp(j) ] = fn_aci_moment_capacity( 'pos', ele_prop.fc_e, ele_prop.w, ele_prop.h, ele_prop.As, ele_prop.As_d, 1.15*ele_prop.fy_e, ele_prop.Es, vector_P(j), 0, 0 );
                    [ ~, vector_M_oop(j) ] = fn_aci_moment_capacity( 'oop', ele_prop.fc_e, ele_prop.h, ele_prop.w, ele_prop.As, ele_prop.As_d, ele_prop.fy_e, ele_prop.Es, vector_P(j), 0, 0 );
                    [ ~, vector_Mp_oop(j) ] = fn_aci_moment_capacity( 'oop', ele_prop.fc_e, ele_prop.h, ele_prop.w, ele_prop.As, ele_prop.As_d, 1.15*ele_prop.fy_e, ele_prop.Es, vector_P(j), 0, 0 );
                end
                % Save PM Structure
                ele_PM.(['vector_P_' num2str(i)]) = [-ele.Pn_t, vector_P, ele.Pn_c];
                ele_PM.(['vector_M_' num2str(i)]) = [0, vector_M, 0];
                % Moment Capacity Time History
                load_history = ele_TH.P_TH;
                load_history(load_history > max(vector_P)) = max(vector_P); % Keep the axial load history within the bounds of the PM diagram so that we don't get NaNs with the interp
                load_history(load_history < min(vector_P)) = min(vector_P); % This shouldn't really matter unless I load a linear model too heavily

                load_history_linear = ele_TH.P_TH_linear;
                load_history_linear(load_history_linear > max(vector_P)) = max(vector_P); % Keep the axial load history within the bounds of the PM diagram so that we don't get NaNs with the interp
                load_history_linear(load_history_linear < min(vector_P)) = min(vector_P);

                ele_TH.(['Mn_pos_' num2str(i)]) = interp1(vector_P,vector_M,load_history);
                ele_TH.(['Mn_neg_' num2str(i)]) = ele_TH.(['Mn_pos_' num2str(i)]); % assumes columns are the same in both directions
                ele_TH.(['Mn_oop_' num2str(i)]) = interp1(vector_P,vector_M_oop,load_history);
                ele_TH.(['Mp_pos_' num2str(i)]) = interp1(vector_P,vector_Mp,load_history);
                ele_TH.(['Mp_neg_' num2str(i)]) = ele_TH.(['Mp_pos_' num2str(i)]); % assumes columns are the same in both directions
                ele_TH.(['Mp_oop_' num2str(i)]) = interp1(vector_P,vector_Mp_oop,load_history);
                ele_TH.(['Mn_pos_linear_' num2str(i)]) = interp1(vector_P,vector_M,load_history_linear);
                ele_TH.(['Mn_neg_linear_' num2str(i)]) = ele_TH.(['Mn_pos_linear_' num2str(i)]); % assumes columns are the same in both directions
                % Moment Capcity
                [~, ele.P_max_idx] = min(abs(load_history-ele.Pmax));
                % Use Maximum axial from analysis to find capacity
                ele.(['Mn_pos_' num2str(i)]) = ele_TH.(['Mn_pos_' num2str(i)])(ele.P_max_idx); 
                ele.(['Mn_neg_' num2str(i)]) = ele_TH.(['Mn_neg_' num2str(i)])(ele.P_max_idx);
                ele.(['Mn_oop_' num2str(i)]) = ele_TH.(['Mn_oop_' num2str(i)])(ele.P_max_idx);
                ele.(['Mp_pos_' num2str(i)]) = ele_TH.(['Mp_pos_' num2str(i)])(ele.P_max_idx);
                ele.(['Mp_neg_' num2str(i)]) = ele_TH.(['Mp_neg_' num2str(i)])(ele.P_max_idx);
                ele.(['Mp_oop_' num2str(i)]) = ele_TH.(['Mp_oop_' num2str(i)])(ele.P_max_idx);
                % Find moment capacity at gravity load
                P_grav_idx = 1; % The very first step is the closest to the gravity load (could change this to explicityly calc at the exact grav load)
                ele.(['Mn_grav_pos_' num2str(i)]) = ele_TH.(['Mn_pos_' num2str(i)])(P_grav_idx);
                ele.(['Mn_grav_neg_' num2str(i)]) = ele_TH.(['Mn_neg_' num2str(i)])(P_grav_idx);
            else
                [ ~, ele.(['Mn_pos_' num2str(i)]) ] = fn_aci_moment_capacity( 'pos', ele_prop.fc_e, ele_prop.w, ele_prop.h, ele_prop.As, ele_prop.As_d, ele_prop.fy_e, ele_prop.Es, 0, 0, 0 );
                [ ~, ele.(['Mn_neg_' num2str(i)]) ] = fn_aci_moment_capacity( 'neg', ele_prop.fc_e, ele_prop.w, ele_prop.h, ele_prop.As, ele_prop.As_d, ele_prop.fy_e, ele_prop.Es, 0, 0, 0 );
                [ ~, ele.(['Mn_oop_' num2str(i)]) ] = fn_aci_moment_capacity( 'oop', ele_prop.fc_e, ele_prop.h, ele_prop.w, ele_prop.As, ele_prop.As_d, ele_prop.fy_e, ele_prop.Es, 0, 0, 0 );
                [ ~, ele.(['Mp_pos_' num2str(i)]) ] = fn_aci_moment_capacity( 'pos', ele_prop.fc_e*1.15, ele_prop.w, ele_prop.h, ele_prop.As, ele_prop.As_d, ele_prop.fy_e*1.15, ele_prop.Es, 0, 0, 0 );
                [ ~, ele.(['Mp_neg_' num2str(i)]) ] = fn_aci_moment_capacity( 'neg', ele_prop.fc_e*1.15, ele_prop.w, ele_prop.h, ele_prop.As, ele_prop.As_d, ele_prop.fy_e*1.15, ele_prop.Es, 0, 0, 0 );
                [ ~, ele.(['Mp_oop_' num2str(i)]) ] = fn_aci_moment_capacity( 'oop', ele_prop.fc_e*1.15, ele_prop.h, ele_prop.w, ele_prop.As, ele_prop.As_d, ele_prop.fy_e*1.15, ele_prop.Es, 0, 0, 0 );
                ele.(['Mn_grav_pos_' num2str(i)]) = ele.(['Mn_pos_' num2str(i)]); 
                ele.(['Mn_grav_neg_' num2str(i)]) = ele.(['Mn_neg_' num2str(i)]);
            end
        end
    end

    %% Shear Capacity
    % Shear check 10.3.4
    if ele_prop.(['S_' num2str(i)]) > ele_prop.d_eff
        ele.(['effective_shear_rein_factor_' num2str(i)]) = 0; %Transverse Reinforcement Spaced too far apart. Transverse reinforcement is ineffective in resiting shear
    elseif ele_prop.(['S_' num2str(i)]) > ele_prop.d_eff/2
        ele.(['effective_shear_rein_factor_' num2str(i)]) = 2*(1-ele_prop.(['S_' num2str(i)])/ele_prop.d_eff); % Transverse Reinforcement Spaced too far apart. Reduce effectivenes of transverse reinforcement
    else
        ele.(['effective_shear_rein_factor_' num2str(i)]) = 1;
    end
    eff_fyt_e = ele_prop.fy_e*ele.(['effective_shear_rein_factor_' num2str(i)]);

    % Vye and Diplacement Ductility
    [  ele.(['disp_duct_' num2str(i)]), ele.(['vye_' num2str(i)]), ele.(['vye_oop_' num2str(i)]) ] = fn_disp_ductility( ele.(['Mn_pos_' num2str(i)]), ele.(['Mn_neg_' num2str(i)]), ele.(['Mn_oop_' num2str(i)]), ele, ele_prop, story, eff_fyt_e, ele_prop.(['Av_' num2str(i)]), ele_prop.(['S_' num2str(i)]));

    % Shear capacity is not a function of time
    if strcmp(ele.type,'column')
        % Determine Ductility Factors
        if nonlinear % for nonlinear use the displacement ductility
            ductility_factor = ele.(['disp_duct_' num2str(i)]); 
        else % for linear use max DCR
            ductility_factor = ele.DCR_raw_max_V; 
        end

        % The yield displacement is the lateral displacement of the column, determined using the effective rigidities 
        % from Table 10-5, at a shear demand resulting in flexural yielding of the plastic hinges, VyE.
        if isempty(ele_TH)
            [ ele.(['Vn_' num2str(i)]), ele.(['V0_' num2str(i)]) ] = fn_shear_capacity( ele_prop.(['Av_' num2str(i)]), eff_fyt_e, ele_prop.d_eff, ele_prop.(['S_' num2str(i)]), ele_prop.lambda, ele_prop.fc_e, ele_prop.a, 3*ele_prop.d_eff, 1, ele.P_grav, ductility_factor );
        else
            [ ele.(['Vn_' num2str(i)]), ele.(['V0_' num2str(i)]) ] = fn_shear_capacity( ele_prop.(['Av_' num2str(i)]), eff_fyt_e, ele_prop.d_eff, ele_prop.(['S_' num2str(i)]), ele_prop.lambda, ele_prop.fc_e, ele_prop.a, ele_TH.(['M_TH_' num2str(i)]), ele_TH.(['V_TH_' num2str(i)]), ele.P_grav, ductility_factor );
        end
        ele.(['Vs_' num2str(i)]) = NaN;
    else
        [ ~, ele.(['Vn_' num2str(i)]), ele.(['Vs_' num2str(i)]) ] = fn_aci_shear_capacity( ele_prop.fc_e, ele_prop.w, ele_prop.h, ele_prop.(['Av_' num2str(i)]), eff_fyt_e, ele_prop.(['S_' num2str(i)]), ele_prop.lambda, ele_prop.a, ele_prop.hw, ele.type, ele_prop.d_eff );
        ele.(['V0_' num2str(i)]) = NaN;
    end 

    % Shear capacity time history is uniform (this is not quite correct since
    % shear capacity depends on Axial load for columns (through ductility
    % factor)) However, only used to calculate dcrs for linear analysis.
    if ~isempty(ele_TH)
        ele_TH.(['Vn_' num2str(i)]) = ones(1,length(ele_TH.P_TH))*ele.(['Vn_' num2str(i)]);
    end

    %% Perform Checks
    % Balanced Moment Capcity and Reinforcement Ratio
    [ ele.row_bal ] = fn_balanced_moment( ele_prop.fc_e, ele_prop.fy_e );

    % Determine Flexure v Shear Critical
    [ ele.(['critical_mode_' num2str(i)]) , ele.(['critical_mode_oop_' num2str(i)]), ele.model_shear_deform  ] = fn_element_critical_mode( ele, ele_prop, ele.(['Vn_' num2str(i)]), ele.(['vye_' num2str(i)]), ele.(['vye_oop_' num2str(i)]) );

    % If Shear controlled, reduce Mn for beams and columns and joints
    % Ignoring time history capacity modifications (may only affect linear)
    if strcmp(ele.(['critical_mode_' num2str(i)]),'shear') && ~strcmp(ele.type,'wall')
        ele.(['Mn_pos_' num2str(i)]) = ele.(['Mn_pos_' num2str(i)])*ele.(['Vn_' num2str(i)])/ele.(['vye_' num2str(i)]);
        ele.(['Mn_neg_' num2str(i)]) = ele.(['Mn_neg_' num2str(i)])*ele.(['Vn_' num2str(i)])/ele.(['vye_' num2str(i)]);
        ele.(['Mp_pos_' num2str(i)]) = ele.(['Mn_pos_' num2str(i)]); % no strain hardening if shear controlled
        ele.(['Mp_neg_' num2str(i)]) = ele.(['Mn_neg_' num2str(i)]) ; % no strain hardening if shear controlled
    end

    if strcmp(ele.(['critical_mode_oop_' num2str(i)]),'shear') && ~strcmp(ele.type,'wall')
        ele.(['Mn_oop_' num2str(i)]) = ele.(['Mn_oop_' num2str(i)])*ele.(['Vn_' num2str(i)])/ele.(['vye_oop_' num2str(i)]);
        ele.(['Mp_oop_' num2str(i)]) = ele.(['Mp_oop_' num2str(i)])*ele.(['Vn_' num2str(i)])/ele.(['vye_oop_' num2str(i)]);
    end

    % Wall Checks
    if sum(strcmp('Pmax',ele.Properties.VariableNames)) == 1
        if strcmp(ele.type,'wall')
            % For walls controlled by shear, if axial loads are too high
            if strcmp(ele.(['critical_mode_' num2str(i)]),'shear') && ele.Pmax > 0.15*ele_prop.a*ele_prop.fc_e % ASCE 41-17 table 10-20 note b
                warning('Wall is force controlled, too much axial load')
            end
            % Are the axial loads too high for lateral resistance
            if ele.Pmax > 0.35*ele.Pn_c 
                warning('Wall has too much axial load to take lateral force, modify model')
            end
        end
    end

    % % Check 10.3.3 (if not using timeshenko beams)
    % if ele.Vmax >= 6*sqrt(ele_prop.fc_e)*ele_prop.a
    %     error('Shear too High for model assumptions. Use deformation that is 80% of the value from the analytical model')
    % end
end

% End Function
end

