#################################################################################
#################################################################################
# Marketing Analytics
# Tutorial 2: Consumer and Customer Analytics
#################################################################################
#################################################################################

#################################################################################
# Set up
#################################################################################

# load required packages
# install.packages("vcdExtra")
library(vcdExtra) # to expand data tables
# install.packages("vcd")
library(vcd) # for mosaic plot
# install.packages("mlogit")
library(mlogit) # for multinomial logit models & heating data set
# install.packages("dfidx")
library(dfidx) # to index a data set
# install.packages("lmtest")
library(lmtest) # for likelihood ratio test
# install.packages("expm")
library(expm)  # for matrix exponentiation
# install.packages("clickstream")
library(clickstream)  # for transition probabilities
# install.packages("superheat")
library(superheat) # for cluster visualization

# set working directory to the desired folder
getwd()
# setwd("INSERT FILE PATH HERE")

#################################################################################
# Part A) Binary Choice: Logistic Regression
#################################################################################

#################################################################################
# Exercise 1

# We will work with sales data on season passes to an amusement park. Thereby, 
# the sales differ according to two factors: the channel (email, postal mail, in-
# person) used to deliver the promotion and whether the promotion included the 
# ticket in a bundle with free parking or not.

# Bought season pass (count): 
#      Bundle No Bundle
# Mail    242       359
# Park    639       284 
# Email    38        27

# Did not buy season pass (count): 
#      Bundle No Bundle
# Mail    449       278
# Park    223        49 
# Email    83       485

####
# a) 
# Store the data tables in R, also including the descriptive marginal labels 
# (Ticket, Channel, Offer).
####

# Store all count values in a single vector by entering them column-wise.
pass_tab <- c(242, 639, 38, 359, 284, 27, 449, 223, 83, 278, 49, 485)
# Assign dimensions to the vector, reformatting it to a 3 (rows) x 2 (columns) x
# 2 (tables) array. 
dim(pass_tab) <- c(3, 2, 2)
# Adding marginal labels (using dimnames) to the table helps with readability.
# The rows correspond to the channel type, the columns to whether or not the
# bundle was offered and each table counts either the number of people that did 
# or did not buy the season pass.
dimnames(pass_tab) <- list(Channel = c("Mail", "Park", "Email"),
                           Offer = c("Bundle", "NoBundle"),
                           Ticket = c("Pass", "NoPass") )
# Inspect the resulting table to confirm it matches our data.
pass_tab

####
# b)
#	Convert the data into long form to get a data frame of individual customer 
# observations.
####

# First, we need to convert to class "table". 
class(pass_tab) <- "table"
# This is necessary to be able to use expand.dft( ) from thevcdExtra package and 
# get a data frame where each row corresponds to one customer (observation).
pass_df <- expand.dft(pass_tab)
# Inspecting the structure of the resulting object shows that the data frame
# contains 3156 observations of individuals with information on whether a 
# season pass was purchased (Ticket), the channel used for promotion (Channel) 
# and whether a bundle with free parking was offered (Offer).
str(pass_df)

# The observations are ordered according to their count in the initial data
# tables (e.g. the first 242 rows are customers that bought the season pass and 
# received the promotion for the bundle via postal mail).
View(pass_df)
# Alternatively, we could randomly sort the rows of the data frame to get a 
# random ordering of customers so that they are not grouped together anymore.
pass_df2 <- pass_df[sample(nrow(pass_df)),]
View(pass_df2)
# This does not affect the calculations in the following.

# Using table( ) on this data frame allows us to create cross-tabs.
table(pass_df$Ticket, pass_df$Offer)
# For example, 919 consumers that were offered the bundle also bought the season 
# pass, the remaining 755 did not.

####
# c)
#	Using logistic regression, estimate whether the promotion of the bundle 
# (season pass + free parking) has an effect on the sales of season passes to 
# the amusement park. 
####

# By default, R orders factors alphabetically which does not necessarily always 
# make sense for the specific case at hand.
str(pass_df$Offer)
# Instead, manually specify the order of the factors levels as desired.
pass_df$Offer <- factor(pass_df$Offer , levels = c("NoBundle", "Bundle"))
# Now, NoBundle is given the lower implicit value and listed first.
table(pass_df$Ticket, pass_df$Offer)
str(pass_df$Offer)

