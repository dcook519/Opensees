function [ model, element, torsion, node ] = fn_basic_analysis_properties( model, story, element, node )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

% Building Properties
model.num_stories = length(story.id);

% Default DCR
model.DCR_raw_max = 4; % Set to middle of interp if not already defined (ie create a k factor of 0.85)
element.DCR_raw_max_V = model.DCR_raw_max*ones(height(element),1);

% Torsion effect
torsion.x = story.torsional_factor_x;
if sum(strcmp('torsional_factor_z',story.Properties.VariableNames)) > 0
    torsion.z = story.torsional_factor_z;
else
    torsion.z = story.torsional_factor_x;
end

for s = 1:height(story)
    node.TAR_x(node.story == s & node.on_slab == 1) = node.max_disp_x(node.story == s & node.on_slab == 1) ./ story.ave_disp_x(s);
    if any(strcmp(node.Properties.VariableNames,'max_disp_z'))
        node.TAR_z(node.story == s & node.on_slab == 1) = node.max_disp_z(node.story == s & node.on_slab == 1) ./ story.ave_disp_z(s);
    end
end

if any(strcmp(node.Properties.VariableNames,'max_disp_z'))
    node.TAR_srss = sqrt(node.TAR_x.^2 + node.TAR_z.^2);
end
end

