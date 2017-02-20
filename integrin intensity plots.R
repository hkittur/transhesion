setwd("Documents/Lab/Lab files/IMPORTANT DATA/")

#bring in libraries
library(ggplot2)
library (reshape2)
library(scales)
library(grid)

colors <- c("#B3B3B3", "#B3B3B3", "#FF7F2A","#37ABC8","#FF7F2A","#37ABC8")
colors6 <- c("red","blue","green","orange","yellow","magenta")
colors12 <- c("#FF7F2A","#37ABC8","#FF7F2A","#37ABC8","#FF7F2A","#37ABC8","#FF7F2A","#37ABC8","#FF7F2A","#37ABC8","#FF7F2A","#37ABC8")
colors12_new <-c("#B3B3B3","magenta","#B3B3B3","magenta","#B3B3B3","magenta","#B3B3B3","magenta","#B3B3B3","magenta","#B3B3B3","magenta")
colors12_flip <-c("#37ABC8","#FF7F2A","#37ABC8","#FF7F2A","#37ABC8","#FF7F2A","#37ABC8","#FF7F2A","#37ABC8","#FF7F2A","#37ABC8",'#37ABC8')

#read all csv files
alpha2 <- read.csv("alpha2.csv")
alpha6 <- read.csv("alpha6.csv")
beta1 <- read.csv("beta1.csv")
alpha2_2D <- read.csv("alpha2_2D.csv")
alpha6_2D <- read.csv("alpha6_2D.csv")
beta1_2D <- read.csv("beta1_2D.csv")
circularity <- read.csv("circularity.csv")
area <- read.csv("Area.csv")
MDA_C1vLn <- read.csv("MDAlung_C1vLn_alldata.csv")
MDAlung_all <- read.csv("MDAlung_alldata.csv")
MDAlung_melt <- read.csv("MDAlung_alldata_melt.csv")
via <- read.csv("viability.csv")
hMEC_via <- read.csv("hMEC_viability.csv")
vimentin <- read.csv("vimentin.csv")
cadherin <- read.csv("cadherin.csv")
hMEC_area <- read.csv("hMEC_area.csv")
hMEC_circularity <- read.csv("hMEC_circularity.csv")
MDAlung_area <- read.csv("MDAlung_area.csv")
MDAlung_circularity <- read.csv("MDAlung_circularity.csv")
hMEC_neighbors <- read.csv("hMEC_neighbors.csv")
MDAlung_neighbors <- read.csv("MDAlung_neighbors.csv")
cellsize <- read.csv("cellsize.csv")
drug_transhesion <- read.csv("drug_transhesion.csv")
protein_intensity <- read.csv("proteinstripes_intensity.csv")
hMEC_trans <-read.csv("hMEC_trans.csv")
MDAbrain_trans <-read.csv("mdabrain_trans.csv")

#more CSV files! Drugs
setwd("Documents/Lab/Lab files/IMPORTANT DATA/Drug comparisons/")
a2 <- read.csv("a2.csv")
a6 <- read.csv("a6.csv")
B1 <- read.csv("B1.csv")
bleb <- read.csv("bleb.csv")
calyA <- read.csv("calyA.csv")
GM <- read.csv("GM.csv")
GMSS <- read.csv("GMSS.csv")
IPA3 <- read.csv("IPA3.csv")
jak <- read.csv("jak.csv")
latB <- read.csv("latB.csv")
LPA <- read.csv("LPAnoFBS.csv")
noco <- read.csv("noco.csv")
noFBS <- read.csv("noFBS.csv")
pax <- read.csv("pax.csv")
SS <- read.csv("SS.csv")



#choose data and melt it
df <- hMEC_trans
m_df <- melt(df)

# hist
ggplot(df, aes(x=C1.v.C4.top)) + geom_histogram()

