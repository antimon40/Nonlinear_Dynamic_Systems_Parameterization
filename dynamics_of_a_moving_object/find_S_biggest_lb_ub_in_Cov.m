function [S] = find_S_biggest_lb_ub_in_Cov(Cov,cr)
%input: Cov is a cover struct
%input: cr is criteria: 'ub', 'lb'
%output: S with the biggest lower bound/upper bound
%description: find S with the biggest lower bound if cr is 'lb' and
% biggest upper bound if cr is 'ub' 
%Author: Sebastian A. Nugroho
%Date: 1/31/2019

if length(Cov.dat) == 1
    if isempty(Cov.dat{1})
        n_el = 0;
        S = [];
        return;
    else
        n_el = length(Cov.dat);
    end
else
    if isempty(Cov.dat{1})
        n_el = length(Cov.dat)-1;
    else
        n_el = length(Cov.dat);
    end
end

if isequal(cr,'lb') %Find S in Cov with biggest lower bound
    temp = -Inf;
    ctr_pos = 0;
    %Traverse Cov for S with the biggest lower bound
    for i = 1:n_el
        if temp < Cov.dat{i}.lb
            temp = Cov.dat{i}.lb;
            ctr_pos = i;
        end
    end
    S = Cov.dat{ctr_pos};
elseif isequal(cr,'ub') %Find S in Cov with biggest upper bound
    temp = -Inf;
    ctr_pos = 0;
    %Traverse Cov for S with the biggest upper bound
    for i = 1:n_el
        if temp < Cov.dat{i}.ub
            temp = Cov.dat{i}.ub;
            ctr_pos = i;
        end
    end
    S = Cov.dat{ctr_pos};
end
    
end