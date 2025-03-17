##General Info and Base Graphics Notes

##1: Principles of Analytic Graphs 

#6 Principles of Presenting Data
    #1) Show comparision
    #2) Show a mechanism
    #3) Show multivariate data
        #Simpson's paradox, or the Yule–Simpson effect: is a paradox in
        #probability and statistics, in which a trend that appears in different groups of data
        #disappears when these groups are combined."
    #4) Integrating multiple modes of evidence
    #5) Describing and documenting the evidence with sources, appropriate labels, and scales
    #6) Content - quality, relevance,and integrity of their content.


##2: Exploratory Graphs
    #Exploratory graphs are the initial step in an investigation, the "quick and
        #dirty" tool used to point the data scientist in a fruitful direction.
        #Plot details such as axes, legends, color and size are cleaned up later to 
        #convey more information in an aesthetically pleasing way.
    #Types of exploratory graphs
        # 5 number summary (not a graph)
        #Boxplot
            boxplot(ppm, col = "blue"))
            #draw a horizontail line on hte boxplot
            abline(h = 12)
        #Histogram
            hist(ppm, col = "green")
            #add a rug to gives you a little more detailed information about how many data points 
                #are in each bucket and where they lie within the bucket
            rug(ppm)
            #change the number of bars(buckets) on the histogram with 'breaks = '
            hist(ppm, col = "green", breaks = 100)
            #add a veritcal line equal to 12 and weight of the line at 2
            abline(v = 12, lwd = 2)
            #veritcal line equal to median, color magenta, and  weight of the line at 4
            abline(v = median(ppm), col = "magenta", lwd = 4)
        #barplot
            reg <- table(pollution$region)
            barplot(reg, col = "wheat", main = "Number of Counties in Each Region")
            
    #Some graphs have more than two-dimensions. These include overlayed or multiple
        #two-dimensional plots and spinning plots.
    #Multiple Boxplots
        #two boxplots for pmm, one for each region, from pollution data 
        boxplot( pm25~region, pollution, col = "red")
        
    #Subsets with histograms
        #set up the parameters (two rows, one column) and margins (below, left, top, right)
        par(mfrow = c(2,1), mar = c(4,4,2,1))
        #subset all "east" region data and name east
        east <- subset(pollution, region == "east")
        #first histogram with east pm25
        hist(east$pm25, col = "green")
        #do it all in one line with "west"
        hist(subset(pollution, region == "west")$pm25, col = "green")
        
    #Scatterplots
        #create a scatter plot without typing "pollution$' 
        with(pollution, plot(latitude, pm25))
        plot(pm25~latitude, pollution)
        #create a scatter plot with lattitude and pmm and distingish region by color
        plot(pollution$latitude, ppm, col = pollution$region)
        #furture investigate but making two different plots one for east and one for west
        par(mfrow = c(1,2), mar = c(5, 4, 2, 1))
        west<- subset(pollution, region == "west")
        plot(west$latitude, west$pm25, main = "West")
        plot(east$latitude, east$pm25, main = "East")
        #Or 
        plot(pm25~latitude, west, main = "West")
        plot(pm25~latitude, east, main = "East")
        
        
##3: Graphics Devices in R
    #types of graphing devices [2]
    #quartz() - Mac Screen Device
    #pdf - File Device [4]
        # use for line-type graphics and paper. resizes well, portable, 
        #not efficient for many objects/points
    #svg - File Device
        #XML-based, scalable vector graphics.
        #supports animation and interactivity  -good for web-based plots
    #bimap - File Device
        #png (Portable Network Graphics)
            #line drawings or images with solid colors. Good for plots with many points
            #most web browsers can read this format natively 
            #does not resize well
        #jpeg
            #good for photographs or natural scenes and plots with many points. 
            #read by almost any computer and any web browser.         
            #don't resize well, not great for line drawings
    #change the active graphics device with 
        dev.set(<integer>)
    #copy a plot to a new device (warning: doesn;t aways copy prefectly)
        dev.copy
        dev.copy(png, file = "geyserplot.png")
    #copies a plot to pdf 
        dev.copy2pdf 
    #Call to the graphics device, with()
        with(faithful, plot(eruptions, waiting))
        #add information
        title(main = "Old Faithful Geyser data")
        
    #check what device you are using currently (no device = 1)
        dev.cur()
        #output RStudioGD 
        #       2 
        
    #create a file to make a new graph
        pdf(file = "myplot.pdf")
        