# Estimate the described relationship (Ticket as DV, Offer as IV).
# family argument to specify the distribution of the outcome variable
pass_m1 <- glm(Ticket ~ Offer, data = pass_df, family = binomial) 
summary(pass_m1)
# Individuals that receive the bundled offer are more likely to purchase the 
# season pass, since the offer coefficient is positive (0.389) and statistically 
# significant.

####
# d)
#	Manually calculate the association between season pass purchase and the bundle 
# factor by examining the ratio of success to non-success.
####

# plogis(x) gives the logistic distribution function and can be used to manually 
# calculate the ratio of the probability of the desired outcome to the 
# probability of the alternative outcome.
plogis(0.389) / (1 - plogis(0.389))
# From the lecture, you know this is equivalent to:
exp(0.389)
# The effect of the bundle equals an estimated odds ratio of 1.476. This suggests 
# individuals are 1.476 times more likely to purchase the season pass if it is 
# offered in a bundle with free parking.

# If the estimated model is stored in R, it is possible to access the 
# coefficients directly using coef( ).
coef(pass_m1)
exp(coef(pass_m1))
# To only access the estimated coefficient for Offer:
coef(pass_m1)[2]

# Similarly, a confidence interval for the odds ratio can be calculated.
exp(confint(pass_m1))
# The odds ratio of the bundle is estimated to be in the interval 1.28 - 1.70. 
# This suggests a significant positive effect of the offer of a bundle on season 
# pass purchases.

####
# e)
#	How does the model from c) change if channel is added as a predictor? 
####

# Taking a closer look at season pass purchases per channel indicates that the 
# amusement park itself is most successful at selling tickets.
table(pass_df$Ticket, pass_df$Channel)

# Estimate the described relationship (Ticket as DV, Offer and Channel as IV).
pass_m2 <- glm(Ticket ~ Offer + Channel, data = pass_df, family = binomial)
summary(pass_m2)
# Now, ceteris paribus, a strong negative contribution of the bundle offer to 
# season pass sales is estimated.

# A calculation of the odds ratios and the corresponding confidence intervals 
# suggest that individuals are 30 - 56 times more likely to purchase a season 
# pass at the park directly. Offering the bundle to individuals is associated 
# with a 32% - 52% lower likelihood of purchase. 
exp(coef(pass_m2))
exp(confint(pass_m2))

####
# f)	
# Is there an interaction between the bundle offer and channel in their 
# relationship with the purchase of season passes? 
####

# Mosaic plots visualize tiles so that the area of each corresponds to counts in 
# a table.
doubledecker(table(pass_df))
# The plot suggests that season pass sales are rather unsuccessful by email, but 
# successful at the park. This indicates different effects for the three channels. 
# Offering the bundle is associated with higher sales by email but lower sales 
# for the other two channels, providing evidence for an interaction effect. 

# Estimate the described relationship (Ticket as DV, Offer and Channel as IV) and
# include an interaction term in addition to the main effects.
pass_m3 <- glm(Ticket ~ Offer + Channel + Offer:Channel, 
               data = pass_df, family = binomial)
summary(pass_m3)
# The interaction term itself can be added to the formula using :, or include the 
# main effects and the interaction effect directly using *. Both approaches lead 
# to the same model.
pass_m3_alt <- glm(Ticket ~ Offer*Channel, 
               data = pass_df, family = binomial)
summary(pass_m3_alt)
# The interaction of bundle with channel is statistically significant and 
# strongly negative for the mail and park channels, as opposed to the baseline.

exp(confint(pass_m3))
# The confidence intervals of the odds ratios suggest that the bundle is only
# 2% - 11% as effective for the mail and park channel than when offered by email.

#################################################################################
# Exercise 2

# We will use a simulated data set that contains customer transactions on an 
# e-commerce website together with satisfaction data. 

# First, download the sales data.
salesdata <- read.csv("https://goo.gl/4Akgkt") 
# Take a look at the included variables and the number of observations.
summary(salesdata)
str(salesdata)

####
# a) 
# Using logistic regression, estimate the relationship between customers 
# receiving the coupon and their purchasing behavior of the promoted product. 
####

# Estimate the described relationship (purchase as DV, coupon as IV).
purchase_m1 <- glm(purchase ~ coupon, data = salesdata, family = binomial)
summary(purchase_m1)  
# Customers that receive the coupon are more likely to buy the promoted product, 
# since the coupon coefficient is positive (1.72) and statistically significant.

####
# b)
# Manually calculate the association between purchase and the coupon factor by 
# examining the ratio of success to non-success.
####

