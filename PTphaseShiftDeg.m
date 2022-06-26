% convert filter delay to phase

delay_ms = 4

freq_of_interest_hz = 30

period_of_freq_of_interest_ms = 1000/freq_of_interest_hz;

phase_shift_deg = delay_ms / period_of_freq_of_interest_ms * 360