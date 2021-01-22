function [props] = check_props(props)


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