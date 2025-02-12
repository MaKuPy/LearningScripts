#################################################################################
#################################################################################
# Marketing Analytics
# Tutorial 4: Analytics for Customer Management
#################################################################################
#################################################################################

#################################################################################
# Set up
#################################################################################

# no required packages for this tutorial 

# set working directory to the desired folder
getwd()
# setwd("INSERT FILE PATH HERE")

#################################################################################
# Part A) Customer Lifetime Value
#################################################################################

# user-defined functions in R for repeated tasks and less errors
# functionname <- function(arguments){body}
# arguments to provide data and control instructions
# body represents the code to be executed upon function call
# function exit either by returning an error (failure) or a value (success)

#################################################################################
# Exercise 1

# A music subscription service charges its customers 9.99EUR per month. The 
# provider incurs monthly variable costs of 1.20EUR and yearly marketing costs of 
# 8EUR per customer. Reviewing past customer data has shown that 10% of customers 
# churn at the end of each month. Furthermore, customers tend to subscribe to the  
# music service for 6 months. Assume a discount rate of 5%.

####
# a) 
# R offers the opportunity to create a user-defined function of the following
# general form: functionname <- function(arguments){body}
# We use this to define a function that calculates CLV (in the body) based on the 
# provided information (arguments). Assign the function an appropriate name 
# (functionname). Use the function to calculate CLV for customers of the music 
# subscription service.
####

calc_CLV <- function(margin, retention, discountrate, acquisitioncost = 0, time){
  # It is always better to create an output container with the required length in
  # advance rather than growing a vector in a loop. Here, the values calculated
  # for the individual time periods are stored in a numeric vector with one 
  # element for each period.
  res <- vector(mode = "numeric", length = time)
  # A for loop iterates through the time periods (1 - T), calculating each part 
  # of the total CLV sum separately. The assumption made in this exercise is that
  # the first payment occurs in t = 1.
  for(i in 1:time){
    # This term is taken from the CLV formula. The current value of each future
    # period is given by the product of the margin and the retention rate to the
    # power of the current period i, divided by the discount term also to the 
    # power of the current period i.
    res[i] <- margin * retention^i/(1 + discountrate)^i
  }
  # After the loop, vector res has T elements, one for each of the individual 
  # periods within the total specified time. Total CLV is then given by the sum
  # over all these terms minus the acquisition costs for a customer.
  CLV <- sum(res) - acquisitioncost
  # Note that acquisition cost is not a required argument here, since the text
  # does not provide such information. Still, it is kept here for a more general
  # CLV function.
  return(CLV)
}

# Use this function to calculate the lifetime value for a customer of the music
# subscription service, specifying the argument values in accordance with the 
# exercise text.
calc_CLV(margin = (9.99 - 1.2 - 8/12), retention = 0.9, discountrate = 0.05,
         time = 6)
# This function is simply one solution suggestion, there are possible alternative
# specifications that lead to the same correct result, e.g. calculating the
# margin within the function.

####
# b)	
# For the following tasks, first consider the resulting change in CLV 
# theoretically, before using the function from a) to observe the difference.
# Assume the music subscription service is able to reduce its variable costs by
# 0.10EUR per customer. What is the effect of the resulting higher margin on CLV?
####

# In line with intuition, increasing the margin earned with each customer raises
# CLV, ceteris paribus.
calc_CLV(margin = (9.99 - 1.1 - 8/12), retention = 0.9, discountrate = 0.05, 
         time = 6)

####
# c)	
# As the music subscription service improves its interface and thereby ease of 
# use, customers become more attached and tend to subscribe for longer than 6 
# months. They now stick to the service for 1 year on average. How does this 
# affect the CLV?
####

# In line with intuition, increasing the customer lifetime raises CLV, ceteris 
# paribus.
calc_CLV(margin = (9.99 - 1.2 - 8/12), retention = 0.9, discountrate = 0.05, 
         time = 12)
# Since future earnings are discounted, CLV is not simply doubled, even though
# the expected customer lifetime is.

####
# d)	
# Perhaps after initial market skepticism, subscribers become more familiar with
# the music service, now tending to create various playlists, and collecting and 
# organizing most of their favorite tunes within the music service. This behavior 
# leads to only 5% of customers switching to competitors per month. How is this 
# change reflected in the CLV?
####

# In line with intuition, increasing the retention rate raises CLV, ceteris 
# paribus.
calc_CLV(margin = (9.99 - 1.2 - 8/12), retention = 0.95, discountrate = 0.05, 
         time = 6)

####
# e)	
# The discount rate represents the company’s trade-off between current and future 
# margins. Assume the music subscription service is planning to branch out and 
# purchase its own record label. This impending investment effectively increases 
# the cost of capital for the company in the short-term. What is the effect of 
# the new discount rate of 8% on CLV?
####

# The described change in discount rate represents a stronger discounting of
# future earnings. In line with intuition, this reduces CLV, ceteris paribus.
calc_CLV(margin = (9.99 - 1.2 - 8/12), retention = 0.9, discountrate = 0.08, 
         time = 6)

####
# f)
#	Finally, assume the provider incurs a cost of 10EUR for the acquisition of a 
# new customer. This could arise through the introduction of a referral program, 
# for example. How does this change CLV?
####

