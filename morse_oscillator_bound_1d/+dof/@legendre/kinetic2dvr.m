% This file is part of the WavePacket program package for quantum-mechanical
% simulations, and subject to the GNU General Public license v. 2 or later.
%
% Copyright (C) 2007 Martin Winter
%               2007-2008 Ulf Lorenz
%               2011 Ulf Lorenz
%
% see the README file for license details.

function dvrkin = kinetic2dvr(obj,cutoff,storage)

global space


if obj.nokin
    dvrkin = zeros(space.n_tot,space.n_tot);
    return;
end


% The situation here is again almost identical to the other grids. Two slight
% complications arise.
%
% 1. Our kinetic energy matrix is initially given in FBR
% 2. The kinetic energy consists of two terms. 1/i2mR^2, and L^2, which
%    affect different degrees of freedom.
%
% We solve the first problem by transforming L^2 into DVR. Then, we only handle
% the L^2 matrix throughout the whole procedure, and apply 1/2mR^2 only at the
% very end.

% First, construct L^2, and transform it into DVR
kinetic = diag(space.dof{obj.dof}.p_grid.^2);
kinetic = obj.trafo2dvr * kinetic * obj.trafo2fbr;

kinetic( abs(kinetic) < cutoff ) = 0;
if storage == 's'
    kinetic = sparse(kinetic);
    dvrkin = sparse(space.n_tot, space.n_tot);
else
    dvrkin = zeros(space.n_tot);
end

% Create full matrix, and fill it row by row
indices = cell(space.n_dim);
[indices{:}] = ind2sub(size(space.dvr{1}), (1:space.n_tot));

for ii = 1:space.n_tot
    allowed    = ones(space.n_tot, 1);

    % Now disallow all indices, where the other dimension's indices change,
    % which translates to a zero matrix element
    for k = 1:space.n_dim
        if k == obj.dof
            continue;
        end

        allowed(indices{k} ~= indices{k}(ii)) = 0;
    end

    % get the indices of the allowed cells, and fill the row
    allowedindex = find(allowed);
    dvrkin(ii, allowedindex) = kinetic( indices{obj.dof}(ii), indices{obj.dof}(allowedindex) );
end

% Apply the additional factor 1/2mR^2
if ~isempty(obj.R_0)
    dvrkin = dvrkin / (2 * obj.mass * obj.R_0^2);
else
    for ii = 1:space.n_tot
        dvrkin(ii, :) = dvrkin(ii, :) / (2 * obj.mass *space.dvr{obj.R_dof}(ii));
    end
end
