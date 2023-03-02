## ---------------------------
##
## Script name: PCOa MAGs from PULs
##
##
## Author: Rafael López-Sánchez
##
## Date Created: 2023-02-20
##
## Copyright (c) Rafael, López-Sánchez 2023
## Email: rafael.lopez@ibt.unam.mx
##
## ---------------------------
##
## Notes: This script is to see the distribution of PULs in Nayfach MAGs.
##   
##
## ---------------------------

## set working directory for Mac.

setwd("/Users/rafaellopezsanchez/Desktop") # Rafa's working directory (mac)


# Loading the required libraries
library(pracma)
library(vegan)

# Reading a table that classifies the samples into ecological zones.

Colvec_expedition=read.csv('MAG.Color_vector.csv', header=TRUE ,row.names=1,sep=',')


# Assigning colors to the samples based on their ecological air supply
colvec <-c(rep("blue", 212),rep("orange", 217))

#Reading the abundance table (samples must be organized by row while PUL composition must be organized by column).
PULs=read.table('pcoa.puls.matrix.txt', header=TRUE, row.names=1, sep="\t")

# Transpose the table
PULs=t(PULs)
# Calculating Bray-Curtis dissimilarity
Bray=vegdist(PULs,"bray")

# Applying a non-constrained ordination (PCoA) on the dissimilarity matrix 
PULs_bray=capscale(Bray~-1)

# Extracting the percentage explained by the first two dimensions and automatically adding them to the axes titles

PULs_bray_eig = eigenvals(PULs_bray)
percentage_variance_explained <- PULs_bray_eig / sum(PULs_bray_eig)
sum_percentage_variance_explained <- cumsum(PULs_bray_eig / sum(PULs_bray_eig))
xlabel= as.numeric(format(round((percentage_variance_explained[1]*100), 2), nsmall = 2))
xlabel= sprintf("%.2f %%", xlabel)
xlabel= paste ("PCo1 (", xlabel, ")")
ylabel= as.numeric(format(round((percentage_variance_explained[2]*100), 2), nsmall = 2))
ylabel= sprintf("%.2f %%", ylabel)
ylabel= paste ("PCo2 (", ylabel, ")")
# Assigning the groups to the samples. 
gsites= c(Colvec_expedition$Ecosystem)


# Conducting a Permanova test and extracting the p-value
Permanova_test <- adonis(formula = PULs ~ gsites)
pval <- Permanova_test$aov.tab$`Pr(>F)`[1]

# Applying hierarchical clustering on the dissimilarity matrix for plotting on top of the ordination analysis

H_CLustering=hclust(vegdist(PULs,"bray"))

png("PULs.PCOa.png", width=1100, height=1100, res = 300)

# Plotting the figure
# Adding the axes, grid, and other aestethics
plot(PULs_bray, 
	family="Times", 
	type="n", 
	xlab="", 
	ylab="",
	ylim=c(-1.5, 2.0), 
	xlim=c(-1.5, 1.8), 
	cex.axis=0.4, 
	tck = -0.01, 
	mgp = c(3, 0.2, 0), 
     	xaxp  = c(-4, 4, 8), 
	panel.first=grid(col = "white",lty=0))
title(ylab=ylabel, 
	line=1.2, 
	cex.lab=0.4)
title(xlab=xlabel, 
	line=1.2, cex.lab=0.4)
abline(h=0,
	v=0, 
	col = "white", 
	lty = 1, 
	lwd = 1.5)
abline(h=-10:10, 
	v=-10:10, 
	col = "lightgray", 
	lty = "dotted", 
	lwd = 0.5)
	par(lty=2)

# Adding the confidence intervals at two different levels (97.5% and 95%)
ordiellipse(PULs_bray, groups = gsites,  kind = "sd",conf= 0.975, draw ="polygon", lwd = 0.5)
par(lty=2)
ordiellipse(PULs_bray, groups = gsites,  kind = "sd",conf= 0.95, draw ="polygon", col = "grey90", lwd = 0.5, lty=2)
par(lty=2)

# Adding the hierarchical clustering
ordicluster(PULs_bray, H_CLustering, prune= 4, display = "sites", col = "grey", lwd = 0.5)

# Adding the samples at the end to be on top of all the other plotted elements
points(PULs_bray,cex= 0.5,pch=21, col="black", bg= colvec, lwd = 0.5)
# Adding a legend
lgend.x=2.1
legend.y=1.8
legend(lgend.x-0.5,legend.y, pt.cex= 0.5 , pt.lwd = 0.5,c("Soil", "Sediment"),bty = "n" ,pch = 21,col="black",pt.bg = c("blue", "orange"), cex = 0.4)
legend((lgend.x-0.71),(legend.y+0.15), cex=0.4 , c("Ecosystem"),bty = "n" ,pch = 21,col="white",pt.bg = c("white"))

# Adding the Permanova p-value
text(x= 1.6 , y= -1.2 ,expression(paste("Permanova")), cex = 0.4)
text(x= 1.6 , y= -1.35 ,paste("p-value = ", pval, sep = ""), cex = 0.4)

dev.off()
##############################################################################################################################################################
