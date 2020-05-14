function [stepresponse, t, rateHigh] = PTstepcalc(SP, GY, lograte, subsamp, minInput, rateHighThreshold)
%% [stepresponse, t, rateHigh] = PTstepcalc(SP, GY, lograte, subsamp, minInput))
% estimate of step response function using Wiener filter/deconvolution method
% SP = set point (input), GY = filtered gyro (output)
% returns matrix/stack of etimated stepresponse functions, time [t] in ms, and  
% rateHigh, where 1 means set point >=500 deg/s, and 0 < 500deg/s
%
%
% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------


segment_length=(lograte*2000); % 2 sec segments
wnd=(lograte*1000) * 0.5; % 500ms step response function, length will depend on lograte  
StepRespDuration_ms=500; % max dur of step resp in ms for plotting
subsampleFactor=subsamp;

stepresponse=[];

segment_vector=1:round(segment_length/subsampleFactor):length(SP);
NSegs=max(find((segment_vector+segment_length) < segment_vector(end)));

length(segment_vector)

if NSegs>0
    hw = waitbar(0,['generating stack of input-output segments... ']); 
    clear SPseg GYseg
    j=0;
    for i=1:NSegs
        waitbar(i/length(segment_vector),hw,['generating stack of input-output segments... ']);
        if max(abs(SP(segment_vector(i):segment_vector(i)+segment_length))) >= minInput 
            j=j+1;
            SPseg(j,:)=SP(segment_vector(i):segment_vector(i)+segment_length);  
            GYseg(j,:)=GY(segment_vector(i):segment_vector(i)+segment_length); 
        else
        end 
    end
 
    clear resp resp2 G H Hcon imp impf a b
    j=0; rateHigh=0;
    for i=1:size(SPseg,1)
        waitbar(i/size(SPseg,1),hw,['computing step response functions... ']); 
        a=fft(GYseg(i,:).*hamming(length(GYseg(i,:)))',segment_length*2);% output, use hann or hamming taper
        b=fft(SPseg(i,:).*hamming(length(SPseg(i,:)))',segment_length*2);% input, use hann or hamming taper
        G=a/length(a);
        H=b/length(b);
        Hcon=conj(H);     
        imp=real(ifft((G .* Hcon) ./ (H .* Hcon + .0001)))'; % impulse response function, .0001 to avoid divide by 0
        resptmp(i,:) = (cumsum(imp));%.^.5;% integrate impulse resp functions
        a=stepinfo(resptmp(i,1:wnd)); % gather info about quality of step resp function
        if a.SettlingMin>.5 && a.SettlingMin<=1 && a.SettlingMax>1 && a.SettlingMax<1.5 %Quality control
            j=j+1;
            stepresponse(j,:)=real(resptmp(i,1:1+wnd)); 
            
            if max(abs(SPseg(i,:))) >= rateHighThreshold
                rateHigh(j,:)=1;
            else
                rateHigh(j,:)=0;
            end
        end      
        t = 0:1/lograte:StepRespDuration_ms;% time in ms        
    end        
end
close(hw)

end

