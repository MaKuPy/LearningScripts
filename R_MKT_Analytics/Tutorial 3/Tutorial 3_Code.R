#################################################################################
#################################################################################
# Marketing Analytics
# Tutorial 3: Market Analytics
#################################################################################
#################################################################################

#################################################################################
# Set up
#################################################################################

# load required packages
# install.packages("arules")
library(arules) # to analyze transaction data using association rules
# install.packages("arulesViz")
library(arulesViz) # for visualizing association rules
# install.package("cluster")
library(cluster) # for cluster analysis
# install.packages("mclust")
library(mclust) # for model-based clustering
# install.packages("poLCA")
library(poLCA) # for categorical (polytomous) LCA
# install.packages("e1071") 
library(e1071) # for Naive Bayes classification
# install.packages("randomForest")
library(randomForest) # for random forest classification
# install.packages("psych")
library(psych) # for Cohen's Kappa

# set working directory to the desired folder
getwd()
# setwd("INSERT FILE PATH HERE")

#################################################################################
# Part A) Market Basket Analysis
#################################################################################

# set of items: a group of one or more items, e.g {pasta} or {pasta, sauce, 
# parmesan}
# rule: association of one set of items (e.g. sauce) conditional on another (e.g.
# pasta), so {sauce} -> {pasta} or {sauce, parmesan} -> {pasta, wine, tiramisu}

# support: proportion of all transactions that contain some set, e.g. 
# support({pasta, wine}) = 0.05 if 10 out of 200 transactions contain this set

# confidence(x -> y) = support(x and y)/support(x), e.g. confidence({sauce} -> 
# {pasta}) = support({sauce, pasta})/support({sauce}) = 0.005/0.01 = 0.5 or pasta 
# occurs alongside sauce in 50% of the cases that sauce occurs in a transaction

# lift(x -> y) = support(x and y)/[support(x)*support(y)], e.g. lift({sauce} ->
# {pasta}) = support({sauce, pasta})/[support({sauce})*support({pasta})] = 0.005/
# (0.01*0.01) = 50

#################################################################################
# Exercise 1

# We will use a real data set of a supermarket that contains more than 80.000 
# market basket transactions over more than 16.000 unique items. 

# First, download the transaction data.
retail_raw <- readLines("http://fimi.ua.ac.be/data/retail.dat")  
# Inspect the data, e.g. by taking a closer look at the first and last 5 baskets.
summary(retail_raw)
head(retail_raw, 5)
tail(retail_raw, 5)

####
# a) 
# First, convert the raw data into a list, where each element contains the items 
# of a single market basket. Then, the resulting list can be transformed to a 
# formal transactions object, as required for the analysis of association rules. 
# How many unique items does the supermarket offer? What is the most popular item? 
# What are the sizes of the smallest, largest, and median market basket?
####

# Convert the raw character data into a list of individual character vectors, one
# for every observed transaction.
retail_list <- strsplit(retail_raw, " ")
# Assign descriptive names to label the individual market baskets.
names(retail_list) <- paste("Transaction", 1:length(retail_list), sep=" ")
# Inspect the new transformed data.
str(retail_list)

# A formal transaction object improves the possibilities of working with this 
# type of data, speeding up the operations of the arules package.
retail_transactions <- as(retail_list, "transactions")
# Inspect the resulting transaction object.
summary(retail_transactions)
# The object is a matrix with 88.162 rows (transactions) and 16.470 columns
# (items). The low density (0.06%) suggests that the majority of items are not
# included in most of the market baskets. Item 39 is purchased most frequently.
# 3016 transactions consist of only a single item, the median basket size is 8,
# and the largest purchase was for 76 different items.

####
# b) 
# Use apriori( ) to find association rules in the transaction data. Consider 
# tuning the parameters so that the results only consider sets found in at least 
# 0.1% of transactions. Also, confidence should be at least 0.4. 
# Plot rule confidence against support and interpret the graph.
####

# Set the thresholds for support and confidence as specified by the text.
retail_rules <- apriori(retail_transactions, 
                        parameter = list(supp = 0.001, conf = 0.4))
