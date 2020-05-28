function y = is_atomic_Cov(Cov,epsilon)
%input: Cov is a cover struct, epsilon is the tolerance
%output: boolean
%description: true if all S in Cov are atomic relative to epsilon
%Author: Sebastian A. Nugroho
%Date: 1/31/2019

%Traverse Cov
if (length(Cov.dat) == 1) && (isempty(Cov.dat{1}))
    y = true;
    return;
else
    n_el = length(Cov.dat);
    for i =1:n_el
        if is_atomic_hrec(Cov.dat{i},epsilon)
            y = true;
        else
            y = false;
            break;
        end
    end
end

end