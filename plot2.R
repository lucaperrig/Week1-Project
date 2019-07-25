library(dplyr)

#Load the data
if (!file.exists("household_power_consumption.txt")) {
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                destfile = "household_power_consumption.txt")
}
df <- read.table("household_power_consumption.txt", header = TRUE, sep = ";", colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"), na.strings = "?")

#Take subset
ids <- grepl('^1/2/2007|^2/2/2007', x = df$Date)
df <- subset(x = df, subset = ids, select = names(df), drop = TRUE)

#Convert to date and time
n <- names(df)
tbl <- tbl_df(df) %>%
  mutate(DateTime = paste(Date, Time)) %>%
  select(DateTime, n[3:length(n)])
tbl$DateTime <- strptime(tbl$DateTime, format = "%e/%m/%Y %H:%M:%S")
names(tbl)

#Plot2
png(filename = "plot2.png")
with(tbl, plot(DateTime, Global_active_power,
               ylab = "Global Active Power (kilowatts)",
               xlab = "",
               type = "n"))
with(tbl, lines(DateTime, Global_active_power))
dev.off()
