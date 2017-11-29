# libraries
library(shiny)
library(tidyverse)
library("shinyWidgets")
library(RColorBrewer)		# awesome color palettes
library(d3heatmap)			# for heatmaps
library(plotly)
library(DT)
library(networkD3)			# Classification tree of disease
library(packcircles)		# for calculating packcircles
library(gridExtra)
library(viridis)
library(grid)
library(ggiraph)			# To animate the ggplot2 bubble chart




# -----------------------------------
# data = HR of oleguer give in October
data=read.table(file="DATA/pairwiseHR_october.txt" , header=T, sep=";")	
# In data I remove the useless 'Risk of..' 
data=data %>% mutate(outcome2=gsub("Risk of ","",outcome2)) 
# I reorder the levels in data to respect the ICD10 classification order.
mylevels = c("Organic disorders", "Substance abuse", "Schizophrenia and related", "Mood disorders",  "Neurotic disorders", "Eating disorders", "Personality disorders", "Mental retardation", "Developmental disorders", "Behavioral disorders")     
data = data %>% mutate( outcome2 = factor(outcome2, levels=mylevels)) %>% mutate( exposure2 = factor(exposure2, levels=mylevels))


# -----------------------------------
# Equivalence between Oleguer codes and WHO classif
equi=read.table(file="DATA/classif_oleguer.csv", sep="\t", header=F)
colnames(equi)=c("OleguerCode","Group","WHO","Explanation","Importance")

# The Main groups are:
mymain=equi$OleguerCode[which(equi$Importance=="main")]



# -----------------------------------
# Complete list of ICD disease
load("DATA/WHO_disease_classification_mental.R")


# -----------------------------------
# Set the color attribution?
my_palette = viridis(10)
my_palette = rev(my_palette)
color_attribution=c(
	"Organic disorders" = my_palette[1], 
	"Substance abuse" = my_palette[2], 
	"Schizophrenia and related" = my_palette[3], 
	"Mood disorders" = my_palette[4],  
	"Neurotic disorders" = my_palette[5], 
	"Eating disorders" = my_palette[6], 
	"Personality disorders" = my_palette[7], 
	"Mental retardation" = my_palette[8], 
	"Developmental disorders" = my_palette[9], 
	"Behavioral disorders" = my_palette[10]
)