##4) Plotting Systems
#three main systems: 
    #1. Base Plotting System (build plot piece but piece so you can add as you go)
        # main disadvantage: you can;t go back (ex. readjust margins or fix a misspelled a caption)
        
        #Make a plot
        with(cars, plot(speed, dist))
        #add text
        text(<x coor>, <y coor>, <text>)
    #Lattice System (deals with scaping, text, titles)
        #most useful for plots which display how y changes with x across levels of z. (z:categorical variable)
        #good for putting many plots on a screen at once
        #create 4 scatterplots by region with state data
            #all in one row and 4 columns
            xyplot(Life.Exp~Income | region, data = state, layout = c(4,1))
            #in 2 rows and 2 columns
            xyplot(Life.Exp~Income | region, data = state, layout = c(2,2))
    #ggplot2 (combination of both)
        #scatterplot 
            qplot(displ, hwy, data = mpg)
            
            
##5) Base Plotting System
    #Consists of core plotting and graphics engine
    #core plotting
        #Get a list of parameters, par()
            names(par())
        #get specfic info on a par()
            par("pin") 
            #OR
            par()$pin
            
            colors()
        #play with color and titles in boxplot
            boxplot(Ozone~Month, airquality, xlab = "Month", y = "Ozone(ppb)", col.axis = "blue", col.lab = "red")
            title(main = "Ozone and Wind in New York City")
        #build a scatterplot in multiple pieces 
            plot(airquality$Wind, airquality$Ozone, type = "n")
            title(main = "Wind and Ozone in NYC")
            may <- subset(airquality, Month == 5)
            points(may$Wind, may$Ozone, col  = "blue", pch = 17)
            notmay <- subset(airquality, Month != 5)
            points(notmay$Wind, notmay$Ozone, col = "red", pch = 8)
            legend("topright", pch = c(17, 8), col = c("blue", "red"), legend = c("May", "Other Months"))
            abline(v= median(airquality$Wind), lty = 2, lwd = 2)
            par(mfrow = c(1, 2))
            plot(Ozone~Wind, airquality, main = "Ozone and Wind")
            plot(airquality$Ozone, airquality$Solar.R, main = "Ozone and Solar Radiation")
        #one more with three plots and specified margins
            par(mfrow = c(1, 3), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))
            plot(airquality$Wind, airquality$Ozone, main = "Ozone and Wind")
            plot(airquality$Solar.R, airquality$Ozone, main = "Ozone and Solar Radiation")
            plot(airquality$Temp, airquality$Ozone, main = "Ozone and Temperature")
            mtext("Ozone and Weather in New York City", outer = TRUE)

##7: Working with Color
 #get a list of color names 600+
    sample(colors(), 10)
    #create a function to call colors with the function colorRamp
        pal <- colorRamp(c("red","blue"))
        pal(0) #all red
        pal(1) #all blue
        pal(seq(0, 1, len=6)) #string of varying combinations from 0/6 to 6/6
    #create a function to call colors with the function colorRampPallette
    #hexadecimal number scheme
        p1 <- colorRampPalette(c("red", "blue"))
        p1(2) #all red and blue
        p1(6) # same as pal(seq(0,1, len=6))
        p2 <- colorRampPalette(c("red", "yellow"))
        p2(2) #red(FF0000) and yellow (FFFF00)
        p2(10) # red is fixed full (FF0000) and green component graws to make yellows (FF__00)
        #alpha contours the density
        p3 <- colorRampPalette(c("blue", "green"), alpha = .5)
        plot(x, y, pch = 19, col = rgb(0, .5, .5, .3)) #plot with varying density points
    #RColorBrewer Package - used in conjection with colorRamp() and colorRampPalette() 
    #has three types of pallettes
        #sequential, divergent, and qualitative
    cols <- brewer.pal(3, "BuGn")
    pal <- colorRampPalette(cols)
    image(volcano, col = pal(20)) # good for topographical images
    image(volcano, col = p1(20)) # from before with red and blue
        