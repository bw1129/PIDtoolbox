%% PTsaveFig

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

%% simplified figure saving
if ~isempty(fnameMaster) 
    figname=[];
    [filename, saveDirectory] = uiputfile('untitled.png')
     figname=[saveDirectory filename];
     saveas(gcf, filename );
else
     warndlg('Please select file(s)');
end