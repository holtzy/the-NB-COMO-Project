	# ------------------------------------
	#
	#	The COMO project
	#
	# ------------------------------------




shinyUI(fluidPage(


	
	# This is to explain you have a CSS file that custom the appearance of the app
	includeCSS("www/style.css") ,





	# -------------------------------------------------------------------------------------
	# === ROW : title + Main tabs
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
	# === ROW : Grey Parts with the introduction
	fluidRow(align="center", style="opacity:0.9 ;margin-top: 0px; width: 100%;",

		hr(),
		br(), br(),	

		column(6, offset=3, align="center",
				div(img(src="NBP logo.jpg" , height = 250, width = 250) , style="text-align: center;"),
				column(6, offset=0, align="justify",
					h5("As part of the ", a("Niels Bohr Professorship", href="http://econ.au.dk/the-national-centre-for-register-based-research/niels-bohr-professorship/"), "we are exploring patterns of comorbidity (COMO) within treated mental disorders. Over the next few years we will explore different ways describing the complex patterns of comorbidity between mental disorders. In particular, we wish to develop")
				), 
				column(6, offset=0, align="justify",
					h5("interactive data visualizations that will allow the research community greater flexibilitly in exploring the multidimensional nature of the COMO. Firstly, we will explore COMO within the ", a("Danish National Patient Registry", href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4655913/"), "(DNPR), one of the world’s oldest nationwide hospital registries")
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
	# ===  ROW : Time lapse + Circle Packing explaining ICD10 OR table with link ICD10 - ICD8
	fluidRow(align="center",
		
		br(),br(),br(),br(),br(),br(), br(),br(),br(),

		# title
		fluidRow(column(5, offset=1,  align="left", id="definition",
			h2( "1. Key features of the Danish registers"),
			hr()
		)),

		# image
		br(),br(),
		column(8, offset=2, align="justify", 
			h5("Danish health registers provide approved researcher access to anonymized person-level information on access to mental  health care via inpatient, outpatient and emergency settings. Our study is built on a sampling frame that provides an extended period to identify prevalent cases prior to the year 2000. From 2000-2016 we have a period of observation where we are more confident we can identify incident (new) cases."),
			br(),
			h5("As can be seen in the figure below, ICD8 was used from 1969 to 1994, and ICD-1o has been used since 1995. The mental health register was based on inpatient events between 1969 and 1994, after which outpatient and emergency visits were included."),
			br()	
		),
		div(img(src="TimeLine.png" , height = 250, width = 800) , style="text-align: center;"),
		h3(tags$u(tags$b("Figure 1")),": Timeline of the Danish Register"),
		br(), br(),

		# table or bubble
		br(),br(),br(),
		fluidRow(column(8, offset=2, h5("In ICD10 the mental health related disorders are included in the F chapter, with major groups clustered in two digit strata (e.g. F20-F29). In this paper we base our major disorder strata on the conditions outlined in", a("this paper", href="https://www.ncbi.nlm.nih.gov/pubmed/24806211"), "." ))),
		radioGroupButtons( "table_or_bubble",label = NULL, choices=c("Table"=1, "Chart"=2), selected=1 ),
		conditionalPanel("input.table_or_bubble == 2", align="center",
			column(6, offset=3, ggiraphOutput("plot_circlepack", height = "800px", width="800px")),
			column(2, br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(), h3(tags$u(tags$b("Figure 3")),": The relative occurence of each mental disorders. Hover over the bubble to see the number of cases with each disorder"))
		),
		conditionalPanel("input.table_or_bubble == 1", align="center",
			#dataTableOutput('ICD10table' , width="80%") %>% withSpinner( color= "#2ecc71") ,
			h3(tags$u(tags$b("Figure 2")),": The 10 mental diseases studied with their ICD10 and ICD8 codes.")
		)

	),








	# -------------------------------------------------------------------------------------
	# ===  ROW 2: HISTOGRAM DOTPLOT
	br(),br(),br(),br(),

	fluidRow(align="center",
		column(5, offset=1,  align="left", id="globalsection",
			h2("2. Pairwise, temporally-ordered hazard ratios"),
			hr()
	)),

	fluidRow(align="center",
		column(6, offset=3,  align="center",
			br(), br(),
			h5("We calculated the hazard ratio between each pair of diseases. The vast majority of these estimates are over 1, meaning that individuals with a prior mental disorder (which we call an exposure), are more likely to subsequently develop  an additional mental disorder (which we call an outcome)."), 
			br(),
			h5("The plot below shows the distribution of hazard ratios for all COMO pairs. Note that all hazard ratios are greater than 1."),
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
			h2("3. COMO is pervasive"),
			hr()
	)),

	fluidRow(align="center",
		column(6, offset=3,  align="center",
			br(), br(),
			h5("This Sankey diagram shows every possible relationship between pairs of mental illness. Exposure diseases are represented on the left, while outcomes are on the right."),
			br(), 
			h5("You can study the association between each disorder group and all other disorder groups. To see the hazard ratio and 95%CI hover over the connecting threads. While the disorder groups are colour coded, the Sankey diagram will automatically rearrange the order of exposure and outcome disorders in order to minimize cross-overs. If you slide the Hazard Ratio bar, you can see which COMO pairs have the largest effect size. Remember that relative risk is different to absolute risk."),
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
			h2("4. Patterns of effect size between disorder pairs"),
			hr()
	)),

	fluidRow(align="center",
		column(6, offset=3,  align="center",
			br(), br(),
			h5("This heat map shows the pairwise hazard ratios. Darker shades of blue indicate larger hazard ratios (see colour legend on the right). Hover the cells to get the exact value of each pair of disease."),
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
			h5("In these graphs we wish to explore the bidirectional association between disease pairs. The results suggests that most temporally ordered disease pairs have a bidirectional relationship - there is an increased risk of the other disorder regardless of temporal order. However, some disease pairs appear more symmetrical – we call these ‘mirror phenotypes’ – it seems as if the disease pairs co-occur with approximately risk regardless of which disorder comes first."),
			br()
		)
	),

	fluidRow(align="center", radioGroupButtons("disease_symetry_plot", label = NULL, choices=c( "Organic"="Organic disorders", "Substance"="Substance abuse", "Schizophrenia"="Schizophrenia and related", "Mood"="Mood disorders", "Neurotic"="Neurotic disorders", "Eating"="Eating disorders", "Personality"="Personality disorders", "Retardation"="Mental retardation", "Developmental"="Developmental disorders", "Behaviour"="Behavioral disorders" ), direction='horizontal', selected="Mood disorders")),
	br(), br(),
	fluidRow(align="center",
		column(6, offset=3, plotOutput("plot_symbar", height = 700, width="90%")),
		column(2, offset=0, 
			br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(), 
			h3(tags$u(tags$b("Figure 7")),": Description of the symmetry between diseases. On the left, hazard ratio from every diseases to your selection are represented. On the right, the opposite direcion is represented."),
			dropdownButton(circle = TRUE, icon = icon("plus"), width = "300px", tooltip = tooltipOptions(title = "More options available"),
				selectInput(inputId = 'model_symmetry', label = 'Model used to compute HR', choices = c("Model A"="1", "Model B"="2") )
			)
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
			h2("6. Lagged hazard ratios between COMO pairs"),
			hr()
	)),

	fluidRow(align="center",
		column(6, offset=3,  align="center",
			br(), br(),
			h5("Here we wish to explore the lag between disease pairs. For all disease pairs, the greatest hazard ratios occur within the first year after diagnosis, and then fall to a stable risk."),
			br(),
			h5("The high risks within the first few months probably reflects a range of factors, including presentations with more than one disorder, and also diagnostic practices during observation and history taking, a normal process of clinical practice."),
			br()
		)
	),

	fluidRow(align="center",
		br(),
		radioGroupButtons("disease_time_plot", label = NULL, choices=c( "Organic"="Organic disorders", "Substance"="Substance abuse", "Schizophrenia"="Schizophrenia and related", "Mood"="Mood disorders", "Neurotic"="Neurotic disorders", "Eating"="Eating disorders", "Personality"="Personality disorders", "Retardation"="Mental retardation", "Developmental"="Developmental disorders", "Behaviour"="Behavioral disorders"),  direction='horizontal', selected="Mood disorders"),
		plotlyOutput("plot_time", height = "800px", width="70%"),
		br(),
		column(6, offset=3, h3( tags$u(tags$b("Figure 8")),": Evolution of hazard ratios through time. 1-6m: from first to sixth month after exposure, 1-2y: from first to second year after exposure. Choose exposure on top of the figure. Results are displayed outcome per outcome."))
	),
	fluidRow(column(2, offset=5, align="center",	
		dropdownButton(circle = TRUE, icon = icon("plus"), width = "300px", tooltip = tooltipOptions(title = "More options available"),
				selectInput(inputId = 'model_evolution', label = 'Model used to compute HR', choices = c("Model A"="1", "Model B"="2") )
		)
	)),
	br(),br(),br(),br(),









	# -------------------------------------------------------------------------------------
	# ===  ROW : CUMULATIVE INCIDENCE PROPORTION (CIP)
	# -------------------------------------------------------------------------------------

	fluidRow(align="center",
		column(5, offset=1,  align="left", id="CIP",
			h2("7. Absolute risk"),
			hr()
	)),

	fluidRow(align="center",
		column(6, offset=3,  align="center",
			br(), br(),
			h5("The cumulative incidence proportion (CIP) shows the proportion of people who develop an outcome disorder after exposure to a prior mental disorder. A cumulative incidence proportion of 20 per 100 personss at 10 years suggests that approximately one in 5 people who present with an index (exposure) mental disorder will subsequently develop a second (incident) disorder after 10 years of exposure."),
			br()
		)
	),

	fluidRow(align="center",
		br(),
		h6("Choose exposure: "),
		radioGroupButtons( "disease_CIP_plot", label = NULL, choices=c( "Organic"="Organic disorders", "Substance"="Substance abuse", "Schizophrenia"="Schizophrenia and related", "Mood"="Mood disorders", "Neurotic"="Neurotic disorders", "Eating"="Eating disorders", "Personality"="Personality disorders", "Retardation"="Mental retardation", "Developmental"="Developmental disorders", "Behaviour"="Behavioral disorders"), direction='horizontal', selected="Mood disorders"),
		column(6, offset=3, 
			h3( tags$u(tags$b("Figure 9.a")),": Evolution of cumulative incidence proportion (CIP, Y axis) through time (in years after exposure, X axis). Choose exposure on top of the figure. Results are displayed outcome per outcome. You can split this relationship per age range using the 'more' button below.")
		)
	),
	fluidRow(align="center", 
		plotOutput("plot_CIP_a", height = "800px", width="70%", click = "plot1_click")
	),
	fluidRow(column(6, offset=3,
		hr(),
		h5("The next chart allows you to explore a specific interaction by splitting in in several age ranges. Click on the upper chart to choose your outcome disease."),
		hr()
	)),
	fluidRow(align="center",
		plotOutput("plot_CIP_b", height = "300px", width="70%"),
		br(),
		column(6, offset=3, h3( tags$u(tags$b("Figure 9.b")),": Evolution of CIP through time for different age range at exposure. The exposure is chosen using the buttons above. The outcome is chosen clicking on the panel of figure 10.a"))
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
			h3(tags$u(tags$b("Figure 10")),": Comparison of hazard ratios between males and females. Each hazard ratio is represented by a point and its confidence intervals (p=0.95) (horizontal and vertical lines)."),
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
	br(),br(),br(),

	fluidRow(
		column(8, offset=2, align="justify",
			h2("STUDY POPULATION AND ASSESSMENT OF MENTAL ILLNESS"),
			hr(),
			h5("We designed a population-based cohort study including all individuals living in Denmark during the study period (2000-2016) who had been born in Denmark between 1900 and 2015 (N = 5,940,778). Since 1968, the Danish Civil Registration System1,2 includes information on all residents, including sex, date of birth, continuously updated information on vital status, and a unique personal identification number that can be used to link information from various national registries."),
			br(),
			h5("Information on mental diseases was obtained from the Danish Psychiatric Central Research Register, 3 which contains all admissions to psychiatric inpatient facilities since 1969 and, from 1995, also contacts to outpatient psychiatric departments and emergency visits."),
			br(),
			h5("The diagnostic system used was the Danish modification of the International Classification of Diseases, 8th Revision (ICD-8) from 1969 to 1993, and 10th Revision (ICD-10) from 1994 and onward. We classified different mental disorders into 10 main groups (Table 1), based on previous research using Danish registers and validated linkage between ICD-8 and ICD-10 codes.4 From this point onward, we use “main disorder” to describe a group of specific diagnosis. The date of onset for each main disorder was defined as the first day of the first contact (inpatient, outpatient, or emergency visit) for any of the diagnosis of interest"),
			br()
		)
	),	

	fluidRow(
		br(),br(),br(),
		column(8, offset=2, align="justify",
			h2("STUDY DESIGN"),
			hr(),
			h5("For each of the ten main disorders, follow-up started on January 1, 2000 or at the earliest age at which a person might develop the disorder (Table 1), whichever came later. Follow-up was terminated at onset of the disorder, death, emigration from Denmark, or December 31, 2016, whichever came first. Our analyses were based on incident cases diagnosed according to the ICD-10 classification system during the observation period (2000-2016), when inpatient, outpatient and emergency visits information were included in the register."),
			br(),
			h5("Individuals with a diagnosis of the disorder before the observation period were considered prevalent cases and excluded from the analyses. This stringent washout rule meant that individuals included in the analyses could not have previously accessed services for the specific psychiatric condition for a 31-year period from 1969 to 1999. A sensitivity analysis in a previous study estimating incidence rates and lifetime risks for the same mental disorders revealed nearly identical results when extending the washout period to 36 years."),
			br()
		)
	),
	
	fluidRow(
		br(),br(),
		column(8, offset=2, align="justify",
			h2("STATISTICAL ANALYSIS"),
			hr(),
			h5("We examined the association between all pairs of mental disorders taking into consideration the time order, i.e. each pair consisted of a temporally prior disorder (exposure-disorder) and temporally later disorder (outcome-disorder). All disorders were treated as time-varying. When investigating the association between a specific pair, all individuals were free of the outcome-disorder at the beginning of follow-up (prevalent cases were excluded by design) and individuals were either (a) considered exposed to the exposure-disorder if they were diagnosed before start of follow-up, or (b) remained unexposed until the onset of the exposure-disorder (if it happened during the follow-up), moment in which they became exposed."),
			br(),
			h5("In those instances where there were ties, i.e. exposure- and outcome- disorders occurring on the same day, ties were broken by moving a proportion of the exposure-disorder diagnosis to one day earlier, otherwise the outcome-disorder would only count for the unexposed, and the association would be underestimated. The proportion of cases to be moved was obtained by estimating the proportion of cases in which the exposure-disorder occurred before the outcome-disorder among those with both exposure- and outcome-disorders occurring within 5 years."),
			br(),
			h5("We then compared the rate of being diagnosed with the outcome-disorder between exposed and unexposed to the exposure-disorder using hazard ratios, obtained via Cox Proportional Hazards models with age as the underlying time scale. All estimates were adjusted for sex and calendar time (model A); in a second step, the estimates were further adjusted for psychiatric comorbidity with onset prior to exposure, but not with onset after exposure, as it might be an intermediate factor (model B). Psychiatric comorbidity consisted on all other disorders except the specific exposure- and outcome-disorders and the total number of other disorders (2, 3 or 4+)."),
			br(),
			h5("We further adjusted for the interaction between each type and each number of co-occurring disorders, but results were substantially the same as in model B. Additionally, we performed stratified sex-specific analyses to examine if there were differences between men and women. A hazard ratio of 5 obtained with model B, for example, can be interpreted as the rate of outcome-disorder among individuals diagnosed with exposure-disorder being 5 times higher compared with individuals of the same sex, age and birth date, with the same comorbidities, but not diagnosed with exposure-disorder. When the rates among the exposed and unexposed are not proportional over time, the Cox Proportional Hazards model estimates can be interpreted as an average hazard ratio over the entire follow-up period.5 However, we further investigated if the association differed depending on the time since onset of the exposure-disorder. Finally, we estimated the cumulative incidence proportion of being diagnosed with an outcome-disorder after being diagnosed with an exposure-disorder. Cumulative incidences can be interpreted as the percentage of individuals diagnosed with exposure-disorder who develop the outcome-disorder after a specific time, and they were estimated using competing risks survival analyses to account for the fact that persons are simultaneously at risk of developing the disorder, dying or emigrating."),
			br(),
			h5("All analyses were performed in the secured platform of Statistic Denmark using R version 3.2.2 and STATA/MP version 13.1 (Stata Corporation, College Station, Texas, USA). The data displayed in this application are available in the table below and a .csv version is available using the download button."),
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

	fluidRow( align="left",
			column(6, offset=3, 
				h2("Core team"),
				hr(),
				tags$ul(
   					tags$li(h5(a("Oleguer Plana Ripoll",href="http://pure.au.dk/portal/en/persons/id(bdf4b27a-e767-49e7-9c8f-3314033a15b2).html"))), 
   					tags$li(h5(a("Yan Holtz",href="https://holtzyan.wordpress.com"))), 
   					tags$li(h5(a("John McGrath",href="http://researchers.uq.edu.au/researcher/6724")))
				)
			)
		),
	br(),br(),br(),br(),


	fluidRow( align="left",
			column(6, offset=3, 
				h2("NCRR team"),
				hr(),
				tags$ul(
   					tags$li(h5(a("Carsten Bøcker Pedersen",href="http://pure.au.dk/portal/en/persons/id(2d0e5aa0-9f34-4a6e-9adc-317eb444e801).html"))), 
   					tags$li(h5(a("Esben Agerbo",href="http://pure.au.dk/portal/en/persons/id(5b08ed69-ad64-469f-a5b3-3407bf3c4b04).html"))), 
   					tags$li(h5(a("Thomas Munk Laursen",href="http://pure.au.dk/portal/en/persons/id(366752b6-7172-46ab-9feb-f8f7eadce49f).html"))), 
   					tags$li(h5(a("Preben Bo Mortensen",href="http://pure.au.dk/portal/en/persons/id(59099748-c5c8-4c1c-8bcb-023f8c51a090).html")))
				)
			)
		),
	br(),br(),br(),br(),


	fluidRow(
		column(6, offset=3, align="center",
			h2("Acknolwedgement", align="left"),
			hr(),
			br(),
			div(img(src="aarhus_university_logo.png")),
			br(),br(),
			div(img(src="UQlogo.png", width="40%", height="40%")),
			br(),br(),
			div(img(src="NBP logo.jpg", width="40%", height="40%")),
			br(),br(),
			div(img(src="DNRF.png", width="50%", height="50%"))
		)
	)

),











	# -------------------------------------------------------------------------------------
	# === 9/ Footer
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
