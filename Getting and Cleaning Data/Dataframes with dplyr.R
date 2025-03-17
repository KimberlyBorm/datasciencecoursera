#The first step of working with data in dplyr is to load the data into what the package authors call a 'data frame tbl' or 'tbl_df'.
cran <- tbl_df(mydf)

#"The main advantage to using a tbl_df over a regular data frame is the printing." 
#This output is much more informative and compact than what we would get if we printed the original data frame (mydf) to the console.
cran

#To avoid confusion and keep things running smoothly, let's remove the original data frame from your workspace with rm("mydf").
rm("mydf")

#The first thing to notice is that we don't have to type cran$ip_id, cran$package, and cran$country, as we normally would when referring to columns of a
#data frame. The select() function knows we are referring to columns of the cran dataset.
select(cran, ip_id, package, country)

#specify the columns we want to throw away
select(cran, -time)

#then returns only the rows of cran corresponding to the TRUEs.
filter(cran, package == "swirl")