# We can either use plogis( ) and calculate the ratio manually
plogis(1.7234) / (1-plogis(1.7234))
# or use exp( ) to get the exponential.
exp(coef(purchase_m1)[2])  
# The result shows that the effect of the coupon equals an estimated odds ratio 
# of 5.603, meaning that customers are 5.603 times more likely to purchase the 
# promoted product when they receive a coupon.

####
# c)
# How does the model from a) change if region, overall satisfaction, and total 
# spending are added as predictors? 
####

# Estimate the described relationship (purchase as DV, coupon, lifetime spending
# and overall satisfaction as IV).
purchase_m2 <- glm(purchase ~ coupon + spendToDate + region + satOverall, 
                    data = salesdata, family = binomial)
summary(purchase_m2)
# The coefficient for coupon is still positive and significant.
# The coefficient for spending is not significant, so it seems that previous 
# purchases do not influence the purchase of the promoted product.
# Overall satisfaction has a highly significant effect. Higher satisfaction is
# related to a higher purchase likelihood.
table(salesdata$region)
# The Mideastern region is taken as the baseline in this model. Region does not
# seem to have a significant effect.

####
# d)
# Is there an interaction between the coupon variable and overall satisfaction 
# in their relationship with the purchase of the promoted product? 
####

# Estimate the described relationship (purchase as DV, coupon and overall
# satisfaction as IV) and include an interaction term in addition to the main 
# effects.
purchase_m3 <- glm(purchase ~ coupon + satOverall + coupon:satOverall,         
                   data = salesdata, family = binomial)
summary(purchase_m3)
# The interaction term itself can be added to the formula using :, or include the 
# main effects and the interaction effect directly using *. Both approaches lead 
# to the same model.
purchase_m3_alt <- glm(purchase ~ coupon * satOverall,         
                       data = salesdata, family = binomial)
summary(purchase_m3_alt)
# The interaction term is not significant. 

#################################################################################
# Part B) Product Choice: Multinomial Logit Model
#################################################################################

#################################################################################
# Exercise 3

# We will use a data set that contains the heating system choices for Californian
# houses.

# First, load the heating data.
data("Heating", package = "mlogit")
# Take a look at the included variables and the number of observations.
summary(Heating)
head(Heating)

####
# a) 
# Index the data set on the two variables idcase and depvar.
####

# The package dfidx has a function that creates a data object for which 
# observations are characterized by two indexes. The first (id1) gives the 
# observation number, the second (id2) represents the chosen heating system. 
# Since the Heating data is in wide format, we pass the ic. and oc. variables in
# columns 3-12 to the varying argument. 
heatingdata <- dfidx(Heating, choice = "depvar", varying = c(3:12))

# Print the first 10 rows to see that the first house chose the heating option
# gas central, for example.
print(heatingdata, n = 10)
# Print only the indexes of the first 10 rows.
print(idx(heatingdata), n = 10)

####
# b)
# Estimate a multinomial logit model with installation and operating costs, but 
# do not include an intercept. 
####

# Estimate the described relationship (depvar as DV, installation and operating
# costs as IV) using a multinomial logit model. Suppress the intercept either 
# specifying + 0 in the formula directly
heating_m1 <- mlogit(depvar ~ 0 + ic + oc, heatingdata)
# or by adding | 0. Both approaches lead to the same estimated model.
heating_m1a <- mlogit(depvar ~ ic + oc | 0, heatingdata)
summary(heating_m1)
# Both estimated coefficients are negative. This suggests that as the cost of a 
# heating system rises (and the costs of the alternatives remain the same), the 
# probability of that system being chosen decreases. Both coefficients are 
# statistically significantly different to 0.

####
# c) 
# How close do the model's estimated probabilities match the shares of houses 
# that actually chose each heating system?
####

# The observed frequencies are given at the top of model summary output. 
# Alternatively, this table shows the proportions of the chosen heating systems, 
# as calculated from the observed frequencies.
prop.table(table(Heating$depvar))
# The function fitted returns the fitted values from the estimated model and
# specifying the argument outcome as FALSE returns the probability for each 
# alternative and for each house. Using apply will take the mean for each column.
apply(fitted(heating_m1, outcome = FALSE), MARGIN = 2, FUN = mean)
# Observed frequencies and predicted shares do not match well.

####
# d) 
# Calculate the willingness to pay (WTP) for a $1 reduction in annual operating 
# costs.
####

