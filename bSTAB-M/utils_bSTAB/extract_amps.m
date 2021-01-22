function [amps] = extract_amps(T, Y, props)

amps = max(abs(Y), [], 1);
end