# 5944 rules fulfilling the defined criteria are found.

plot(retail_rules)
# Graph with support on the x-axis, confidence on the y-axis, and lift reflected
# in the color of the data points suggests that support is generally low, while
# confidence seems distributed quite evenly.

####
# c) 
# Extract the 50 rules with the highest lift, inspect and plot them separately. 
####

# A combination of head() and sort() is useful to take only those 50 rules with
# the highest lift.
retail_rules_50high <- head(sort(retail_rules, by = "lift"), 50)
inspect(retail_rules_50high)
# Support and lift are defined for item sets and therefore have the same value
# for rule 1 & 2, but confidence reflects the direction so that its values differ.
# The identical lift value only holds for rules over two items.

# A graphical review of the data can uncover higher level patterns. Graph method 
# visualizes the rules (circles) by displaying arrows pointing to the rule from 
# items on the left side and then arrows directed to the items on the right side.
plot(retail_rules_50high, method = "graph")
# Darker red indicates a higher lift, larger circles more support. There seem to
# be four distinct set of rules in the transaction data set.

#### 
# d)
# To determine the profitability of transactions, simulate margins for each of 
# the items included in the transaction data. Do so by drawing randomly from the
# N(0.3, 0.3) distribution and storing the results in a separate data frame. 
# What is the supermarket's margin for a purchase containing the items 696 and 
# 699? What is the margin achieved through the 100th transaction in the data set?
####

# Find the 16.470 unique item names in the list of transactions and store them in
# a separate object.
retail_itemnames <- unique(unlist(retail_list))
# Inspect the result.
head(retail_itemnames)
tail(retail_itemnames)

# Simulate the margins for each of the items by sampling from the normal 
# distribution with mean = 0.3 and standard deviation = 0.3. Set the random number 
# seed to ensure consistency. The results are stored in a new data frame.
set.seed(9472)
retail_margin <- data.frame(margin = rnorm(n = length(retail_itemnames), 
                                           mean = 0.3, sd = 0.3))
# Set the rownames of the data frame to correspond to the item names.
rownames(retail_margin) <- retail_itemnames
# Inspect the result.
head(retail_margin)
tail(retail_margin)

# Use the item name to index the margin data frame and find the corresponding
# margins.
retail_margin[c("696", "699"),]
sum(retail_margin[c("696", "699"),])
# The total margin of a market basket containing item 696 and 699 is given by
# 1.63. The margin for item 696 is much larger than for item 699.

# Use the list of transactions to find the names of the items purchased in the 
# 100th transaction. The resulting vector shows this purchase covered 12 items.
basket_items <- retail_list[[100]]
# Use the character vector of included items to index the margin data frame and
# find the corresponding margins.
retail_margin[basket_items,]
sum(retail_margin[basket_items,])
# The total margin of the market basket observed in transaction 100 is 2.42.

#################################################################################
# Exercise 2

# We will use a simulated data set of a subscription-based service that contains 
# consumer segment assignments and demographic information of respondents.

# First, download the transaction data.
segdata <- read.csv("http://goo.gl/qw303p", stringsAsFactors = TRUE)
# Take a look at the included variables and the number of observations.
summary(segdata)
str(segdata)

#### 
# a)
# Convert the numeric variables in the data set to ordered factor types instead. 
# More specifically, age should have 5 levels: 19 - 24, 25 - 34, 35 - 54, 55 - 64, 
# and 65+, income 3: Low (<40.000), Medium (40.000 - 70.000), and High (70.000+), 
# and kids should have 4 levels: None, 1, 2, and 3+.
####

# Use cut(data, breaks, labels) to recode the numeric values into ordered factors
# where breaks specifies the cut-off points and labels gives the corresponding
# category name.
# Age should be an ordered factor with 5 levels, as described in the text. 
# Setting right = FALSE ensures the intervals are closed on the left [ , ).
segdata$age <- cut(segdata$age, breaks = c(0, 25, 35, 55, 65, 100), 
                   labels = c("19-24", "25-34", "35-54", "55-64", "65+"), 
                   right = FALSE, ordered_result = TRUE)
