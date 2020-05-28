% Traffic networks parameter
% By: Sebastian A. Nugroho
% Date: 8/26/2018

function [param] = traffic_network_parameters()
    
    %From Observability and Sensor Placement Problem on Highway Segments: A
    %Traffic Dynamics-Based Approach by Contreras et. al.
    
    % Model parameters of Greenshields flux function
    param.vf = 31.3; %free flow speed (meter per second)

    %Maximum density per meter
    param.k_max = 0.053; % maximum density (vehicle per meter)

    % Parameters of highway section
    param.l = 500; %length of a cell in meters

    %Maximum density in each highway section (vehicle per meter)
    param.rho_max = param.k_max;
    
    %Critical density per highway section
    param.rho_c = param.rho_max/2;
    
end