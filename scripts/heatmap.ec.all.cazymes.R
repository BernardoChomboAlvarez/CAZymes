## ---------------------------
##
## Script name: HEATMAP EXTRACELLULAR CAZYMES FROM MAGS OBTAINED FROM MARINE SEDIMENTS
##
##
## Author: Rafael López-Sánchez
##
## Date Created: 2023-01-10
##
## Copyright (c) Rafael, López-Sánchez 2023
## Email: rafael.lopez@ibt.unam.mx
##
## ---------------------------
##
## Notes: This script is used to make a Heatmap of the Extracellular CAZyme matrix of MAGs found in our 37 marine sediment metagenomes using the "pheatmap" package of R. For more information https://github.com/RafaelLopez-Sanchez/marine_sediments.
##   
##
## ---------------------------

## set working directory for Mac.

setwd("/Users/rafaellopezsanchez/Desktop") # Rafa's working directory (mac)

## Load the R packages.

library(tidyr)
library(readr)
library(pheatmap)
library(RColorBrewer)
library(vegan)


#Load MAG annotation.
MAG=read.table('normalized_counts.txt', header=TRUE, row.names=1, sep="\t")
as.data.frame(MAG) -> MAG

#Load class annotation
class=read.table('class.all.MAGs.txt', header=TRUE, row.names=1, sep="\t")

#Remove all columns with a sum less than 4.
#MAG=MAG[colSums(MAG)> 6.0]
MAG=MAG[, colSums(MAG != 0) > 0]
#Remove zero labels from figure
MAG-> non_zero
non_zero[non_zero == 0.0] <- ""
as.data.frame(non_zero) -> non_zero

#Color palette for the heatmapmy_palette <- colorRampPalette(c("white", "pink", "red"))(n = 400)
col_breaks = c(seq(-0,1, length=100), seq(2,300,length=100), seq(301,1000,length=100))


#Transpose the data frames.MAG=t(MAG)
non_zero=t(non_zero)

png("ec.MAGs.CAZymes.png", width=3100, height=4900, res = 300)
pheatmap(MAG, 
	cluster_cols = FALSE, 	
	annotation_row = class ,
	breaks = col_breaks, 
	legend_breaks = c(0, 1),
	legend_labels= c("-","+"),
	cluster_rows = FALSE, 
	color= my_palette, 
	main = "Extracellular CAZymes in MAGs", cex.lab=0.01)
dev.off()

