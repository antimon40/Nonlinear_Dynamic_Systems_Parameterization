function [Cov] = add_S1_S2_to_Cov(Cov,S1,S2)
%input: Cov is a cover struct
%input: S1 and S2 are hyperrectangles
%output: Cov with added S1 and S2
%description: add S1 and S2 to Cov
%warning: Cov must not contain empty elements
%Author: Sebastian A. Nugroho
%Date: 1/31/2019

%Number of elements S in Cov
if length(Cov.dat) == 1
    if isempty(Cov.dat{1})
        n_el = 0;
        Cov.dat{1} = S1;
        Cov.dat{2} = S2;
        return;
    else
        n_el = length(Cov.dat);
    end
else
    n_el = length(Cov.dat);
end

%Add S1 and S2 to Cov
Cov.dat{n_el+1} = S1;
Cov.dat{n_el+2} = S2;
end