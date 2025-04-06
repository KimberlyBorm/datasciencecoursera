simulate 40 exponential random variables.
expDis <- rexp(40, rate = 0.2)
mean(expDis)
sd(expDis)
summary(expDis)

#design simulation

# first simulation (40 exponesntial random variables)
        set.seed(123)
        expDis <- rexp(40, rate = 0.2)
        print(expDis)
        mean(expDis)
        var(expDis)
#perform the simulation 1000 times for the mean
        set.seed(123)
        avg_values <- replicate(1000, mean(rexp(40, rate = 0.2)))
        head(avg_values)
        mean(avg_values)
#perform the simulation 1000 times for the variance
        set.seed(123)
        var_values <- replicate(1000, var(rexp(40, rate = 0.2)))
        head(var_values)
        mean(var_values)

#visualizing the distributions
        # Histogram for raw exponential values
        hist(expDis, 
             main = "Histogram of 1000 Exponential Values", 
             xlab = "Exponential Value", 
             col = "lightblue")
        #overlay the theoretical exponential density curve
        curve(dexp(x, rate = lambda), add = TRUE, col = "red", lwd = 2)
        
        hist(expDis, probability = TRUE, 
             main = "Histogram of 1000 Exponential Values", 
             xlab = "Exponential Value", 
             col = "lightblue",
             xlim = c(0, quantile(expDis, 0.99)))
        
        # Overlay the theoretical exponential density curve over the same x-range
        curve(dexp(x, rate = lambda), 
              from = 0, 
              to = quantile(expDis, 0.99),
              add = TRUE, 
              col = "red", 
              lwd = 2)

        # Plot the histogram of sample means with density scaling
        hist(sim_means, probability = TRUE,
             main = "Histogram of 1000 Sample Means (n = 40)",
             xlab = "Sample Mean",
             col = "lightgreen")
        
        # Overlay the theoretical normal density curve
        curve(dnorm(x, mean = theoretical_mean, sd = sqrt(theoretical_mean_var)),
              from = min(sim_means), to = max(sim_means),
              add = TRUE, col = "red", lwd = 2)        
        