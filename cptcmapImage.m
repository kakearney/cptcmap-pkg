% Create example image


hh.fig = figure('color', 'w');

% Display all the included colormaps

hh.pan1 = uipanel('Title', 'Example color palette tables', ...
                 'position', [.02 .5 .96 .48], ...
                 'backgroundcolor', 'w', ...
                 'fontsize', 8);
 

cptcmap('showall');
copyobj(gca, hh.pan1);
close(gcf);

% An example map

hh.pan2 = uipanel('Title', 'Bathymetry with GMT_globe', ...
                 'position', [.02 .02 .96 .46], ...
                 'backgroundcolor', 'w', ...
                 'fontsize', 8);
hh.ax = axes('parent', hh.pan2);
[lat, lon, z] = satbath(10);
pcolor(lon, lat, z);
shading flat;
cptcmap('GMT_globe', 'mapping', 'direct');
cb = colorbar;
cbtk = get(cb, 'ytick');
set(cb, 'yticklabel', num2str(cbtk', '%g'));

% set(hh.fig, 'renderer', 'zbuffer')
setpos(hh.fig, '# # 800px 600px')

export_fig cptcmapImage -png -nocrop;

%% Example with multiple colormaps

[lat, lon, z] = satbath(10);

cptfile = {'GMT_globe', 'GMT_sealand'};

for ii = 1:2
    ax(ii) = subplot(1,2,ii);
    pcolor(lon, lat, z);
    shading flat;
    cptcmap(cptfile{ii}, ax(ii), 'mapping', 'direct');
    colorbar; 
end

 