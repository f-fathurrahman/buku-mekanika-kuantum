% This file is part of the WavePacket program package for quantum-mechanical
% simulations, and subject to the GNU General Public license v. 2 or later.
%
% Copyright (C) 2004-2017 Burkhard Schmidt's group
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

if isempty(obj.kin)
    init_kin(obj, 1);
end

% The situation here is very similar to the FFT one. We already have
% the kinetic energy given in DVR, and just need to upgrade it to a full
% multidimensional array. Essentially, the code there can be copied.

kinetic = obj.kin;

kinetic( abs(kinetic) < cutoff ) = 0;
if storage == 's'
    kinetic = sparse(kinetic);
    dvrkin = sparse(space.n_tot, space.n_tot);
else
    dvrkin = zeros(space.n_tot);
end

% Transform to a Pseudo-2D matrix form
indices = cell(space.n_dim);
[indices{:}] = ind2sub(size(space.dvr{1}), (1:space.n_tot));

% Fill it row by row
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
