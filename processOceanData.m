%% *Ocean province dataset retrieval and visualization* 

%% Loading local file (Deprecated)
%% Bror's data file version alpha Dec 2019  
% oceanFile = 'data/gridded_geospatial_montly_clim_360_720.nc';

%% Loading file from web (Deprecated) 
% oceanURlFile = 'https://rsg.pml.ac.uk/shared_files/brj/CBIOMES_ecoregions/ver_0_2/tabulated_geospatial_montly_clim_045_090_ver_0_2.csv';

%% Loading file from Bror's up-to-date GitHub repository (Monthly climatology, four degree resolution) 
oceanURlFile = 'https://rsg.pml.ac.uk/shared_files/brj/CBIOMES_ecoregions/ver_0_2_5/tabulated_geospatial_montly_clim_045_090_ver_0_2_5.csv';

%% Load table from the web into oceanData 
oceanData = webread(oceanURlFile);

%% Remove all rows with missing data
oceanData = oceanData(~any(ismissing(oceanData),2),:);

%% Show all table properties (column names)
oceanData.Properties.VariableNames

%% Show Chlorophyll data per month in a world bubble chart
nMonths = 12;
for i = 1:nMonths
        
    % Find indices corresponding to month
    currMonthInds = find(oceanData.month==i);

    figure(i);
    geobubble(oceanData.lat(currMonthInds),oceanData.lon(currMonthInds),oceanData.Chl(currMonthInds));
    title(['Chlorophyll month ',num2str(i)]);
    drawnow;
    
    
end

%% Show all data per month in a stacked plot
figure;
stackedplot(oceanData);
set(gca,'FontSize',14);


%% Histogram for all features data

% Feature indices
featureInds = 5:19;
nFeatures = length(featureInds);

oceanX = table2array(oceanData(:,featureInds));
featureLabels = oceanData.Properties.VariableNames(featureInds);

for i=1:nFeatures
    currLabel = featureLabels{i};
    currData = oceanX(:,i);
    figure;
    histogram(currData,'Normalization','pdf');
    title(['Unnormalized feature: ',currLabel]);
    grid on;
    drawnow;
end

%% Correlation patterns among features

% Correlation of unnormalized features
corrX = corr(oceanX);

figure;
imagesc(corrX)
set(gca,'XTick',1:nFeatures,'XTickLabels',featureLabels);
xtickangle(90);
set(gca,'YTick',1:nFeatures,'YTickLabels',featureLabels);
set(gca,'FontSize',15);
title('Correlation among unnormalized features');
colorbar

%% Global feature normalization

% z-scoring
oceanZ = zscore(oceanX);

% Plot histograms
for i=1:nFeatures
    currLabel = featureLabels{i};
    currData = oceanZ(:,i);
    figure;
    histogram(currData,'Normalization','pdf');
    title(['Normalized feature: ',currLabel]);
    grid on;
    drawnow;
end

% Correlation of normalized features
corrZ = corr(oceanZ);

figure;
imagesc(corrZ);
set(gca,'XTick',1:15,'XTickLabels',featureLabels);
xtickangle(90);
set(gca,'YTick',1:15,'YTickLabels',featureLabels);
set(gca,'FontSize',15);
title('Correlation among normalized features');
colorbar;

%% Computing distances

D_euclid = pdist(oceanZ,'euclidean');
D_cosine = pdist(oceanZ,'cosine');
D_l1 = pdist(oceanZ,'cityblock');
D_maha = pdist(oceanZ,'mahalanobis');


%% Comparing distances via scatter plots

nDists = length(D_euclid);
randInds = randi(nDists,[1 1e6]);

% Comparing Euclidean vs. Cosine distances 
figure;
plot(D_euclid(randInds),D_cosine(randInds),'.');
set(gca,'FontSize',15);
title('Scatter plot of distances');
xlabel('Euclidean distance');
ylabel('Cosine distance');