# Income should be an ordered factor with 3 levels, as described in the text.
segdata$income <- cut(segdata$income, breaks = c(-100000, 40000, 70000, 1000000),
                      labels = c("Low", "Medium", "High"),
                      right = FALSE, ordered_result = TRUE)
# Kids should be an ordered factor with 4 levels, as described in the text.
segdata$kids <- cut(segdata$kids, breaks = c(0, 1, 2, 3, 100),
                    labels = c("None", "1", "2", "3+"),
                    right = FALSE, ordered_result = TRUE)
summary(segdata)

#### 
# b)
# Use apriori( ) to find association rules in the segment data. Consider tuning
# the parameters so that the results only consider sets found in at least 10% of 
# transactions. Also, confidence should be at least 0.4. 
# Plot rule confidence against support and interpret the graph. 
####

# A formal transaction object improves the possibilities of working with this 
# type of data, speeding up the operations of the arules package.
seg_transactions <- as(segdata, "transactions")
# Inspect the resulting transaction object.
summary(seg_transactions)
# The object is a matrix with 300 rows (respondents) and 22 columns. Density is 
# 0.32. Non-subscribers are observed most frequently. Since the 7 variables are 
# captured for all respondents, the size of each "transaction" is always 7.

# Set the thresholds for support and confidence as specified by the text.
seg_rules <- apriori(seg_transactions, parameter = list(supp = 0.1, conf = 0.4))
summary(seg_rules)
# 579 rules fulfilling the defined criteria are found.

plot(seg_rules)
# Graph with support on the x-axis, confidence on the y-axis, and lift reflected
# in the color of the data points suggests that some rules (top left corner) have
# very high confidence.

####
# c) 
# Extract the 35 rules with the highest lift, inspect and plot them separately. 
####

# A combination of head() and sort() is useful to take only those 35 rules with
# the highest lift.
seg_rules_35high <- head(sort(seg_rules, by = "lift"), 35)
inspect(seg_rules_35high)

# A graphical review of the data can uncover higher level patterns. Graph method 
# visualizes the rules (circles) by displaying arrows pointing to the rule from 
# items on the left side and then arrows directed to the items on the right side.
plot(seg_rules_35high, method = "graph")
# Darker red indicates a higher lift, larger circles more support. There seem to
# be two dominant clusters of rules.

####
# d)
# Find only those association rules with the Urban hip segment on the right side. 
# Also, lift should be at least 1. Sort the rules according to lift.
####

# %pin% as a binary operator from arules to partially match items and create a 
# subset containing only those association rules with the Urban hip segment on
# the right side and a lift of at least 1.
seg_rules_subset <- subset(seg_rules, subset = (rhs %pin% "Urban" & lift > 1))
inspect(seg_rules_subset)
# Sort the rules with urban hip segment on the right side by lift.
inspect(sort(seg_rules_subset, by = "lift"))

#################################################################################
# Part B) Segmentation
#################################################################################

# We will use a simulated data set that contains customer relationship management
# (CRM) data of a music subscription service.

# First, download the music data.
musicdata_raw <- read.csv("https://goo.gl/s1KEiF", stringsAsFactors = TRUE)
# Take a look at the included variables and the number of observations.
summary(musicdata_raw)
str(musicdata_raw)

#################################################################################
# Exercise 3

####
# a) 
# Inspect the data set and create a copy that does not contain the respondent's 
# segment information. Use this copy for the following tasks.
####

# Create a copy and remove the known segment assignment for the following tasks.
musicdata <- musicdata_raw
musicdata$Segment <- NULL
summary(musicdata)

# Use the different segment types to group the data and compute the means for all 
# variables. Transform any non-numeric variables for the calculation.
aggregate(musicdata, by = list(musicdata_raw$Segment), 
          FUN = function(x) mean(as.numeric(x)))
# Sex = 1 for Female, = 2 for Male
# subscribeToMusic = 1 for subNo, = 2 for SubYes

