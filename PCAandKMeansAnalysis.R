---
  title: "Pääkomponenttianalyysin ja kmeans-ryhmittelyn soveltaminen suuridimensionaaliseen aineistoon"
subtitle: "Harjoitustyö opintojaksoll Monimuuttujamenetelmät"
author: Ellinoora Hetemaa
output:
  pdf_document: default
html_document: default
date: "03.03.2023"
bibliography: #references.bib
  biblio-style: "apalike"
link-citations: true
lang: fi
editor_options: 
  markdown: 
  wrap: 72
---
  
  ```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

# Sisällysluettelo

1.  [Johdanto](#johdanto)
  2.  [Datan esittely](#data)
    3.  [Käytetyt menetelmät](#menetelmat)
      1.  [K-means ryhmittely](#kmeans)
        2.  [Pääkomponenttianalyysi](#pca)
          4.  [Tulokset ja niiden tulkinta](#tulokset)
            1.  [K-means ryhmittely](#kmeans2)
              2.  [Pääkomponenttianalyysi](#pca2)
                5.  [Yhteenveto](#yhteenveto)
                  
                  ## Johdanto <a name="johdanto"></a> {#johdanto}
                  
                  Tässä työssä sovelletaan kahta yleisesti tunnettua
                  monimuuttuja-analyysiä aineistoon, joka on peräisin julkisesta
                  koneoppimiseen käytetystä repositoriosta. Tarkoituksena on selvittää
                  saadaanko pääkomponenttianalyysillä vähennettyä datan
                  dimensionaalisuutta luotettavasti ja toisaalta k-means ryhmittelyllä
                  jaoteltua dataa selkeisiin kokonaisuuksiin.
                  
                  ## Datan esittely <a name="data"></a>
                  
                  Aineistona on datasetti korkeakouluopiskelijoiden koulumenestyksestä,
                  joka on peräisin avoimesta ML-repositoriosta [1]. Datassa on 33
                  attribuuttia ja eri opiskelijoita 145. Attribuutteina ovat mm.
                  opiskelijan ikä, sukupuoli, aiemmin käydyn lukion tyyppi, stipendin
                  tyyppi, työskenteleekö ohessa ja onko liikunnallista aktiivisuutta.
                  
                  Attribuutit 1-10 ovat henkilökohtaisia tietoja, 11-16 perheeseen
                  liittyviä tietoja ja loput koulutukseen liittyviä tietoja.
                  Yksityiskohtaisemmin attribuutit on avattu alla.
                  
                  Student ID - opiskelijan tunnus
                  
                  1 - Opiskelijan ikä (1: 18-21, 2: 22-25, 3: yli 26)
                  
                  2 - Opiskelijan sukupuoli (1: nainen, 2: mies)
                  
                  3 - Lukion tyyppi, josta opiskelija on valmistunut (1: yksityinen, 2:
                                                                        valtion, 3: muu)
                  
                  4 - Stipendin tyyppi (1: Ei mitään, 2: 25%, 3: 50%, 5: 75%, 6: Täysi)
                  
                  5 - Töitä opiskelun ohessa (1: Kyllä, 2: Ei)
                  
                  6 - Säännöllistä taiteellista tai liikunnallista aktiivisuutta (1:
                                                                                    Kyllä, 2: Ei)
                  
                  7 - Kumppania (1: Kyllä, 2: Ei)
                  
                  8 - Kokonaispalkka, jos saatavilla (1: USD 135-200, 2: USD 201-270, 3:
                                                        USD 271-340, 4: USD 341-410, 5: above 410)
                  
                  9 - Kulkeutuminen yliopistolle (1: Linja-auto, 2: Oma auto/taksi, 3:
                                                    Polkypyörä, 4: Muu)
                  
                  10 - Asumistyyppi Kyproksella (1: Vuokra, 2: Asuntola, 3: Perheen koti,
                                                 4: Muu)
                  
                  11 - Äidin koulutus (1: Ala-aste, 2: Ylä-aste, 3: Lukio, 4: Yliopisto,
                                       5: Muu)
                  
                  12 - Isän koulutus (1: Ala-aste, 2: Ylä-aste, 3: Lukio, 4: Yliopisto, 5:
                                        Muu)
                  
                  13 - Sisarusten lukumäärä, jos saatavilla (1: 1, 2:, 2, 3: 3, 4: 4, 5: 5
                                                             yli)
                  
                  14 - Vanhempien status (1: Naimisissa, 2: Eronneet, 3: Kuollut - toinen
                                          tai molemmat)
                  
                  15 - Äidin työllisyys (1: Eläke, 2: Kotiäiti, 3: Valtion virkamies, 4:
                                           Yksityisen sektorin työntekijä, 5: Yrittäjä, 6: Muu)
                  
                  16 - Isän työllisyys (1: Eläke, 2: Valtion virkamies, 3: Yksityisen
                                        sektorin työntekijä, 4: Yrittäjä, 5: Muu)
                  
                  17 - Viikkotyäaika (1: Ei mitään, 2: \< 5h, 3: 6-10h, 4: 11-20h, 5:
                                        \>20h)
                  
                  18 - Lukemistaajuus (non-scientific books/journals) (1: Ei mitään, 2:
                                                                         Joskus, 3: Usein)
                  
                  19 - Lukemistaajuus (scientific books/journals) (1: Ei mitään, 2:
                                                                     Joskus, 3: Usein)
                  
                  20 - Osallistuminen seminaareihin/konferensseihin (1: Kyllä, 2: Ei)
                  
                  21 - Omien projektien tai harrastusten vaikutus menestykseen (1:
                                                                                  Positiivinen, 2: Negatiivinen 3: Neutraali)
                  
                  22 - Oppitunneille osallistuminen (1: Aina, 2: Joskus, 3: Ei koskaan)
                  
                  23 - Valmistautuminen välikokeisiin 1 (1: Yksin, 2: Kavereiden kanssa,
                                                         3: Ei saatavilla)
                  
                  24 - Valmistautuminen välikokeisiin 2 (1: Päivä ennen koetta, 2:
                                                           Säännöllisesti jakson aikana, 3: Ei koskaan)
                  
                  25 - Muistiinpanojen tekeminen oppintunneilla (1: Ei koskaan, 2: Joskus,
                                                                 3: Aina)
                  
                  26 - Kuunteleminen oppitunneilla (1: Ei koskaan, 2: Joskus, 3: Aina)
                  
                  27 - Keskustelu lisää kiinnostusta ja menestystä kurssilla (1: Ei
                                                                              koskaan, 2: Joskus, 3: Aina)
                  
                  28 - Flipatut oppitunnit (1: Hyödyttömiä, 2: Hyödyllisiä. 3: Ei
                                            saatavilla)
                  
                  29 - Tutkinnon arvosanojen kumulatiivinen keskiarvo (/4.00): (1: \<2.00,
                                                                                2: 2.00-2.49, 3: 2.50-2.99, 4: 3.00-3.49, 5: above 3.49)
                  
                  30 - Tutkinnon odotettu arvosanojen kumulatiivinen keskiarvo (/4.00):
                    (1: \<2.00, 2: 2.00-2.49, 3: 2.50-2.99, 4: 3.00-3.49, 5: above 3.49)
                  
                  31 - Kurssin tunnus
                  
                  32 - Arvosana (0: Hylätty, 1: DD, 2: DC, 3: CC, 4: CB, 5: BB, 6: BA, 7:
                                   AA)
                  
                  Alla on histogrammit, jokaisen muuttujan suhteesta koulumenestykseen
                  (arvosanoihin).
                  
                  ```{r}
                  rm(list = ls())
                  # Multiple plot function
                  #
                  # ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
                  # - cols:   Number of columns in layout
                  # - layout: A matrix specifying the layout. If present, 'cols' is ignored.
                  #
                  # If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
                  # then plot 1 will go in the upper left, 2 will go in the upper right, and
                  # 3 will go all the way across the bottom.
                  #
                  multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
                    library(grid)
                    
                    # Make a list from the ... arguments and plotlist
                    plots <- c(list(...), plotlist)
                    
                    numPlots = length(plots)
                    
                    # If layout is NULL, then use 'cols' to determine layout
                    if (is.null(layout)) {
                      # Make the panel
                      # ncol: Number of columns of plots
                      # nrow: Number of rows needed, calculated from # of cols
                      layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                                       ncol = cols, nrow = ceiling(numPlots/cols))
                    }
                    
                    if (numPlots==1) {
                      print(plots[[1]])
                      
                    } else {
                      # Set up the page
                      grid.newpage()
                      pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
                      
                      # Make each plot, in the correct location
                      for (i in 1:numPlots) {
                        # Get the i,j matrix positions of the regions that contain this subplot
                        matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
                        
                        print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                                        layout.pos.col = matchidx$col))
                      }
                    }
                  }
                  
                  library(data.table)
                  library(ggplot2)
                  library(gridExtra)
                  
                  student_data <- fread("DATA.csv", header = TRUE)
                  dim(student_data)
                  student_data <- student_data[1:145, 2:33]
                  
                  student_data
                  means = NULL
                  vars = NULL
                  modes = NULL
                  medians = NULL
                  # Let's calculate variable means
                  for (i in 1:31) {
                    colnames(student_data)[i] <- "y"
                    means[i] <- mean(student_data$y)
                    vars[i] <- var(student_data$y)
                    modes[i] <- mode(student_data$y)
                    medians[i] <- median(student_data$y)
                    colnames(student_data)[i] <- i
                  }
                  
                  modes
                  medians
                  means
                  vars
                  
                  # Plotting all the variables towards course grade ((0: Fail, 1: DD, 2: DC, 3: CC, 4: CB, 5: BB, 6: BA, 7: AA)
                  # Course grade here reflects the success of the student at certain course
                  
                  # regular artistic or sports activity (1: Yes, 2: No) 
                  
                  # colnames(student_data)[6] <- "activity"
                  plots <- NULL
                  myplots <- list()
                  for (i in 1:31) {
                    colnames(student_data)[i] <- "y"
                    student_data$y <- as.factor(student_data$y)
                    ggp <- ggplot(student_data,
                                  aes(x = GRADE, color = y, fill= y)) +
                      geom_histogram(position = "dodge", bins = 20, alpha = 1) +
                      labs(title = paste("Histogram of variable ", i, " towards grade counts"))
                    colnames(student_data)[i] <- i
                    myplots[[i]] <- ggp
                  }
                  
                  multiplot(plotlist = myplots[1:4], cols = 2)
                  multiplot(plotlist = myplots[5:8], cols = 2)
                  multiplot(plotlist = myplots[9:12], cols = 2)
                  multiplot(plotlist = myplots[13:16], cols = 2)
                  multiplot(plotlist = myplots[17:20], cols = 2)
                  multiplot(plotlist = myplots[21:24], cols = 2)
                  multiplot(plotlist = myplots[25:28], cols = 2)
                  multiplot(plotlist = myplots[29:31], cols = 2)
                  ```
                  
                  Histogrammeista löydetään mielenkiintoinen suhde isän työllistymistavan
                  ja opiskelijoiden arvosanojen välillä. Selkeästi menestyneimpiä ovat ne
                  opiskelijat, joiden isä työskentelee joko valtion virkamiehenä tai
                  jonain muuna.
                  
                  Lisäksi merkittäviltä menestykseen vaikuttavilta muutujilta näyttävät
                  opiskelijan sukupuoli ja ikä. Katsotaan löydetäänkö näiden kolmen
                  muuttujan ja arvosanojen välillä korrelaatiota.
                  
                  ```{r}
                  # Loading data
                  rm(list = ls())
                  library(data.table)
                  
                  data <- fread("DATA.csv", header = TRUE)
                  
                  data <- data[1:145, 2:33]
                  ```
                  
                  ```{r}
                  # 18, 20, 21, 29, 30
                  cor(data[1:145, 1], data[1:145, 32])
                  cor(data[1:145, 2], data[1:145, 32])
                  cor(data[1:145, 16], data[1:145, 32])
                  cor(data[1:145, 19], data[1:145, 32])
                  ```
                  
                  Huomataan, että opiskelijan sukupuolen ja arvosanan välillä on
                  kohtalainen korrelaatio, mutta iän ja arvosanojen tai opiskelijan isän
                  työllisyyden ja arvosanojen väliset korrelaatiot ovat selkeästi
                  heikompia. Voidaan todeta, että opiskelijan sukupuolella on tämän
                  tutkimusaineiston perusteella vaikutusta opiskelijan koulumenestykseen.
                  Tutkitaan seuraavaksi korrelaatiota opiskelijan sukupuolen ja isän
                  työllisyyden välillä
                  
                  ```{r}
                  cor(data[1:145, 1], data[1:145, 16])
                  ```
                  
                  Sukupuolen ja iän välillä on pieni korrelaatio, mutta ei niin
                  merkittävä, että voitaisi tehdä mitään johtopäätöksiä. Tutkitaan
                  seuraavaksi korrelaatiota sukupuolen ja isän työpaikan välillä.
                  
                  ```{r}
                  cor(data[1:145, 2], data[1:145, 16])
                  ```
                  
                  Kokeilemalla havaitaan, joidenkin muiden muuttujien ja arvosanojen
                  välillä melko merkittävää korrelaatiota. Näitä koulumenestykseen
                  vaikuttavia muuttujia ovat muuttujat 18, 20, 21, 29, 30. Lasketaan
                  näiden ja arvosanojen väliset korrelaatiot.
                  
                  ```{r}
                  print("Lukemistaajuus 1:")
                  print(cor(data[1:145, 18], data[1:145, 32]))
                  print("Osallistuminen seminaareihin/konferensseihin:")
                  cor(data[1:145, 20], data[1:145, 32])
                  print("Omien projektien tai harrastusten vaikutus menestykseen: ")
                  cor(data[1:145, 21], data[1:145, 32])
                  print("Tutkinnon arvosanojen kumulatiivinen keskiarvo:")
                  cor(data[1:145, 29], data[1:145, 32])
                  print("Tutkinnon odotettu arvosanojen kumulatiivinen keskiarvo:")
                  cor(data[1:145, 30], data[1:145, 32])
                  ```
                  
                  ## Käytetyt menetelmät <a name="menetelmat"></a>
                  
                  Tässä osiossa selitetään lyhyesti käytetyt menetelmät ja teoriat niiden
                  taustalla.
                  
                  ### K-means ryhmittely <a name="kmeans"></a>
                  
                  K-means ryhmittely on alunperin singaalinkäsittelyssä käytetty metodi,
                  joka pyrkii ryhmittelemään datan eri pisteet k ryhmään. Metodi jakaa
                  jokaisen datapisteen sitä lähimpänä olevaan "klusteri-keskukseen".
                  Klusteri-keskukset taas sijoitetaan dataan niin, että ne ovat
                  keskimäärin mahdollisimman lähellä datapisteitä. Tavoitteena on siis
                  minimoida seuraava summalauseke:
                    
                    $\sum_i min(dist(d_i, c_j)^2)$
                    
                    Klusteroinnissa pyritään siis jakamaan datapisteet ryhmiin niiden
                  samankaltaisuuden perusteella, jolloin voidaan tehdä johtopäätöksiä
                  datan jakautumisesta. [3]
                  
                  ### Pääkomponenttianalyysi <a name="pca"></a>
                  
                  Pääkomponenttianalyysi pyritään vähentämään datan dimensionaalisuutta,
                  jotta sitä olisi helpompi tarkastella ja analysoida. Menetelmä on
                  erityisen hyödyllinen sellaisille aineistoilla, joissa dimensioita on
                  enemmän kuin 3. Metodilla pyritään luomaan aineiston muuttujien tilalle
                  kokonaan uudet muuttujat aiempien muuttujien lineaarikombinaatioina.
                  Näin datasta ei häviä tietoa, se vain muuttaa muotoaan. Nämä uudet
                  muuttujat eli "pääkomponentit" muodostetaan siten, etttä ensimmäinen
                  pääkomponentti selittää suurimman osan datan varianssista, toinen
                  pääkomponentti toiseksi suurimman osan datan varianssista ja niin
                  edelleen. Seuraava pääkomponentti muodostetaan kuitenkin siten, että se
                  on ortogonaalinen edellisten pääkomponenttien kanssa. Seuraavaksi
                  kuvaamme menetelmän matemaattisesti. [2]
                  
                  Ensimmäinen pääkomponentti saadaan alkuperäisten muuttujien
                  lineaarikombinaationa
                  
                  $$
                    y_1 = a_{11}x_1+a_{12}x_2+ ... + a_{1p}x_p = a_1'x,
$$

jolle $Var(y_1)$ on suurin ja siten, että $a_1'a = 1$.
                  
                  Samoin toinen pääkomponentti saadaan lineaarikombinaationa
                  
                  $$
                    y_2 = a_{21}x_1+a_{22}x_2+ ... + a_{2p}x_p = a_2'x
$$

siten, että $y_1$ ja $y_2$ ovat korreloimattomia keskenään ja $Var(y_2)$
on suurin mahdollinen.

Edellisten tavoin j:dennes pääkomponentti saadaan lineaarinkombinaationa

$$
y_j = a_{j1}x_1+a_{j2}x_2+ ... + a_{jp}x_p = a_j'x,
                  $$
                    
                    jolle $Var(y_j)$ on suurin mahdollinen siten, että $a_j'a_j = 1$ ja
$a_j'a_i = 0, (i<j)$. [2]
                  
                  ## Tulokset ja niiden tulkinta <a name="tulokset"></a>
                  
                  Tässä osiossa suoritetaan halutut menetelmät aineistolle ja pyritään
                  tulkitsemaan niitä.
                  
                  ### K-means ryhmittely <a name="kmeans2"></a>
                  
                  ```{r}
                  km <- kmeans(data, 5)
                  km$centers
                  library(cluster)
                  clusplot(data, km$cluster, color=TRUE, shade=TRUE,
                           labels=2, lines=0)
                  ```
                  
                  Huomataan, että ryhmät menevät suurelta osin päällekkäin, eikä ainakaan
                  5 ryhmän ryhmittelyanalyysi selitä dataa kovinkaan luotettavasti. Emme
                  voi vetää tämän menetelmän pohjalta yhteyksiä datapisteiden välille.
                  
                  ### Pääkomponenttianalyysi <a name="pca2"></a>
                  
                  Tehdään opiskelijoiden koulumenestyaineistoon pääkomponenttianalyysi
                  r-kielen prcomp-funktiolla.
                  
                  ```{r}
                  library(factoextra)
                  dim(data)
                  students.pca <- prcomp(data, center = TRUE, scale = TRUE, rank = 7)
                  print(students.pca)
                  fviz_eig(students.pca)
                  
                  plot(students.pca, type='l')
                  summary(students.pca)
                  students.pca$x[1:31,1:3]
                  loadings(students.pca)
                  
                  summary(students.pca)
                  biplot(students.pca, scale = 0)
                  ```
                  
                  Yllä olevasta kuvaajasta nähdään, että mikään pääkomponeista ei selitä
                  aineiston varianssia mitenkään ylivertaisesti, vaan osuus laskee
                  tasaisesti ensimmäisestä pääkomponenetista viimeiseen. Kuvaajasta
                  nähdään, ettei pääkomponenttianalyysi ole kovin hyvä menetelmä kyseisen
                  datan analysointiin, sillä emme saa kovin hyvin perustein vähennettyä
                  datan dimensionaalisuutta. Piirretään kuitenkin vielä kuvaaja kahden
                  ensimmäisen pääkomponentin välille.
                  
                  ```{r}
                  fviz_pca_ind(students.pca,
                               col.ind = "cos2", # Color by the quality of representation
                               gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
                               repel = TRUE     # Avoid text overlapping
                  )
                  ```
                  
                  Yllä olevasta kuvaajasta nähdään selvästi, että kaksi ensimmäistä
                  pääkomponenttia eivät selitä aineistoa kovinkaan luotettavasti.
                  
                  ## Yhteenveto <a name="yhteenveto"></a> {#yhteenveto}
                  
                  Yhteenvetona nämä kaksi käytettyä menetelmää antoivat melko heikkoja
                  tuloksia. Pääkomponenttianalyysistä emme löytäneet komponentteja, jotka
                  selittäisivät erityisen suuren osan datasta, eikä myöskään
                  ryhmittelyanalyysi saanut datapisteitä jaoteltua kovinkaan selkeisiin
                  ryhmiin. Voimme ehkä todeta, että data koostui lopulta suhteellisen
                  samankaltaisista opiskelijoista, eikä mikään yksittäinen tekijä
                  vaikuttanut erityisen paljoa opiskelijoiden koulumenestykseen. Toisaalta
                  näitä tuloksia ei voi ottaa kovinkaan vakavasti senkään vuoksi, että
                  datapisteiden määrä oli hyvin pieni, vain 145 tapausta.
                  
                  # Lähteet
                  
                  [1][UCI Machine Learning
                      Repository](<https://archive.ics.uci.edu/ml/datasets/Higher+Education+Students+Performance+Evaluation+Dataset>)
                  
                  [2] [Kurssin Multivariate Analysis -
                         opintomoniste](https://moodle.tuni.fi/pluginfile.php/2952679/mod_resource/content/1/MA2-2021.pdf)
                  
                  [3] Kristina P. Sinaga ja Min-Shen Yang, Unsupervised K-Means Clustering
                  Algorithm, 2020
                  