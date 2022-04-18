function [angleRate] = PTrc2deg(X,rcRate,rcExpo,superrate, C)
% raw RCcommand data to RCrate in deg/s, i.e. "set point"
%  with help from: https://github.com/betaflight/betaflight-configurator/blob/master/src/js/RateCurve.js
%   X is a vector containing a single axis of RCcommand data scaled from -500 to 500, 
%   rcRate(0-255),rcExpo(0-100),superrate(0-100)
    
    expoPower=3;
    rcRateConstant=C; 
    angleRate=[];

    rcRate=rcRate/100;
    rcExpo=(rcExpo/100);
    superrate=superrate/100;
    
    maxRC=500;
    rcCommandf = X / maxRC;% scales from -1 to 1 for the math
    rcCommandfAbs = abs(rcCommandf) / 1;%max(abs(rcCommandf)); 

    if (rcRate > 2) 
        rcRate = rcRate + (rcRate - 2) * 14.54; 
    end
    if (rcExpo > 0)
       %disp('rcExpo > 0')
        rcCommandf =  rcCommandf .* power(rcCommandfAbs, expoPower) * rcExpo + rcCommandf * (1-rcExpo);         
    end 
    if (superrate > 0) 
        %disp('superrate > 0')
        rcFactor = 1 ./ (1 - rcCommandfAbs * superrate); % this creates the super expo curve needed to convert RCcommand to RCrate  
        angleRate = (rcRateConstant * rcRate * rcCommandf);  
        angleRate = angleRate .* rcFactor;
       % disp(['angleRate:' num2str(angleRate) ' rcFactor:' num2str(rcFactor)])
    else
        angleRate = (rcRateConstant * rcRate * rcCommandf);
    end
    
end
