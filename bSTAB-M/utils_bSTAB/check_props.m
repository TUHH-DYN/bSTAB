function [props] = check_props(props)

% 18.03.2021
% -------------------------------------------------------------------------
% Copyright (C) 2020 Merten Stender (m.stender@tuhh.de)
% Hamburg University of Technology, Dynamics Group, www.tuhh.de/dyn

% This program is free software: you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the
% Free Software Foundation, either version 3 of the License, or (at your
% option) any later version.

% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
% Public License for more details.

% You should have received a copy of the GNU General Public License along
% with this program. If not, see http://www.gnu.org/licenses/
% -------------------------------------------------------------------------

% if the user did not specify a custom function to extract some amplitude
% value from the steady-state time trajectories: set the default (which is
% simply the abs. maximum per state)

        if ~isfield(props, 'eval')
            props.eval.ampFun = @extract_amps; 
        else
            if ~isfield(props.eval, 'ampFun')
                props.eval.ampFun = @extract_amps;
            end
        end

end