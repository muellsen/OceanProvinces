%% Test script to produce smooth ocean data for every month
% Extremely slow - only intended for experimenting with landmasks

%% Loading file from Bror's GitHub repository (Monthly climatology, four degree resolution) 
%% Note this file is slightly deprecated 
oceanURlFile = 'https://rsg.pml.ac.uk/shared_files/brj/CBIOMES_ecoregions/ver_0_2/tabulated_geospatial_montly_clim_045_090_ver_0_2.csv';

%% Load table from the web into oceanData 
oceanData = webread(oceanURlFile);

%% Show Chlorophyll data per month in a smooothed ocean map
nMonths = 1;

for i = 1:nMonths
        
    % Find indices corresponding to month
    currMonthInds = find(oceanData.month==i);

    lat = oceanData.lat(currMonthInds);
    lon = oceanData.lon(currMonthInds);
    Chl = oceanData.Chl(currMonthInds); % : not ;
    lon0 = min(lon) ; lon1 = max(lon) ;
    lat0 = min(lat) ; lat1 = max(lat) ; 
    
    N = length(lat-1) ;
    x = linspace(lon0,lon1,N) ;
    y = linspace(lat0,lat1,N) ; % lat0, not lon1
    
    [X,Y] = meshgrid(y,x) ;
    F = scatteredInterpolant(lon,lat,Chl) ;
    Z = F(X,Y);

    worldmap('World') 
    h=pcolorm(X,Y,Z); 

    delete(h)
    landInds = landmask(X,Y,85); 
    Z(landInds) = NaN; 
    
    h=pcolorm(X,Y,Z); 
    
    load coastlines    
    plotm(coastlat,coastlon)
    geoshow(X,Y,-Z,'DisplayType', 'texturemap') %
    title(['Chlorophyll month ',num2str(i)]);
    drawnow;
    
end
