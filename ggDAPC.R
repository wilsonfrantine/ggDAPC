packages <- c("adegenet", "tidyverse", "ggplot2", "scico", "patchwork")
for(i in packages){
  if(!require(i, character.only = T)){
    install.packages(i); library(i);
  } 
  else cat(paste("package", i, "loadead \n")) 
}

ggDapc <- function (dapc=NULL, k=NULL, x="LD1", y="LD2", cstar=TRUE, ellipse=TRUE, labels=TRUE) {
  
  ggDataShaper <- function(x, k=NULL){
    if(is.null(k)) k=x$grp
    da.coord  <- data.frame(x$ind.coord, grp=x$grp) %>% as_tibble()
    grp.coord <- data.frame(x$grp.coord, grp=rownames(x$grp.coord))
    ind.coord <- left_join(da.coord, grp.coord, by="grp", suffix = c("",".c"))
    ind.coord$grp <- k
    
    labels    <- data.frame(x$grp.coord, "Pop"=row.names(x$grp.coord))
    
    out <- list("ind.coord" = ind.coord,
                "grp.labels"      = labels)
    return(out)
  }
  ggScatter <- function(ggdata=NULL, x="LD1", y="LD2", cstar=TRUE, ellipse=TRUE, grp.labels=TRUE){
    out <- ggplot(data = ggdata$ind.coord, 
                  aes_string(x = x, y=y, color="grp")) + 
      geom_point()+
      scale_color_scico_d(palette = "romaO", begin = 0.2, end = 0.8)+
      scale_fill_scico_d(palette = "romaO", begin = 0.2, end = 0.8)+
      theme(
        legend.position = "none"
      )
    if(cstar) { 
      out <- out + geom_segment(
        data=ggdata$ind.coord,
        aes_string(x = x, xend = paste0(x,".c"),
                   y = y, yend = paste0(y,".c")) )
    }
    if(ellipse) out <- out + stat_ellipse()
    if(grp.labels) {
      out <- out + geom_text(data = ggdata$grp.labels,
                             aes_string(x = x, y = y, label = "Pop"),
                             color="black", fontface="bold", size=6
      )
    }
    return(out)
  }
  
  ggDensity <- function(ggdata=NULL, x="LD1"){
    d <- density(unlist(ggdata$ind.coord[,x]))
    dmin <- min(d$x)
    dmax <- max(d$x)
    ggplot(data = ggdata$ind.coord,
           aes_string(x = x, groups="grp", 
                      fill="grp", colour="grp"))+
      geom_density(alpha=0.7)+
      xlim(dmin, dmax)+
      labs(fill=x, color=x)+
      scale_color_scico_d(palette = "romaO", begin = 0.2, end = 0.8)+
      scale_fill_scico_d(palette = "romaO", begin = 0.2, end = 0.8)
  }
  
  if(dapc$n.da > 1) ggDataShaper(dapc, k) %>% ggScatter(., x, y, cstar, ellipse, grp.labels)
  else ggDataShaper(dapc, k) %>% ggDensity
}

ggPCvar <- function(x){
  out <- 
    data.frame(
      var = cumsum((x$pca.eig))/sum(x$pca.eig)*100,
      ret.pca = c( rep(TRUE,length(x$tab)),
                   rep(FALSE, length(x$pca.eig)-length(x$tab)) ),
      pca = 1:length(x$pca.eig)
    ) %>%
    ggplot(aes(y=var, x=pca, fill=ret.pca))+
    geom_col(width = 1)+
    theme_classic()+
    scale_fill_scico_d(palette = "grayC", begin=0.1, end=0.2)+
    theme(
      legend.position = "none"
    )+
    labs(y="PC cum. var. %", x="PC")
  return(out)
}

ggDAplot <- function(x){
  out <- data.frame(
    DA = colnames(x$loadings),
    values = x$eig,
    fill = "gray") %>% 
    ggplot( aes(x=DA, y=values, fill=fill) )+
    geom_col()+
    theme_classic()+
    labs(y="DA eigenvalues", x="")+
    scale_fill_scico_d(palette="grayC", begin=0.2)+
    theme(legend.position = "none")
  return(out)
}

ggCompoplot <- function(dapc){
  
  temp.data <- dapc$grp %>% as_tibble() %>% arrange(value) %>%
    mutate(x = row_number()) %>% group_by(value) %>%
    mutate(xend = n()+x, y=-0.05, yend=-0.05 ) %>% slice(1)
  
  temp.data$x[1] <- 0
  
  temp.data <- temp.data %>% mutate(labels.pos = xend - I((xend-x)/2))
  
  out <- 
    dapc$posterior %>% as_tibble() %>% 
    mutate(ind = row_number()) %>%
    pivot_longer(cols=colnames(.)[-length(.)], names_to = "grp", values_to = "prob") %>% dplyr::arrange(grp) %>%
    ggplot(aes(y=prob, x=ind, fill=grp)) +
    geom_col(position = "stack", width = 1) + 
    labs(y="membership probability", x="", fill="")+
    theme_classic()+
    scale_fill_scico_d(palette = "romaO", begin = 0.2, end = 0.8, aesthetics = "fill") + 
    geom_segment(data = temp.data,
                 mapping=aes(x=x, xend=xend, y=y, yend=yend),
                 inherit.aes = F, show.legend = F, color="black"
    )+
    geom_segment( data = temp.data,
                  mapping=aes(x=xend-0.5, xend=xend-0.5, y=-0.075, yend=-0.025),
                  inherit.aes = F, color="grey10"
    )+
    geom_text(data = temp.data,
              aes(x=labels.pos, y=-0.1, label=value),
              inherit.aes = F)+
    theme(axis.line.x = element_blank(),
          axis.ticks.x = element_blank(),
          axis.text.x = element_blank(),
          legend.position = "none",
          legend.margin = margin(0,0,0,0, unit="mm"),
          legend.box.spacing = unit(0,"mm"),
          legend.box.margin = margin(0,0,0,0, unit="mm")
    )
  return(out)
}