#Larvae DAPC + ggplot2
library("adegenet")
library("tidyverse")
library("ggplot2")
library("scico")
library("patchwork")

file <- "~/genepop.gen"
data <- adegenet::read.genepop(file, 3)
summary(data)

#DAPC considering prior Pop grous
Popdapc <- adegenet::dapc(data)
50
2
scatter(Popdapc, scree.da = T, scree.pca = T)
compoplot(Popdapc, border = 1)

#Preparing for ggplot2
##calculating centroids of each Pop for cstars
ggdapc <- 
  data.frame(Popdapc$ind.coord[,c("LD1","LD2")],
             Pop=Popdapc$grp) %>% 
  as_tibble() %>%
  group_by(Pop) %>%
  mutate(LD1.c=median(LD1), LD2.c=median(LD2)) %>% cbind(K = k_hypothesis)
##Getting the max values of each Pop
ymax <- ggdapc %>% group_by(Pop) %>%
    filter(LD2 == max(LD2)) %>% 
    ungroup() %>% select(LD2) %>% unlist()
  
centroids <- ggdapc %>% group_by(Pop) %>% summarise(x=first(LD1.c), y=first(LD2.c))
  
ggPopDapc <- ggdapc %>% 
  ggplot(aes(x=LD1, y=LD2, color=Pop))+
    geom_point()+
    geom_segment(aes(x=LD1, xend=LD1.c, y=LD2, yend=LD2.c))+
    stat_ellipse()+
    theme_light()+
    geom_text(aes(x = x, y = y, label = Pop), data=centroids,
               color="black", fontface="bold", size=6) +
    labs(x=x, y=y)+
  scale_color_scico_d(palette = "romaO", begin = 0.2, end = 0.8, aesthetics = "color")+
  theme(
    legend.position = "none"
  )
#To see other pallets
#scico::scico_palette_show()

##To access PCs used
PopPCAvar <- data.frame(
  var = cumsum((Popdapc$pca.eig))/sum(Popdapc$pca.eig)*100,
  ret.pca = c( rep(TRUE,length(Popdapc$tab)), rep(FALSE, length(Popdapc$pca.eig)-length(Popdapc$tab)) ),
  pca = 1:length(Popdapc$pca.eig)
) %>%
  ggplot(aes(y=var, x=pca, fill=ret.pca))+
  geom_col(width = 1)+
  theme_classic()+
  scale_fill_scico_d(palette = "grayC", begin=0.05, end=0.2)+
  theme(
    legend.position = "none"
  )+
  labs(y="PC cum. var. %", x="")

#Create a DA plot
PopDAplot <- data.frame( 
  DA = colnames(Popdapc$loadings),
  values = Popdapc$eig,
  fill = "gray") %>% 
ggplot( aes(x=DA, y=values, fill=fill) )+
  geom_col()+
  theme_classic()+
  labs(y="DA eigenvalues", x="")+
  scale_fill_scico_d(palette="grayC", begin=0.2)+
  theme(legend.position = "none")

##ggCompoPlot
ggPopCompoplot <- 
Popdapc$posterior %>% as_tibble() %>% 
  mutate(ind = row_number()) %>%
  pivot_longer(cols=colnames(.)[-length(.)], names_to = "grp", values_to = "prob") %>%
  ggplot(aes(y=prob, x=ind, fill=grp)) +
  geom_col(position = "stack", width = 1) + 
  labs(y="membership probability", x="", fill="")+
  theme_classic()+
  theme(
    axis.line.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.text.x = element_blank(),
    legend.position = "bottom"
  )+
  scale_fill_scico_d(palette = "romaO", begin = 0.2, end = 0.8, aesthetics = "fill")

layout <- c(
  patchwork::area(t = 1, l = 1, b = 4, r = 3),
  patchwork::area(t = 1, l = 4, b = 2, r = 4),
  patchwork::area(t = 3, l = 4, b = 4, r = 4),
  patchwork::area(t = 5, l = 1, b = 6, r = 4)
)
ggPopDapc + PopPCAvar + PopDAplot + ggPopCompoplot +
  patchwork::plot_layout(design = layout)

# Alternative K clusters ####
## Finding best K groupments ####
k <- find.clusters(data)
60
3
#Ploting individuals in each K
ktable <- table(data$pop, k$grp) %>% 
  as.data.frame() 
