function [props] = update_props(props, field, value)
% [props] = update_props(field,value)

% to do: check the correct type of <value>

eval(['props.', field, ' = ', num2str(value), ';']); 


end

