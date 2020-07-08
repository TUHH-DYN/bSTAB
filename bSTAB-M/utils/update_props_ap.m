function [props] = update_props_ap(props, iter_idx)
% [props] = update_props_ap(props, iter_idx)

% to do: check the correct type of <value> to be consistent with the type
% of the original entry of props.field

switch props.ap_study.mode
    
    case 'hyper_parameter'
        % update the props entry. Unfortunately, we will have to use 'eval'
        % for this job.
        value = props.ap_study.ap_values(iter_idx);
        eval(['props.', props.ap_study.ap, ' = ', num2str(value), ';']);
        
    case 'model_parameter'
        
        % replace the model parameter vector at the index
        % (props.ap_study.ap) with the value props.ap_study.ap_values for
        % the current index of the parameter variation loop
        props.model.ode_params(props.ap_study.ap) = props.ap_study.ap_values(iter_idx);
        
    otherwise
        
        error('sorry, this type of parameter variation is not supported');
end


end

