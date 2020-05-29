<img src="https://i.imgur.com/Ei8KgYG.png" alt="TREX" height="150" align="right"/>

## Data-driven Ocean Provinces

This GitHub repository is part of a project that aims to create data-driven partitions of the ocean from globally observed
data. 

All data are available on [https://github.com/brorfred/ocean_clustering](https://github.com/brorfred/ocean_clustering)

The dataset consists of monthly climatologies resampled to the same 1/2° grid, both gridded in netcdf format and tabulated as hdf5 and csv files. The tabulated data are also provided subsampled by including every 2nd, 4th or 8th datapoint. These files are much smaller to download and work with.

The effort is part of the Simons Collaboration on Computational Biogeochemical Modeling of Marine Ecosystems [Simons CBIOMES](https://www.cbiomes.org), which seeks to develop and apply quantitative models of the structure and function of marine microbial communities at seasonal and basin scales.

Below is an example when using Ward's method with cosine similarity 

```Matlab
linkZ_cosine = linkage(oceanZ,'ward','cosine');

figure;
dendrogram(linkZ_cosine)

T_cosine = cluster(linkZ_cosine,'maxclust',7);
```
The image represents the clusteing of the ocean into seven regions for the month of September.

<p align="center">
  <img width="560" height="420" src="https://github.com/muellsen/OceanProvinces/blob/master/html/processOceanData_70.png">
</p>

An initial MATLAB notebook using hierarchical clustering is available [here:](http://htmlpreview.github.io/?https://github.com/muellsen/OceanProvinces/blob/master/html/processOceanData.html)
