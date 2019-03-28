function data = PTstr2num(str, numCols)
%% data = PTstr2num(str, numCols)
% data = PTstr2num(str, numCols)
% modified from:
% https://www.mathworks.com/company/newsletters/articles/tips-for-accelerating-matlab-performance.html

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

% faster alternative to str2num
    str = char(str);
    str(:,end+1) = ' ';
    data = sscanf(str','%f');
    if nargin>1 && ~isempty(numCols)
        data = reshape(data,numCols,[])';
    end
end

