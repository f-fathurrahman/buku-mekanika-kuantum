function init_kin(obj, space, time_var, hamilt, fraction, output)
% global space time_var hamilt
% No "arguments are modified except obj

disp(["nargin = " int2str(nargin)])
if nargin < 6
    output = true;
end

obj.kin = space.fbr{obj.dof}.^2 / (2*obj.mass);

% Truncate the kinetic energy at some upper bound.
obj.kin(obj.kin > hamilt.truncate.delta) = hamilt.truncate.delta;

% For the propagation or application of the kinetic energy, it is much
% faster if we don't have to shift around the grids too often (internally,
% these are matrix copies!), so we fftshift the kinetic energy
% grids once here instead of applying it again and again to the wavefunction.
obj.kin_shift = ifftshift(obj.kin, obj.dof);

% Just exponentiate...
obj.kin_expo = exp(-1i * time_var.steps.s_delta * fraction * obj.kin_shift);


%% Don't know another place to put it...
% factor that we need to apply because FFT does not do it. It normalizes the
% wave function in momentum representation and removes a spurious complex phase
obj.kin_factor = sqrt(obj.x_max - obj.x_min) / obj.n_pts ...
        * exp(-1i * space.fbr{obj.dof} * obj.x_min);


%% Informational output

if obj.nokin
    return
end

if output
    prt.disp ('***************************************************************')
    prt.disp ( ['Kinetic energy for FFT degree of freedom: ' obj.label] )
    prt.disp ('***************************************************************')
    prt.disp ('                                                  ')
    prt.disp ('          1  (  d  ) 2                            ')
    prt.disp (' T  =  - --- ( --- )                              ')
    prt.disp ('         2 M ( d R )                              ')
    prt.disp ('                                                  ')
    prt.disp ( ['with mass M : ' num2str(obj.mass)] )
    prt.disp ('                                                  ')
end
