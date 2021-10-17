%% PTplotBreakout - script to save main Figs without UI control panel in new window

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

%% simplified figure saving
if ~isempty(fnameMaster) 
    
    [filename, saveDirectory] = uiputfile('*.png')

    set(gcf, 'pointer', 'watch')

    figname=[saveDirectory filename];
    try
        saveas(gcf, figname );
    catch
    end

    set(gcf, 'pointer', 'arrow')

else
     warndlg('Please select file(s)');
end
