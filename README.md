<img src="https://i.imgur.com/39RTmsl.png" alt="cbiomes" height="120" align="right"/>

## Data-driven Ocean Province Inference

This GitHub repository is part of a collaborative project that aims to create data-driven partitions 
of the ocean from globally observed data. 

All data are available on the main GitHub repository [https://github.com/brorfred/ocean_clustering](https://github.com/brorfred/ocean_clustering).

The dataset consists of 15 monthly climatologies resampled to the same 1/2° grid, both gridded in netcdf format and 
tabulated as hdf5 and csv files. The tabulated data are also provided subsampled by including every 2nd, 4th or 8th datapoint. These files are much smaller to download and work with.

The effort is part of the Simons Collaboration on Computational Biogeochemical Modeling of Marine Ecosystems 
[Simons CBIOMES](https://www.cbiomes.org), which seeks to develop and apply quantitative models of the structure 
and function of marine microbial communities at seasonal and basin scales.

## List of 15 measurements included in the files

- Chlorophyll (Chl), PAR, Kd490, Euphotic Depth
- remotely sensed reflectances (Rrs412, Rrs443, Rrs490, Rrs510, Rrs555, Rrs670)
- Sea Surface Temperature (SST), Mixed Layer Depth (MLD)
- Wind Speed (wind), Eddy Kinetik Energy (EKE), Bathymetry

## Basic example
Below is an example in MATLAB how to download the data and using Ward's method with cosine similarity 

```Matlab
oceanURlFile = 'https://rsg.pml.ac.uk/shared_files/brj/CBIOMES_ecoregions/ver_0_2/tabulated_geospatial_montly_clim_045_090_ver_0_2.csv';

% Load table from the main GitHub into oceanData 
oceanData = webread(oceanURlFile);

% Feature indices (first four indices are index, month, lat, lon)
featureInds = 5:19;
nFeatures = length(featureInds);

% Extract all features from the data file
oceanX = table2array(oceanData(:,featureInds));

% z-scoring
oceanZ = zscore(oceanX);

% Hierarchical clustering 
linkZ_cosine = linkage(oceanZ,'ward','cosine');

% Group into the top-7 global yearly clusters
T_cosine = cluster(linkZ_cosine,'maxclust',7);
```
The image represents the clustering of the ocean into seven regions for the month of September.

<p align="center">
  <img width="560" height="420" src="https://github.com/muellsen/OceanProvinces/blob/master/html/processOceanData_70.png">
</p>

## MATLAB notebook 

An MATLAB notebook using hierarchical clustering with several distance measures is available [here](http://htmlpreview.github.io/?https://github.com/muellsen/OceanProvinces/blob/master/html/processOceanData.html).
