#Larvae DAPC + ggplot2
#if you don't have devtools installed
#run install.packages("devtools")
devtools::source_url("https://raw.githubusercontent.com/wilsonfrantine/ggDAPC/main/ggDAPC.R")
#if you downloaded the file you can use:
#source("change this quotes for the file path")

file <- "~/genepop.gen"
data <- adegenet::read.genepop(file, 3)
summary(data)
#save(data, file ="test.Rdata", ascii = TRUE)

#DAPC considering prior Pop groups
PopDapc <- adegenet::dapc(data)
50
2
scatter(PopDapc, scree.da = T, scree.pca = T)
compoplot(PopDapc, border = 1)

### ggDAPC plots
ggDapc(PopDapc)
ggCompoplot(PopDapc)

layout <- c(
  patchwork::area(t = 1, l = 1, b = 4, r = 3),
  patchwork::area(t = 1, l = 4, b = 2, r = 4),
  patchwork::area(t = 3, l = 4, b = 4, r = 4),
  patchwork::area(t = 5, l = 1, b = 6, r = 4)
)
ggDapc(PopDapc) + ggPCvar(PopDapc) + ggDAplot(PopDapc) + ggCompoplot(PopDapc) +
  patchwork::plot_layout(design = layout)

# Alternative K clusters ####
## Finding best K groupments ####
k <- find.clusters(data)
60
3
#Plotting individuals in each K
ggKtable(data, k) %>% wrap_plots()
k3 <- dapc(data, k$grp)
40
2
ggDapc(k3)
ggCompoplot(k3)

ggDapc(k3) + ggPCvar(k3) + ggDAplot(k3) + ggCompoplot(k3) +
  patchwork::plot_layout(design = layout)
