# <img src="https://cdn-icons-png.flaticon.com/512/15387/15387869.png" alt="scatterplot icon" width="40" align="center"> ggDAPC

**ggDAPC** is an R script that enhances the visualization of Discriminant Analysis of Principal Components (DAPC) results using the versatile `ggplot2` package.  
DAPC, available in the `adegenet` package, is a robust method for exploring genetic differences among groups without relying on genetic model assumptions.  
By leveraging `ggplot2`, **ggDAPC** offers customizable and publication-ready graphics for your genetic data analyses.  

![Comparison of plots](./images/comparison.png)  

---

## ✨ Features  

- **Enhanced Visualization** – Transform standard DAPC plots into customizable `ggplot2` graphics.  
- **Flexibility** – Modify colors, shapes, and layouts to suit your publication needs.  
- **Integration** – Seamlessly works with outputs from the `adegenet` package.  

---

## 📦 Dependencies  

To utilize **ggDAPC**, ensure the following R packages are installed:  

- **base R v4.1.1**  
- **adegenet** – Exploratory Analysis of Genetic and Genomic Data  
- **tidyverse** – A collection of packages for data wrangling  
- **ggplot2** – Create Elegant Data Visualisations Using the Grammar of Graphics  
- **scico** – Colour Palettes Based on the Scientific Colour-Maps (colorblind friendly)  
- **patchwork** – The Composer of Plots - a `ggplot2` arranger  

It's recommended to review the documentation of these packages to fully leverage their capabilities.  

---

## 🚀 Getting Started  

1. **Download the `DAPC.R` File** – Obtain the script from the repository.  
2. **Load the Script** – Source the script in your R environment.  
   ```r
   source("path_to/DAPC.R")
   ```  
3. **Prepare Your Data** – Ensure your genetic data is in the appropriate format (e.g., GENEPOP file with `.gen` extension).  
4. **Run the Analysis** – Execute the functions provided in the script to perform DAPC and generate plots.  

For a step-by-step guide, refer to the [simple tutorial](https://wilsonfrantine.github.io/ggDAPC/).  

---

## 🔍 Analysis Overview  

**ggDAPC** facilitates two primary analyses:  

1. **A Priori Grouping** – Analyzes groups as defined in your input file, typically representing predefined populations. This approach assesses whether the data supports expected group separations.  

2. **Optimal K Grouping** – Determines the optimal number of clusters (`K`) based on your data, utilizing the `find.clusters` function from `adegenet`. This method identifies the most likely grouping without prior assumptions.  

---

## 📝 Important Considerations  

- **Data Responsibility** – Ensure your data is appropriately formatted and that you understand the implications of your analytical choices.  
- **Customization** – Feel free to modify graph parameters to better represent your findings.  
- **No Warranty** – This script is provided as-is, without guarantees. Use it responsibly and validate your results.  

---

## 📚 Learn More  

For detailed information on DAPC and its applications, consult the [adegenet package documentation](https://cran.r-project.org/web/packages/adegenet/index.html) and relevant literature, such as Jombart et al. (2010). 
