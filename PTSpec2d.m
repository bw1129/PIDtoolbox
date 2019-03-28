function [freq amp2d] = PTSpec2d(Y, F)
%% [freq amp2d] = PTSpec2d(Y, F) 
%   computes standard fft on input data Y. F is sample frequency in Hz.  

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

Y2 = fft(Y);
L=length(Y);
P2 = abs(Y2/L); % 'normalize' amplitude spectrum by length of signal
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
freq = (F*1000)*(0:(L/2))/L;
amp2d=P1;

end
