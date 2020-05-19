function [GyroFilt] = pt1(GyroUnfilt, cutoffHz, sfreqHz)

filtCut=((2*pi)*cutoffHz)/sfreqHz;
GyroFilt=0;%place 0 in first filtered sample
for i=2:length(GyroUnfilt)
    GyroFilt(i)=GyroFilt(i-1) + (filtCut * (GyroUnfilt(i) - GyroFilt(i-1)));
end

 