# The ratio of operating cost coefficient to installation cost coefficient gives
# the WTP for a $1 reduction in operating costs (paid for through higher 
# installation costs).
wtp <- coef(heating_m1)["oc"]/coef(heating_m1)["ic"]
wtp
# Individuals are willing to pay $0.73 higher installation costs to have $1 lower
# annual operating costs.
# Referring to the coefficient position (rather than the name) leads to the same
# result.
coef(heating_m1)[2]/coef(heating_m1)[1]

####
# e) 
# What is the discount rate r implied by this WTP? Assume a sufficiently long 
# life T of the operating system so that the current value of operating costs cv
# approaches oc/r for an increasing lifetime.
####

# As T increases, cv approaches oc/r. Then, a $1 reduction in annual operating
# costs reduces cv by 1/r, representing the WTP for such a future discount. 
# Rearranging this gives the discount rate implied by the model.
r <- 1/wtp
r
# A discount rate > 1 is not reasonable.

####
# f) 
# Estimate a multinomial logit model that imposes the following restraint on the 
# discount rate: r=0.12. Again, cost is the independent variable and there should 
# be no intercept.
####

wtp <- 1/0.12
wtp
# Assuming a discount rate of 0.12, the corresponding WTP is 8.33. This means
# individuals are willing to pay $8.33 higher installation costs to have $1 lower
# annual operating costs.

# Create a new variable tc that combines both costs and includes the specified 
# discount rate constraint. It now represents the current value of the total 
# costs for each heating system (again under the assumption of a sufficiently
# long lifetime T).
heatingdata$tc <- heatingdata$ic + (heatingdata$oc / 0.12)

# Estimate the described relationship (depvar as DV, costs as IV) using a 
# multinomial logit model. Suppress the intercept and use the total cost variable.
heating_m2 <- mlogit(depvar ~ tc | 0, heatingdata)
summary(heating_m2)
# The estimate is negative and statistically significant, suggesting higher total
# costs of a heating system are related to a lower likelihood of its purchase.

####
# g)
# Test the assumption made for the discount rate in f) using a likelihood ratio 
# test.
####

# The function lrtest performs a likelihood ratio test. The null hypothesis is 
# that r = 0.12, or that m2 is better than the unconstrained model m1.
lrtest(heating_m1, heating_m2)
# The test statistic is given by twice the difference in the log likelihoods of 
# the models: 306.93 = 2*(1248.7 - 1095.2). The p-value indicates it is larger
# then the critical value, so the null hypothesis is rejected.

# Alternatively, the critical value is given by the 0.95% quantile of the chi-
# square distribution with 1 degree of freedom. This can directly be compared to
# the test statistic for a manual check of the null hypothesis.
qchisq(0.95, df = 1)

#### 
# h)
# Estimate a multinomial logit model with installation and operating costs and 
# include alternative-specific constants. Take the heat pump as the base 
# alternative. 
####

# With J alternatives, a model can only estimate J-1 alternative-specific 
# constants. The resulting coefficients are interpreted relative to the base J.
# Estimate the described relationship (depvar as DV, installation and operating
# costs as IV) using a multinomial logit model. Include alternative-specific
# constants, taking hp as the base.
heating_m3 <- mlogit(depvar ~ ic + oc, heatingdata, reflevel = "hp")
summary(heating_m3)
# All estimates except for the constant for gas room are statistically 
# significant at the 5% level. Both costs coefficients are negative as before.

#### 
# i)
# How close do this model's estimated probabilities now match the shares of 
# houses that actually chose each heating system? 
####

# Again, the observed frequencies are given at the top of model summary output,
# or they can be calculated manually.
prop.table(table(Heating$depvar))
# The function fitted returns the fitted values from the estimated model and
# specifying the argument outcome as FALSE returns the probability for each 
# alternative and for each house. Using apply will take the mean for each column.
apply(fitted(heating_m3, outcome = FALSE), MARGIN = 2, FUN = mean)
# The probabilities are a perfect match. Alternative-specific constants ensure
# average probabilities equal observed shares in logit models.

####
# j) 
# Again, compute the corresponding WTP and discount rate.
####

# The ratio of operating cost coefficient to installation cost coefficient gives
# the WTP for a $1 reduction in operating costs (paid for through higher 
# installation costs).
wtp <- coef(heating_m3)["oc"]/coef(heating_m3)["ic"]
wtp
# Individuals are willing to pay $4.56 higher installation costs to have $1 lower
# annual operating costs.

r <- 1/wtp
r
# The corresponding discount rate is 0.22. 

####
# k)
# Relate the magnitude of upfront installation costs to household income and add 
# this to the model instead of installation cost by itself. Include operating 
# costs as before.
####