####
# b)
# Apply hierarchical clustering (hclust) to find groups in the data set and 
# visualize the result. Based on this, what do you think is an appropriate number 
# of segments? Do you find this result useful? 
####

# Use daisy() to compute the dissimilarity matrix reporting the distances between
# the pairs of observations, since musicdata does not contain only numeric data.
music_dist <- daisy(musicdata)
# Print the top left corner (5x5) of the resulting matrix to check whether it is
# reasonable (symmetric, 0 on diagonal, and values ranging 0 - 1).
as.matrix(music_dist)[1:5, 1:5]

# Use this distance matrix as input for the hierarchical cluster method which 
# uses the complete linkage method, comparing distances between all group members.
music_hclust <- hclust(music_dist, method = "complete")

# Visualize using a dendrogram.
plot(music_hclust)
# Can zoom in on certain sections of the chart, first coercing to a dendrogram 
# object, then selecting the height at which to cut off and finally listing which 
# of the resulting branches to consider. 
plot(cut(as.dendrogram(music_hclust), h = 0.4)$lower[[1]])
# Consider only the first branch from the left, up to a maximum distance of 0.4. 
# Respondent 853 and 864 seem very similar, but rather different from 866.
musicdata[c(853, 864, 866),]

# The cophenetic correlation coefficient (CPCC) is one goodness-of-fit measure,
# comparing the dendrogram with the true distance metric. Use cophenetic() to get
# the distances from the dendrogram.
cor(cophenetic(music_hclust), music_dist)
# CPCC > 0.7 indicates a relatively strong fit. 

# Use rect.hclust() to lay possible cluster solutions over the dendrogram.
plot(music_hclust)
rect.hclust(music_hclust, k = 4, border = "green")
# Use cutree() to get the corresponding assignment vector.
music_hclust_segment <- cutree(music_hclust, k = 4)
table(music_hclust_segment)
# Cluster 1 is the largest, cluster 4 is far smaller.
aggregate(musicdata, by = list(music_hclust_segment), 
          FUN = function(x) mean(as.numeric(x)))
# Sex = 1 for Female, = 2 for Male
# subscribeToMusic = 1 for subNo, = 2 for SubYes

# Compare whether respondents commute by car and subscribe to the music service
# by including the cluster assignment as color in the graph. Since the variables
# can only take on two values each, jitter is used to add some random noise
# making each data point visible.
plot(jitter(as.numeric(musicdata$commuteCar)) ~ 
       jitter(as.numeric(musicdata$subscribeToMusic)), 
     col = music_hclust_segment,
     ylab = "commuteCar", xlab = "subscribeToMusic")
# commuteCar = 0 for no, = 1 for yes
# subscribeToMusic = 1 for subNo, = 2 for SubYes
# The groups are rather unbalanced.

#### 
# c)
# Instead, use mean-based clustering (kmeans) to find four groups in the data. Do 
# you find these results useful? To illustrate, plot two continuous variables by 
# segment.
####

# Means-based clustering requires numeric data to compute the Euclidean distance.
# Create a copy and turn the 2 dummy factors into numeric variables using ifelse(
# test, yes, no).
musicdata_num <- musicdata
musicdata_num$sex <- ifelse(musicdata_num$sex == "Female", 0, 1)
musicdata_num$subscribeToMusic <- ifelse(musicdata_num$subscribeToMusic == "subNo", 
                                         0, 1)
summary(musicdata_num)

# Run mean-based clustering using kmeans() and specifying the desired number of 
# groups (centers). The cluster object of the resulting list gives the assignments.
set.seed(2782)
music_kmeans <- kmeans(musicdata_num, centers = 4)
aggregate(musicdata, by = list(music_kmeans$cluster), 
          FUN = function(x) mean(as.numeric(x)))
# Sex = 1 for Female, = 2 for Male
# subscribeToMusic = 1 for subNo, = 2 for SubYes

# For example, plot income by cluster segment.
boxplot(musicdata_num$householdIncome ~ music_kmeans$cluster,
        ylab = "Income", xlab = "Cluster Assignment")
