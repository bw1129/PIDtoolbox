function [throttlePercent] = PTthrExpo(X,thrMid,thrExpo)
%% [throttlePercent] = PTthrExpo(X,thrMid,thrExpo) converts
% PTthrExpo(X,thrMid,thrExpo), converts raw throttle [RCcommand] to percent throttle
%   X is a vector containing a single axis of RCcommand data, scaled from -500 to +500
%   thrMid, thrExpo must range from 0-100.

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

    expoPower=2;

    thrMid=thrMid/100;
    thrExpo=thrExpo/100;
    
    rcCommandf = (X-1500) / 1000;%
    rcCommandf(rcCommandf<-.5)=-.5;
    rcCommandf(rcCommandf>.5)=.5;
    rcCommandf=rcCommandf+(.5-thrMid);

    rcCommandfAbs = abs(rcCommandf)/max(abs(rcCommandf));

    if (thrExpo > 0), 
        rcCommandf =  rcCommandf .* power(rcCommandfAbs, expoPower) * thrExpo + (rcCommandf * (1-thrExpo));         
    end
    throttlePercent = (rcCommandf-min(rcCommandf));
end