# Estimate the described relationship (depvar as DV, installation costs divided
# by income and operating costs as IV) using a multinomial logit model. Since the
# symbol : is used for interactions in R formulas, use the wrapper I( ) to 
# specify the desired division.
heating_m4 <- mlogit(depvar ~ oc + I(ic / income), heatingdata)
summary(heating_m4)
# Both cost coefficients remain negative, but the estimated coefficient for the 
# installation cost term is not statistically significant.

####
# l)
# Next, use alternative-specific income effects instead, again with the heat pump
# as the base alternative. Test whether including income effects leads to a better 
# model than one using alternative-specific constants.
####

# Estimate the described relationship (depvar as DV, installation and operating
# costs as IV) using a multinomial logit model. Include alternative-specific
# income effects, taking hp as the base. The operator | is used to signify the 
# variable on which the formula is conditioned.
heating_m5 <- mlogit(depvar ~ oc + ic | income, heatingdata, reflevel = "hp")
summary(heating_m5)
# Income does not seem to have a strong effect, since all corresponding 
# coefficients are not statistically significant.

# Use a likelihood ratio test to compare the smaller model with alternative-
# specific constants to the model with alternative-specific income effects.
lrtest(heating_m3, heating_m5)
# The p-value is too high, the null hypothesis that the smaller model provides as
# good a fit for the larger data as the larger one can't be rejected.

####
# m)
# Finally, we use a multinomial logit model for prediction. The Californian
# government is considering to offer a 15% rebate on the installation cost of 
# heat pumps. They want to predict the effect of this proposal on the choice of 
# heating systems. Use the estimated coefficients from h) to calculate the new 
# probabilities and predicted shares in the case of the cheaper installation 
# costs for a heat pump. 
####

# Create a copy of the data set.
heatingdata_new <- heatingdata
# Adjust the installation costs of heat pumps to reflect the proposed rebate.
heatingdata_new[idx(heatingdata_new, 2) == "hp", "ic"] <- 
  0.85 * heatingdata_new[idx(heatingdata_new, 2) == "hp", "ic"]
# Comparing the installation costs for heat pumps in the original and new data 
# set shows the variable manipulation worked as intended.
mean(heatingdata$ic[idx(heatingdata, 2) == "hp"])
mean(heatingdata_new$ic[idx(heatingdata_new, 2) == "hp"])

# The observed frequencies in the original data:
apply(fitted(heating_m3, outcome = FALSE), 2, mean)
# Use predict() to estimate the new shares of the heating systems after the 
# proposed price change for heat pumps.
apply(predict(heating_m3, newdata = heatingdata_new), 2, mean)

#################################################################################
# Part C: Markov Chain Models
#################################################################################

#################################################################################
# Exercise 4

# Imagine a popular restaurant is now offering a weekly lunch, where customers 
# can choose between 3 dish options: Pasta, Rice, and Salad. The individual 
# dishes vary weekly, but the base component of each of the 3 alternatives 
# remains the same. Due to the weekly menu, assume that customers will only get 
# lunch at the restaurant once a week. 

#### 
# a)
# In the first week, 70% of customers ate pasta for lunch, 20% rice, and 10% 
# salad. Create a vector in R with the starting probabilities of the 3 menu 
# options. 
####

# Assign a meaningful name to the specified vector of starting probabilities and
# name the individual elements according to the corresponding lunch dish.
p_start <- c(0.7, 0.2, 0.1)
names(p_start) <- c("Pasta", "Rice", "Salad")
p_start

####
# b)
# Since the restaurant just started offering the lunch menu, there is no 
# historical data from which to derive the likelihood of customers switching 
# between the 3 lunch options in the following weeks. Instead, the restaurant
# used its regular dinner orders to estimate the purchasing behavior of their 
# lunch customers. Store the transition probabilities as a matrix in R.
####

# The matrix is filled with the specified values element-wise by row. There are 3 
# rows in total.
p_trans <- matrix(c(0.1, 0.6, 0.3, 0.5, 0.4, 0.1, 0.2, 0.8, 0), nrow = 3, 
                  byrow = TRUE)
# Assign meaningful names to the rows and columns.
rownames(p_trans) <- c("Pasta (t)", "Rice (t)", "Salad (t)")
colnames(p_trans) <- c("Pasta (t+1)", "Rice (t+1)", "Salad (t+1)")
p_trans
# A customer who purchased the Rice dish in the first week has a 40% probability
# of eating the same type of lunch in the next week, for example.

