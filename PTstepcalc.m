function [normalizedStepResp, time] = PTstepcalc(RCdata, ERRdata, decelerationThresh, samp_time, lowerLim, upperLim)
% [normalizedStepResp, time] = PTstepcalc(data,degPerSec)
%
%   work in progress...A few words: Currently, this script is a basic input-output comparison
%   on segments of data where input (RC) "steps" a specified amount over a specified time, 
%   similar to that described here: https://en.wikipedia.org/wiki/PID_controller#Manual_tuning.
%   Deriving a "step response" from typical flight data can be problematic because
%   there are typcally no actual step changes in the set point (RC input), and depend largely
%   on how fast one is able to change stick position in so-called snap manouvers. Also, sharp manouvers 
%   should ideally be followed by a sufficient steady-state period (step then hold). For these reasons, 
%   I use PID error (difference between set point and gyro) to compute these plots, since in 
%   an actual step, the gyro relative to the step is essentially the error. Tentatively, I chose to analyze 
%   only end of manouvers when the set point is brought back close to zero for at least 400ms, because I find this 
%   to be the most reliable post-step steady-state period. Also, we can't see overshoot etc
%   while to copter is in rotation at high rate. It's only at the end of flips/roll where we see 
%   bounce back, so this is where I focused the "step" calculation. 
%   In the future, I may consider the method used in https://github.com/Plasmatree/PID-Analyzer 
%   involving deconvolution.
%   -B. White

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------


stickAcc=PTscale2ref(smooth(diff(abs(RCdata)),100),RCdata);
x=stickAcc<-decelerationThresh;
diffx=diff(x);
xST=find(diffx==1);
sample_time=(samp_time/1000);

% % get rid of close xST times, must be 1000ms apart
a=diff(xST)<round(sample_time*1000);
xST=xST(~a);

dur=400;% ms
num_samples=round(dur/sample_time); % in samples

clear resp_segments_norm resp_segments resp_segments2 RC_segments RCtmp
for i=1:size(xST,1)
    RCtmp=(RCdata(xST(i):xST(i)+num_samples));
    if nanmean(RCtmp(1:100)) < 0 % test polarity of stick
        resp_segments(i,:)=(ERRdata(xST(i):xST(i)+round(num_samples*1.4)));
        RC_segments(i,:)=abs(RCdata(xST(i):xST(i)+round(num_samples*1.4)));
    else
        resp_segments(i,:)=-(ERRdata(xST(i):xST(i)+round(num_samples*1.4)));
        RC_segments(i,:)=abs(RCdata(xST(i):xST(i)+round(num_samples*1.4)));
    end 
    RC_segments(i,:)=RC_segments(i,:)/max(RC_segments(i,:));

    x=find(resp_segments(i,:)==min(resp_segments(i,1:200)),1);  
     k=1;
    while (resp_segments(i,x) >= resp_segments(i,x+k)) & k<100 
        k=k+1;
    end
    x=x+k+round(5/sample_time); %
     
    resp_segments2(i,:)=resp_segments(i,x:x+num_samples);
end
resp_segments2=resp_segments2(resp_segments2(:,1)<-200,:);% kill the weak ones
j=1;
clear normalizedStepResp resp_segments_norm
for i=1:size(resp_segments2,1)
    resp_segments_norm(i,:)=(-(resp_segments2(i,:)/min(resp_segments2(i,1:round(50/sample_time))))) + 1;
    if isempty(find(resp_segments_norm(i,round(75/sample_time):end)<lowerLim)) & isempty(find(resp_segments_norm(i,round(100/sample_time):end)>upperLim)) & isempty(find(resp_segments_norm(i,round(20/sample_time):end)<.2))
        normalizedStepResp(j,:)=resp_segments_norm(i,:);
        j=j+1;
    end
end

time=[0 sample_time:sample_time:length(normalizedStepResp)*sample_time];
time(end)=[];

end

