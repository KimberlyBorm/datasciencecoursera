#read in data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

head(NEI)
head(SCC)
str(SCC)
str(NEI)


#create one graphical image that answer each questions (PNG file)
#1) Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
    #Using the base plotting system, make a plot showing the total PM2.5 emission from all 
    #sources for each of the years 1999, 2002, 2005, and 2008.
#load required package
library(dplyr)
#check for NAs
sum(is.na(NEI$Emissions))
# look at summary to see if boxplot is helpful for this question 
tapply(NEI$Emissions,NEI$year, summary)
#create boxplots for each year
boxplot(Emissions ~ as.factor(year), data = NEI) # notive the 3rd Q and Max is very large
#check if suspision that outlinier make the plot ininformative is true
NEI %>% filter(Emissions < 0) %>% str()
#try again with log10 for scale
boxplot(log10(Emissions) ~ as.factor(year), data = NEI)  #suspicion confirmed
#bar plot would be best for looking at "total emissions" 
tapply(NEI$Emissions, NEI$year, sum) %>% 
    barplot(., main = "Total PM2.5 by Year",
        xlab = "Year",
        ylab = "Total Emissions",
        col = "wheat"
        )
#fix y axis to not use scientific notation for better readability
options(scipen = 999)
#run again
tapply(NEI$Emissions, NEI$year, sum) %>% 
    barplot(., main = "Total PM2.5 by Year",
            xlab = "Year",
            ylab = "Total Emissions",
            col = "wheat"
    )
#---------------------------------------------------------
##Plot1 - Bar Chart Sum Emissions by Year
#load required package
library(dplyr)
#open file device - png
png(filename = "plot1.png", width = 480, height = 480)
# sum data and create bar graph
tapply(NEI$Emissions, NEI$year, sum) %>% 
    barplot(., main = "Total PM2.5 by Year",
            xlab = "Year",
            ylab = "Total Emissions",
            col = "wheat"
    )
#close device
dev.off()
#---------------------------------------------------------

#2) Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510")
    #from 1999 to 2008? Use the base plotting system to make a plot answering this question.


#Plot2 - scatterplot total emission by year of Baltimore City only
#open file device
png(filename = "plot2.png", width = 480, height = 480)
#subset data for Baltimore City only
baltimore <- subset(NEI, fips == "24510", select = c(Emissions, year), drop = FALSE)
table(baltimore$year)
# sum emission per year
totals <- with(baltimore, tapply(Emissions, year, sum))
print(totals)
years <- as.numeric(names(totals))
trend <- lm(totals ~ years)
    plot(years, totals, 
                    main = "Baltimore City, Maryland Total PM2.5",
                    xaxt = "n",
                    xlab = "Year",
                    ylab = "Total Emissions",
                    col = "red",
                    pch = 19,
                    ylim = c(1500, 3500)
                    
)
    axis(1, at = years, label = years)
    abline(trend, col = "blue")
#close file device
    dev.off()
    
#3) Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) 
    #variable, which of these four sources have seen decreases in emissions from 1999–2008 
    #for Baltimore City? Which have seen increases in emissions from 1999–2008? 
    #Use the ggplot2 plotting system to make a plot answer this question.
    
    
    #Plot3  = total emissions 
    #subset Baltimore City data
    baltimore <- subset(NEI, fips == "24510", drop = FALSE)
    #load packages
    library(dplyr)
    library(ggplot2)
    #open file device
    png(filename = "plot3.png", width = 480, height = 480)
    #group data by year and type to sum total emissions each year and type
    baltimore_sum <- baltimore %>%
        group_by(year, type) %>%
        summarise(total_Emissions = sum(Emissions))
  #create ggplot with summary data with facets for type to create 4 plots
    ggplot(baltimore_sum, aes(x= as.numeric(year), y = total_Emissions, color = type))+
        facet_wrap(~type)+
        geom_point()+
        geom_smooth(method = "lm", se = FALSE)+
        labs(title = "Total PM2.5 by Year in Baltimore City", 
           x = "Year", y = "Total Emissions")
    #close file device 
    dev.off()

    
    
    
    
    #Plot3B  = average emissions 
    png(filename = "Plot3B.png", width = 480, height = 480)
    baltimore_mean <- baltimore %>%
        group_by(year, type) %>%
        summarise(mean_Emissions = mean(Emissions))
   
    ggplot(baltimore_mean, aes(x= as.numeric(year), y = mean_Emissions, color = type))+
        facet_wrap(~type) +
        geom_point()+
        geom_smooth(method = "lm", se = FALSE)+
        labs(title = "Average PM2.5 by Year in Baltimore City", 
             x = "Year", y = "Average Emissions")
    dev.off()
    
