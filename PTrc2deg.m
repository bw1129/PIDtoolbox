function [angleRate] = PTrc2deg(X,rcRate,rcExpo,superrate)
% [RCdegpersec] = PTrc2deg(X,rcRate,rcExpo,superrate) converts
% raw RCcommand data to RCrate in deg/s, i.e. "set point"
%  with help from: https://github.com/betaflight/betaflight-configurator/blob/master/src/js/RateCurve.js
%   X is a vector containing a single axis of RCcommand data, scaled from -500 to +500
%   rcRate, rcExpo and superrate must range from 0-100.

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------


    expoPower=2;
    rcRateConstant=200;
    anotherStupidConstant=504.0;
    angleRate=[];

    rcRate=rcRate/100;
    rcExpo=rcExpo/100;
    superrate=superrate/100;
    
    rcCommandf = X;
    rcCommandfAbs = abs(rcCommandf)/max(abs(rcCommandf));

    if (rcRate > 2), 
        rcRate = rcRate + (rcRate - 2) * 14.54;, 
    end
    if (rcExpo > 0), 
        rcCommandf =  rcCommandf .* power(rcCommandfAbs, expoPower) * rcExpo + rcCommandf * (1-rcExpo);         
    end
    angleRate = rcRateConstant * rcRate * rcCommandf;
    if (superrate > 0), 
        rcFactor = 1 ./ (1 - rcCommandfAbs * superrate); % this creates the super expo curve needed to convert RCcommand to RCrate
        angleRate = angleRate .* rcFactor;
    end
    angleRate=(angleRate/anotherStupidConstant);
end

