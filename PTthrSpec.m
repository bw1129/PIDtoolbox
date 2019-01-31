function [SpecMat] = PTthrSpec(X, Y, F)
% [SpecMat] = PTthrSpec(X, Y, F) 
%   computes fft as function of throttle and generates throttle x freq
%   matrix. X is throttle data in percent, Y is flight data (gyro, PIDerror, etc), 
%   F is sample frequency in Hz of the input flight data. The function returns 
%   a throttle x freq matrix/spectrogram [SpecMat] of input data X and Y.  

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------


X=X';
Y=Y';

Tr=100;% throttle range
multiplier=.2;
wnd=6; % moving window size 
segment_length=F*multiplier;  
amp_smoothfactor=(F/1000); 
thr_smoothfactor=8; 
         
segment_vector=1:segment_length:length(Y);
for i=1:length(segment_vector)-1   
    Tm(i)=nanmean(X(segment_vector(i):segment_vector(i+1)));    
end
ampTemp=zeros(Tr,(segment_length/2)+1);
freqTemp=zeros(Tr,(segment_length/2)+1);
for i=1:Tr
    clear tmp
    if ~isempty(find(Tm>i-wnd & Tm<=i+wnd))
        ind=find(Tm>i-wnd & Tm<=i+wnd);
        for j=1:length(ind)
            try
            Ytmp=Y(segment_vector(ind(j)):segment_vector(ind(j)+1));
            Ytmp2 = Ytmp.*hann(length(Ytmp));
            YA=fft(Ytmp2);
            LA=length(YA);
            PA = abs(YA/LA);
            tmp(j,:) = PA(1:(LA/2)+1);
            warning off
            fA = F*(0:(LA/2))/LA;
            catch
            end
        end 
        a=nanmean(tmp,1);
        ampTemp(i,:)=a;
        freqTemp(i,:) = fA;
    end
end
 h = fspecial('average',[thr_smoothfactor amp_smoothfactor]);
 clear tmp
 tmp = filter2(h, ampTemp);
 clear ampTemp
 if (F/1000)>2, 
        ampTemp=tmp(:,1:200);
    else
        ampTemp=tmp;
 end
    
SpecMat = ampTemp;

end

