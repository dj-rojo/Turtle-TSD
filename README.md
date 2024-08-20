
# Climate Change-Induced Bias in Turtle Populations with Temperature-Dependent Sex Determination
<img src="https://github.com/dj-rojo/Climate-Change-Induced-Bias-in-Turtle-Populations-with-Temperature-Dependent-Sex-Determination/blob/main/Model%20Final%20view.png" alt="Description of the image" align="right" width="200" />

This project showcases an agent-based model developed in NetLogo, along with the accompanying code for data analysis. It was submitted as part of my bachelor's thesis to achieve a Bachelor of Science in Environmental Systems Science at the University of Graz. The model simulates a sea turtle population with a basic reproductive cycle, demonstrating how climate change-induced feminization might affect it.
For more information and a detailed description of the methods see my thesis paper as published in this repository. 

# Background

Temperature-dependent sex determination (TSD) in turtles is an adaptive strategy that increases the production of female hatchlings when eggs are exposed to warmer incubation temperatures. Under the influence of rapid anthropogenic climate change, this adaptation may become a threat, as turtle populations face high levels of feminization. This study uses an agent-based modeling approach to explore the threshold at which an increased percentage of female hatchlings leads to population instability, decline, or even extinction, assuming all other temperature-induced effects besides sex ratio biases are disregarded.

In the simulation, a fictional sea turtle population starting with a 50-50 sex ratio undergoes a simplified reproductive cycle, producing hatchlings at a predetermined primary sex ratio, varied across scenarios. Additionally, the number of females a single male turtle can mate with in one season is adjusted to test how the population’s sensitivity to sex ratio changes under different levels of pollution.

# Model Description 


In each time step in the model, every turtle undergoes the following steps:



1. The age increases by one. If a turtle reaches the set maturity age in the current time step, it now counts towards the adult population and is considered in the mating function.
2. The turtles move in a random direction.
3. Within an assigned radius, every male turtle looks for females to mate with. The maximum number of female mates is varied between scenarios.
4. Any female that mates with a male produces a number of hatchlings calculated based on literature data. The hatchling sex is determined by the chance of producing females according to the respective scenario.
5. Adult turtles are subjected to a mortality, expressed as a probability to die in the current time step. If the carrying capacity *K* of the model ecosystem is surpassed, an additional mortality rate becomes effective.

# Limitations

<img src="https://github.com/dj-rojo/Climate-Change-Induced-Bias-in-Turtle-Populations-with-Temperature-Dependent-Sex-Determination/blob/main/50%20and%204.png" alt="Description of the image" align="left" width="300" />

While the model uses input data grounded in scientific research, the simplified reproductive cycle has certain limitations. A model is always a simplified representation of a natural system and should be interpreted as such. The limitations of this model include the exclusion of female breeding intervals, the smaller population sizes compared to natural turtle populations, and the disregard for genetic effects and other temperature-induced impacts on turtle hatchlings. Despite these limitations, modeling remains a valuable tool for informing conservation efforts and exploring ecological questions.
