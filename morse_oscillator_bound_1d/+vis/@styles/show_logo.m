%--------------------------------------------------------------------------
%
% Include logos in the four corners of a plot 
%
%--------------------------------------------------------------------------

% This file is part of the WavePacket program package for quantum-mechanical
% simulations, and subject to the GNU General Public license v. 2 or later.
%
% Copyright (C) 2004-2017 Burkhard Schmidt's group
%               2007-2009 Ulf Lorenz
%
% see the README file for license details.

function show_logo (obj)
global info

% Upper left: WavePacket name, program, and GIT hash value
string1 = info.package;
string2 = info.program;
string3 = info.version1;
h = annotation('textbox');
set(h, ...
    'Position',            [0.0 0.5 0.5 0.5], ... % [left bottom width height]
    'HorizontalAlignment', 'left', ...
    'VerticalAlignment',   'top', ...
    'Interpreter',         'none', ...
    'LineStyle',           'none', ...
    'String',              { string1, string2, string3 }, ...
    'FontName',            obj.f_name, ...
    'FontSize',            obj.f_small, ...
    'FontWeight',          obj.f_heavy, ...
    'FitBoxToText',        'off')

% Upper right: Host name, date, and time
string1 = info.host_name;
string2 = date;
c = clock;
string3 = strcat ( num2str(c(4),'%2.2i'), ':', num2str(c(5),'%2.2i'));
h = annotation('textbox');
set(h, ...
    'Position',            [0.5 0.5 0.5 0.5], ... % [left bottom width height]
    'HorizontalAlignment', 'right', ...
    'VerticalAlignment',   'top', ...
    'Interpreter',         'none', ...
    'LineStyle',           'none', ...
    'String',              { string1, string2, string3 }, ...
    'FontName',            obj.f_name, ...
    'FontSize',            obj.f_small, ...
    'FontWeight',          obj.f_heavy, ...
    'FitBoxToText',        'off')

% Lower left: User name and MATLAB release
string1 = ['User: ' info.user_name];
if strcmpi(info.system,'Matlab')
    string2 = ['MATLAB Release R' info.release];
elseif strcmpi(info.system,'Octave')
    string2 = ['Octave Release ' info.release];
end
h = annotation('textbox');
set(h, ...
    'Position',            [0.0 0.01 0.5 0.5], ... % [left bottom width height]
    'HorizontalAlignment', 'left', ...
    'VerticalAlignment',   'bottom', ...
    'Interpreter',         'none', ...
    'LineStyle',           'none', ...
    'String',              { string1, string2 }, ...
    'FontName',            obj.f_name, ...
    'FontSize',            obj.f_small, ...
    'FontWeight',          obj.f_heavy, ...
    'FitBoxToText',        'off')

% Lower right: Full path name (if too long, truncate it) and GIT hash value
string1 = info.path_name;
string2 = info.version2;
if numel(string1) > 48
    string1 = prt.shorten(string1);
end
h = annotation('textbox');
set(h, ...
    'Position',            [0.5 0.01 0.5 0.5], ... % [left bottom width height]
    'HorizontalAlignment', 'right', ...
    'VerticalAlignment',   'bottom', ...
    'Interpreter',         'none', ...
    'LineStyle',           'none', ...
    'String',              { string1, string2 }, ...
    'FontName',            obj.f_name, ...
    'FontSize',            obj.f_small, ...
    'FontWeight',          obj.f_heavy, ...
    'FitBoxToText',        'off')

end
