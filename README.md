The NB-COMO Project
===================

--> [online application](https://holtzyan.shinyapps.io/the-nb-como-project/)
--> [Scientific paper](https://jamanetwork.com/journals/jamapsychiatry/fullarticle/2720421)


Overview
--------
The NB-COMO project aims to explore the patterns of comorbidity within treated mental disorders. It explores different ways to capture the complex patterns of comorbidity, notably through data visualization techniques. The first part of this project explores COMO within the [Danish National Patient Registry](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4655913/) (DNPR), one of the world’s oldest nationwide hospital registries.

This repository gives the code of a [web application](https://holtzyan.shinyapps.io/the-nb-como-project/) that allows to interactively explore our results. It goes along with our peer reviewed [publication](https://jamanetwork.com/journals/jamapsychiatry/fullarticle/2720421) in JAMA psychiatry.

Here is a screenshot of one of the multiple visualizations proposed in the website:
![fig1](www/Screen_Shot_ShinyCOMO.png)





How to use the application
--------
The best way to use this application is via its [online version](https://holtzyan.shinyapps.io/the-nb-como-project/).

If you really want to use this application locally you can:

**1.** Clone the whole repository

**2.** Open R and make sure all the required libraries are installed (see top of the global.R file). If you miss a library, remember you can install it with:
```
ìnstall.packages("shiny")
```

**3.**
Then, set the working directory and run the App:
```
setwd("my/path/to/the/github/folder/you/downloaded")
library(shiny)
runApp()
```



Citing
--------
If using, please cite the [associated paper](https://jamanetwork.com/journals/jamapsychiatry/fullarticle/2720421).



About us
--------

John Mc Grath: [homepage](http://researchers.uq.edu.au/researcher/6724)   
Oleguer Plana Ripoll: [homepage](https://www.researchgate.net/profile/Oleguer_Plana-Ripoll)  
Yan Holtz: [homepage](https://holtzyan.wordpress.com)  
