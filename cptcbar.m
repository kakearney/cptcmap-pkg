function h = cptcbar(ax, map, loc, flag, varargin)
% Create colorbar associated with cpt colormap
%
% Due to uneven spacing, regular colorbars are sometimes inappropriate for
% colormaps applied via cptcmap.  This function offers an alternative.
%
% h = cptcbar(ax, map, loc, flag)
%
% Input variables:
%
%   ax:     peer axis for colormap.  Used for positioning only.
% 
%   map:    name of colormap used  
%
%   loc:    location of colormap (see colormap.m)
%
%   flag:   if true, evenly space the colors.  If false, space according to
%           values of each color block
%
% Optional input arguments (passed as parameter/value pairs)
%
%   tkint:  Label every x intervals [1]

% Copyright 2014 Kelly Kearney

Opt.tkint = 1;
Opt = parsepv(Opt, varargin);


[cmap, lims, ticks, bfncol, ctable] = cptcmap(map);

cb = colorbar('peer', ax, 'location', loc);
loc = get(cb, 'Location'); % Easier than lower/upper

pos = get(cb, 'position');
% axpos = get(ax, 'position');
% delete(cb);

% h.ax = axes('position', pos, 'box', 'on');

if flag
    tmp = linspace(0, 1, size(ctable,1)+1)';
    y1 = tmp(1:end-1);
    y2 = tmp(2:end);
    tk = [y1; y2(end)];
else
    y1 = ctable(:,1);
    y2 = ctable(:,5);
    tk = [ctable(:,1); ctable(end,5)];
end
tklbl = strtrim(cellstr(num2str([ctable(:,1); ctable(end,5)])));

islbl = ismember(1:length(tk), 1:Opt.tkint:length(tk));
[tklbl{~islbl}] = deal(' ');


ypatch = [y1 y2 y2 y1 y1]';
xpatch = repmat([0 0 1 1 0], size(ypatch,2), 1)';

cpatch = cat(3, ctable(:,2:4), ctable(:,6:8), ctable(:,6:8), ctable(:,2:4), ctable(:,2:4));
cpatch = permute(cpatch, [3 1 2]);

% delete(cb);
h.ax = axes('position', pos, 'box', 'on');

switch lower(loc)
    case {'east', 'west', 'eastoutside', 'westoutside'}
        h.p = patch(xpatch, ypatch, cpatch);
        set(h.ax, 'ytick', tk, 'yticklabel', tklbl, 'ylim', minmax(tk), ...
            'xlim', [0 1], 'xtick', []);
        
    otherwise
        h.p = patch(ypatch, xpatch, cpatch);   
        set(h.ax, 'xtick', tk, 'xticklabel', tklbl, 'xlim', minmax(tk), ...
            'ylim', [0 1], 'ytick', []);
end

switch lower(loc)
    case {'eastoutside', 'west'}
        set(h.ax, 'yaxislocation', 'right');
    case {'south', 'northoutside'}
        set(h.ax, 'xaxislocation', 'top');
end

set(h.ax, 'layer', 'top');

set(h.p, 'edgecolor', 'none');
set(cb, 'visible', 'off');



