%% PTplotBreakout - script to save main Figs without UI control panel in new window

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

%%
%% create saveDirectory
if ~isempty(filenameA) && ~isempty(filenameB)
    saveDirectory=[filenameA(1:end-4) '-' filenameB(1:end-4)];
end
if ~isempty(filenameA) && isempty(filenameB)
    saveDirectory=[filenameA(1:end-4)];
end
if ~isempty(filenameB) && isempty(filenameA)
    saveDirectory=[filenameB(1:end-4)];
end
if ~exist(saveDirectory,'dir')
    if ~isempty(strfind(saveDirectory,'.bbl')) 
        s=strfind(saveDirectory,'.bbl');
        for i=length(s):-1:1
            saveDirectory(s(i):s(i)+3)=[];
        end       
    end
     if ~isempty(strfind(saveDirectory,'.bfl')) 
        s=strfind(saveDirectory,'.bfl');
        for i=length(s):-1:1
            saveDirectory(s(i):s(i)+3)=[];
        end       
     end
    if ~isempty(strfind(saveDirectory,'.BBL'))  
        s=strfind(saveDirectory,'.BBL');
        for i=length(s):-1:1
            saveDirectory(s(i):s(i)+3)=[];
        end       
    end
     if ~isempty(strfind(saveDirectory,'.BFL'))
        s=strfind(saveDirectory,'.BFL');
        for i=length(s):-1:1
            saveDirectory(s(i):s(i)+3)=[];
        end       
    end
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


