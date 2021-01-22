function export2tikz(name, varargin)
% export2tikz(name, width, height, resolution)

% defaults
reso = 0; 
wid = 7; 
heig = 4;

if nargin == 2
    wid = varargin{1};
elseif nargin == 3
    wid = varargin{1};
    heig = varargin{2};
elseif nargin == 4
    wid = varargin{1};
    heig = varargin{2};
    reso = varargin{3};
end

if reso>0
cleanfigure('targetResolution',reso);
end

matlab2tikz([name, '.tex'], 'height', [num2str(heig), 'cm'], 'width',[num2str(wid), 'cm'], ...
    'extraaxisoptions',['title style={font=\normalsize},'...
                       'xlabel style={font=\normalsize},'...
                       'ylabel style={font=\normalsize},',...
                       'ticklabel style={font=\normalsize}'], ...
                       'standalone', true);
%             'legend style={font=\normalsize},',...       
                   
end