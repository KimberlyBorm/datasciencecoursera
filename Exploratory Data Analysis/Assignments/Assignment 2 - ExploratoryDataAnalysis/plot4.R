#4) Across the United States, how have emissions from coal combustion-related sources 
#changed from 1999–2008?

#Scatter plot for total coal emission by year in US with trend curve
#Coal Emissions decrease overall with a large decrease from 2005 to 2008

#load required packages to join two data sets and create ggplots
library(dplyr)
library(ggplot2)
#match NEI and SCC column types - characters
SCC_modified <- SCC %>%
    mutate(SCC = as.character(SCC))
#join dataframes with SCC column
joined_data <- NEI %>% 
    left_join(SCC_modified, by = "SCC")
#check data
str(joined_data)
#subset data for coal combustion only
coal_data <- joined_data %>%
    filter(grepl("coal", EI.Sector, ignore.case = TRUE))

#I tried a bar plot which was sufficient but wanted a graph 
#that more clearly demonstrated the trend with a curve tread line 

#open file device
png(filename = "plot4.png", width = 480, height = 480)
#create dataframe for total emissions by year
coal_totals <- coal_data %>%
    group_by(year) %>%
    summarize(totalcoal_Emissions = sum(Emissions, na.rm = TRUE))
#check dataframe
print(coal_totals)
#create plot with trend curve
ggplot(coal_totals, aes(x = as.numeric(year), y = totalcoal_Emissions)) +
    geom_point(color = "blue", size = 3) +
    geom_smooth(method = "loess", color = "skyblue") +
    labs(title = "Total U.S. Coal Emissions", 
         x = "Year", 
         y = "PM2.5 Emissions") +
    theme_light()
#close file device
dev.off()