####
# c)
# Use the information you have to compute the estimated popularity of each of the 
# 3 lunch alternatives in the second week.
####

# Simply using the normal product operator would calculate element-wise. All 
# values in the first row of the matrix are multiplied by the first vector 
# element, all values in the second row by the second vector element, and all 
# values in the final row of the matrix are multiplies by the third vector 
# element.
p_start * p_trans

# Use %*% to calculate the matrix product of the starting probabilities and the
# transition probabilities.
p_start %*% p_trans
# The prediction for the second week is that 19% of customers will order the 
# Pasta, 58% the Rice dish, and 23% Salad.
# Manually calculating the predicted popularity of Pasta in the second week 
# confirms this.
0.7*0.1 + 0.2*0.5 + 0.1*0.2

####
# d)
# Do the same popularity prediction for the third week in which the restaurant 
# offers the lunch menu.
####

# Calculate the state probabilities in the third week by multiplying the state
# probabilities that result from c) with the transition probabilities.
p_start %*% p_trans %*% p_trans
# The prediction for the second week is that 35.5% of customers will order the 
# Pasta, 53% the Rice dish, and 11.5% Salad.
# Manually calculating the predicted popularity of Pasta in the third week 
# confirms this.
0.19*0.1 + 0.58*0.5 + 0.23*0.2

####
# e)
# Find the long-term steady state shares of the 3 lunch options.
####

# Exponentiate the transition matrix and multiply with the state probabilities to
# get the steady long-term prediction.
p_start %*% (p_trans %^% 100)
# The long-term prediction is that 32.5% of customers will order the Pasta, 52.5% 
# the Rice dish, and 15% Salad.This steady state is achieved in the long run, 
# regardless of the initial distribution across the states.
c(1, 0, 0) %*% (p_trans %^% 100)
c(1/3, 1/3, 1/3) %*% (p_trans %^% 100)

#################################################################################
# Exercise 5

# We use a data set of a government web server log that has been made public. 

# First, download the server log data. 
epadata <- readRDS(gzcon(url("https://goo.gl/s5vjWz"))) 
# Take a look at the included variables and the number of observations.
summary(epadata)
View(epadata)

####
# a)
# What are the overall 5 most common page requests? Then, only consider HTML 
# requests and determine the 5 most common requests.
####

# The overall 5 most common requests are found by sorting the frequency table of
# the page variable in decreasing order and printing the first 5 results.
head(sort(table(epadata$page), decreasing = TRUE), 5)
# Users often request .gif files, e.g. logos.

# To find the 5 most common HTML request, first filter the data to only consider
# the specified page type.
head(sort(table(epadata$page[epadata$pagetype == "html"]), decreasing = TRUE), 5)

####
# b)
# When are users most active in making requests? Choose an appropriate 
# visualization method.
#### 

# One way to visualize the distribution of requests over time is to plot a 
# histogram of the datetime variable.
hist(epadata$datetime, breaks = 25,
     main = "User Requests Over Time", xlab = "Date & Time")
# It seems most requests occur in the evening (of Wednesday, August 29, 1995) and
# by far the fewest requests are registered in the early morning hours.

####
# c)
# How many unique users are registered in the data? Are there very active users?
# How many users account for 80% of the requests?
####

# Get the length of the vector of unique host IDs to see that the web server log
# counts 2333 active users.
length(unique(epadata$host))

# Plot the sorted frequency table of users.
host_tab <- sort(table(epadata$host), decreasing = TRUE)
plot(host_tab, main = "Activity of Unique Users",
     ylab = "Number of Requests by User") 
# The graph indicates an anti-logarithmic pattern, suggesting that only a few 
# users account for the majority of transactions.

# Compute an empirical cumulative distribution function to analyze how many users
# account for a majority of the activity
host_cdf <- ecdf(cumsum(host_tab) / sum(host_tab))
host_cdf(0.8) 
# Only 40% of users account for 80% of transactions. 
# Plot the cumulative distribution function.
plot(host_cdf, main = "Requests by Unique Users",
     xlab = "Total Requests (%)", ylab="Unique Users (%)")
# Add a vertical and horizontal line to visualize the proportion of users 
# responsible for 80% of requests.
abline(v = 0.8)
abline(h = host_cdf(0.8))

