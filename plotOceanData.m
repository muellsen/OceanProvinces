% Ocean province dataset visualization example

% Bror's data file version alpha Dec 2019  

oceanFile = 'data/gridded_geospatial_montly_clim_360_720.nc';

% To get information about the nc file
ncinfo(oceanFile)

% To display nc file
ncdisp(oceanFile)

% To read a variable 'var' exisiting in nc file, e.g., Chlorophyll
ChloData = ncread(oceanFile,'Chl');

% Plot monthly global chlorophyll concentration as an image

nMonths = 12;

for i = 1:nMonths
    figure(i);
    imagesc(rot90(log(ChloData(:,:,i))))
    title(['Chlorophyll (monthly average) in month ',num2str(i)])
    xlabel('longitude','FontSize',14)
    ylabel('latitude','FontSize',14)
    c = colorbar;
    c.Label.String = 'Chlorophyll conceentration (log)';
    drawnow
end