# Specifying the given acquisition cost will overwrite the default of 0 EUR. In 
# line with intuition, this reduces CLV, ceteris paribus. Note that the reduction
# exactly corresponds to the arising cost which is incurred immediately and 
# therefor not discounted.
calc_CLV(margin = (9.99 - 1.2 - 8/12), retention = 0.9, discountrate = 0.05,
         acquisitioncost = 10, time = 6)

#################################################################################
# Part B) Acquisition vs Retention
#################################################################################

#################################################################################
# Exercise 2

# The music subscription service is considering to spend 60.000EUR on an online
# advertisement campaign that is estimated to reach 90.000 Internet users. 
# Thereby, the firm expects that 1.2% of those users will respond positively to 
# the campaign, taking advantage of the special introductory offer. Assume the 
# CLV of acquired subscribers is 30EUR. Due to the low price of the special offer, 
# the service provider only earns a margin of 5€ on the initial purchase by the
# newly acquired customers.

####
# a)
# Given the provided information, is the planned advertising campaign
# economically attractive for the firm?
####

# prospect lifetime value (PLV) 
# = acquisition rate * (initial margin + CLV) - acquisition cost

# Calculate PLV to determine the economic attractiveness of the proposed
# campaign.
PLV <- 0.012 * (5 + 30) - 60000/90000
# Given the provided information, the PLV is negative, suggesting that the 
# planned acquisition campaign is not profitable.

####
# b)
# What is the minimum acquisition rate required for the planned campaign to be
# economically successful?
####

# The minimum viable acquisition rate is given by setting PLV = 0 and rearranging. 
# 0 = acquisition rate * (5 + 30) - 60000/90000
breakevenacquisition <- (60000/90000) / (5 + 30)
# The acquisition rate must exceed 1.9% in order for the campaign to be 
# successful and PLV > 0.

####
# c)
# Fast-forward to the following year. The music subscription service provider 
# decided to run the campaign and was able to acquire 5.847 new customers this
# way. Furthermore, of the nearly 24.364 subscribers the firm had at the beginning
# of the year, 17.828 remained loyal, not unlikely due to the 25.000€ spent in 
# retention efforts. Compute the average acquisition and retention costs incurred 
# by the firm and discuss.
####

avg_acquisitioncost <- 60000/5847
# The average acquisition cost of a new subscriber to the music service is 
# 10.26EUR.
avg_retentioncost <- 25000/17828
# The average yearly retention cost is 1.40EUR per customer. It costs more than 5
# times as much to acquire a new customer than it does to retain an existing one.

#################################################################################
# Exercise 3

# Over time, the music subscription service has broadened its offer and now
# serves 3 different customer segments (regular, student, and family). Generally,
# all three types of subscribers have access to the same music database, but the 
# specifics differ slightly. 
# First, the average customer tends to subscribe to the service for 5 years,
# earning the firm a monthly 7EUR margin. Due to the referral program, the 
# acquisition of such a new customer costs 10EUR. Next, enrolled students can
# subscribe to the service for a lower monthly cost, generating only a 4EUR
# margin for the firm in each period. This type of customer stays for 4 years on 
# average. In order to receive this lower offer, subscribers must prove their 
# enrollment status and this check costs the music service provider 1ÉUR.
# Finally, the firm also offers a family plan at a higher price (15EUR margin) 
# that allows multiple people in the same household to share an account with 
# different profiles. Market research has shown that this segment generally
# subscribes for a period of 2 years. The specialized advertisements targeting 
# such families leads to an average cost of 5€ per family plan.

####
# a)
# Calculate the lifetime value of a customer in each of the segments separately.
# The cost of capital is 12%. Are all types of subscribers profitable for the 
# firm? Discuss.
####

# The expected lifetime provided in the text can be used to determine the churn 
# rate (= 1 / expected lifetime). Subtracting this value from 1 then gives the
# retention rate.
# An expected lifetime of 5 years leads to 5 * 12 = 60 periods.
regular <- calc_CLV(margin = 7, retention = (1 - 1/60), discountrate = 0.12,
                    acquisitioncost = 10, time = 60)
# The CLV of a regular customer is 40.35EUR.

# An expected lifetime of 4 years leads to 4 * 12 = 48 periods.
student <- calc_CLV(margin = 4, retention = (1 - 1/48), discountrate = 0.12,
                    acquisitioncost = 1, time = 48)
# The CLV of a student is 26.77EUR.

# An expected lifetime of 2 years leads to 2 * 12 = 24 periods.
family <- calc_CLV(margin = 15, retention = (1 - 1/24), discountrate = 0.12,
                   acquisitioncost = 5, time = 24)
# The CLV of a family is 81.81EUR.
# Since all CLVs > 0, each customer type is profitable for the firm.

####
# b)
# Of the 20.000 subscribers, 1/3 are students, 1/6 are families, and the 
# remainder are regular customers. Compute the CLV of each entire segment.
####

# To compute the segment lifetime value, simply multiply the individual CLV by
# the observed segment share among all subscribers.
student * 20000/3
# The CLV of all student subscribers is 178444.70EUR.

family * 20000/6
# The CLV of all family subscribers is 272693.80EUR.

# 1 - 1/3 - 1/6 = 0.5 (half of the subscribers are from the regular segment)
regular * 10000 
# The CLV of all regular subscribers is 403453.80EUR. Although the CLV of a 
# family is double as high, the large share of this segment among all subscribers
# gives it the highest value overall.