# Alternatively, consider age which has somewhat more of an overlap between
# groups.
boxplot(musicdata_num$age ~ music_kmeans$cluster,
        ylab = "Age", xlab = "Cluster Assignment")

#### 
# d)
# Plot the clusters found in c) by their principal components with clusplot() and 
# interpret the graph.
####

# The argument color gives each cluster a different color and shade ensures that 
# the corresponding areas are filled in, as well. Setting labels = 4 will only 
# give labels to the 4 groups and lines = 0 omits distance lines between the 
# clusters.
clusplot(musicdata_num, music_kmeans$cluster, color = TRUE, shade = TRUE,
         labels = 4, lines = 0, main = "Plot of k-means Clusters")
# Cluster 3 is nearly entirely contained by either cluster 4 or cluster 1. All 4
# clusters have some overlap.

#################################################################################
# Exercise 4 

####
# a)	
# Apply model-based clustering (mclust) to find groups in the data set and 
# visualize the result. What is the suggested number of clusters and are they 
# well-differentiated? Compare to the mean-based solution from 3c).
####

# Mclust() estimates an appropriate model. Since it assumes normal distributions,
# this approach can only use numeric data.
set.seed(424645)
music_mbased <- Mclust(musicdata_num)
summary(music_mbased)
# The summary suggests the data set consists of 3 different clusters.

aggregate(musicdata, by = list(music_mbased$classification), 
          FUN = function(x) mean(as.numeric(x)))
# Sex = 1 for Female, = 2 for Male
# subscribeToMusic = 1 for subNo, = 2 for SubYes

clusplot(musicdata_num, music_mbased$classification, color = TRUE, shade = TRUE,
         labels = 4, lines = 0, main = "Plot of Model-based Clusters")
# Cluster 2 is entirely included in cluster 1, so it seems that perhaps driving
# behavior provides the greatest differentiation.

####
# b)	
# Fit a model-based solution by pre-specifying the number of clusters (G = 2 and 
# G = 4). Compare both results to the suggestion from a).
####

# Set the G argument to specify the desired number of clusters in advance.
music_mbased_2 <- Mclust(musicdata_num, G = 2)
music_mbased_4 <- Mclust(musicdata_num, G = 4)
summary(music_mbased_2) 
summary(music_mbased_4)
# The 3-cluster solution has the highest (least negative) log-likelihood, as well
# as the lowest BIC and hence the strongest evidence based on the data. The 4-
# cluster solution is still preferable to the 2-cluster solution.
BIC(music_mbased, music_mbased_2, music_mbased_4)

####
# c)
# In preparation for latent class analysis, recode all variables to binary 
# factors. Exclude milesDrive and drivingEnthuse. Split the remaining variables 
# at the specified cut-off values: age (<30), householdIncome (<55.000), 
# kidsAtHome (>0), and musicEnthuse (<5).
####

# LCA requires categorical data. Create a copy and transform the variables to
# binary factors as specified using ifelse(test, yes, no).
musicdata_lca <- musicdata
musicdata_lca$milesDrive <- NULL
musicdata_lca$drivingEnthuse <- NULL
musicdata_lca$age <- factor(ifelse(musicdata_lca$age < 30, 
                            "YoungerThan30", "Over30"))
musicdata_lca$householdIncome <- factor(ifelse(musicdata_lca$householdIncome < 55000, 
                                        "LessThan55k", "Over55k"))
musicdata_lca$kidsAtHome <- factor(ifelse(musicdata_lca$kidsAtHome > 0, 
                                   "Kids", "NoKids"))
musicdata_lca$musicEnthuse <- factor(ifelse(musicdata_lca$musicEnthuse < 5, 
                                        "NoEnthusiast", "Enthusiast"))
musicdata_lca$commuteCar <- factor(musicdata_lca$commuteCar, 
                                   labels = c("noCar", "CarCommute"))
summary(musicdata_lca)

####
# d)
# Fit categorical LCA (poLCA) with both 3- and 4-class solutions to the data set 
# and visualize the results. Discuss the differences in respondent assignment 
# based on the two solutions and compare their usefulness.
####

