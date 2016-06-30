################################################################################
# retreive the data
################################################################################

url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

tmp = tempfile()
download.file(url, tmp)
unzip(tmp)
unlink(tmp)

household_power = read.csv(
  "household_power_consumption.txt",
  sep = ";"
)

################################################################################
# reshape the data
################################################################################

household_power$Date =
  as.Date(household_power$Date, format='%d/%m/%Y')

# only select data for two days
household_power = subset(household_power,
                         Date == '2007-02-01' | 
                         Date == '2007-02-02'
)

# remove rows with missing values
household_power = subset(household_power, 
                         Global_active_power != '?')

# num of digits to use when converting to decimal field
options(digits=9)

# convert to the correct data type
household_power$Global_active_power =
  as.numeric(
    as.character(household_power$Global_active_power)
  )

################################################################################
# draw the plot
################################################################################

png(filename = "plot1.png",
    width = 480, height = 480, units = "px", pointsize = 12
)
    
with(household_power, 
     hist(
          Global_active_power, col = 'red',
          main = "Global Active Power",
          xlab = "Global Active Power (kilowatts)"
     )
)

dev.off()
