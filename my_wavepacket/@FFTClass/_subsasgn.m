% ffr: This is disabled. It gave some problems.
% ffr: This is caused by access to global variable space
% ffr: For the moment, some of the limitations must be checked manually.

function obj = subsasgn(obj, index, val)
    
global space

% We allow only setting of the parameters that are needed,
% otherwise always return an error.
if index.type == '.'
    switch index.subs
        case 'label'
            obj.label = val;
        case 'dof'
            if val > space.n_dim
                prt.error ('too large value for index "dof" assigned');
            end
            obj.dof = val;
            % If necessary, convert obj.dof into a label for this d.o.f.
            if isempty(obj.label)
                if space.n_dim > 1
                    obj.label = int2str(obj.dof);
                else
                    obj.label = '';
                end
            end
        case 'n_pts'
            % Check for an even number of grid points!
            if val ~= 2*round(val/2)
                prt.error ('Number of grid points must be even');
            end
            obj.n_pts = val;
        case 'mass'
            if val <= 0
                prt.error ('Non-positive mass assigned');
            end
            obj.mass = val;
        case 'periodic'
            if ~islogical(val) || length(val) ~= 1
                prt.error('Need to supply a boolean value for "periodic"')
            end
            obj.periodic = val;
        case 'x_min'
            if ~isempty(obj.x_max) && obj.x_max <= val
                prt.error ('maximum grid point should be greater than minimum one');
            end
            obj.x_min = val;
        case 'x_max'
            if ~isempty(obj.x_min) && obj.x_min >= val
                prt.error ('maximum grid point should be greater than minimum one');
            end
            obj.x_max = val;
        case 'nokin'
            if ~islogical(val) || length(val) ~= 1
                prt.error('Need to supply a boolean value for "nokin"')
            end
            obj.nokin = val;
        otherwise
            prt.error ( ['Tried to set invalid field ' index.subs 'in FFT DVR object'] );
    end
end
