## Lattice and ggplots Plotting Systems7

##6: Lattice Plotting Systems
    #Must call Lattice Package
    library(lattice)
    #Create:
        #xyplot for scatterplots
        #bwplot for box-and-whiskers plots or boxplots
        #histogram for histograms
    #Graphs are save as plot objevts so we can use 
    names() #to see properties
    #and 
    ynames[myfull] #to see call TRUE or full properties
    #and more info on each property 
    p[["formula"]]
    p[["x.limits"]]
    #xyplots
    #Scatterplot with red stars and main label
    xyplot(Ozone~Wind, data = airquality, pch = 8, col = "red", main = "Big Apple Data")
    #Multiple Scatterplots (but not what we want for labels)
    xyplot(Ozone~Wind | Month, data = airquality, layout = c(5,1))
    #as.factor(Month) displayed and labeled each subplot with the month's integer
    xyplot(Ozone~Wind | as.factor(Month), data = airquality, layout = c(5,1))
    
    #building multiple plot in latttice with features
    
    #two plots seperated by group with a horizontail line
    p <- xyplot(y ~ x | f, panel = function(x, y, ...) {
        panel.xyplot(x, y, ...)  ## First call the default panel function for 'xyplot'
        panel.abline(h = median(y), lty = 2)  ## Add a horizontal line at the median
    })
    print(p)
    invisible()
   #Same two plots but with a red linear regression line
     p2 <- xyplot(y ~ x | f, panel = function(x, y, ...) {
        panel.xyplot(x, y, ...)  ## First call default panel function
        panel.lmline(x, y, col = 2)  ## Overlay a simple linear regression line
    })
    print(p2)
    invisible()
#create a matrix and strip hte titles for viewability
    xyplot(price~carat|color*cut, data = diamonds, strip = FALSE, pch = 20, xlab = "Carat", ylab = "Price", main = "Diamonds are Sparkly!")

##8: GGPlot2 Part1 
#ggplot2 package has 2 workhorse functions: 
#qplot, (think quick plot) and 
#ggplot, which is more flexible and can be customized for doing things qplot cannot do
#7 basic components:
    #data frame
    #aestectic mapping (color, size, ect.)
    #geoms (goemetric objects - points, lines, shapes)
    #facets (panels of conditioning plots)
    #stats (binning, quantiles, smoothing)
    #scales (for example, male = red, female = blue)
    #coordinate systems
    
#qplot
    #scatter plots 
        #scartter plot same as base plotting system but with labels
        qplot(displ, hwy, data = mpg)
        #color to distinguish drv
        qplot(displ, hwy, data = mpg, color = drv)
        #add trend line with geom to get 3 trend curves with 95% confidence intervals
        qplot(displ, hwy, data = mpg, color = drv, geom = c("point", "smooth"))
        #plot the data in hte order it occurs in hte data by leaving out x argument 
        qplot( y =hwy, data = mpg, color = drv)
        #create 3 scatter plots with 1 row and 3 columns
        qplot(displ, hwy, data = mpg, facets = .~drv)
        qplot(displ, hwy, data = mpg, geom = c("point", "smooth"), facets = .~drv)
    #box and whisker plots
        #first argument is how we split the variable hwy (unexpected)
        qplot(drv, hwy, data = mpg, geom = "boxplot")
        #same structure but with seperate boxplots for each manufacturer
        qplot(drv, hwy, data = mpg, geom = "boxplot", color = manufacturer)
    #histograms
        #color distinuishes drv
        qplot(hwy, data = mpg, fill = drv)
        #instead of color we will create separate plots with 3 rows and 1 column
        qplot(hwy, data = mpg, facets = drv~., binwidth = 2) #default for bin was not ideal
#ggplot
#makes the same plots but build it up step-by-step (artists pallette)
    g <- ggplot(mpg, aes(displ, hwy)) #bsae layer, no plot
    g+geom_point() #added a layer with points
    g+geom_point()+geom_smooth() #added a layer with trend curve and 95% confidence interval 
    g+geom_point()+geom_smooth(method = "lm") #changed to line because of noise at right end
    g+geom_point()+geom_smooth(method = "lm")+facet_grid(.~drv) #add drv as a condition/facet
    g+geom_point()+geom_smooth(method = "lm")+facet_grid(.~drv)+ggtitle("Swirl Rules!") #add main title
#change look of the plots points 
    g+geom_point(color = "pink", size = 4, alpha = 1/2) #darker points for density of value in hte data
    g+geom_point(aes(color = drv), size = 4, alpha = 1/2) #drv is distingished by colr adn wraped in aes()
#add labels 
    g + geom_point(aes(color = drv), alpha = .5) + labs(title="Swirl Rules!", x="Displacement", y="Hwy Mileage")
#modify tread line/curve and turn off confidence interval
    g + geom_point(aes(color = drv), size = 2, alpha = .5) + geom_smooth(size = 4, linetype = 3, method = "lm", se = FALSE)
#change theme and font
    g + geom_point(aes(color = drv)) + theme_bw(base_family = "Times")
#limit range of y-axis because you have an outliner
    g <- ggplot(testdat, aes(myx,myy))
    g+geom_line()+ylim(-3, 3)
    #OR , even better
    g+geom_line()+coord_cartesian(ylim = c(-3, 3))
#create our most complicated plot
    g <- ggplot(mpg, aes(x= displ, y = hwy, color = factor(year))) 
    g+geom_point()
    #add facets and margins = FALSE is marginal totals over each row and column
    g+geom_point()+facet_grid(drv~cyl, margins = TRUE)
    #add regression lines
    g + geom_point() +facet_grid(drv~cyl,margins=TRUE)+geom_smooth(method="lm",size=2,se=FALSE,color="black")
    #add titles
    g + geom_point()+facet_grid(drv~cyl,margins=TRUE)+geom_smooth(method="lm",size=2,se=FALSE,color="black")+labs(x="Displacement",y="Highway Mileage",title="Swirl Rules!")
#cut() a variable in a data set to use with facets with carat and cut
    g <- ggplot(diamonds, aes(depth, price))
    g+geom_point(alpha = 1/3)
    #cut carat into 1/3 quantiles 
    cutpoint <- quantile(diamonds$carat, seq(0, 1, length = 4), na.rm = TRUE)
    diamonds$car2 <- cut(diamonds$carat, cutpoints)
    #reset plot since we modified the data
    g <- ggplot(diamonds, aes(depth, price))
    #use facet to generate new plot
    g+geom_point(alpha = 1/3)+facet_grid(cut~car2)
    #add regression lines
    g+geom_point(alpha = 1/3)+facet_grid(cut~car2)+geom_smooth(method= "lm", size = 3, color = "pink")
    