# Set the random number seed.
set.seed(23532)
# Model the dependent variables (all columns) with respect to the model 
# intercepts (cluster positions). Estimate using poLCA().
music_LCA_3 <- poLCA(cbind(age, sex, householdIncome, kidsAtHome, commuteCar, 
                           musicEnthuse, subscribeToMusic) ~ 1, 
                     data = musicdata_lca, nclass = 3)
music_LCA_4 <- poLCA(cbind(age, sex, householdIncome, kidsAtHome, commuteCar, 
                           musicEnthuse, subscribeToMusic) ~ 1, 
                     data = musicdata_lca, nclass = 4)
music_LCA_3$bic
music_LCA_4$bic
# Lower BIC suggests the 3-cluster solution is preferable.

# Compare the resulting cluster solutions in more depth.
aggregate(musicdata, by = list(music_LCA_3$predclass), 
          FUN = function(x) mean(as.numeric(x)))
aggregate(musicdata, by = list(music_LCA_4$predclass), 
          FUN = function(x) mean(as.numeric(x)))
# Sex = 1 for Female, = 2 for Male
# subscribeToMusic = 1 for subNo, = 2 for SubYes

clusplot(musicdata, music_LCA_3$predclass, color = TRUE, shade = TRUE,
         labels = 4, lines = 0, main = "Plot of LCA Clusters (K = 3)")
clusplot(musicdata, music_LCA_4$predclass, color = TRUE, shade = TRUE,
         labels = 4, lines = 0, main = "Plot of LCA Clusters (K = 4)")
# It seems the 4-cluster approach neatly splits one cluster from the 3-cluster 
# model (#1), as is also visible in the following table.
table(music_LCA_3$predclass, music_LCA_4$predclass)

#################################################################################
# Exercise 5 

####
# a)
# Split the initial data set that includes segment assignment into a training 
# (65%) and test (35%) set. 
####

# Set the random number seed.
set.seed(2806)
# Randomly select 65% of the respondents. Remember to use the original raw data
# that includes the segment assignment.
train_sample <- sample(x = nrow(musicdata_raw), size = nrow(musicdata_raw)*0.65)
# Use the chosen 581 rows to index and separate the data into a traning and test
# set.
music_train <- musicdata_raw[train_sample,]
music_test <- musicdata_raw[-train_sample,]

# A comparison of the segments suggests the two data sets are suitably similar.
aggregate(music_train, by = list(music_train$Segment), 
          FUN = function(x) mean(as.numeric(x)))
aggregate(music_test, by = list(music_test$Segment), 
          FUN = function(x) mean(as.numeric(x)))

####
# b)
# Fit a Naïve Bayes model to predict segment membership based on all of the 
# included variables in the training data set. Assess model performance on the 
# test data comparing its performance to chance.
####

# Set the random number seed.
set.seed(95173)
# Use naiveBayes() from the e1071 package to fit an appropriate model and predict
# segment membership. Use all possible variables as predictors.
music_naive <- naiveBayes(Segment ~ ., data = music_train)
music_naive
# The model output gives the a-priori likelihood of membership, as well as the 
# conditional probabilities.

# Predict segment membership for the test data set and review the resulting 
# segment frequencies.
music_naive_class <- predict(music_naive, music_test)
prop.table(table(music_naive_class))
# Compare to the a-priori likelihoods.
prop.table(music_naive$apriori)

# Plot the predicted clusters for the test data set. The group labels are now 
# given by the corresponding segment.
clusplot(music_test[, -10], music_naive_class, color = TRUE, shade = TRUE,
         labels = 4, lines = 0, main = "Plot of Naive Bayes Classes (Test)")

# Three steps to assess model performance on the test data and compare the 
# prediction to the known segment assignment.
# First, consider the raw agreement rate.
mean(music_test$Segment == music_naive_class) 
# Second, compare performance against random chance (simply assigning each 
# observation to the largest class).
# ARI ranges from -1 to 1, where 0 equals random assignment.
adjustedRandIndex(music_naive_class, music_test$Segment) 
# Third, assess performance for each different class.
table(music_test$Segment, music_naive_class)
# The confusion matrix shows that most classes are predicted quite well. Mainly,
# the prediction for the Quiet segment seems difficult due to the overlaps with 
# CommuteNews and KidsAndTalk.

