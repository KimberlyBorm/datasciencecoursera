#6) Compare emissions from motor vehicle sources in Baltimore City with emissions from
#motor vehicle sources in Los Angeles County, California (fips == "06037"). 
#Which city has seen greater changes over time in motor vehicle emissions?

#create four scatter plots with trend lines 
#the first two(p1) compare overall emissions by year from both cities
#it is unclear which is changing more over time from this graph, 
#just that Los Angeles has much higher emissions overall that appear to increase slightly
# and Baltimore has much lower emissions overall that appear to decrease slightly 
#however, the y scale is to large to evaluate this properly. 

#the bottom two graphs(p2) will index the change by comparing each years emissions to 
#the starting value for that city in 1999 (baseline)
#this will allow us to see the change each year  compared to the starting year 
#and more clearly see the difference over time

#open file decide
png(filename = "plot6.png", width = 480, height = 480)
#load library required for combining plots
library(gridExtra)
library(ggplot2)
#subset joined-data to only two cities and motor vechicle
twocities <- subset(joined_data, (fips == "24510" | fips == "06037") & type == "ON-ROAD", drop = FALSE)
#create first two plots(p1)
#group to find the total emissions per year per city
twocities_totals <- twocities %>%
    group_by(year, fips) %>%
    summarise(city_totals = sum(Emissions, na.rm = TRUE))
#Create plots for total emissions by year for each city 
p1 <-ggplot(twocities_totals, aes(x = as.numeric(year), y = city_totals)) +
    facet_wrap(~ fips, labeller = as_labeller(c("24510" = "Baltimore City", "06037" = "Los Angeles"))) +
    geom_point(color = "skyblue", size = 3) +
    geom_smooth(method = "lm", se = FALSE, color = "blue") +
    labs(title = "Total Motor Vehicle Emissions",
         x = "Years",
         y = "Total PM2.5") +
    theme_light()

#Create second teo plots (p2)
#group data by flips and create index variable to compare change over time from baseline
twocities_index <- twocities_totals  %>%
    group_by(fips) %>%
    mutate(baseline = city_totals[year == 1999],
           index = (city_totals / baseline)) %>%
    ungroup()

p2 <- ggplot(twocities_index, aes(x = as.numeric(year), y = index)) +
    facet_wrap(~ fips, labeller = as_labeller(c("24510" = "Baltimore City", "06037" = "Los Angeles"))) +
    geom_point(color = "skyblue", size = 3) +
    geom_line(color = "skyblue") +
    geom_smooth(method = "lm", se = FALSE, color = "blue") +
    labs(title = "Motor Vehicle Change in Emissions Since 1999 (Baseline(1999) = 1)",
         x = "Year", 
         y = "Emissions Index") +
    theme_light()
#compile both graphs in one image
grid.arrange(p1, p2, nrow = 2)
#close file devide
dev.off()
