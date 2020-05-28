function [Cov2] = clean_up_Cov(Cov,C)
%input: Cov is a cover struct
%input: C is struct for cover
%output: new Cov with empty elements removed 
%description: remove empty elements from Cov 
%Author: Sebastian A. Nugroho
%Date: 1/31/2019

%Traverse Cov
if (length(Cov.dat) == 1) && isempty(Cov.dat{1})
    Cov2 = Cov;
    return;
else
    Cov2 = C;
    Cov2.dat = {[]};
    n_el = length(Cov.dat);
    ctr = 1;
    for i =1:n_el
        if ~isempty(Cov.dat{i})
            Cov2.dat{ctr} = Cov.dat{i};
            ctr = ctr + 1;
        end
    end
end
end