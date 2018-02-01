

# -----------------------------------
# 1- LOAD LIBRARIES

# libraries
library(shiny)
library(dplyr)
library(ggplot2)
library(tidyr)
library("shinyWidgets")
library(RColorBrewer)		# awesome color palettes
#library(d3heatmap)			# for heatmaps
library(plotly)
library(DT)
library(networkD3)			# Sankey
library(packcircles)		# for calculating packcircles
library(gridExtra)
library(viridis)
library(grid)
library(ggiraph)			# To animate the ggplot2 bubble chart

library(shinycssloaders)	# Spinner if plot takes time to load


library(collapsibleTree)







# -----------------------------------
# 1- LOAD DATA

# data = HR of oleguer give in October
data=read.table(file="DATA/pairwiseHR.txt" , header=T, sep=";")	

# In data I remove the useless 'Exposed to ' 
data=data %>% mutate(exposure2=gsub("Exposed to ", "", exposure2)) 

# I reorder the levels in data to respect the ICD10 classification order.
mylevels = c("Organic disorders", "Substance abuse", "Schizophrenia and related", "Mood disorders",  "Neurotic disorders", "Eating disorders", "Personality disorders", "Mental retardation", "Developmental disorders", "Behavioral disorders")     
data = data %>% mutate( outcome2 = factor(outcome2, levels=mylevels)) %>% mutate( exposure2 = factor(exposure2, levels=mylevels))






# -----------------------------------
# 2- COLOR ATTRIBUTION

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



# -----------------------------------
# 3- SUMMARY INFO FOR EACH DISEASE

# Make the data nicer to see
don=read.table("DATA/Link_ICD10_ICD8.txt", header=T, sep="\t")
colnames(don)=gsub("\\.", " ", colnames(don))
don$Subgroup=gsub("@", "\n", don$Subgroup)

don_long=read.table("DATA/Link_ICD10_ICD8_long.txt", header=T, sep="\t")
colnames(don_long)=gsub("\\.", " ", colnames(don_long))



# -----------------------------------
# 4- CIP DATA

# CIP data are in a R object, the object is called 'CIP'
load("DATA/CIP_data.R")






