function [scaledOutput] = PTscale2ref(inputSig,inputRef)
%[scaledSig] = PTscale2ref(sig,ref)
%   Normalizes an input signal [inputSig] relative to a reference signal [inputRef]  

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

c=1;% constant, scaling factor, though probably unnecessary ;-)

mRef = mean(abs(inputRef)); stdRef = std(abs(inputRef));
mSig = mean(abs(inputSig)); stdSig = std(abs(inputSig));
scaledOutput = (((inputSig - mSig)/stdSig) * stdRef + mRef) * c;
end

