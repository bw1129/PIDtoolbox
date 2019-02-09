function [output_txt] = PTdatatip(obj,event_obj)
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).
% this is a minor modification of the Matlab datatip tool to display
% relevant units for this project, deg/s and time with ms precision 
% - B. White
%
% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------
%
%
%

try
    a=event_obj.Target.Type;  
catch
end

if ~strcmp(a,'image') % ugly workaround
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
    else
        pos = get(event_obj,'Position');  
        output_txt = {['X: ',num2str(pos(1),4)],...
            ['Y: ',num2str(pos(2),4)]};

        % If there is a Z-coordinate in the position, display it as well
        if length(pos) > 2
           output_txt{end+1} = ['Z: ',num2str(pos(3),4)];
        end
        if strcmp(a,'image')    
            obj.Parent.YLim(2)*.001
            y=(obj.Parent.YLim(2)-pos(2)) / (.2);
            output_txt = {['%T: ',num2str(pos(1),4)],...
            ['Hz: ',num2str(y,4)]};
 
            z=event_obj.Target.CData(pos(2),pos(1));
            output_txt{end+1} = ['Z: ',num2str(z,4)];   
        end
end
 
