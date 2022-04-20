Title: "Individual dietary specialization in a generalist bee varies across populations but has no effect on the richness of associated microbial communities"
Authors: Marilia P. Gaiarsa, Sandra Rehan, Matthew Barbour, Quinn McFrederick
Journal: The American Naturalist 

Marilia P. Gaiarsa is responsible for collecting data and writing code.


# Overview 
We examine the occurrence of individual specialization in a solitary bee species, *Ceratina australensis* in three different wild populations from Australia. We use data previously published by @mcfrederick2019wild on metabarcoding of the pollen contents of *Ceratina* nests to characterize the plant, bacteria, and fungi present in each individual nest. We show that bee individuals have marked dietary specialization and that the level of specialization varies across populations. In the most specialized population, we also show that individuals' diet breadth was positively related to the richness of fungi, but not bacteria. Overall, individual specialization appeared to have a weak or negligible effect on the microbial richness of nests, suggesting that different mechanisms beyond environmental transmission may be at play regarding microbial acquisition in wild bees.

This repo cointains an R Markdown document (pdf and rmd) describing the data and analyses, as well as excel file with the raw data (previously published by McFrederick & Rehan (2019), a csv file with the metadata, and RScript with the analyses to statistical results and figures. In the excel file `rawData.xlsx` spreadsheets, across al spreadsheets each line represents a genus/ASV and the columns have information related to the metabarcoding (sequence ID, best taxonomic match, etc), as well as the number of reads found in each brood cell of each individual nest. There are four spreadsheets in total: `plant` (with the genus-level plant data), `plant_asv` (with the ASV plant data---see Online Supplement for details), `bact` (with the ASV bacteria data), and `fungi` (with the ASV fungi data). 

These files are also available on Dryad () and Zenodo (doi: 10.5281/zenodo.6327241), and previously published sequence data are publicly available under NCBI/EMBL/DDBJ accession numbers SAMN08911168- SAMN08911424.

# Information about versions of packages and software used
R version 4.0.2 (2020-06-22)
Platform: x86_64-apple-darwin17.0 (64-bit)
Running under: macOS  10.16

Matrix products: default
LAPACK: /Library/Frameworks/R.framework/Versions/4.0/Resources/lib/libRlapack.dylib

locale:
[1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
 [1] bipartite_2.15       sna_2.6              network_1.16.1      
 [4] statnet.common_4.4.1 vegan_2.5-7          lattice_0.20-41     
 [7] permute_0.9-5        RInSp_1.2.4          GGally_2.1.0        
[10] performance_0.9.0    cowplot_1.1.1        visreg_2.7.0        
[13] broom_0.7.3          forcats_0.5.0        stringr_1.4.0       
[16] dplyr_1.0.2          purrr_0.3.4          readr_1.4.0         
[19] tidyr_1.1.2          tibble_3.0.4         ggplot2_3.3.5       
[22] tidyverse_1.3.0     

loaded via a namespace (and not attached):
 [1] nlme_3.1-151       fs_1.5.0           lubridate_1.7.9.2  insight_0.17.0    
 [5] RColorBrewer_1.1-2 httr_1.4.2         tools_4.0.2        backports_1.2.1   
 [9] utf8_1.1.4         R6_2.5.0           DBI_1.1.0          mgcv_1.8-33       
[13] colorspace_2.0-0   withr_2.3.0        tidyselect_1.1.0   compiler_4.0.2    
[17] cli_2.2.0          rvest_0.3.6        xml2_1.3.2         labeling_0.4.2    
[21] bayestestR_0.11.5  scales_1.1.1       EcoSimR_0.1.0      digest_0.6.27     
[25] rmarkdown_2.6      pkgconfig_2.0.3    htmltools_0.5.1    dbplyr_2.0.0      
[29] maps_3.3.0         rlang_0.4.10       readxl_1.3.1       rstudioapi_0.13   
[33] farver_2.0.3       generics_0.1.0     jsonlite_1.7.2     magrittr_2.0.1    
[37] dotCall64_1.0-0    Matrix_1.3-2       Rcpp_1.0.6         munsell_0.5.0     
[41] fansi_0.4.1        lifecycle_0.2.0    stringi_1.5.3      yaml_2.2.1        
[45] MASS_7.3-53        plyr_1.8.6         grid_4.0.2         parallel_4.0.2    
[49] crayon_1.3.4       haven_2.3.1        splines_4.0.2      hms_1.0.0         
[53] knitr_1.30         pillar_1.4.7       igraph_1.2.6       rle_0.9.2         
[57] reprex_0.3.0       glue_1.4.2         evaluate_0.14      modelr_0.1.8      
[61] vctrs_0.3.6        spam_2.6-0         cellranger_1.1.0   gtable_0.3.0      
[65] reshape_0.8.8      assertthat_0.2.1   datawizard_0.4.0   xfun_0.20         
[69] coda_0.19-4        fields_11.6        cluster_2.1.0      ellipsis_0.3.1    
