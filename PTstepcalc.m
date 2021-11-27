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
      
segment_vector = 1 : round(segment_length/subsampleFactor) : length(SP);
NSegs = max(find((segment_vector+segment_length) < segment_vector(end)));
if NSegs > 0
    SPseg = []; GYseg = [];
    j = 0;
    for i = 1 : NSegs
        if max(abs(SP(segment_vector(i):segment_vector(i)+segment_length))) >= minInput 
            j=j+1;
            SPseg(j,:) = SP(segment_vector(i):segment_vector(i)+segment_length);  
            GYseg(j,:) = GY(segment_vector(i):segment_vector(i)+segment_length); 
        end
    end

    padLength = 100;% 2^nextpow2(length(SPseg(i,:)));
    clear resp resp2 G H Hcon imp impf a b
    j=0; 
    if ~isempty(SPseg)
        for i = 1 : size(SPseg,1)
            a = GYseg(i,:).*hann(length(GYseg(i,:)))'; 
            b = SPseg(i,:).*hann(length(SPseg(i,:)))'; 
            a = fft([zeros(1,padLength) a zeros(1,padLength)]); 
            b = fft([zeros(1,padLength) b zeros(1,padLength)]); 
            G = a / length(a);
            H = b / length(b); 
            Hcon = conj(H);  

            imp = real(ifft((G .* Hcon) ./ (H .* Hcon + 0.0001 )))'; %  impulse response function
            resptmp(i,:) = cumsum(imp);% integrate impulse resp function 
            
            clear a steadyStateWindow steadyStateResp yoffset
            steadyStateWindow = find(t > 200 & t < StepRespDuration_ms); 
            steadyStateResp = resptmp(i, steadyStateWindow); 
            if Ycorrection
                if nanmean(steadyStateResp) < 1 || nanmean(steadyStateResp) > 1
                    yoffset = 1 - nanmean(steadyStateResp);
                    resptmp(i,:) = resptmp(i,:) * (yoffset+1);
                end  
                steadyStateResp = resptmp(i, steadyStateWindow); 
            else
            end
            
            if min(steadyStateResp) > 0.5 && max(steadyStateResp) < 3 % Quality control     
                j=j+1;
                stepresponse(j,:)=resptmp(i,1:1+wnd);
                 
            end     
        end 
    else
    end
else
end