####
# d)
# To prepare for the sequence analysis, the data set must be adjusted. First,
# order the requests according to host (primary key) and timestamp (secondary 
# key). Then, calculate the time gap between requests to determine individual 
# sessions. Take 15 minutes of inactivity as the cutoff value. Please add 3 new 
# variables to the data set, one for the time difference, one conveying whether a
# request is part of a new session, and one giving a running total of the overall
# number of sessions. 
####

# Since order() returns the order of elements in an object, it can be used to 
# index a data set and thereby order it in the desired way.
x <- c(1,4,2)
order(x)
# In x, the first element is also the first when ordering the vector. The second
# element (4), however, is actually the third element in the ordered version.
x[order(x)]
# Indexing x with the vector of order assignments changes the order of the 
# elements accordingly.

# Create a new data set, ordering requests first by host and then by the time.
# In the square brackets, the first index specifies the row orders and the second
# (empty) index after the comma defines that all columns/variables should be 
# taken.
epadata_ord <- epadata[order(epadata$host, epadata$datetime),]
View(epadata_ord)

# Calculate the time elapsed between requests in minutes by comparing the time-
# stamp of each row (request) to the timestamp of the previous row (request).
# Store the result in a new variable where the first value is NA, since no
# difference can be calculated for the first request.
epadata_ord$timediff <- 
  c(NA, 
    as.numeric(epadata_ord$datetime[2:nrow(epadata_ord)] - 
                 epadata_ord$datetime[1:(nrow(epadata_ord)-1)], units = "mins"))

# A new session starts either as soon as a new host makes the request, or the 
# same host makes a request after more than 15 minutes of inactivity. Of course,
# the first row in the data set itself is also a new session, it is the first
# session.
# Create a new variable that indicates whether a row constitutes a new session.
epadata_ord$newsession <- NA
# As specified, the first row is a new session, by definition.
epadata_ord$newsession[1] <- TRUE

# Use an ifelse(test, yes, no) statement to determine for each other request
# whether it constitutes a new session. The test checks whether the hosts differ.
# If this is the case, then the corresponding value in the newsession variable
# is set to TRUE. If not, the time elapsed since the last request is compared to
# the specified cutoff of 15 minutes.
epadata_ord$newsession[2:nrow(epadata_ord)] <- 
  ifelse(epadata_ord$host[2:nrow(epadata_ord)] != 
           epadata_ord$host[1:(nrow(epadata_ord)-1)],     # test: different host?
         TRUE,                                            # yes: TRUE
         epadata_ord$timediff[2:nrow(epadata_ord)] >= 15) # no: compare time                                 

# Print the first 16 rows and specified 3 variables of the data to see that 
# host10 is active in 2 sessions. The first starts at 11:07, the second begins at
# 11:32 after a 20 minute break of inactivity.
epadata_ord[1:16, c("host", "datetime", "newsession")]

# Create a third new variable sessionnum that gives a running total.
epadata_ord$sessionnum <- cumsum(epadata_ord$newsession)

# Since the time difference computed in comparison to another host's request is 
# not reasonable, clean the timediff variable by assigning missing values (NA) to
# the start of every new session. Remember TRUE is stored as 1 internally in R.
epadata_ord$timediff[epadata_ord$newsession == 1] <- NA

# Again, visualize the first 16 rows and include all three new variables.
epadata_ord[1:16, c("host", "datetime", "timediff", "newsession", "sessionnum")]

####
# e)
# How many unique sessions are there? What is the average number of requests per
# session?
####

# The unique number of sessions is given either by the sum of all new sessions,
sum(epadata_ord$newsession)
# or the final running total (maximum value).
max(epadata_ord$sessionnum)
# There are 3314 unique sessions.

# Simply dividing the total number of requests by the total number of sessions
# is a rather imprecise measure.
nrow(epadata_ord) / sum(epadata_ord$newsession)

# Instead, it is better to consider the distribution of requests across sessions.
# The function rle() counts the number of sequential occurrences of a specific
# session number.
session_length <- rle(epadata_ord$sessionnum)$length
# A frequency table shows that 357 sessions consist of only 1 request, while the 
# most common number of requests per session seems to be 7.
table(session_length)
# The summary shows the average number of requests calculated earlier. But, there
# is a positive skew in the data, fewer requests are more common and the mean is 
# affected by the few high outliers. The median number of requests is far lower.
summary(session_length)
# Positive skew is also visible in the graph.
plot(table(session_length), 
     main = "Distribution",
     xlab = "Number of Requests per Session", ylab = "Number of Sessions")

####
# f)
# Create a subset of the ordered EPA data to include only HTML pages that are 
# among the 20 most popular pages. 
####

