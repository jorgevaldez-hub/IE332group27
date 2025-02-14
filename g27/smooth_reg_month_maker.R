smoothing_reg_month_maker<-function(sensor,pms=1,month="january"){
  require(readr) #input/output
  require(dplyr) #data wrangling
  require(lubridate) #date/time
  require(knitr) #quite fond of the kable function for making tables.
  require(ggplot2) #plotting
  require(ggthemes) #plotting
  require(gridExtra) #extra space for plots
  require(leaflet) #mapping
  require(leaflet.extras) #mapping
  require(data.table) #data manipulation 
  require(RColorBrewer) #plotting
  require(stringr) #more data wrangling
  require(ggridges) #plotting density ridges
  
  
  #Geographic information contained in this csv file
  sensor_locations <- read.csv("sensor_locations.csv")
  #Monthly data contained in these csv files. 
  gett_data<-paste("../Project/",month,"-2017.csv",sep="")
  month_data <- as_tibble(fread(gett_data))
  
  Sys.setenv(TZ='Poland') #we're looking at data from Poland, to avoid erors we'll use this command. If this is not given a timezone error will appear.
  month_data$`UTC time` <- as_datetime(month_data$`UTC time`)
  
      MONTH=month_data
      #Code to create the Fit Test
      kable(head(is.na(MONTH),n=10))
      MONTH.test<-MONTH %>% select(-`UTC time`)
      medrep <- function(i){
        i[is.na(i)] <- median(i, na.rm=TRUE) 
        as.numeric(i)
      }
      MONTH.med<- data.frame(apply(MONTH.test,2,medrep))
      MONTH.med<-MONTH.med %>% mutate(Date=MONTH$`UTC time`)
      Date <- MONTH.med$Date
      Sensor_and_pm<-paste("X",sensor,"_pm",pms,sep="")
      S_PM <- MONTH.med[[Sensor_and_pm]]
      fit<-smooth.spline(Date,S_PM,df=32)
     
      return(fit) 
    }