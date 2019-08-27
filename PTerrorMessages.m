function [errorMessage] = PTerrorMessages(message_string, err)
%%  
errorMessage = sprintf(['Error in ' message_string ' \n\n Message:\n%s'], err.message);
% Display pop up message and wait for user to click OK
uiwait(warndlg(errorMessage)); 
close
end

