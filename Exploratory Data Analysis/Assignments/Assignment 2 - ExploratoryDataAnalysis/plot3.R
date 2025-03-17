#3) Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) 
#variable, which of these four sources have seen decreases in emissions from 1999–2008 
#for Baltimore City? Which have seen increases in emissions from 1999–2008? 
#Use the ggplot2 plotting system to make a plot answer this question.


# Four scatter plots w/ trend line for total emissions by year by type
#plots show that all decrease over time except "point" type 
#which increases most in 2002 and 2005 and then decreases in 2008

#load packages
library(dplyr)
library(ggplot2)
#open file device
png(filename = "plot3.png", width = 480, height = 480)
#group data by year and type to sum total emissions each year and type
baltimore_sumbytype <- baltimore %>%
    group_by(year, type) %>%
    summarise(total_Emissions = sum(Emissions))
#create ggplot using summary data with facets by type to create 4 plots and tread line
ggplot(baltimore_sumbytype, aes(x= as.numeric(year), y = total_Emissions, color = type))+
    facet_wrap(~type)+
    geom_point(size = 2)+
    geom_smooth(method = "lm", se = FALSE, lwd = .5)+
    labs(title = "Total Emmissions in Baltimore City by Type", 
         x = "Year", y = "Total PM2.5")
#close file device 
dev.off()
