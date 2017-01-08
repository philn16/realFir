% Gets the UPR for a fir filter so that it has the disired frequency response values at each y for a
% given frequency of t.
% t is expected to be less or equal to 0.5
% For t=0, there can not be any imaginary y component
% The resuting frequency response does not match the desired response directly. Rather, the phase response is 
% off by some linear constant; exp(1j*M*(2*pi*t)). H_desired = H_actual .* exp(1j*M*(2*pi*t)). In
% this case, M = (filterOrder-1)/2
function [h , M , t] = get_h(y , t)

if ~exist('t','var') || numel(t) == 0
t = linspace(0,1-1/numel(y),numel(y)) / 2;
end

% H(z) = h(-M) z^M + h(-M+1) z^(M-1) + ... h(0) + ... h(M-1) z^(-M+1) + h(-M)
M = numel(y)-1;

% These are used to get the final values for h
% hc(0) and hs(0) are special. hs(0) should always be 0, and hc(0) is used differently
% real(H(e^(j*2*pi*w)) = hc(0) * cos(0) + hc(1) * cos(1) + hc(2) * cos(2) + ...
% imag(H(e^(j*2*pi*w)) = hs(0) * sin(0) + hs(1) * sin(1) + hs(2) * sin(2) + ...
% hc and hs should be of size M+1
f = @(x) cos(2*pi*x);
[hc , ~] = f_series(  real(y) , f , t);
f = @(x) sin(2*pi*x);
[hs , ~] = f_series(  imag(y) , f , t);

range=2:M+1;
h = [1/2*(hc(flip(range))+hs(flip(range))) , hc(1) , 1/2*(hc(range)-hs(range)) ];

H = freqz(h,1,2*pi*t);
% Adds a linear phase to verify that the phase - magniude response is the same.
% Bear in mind it's not the actual frequency response
H_phased = H .* exp(1j*M*(2*pi*t));

% Verifyies correctness - the new response should be identical to the old response at the given values
if max(abs(imag(y-H_phased))) > 2^5*eps(max(abs(y)))
    error('Imaginary components are too far off');
end
if max(abs(real(y-H_phased))) > 2^5*eps(max(abs(y)))
    error('Real components are too far off');
end

end