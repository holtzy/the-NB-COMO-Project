	# ------------------------------------
	#
	#	The COMO project
	#
	# ------------------------------------


# Some stuff you need to explain and remember at the begining of the script

# open server
shinyServer(function(input, output) {






  # ------------------------------------------------------------------------------
  # COLLAPSIBLE TREE OF IC10
  # ------------------------------------------------------------------------------

	output$tree=renderCollapsibleTree({
		collapsibleTree(don_long, c("Name used in this study", "Subgroup"), zoomable=FALSE, root="Disorder Groups", fontSize = 17,
		                fill = c(
		                  # The root
		                  "seashell",
		                  # Unique regions
		                  my_palette,
		                  # Unique classes per region
		                  my_palette[match(don_long$`Name used in this study`, names(color_attribution))]
		                )
		                )
	})











  # ------------------------------------------------------------------------------
  # LINK ICD10 / ICD8
  # ------------------------------------------------------------------------------


	# render the table
	output$ICD10table <- DT::renderDataTable(

			displayableData<-DT::datatable( don , rownames = FALSE ,
				options = list(
					columnDefs = list(list(visible=FALSE, targets=8)),
					#pageLength = 40,
					dom = 't',
      				rowCallback = JS(
        				"function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {",
        				"var full_text = aData[8]",
        				"$('td:eq(0)', nRow).attr('title', full_text);",
        				"}"
      			)

			)) #%>%
			#formatStyle( 'Prevalent cases before follow up', background = styleColorBar(don[,6], alpha('steelblue',0.3)), backgroundSize = '80% 50%', backgroundRepeat = 'no-repeat', backgroundPosition = 'center' ) %>%
			#formatStyle( 'Persons at risk at start of follow up', background = styleColorBar(don[,7], alpha('skyblue',0.3)), backgroundSize = '80% 50%', backgroundRepeat = 'no-repeat', backgroundPosition = 'center' ) %>%
			#formatStyle( 'New cases during follow up', background = styleColorBar(don[,8], alpha('steelblue',0.3)), backgroundSize = '80% 50%', backgroundRepeat = 'no-repeat', backgroundPosition = 'center' )
	)












  # ------------------------------------------------------------------------------
  # Circle Packing
  # ------------------------------------------------------------------------------

	output$plot_circlepack=renderggiraph({

		# Generate the layout
		packing <- circleProgressiveLayout(don[,8], sizetype='area')
		packing$radius=0.98*packing$radius
		my_n_points=60
		dat.gg <- circleLayoutVertices(packing, npoints=my_n_points)
		dat.gg$id= rep( don[,2], each=my_n_points+1)

		# Add info
		packing$disease=don[,2]
		packing$N=don[,8]

		# Prepare text to display on hover
		packing$text=paste('<span style="font-size: 17px">', packing$disease, "\n\n", "</br>", "Number of cases:", packing$N, "\n", '</span>')
		dat.gg$text= rep( packing$text, each=my_n_points+1)

		# Make the plot
		p=ggplot() +
  			geom_polygon_interactive(data = dat.gg, aes(x, y, group = id, fill=as.factor(id), tooltip = text), colour = "black", alpha = 0.6, size=0.1) +
 		 	scale_fill_manual( values = color_attribution ) +

 		 	geom_text(data = packing, aes(x, y, size=N, label = gsub(" ", "\n", disease))) +
 		 	scale_size_continuous(range = c(0.8,3)) +

 		 	theme_void()+
 		 	theme(
  		  		legend.position="none",
   			) +
   			coord_equal()

  		ggiraph(ggobj = p, width_svg = 3, height_svg = 3)

	})

















  # ------------------------------------------------------------------------------
  # HISTOGRAM DOTPLOT
  # ------------------------------------------------------------------------------

	output$plot_longbar=renderPlotly({

		# Filter the data following the choice of the user
		if( input$sex_longbar=="all" ){
			list=c("basic_confounders","kessler_prev","kessler_prev_interactions")
			choice=as.numeric(input$model_dotplothisto)
			don = data %>% filter(model==list[choice] & !is.na(HR) )
		}else{
			list=c("sex_basic_confounders","sex_kessler_prev","sex_kessler_prev_interactions")
			choice=as.numeric(input$model_dotplothisto)
			don = data %>% filter(model==list[choice] & sex==input$sex_longbar & !is.na(HR) )
		}

		# Decide a color
		mycolor = ifelse(input$sex_longbar=="all" , "grey", ifelse(input$sex_longbar=="men", "#6699FF", "#CC99FF" ))

		# Prepare don for a hacked histogram
		don = don %>%
			arrange(HR) %>%
			mutate(HR_rounded = (HR+1) - ( (HR+1) %%2 ) ) %>%
			mutate(y=ave(HR_rounded, HR_rounded, FUN=seq_along)) %>%
		  	mutate(text=paste("Prior-Disorder: ", exposure2, "\n", "Later-disorder: ", outcome2, "\n", "HR: ", round(HR,1), " (", round(CI_left,1), " - ", round(CI_right,1), ")", sep="" ))

		# Make the plot
		p=ggplot(don, aes(x=HR_rounded, y=y) ) +
      		  geom_point( aes(text=text), size=5, color=mycolor ) +
		      xlab('Hazard Ratio') +
		      ylab('Number of pair of mental disorder') +
		      ylim(1,18) +
		      xlim(0,70) +
		      geom_vline(aes(xintercept = 1), color="grey", linetype="dashed") +
		      geom_text(  x=3, y=17, label="HR=1", color="grey") +
		      theme_classic() +
		      theme(
		      	legend.position="none",
		      	axis.line.y = element_blank(),
		      	axis.text=element_text(size=15)
		      )

		# Eventually log scale?
		if( input$log_dotplothisto == "log"){ p = p + scale_x_log10() }

		ggplotly(p, tooltip="text")


	})







  # ------------------------------------------------------------------------------
  # SANKEY diagram
  # ------------------------------------------------------------------------------

	output$plot_sankey=renderSankeyNetwork({

		# Filter the data following the choice of the user
		if( input$sex_sankey=="all" ){
			list=c("basic_confounders","kessler_prev","kessler_prev_interactions")
			choice=as.numeric(input$model_sankey)
			don = data %>% filter(model==list[choice] & !is.na(HR) )
		}else{
			list=c("sex_basic_confounders","sex_kessler_prev","sex_kessler_prev_interactions")
			choice=as.numeric(input$model_sankey)
			don = data %>% filter(model==list[choice] & sex==input$sex_sankey & !is.na(HR) )
		}

		# Prepare data?
		don = don %>%

			# Select subset of the data
			filter( HR>input$sankey_thres ) %>%

  			# make a difference between outcome and exposure (I add a space to outcome)
  			select(exposure2, outcome2, HR) %>%

  			# Make sure to respect the ICD10 order
  			arrange(exposure2, outcome2) %>%

  			# Add a space after outcome to make it slightly different
  			mutate(outcome2=paste(outcome2, " ", sep=""))

 		# Make a data frame with nodes
 		nodes=data.frame( ID = c(as.character(unique(don$exposure2)), as.character(unique(don$outcome2)) ) )

 		# Make a data frame with the links
 		don$outcome=match(don$outcome2, nodes$ID)-1
		don$exposure=match(don$exposure2, nodes$ID)-1

		# Prepare a color scale:
		ColourScal ='d3.scaleOrdinal() .domain(["Organic disorders" , "Substance use" , "Schizophrenia and related","Mood disorders" ,"Neurotic disorders", "Eating disorders" ,"Personality disorders", "Mental Intellectual Dis.", "Developmental disorders", "Behavioral disorders"]) .range(["#FDE725FF","#B4DE2CFF","#6DCD59FF","#35B779FF","#1F9E89FF","#26828EFF","#31688EFF","#3E4A89FF","#482878FF","#440154FF"])'

  		# Make the plot
 		sankeyNetwork(Links = don, Nodes = nodes,
             Source = "exposure", Target = "outcome",
             Value = "HR", NodeID = "ID", nodeWidth=40, fontSize=13,
             nodePadding=20, colourScale=ColourScal, width=992, height=744 ) #, LinkGroup="group")

	})








  # ------------------------------------------------------------------------------
  # Heatmap
  # ------------------------------------------------------------------------------

	output$plot_heat2=renderPlotly({


		# Filter the data following the choice of the user
		if( input$sex_heatmap=="all" ){
			list=c("basic_confounders","kessler_prev","kessler_prev_interactions")
			choice=as.numeric(input$model_heatmap)
			don = data %>% filter(model==list[choice] & !is.na(HR) )
		}else{
			list=c("sex_basic_confounders","sex_kessler_prev","sex_kessler_prev_interactions")
			choice=as.numeric(input$model_heatmap)
			don = data %>% filter(model==list[choice] & sex==input$sex_heatmap & !is.na(HR) )
		}


		p=don %>%
		  mutate(text=paste('<span style="font-size: 17px">', "\n", "Prior-disorder: ", exposure2, "\n\n", "Later-disorder: ", outcome2, "\n\n", "Hazard Ratio: ", round(HR,1), " (", round(CI_left,1), " - ", round(CI_right,1), ")", "\n"), '</span>') %>%
		  ggplot(aes( x=exposure2, y=outcome2)) +
			geom_tile(aes(fill = HR, text=text), colour = "white", size=4) +
			scale_fill_gradient(low = "white", high = "steelblue", breaks=c(0, 1, 10, 20, 30, 40, 50, 60), labels=c(0, 1, 10, 20, 30, 40, 50, 60) ) +
			theme_grey(base_size = 9) +
			labs(x = "Prior-disorder", y = "Later-disorder") +
			scale_x_discrete(expand = c(0, 0)) +
			scale_y_discrete(expand = c(0, 0)) +
			theme(
			  #legend.position = "none",
			  axis.ticks = element_blank(),
			  axis.text.x = element_text(size = 10, angle = 45, hjust = 0, colour = "grey50"),
			  axis.title = element_text(size = 14, angle = 0, hjust = 1, colour = "#2ecc71"),
			  axis.text.y = element_text(size = 10, angle = 0, hjust = 0, colour = "grey50"),
			  plot.margin = unit(c(1.8,1.8,1.8,1.8), "cm")
			)

		if (input$log_heatmap=="log"){ p = p + scale_fill_gradient(low = "white", high = "steelblue", trans = "log", breaks=c(0, 1, 10, 20, 30, 40, 50, 60), labels=c(0, 1, 10, 20, 30, 40, 50, 60)) }

		ggplotly(p, tooltip="text")

	})












  # ------------------------------------------------------------------------------
  # Symmetric Barplot
  # ------------------------------------------------------------------------------

	output$plot_symbar=renderPlot({

		# Recover what user choosed.
		mysex=input$sex_symetry_plot
		mydisease=input$disease_symetry_plot


		# Filter the data following the choice of the user
		if( input$sex_symetry_plot=="all" ){
			list=c("basic_confounders","kessler_prev","kessler_prev_interactions")
			choice=as.numeric(input$model_symmetry)
			don = data %>% filter(model==list[choice] & !is.na(HR) )
		}else{
			list=c("sex_basic_confounders","sex_kessler_prev","sex_kessler_prev_interactions")
			choice=as.numeric(input$model_symmetry)
			don = data %>% filter(model==list[choice] & sex==input$sex_symetry_plot & !is.na(HR) )
		}

		# I put the levels in the other side to make them appear in the normal order on the plot
		don = don %>%  mutate( exposure2 = factor(exposure2, levels=rev(mylevels))) %>%  mutate( outcome2 = factor( outcome2, levels=rev(mylevels)))

		# Create 2 datasets: every disease --> schizophrenia and return
		a=don %>%
		  filter( exposure2==mydisease ) %>%
		  select( outcome2, HR, CI_left, CI_right)
		b=don %>%
		  filter( outcome2==mydisease ) %>%
		  select( exposure2, HR, CI_left, CI_right)
		tmp=merge(a, b, by.x="outcome2", by.y="exposure2", all=T)

		#Create a theme
		mytheme =  theme(
		  legend.position="none",
		  axis.text.y = element_blank(),
		  axis.ticks.y = element_blank(),
		  axis.title.y = element_blank(),

		  axis.text.x = element_text(size=14),
		  axis.ticks.x = element_line(),
		  axis.title.x = element_text(size=16),

		  axis.line = element_blank(),
		  plot.margin = unit(rep(.3 ,4), "cm")
		)

		# Maximum?
		mymax=max(c(tmp$CI_right.x, tmp$CI_right.y))

		# p1
		mytitle=paste( mydisease, " as a later-disorder.", sep="")
		p1 <- ggplot(tmp, aes(x=outcome2, y=HR.y, fill=outcome2)) +
		  geom_bar(stat="identity") +
		  geom_errorbar( aes(ymin=CI_left.y, ymax=CI_right.y), width=0.3 ) +
		  coord_flip() +
		  ylim(0, mymax) +
		  scale_fill_viridis(discrete=TRUE) +
		  theme_classic() +
		  ylab("Hazard Ratio") +
		  mytheme +
		  ggtitle(bquote(italic(.(mytitle)))) +
		  theme( plot.title = element_text(color="grey", size=15, hjust=0.5))

		# p2
		mytitle=paste( mydisease, " as a prior-disorder.", sep="")
		p2 <- ggplot(tmp, aes(x=outcome2, y=HR.x, fill=outcome2)) +
		  geom_bar(stat="identity") +
		  geom_errorbar( aes(ymin=CI_left.x, ymax=CI_right.x), width=0.3 ) +
		  scale_y_reverse() +
		  ylim(mymax, 0) +
		  coord_flip() +
		  scale_fill_viridis(discrete=TRUE) +
		  theme_classic() +
		  ylab("Hazard Ratio") +
		  mytheme +
		  ggtitle(bquote(italic(.(mytitle)))) +
		  theme( plot.title = element_text(color="grey", size=15, hjust=0.5))

		p3 = ggplot(tmp, aes(x=outcome2, y=-100)) + #, color=outcome2)) +
		  geom_text( aes(label=gsub(" ","\n", outcome2)), size=5) +
		  #scale_color_viridis(discrete=TRUE) +
		  coord_flip() +
		  theme_classic() +
		  ylab("Hazard Ratio") +
		  mytheme +
		  theme(
		    axis.ticks.x = element_line(color="white"),
		    axis.title.x = element_text(color="white"),
		    axis.text.x = element_text(color="white"),
		    plot.margin = unit(c(.9 ,.3, .3, .3), "cm")
		  )

		# Arrange and display the plots into a 2x1 grid
		title=textGrob(mydisease,gp=gpar(fontsize=20,font=2))
		grid.arrange( p2, p3, p1, ncol=3 , widths=c(0.41, 0.18,  0.41) , top = title )
		#ggsave(p, file="symBarPaper.eps")

	})






  # ------------------------------------------------------------------------------
  # Line plot time
  # ------------------------------------------------------------------------------

	output$plot_time=renderPlotly({


		# Recover what user choosed.
		mydisease=input$disease_time_plot

		# Recover the model:
		if( input$model_evolution==1 ){
			don = data %>%
		 		filter(substr(model, 1, 15)=="time_after_expo") %>%
		 		mutate(time=as.numeric( gsub("time_after_expo_","", model)))
		}else{
			don = data %>%
		 		filter(substr(model, 1, 15)=="adjusted_time_a") %>%
		 		mutate(time=as.numeric( gsub("adjusted_time_after_expo_","", model)))
		}



		don %>%

		 	# keep the good disease
		 	filter( exposure2 == mydisease ) %>%

		 	# Order levels in alphabetical order
		 	mutate(outcome2 = factor(outcome2, sort(levels(outcome2))))	%>%

			# Prepare text
			mutate( real_label = case_when( time==1 ~ "0-6m", time==2 ~ "6-12m", time==3 ~ "1-2y", time==4 ~ "2-5y", time==5 ~ "5-10y", time==6 ~  "10-15y", time==7 ~  "15+y") ) %>%
			mutate( text=paste("Prior-disorder: ", mydisease, "\n\nLater-disorder: ", outcome2, "\n\n", paste("Time after diagnosis in ",mydisease,": ",sep=""), real_label, "\n\nHazard Ratio: ", round(HR,1), " (", round(CI_left,1), " - ", round(CI_right,1), ")", sep="" )) %>%


		  	# Make the plot
		  	ggplot( aes(x=time, color=outcome2)) +
		    	geom_line( aes(y=HR), col="grey") +
		    	geom_errorbar( aes(ymin=CI_left, ymax=CI_right), width=0.7) +
		    	geom_point( aes(y=HR, text=text), size=3) +
		    	scale_color_manual( values = color_attribution) +
		    	geom_hline(yintercept = 1, color='red', alpha=0.9, linetype="dotted") +
		    	scale_x_continuous( breaks = 1:7, labels=c("0-6m", "6-12m", "1-2y", "2-5y", "5-10y", "10-15y", "15+y")) +
		    	scale_y_log10() +
		    	xlab("") +
		    	facet_wrap(~outcome2) +
		    	theme(
		      		legend.position = "none",
		      		axis.text.x = element_text(angle = 45, hjust=0.8),
		      		strip.background = element_rect(colour = "white", fill = alpha("white",0.2) ),
		      		strip.text.x = element_text(colour = "black", size=13),
		      		plot.margin = unit(c(1,1,1,1), "cm")
		      	)

		ggplotly(tooltip="text")

	})


# Small text output for the X axis because plotly drives me crazy.
output$xlablineplot <- renderText({
	mydisease=input$disease_time_plot
	text=paste("Time since diagnosis in ", mydisease, sep="")
	return(text)
	})



  # ------------------------------------------------------------------------------
  # CIP PLOT .a AND .b
  # ------------------------------------------------------------------------------

	output$plot_CIP_a=renderPlot({

		# Recover what user choosed.
		mydisease=input$disease_CIP_plot

		# Make the plot
		CIP %>%

  			# Keep the chosen data
  			filter(sex==input$sex_absolute_plot & age_group=="all" & exposure2==mydisease) %>%


			# Prepare text
			#mutate(text=paste("Exposure: ", mydisease, "\n\nOutcome: ", outcome2, "\n\nTime after exposure: ", real_label, "\n\nHazard Ratio: ", round(HR,2), sep="" )) %>%

		  	# Make the plot
			ggplot(aes(x=time_since_dx, y=cip, fill=outcome2)) +
  				geom_area() +
		    	scale_fill_manual( values = color_attribution) +
  				facet_wrap( ~ outcome2) +
  				xlab( paste("Time since diagnosis in ", mydisease, " (Years)", sep="") ) +
  				ylab("Cumulative incidence proportion (%)") +
  				ylim(0,40) +
		    	theme(
		      		legend.position = "none",
		      		axis.text = element_text(size=10),
		      		axis.title = element_text(size=14),
		      		strip.background = element_rect(colour = "white", fill = alpha("white",0.2) ),
		      		strip.text.x = element_text(colour = "black", size=17),
		      		panel.spacing = unit(2, "lines")
		      	)
	})




	output$plot_CIP_b=renderPlot({

		# Recover what user choosed.
		mydisease=input$disease_CIP_plot

		# Recover the outcome = where the user click:
		myoutcome = ifelse( is.null(input$plot1_click$panelvar1)  , mylevels[-match(mydisease, mylevels)][4], input$plot1_click$panelvar1)

		# Prepare data subset
		tmp = CIP %>%

  			# Keep the chosen data
  			filter(sex==input$sex_absolute_plot & age_group!="all" & exposure2==mydisease & outcome2==myoutcome) %>%

 			# Create a more readabe column for age range
  			mutate(clean_age_range = paste("age: ",age_group,sep="")) %>% mutate(clean_age_range = gsub("\\[", "from ", clean_age_range)) %>% mutate(clean_age_range = gsub(",", " to ", clean_age_range)) %>% mutate(clean_age_range = gsub(")", "", clean_age_range)) %>%
			mutate(clean_age_range = factor(clean_age_range, levels=c( "age: from 0 to 20", "age: from 20 to 40", "age: from 40 to 60", "age: from 60 to 80", "age: 80+")))

		# plot
		tmp %>% ggplot(aes(x=time_since_dx, y=cip, color=outcome2, fill=outcome2)) +
				geom_ribbon(aes(ymin = cip_low, ymax = cip_high), fill = "grey70", color = "grey70") +
  				geom_line( size=2 ) +
  				facet_wrap( ~ clean_age_range, nrow=1) +
 		    	scale_color_manual( values = color_attribution) +
  				xlab(paste("Time since diagnosis in ", mydisease, " (Years)", sep="") ) +
  				ylab("Cumulative incidence proportion (%)") +
  				ylim(0, 55 ) +
		    	theme(
		      		legend.position = "none",
		      		title = element_text( size=18),
		      		axis.text = element_text(size=10),
		      		axis.title = element_text(size=14),
		      		strip.background = element_rect(colour = "white", fill = alpha("white",0.2) ),
		      		strip.text.x = element_text(colour = "black", size=17),
		      		plot.title = element_text(colour="#2ecc71", size=17, hjust=0.5)
		      	) +
		      	ggtitle(paste( "Prior-disorder: ", mydisease, " | Later-disorder: ", myoutcome, sep=""))

	})









  # ------------------------------------------------------------------------------
  # Scatterplot Sex Comparison
  # ------------------------------------------------------------------------------

	output$plot_sexcomp=renderPlotly({

		# Recover what model user choosed.
		list=c("sex_basic_confounders","sex_kessler_prev","sex_kessler_prev_interactions")
		choice=as.numeric(input$model_sexcomp)
		mymodel=list[choice]


		# prepare data
		tmp=data %>%
		  filter(model==mymodel) %>%
		  select( outcome2, exposure2, sex, HR, CI_left, CI_right) %>%
		  gather(variable, value, -(outcome2:sex)) %>%
		  unite(temp, sex, variable) %>%
		  spread(temp, value) %>%
		  mutate(text=paste("Prior-disorder: ", exposure2, "\n", "Later-disorder: ", outcome2, "\n", "HR for women: ", round(women_HR,1), " (", round(women_CI_left,1), " - ", round(women_CI_right,1), ")", "\n", "HR for men: ", round(men_HR,1) , " (", round(men_CI_left,1), " - ", round(women_CI_right,1), ")", sep="" )) %>%
		  mutate(biggest=as.factor(ifelse(men_HR>women_HR,1,2)))


		# Make the plot
		p=ggplot(tmp) +

		    geom_segment( aes(x=men_HR, xend=men_HR, y=women_CI_left, yend=women_CI_right, color=biggest, text=""), alpha=1, size=0.3) +
		    geom_segment( aes(y=women_HR, yend=women_HR, x=men_CI_left, xend=men_CI_right, color=biggest, text=""), alpha=1, size=0.3) +
		    geom_point(aes(x=men_HR, y=women_HR, text=text, color=biggest)) +
		    scale_colour_manual(values = c("black", "black")) +

		    xlim(0,50) + ylim(0,50) +

		    geom_abline( intercept=0, slope=1, linetype="dotted") +
		    theme(
		    	legend.position="none"
		    ) +
		    labs(x="Hazard Ratios for men", y="Hazard Ratios for women") #+
		    #coord_equal() +
		    annotate("text", x = c(30,40), y = c(50,20), label = c("Women have higher HR", "Men have higher HR") , color=c("#CC99FF", "#6699FF"), size=5 , angle=0, fontface="bold", vjust=c(0,1) )


		# Eventually log scale?
		if( input$log_sexcomp == "log"){ p = p + scale_x_log10() + scale_y_log10() }

		ggplotly(p, tooltip="text")

	})






  # ------------------------------------------------------------------------------
  # RAW DATA
  # ------------------------------------------------------------------------------

		# Show it in a table
		observe({

			# Make the data nicer to see
			don=data %>% mutate(
				exposure=gsub("expo_","",exposure),
				personyears0=round(personyears0,1),
				personyears1=round(personyears1,1),
				HR=round(HR,2),
				CI_left=round(CI_left,2),
				CI_right=round(CI_right,2)
				)
			colnames(don)[1:4]=c("outcome_id", "outcome", "exposure_id", "exposure")

			# render the table
			output$raw_data <- DT::renderDataTable(
					DT::datatable( don , rownames = FALSE , filter = 'top', options = list(pageLength = 10, scrollX = TRUE )  )
			)
		})

		# Allow user to download it
		output$load_ex_format1 <- downloadHandler(
    		filename = "HR_comoproject.csv",
			content <- function(file) {
    			file.copy("DATA/pairwiseHR.txt", file)
  			}
  	)

		# Allow user to download it
		output$load_ex_format2 <- downloadHandler(
    		filename = "CIP_comoproject.csv",
			content <- function(file) {
    			file.copy("DATA/CIP_data.txt", file)
  			}
  	)





# Close the ShinyServer
})
