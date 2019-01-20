	# ------------------------------------
	#
	#	The COMO project
	#
	# ------------------------------------




tagList(

	# This is to explain you have a CSS file that custom the appearance of the app
	includeCSS("www/style.css"),

	navbarPage(title="",


	footer=fluidRow( align="center" ,
		br(), br(),
		column(4, offset=4,
			hr(),
			br(), br(),
			"Created by", strong(a("Yan Holtz", style="color:lightblue", href="https://www.linkedin.com/in/yan-holtz-2477534a")), ".",
			br(),
			"Source code available on", strong(a("Github", style="color:lightblue", href="https://github.com/holtzy/the-NB-COMO-Project")), ".",
			br(),
			"Copyright © 2017 The COMO Project",
			br(), br(),br(),
			includeScript("google-analytics.js")

		),
		br(),br()
	),

	header=	fluidRow(align="center", style="opacity:0.9 ;margin-top: 0px; width: 100%;",

			helpText("The", style="color:black ; font-family: 'times'; font-size:30pt",
						strong("NB-COMO", style="color:black; font-size:40pt"),
						"project", style="color:black ; font-family: 'times'; font-size:30pt"
			),
			column(8, offset=2, hr())
			),








# #########
#	TAB  INTRO
# #########

	tabPanel("Intro",


		fluidRow(align="center", style="opacity:0.9 ;margin-top: 0px; width: 100%;",

			column(6, offset=3, align="center",
					div(img(src="NBP logo.jpg" , height = 230, width = 230) , style="text-align: center;"),
					br(),
					column(6, offset=0, align="justify",
						h5("As part of the ", a("Niels Bohr Professorship", href="http://econ.au.dk/the-national-centre-for-register-based-research/niels-bohr-professorship/"), "we are exploring patterns of comorbidity (COMO) within treated mental disorders. Over the next few years we will explore different ways of describing the complex patterns of comorbidity between mental disorders. In particular, we wish to develop interactive data visualizations")
					),
					column(6, offset=0, align="justify",
						h5("that will allow the research community greater flexibility in exploring the multidimensional nature of the COMO. Firstly, we will explore COMO within the ", a("Danish Psychiatric Central Research Register", href="https://www.ncbi.nlm.nih.gov/pubmed/21775352"), "(DNPR), one of the world’s oldest nationwide hospital registries.")
					),
					hr()
			),
		br()
		)
	),

















# #########
#	TAB 2 (METHODS)
# #########
tabPanel("Methods",

	# -------------------------------------------------------------------------------------
	# ===  ROW : Time lapse + Circle Packing explaining ICD10 OR table with link ICD10 - ICD8
	fluidRow(align="center",

		br(),br(),br(),br(),

		# title
		fluidRow(column(5, offset=1,  align="left", id="definition",
			h2( "1. Key features of the Danish registers"),
			hr()
		)),

		# image
		br(),br(),
		column(8, offset=2, align="justify",
			h5("Since 1968 , the ", a("Danish Civil Registration System", href="https://www.ncbi.nlm.nih.gov/pubmed/21775345"), " has maintained information on all residents, including sex, date of birth, continuously updated information on vital status, and a unique personal identification number that can be used to link information from various national registries."),
			br(),
			h5("Danish health registers provide approved researchers access to anonymized person-level information on access to mental health care via inpatient, outpatient, and emergency settings. Our study was built on a sampling frame that provides an extended period to identify prevalent cases prior to the year 2000. In addition, from 2000 to 2016, there has been a period of observation of incident (new) cases, that can be confidently identified using the International Classification of Diseases (ICD)."),
			br(),
			h5("As can be seen in the figure below, the Danish Psychiatric Central Research Register contains information on all admissions to psychiatric inpatient facilities since 1969 and visits to outpatient psychiatric departments and emergency departments since 1995. The diagnostic system used was the Danish modification of the ",em("International Classification of Diseases, Eighth Revision"), " (ICD-8) from 1969 to 1993, and ", em("Tenth Revision"), " (ICD-10) from 1994 onwards."),
			br()
		),
		div(img(src="TimeLine.png" , height = 250, width = 800) , style="text-align: center;"),
		h3(tags$u(tags$b("Figure 1")),": Timeline of the Danish Register"),
		br(), br(),

		# table
		br(),br(),br(),
		fluidRow(column(8, offset=2, h5("In order to keep the number of analyses tractable, and to ensure comparability between our analysis and", a("previous publications", href="https://www.ncbi.nlm.nih.gov/pubmed/24806211"), " based on the Danish registers, we used the ten level subchapter categories as described in ICD-10 (e.g. F00-F09, F10-19, F20-29, etc.) and corresponding diagnoses in ICD-8. Each disorder includes several specific diagnosis. If you hover your mouse to a row under the column “Mental disorders”, you will see examples of diagnoses included in each group in the following interactive table." ))),
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
			h5("We designed a population-based cohort study including all individuals born in Denmark during 1900-2015, who resided in the country during the study period (2000-2016) (5,940,778; 2,958,293 males and 2,982,485 females). The Danish Civil Registration System was used to link information from various national registries. Information on mental diseases was obtained from the Danish Psychiatric Central Research Register."),
			br(),
			h5("From this point onwards, we use “disorder” to describe each group of specific diagnoses presented above. For each individual in the study, the date of onset for each disorder was defined as the date of first contact (inpatient, outpatient, or emergency visit)."),
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
			h5("We examined the association between all possible 90 pairs of disorders taking the temporal order into consideration (i.e. the association between two specific disorders was estimated in both directions). Depending on whether individuals had a diagnosis of one of the specific disorders (henceforth referred to as prior-disorder), we estimated the risk of being diagnosed with an additional disorder (henceforth referred to as later-disorder)."),
			br(),
			h5("For each specific pair, follow-up started on January 1, 2000 or at the earliest age at which a person might develop the later-disorder (Table 1), whichever came later. Follow-up was terminated at onset of the later-disorder, death, emigration from Denmark, or December 31, 2016, whichever came first. Our analyses were based on incident cases of the later-disorder, diagnosed during the observation period (2000-2016). Individuals with a diagnosis of the particular later-disorder before the observation period were considered prevalent cases and excluded from the analyses (i.e. prevalent cases were “washed-out”)."),
			br(),
			h5("When estimating the risk of a later-disorder, we considered all individuals to be exposed or unexposed to the each prior-disorder depending on whether they had a diagnosis between January 1st, 1969 and the end of follow-up. Persons with a prior-disorder were considered unexposed until the date of the first diagnosis, and exposed afterwards. It is important to note that we make no assumption that the later-disorder is causally related to the prior-disorder."),
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
			h5("We compared the rate of diagnosis with a specific later-disorder between exposed and unexposed to each of the other nine prior-disorders using hazard ratios (HRs) and 95% confidence intervals (CI), obtained via Cox proportional hazards models with age as the underlying time scale."),
			br(),
			h5("All estimates were adjusted for sex and calendar time (Model A). In order to adjust for additional preceding comorbidity, we also examined models that adjusted for mental disorder comorbidity with onset before the prior-disorder, but not with onset after the prior-disorder (Model B). This model adjusted for both (a) all additional types of disorders (apart from the specific prior- and later-disorders), and (b) the total number of other disorders (2, 3 or 4+)."),
			br(),
			h5("We further adjusted for the interaction between type and number of co-occurring disorders, but the results were substantially the same as in model B (data not shown). Additionally, we included an interaction term between exposure to a prior-disorder and sex in order to obtain sex-specific estimates and test for differences between males and females. When the rates among the exposed and unexposed are not proportional over time, the Cox proportional hazards model estimates can be interpreted as an average HR over the entire follow-up period. However, we further investigated if the association differed depending on the time since onset of the prior-disorder (i.e. lagged HRs)."),
			br(),
			h5("Finally, in order to quantitate the absolute risk of developing the later-disorder, we estimated the cumulative incidence proportion of diagnosis with a later-disorder after being diagnosed with a prior-disorder. Cumulative incidences can be interpreted as the percentage of individuals diagnosed with prior-disorder who develop the later-disorder after a specific time. These estimates were stratified by sex and age (at onset of the prior-disorder) groups (<20, 20-40, 40-60, 60-80, and >=80 years) using competing risks survival analyses to account for individual’s simultaneously risk of developing the disorder, dying or emigrating."),
			br(),
			h5("All analyses were performed on the secured platform of Statistics Denmark using R version 3.2.2 and STATA/MP version 13.1 (Stata Corporation, College Station, Texas, USA)."),
			br(),br()

		)
	),
	br(),
	fluidRow(align="center",
		downloadButton("load_ex_format1", label = "Download"),
		actionButton(inputId='ab1', label="Github", icon = icon("github"), onclick ="location.href='https://plana-ripoll.github.io/NB-COMO/';"),
		actionButton(inputId='ab1', label="Paper", icon = icon("file-o"), onclick ="location.href='https://jamanetwork.com/journals/jamapsychiatry/fullarticle/2720421';"),
		br(),br(),
		column(10, offset=1, dataTableOutput('raw_data') %>% withSpinner( color= "#2ecc71") )
	)
),










# #########
#	TAB  RESULT
# #########
tabPanel("Results",




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
			h5("We estimated hazard ratios between each pair of disorders. Note that all estimates are over 1, meaning that being diagnosed with one of the disorders increased the risk of a subsequent diagnosis with each of the other disorders."),
			br(),
			h5("The plot below shows the distribution of hazard ratios for all COMO pairs."),
			br()
		)
	),

	fluidRow(align="center",
		br(),
		radioGroupButtons("sex_longbar", label = NULL, choices=c("Women"="women", "Men"="men", "All"="all"), selected="all"),
		column(6, offset=3, plotlyOutput("plot_longbar", height = "500px", width="900") %>% withSpinner( color= "#2ecc71") ),
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
			h5("This Sankey diagram shows the associations between all possible combinations of mental disorders. Prior-disorders are represented on the left, while later-disorders are on the right"),
			br(),
			h5("It is possible to examine the association between each prior-disorder and later-disorder. To see the hazard ratios, hover your mouse over the connecting threads. The different disorders are colour-coded. The Sankey diagram will automatically rearrange the order of prior- and later-disorders to minimize cross-overs. Move the slider below figure 6 to examine COMO pairs with effect sizes larger than a specific value. Note that relative risks are different than absolute risks."),
			br()
		)
	),

	fluidRow(
		column(6, offset=3,  align="center",
			fluidRow(
				column(6, h6(align="left", "prior-disorders")),
				column(6, h6(align="right", "later-disorders"))
			),
			sankeyNetworkOutput("plot_sankey", height = "800px", width="100%") %>% withSpinner( color= "#2ecc71"),
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
			h5("This heat map shows the pairwise hazard ratios. Darker shades of blue indicate larger hazard ratios (see colour legend on the right). Hover your mouse hover the cells to get the exact hazard ratio for each pair of disorders."),
			br()
		)
	),

	fluidRow(
		column(8, offset=1,  align="center",
			plotlyOutput("plot_heat2", height=900, width=1000) %>% withSpinner( color= "#2ecc71"),
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
			h2("4. The bidirectional association between pairs of disorders – symmetrical and asymmetrical patterns"),
			hr()
	)),

	fluidRow(align="center",
		column(6, offset=3,  align="center",
			br(), br(),
			h5("In these graphs, we wish to explore the bidirectional association between pairs of disorders. The results suggest that most temporally ordered disorder pairs have a bidirectional relationship - there is an increased risk of disorder regardless of temporal order. However, some disorder pairs appeared to be quite symmetrical – we call these ‘mirror phenotypes’ – where it seems the risk of developing either disorder are similar regardless of which disorder comes first."),
			br()
		)
	),

	fluidRow(align="center", radioGroupButtons("disease_symetry_plot", label = NULL, choices=c( "Organic"="Organic disorders", "Substance"="Substance use", "Schizophrenia"="Schizophrenia and related", "Mood"="Mood disorders", "Neurotic"="Neurotic disorders", "Eating"="Eating disorders", "Personality"="Personality disorders", "Intellectual Dis."="Intellectual Disabilities", "Developmental"="Developmental disorders", "Behaviour"="Behavioral disorders" ), direction='horizontal', selected="Mood disorders")),
	br(), br(),
	fluidRow(align="center",
		column(6, offset=3, plotOutput("plot_symbar", height = 700, width="90%") %>% withSpinner( color= "#2ecc71")),
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
		radioGroupButtons("disease_time_plot", label = NULL, choices=c( "Organic"="Organic disorders", "Substance"="Substance use", "Schizophrenia"="Schizophrenia and related", "Mood"="Mood disorders", "Neurotic"="Neurotic disorders", "Eating"="Eating disorders", "Personality"="Personality disorders", "Intellectual Dis."="Intellectual Disabilities", "Developmental"="Developmental disorders", "Behaviour"="Behavioral disorders"),  direction='horizontal', selected="Mood disorders"),
		plotlyOutput("plot_time", height = "800px", width="70%"),
		textOutput("xlablineplot"),
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
			h5("The cumulative incidence proportion (CIP) shows the proportion of individuals who developed a later-disorder after being diagnosed with a prior-disorder. A cumulative incidence proportion of 20 per 100 persons at 10 years suggests that approximately one in 5 people with a prior-disorder will subsequently develop a different (incident) disorder within the following 10 years."),
			br()
		)
	),

	fluidRow(align="center",
		br(),
		h6("Choose exposure: "),
		radioGroupButtons( "disease_CIP_plot", label = NULL, choices=c( "Organic"="Organic disorders", "Substance"="Substance use", "Schizophrenia"="Schizophrenia and related", "Mood"="Mood disorders", "Neurotic"="Neurotic disorders", "Eating"="Eating disorders", "Personality"="Personality disorders", "Intellectual Dis."="Intellectual Disabilities", "Developmental"="Developmental disorders", "Behaviour"="Behavioral disorders"), direction='horizontal', selected="Mood disorders"),
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
#	TAB 3
# #########
tabPanel("Meet the team",

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

)











	# -------------------------------------------------------------------------------------
	# === 9/ Footer



	# -------------------------------------------------------------------------------------





# Close the ui
))
