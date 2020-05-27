% Ocean province dataset visualization

% Bror's data file version alpha Dec 2019  

oceanFile = 'gridded_geospatial_montly_clim_360_720.nc';

% To get information about the nc file
ncinfo(oceanFile)

% to display nc file
ncdisp(oceanFile)

% to read a vriable 'var' exisiting in nc file
ChloData = ncread(oceanFile,'Chl');

for i = 1:12
    figure(i);
    imagesc(rot90(log(ChloData(:,:,i))))
    title(['Chlorophyll month ',num2str(i)])
end
