function [output_txt] = PTdatatip(obj,event_obj)
%% Display the position of the data cursor
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

global logviewerYscale

fontsz2=16;
try
    a=event_obj.Target.Type;  
    c=event_obj.Target.Color;
catch
end
c1=[0.9300    0.5000    0.3000];
c2=[0.3000    0.6500    0.9500]; 
if ~strcmp(a,'image') % ugly workaround       
        pos = get(event_obj,'Position');
        if pos(1)<100,
            dgts=5;
        else
            dgts=6;
        end   
        if pos(2) > -logviewerYscale
        output_txt = {['x: ',num2str(pos(1),dgts)],...
            ['y: ',num2str(pos(2),4)]};
        else
            output_txt = {['sec: ',num2str(pos(1),dgts)],...
            ['%: ',num2str(((pos(2)+(logviewerYscale*2)) / (logviewerYscale/100)),4)]};
        end
            
  
%         dataTipH=plot([pos(1) pos(1)], [-2400 2400],'r-');
%         get(dataTipH)
        if c==c1 | c==c2
            output_txt = {['x: ',num2str(pos(1),4)],...
            ['y: ',num2str(pos(2),4)]};
        end
        % If there is a Z-coordinate in the position, display it as well
        if length(pos) > 2
            output_txt{end+1} = ['Z: ',num2str(pos(3),4)];
        end
        set(findall(gcf,'type','hggroup'),'FontSize',fontsz2,'FontWeight', 'bold')
    else
        pos = get(event_obj,'Position');  
        output_txt = {['X: ',num2str(pos(1),4)],...
            ['Y: ',num2str(pos(2),4)]};

        % If there is a Z-coordinate in the position, display it as well
        if length(pos) > 2
           output_txt{end+1} = ['Z: ',num2str(pos(3),4)];
        end
        if strcmp(a,'image') 
%             pos = get(event_obj,'Position');
%             output_txt = {['X: ',num2str(pos(1),4)],...
%             ['Y: ',num2str(pos(2),4)]};
        
            y=(obj.Parent.YLim(2)-pos(2)) / (.3);
            output_txt = {['%T: ',num2str(pos(1),4)],...
            ['Hz: ',num2str(y,4)]};
 
            z=event_obj.Target.CData(pos(2),pos(1));
            output_txt{end+1} = ['Z: ',num2str(z,4)];   
        end     
        set(findall(gcf,'type','hggroup'),'FontSize',fontsz2,'FontWeight', 'bold')
end
 
