	# ------------------------------------
	#
	#	The COMO project
	#
	# ------------------------------------


shinyUI(fluidPage(
        
	
	# This is to explain you have a CSS file that custom the appearance of the app
	includeCSS("www/style.css") ,




	# -------------------------------------------------------------------------------------
	# === ROW 1 : title + Main tabs
	fluidRow(
		style="opacity:0.9; background-color: white ;margin-top: 10px; width: 100%;",

		column(4, offset=4, align="center",
			br(),
			helpText(
				"The", style="color:black ; font-family: 'times'; font-size:30pt",
				strong("NB-COMO", style="color:black; font-size:40pt"),
				"project", style="color:black ; font-family: 'times'; font-size:30pt"
			)
			#helpText( align="right",
			#	em("A project by", style="color:grey ; font-family: 'times'; font-size:15pt ; font-type:italic"),
			#	em(a("Oleguer Plana Ripoll", style="color:grey ; font-family: 'times'; font-size:15pt ; font-type:italic", href="https://twitter.com/oleguerplana?lang=fr")),
			#	em(a(" & ", style="color:grey ; font-family: 'times'; font-size:15pt ; font-type:italic")),				
			#	em(a("John McGrath", style="color:grey ; font-family: 'times'; font-size:15pt ; font-type:italic", href="https://twitter.com/John_J_McGrath?lang=fr"))				
			#)
		),
		column(4, align="right",
			br(),
			tags$div(style="backgroundcolor:black;", class = "tab_header", radioGroupButtons( "plot_type",label = NULL, choices=c("Results"=1, "Methodology"=2, "Meet the team"=3), selected=1 ))
			)
		),
 	# -------------------------------------------------------------------------------------



	# -------------------------------------------------------------------------------------
	# === ROW 2 : Grey Parts with the introduction
	fluidRow(align="center", style="opacity:0.9 ;margin-top: 0px; width: 100%;",

		hr(),
		br(), br(),	

		column(6, offset=3, align="center",
				div(img(src="NBP logo.jpg" , height = 250, width = 250) , style="text-align: center;"),
				column(6, offset=0, align="justify",
					h5("As part of the ", a("Niels Bohr Professorship", href="http://econ.au.dk/the-national-centre-for-register-based-research/niels-bohr-professorship/"), "we are exploring the patterns of comorbidity within treated mental disorders. Over the next few years we will explore different ways to capture the complex patterns of comorbidity between mental disorders. In particular, we wish to develop")
				), 
				column(6, offset=0, align="justify",
					h5("interactive data visualizations that allow the research community greater flexibilitly in exploring the multidimensional nature of the COMO. Firstly, we will explore COMO within the ", a("Danish National Patient Registry", href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4655913/"), "(DNPR), one of the world’s oldest nationwide hospital registries")
				),
				hr()
		),
	br()
	),
 	# -------------------------------------------------------------------------------------




# #########
#	TAB 1
# #########
conditionalPanel("input.plot_type == 1",






	# -------------------------------------------------------------------------------------
	# ===  ROW 1 : Circle Packing explaining ICD10 OR table with link ICD10 - ICD8
	fluidRow(align="center",
		
		br(), br(),br(),br(),br(),br(), br(),br(),br(),

		# title
		fluidRow(column(5, offset=1,  align="left", id="definition",
			h2( "1. Key features of the Danish registers"),
			hr()
		)),

		# image
		br(),br(), br(),
		h5("The Danish register is a study that took place between 1969 and 2016. Here is a brief desctiption of its timeline: "),
		br(),
		div(img(src="TimeLine.png" , height = 250, width = 800) , style="text-align: center;"),
		br(),
		h3(tags$u(tags$b("Figure 1")),": Timeline of the Danish Register"),
		br(), br(),

		# table or bubble
		br(),br(),br(),
		h5("During this period of time we studied mental disorders that are split in 10 main categories:"),
		radioGroupButtons( "table_or_bubble",label = NULL, choices=c("Table"=1, "Chart"=2), selected=1 ),
		conditionalPanel("input.table_or_bubble == 2", align="center",
			column(6, offset=3, ggiraphOutput("plot_circlepack", height = "800px", width="800px")),
			column(2, br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(), h3(tags$u(tags$b("Figure 3")),": The relative occurence of each mental disorders. Hover the bubble to get the exact numbers."))
		),
		conditionalPanel("input.table_or_bubble == 1", align="center",
			dataTableOutput('ICD10table' , width="80%"),
			h3(tags$u(tags$b("Figure 2")),": The 10 mental diseases studied with their ICD10 and ICD8 codes.")
		)

	),








	# -------------------------------------------------------------------------------------
	# ===  ROW 2: HISTOGRAM DOTPLOT
	br(),br(),br(),br(),

	fluidRow(align="center",
		column(5, offset=1,  align="left", id="globalsection",
			h2("2. Sick people are more likely to develop other mental illness"),
			hr()
	)),

	fluidRow(align="center",
		column(6, offset=3,  align="center",
			br(), br(),
			h5("We calculated the hazard ratio between each pair of diseases. The vast majority of them is over 1, meaning that people with a mental disease are more likely to develop another one."),
			br()
		)
	),

	fluidRow(align="center",
		br(),
		radioGroupButtons("sex_longbar", label = NULL, choices=c("Women"="women", "Men"="men", "All"="all"), selected="all"),
		column(6, offset=3, plotlyOutput("plot_longbar", height = "500px", width="900") ),
		column(2, br(), br(), 
			h3(tags$u(tags$b("Figure 4")),": Distribution of Hazard Ratios. Each dot represents a pair of disease."),
			dropdownButton(circle = TRUE, icon = icon("plus"), width = "300px", tooltip = tooltipOptions(title = "More options available"),
				selectInput(inputId = "log_dotplothisto",   label = "Kind of scale:", choices=c("Log Scale"="log", "Linear Scale"="normal"), selected="normal"),
				selectInput(inputId = 'model_dotplothisto', label = 'Model used to compute HR', choices = c("Model A"="1", "Model B"="2") )
			)

		)
	),
	br(),br(),br(),br(),	







	# -------------------------------------------------------------------------------------
	# ===  ROW 3 : SANKEY DIAGRAM
	fluidRow(align="center",
		column(5, offset=1,  align="left", id="globalsection",
			h2("3. An overview of all relationships"),
			hr()
	)),

	fluidRow(align="center",
		column(6, offset=3,  align="center",
			br(), br(),
			h5("This Sankey diagram shows every possible relationship between pairs of mental illness. Exposure diseases are represented on the left, while outcomes are on the right."),
			br(), 
			h5("You can study interaction in the other side by highlighting the outcome disease (on the right).  You can explore patterns for men or women, and use the slider bar to explore all Hazard Ratios, or only those above a certain effect size."),
			br()
		)
	),

	fluidRow(
		column(6, offset=3,  align="center",
			fluidRow(
				column(6, h6(align="left", "exposure")),
				column(6, h6(align="right", "outcome"))
			),
			sankeyNetworkOutput("plot_sankey", height = "800px", width="100%"), 
			h3(tags$u(tags$b("Figure 5")),": Sankey diagram showing the general flows between disease."),
			dropdownButton(circle = TRUE, icon = icon("plus"), width = "300px", tooltip = tooltipOptions(title = "More options available"),
					selectInput(inputId = 'model_sankey', label = 'Model used to compute HR', choices = c("Model A"="1", "Model B"="2") )
			),
			br(),
			radioGroupButtons("sex_sankey", label = NULL, choices=c("Women"="women", "Men"="men", "All"="all"), selected="all"),
			sliderInput("sankey_thres", "", min=1, max=30, value=1, ticks=F),
			h3("Use this slider to display Hazard Ratio over a certain value")				
		)
	),
	br(),br(),







	# -------------------------------------------------------------------------------------
	# ===  HEATMAP
	fluidRow(align="center",
		column(5, offset=1,  align="left", id="globalsection",
			h2("4. Similarities between pairs of disorders"),
			hr()
	)),

	fluidRow(align="center",
		column(6, offset=3,  align="center",
			br(), br(),
			h5("This heat map shows the pairwise hazard ratios. Hot colours denotes high hazard ratios, and cold colors low hazard ratios. Hover the cells to get the exact value of each pair of disease."),
			br()
		)
	),

	fluidRow(
		column(8, offset=1,  align="center",
			plotlyOutput("plot_heat2", height=900, width=1000), 
			br()
		),
		column(2, 
			br(), br(),br(), br(), br(), br(),br(), br(), br(), br(),br(), br(), 
			h3(tags$u(tags$b("Figure 6")),": Heatmap displaying every hazard ratios (HR). Exposure diseases are located on the bottom, outcome diseases on the left."),
			br(),
			radioGroupButtons("sex_heatmap", label = NULL, choices=c("Men"="men", "Women"="women", "All"="all"), direction='horizontal', selected="all"),
			dropdownButton(circle = TRUE, icon = icon("plus"), width = "300px", tooltip = tooltipOptions(title = "More options available"),
					selectInput(inputId = "log_heatmap",   label = "Kind of scale:", choices=c("Log Scale"="log", "Linear Scale"="normal"), selected="normal"),
					selectInput(inputId = 'model_heatmap', label = 'Model used to compute HR', choices = c("Model A"="1", "Model B"="2") )
			)
		)
	),

	br(), br(),









	# -------------------------------------------------------------------------------------
	# ===  ROW 4 : SYMETRY BETWEEN DISEASE
	fluidRow(align="center",
		column(8, offset=1,  align="left", id="globalsection",
			h2("5. The bidirectional association between disease pairs – symmetrical and asymmetrical patterns"),
			hr()
	)),

	fluidRow(align="center",
		column(6, offset=3,  align="center",
			br(), br(),
			h5("In these graphs we wish to explore the bidirectional association between disease pairs. The results suggests that most temporally ordered disease pairs have significant hazard ratios, but some disease pairs appear more symmetrical – we call these ‘mirror phenotypes’ – it seems as if the disease pairs co-occur with approximately risk regardless of which disorder comes first."),
			br()
		)
	),

	fluidRow(align="center", radioGroupButtons("disease_symetry_plot", label = NULL, choices=c( "Organic"="Organic disorders", "Substance"="Substance abuse", "Schizophrenia"="Schizophrenia and related", "Mood"="Mood disorders", "Neurotic"="Neurotic disorders", "Eating"="Eating disorders", "Personality"="Personality disorders", "Retardation"="Mental retardation", "Developmental"="Developmental disorders", "Behaviour"="Behavioral disorders" ), direction='horizontal', selected="Mood disorders")),
	fluidRow(align="center", radioGroupButtons("type_symetry_plot", label = NULL, choices=c( "Chart 1"=1, "Chart 2"=2), direction='horizontal', selected=1)),
	br(), br(),
	conditionalPanel("input.type_symetry_plot == 2",
		fluidRow(align="center",
			column(6, offset=3, plotlyOutput("plot_bar", height = 700, width="90%")),
			column(2, offset=0, br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(), h3(tags$u(tags$b("Figure 8")),": Description of the symmetry between diseases. Each line represents à pair of disease. The 2 hazard ratios are represented in green and orange."))
		)
	),
	conditionalPanel("input.type_symetry_plot == 1",
		fluidRow(align="center",
			column(6, offset=3, plotOutput("plot_symbar", height = 700, width="90%")),
			column(2, offset=0, br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(), h3(tags$u(tags$b("Figure 7")),": Description of the symmetry between diseases. On the left, hazard ratio from every diseases to your selection are represented. On the right, the opposite direcion is represented."))
		)
	),
	br(),
	fluidRow(align="center", radioGroupButtons("sex_symetry_plot", label = NULL, choices=c("Men"="men", "Women"="women", "All"="all" ), direction='horizontal', selected="all")),
	br(),br(),br(),br(),







	# -------------------------------------------------------------------------------------
	# ===  ROW 5 : EVOLUTION OF COMORBIDITY
	# -------------------------------------------------------------------------------------
	fluidRow(align="center",
		column(5, offset=1,  align="left", id="globalsection",
			h2("6. Temporal components of COMO"),
			hr()
	)),

	fluidRow(align="center",
		column(6, offset=3,  align="center",
			br(), br(),
			h5("Here we wish to explore the lag between disease pairs. For all disease pairs, the greatest hazard ratios occur within the first year after diagnosis, and then fall to a stable risk."),
			br(),
			h5("The high risks within the first few months probably reflect diagnostic practices during observation and history taking, a normal process of clinical practice."),
			br()
		)
	),

	fluidRow(align="center",
		br(),
		radioGroupButtons("disease_time_plot", label = NULL, choices=c( "Organic"="Organic disorders", "Substance"="Substance abuse", "Schizophrenia"="Schizophrenia and related", "Mood"="Mood disorders", "Neurotic"="Neurotic disorders", "Eating"="Eating disorders", "Personality"="Personality disorders", "Retardation"="Mental retardation", "Developmental"="Developmental disorders", "Behaviour"="Behavioral disorders"),  direction='horizontal', selected="Mood disorders"),
		plotlyOutput("plot_time", height = "800px", width="70%"),
		br(),
		column(6, offset=3, h3( tags$u(tags$b("Figure 9")),": Evolution of hazard ratios through time. 1-6m: from first to sixth month after exposure, 1-2y: from first to second year after exposure. Choose exposure on top of the figure. Results are displayed outcome per outcome."))
	),
	br(),br(),br(),br(),









	# -------------------------------------------------------------------------------------
	# ===  ROW : CUMULATIVE INCIDENCE PROPORTION (CIP)
	# -------------------------------------------------------------------------------------

	fluidRow(align="center",
		column(5, offset=1,  align="left", id="CIP",
			h2("7. Cumulative Incidence Proportion"),
			hr()
	)),

	fluidRow(align="center",
		column(6, offset=3,  align="center",
			br(), br(),
			h5("The cumulative incidence proportion (CIP) calculates the proportion of people carrying a mental disorder following a given exposure. Here we propose to study this CIP in function of the time after exposure."),
			br()
		)
	),

	fluidRow(align="center",
		br(),
		h6("Choose exposure: "),
		radioGroupButtons( "disease_CIP_plot", label = NULL, choices=c( "Organic"="Organic disorders", "Substance"="Substance abuse", "Schizophrenia"="Schizophrenia and related", "Mood"="Mood disorders", "Neurotic"="Neurotic disorders", "Eating"="Eating disorders", "Personality"="Personality disorders", "Retardation"="Mental retardation", "Developmental"="Developmental disorders", "Behaviour"="Behavioral disorders"), direction='horizontal', selected="Mood disorders"),
		plotOutput("plot_CIP_a", height = "800px", width="70%", click = "plot1_click"),
		column(6, offset=3, 
			h3( tags$u(tags$b("Figure 10.a")),": Evolution of cumulative incidence proportion (CIP, Y axis) through time (in years after exposure, X axis). Choose exposure on top of the figure. Results are displayed outcome per outcome. You can split this relationship per age range using the 'more' button below."),
			hr()
		)
	),
	fluidRow(align="center",
		conditionalPanel("input.more_or_less == 1",
			plotOutput("plot_CIP_b", height = "300px", width="70%"),
			br(),
			column(6, offset=3, h3( tags$u(tags$b("Figure 10.b")),": Evolution of CIP through time for different age range at exposure. The exposure is chosen using the buttons above. The outcome is chosen clicking on the panel of figure 10.a"))
		)
	),
	fluidRow(	 align="center",
			radioGroupButtons( "more_or_less", label = NULL, choices=c( "More"=1, "Less"=2 ), direction='horizontal', selected=2)
	),

	br(),br(),br(),br(),











	# -------------------------------------------------------------------------------------
	# ===  ROW 6 : About Male and Female
	fluidRow(align="center",
		column(5, offset=1,  align="left", id="globalsection",
			h2("7. Differences between Male and Female"),
			hr()
	)),

	fluidRow(align="center",
		column(6, offset=3,  align="center",
			br(), br(),
			h5("The patterns of mental disorder differ between men and women, thus we expect that the pattern of COMO will also differ between by sex. Here we show a scatterplot between all disease pairs, for males (on the X axis) and females (on the Y axis). Note the confidence intervals can vary between the sexes as a consequence of sex-related differences in the prevalence of one or both of the disorders within the disorder pairs."),
			br()
		)
	),

	fluidRow(align="center",
		column(6, offset=3,  align="center",
			br(), br(), br(),br(),
			plotlyOutput("plot_sexcomp", height = "700", width="90%"),
			br()
		),
		column(3, align="left", 
			br(),br(),br(),br(),br(),br(),br(),br(),br(),
			h3(tags$u(tags$b("Figure 11")),": Comparison of hazard ratios between males and females. Each hazard ratio is represented by a point and its confidence intervals (p=0.95) (horizontal and vertical lines)."),
			dropdownButton(circle = TRUE, icon = icon("plus"), width = "300px", tooltip = tooltipOptions(title = "More options available"),
				selectInput(inputId = "log_sexcomp",   label = "Kind of scale:", choices=c("Log Scale"="log", "Linear Scale"="normal"), selected="normal"),
				selectInput(inputId = 'model_sexcomp', label = 'Model used to compute HR', choices = c("Model A"="1", "Model B"="2") )
			)
		),
		br()
	)

),









# #########
#	TAB 2 (METHODS)
# #########
conditionalPanel("input.plot_type == 2",
	br(),

	fluidRow(
		column(8, offset=2, align="center",
			h2("Material"),
			hr(),
			"All the data computed in our study are available in the table hereafter.",
			br(),
			"Moreover, the scripts allowing to build this website are available on Github."
		)
	),	

	fluidRow(
		br(),br(),
		column(8, offset=2, align="center",
			h2("Method"),
			hr(),
			"All the data computed in our study are available in the table hereafter.",
			br(),
			"Moreover, the scripts allowing to build this website are available on Github."
		)
	),
	
	fluidRow(
		br(),br(),
		column(10, offset=1, align="center",
			h2("Raw data"),
			hr(),
			"All the data computed in our study are available in the table hereafter.",
			br(),
			"Moreover, the scripts allowing to build this website are available on Github.",
			br(),
			"Last but not least, our paper in online",
			br(),br(),
			downloadButton("load_ex_format1", label = "Download"),
			actionButton(inputId='ab1', label="Github", icon = icon("github"), onclick ="location.href='https://github.com/holtzy/the-NB-COMO-Project';"), 
			actionButton(inputId='ab1', label="Paper", icon = icon("file-o"), onclick ="location.href='https://www.ncbi.nlm.nih.gov/pubmed/';"), 
			br(),br()
		)
	),
	br(),
	fluidRow(align="center", 
		column(2, offset=1, dataTableOutput('raw_data' , width="200px")) 
	)
),














# #########
#	TAB 3
# #########
conditionalPanel("input.plot_type == 3",

	br(),br(),

	fluidRow( align="center",
			column(6, offset=3, 
				h2("why this application"),
				hr(),
				br(),br(),
				h5("This application has been developped to acompany our research paper. It aims to make our result more accessible"),
				br(),
				h5("and understandable by all."),
				br(),
				h5("Feel free to contact us at : xxx@gmail.com")
			)
		),

	br(),br(),br(),br(),
	fluidRow(
		column(6, offset=3, align="center",
			h2("Who are we"),
			hr()
		),
		column(8, offset=3, align="center",
			fluidRow( style="text-align: center;",
				column(3, img(src="John_pic.jpg" , height = 300, width = 300) ), 
				column(3, img(src="Oleguer_pic.jpg" , height = 300, width = 250) ), 
				column(3, img(src="Yan_pic.jpg" , height = 300, width = 300) )
			),
			fluidRow( style="text-align: center;",
				column(3, h5("John McGrath is a psychiatrist interested in discovering the causes of serious mental disorders. He is the Director of the ",a("Queensland Centre for Mental Health Research", href="http://qcmhr.uq.edu.au"), "and conjoint Professor at the ",a("Queensland Brain Institute", href="https://qbi.uq.edu.au")) ),
				column(3, h5("Oleguer Plana Ripoll is a Postdoc at the ",a("Department of Economics and Business Economics",href="http://econ.au.dk"), "- National Centre for Register-based Research. He is the first author of this study.") ),
				column(3, h5("Yan Holtz is a data analyst working for the", a("Queensland Centre for Mental Health Research", href="http://qcmhr.uq.edu.au"), ". He created this webpage.") )
			),
			fluidRow( style="text-align: center;",
				column(3, actionButton(inputId='ab1', label="Home page", icon = icon("home"), onclick ="location.href='http://researchers.uq.edu.au/researcher/6724';") ),
				column(3, actionButton(inputId='ab1', label="Home page", icon = icon("github"), onclick ="location.href='http://pure.au.dk/portal/en/persons/id(bdf4b27a-e767-49e7-9c8f-3314033a15b2).html';") ),
				column(3, actionButton(inputId='ab1', label="Home page", icon = icon("github"), onclick ="location.href='https://holtzyan.wordpress.com';") )
			)
		)
	),

	br(),br(),br(),br(),br(),br(),
	fluidRow(
		column(8, offset=2, align="center",
			h2("Acknolwedgement"),
			hr(),
			br(),
			column(4, br(),br(),br(),br(), div(img(src="aarhus_university_logo.png" , height = 150, width = 440) , style="text-align: right;")),
			column(4, div(img(src="NBP logo.jpg" , height = 400, width = 440) , style="text-align: center;")),
			column(4, style="text-align: left;",
				div(img(src="QBI_logo.jpg" , height = 250, width = 600) , style="text-align: center;"),	
				br(),
				div(img(src="IMB_logo.png" , height = 150, width = 350) , style="text-align: center;")
			)
			

		)
	)

),











	# -------------------------------------------------------------------------------------
	# === 9/ Add logo of organizations, link toward authors...
	fluidRow( align="center" ,
		br(), br(),
		column(4, offset=4,
			hr(),
			br(), br(),
			"Created by", strong(a("Yan Holtz", style="color:lightblue", href="https://holtzyan.wordpress.com")), ".",
			br(),
			"Source code available on", strong(a("Github", style="color:lightblue", href="https://github.com/holtzy/the-NB-COMO-Project")), ".",
			br(),
			"Copyright © 2017 The COMO Project",
			br(), br(),br()
			
		),
		br(),br()
	)

	
	# -------------------------------------------------------------------------------------







# Close the ui
))
