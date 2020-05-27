%% Test script to produce smooth ocean data for every month


%% Show Chlorophyll data per month in a world bubble chart
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
    geoshow(X,Y,Z,'DisplayType', 'texturemap') %
    title(['Chlorophyll month ',num2str(i)]);
    drawnow;
    
end
