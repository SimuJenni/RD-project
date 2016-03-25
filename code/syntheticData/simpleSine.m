function [ sineFun ] = simpleSine
%SIMPLESINE Generates a function-handle for a simple sine-function for use
%with MAKESYNTHETIC
%   See also MAKESYNTHETIC.

sineFun = @(freq, amp, phase, t) amp*sin(2*pi*freq*t+phase);

end

