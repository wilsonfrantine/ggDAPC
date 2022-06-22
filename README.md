# ggDAPC

## A set of codes to plot DAPC with ggplot2

![Comparison of plots](./images/comparison.png)

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

### How to use

1. Download the DAPC.R file 
2. Open in your R editor software
3. change the path of the input file ('file' variable) to the one were is your genepop input file data.
4. Run the code!

### Important details

This script is just a simple pipeline and it is not a set of functions to translate the results yet.

The code run two sets of analysis:

#### 1. A priori groupment as provided in the genepop input. 

   Usually the "populations" as described by the user into the genepop input file. It is usefull to see whether the data support sampling sites separation as expected. See more in the Adegenet documentation

#### 2. Best K groupment given the data.  

   Some tutorials indicate as the best practice try to findout the best groupment hypothesis given the data. The adegenet package has a function: find.best.k which provides some support to group individuas by bestK algorithm and bayesian information (see more in adegenet docs).
   This seccond option show data considering the user provided bestK groupmented from find.cluster function.
    
### Disclaimer

This code works only when there is more than one DA axis. The kernel density when only a single DA is provided is not implemented yet.
Users must to be sure about their choices on their own data. There is no warants for this script.
You can change any parameters of the graph whenever you want.


