# Predictive-Modeling

## Project Title ##
A Model to Predict Racial Arrests Based on Demographics in the City of Albany New York

## Authors ##
Alice Ottah
Yvonne Dadson
----------------------------------------

## Project Overview ##
Historically, racial discrimination has been regarded as a critical Human Rights problem in the United States. Regardless, racial profiling is still a significant issue among police departments across the United States. To improve policing practices and keep communities safer, the Albany Police Department has taken various steps in the past few years, inluding community engagements and initiatives like, Neighborhood Engagement Unit (NEU) in 2010, Albany Police Reform and Reinvention Collaborative in 2020 and Safer Neighborhoods through Precision Policing Initiative (SNPPI) in 2015.

Predictions about the degree of fatality of crime was based on individual's demographics until the 1970's. There are two extensive types of predictive policing tools are location-based algorithms and person-based predictive. Even with the use of these tools, several historical events have shown that predictive policing tools and the abuse of data by the police force bolsters systemic racism. These occurrences have been blamed on the skewness of arrest data that feeds algorithms. According to research, the likelihood of a black individual being arrested is more than twice and five times more likely to be apprehended without an objective reason than a white person.

The objective of this project is to design a logistic model to predict the race of individual arrests and determine if arrests are racially based on the demographics of an individual

## Technologiy used ##
R is an open source statistical computing and visualization programming language and environment that compiles and runs on various of operating systems. R was used for this project because it provides a variety of statistical and graphical techniques, which includes linear and nonlineral modeling, classification and time series analysis etc.

## Overview of the datasection ##
A secondary dataset which highlights arrests by Albany PD Officers  was obtained from the official website of the City of Albany. A purposive sampling technique was used to extract pre-selected races and neighborhoods from a population size of 1558 observations with 18 variables. Sample size of 928 observations with five variables; race, age, sex, arrest type, and neighborhood association. 

Over 216 arrest types were identified, whose neighborhood associations were not included in the dataset, hence, a bias that can skew the results of the analysis.

A comparatively higher number of arrests of the black race than the White creating an imbalanced dataset with a proportion of 70% black race arrest as against 30% for the white race.
To reduce the skewness in the dataset, observations with no neighborhood associations were randomly assigned to the two predominant neighborhood associations categories namely black and white. Up sampling was performed on the data to increase the number of minority data class (white race) to create a balanced dataset for the analysis.
----------------------------------------

## How to install and use the project files ##
1. Install [RStudio](https://www.rstudio.com/) to your device.
2. Run RStudio
3. Open code file
4. Install required packages
5. load package libraries
6. load dataset
7. Follow the steps to run the codes
----------------------------------------

## Conclusion ##
For this project a model was created to predict the race of an individual arrested based on demographics. Using City of Albany as a case study, a secondary dataset was used to create a logistic regression model which produced an accuracy of 63% and identified the statistically significant variables

