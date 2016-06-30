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

household_power$DateTime =
  as.POSIXct(
    paste(household_power$Date, household_power$Time),
    format="%Y-%m-%d %H:%M:%S"
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

# convert to the correct data type
household_power$Global_reactive_power =
  as.numeric(
    as.character(household_power$Global_reactive_power)
  )

# convert to the correct data type
household_power$Voltage =
  as.numeric(
    as.character(household_power$Voltage)
  )

# convert to the correct data type
household_power$Sub_metering_1 =
  as.numeric(
    as.character(household_power$Sub_metering_1)
  )

household_power$Sub_metering_2 =
  as.numeric(
    as.character(household_power$Sub_metering_2)
  )

household_power$Sub_metering_3 =
  as.numeric(
    as.character(household_power$Sub_metering_3)
  )
################################################################################
# draw the plot
################################################################################


png(filename = "plot4.png",
    width = 480, height = 480, units = "px", pointsize = 12
)

par(mfrow = c(2,2))
attach(household_power) 

# plot 1

plot(
  DateTime,
  Global_active_power,
  xlab = "",
  ylab = "Global Active Power",
  type = "l"
)

# plot 2

plot(
  DateTime,
  Voltage,
  xlab = "datetime",
  ylab = "Voltage",
  type = "l"
)

# plot 3

plot(
  DateTime,
  Sub_metering_1,
  xlab = "",
  ylab = "Energy sub metering",
  type = "n"
)
lines(DateTime, Sub_metering_1, type = 'l', col='black')
lines(DateTime, Sub_metering_2, type = 'l', col='red')
lines(DateTime, Sub_metering_3, type = 'l', col='blue')
legend(x="topright",
       c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'),
       lty=c(1,1,1),
       col=c('black', 'red', 'blue')
) 

# plot 4

plot(
  DateTime,
  Global_reactive_power,
  xlab = "datetime",
  type = "l"
)
detach(household_power)

dev.off()
