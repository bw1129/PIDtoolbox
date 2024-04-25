function [stepresponse, t] = PTstepcalc(SP, GY, lograte, Ycorrection, smoothFactor)
%% [stepresponse, t] = PTstepcalc(SP, GY, lograte, Ycorrection)
% this function deconvolves the step response function using
% SP = set point (input), GY = filtered gyro (output)
% returns matrix/stack of etimated stepresponse functions, time [t] in ms
%
%
% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------
smoothVals = [1 20 40 60];
GY = smooth(GY, smoothVals(smoothFactor),'lowess');

minInput = 20;
segment_length = (lograte*2000); % 2 sec segments
wnd = (lograte*1000) * .5; % 500ms step response function, length will depend on lograte  
StepRespDuration_ms = 500; % max dur of step resp in ms for plotting
t = 0 : 1/lograte : StepRespDuration_ms;% time in ms 

fileDurSec = length(SP) / (lograte*1000);
subsampleFactor = 1;
switch subsampleFactor
    case fileDurSec <= 20
        subsampleFactor = 10;
    case fileDurSec > 20 & fileDurSec <= 60
        subsampleFactor = 7;
    case fileDurSec > 60
        subsampleFactor = 3;
end
      