# Instead of returning only the predicted class, it is also possible to obtain the
# estimated odds of respondent membership for each possible class. Set the predict
# type accordingly.
head(predict(music_naive, music_test, type = "raw")) 
tail(predict(music_naive, music_test, type = "raw")) 
# Prediction seems fairly certain that the first 6 respondents belong to the
# CommuteNews segment, while the last 6 have a very high probability of belonging
# to LongDistance.

####
# c)
# Instead, fit a random forest model to predict segment membership. What is the 
# out-of-bag error rate? Assess model performance on the test data comparing its
# performance to chance.
####

# Set the random number seed.
set.seed(5839)
# Use randomForest() to fit an appropriate model and predict segment membership. 
# Use all possible variables as predictors and specify the number of trees to fit.
music_rf <- randomForest(Segment ~ ., data = music_train, ntree = 3000)
music_rf
# Out-of-bag (OOB) error rate is very low at only 1.38%.

# Predict and plot segment membership for the test data set. The group labels are
# now given by the corresponding segment.
music_rf_class <- predict(music_rf, music_test)
clusplot(music_test[, -10], music_rf_class, color = TRUE, shade = TRUE,
         labels = 4, lines = 0, main = "Plot of Random Forest Classes (Test)")

# Three steps to assess model performance on the test data and compare the 
# prediction to the known segment assignment.
# First, consider the raw agreement rate.
mean(music_test$Segment == music_rf_class) 
# Second, compare performance against random chance (simply assigning each 
# observation to the largest class).
# ARI ranges from -1 to 1, where 0 equals random assignment.
adjustedRandIndex(music_rf_class, music_test$Segment) 
# Third, assess performance for each different class.
table(music_test$Segment, music_rf_class)
# The confusion matrix shows that most classes are predicted very well. 

####
# d)
# What variables are most important for the prediction made in c)?
####

# Set the random number seed.
set.seed(5839)
# Use randomForest() to fit an appropriate model and predict segment membership. 
# Use all possible variables as predictors, this time include importance.
music_rf_imp <- randomForest(Segment ~ ., data = music_train, ntree = 3000,
                             importance = TRUE)
# Print the importance of each variable for each of the different classes
# separately.
importance(music_rf_imp)

# Age, miles driven, and the household income are the most important variables in
# this data.
varImpPlot(music_rf_imp, main = "Variable Importance by Segment")

####
# e)
# Now, fit a random forest model to predict subscription status. How well does it
# predict the test data and which variables are most important?
####

# Set the random number seed.
set.seed(10643)
# Use randomForest() to fit an appropriate model and predict whether or not the
# respondent will purchase a subscription. Use all possible variables as
# predictors.
(music_rf_sub <- randomForest(subscribeToMusic ~ ., data = music_train, 
                             ntree = 5000, importance = TRUE))
# Out-of-bag (OOB) error rate is higher at 10.5% and nearly all subscribers (98%)
# are misclassified.

# This class imbalance issue is often met by using the argument sampsize and
# requiring the groups to be the same size.
table(music_train$subscribeToMusic)
# Set the size of each group to 59 which corresponds to the number of subscribers
# in the training data set. Sampling is performed with replacement.
(music_rf_sub_bal <- randomForest(subscribeToMusic ~ ., data = music_train, 
                                  ntree = 5000, importance = TRUE,
                                  sampsize = c(59, 59)))
# OOB error rate is higher overall, but model is more successful at predicting
# subscribers.

# Predict whether respondents are likely to subscribe to the music service for the
# test data set.
music_sub <- predict(music_rf_sub_bal, music_test)

# Compare performance against random chance using ARI.
adjustedRandIndex(music_sub, music_test$subscribeToMusic) 
table(music_test$subscribeToMusic, music_sub)
# The confusion matrix shows that most classes are predicted very well. 