ktable %>%
  ggplot(aes(x=Var1, y=Freq, fill=Var2)) + 
  geom_col(position = "stack") + 
  labs(x="Pop", y="N", fill="K")
#Alternative Plot
ktable %>%
  ggplot(aes(x=Var1, y=Var2, color=Var2)) + 
  geom_point(aes(size=Freq), stroke=5, shape=15) +
  labs(x="Pop", y="K", color="K", size="N")+
  theme_classic()

#DAPC considering best K groups
Kdapc <- adegenet::dapc(data, k$grp)
40
2
scatter(Kdapc)
compoplot(Kdapc)

ggdapc <- 
  data.frame(Kdapc$ind.coord[,c("LD1","LD2")],
             Pop=Kdapc$grp) %>% 
  as_tibble() %>%
  group_by(Pop) %>%
  mutate(LD1.c=median(LD1), LD2.c=median(LD2)) %>% cbind(K = k_hypothesis)
##Getting the max values of each Pop
ymax <- ggdapc %>% group_by(Pop) %>%
  filter(LD2 == max(LD2)) %>% 
  ungroup() %>% select(LD2) %>% unlist()

centroids <- ggdapc %>% group_by(Pop) %>% summarise(x=first(LD1.c), y=first(LD2.c))

ggKdapc <- ggdapc %>% 
  ggplot(aes(x=LD1, y=LD2, color=Pop))+
  geom_point()+
  geom_segment(aes(x=LD1, xend=LD1.c, y=LD2, yend=LD2.c))+
  stat_ellipse()+
  theme_light()+
  geom_text(aes(x = x, y = y, label = Pop), data=centroids,
            color="black", fontface="bold", size=6) +
  labs(x=x, y=y)+
  scale_color_scico_d(palette = "romaO", begin = 0.2, end = 0.8, aesthetics = "color")+
  theme(
    legend.position = "none"
  )
#To see other pallets
#scico::scico_palette_show()

##To access PCs used
ggKpcaVar <- data.frame(
  var = cumsum((Kdapc$pca.eig))/sum(Kdapc$pca.eig)*100,
  ret.pca = c( rep(TRUE,length(Kdapc$tab)), rep(FALSE, length(Kdapc$pca.eig)-length(Kdapc$tab)) ),
  pca = 1:length(Kdapc$pca.eig)
) %>%
  ggplot(aes(y=var, x=pca, fill=ret.pca))+
  geom_col(width = 1)+
  theme_classic()+
  scale_fill_scico_d(palette = "grayC", begin=0.05, end=0.2)+
  theme(
    legend.position = "none"
  )+
  labs(y="PC cum. var. %", x="")

#Create a DA plot
kDAPlot <- data.frame( 
  DA = colnames(Kdapc$loadings),
  values = Kdapc$eig,
  fill = "gray") %>% 
  ggplot( aes(x=DA, y=values, fill=fill) )+
  geom_col()+
  theme_classic()+
  labs(y="DA eigenvalues", x="")+
  scale_fill_scico_d(palette="grayC", begin=0.2)+
  theme(legend.position = "none")

##ggCompoPlot
ggKcompoplot <- 
  Kdapc$posterior %>% as_tibble() %>% 
  mutate(ind = row_number()) %>%
  pivot_longer(cols=colnames(.)[-length(.)], names_to = "grp", values_to = "prob") %>%
  ggplot(aes(y=prob, x=ind, fill=grp)) +
  geom_col(position = "stack", width = 1) + 
  labs(y="membership probability", x="", fill="")+
  theme_classic()+
  theme(
    axis.line.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.text.x = element_blank(),
    legend.position = "bottom"
  )+
  scale_fill_scico_d(palette = "romaO", begin = 0.2, end = 0.8, aesthetics = "fill")

layout <- c(
  patchwork::area(t = 1, l = 1, b = 4, r = 3),
  patchwork::area(t = 1, l = 4, b = 2, r = 4),
  patchwork::area(t = 3, l = 4, b = 4, r = 4),
  patchwork::area(t = 5, l = 1, b = 6, r = 4)
)
ggKdapc + ggKpcaVar + kDAPlot + ggKcompoplot +
  patchwork::plot_layout(design = layout)