# There are 6565 unique pages in the EPA data.
length(unique(epadata$page))
# To simplify the analysis, only focus on the 20 most popular pages. 
top_pages <- names(head(sort(table(epadata$page[epadata$pagetype == "html"]),
                             decreasing = TRUE), 20))
# Use this list of top pages to subset the ordered data to only include requests
# for these 20 html pages.
epadata_html20 <- subset(epadata_ord, pagetype == "html" &
                           page %in% top_pages)
# 2432 requests fulfill these two criteria.

####
# g)
# For later calculations, the data should be reformatted so that each session is 
# stored in a single line. To do so, first create a list with separate elements
# for each session and remove all sessions consisting of a single request. Then,
# add end states to each session and reformat to have individual lines for each 
# session.
####

# Split the data according to the session so that it is in form of a list with a 
# separate element for each session.
epadata_session <- split(epadata_html20, epadata_html20$sessionnum)

# Remove sessions consisting of a single request.
htmlsession_length <- lapply(epadata_session, nrow)
epadata_session <- epadata_session[htmlsession_length > 1]
# 521 sessions are in the final reformatted subset.

# Unlist this object and append end states to get individual lines per session.
# Each line should name the host, page sequence and end state.
epadata_lines <- unlist(lapply(epadata_session,
                               function(x)
                                 paste0(unique(x$host), ",",
                                        paste0(unlist(x$page), collapse = ","),
                                        ",END")))
# For example, session 13 contains requests made by host1006. The user's session
# consists of 3 requests (What's New, Offices twice) before ending.
head(epadata_lines, 4)

#### 
# h)
# Estimate the Markov Chain using fitMarkovChain( ). In order to do so, import 
# the data from the previous task into a clickstream object.
####

# Write the data to a temporary file and import it as a clickstream object
click_tempfile <- tempfile()
writeLines(epadata_lines, click_tempfile)
epa_lines <- readClickstreams(click_tempfile, header = TRUE)
# Check the first 4 rows to see that the data conversion worked as intended.
head(epa_lines, 4)

# Fit a Markov Chain to the data so that the next state only depends on the 
# current stage.
epa_mc <- fitMarkovChain(epa_lines, order = 1)
# Print the observed transition matrix.
epa_mc@transitions
# Note the difference to Exercise 4: here, we read column (t) to row (t-1). For 
# example, users go from the Info page to the News page with 10%. 8% of users on
# the News page transition to the Info page.

####
# i)
# Visualize the transition matrix in a heat map using the package superheat.
####

# Transpose the transition matrix to read row to column for simplicity.
epa_mc_trans <- t(epa_mc@transitions[[1]])
# Since the layout of the heat map is determined partially at random, set the 
# random number seed to ensure consistency.
set.seed(59911)
# Plot the heat map, removing the first row (contains transitions from END).
superheat(epa_mc_trans[-1, ],                
          bottom.label.size = 0.4,
          bottom.label.text.size = 3.5,
          bottom.label.text.angle = 270,
          left.label.size = 0.3,
          left.label.text.size = 4,
          heat.col.scheme = "red", 
          n.clusters.rows = 5, n.clusters.cols = 5,
          left.label = "variable", bottom.label = "variable", 
          title = "Transition Matrix in Sequences of Top 20 HTML Pages")
# Most obvious pattern suggests most users visit the efhome page after the major
# docs and Software page. 

# Alternatively use a regular graph layout and restrict to those transitions that
# occur with at least 25% probability.
set.seed(70510)
plot(epa_mc, minProbability = 0.25)
# This graph shows the association between pages and common transition paths.

####
# j)
# Use the transition likelihoods to predict the next page request in session 110. 
# Similarly, predict the next two likely pages for session 160.
####

# Session 110 gives the event sequence of host1439
epa_lines[110]
# Store the sequence in a new clickstream object, keeping all individual requests
# of the session except for the last (the END).
epa_pred <- new("Pattern", sequence = head(unlist(epa_lines[110]), -1))
# Use the fitted Markov Chain to predict the next likely page.
predict(epa_mc, epa_pred, dist = 1)
# The next page is most likely the Rules page (29%).

# Do the same for session 160, but predict the next 2 pages.
epa_lines[160]
epa_pred <- new("Pattern", sequence = head(unlist(epa_lines[160]), -1))
predict(epa_mc, epa_pred, dist = 2)
# With 10% probability the sequence continues with the Rules page before reaching
# the end state.

