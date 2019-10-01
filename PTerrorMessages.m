function [errorMessage] = PTerrorMessages(message_string, err)
%% Displays Matlab error messages in a popup so users can report specific errors for development and debugging purposes
% - B. White
%
% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------
%

errorMessage = sprintf(['Error in ' message_string ' \n\n Message:\n%s'], err.message);
% Display pop up message and wait for user to click OK
% Print to command window.
fprintf(1, '%s\n', errorMessage);
uiwait(warndlg(errorMessage)); 
%close % in a previous version, the program would close following an error, but this was problematic
end

