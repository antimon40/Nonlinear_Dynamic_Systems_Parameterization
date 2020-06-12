% Nonlinear function
% By: Sebastian A. Nugroho
% Date: 8/27/2018

function [x_out] = nonlinear_function_all(sys,param,x_in,symb)

    %initialize x_out
    if symb == true
        x_out = sym(zeros(sys.n,1));
    else
        x_out = zeros(sys.n,1);     
    end

%     %Get traffic network parameters
%     [param] = traffic_network_parameters();

    %Define constant c
%     c = param.vf/(param.rho_max*param.l);
    c = param.a; 

    %Select function based on mode
    if (isequal(sys.mode,'uncongested'))
        for i = 1:sys.n
            if i == 1
                x_out(i) = c*x_in(i)^2;
            elseif ((i > 1) && (i <= sys.N)) %Stretched highway
                for j = 1:sys.N_IO %Highway sections having BOTH on-ramps and off-ramps
                    if sys.E_N(i) == sys.E_IO(j)
                        for k1 = 1:sys.N_I
                            if sys.E_IO(j) == sys.E_I(k1)
                                break;
                            end
                        end
                        for k2 = 1:sys.N_O
                            if sys.E_IO(j) == sys.E_O(k2)
                                break;
                            end
                        end
                        x_out(i) = c*(x_in(i)^2-x_in(i-1)^2-x_in(sys.N+k1)^2+sys.SpR(k2)*x_in(sys.N+sys.N_I+k2)^2);
                        break;
                    end
                end
                for j = 1:sys.N_I_not_IO %Highway sections having on-ramps ONLY
                    if sys.E_N(i) == sys.E_I_not_IO(j)
                        for k1 = 1:sys.N_I
                            if sys.E_I_not_IO(j) == sys.E_I(k1)
                                break;
                            end
                        end
                        x_out(i) = c*(x_in(i)^2-x_in(i-1)^2-x_in(sys.N+k1)^2);
                        break;
                    end
                end 
                for j = 1:sys.N_O_not_IO %Highway sections having off-ramps ONLY
                    if sys.E_N(i) == sys.E_O_not_IO(j)
                        for k2 = 1:sys.N_O
                            if sys.E_O_not_IO(j) == sys.E_O(k2)
                                break;
                            end
                        end
                        x_out(i) = c*(x_in(i)^2-x_in(i-1)^2+sys.SpR(k2)*x_in(sys.N+sys.N_I+k2)^2);
                        break;
                    end
                end 
                for j = 1:sys.N_not_I_or_O %Highway sections having no on-ramps NOR off-ramps
                    if sys.E_N(i) == sys.E_not_I_or_O(j)
                        x_out(i) = c*(x_in(i)^2-x_in(i-1)^2);
                        break;
                    end
                end
            elseif ((i > sys.N) && (i <= sys.N + sys.N_I)) %On-ramps
                x_out(i) = c*x_in(i)^2;
            elseif i > sys.N + sys.N_I %Off-ramps  
                x_out(i) = -sys.SpR(i-sys.N-sys.N_I)*c*x_in(i)^2;
            end
        end
    elseif (isequal(sys.mode,'congested'))
        for i = 1:sys.n
            if i == sys.N
                x_out(i) = -c*x_in(i)^2;
            elseif ((i >= 1) && (i < sys.N)) %Stretched highway
                for j = 1:sys.N_IO %Highway sections having BOTH on-ramps and off-ramps
                    if sys.E_N(i) == sys.E_IO(j)
                        for k1 = 1:sys.N_I
                            if sys.E_IO(j) == sys.E_I(k1)
                                break;
                            end
                        end
                        for k2 = 1:sys.N_O
                            if sys.E_IO(j) == sys.E_O(k2)
                                break;
                            end
                        end
                        x_out(i) = c*(x_in(i+1)^2-x_in(i)^2-x_in(sys.N+k1)^2+sys.SpR(k2)*x_in(sys.N+sys.N_I+k2)^2);
                        break;
                    end
                end
                for j = 1:sys.N_I_not_IO %Highway sections having on-ramps ONLY
                    if sys.E_N(i) == sys.E_I_not_IO(j)
                        for k1 = 1:sys.N_I
                            if sys.E_I_not_IO(j) == sys.E_I(k1)
                                break;
                            end
                        end
                        x_out(i) = c*(x_in(i+1)^2-x_in(i)^2-x_in(sys.N+k1)^2);
                        break;
                    end
                end 
                for j = 1:sys.N_O_not_IO %Highway sections having off-ramps ONLY
                    if sys.E_N(i) == sys.E_O_not_IO(j)
                        for k2 = 1:sys.N_O
                            if sys.E_O_not_IO(j) == sys.E_O(k2)
                                break;
                            end
                        end
                        x_out(i) = c*(x_in(i+1)^2-x_in(i)^2+sys.SpR(k2)*x_in(sys.N+sys.N_I+k2)^2);
                        break;
                    end
                end 
                for j = 1:sys.N_not_I_or_O %Highway sections having no on-ramps NOR off-ramps
                    if sys.E_N(i) == sys.E_not_I_or_O(j) 
                        x_out(i) = c*(x_in(i+1)^2-x_in(i)^2);
                        break;
                    end
                end
            elseif ((i > sys.N) && (i <= sys.N + sys.N_I)) %On-ramps
                x_out(i) = c*x_in(i)^2;
            elseif i > sys.N + sys.N_I %Off-ramps  
                x_out(i) = -sys.SpR(i-sys.N-sys.N_I)*c*x_in(i)^2;
            end
        end
    end

end