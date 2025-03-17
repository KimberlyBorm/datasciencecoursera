#1) Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
#Using the base plotting system, make a plot showing the total PM2.5 emission from all 
#sources for each of the years 1999, 2002, 2005, and 2008.

#read in data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
#inspect data
head(NEI)
head(SCC)
str(SCC)
str(NEI)

#Bar Chart Sum Emissions by Year 
#plot shows an overall decrease over time from 1999 to 2008

#load required package
library(dplyr)
#open file device - png
png(filename = "plot1.png", width = 480, height = 480)
#reset preset for scientific notation for better readability
options(scipen = 999)
# sum data with tapply, then create bar graph with base R code
tapply(NEI$Emissions, NEI$year, sum) %>% 
    barplot(., main = "Total U.S. Emissions by Year",
            xlab = "Year",
            ylab = "Total PM2.5",
            col = "wheat"
    )
#close device
dev.off()

