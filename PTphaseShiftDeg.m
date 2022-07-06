function [phase_shift_deg] = PTphaseShiftDeg(delay_ms, freq_of_interest_hz)
% convert filter delay to phase shift in deg
% [phase_shift_deg] = PTphaseShiftDeg(delay_ms, freq_of_interest_hz), self
% explanatory

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

period_of_freq_of_interest_ms = 1000/freq_of_interest_hz;

phase_shift_deg = delay_ms / period_of_freq_of_interest_ms * 360;