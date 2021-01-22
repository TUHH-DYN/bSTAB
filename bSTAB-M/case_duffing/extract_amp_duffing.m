function [amps] = extract_amp_duffing(T, Y, props)

amps = max(abs(Y), [], 1);
end
