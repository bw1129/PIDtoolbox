%% PTplotBreakout - script to save main Figs without UI control panel in new window

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

%% create saveDirectory
if ~isempty(fnameMaster) 
    saveDirectory='PTB_FIGS';
    saveDirectory = [saveDirectory '_' fnameMaster{1}(1:end-4) 'xx_' currentDate];

if ~isfolder(saveDirectory)
   mkdir(saveDirectory)
end

%%
set(gcf, 'pointer', 'watch')
cd(filepath)
cd(saveDirectory)
FigDoesNotExist=1;
n=0;
while FigDoesNotExist,
    n=n+1;
    FigDoesNotExist=isfile([saveDirectory '-' int2str(n) '.png']);
end
figname=[saveDirectory '-' int2str(n)];
saveas(gcf, [figname '.png'] );
print(figname,'-dpng','-r200')

set(gcf, 'pointer', 'arrow')
cd(filepath)

else
     warndlg('Please select file(s)');
end
