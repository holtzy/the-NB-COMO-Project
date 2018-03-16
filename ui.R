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
		),
		column(4, align="right",
			br(),
			tags$div(style="backgroundcolor:black;", class = "tab_header", radioGroupButtons( "plot_type",label = NULL, choices=c("Methodology"=2, "Results"=1, "Meet the team"=3), selected=2 ))
			)
		),
		column(8, offset=2, hr()),
		br(), br(),	
 	# -------------------------------------------------------------------------------------







# #########
#	TAB  RESULT
# #########
conditionalPanel("input.plot_type == 1",




	# -------------------------------------------------------------------------------------
	# ===  ROW: HISTOGRAM DOTPLOT
	br(),br(),br(),br(),

	fluidRow(align="center",
		column(5, offset=1,  align="left", id="globalsection",
			h2("1. Pairwise, temporally-ordered hazard ratios"),
			hr()
	)),

	fluidRow(align="center",
		column(6, offset=3,  align="center",
			br(), br(),
			h5("We calculated hazard ratios between each pair of Disorder Groups. The vast majority of these disorder estimates are over 1, meaning that individuals with a prior mental disorder (prior-disorder), are at greater risk in developing subsequent mental disorder (later-disorder)."), 
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
			h3(tags$u(tags$b("Figure 5")),": Distribution of Hazard Ratios. Each dot represents a pair of disorder."),
			dropdownButton(circle = TRUE, icon = icon("plus"), width = "300px", tooltip = tooltipOptions(title = "More options available"),
				selectInput(inputId = "log_dotplothisto",   label = "Kind of scale:", choices=c("Log Scale"="log", "Linear Scale"="normal"), selected="normal"),
				selectInput(inputId = 'model_dotplothisto', label = 'Model used to compute HR', choices = c("Model A: adjusting for age, sex and calendar time"="1", "Model B: further adjusting for other mental disorders"="2") )
			)

		)
	),
	br(),br(),br(),br(),	







	# -------------------------------------------------------------------------------------
	# ===  ROW 3 : SANKEY DIAGRAM
	fluidRow(align="center",
		column(5, offset=1,  align="left", id="globalsection",
			h2("2. COMO is pervasive"),
			hr()
	)),

	fluidRow(align="center",
		column(6, offset=3,  align="center",
			br(), br(),
			h5("This Sankey diagram shows all possible permutations of relationship between pairs of mental Disorder Groups. Prior-disorders are represented on the left, while later-disorders are on the right."),
			br(), 
			h5("You can study the association between each prior-disorder group and later-disorder group. To see the hazard ratios hover your mouse over the connecting threads. The Disorder Groups are colour coded. The Sankey diagram will automatically rearrange the order of prior-disorder and later-disorders to minimize cross-overs. Move the slider below figure 6 to examine COMO pairs with varying effect sizes. Note that relative risk is different to absolute risk."),
			br()
		)
	),

	fluidRow(
		column(6, offset=3,  align="center",
			fluidRow(
				column(6, h6(align="left", "prior-disorders")),
				column(6, h6(align="right", "later-disorders"))
			),
			sankeyNetworkOutput("plot_sankey", height = "800px", width="100%"), 
			h3(tags$u(tags$b("Figure 6")),": Sankey diagram showing the general flows between Disorder Groups.")
	)),

	fluidRow(
		column(4, offset=4,	align="center",		
			dropdownButton(circle = TRUE, icon = icon("plus"), width = "300px", tooltip = tooltipOptions(title = "More options available"),
					selectInput(inputId = 'model_sankey', label = 'Model used to compute HR', choices = c("Model A: adjusting for age, sex and calendar time"="1", "Model B: further adjusting for other mental disorders"="2") )
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
			h2("3. Pattern of effect sizes between Disorder Group pairs"),
			hr()
	)),

	fluidRow(align="center",
		column(6, offset=3,  align="center",
			br(), br(),
			h5("This heat map shows the pairwise hazard ratios. Darker shades of blue indicate larger hazard ratios (see colour legend on the right). Hover your mouse hover the cells to get the exact hazard ratio for each pair of Disorder Group."),
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
			h3(tags$u(tags$b("Figure 7")),": Heatmap displaying hazard ratios (HR) between disorder pairs. Prior-disorders are located at the bottom, later-disorders on the left."),
			br(),
			radioGroupButtons("sex_heatmap", label = NULL, choices=c("Men"="men", "Women"="women", "All"="all"), direction='horizontal', selected="all"),
			dropdownButton(circle = TRUE, icon = icon("plus"), width = "300px", tooltip = tooltipOptions(title = "More options available"),
					selectInput(inputId = "log_heatmap",   label = "Kind of scale:", choices=c("Log Scale"="log", "Linear Scale"="normal"), selected="normal"),
					selectInput(inputId = 'model_heatmap', label = 'Model used to compute HR', choices = c("Model A: adjusting for age, sex and calendar time"="1", "Model B: further adjusting for other mental disorders"="2") )
			)
		)
	),

	br(), br(),









	# -------------------------------------------------------------------------------------
	# ===  ROW 4 : SYMETRY BETWEEN disorder
	fluidRow(align="center",
		column(8, offset=1,  align="left", id="globalsection",
			h2("4. The bidirectional association between Disorder Group pairs – symmetrical and asymmetrical patterns"),
			hr()
	)),

	fluidRow(align="center",
		column(6, offset=3,  align="center",
			br(), br(),
			h5("In these graphs we wish to explore the bidirectional association between Disorder Group pairs. The results suggests that most temporally ordered disorder pairs have a bidirectional relationship - there is an increased risk of disorder regardless of temporal order. However, some disorder pairs appeared to be quite symmetrical – we call these ‘mirror phenotypes’ – where it seems the risk of developing either disorder are similar regardless of which disorder comes first."),
			br()
		)
	),

	fluidRow(align="center", radioGroupButtons("disease_symetry_plot", label = NULL, choices=c( "Organic"="Organic disorders", "Substance"="Substance abuse", "Schizophrenia"="Schizophrenia and related", "Mood"="Mood disorders", "Neurotic"="Neurotic disorders", "Eating"="Eating disorders", "Personality"="Personality disorders", "Retardation"="Mental retardation", "Developmental"="Developmental disorders", "Behaviour"="Behavioral disorders" ), direction='horizontal', selected="Mood disorders")),
	br(), br(),
	fluidRow(align="center",
		column(6, offset=3, plotOutput("plot_symbar", height = 700, width="90%")),
		column(2, offset=0, 
			br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(), 
			h3(tags$u(tags$b("Figure 8")),": Description of the symmetry between Disorder Groups. Hazard ratio between all possible disorders and your selected disorder are represented on the left panel and vice-versa."),
			dropdownButton(circle = TRUE, icon = icon("plus"), width = "300px", tooltip = tooltipOptions(title = "More options available"),
				selectInput(inputId = 'model_symmetry', label = 'Model used to compute HR', choices = c("Model A: adjusting for age, sex and calendar time"="1", "Model B: further adjusting for other mental disorders"="2") )
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
			h2("5. Lagged hazard ratios between COMO pairs"),
			hr()
	)),

	fluidRow(align="center",
		column(6, offset=3,  align="center",
			br(), br(),
			h5("Here we wish to explore the lagged associations between disorder pairs. For all disorder pairs, risk is very high within the first year after diagnosis, and then decline gradually over time."),
			br(),
			h5("The high risks within the first few months could reflect a range of factors, including individuals being diagnosed with more than one disorder in a single clinical setting, and diagnostic practices during observation and history taking."),
			br()
		)
	),

	fluidRow(align="center",
		br(),
		radioGroupButtons("disease_time_plot", label = NULL, choices=c( "Organic"="Organic disorders", "Substance"="Substance abuse", "Schizophrenia"="Schizophrenia and related", "Mood"="Mood disorders", "Neurotic"="Neurotic disorders", "Eating"="Eating disorders", "Personality"="Personality disorders", "Retardation"="Mental retardation", "Developmental"="Developmental disorders", "Behaviour"="Behavioral disorders"),  direction='horizontal', selected="Mood disorders"),
		plotlyOutput("plot_time", height = "800px", width="70%"),
		br(),
		column(6, offset=3, h3( tags$u(tags$b("Figure 9")),": Evolution of hazard ratios over time. 0-6m: first sixth months after exposure, 1-2y: from first to second year after exposure. Choose exposure on top of the figure. Results are displayed outcome per outcome."))
	),
	fluidRow(column(2, offset=5, align="center",	
		dropdownButton(circle = TRUE, icon = icon("plus"), width = "300px", tooltip = tooltipOptions(title = "More options available"),
				selectInput(inputId = 'model_evolution', label = 'Model used to compute HR', choices = c("Model A: adjusting for age, sex and calendar time"="1", "Model B: further adjusting for other mental disorders"="2") )
		)
	)),
	br(),br(),br(),br(),









	# -------------------------------------------------------------------------------------
	# ===  ROW : CUMULATIVE INCIDENCE PROPORTION (CIP)
	# -------------------------------------------------------------------------------------

	fluidRow(align="center",
		column(6, offset=1,  align="left", id="CIP",
			h2("6. Absolute risk"),
			hr()
	)),

	fluidRow(align="center",
		column(6, offset=3,  align="center",
			br(), br(),
			h5("The cumulative incidence proportion (CIP) shows the proportion of individuals who developed an outcome disorder after exposure to a prior mental disorder. A cumulative incidence proportion of 20 per 100 persons at 10 years suggests that approximately one in 5 people with an exposure disorder will subsequently develop a different (incident) disorder after 10 years of exposure."),
			br()
		)
	),

	fluidRow(align="center",
		br(),
		h6("Choose exposure: "),
		radioGroupButtons( "disease_CIP_plot", label = NULL, choices=c( "Organic"="Organic disorders", "Substance"="Substance abuse", "Schizophrenia"="Schizophrenia and related", "Mood"="Mood disorders", "Neurotic"="Neurotic disorders", "Eating"="Eating disorders", "Personality"="Personality disorders", "Retardation"="Mental retardation", "Developmental"="Developmental disorders", "Behaviour"="Behavioral disorders"), direction='horizontal', selected="Mood disorders"),
		column(6, offset=3, 
			h3( tags$u(tags$b("Figure 10.a")),": Evolution of cumulative incidence proportion (CIP, Y axis) over time (in years after exposure, X axis). Please choose exposure on top of the figure. Results are displayed outcome per outcome. You can split this relationship per age range using the 'more' button below.")
		)
	),
	fluidRow(align="center", 
		plotOutput("plot_CIP_a", height = "800px", width="70%", click = "plot1_click")
	),
	fluidRow(column(6, offset=3, align="center",
		hr(),
		h5("The next chart below allows you to explore a specific interaction by age ranges. Click on the upper chart to choose your outcome disorder."),
		hr()
	)),
	fluidRow(align="center",
		plotOutput("plot_CIP_b", height = "300px", width="70%"),
		br(),
		column(6, offset=3, h3( tags$u(tags$b("Figure 10.b")),": Evolution of CIP over time at different age range for prior-disorder. Use the buttons above to choose the prior-disorder. The age-specific CIPs are shown by clicking on the panel of outcome disorder in the previous figure. Confidence interval are represented by the grey area."))
	),
	fluidRow(align="center", radioGroupButtons("sex_absolute_plot", label = NULL, choices=c("Men"="M", "Women"="K", "All"="all" ), direction='horizontal', selected="all")),

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
			h5("The prevalence of mental disorder differed between men and women, thus we expect the pattern of COMO will also differ by sex. Here we show a scatterplot between all disorder pairs, for males (on the X axis) and females (on the Y axis). Note that confidence intervals can vary between sex as a consequence of sex-related differences in the prevalence of one or both disorders within the disorder pairs."),
			br()
		)
	),

	fluidRow(align="center",
		column(6, offset=3,  align="center",
			br(), br(), br(),br(),
			plotlyOutput("plot_sexcomp", height = "700px", width="90%"),
			br()
		),
		column(3, align="left", 
			br(),br(),br(),br(),br(),br(),br(),br(),br(),
			h3(tags$u(tags$b("Figure 11")),": Comparison of hazard ratios between males and females. Each hazard ratio is represented by a point and 95% confidence intervals (horizontal and vertical lines)."),
			dropdownButton(circle = TRUE, icon = icon("plus"), width = "300px", tooltip = tooltipOptions(title = "More options available"),
				selectInput(inputId = "log_sexcomp",   label = "Kind of scale:", choices=c("Log Scale"="log", "Linear Scale"="normal"), selected="normal"),
				selectInput(inputId = 'model_sexcomp', label = 'Model used to compute HR', choices = c("Model A: adjusting for age, sex and calendar time"="1", "Model B: further adjusting for other mental disorders"="2") )
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



	# -------------------------------------------------------------------------------------
	# === ROW : Grey Parts with the introduction
	fluidRow(align="center", style="opacity:0.9 ;margin-top: 0px; width: 100%;",



		column(6, offset=3, align="center",
				div(img(src="NBP logo.jpg" , height = 250, width = 250) , style="text-align: center;"),
				column(6, offset=0, align="justify",
					h5("As part of the ", a("Niels Bohr Professorship", href="http://econ.au.dk/the-national-centre-for-register-based-research/niels-bohr-professorship/"), "we are exploring patterns of comorbidity (COMO) within treated mental disorders. Over the next few years we will explore different ways of describing the complex patterns of comorbidity between mental disorders. In particular, we wish to develop")
				), 
				column(6, offset=0, align="justify",
					h5("interactive data visualizations that will allow the research community greater flexibility in exploring the multidimensional nature of the COMO. Firstly, we will explore COMO within the ", a("Danish National Patient Registry", href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4655913/"), "(DNPR), one of the world’s oldest nationwide hospital registries.")
				),
				hr()
		),
	br()
	),
 	# -------------------------------------------------------------------------------------




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
			h5("Danish health registers provide approved researchers access to anonymized person-level information on access to mental  health care via inpatient, outpatient, and emergency settings. Our study was built on a sampling frame that provides an extended period to identify prevalent cases prior to the year 2000. From 2000-2016, there has been a period of observation incident (new) cases can be confidently identified using the International Classification of Diseases (ICD)."),
			br(),
			h5("As can be seen in the figure below, ICD8 was used from 1969 to 1994, and ICD10 since 1995. The mental health register was based on inpatient events between 1969 and 1994, after which outpatient and emergency visits were included."),
			br()	
		),
		div(img(src="TimeLine.png" , height = 250, width = 800) , style="text-align: center;"),
		h3(tags$u(tags$b("Figure 1")),": Timeline of the Danish Register"),
		br(), br(),

		# table
		br(),br(),br(),
		fluidRow(column(8, offset=2, h5("In ICD10 the mental health-related disorders are located in the F chapter, with major groups clustered in two digit strata (e.g. F20-F29). In this paper we base our major disorder strata on the conditions outlined in", a("this paper", href="https://www.ncbi.nlm.nih.gov/pubmed/24806211"), ". Each diagnosis includes several specific diagnosis. If you hover your mouse to a row under the column diagnosis, you will see the specific subgroups included in this interactive table." ))),
		br(), br(),
		dataTableOutput('ICD10table' , width="80%") %>% withSpinner( color= "#2ecc71") ,
		h3(tags$u(tags$b("Figure 2")),": The 10 mental disorder groups studied with their ICD10 and ICD8 codes."),
		
		# Bubble
		column(6, offset=3, ggiraphOutput("plot_circlepack", height = "800px", width="800px") ),
		column(2, br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(), h3(tags$u(tags$b("Figure 3")),": The relative occurence of each mental disorders. Hover over the bubble to see the number of cases with each disorder"))
	),
	

	# Tree
	fluidRow(
		column(2, offset=1, br(),br(), br(),br(), br(),br() ,br(),br(),br(),br(),br(),br(),br(), h3(tags$u(tags$b("Figure 4")),": Each diagnosis of our study includes several specific diagnosis. This interactive tree allows to explore them. Click a diagnosis to see the specific subgroups included.")),
		column(9, align="left", collapsibleTreeOutput("tree", height="600px", width="100%") %>% withSpinner( color= "#2ecc71") )
	),

        


	fluidRow(
		column(8, offset=1,  align="left",
			h2( "2. Study population and assessment of mental disorders"),
			hr()
		),
		column(8, offset=2, align="justify",
			h5("We designed a population-based cohort study including all individuals living in Denmark during the study period (2000-2016) who had been born in Denmark between 1900 and 2015 (N = 5,940,778). Since 1968, the Danish Civil Registration System includes information on all residents, including sex, date of birth, continuously updated information on vital status, and a unique personal identification number that can be used to link information from various national registries."),
			br(),
			h5("Information on mental disorders was obtained from the Danish Psychiatric Central Research Register, which contains all admissions to psychiatric inpatient facilities since 1969 and, from 1995, contacts to outpatient psychiatric departments and emergency visits."),
			br(),
			h5("The diagnostic system used was the Danish modification of the International Classification of Diseases, 8th Revision (ICD-8) from 1969 to 1993, and 10th Revision (ICD-10) from 1994 onwards. We classified different mental disorders into 10 main groups, based on previous research using Danish registers and validated linkage between ICD-8 and ICD-10 codes. From this point onwards, we use “Disorder Group” to describe a set of specific ICD diagnoses. Note, because of issues related to ICD8 to ICD10 crosswalks, three disorder groups were restricted to specific disorders. The date of onset for each disorder group was defined as the first day of the first contact (inpatient, outpatient, or emergency visit) for any of the specific diagnoses within the ICD Disorder Group."),
			br()
		)
	),	

	fluidRow(
		br(),br(),br(),
		column(8, offset=1,  align="left",
			h2( "3. Study design"),
			hr()
		),
		column(8, offset=2, align="justify",
			h5("For each of the ten disorder groups, follow-up started on January 1, 2000 or at the earliest age at which a person might develop the disorder (Table 1), whichever came later. Follow-up was terminated at onset of the disorder, death, emigration from Denmark, or December 31, 2016, whichever came first. Our analyses were based on incident cases diagnosed according to the ICD-10 classification system during the observation period (2000-2016), when inpatient, outpatient and emergency visits information were included in the register."),
			br(),
			h5("Individuals with a diagnosis of the disorder before the observation period were considered prevalent cases and excluded from the analyses. This stringent washout rule meant that individuals included in the analyses could not have previously accessed services for the specific mental disorder. for a 31-year period from 1969 to 1999. A sensitivity analysis in a previous study estimating incidence rates and lifetime risks for the same mental disorders revealed nearly identical results when extending the washout period to 36 years."),
			br()
		)
	),
	
	fluidRow(
		br(),br(),br(),
		column(8, offset=1,  align="left",
			h2( "4. Statistical analysis"),
			hr()
		),
		column(8, offset=2, align="justify",
			h5("We examined the association between all pairs of Disorder Groups taking into consideration the time order, i.e. each pair consisted of a temporally prior disorder (prior-disorder) and temporally later disorder (later-disorder). All disorders were treated as time-varying. When investigating the association between a specific Disorder Group pair, all individuals were free of the outcome-disorder at the beginning of follow-up (prevalent cases were excluded by design) and individuals were either (a) considered exposed to the prior-disorder if they were diagnosed before start of follow-up, or (b) remained unexposed until the onset of the prior-disorder (if it happened during the follow-up), moment in which they became exposed."),
			br(),
			h5("In those instances where there were ties, i.e. prior- and later- disorders occurring on the same day, ties were broken by moving a proportion of the prior-disorder diagnosis to one day earlier, otherwise the later-disorder would only count for the unexposed, and the association would be underestimated. The proportion of cases to be moved was obtained by estimating the proportion of cases in which the prior-disorder occurred before the outcome-disorder among those with both prior- and later-disorders occurring within 5 years."),
			br(),
			h5("We then compared the rate of being diagnosed with the outcome-disorder between exposed and unexposed to the prior-disorder using hazard ratios, obtained via Cox Proportional Hazards models with age as the underlying time scale. All estimates were adjusted for sex and calendar time (model A); in a second step, the estimates were further adjusted for mental comorbidity with onset prior to exposure, but not with onset after exposure, as it might be an intermediate factor (model B). Additional mental disorder comorbidity consisted on all other disorders except the specific prior- and later-disorders and the total number of other disorders (2, 3 or 4+)."),
			br(),
			h5("We further adjusted for the interaction between each type and each number of co-occurring disorders, but results were substantially the same as in model B. Additionally, we performed stratified sex-specific analyses to examine if there were differences between men and women. A hazard ratio of 5 obtained with model B, for example, can be interpreted as the rate of outcome-disorder among individuals diagnosed with prior-disorder being 5 times higher compared with individuals of the same sex, age and birth date, with the same comorbidities, but not diagnosed with prior-disorder. When the rates among the exposed and unexposed are not proportional over time, the Cox Proportional Hazards model estimates can be interpreted as an average hazard ratio over the entire follow-up period. However, we further investigated if the association differed depending on the time since onset of the prior-disorder. Finally, we estimated the cumulative incidence proportion of being diagnosed with an outcome-disorder after being diagnosed with a prior-disorder. Cumulative incidences can be interpreted as the percentage of individuals diagnosed with prior-disorder who develop the later-disorder after a specific time, and they were estimated using competing risks survival analyses to account for the fact that persons are simultaneously at risk of developing the disorder, dying, or emigrating."),
			br(),
			h5("All analyses were performed in the secured platform of Statistic Denmark using R version 3.2.2 and STATA/MP version 13.1 (Stata Corporation, College Station, Texas, USA). The data displayed in this application are available in the table below and a .csv version is available using the download button."),
			br(),br()
			
		)
	),
	br(),
	fluidRow(align="center", 
		downloadButton("load_ex_format1", label = "Download"),
		actionButton(inputId='ab1', label="Github", icon = icon("github"), onclick ="location.href='https://github.com/holtzy/the-NB-COMO-Project';"), 
		actionButton(inputId='ab1', label="Paper", icon = icon("file-o"), onclick ="location.href='https://www.ncbi.nlm.nih.gov/pubmed/';"), 
		br(),br(),
		column(10, offset=1, dataTableOutput('raw_data') %>% withSpinner( color= "#2ecc71") ) 
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
   					tags$li(h5(a("Yan Holtz",href="https://www.linkedin.com/in/yan-holtz-2477534a"))), 
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
			h2("Acknowledgement", align="left"),
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
			"Created by", strong(a("Yan Holtz", style="color:lightblue", href="https://www.linkedin.com/in/yan-holtz-2477534a")), ".",
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
