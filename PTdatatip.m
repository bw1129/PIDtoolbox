function output_txt = PTdatatip(obj,event_obj)
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).
% this is a minor modification of the Matlab datatip tool to display
% relevant units for this project, deg/s and time with ms precision 
% - B. White

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

pos = get(event_obj,'Position');
if pos(1)<100,
    dgts=5;
else
    dgts=6;
end
output_txt = {['sec: ',num2str(pos(1),dgts)],...
    ['deg/s: ',num2str(pos(2),4)]};

% If there is a Z-coordinate in the position, display it as well
if length(pos) > 2
    output_txt{end+1} = ['Z: ',num2str(pos(3),4)];
end