#4) Across the United States, how have emissions from coal combustion-related sources 
    #changed from 1999–2008?
    
    #Plot 4 - scatter plot total coal emission by year
    #load required packages to join two datasets
    library(dplyr)
    #match NEI and SCC column types - characters
    SCC_modified <- SCC %>%
        mutate(SCC = as.character(SCC))
    #join dataframes
    joined_data <- NEI %>% 
        left_join(SCC_modified, by = "SCC")
    #check data
    str(joined_data)
    #subset data for coal combustion only
    coal_data <- joined_data %>%
        filter(grepl("coal", EI.Sector, ignore.case = TRUE))
    #turn of scientific notation for readability
    options(scipen = 999)
    #use ggplot to graph coal emissions per year over years
    qplot(as.factor(year), data = coal_data, weight = Emissions, geom = "bar", 
          main = "Total Coal Emissions per Year", 
          xlab = "Year", 
          ylab = "PM2.5",
          fill = I("skyblue"))+ theme_light()
 
    
#5) How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
    #subset data for motor vehicles only
    baltimore_vehicle <- subset(joined_data, fips == "24510" & type == "ON-ROAD", drop = FALSE)
    qplot(as.factor(year), data = baltimore_vehicle, weight = Emissions, geom = "bar",
          main = "Total Motor Vehicle Emissions", 
          xlab = "Year", 
          ylab = "PM2.5",
          fill = I("gold")) + theme_light()
    
    baltimore_onroad_means <- baltimore_vehicle %>%
        group_by(year) %>%
        summarize(mean_Emissions = mean(Emissions, na.rm = TRUE))
    qplot(as.factor(year), mean_Emissions, 
          data = baltimore_onroad_means, 
          geom = "bar",
          stat = "identity",
          main = "Total Motor Vehicle Emissions", 
          xlab = "Year", 
          ylab = "PM2.5",
          fill = I("gold")) + theme_light()
    #6) Compare emissions from motor vehicle sources in Baltimore City with emissions from
    #motor vehicle sources in Los Angeles County, California (fips == "06037"). 
    #Which city has seen greater changes over time in motor vehicle emissions?
    
    #subset joined-data to only two cities and motor vechicle
    twocities <- subset(joined_data, (fips == "24510" | fips == "06037") & type == "ON-ROAD", drop = FALSE)
    
    #   OPTION 1 
    #group to find mean emission per year in each city
    twocities_mean <- twocities %>%
        group_by(year, fips) %>%
        summarize(city_mean = mean(Emissions, na.rm = TRUE))
    #plot both cities mean emissions
    ggplot(twocities_mean, aes(x = as.numeric(year), y = city_mean)) +
        facet_wrap(~fips, labeller = as_labeller(c("24510" = "Baltimore City", "06037" = "Los Angeles"))) +
        geom_point() +
        geom_smooth(method = "lm", se = FALSE) +
        labs(title = "Motor Vehicle Emission By City", 
             x = "Year", y = "Average Emissions")
    
    meanslopes <- twocities_mean %>%
        group_by(fips) %>%
        summarise(slope = coef(lm(city_mean ~ as.numeric(year)))[2])
    print(meanslopes)
    # A tibble: 2 × 2
    #fips   slope
    #<chr>  <dbl>
    #1 06037  7.06 
    #2 24510 -0.150
    
    #OPTION 2
    #group to find the total emmisions
    twocites_totals <- twocities %>%
        group_by(year, fips) %>%
        summarise(city_totals = sum(Emissions, na.rm = TRUE))
    
    ggplot(twocites_totals, aes(x = as.numeric(year), y = city_totals)) +
        facet_wrap(~ fips, scales = "free_y", labeller = as_labeller(c("24510" = "Baltimore City", "06037" = "Los Angeles"))) +
        geom_point(color = "skyblue", size = 3) +
        geom_smooth(method = "lm", se = FALSE, color = "blue") +
        labs(title = "Total Motor Vehicle Emissions by City",
             x = "Years",
             y = "Total PM2.5") +
        theme_light()
    
    slopes <- twocites_totals %>%
        group_by(fips) %>%
        summarise(slope = coef(lm(city_totals ~ as.numeric(year)))[2])
    print(slopes)
    #fips  slope
    #<chr> <dbl>
    #1 06037  27.9
    #2 24510 -26.0
    
    #OPTION 3
    twocities_index <- twocites_totals %>%
        group_by(fips) %>%
        mutate(baseline = city_totals[year == 1999],
               index = (city_totals / baseline)) %>%
        ungroup()
    
    ggplot(twocities_index, aes(x = as.numeric(year), y = index)) +
        facet_wrap(~ fips, labeller = as_labeller(c("24510" = "Baltimore City", "06037" = "Los Angeles"))) +
        geom_point(color = "skyblue", size = 3) +
        geom_line(color = "skyblue") +
        geom_smooth(method = "lm", se = FALSE, color = "blue") +
        labs(title = "Motor Vehicle Change in Emissions Since 1999 (Baseline 1999 = 1)",
             x = "Year", 
             y = "Emissions Index") +
        theme_light()
    
    index_slopes <- twocities_index %>%
        group_by(fips) %>%
        summarise(slope = coef(lm(index ~ as.numeric(year)))[2])
    print(index_slopes)
    # A tibble: 2 × 2
    #fips   slope
    #<chr>  <dbl>
    #1 06037  0.711
    #2 24510 -7.49 