% Comparing Euclidean vs. Mahalanobis distances 
figure;
plot(D_euclid(randInds),D_maha(randInds),'.');
set(gca,'FontSize',15);
title('Scatter plot of distances');
xlabel('Euclidean distance');
ylabel('Mahalanobis distance');


%% Hierarchical clustering

%% Ward's method with Euclidean distance
linkZ_euclid = linkage(oceanZ,'ward','euclidean');

figure;
dendrogram(linkZ_euclid);

T_euclid = cluster(linkZ_euclid,'maxclust',7);

%% Visualization of clusters (Euclidean) across months

nMonths = 12;
for i = 1:nMonths
        
    % Find indices corresponding to month
    currMonthInds = find(oceanData.month==i);
    
    nData = length(currMonthInds);
    
    figure(i);
    geobubble(oceanData.lat(currMonthInds),oceanData.lon(currMonthInds),ones(nData,1),categorical(T_euclid(currMonthInds)));
    title(['Month ',num2str(i)]);
end

%% Ward's method with cosine distance
linkZ_cosine = linkage(oceanZ,'ward','cosine');

figure;
dendrogram(linkZ_cosine)

T_cosine = cluster(linkZ_cosine,'maxclust',7);

%% Visualization of clusters (cosine) across months

nMonths = 12;
for i = 1:nMonths
        
    % Find indices corresponding to month
    currMonthInds = find(oceanData.month==i);
    
    nData = length(currMonthInds);
    
    figure(i);
    geobubble(oceanData.lat(currMonthInds),oceanData.lon(currMonthInds),ones(nData,1),categorical(T_cosine(currMonthInds)));
    title(['Month ',num2str(i)]);
    
end

%% Ward's method with Mahalanobis distance
linkZ_maha = linkage(oceanZ,'ward','mahalanobis');

figure;
dendrogram(linkZ_maha)

T_maha = cluster(linkZ_maha,'maxclust',7);

%% Visualization of clusters (Mahalanbis) across months

nMonths = 12;
for i = 1:nMonths
        
    % Find indices corresponding to month
    currMonthInds = find(oceanData.month==i);
    
    nData = length(currMonthInds);
    
    figure(i);
    geobubble(oceanData.lat(currMonthInds),oceanData.lon(currMonthInds),ones(nData,1),categorical(T_maha(currMonthInds)));
    title(['Month ',num2str(i)]);
    
end


%% Re-do cluster analysis without SST

%% Hierarchical clustering with Euclidean distances
linkZwoSST_euclid = linkage(oceanZ(:,2:end),'ward');

figure;
dendrogram(linkZwoSST_euclid)

TwoSST_euclid = cluster(linkZwoSST_euclid,'maxclust',7);

%% Visualization of clusters (Euclidean) across months

nMonths = 12;
for i = 1:nMonths
        
    % Find indices corresponding to month
    currMonthInds = find(oceanData.month==i);
    
    nData = length(currMonthInds);
    
    figure(i);
    geobubble(oceanData.lat(currMonthInds),oceanData.lon(currMonthInds),ones(nData,1),categorical(TwoSST_euclid(currMonthInds)));
    title(['Month ',num2str(i)]);
    
end


%% Hierarchical clustering with Mahalanbis distances

linkZwoSST_maha = linkage(oceanZ(:,2:end),'ward','mahalanobis');

figure;
dendrogram(linkZwoSST_maha)

TwoSST_maha = cluster(linkZwoSST_maha,'maxclust',7);

%% Visualization of clusters (Mahalanbis) across months

nMonths = 12;
for i = 1:nMonths
        
    % Find indices corresponding to month
    currMonthInds = find(oceanData.month==i);
    
    nData = length(currMonthInds);
    
    figure(i);
    geobubble(oceanData.lat(currMonthInds),oceanData.lon(currMonthInds),ones(nData,1),categorical(TwoSST_maha(currMonthInds)));
    title(['Month ',num2str(i)]);
    
end


