% Returns "r" coeficiants that maxe it so that harmonic frequencies of f are composed to make values of y
% Example if f were cos(2*pi*t) : f = @(t) cos(2*pi*t)
% y0 = cos(0 w t0) r0 + cos(1 w t0) r1 + ...
% y1 = cos(0 w t1) r0 + cos(1 w t1) r1 + ...
% n would be 0,1,2,... numel(y)-1
function [r , n] = f_series( y , f , t)
% clear all
% close all
if ~exist('y','var')
    % These are the values that are desired to get. They can be arbitrary
    y = [0 1 2 -2];
end
y=y(:);

if ~exist('f','var') || numel(f) == 0
    % f is expected to be a sinusoid. harmonic frequencies of this sinusoid are used
    f = @(x) cos(2*pi*x);
    f = @(x) sin(2*pi*x);
end

if ~exist('t','var') || numel(t) == 0
    % The default period is from 0 to almost 0.5 since cos / sin functions simply negative repetitions after pi
    t = linspace(0,1-1/numel(y),numel(y)) / 2;
end
if min(t) < 0 || max(t) > 1
    warning('Invalid times specified. Values of t should be between 0 and 1');
end

N = numel(y);
n = 0:(N-1);
s = zeros(N,N);

% Example:
% y0 = cos(0 w t0) r0 + cos(1 w t0) r1 + ...
for i=1:N
    s(i,:) = f(t(i)*n);
end

% This removes situations where a bunch of zeros needs to create a zero such as sin(0*0) + sin(1*0) + ... = 0
removeRow = find(all(s==0,2));
removeCol = find(all(s==0,1));
if numel(removeRow) ~= 0
    % This method bypasses the matrix being singular
    r = (pinv(s) * y)';
else
    % The case when the values can be more easily solved
    r = (s \ y )';
end

y_new = zeros(N,1);
for i=1:N
    y_new(i) = sum(r .* f(t(i) * n));
end

% Verifies that the coeficiants with the repective functions create the origional function
if sum(abs(y-y_new) > max(abs(y)) * eps(2^10))
    error('New Y difference is too large!');
end

end