#plot parameters
ggplot(m_df, aes(x=variable, 
                     y =value, 
                     #fill=variable, 
                     #shape =variable
                 )) +
  geom_jitter(position=position_jitter(0.2),
              aes(color=variable,
                  size = 2
              #shape = variable
              )) +
  #geom_violin() +
  scale_color_manual(values=colors12_new) +
  #scale_shape_manual(values = 3)+
  #geom_hline(yintercept=1,
             #size = 3,
             #linetype =2) + 
  stat_summary(fun.y=median,
               fun.ymin=median,
               fun.ymax=median,
             geom="crossbar", 
             #shape=18, 
             width = 0.5,
             color="black") +
  theme_bw() +
  theme(axis.line = element_line(colour = "black",
                                 size = 3,
                                 lineend = "round"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.ticks = element_line(size = 3,
                                  lineend = "round"),
        axis.ticks.length=unit(-0.25, "cm"),
        axis.ticks.margin=unit(0.5, "cm"),
        axis.text.y = element_text(face="bold", 
                                   size=30),
        axis.text.x = element_blank(),
        axis.title = element_blank(),
        legend.position = "none") +
        scale_y_continuous(limits=c(0, 100), breaks=seq(0, 100,20)) ### check the scale_y_continuous, it will be different per graph

# bar graph for nearest neighbors
ggplot(m_df, aes(x=variable, 
                 y =value, 
                 #fill=value, 
                 #shape =variable
)) +
  geom_point(aes(color=colors12_flip),
             size = 8) +
 #not sure why the above colors had to be flipped
  theme_bw() +
  theme(axis.line = element_line(colour = "black",
                                 size = 3,
                                 lineend = "round"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.ticks = element_line(size = 3,
                                  lineend = "round"),
        axis.ticks.length=unit(-0.25, "cm"),
        axis.ticks.margin=unit(0.5, "cm"),
        axis.text.y = element_text(face="bold", 
                                   size=30),
        axis.text.x = element_blank(),
        axis.title = element_blank(),
        legend.position = "none") +
  scale_y_continuous(limits=c(0, 100), breaks=seq(0, 100,10)) ### check the scale_y_continuous, it will be different per graph



# Create combinations of the variables
combinations <- combn(colnames(df),2, simplify = FALSE)

# Do the Mann-Whitney-Wilcoxon test
results <- lapply(seq_along(combinations), function (n) {
  df <- df[,colnames(df) %in% unlist(combinations[n])]
  result <- wilcox.test(df[,1], df[,2])
  return(result)})

# Rename list for legibility    
names(results) <- paste(matrix(unlist(combinations), ncol = 2, byrow = TRUE)[,1], matrix(unlist(combinations), ncol = 2, byrow = TRUE)[,2], sep = " vs. ")


#plot MDAlung all data transfer v cell number

ggplot(df, aes(Count,Transfer)) +
  geom_point(aes(color=factor(ID))) +
  geom_smooth(aes(color=factor(ID)),
              se = FALSE,
              size = 3,
              span = 0.5) +
  scale_colour_manual(values=colors6) +
  xlab("Cell number") +
  ylab("Percent transfer") +
  theme_bw() +
  geom_vline(xintercept=100,
             size = 3,
             linetype =2) + 
  theme(axis.line = element_line(colour = "black",
                                 size = 5,
                                 lineend = "round"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.ticks = element_line(size = 5,
                                  lineend = "round"),
        axis.ticks.length=unit(-0.25, "cm"),
        axis.ticks.margin=unit(0.5, "cm"),
        axis.text = element_text(face="bold", 
                                 size=30),
        axis.title = element_text(size =30,
                                  face = "bold"))

#plot MDAlung C1vLn transfer v cell number

ggplot(df, aes(x=count, 
               y =transfer)) +
  xlab("Cell number") +
  ylab("Percent transfer") +
  geom_point(shape=16,
             size = 3,
             color = 'magenta') +
  theme_bw() +
  geom_vline(xintercept=100,
             size = 3,
             linetype =2) + 
  theme(axis.line = element_line(colour = "black",
                                 size = 5,
                                 lineend = "round"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.ticks = element_line(size = 5,
                                  lineend = "round"),
        axis.ticks.length=unit(-0.25, "cm"),
        axis.ticks.margin=unit(0.5, "cm"),
        axis.text = element_text(face="bold", 
                                 size=30),
        axis.title = element_text(size =30,
                                  face = "bold"))

# Simple bar plot showing viability
ggplot(m_df, aes(x=variable, 
               y =value)) +
  ylab("Percent viability") +
  geom_bar(stat="identity") +
  theme_bw() +
  theme(axis.line = element_line(colour = "black",
                                 size = 5,
                                 lineend = "round"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.ticks = element_line(size = 5,
                                  lineend = "round"),
        axis.ticks.length=unit(-0.25, "cm"),
        axis.ticks.margin=unit(0.5, "cm"),
        axis.text = element_text(face="bold", 
                                 size=20),
        axis.title.y = element_text(size =30,
                                  face = "bold"),
        axis.title.x = element_blank())

#plot hMEC C1vLn viability v cell number (still under construction)
ggplot(df, aes(x=num_bottom, 
               y =via_bottom)) +
  xlab("Cell number") +
  ylab("Cell viability") +
  geom_point(shape=16,
             size = 5,
             color = 'blue') +
  theme_bw() +
  geom_vline(xintercept=100,
             size = 3,
             linetype =2) + 
  theme(axis.line = element_line(colour = "black",
                                 size = 5,
                                 lineend = "round"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.ticks = element_line(size = 5,
                                  lineend = "round"),
        axis.ticks.length=unit(-0.25, "cm"),
        axis.ticks.margin=unit(0.5, "cm"),
        axis.text = element_text(face="bold", 
                                 size=30),
        axis.title = element_text(size =30,
                                  face = "bold")) +
  scale_y_continuous(limits=c(0, 100), breaks=seq(0, 100, 10))




for (i in 1:20){
  for (j in 1:6){
    x <- 6*i+j
    y<-84+j
    result <- wilcox.test(df[,y], df[,x])$p.value
  print(result)
  }
}
