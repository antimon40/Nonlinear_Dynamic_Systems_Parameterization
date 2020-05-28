function [Cov,S] = remove_S_from_Cov(Cov,cr,L,C,epsilon)
%input: Cov is a cover struct
%input: cr is criteria: 'ub', 'lb', 'L'
%input: L is the biggest lower bound known
%input: C is struct for cover
%output: new Cov with S
%description: remove S from Cov based on Cr
%Author: Sebastian A. Nugroho
%Date: 1/31/2019

%Number of elements S in Cov
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

if isequal(cr,'ub') %Remove S from Cov with the biggest upper bound
    temp = -Inf;
    ctr_pos = 0;
    %Traverse Cov for S with the biggest upper bound
    for i = 1:n_el
        if temp < Cov.dat{i}.ub
            temp = Cov.dat{i}.ub;
            ctr_pos = i;
        end
    end
    %Remove S from Cov
    S = Cov.dat{ctr_pos};
    Cov.dat{ctr_pos} = [];
    Cov = clean_up_Cov(Cov,C);
elseif isequal(cr,'lb') %Remove S from Cov with the biggest lower bound and not atomic
    temp = -Inf;
    ctr_pos = 0;
    %Traverse Cov for S with the biggest lower bound
    for i = 1:n_el
        if (temp < Cov.dat{i}.lb) && (~is_atomic_hrec(Cov.dat{i},epsilon))
            temp = Cov.dat{i}.lb;
            ctr_pos = i;
        end
    end
    %Remove S from Cov
    S = Cov.dat{ctr_pos};
    Cov.dat{ctr_pos} = [];
    Cov = clean_up_Cov(Cov,C);
elseif isequal(cr,'L') %Remove S from Cov if its upper bound is smaller than L
    %Traverse Cov for S with upper bound smaller than L
    is_anything_removed = false;
    S_temp = {};
    ctr = 1;
    for i = 1:n_el
        if Cov.dat{i}.ub < L
            %Remove S from Cov
            S = Cov.dat{i};
            S_temp{ctr} = S;
            Cov.dat{i} = [];
            is_anything_removed = true;
            ctr = ctr + 1;
        elseif (i == n_el) && ~is_anything_removed
            S_temp = [];
        end
    end
    S = S_temp;
    Cov = clean_up_Cov(Cov,C);
end

end