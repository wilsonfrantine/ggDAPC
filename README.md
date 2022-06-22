# ggDAPC

## A set of codes to plot DAPC with ggplot2

Discriminant Analysis of Principal Components (DAPC) from Adegenet R package is quite usefull analysis to explore differences between sets of genetic data (SNIP or SSR data) without genetic models assumptions.

This chunck of code intends to compile a set of functions to help people to plot DAPC outputs in ggplot2 graphic grammar.
The ggplot2 package is quite flexible and users can customize these objects in several ways.

These scripts are based so far in the following pacakges:

 - **base R v4.1.1**    
  - **adegenet**: Exploratory Analysis of Genetic and Genomic Data    
  - **tidyverse**: a set of packages that work in harmony - for data wragling    
  - **ggplot2**: Create Elegant Data Visualisations Using the Grammar of Graphics    
  - **scico**: Colour Palettes Based on the Scientific Colour-Maps - colorblind friendly    
  - **patchwork**: The Composer of Plots - a ggplot2 arranger    


I recommend users to take a look at the docummentation of all these packages, but you don't have to do so for the script use.

See the comparison of output plot examples:

### Original Plots

**Scaterplots**

![Original DAPC scatter](./images/dapc_org_plot.svg)

**Compoplot**

### ggPlot2 + patchwork composition

![ggplot2 Composition](./images/dapc_ggplot2.svg)
