function [Tm freq specMat] = PTtimeFreqCalc(Y, F, smoothFactor, subsampleFactor)
%% [Tm, freq, specMat] = PTtimeFreqCalc(Y, F, smoothFactor)
%   computes fft as function of time and generates time x freq matrix,
%   specMat, a time vector, Tm, and freq vector, Fs.
%   Y is flight data (gyro, PIDerror, etc)
%   F is sample frequency in kHz of the input flight data.

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

    multiplier = 0.3; % results in 300ms segments (must be same in datatip for accurate reading)
    segment_length = F * 1000 * multiplier; % 300ms segments
    halfSegment = round(segment_length/2);
    fileDurSec = length(Y) / (F*1000);   
    
    stepsz = round(segment_length/subsampleFactor);
  
    smpls = (1 : stepsz : size(Y,1) - segment_length);
    Tm = smpls / (F*1000);
    
    Yseg=[];
    j = 0;
    for i = smpls
        j = j + 1;
        if i < segment_length
            Yseg(j,:) = Y(i : i+(segment_length)-1); 
        else
            Yseg(j,:) = Y(i-(halfSegment) : i+(halfSegment)-1); 
        end
    end
        
    specMat=[];freq = [];
    for i = 1 : size(Yseg,1)
        [freq specMat(i,:)] = PTSpec2d(Yseg(i,:), F, 1);
        specMat(i,:) = smooth(specMat(i,:), smoothFactor, 'lowess');
    end
    specMat = flipud(specMat');
 
end
            
