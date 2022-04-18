function [multiLineCols] = PTlinecmap(nColors)
%% [multiLineCols] = PTlinecmap(nColors)
% input number of color lines, output colormap

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

    cmap=flipud(colormap(jet));
    multiLineCols=(downsample(cmap,ceil(length(cmap)/nColors)));
    for i = find(multiLineCols(:,1) > .5 & multiLineCols(:,2) > .7 & multiLineCols(:,3) < .3)
        multiLineCols(i,:) = multiLineCols(i,:) * .78;
    end
    round(100/nColors)
    multiLineCols = repmat(multiLineCols, round(100/nColors),1);% repeats colormap to be 100 rows long

end

