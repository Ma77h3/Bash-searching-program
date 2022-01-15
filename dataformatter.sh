#!/bin/bash

#check if there is only one input of the file

if [[ ! $# -eq 1 ]]
then
        echo The script only accepts 1 argument
        exit 1

#check if that input is a valid directory

elif [[ ! -d $1 ]]
then
        echo "$1 is not a valid directory name"
        exit 1

fi

# Sorting function

sorting_log_files()
{
        #go through all files in directory
        for files in $(ls $1)
                do
                        #if the file is a directory use recursion and start the function using that directory
                        if [[ -d $1/$files ]]
                        then
                                echo $(sorting_log_files "$1/$files")
                        fi
                done


                #for all the files that match the input description, add the path to the file

                for files in $(ls $1| grep "^sensordata-"| grep "log")
                do
                        echo "$1/$files"
                done
}


#Part 4, Processing Sensor Data
# iterate through the ouputs of the sorting function to get the files

for files in $(sorting_log_files $1)
do
        #Titles
        echo "Processing sensor data set for $files"
        echo "Year,Month, Day, Hour, Sensor1, Sensor2, Sensor3, Sensor4, Sensor5"

        #Filter out the lines without the word "readouts"
        #Change the first two dash of the line into spaces and the first two colons into spaces

        #This allows us to separate the fields and isolate for the hour without the minute


        grep "readouts" $files | sed -e 's/-/ /' -e 's/-/ /' -e 's/:/ /' -e 's/:/ /'|

        #initialize sensor varables that keep track of the previous sensor values
        awk 'BEGIN {OFS=",";sensor1="";sensor2="";sensor3="";sensor4="";sensor5=""}

        # if any of the values is equal to "ERROR" set it equal to the previous sensor values
        {


        if ($9 == "ERROR") { $9=sensor1 }
        if ($10 == "ERROR") { $10=sensor2 }
        if ($11 == "ERROR") { $11=sensor3 }
        if ($12 == "ERROR") { $12=sensor4 }
        if ($13 == "ERROR") { $13=sensor5 }

        #print the correct formation of Year, Month.....
        # update previous sensor values

        print $1,$2,$3,$4,$9,$10,$11,$12,$13
        sensor1=$9;sensor2=$10;sensor3=$11;sensor4=$12;sensor5=$13 }'

        echo "===================================="

#Part 5, Readout Statistics

        #Titles
        echo "Readouts Statistics"
        echo "Year,Month,Hour,MaxTemp,MaxSensor,MinTemp,MinSensor"

        #Same grep and sed commands as part 4
        grep "readouts" $files | sed -e 's/-/ /' -e 's/-/ /' -e 's/:/ /' -e 's/:/ /'|


        #initialize variables to keep track of the largest and smallest sensor readings along with the sensor numbers
        awk 'BEGIN {OFS=",";largest_sensor="";largest_reading="";smallest_sensor="";smallest_reading=""}
        {

        # initially set the both large and small fields to 9th position as long as it is not error, if there is an error, move to the right 1 position


        if ($9 != "ERROR") { largest_reading=$9; largest_sensor="Sensor1"; smallest_reading=$9; smallest_sensor="Sensor1"}
        else if ($10 != "ERROR") { largest_reading=$10; largest_sensor="Sensor2"; smallest_reading=$10; smallest_sensor="Sensor2"}
        else if ($11 != "ERROR") { largest_reading=$11; largest_sensor="Sensor3"; smallest_reading=$11; smallest_sensor="Sensor3"}
        else if ($12 != "ERROR") { largest_reading=$12; largest_sensor="Sensor4"; smallest_reading=$12; smallest_sensor="Sensor4"}
        else if ($13 != "ERROR") { largest_reading=$13; largest_sensor="Sensor5"; smallest_reading=$13; smallest_sensor="Sensor5"}

        #check with other postions to see if the current largest reading is smaller then the current reading, if so update it, as well as the sensor name
        #check with other postions to see if the current smallest reading is larger then the current reading, if so update it, as well as the sensor name

        if (largest_reading < $10 && $10 != "ERROR") { largest_reading=$10; largest_sensor="Sensor2" }
        if (smallest_reading > $10 && $10 != "ERROR") { smallest_reading=$10; smallest_sensor="Sensor2" }
        if (largest_reading < $11 && $11 != "ERROR") { largest_reading=$11; largest_sensor="Sensor3" }
        if (smallest_reading > $11 && $11 != "ERROR") { smallest_reading=$11; smallest_sensor="Sensor3" }
        if (largest_reading < $12 && $12 != "ERROR") { largest_reading=$12; largest_sensor="Sensor4" }
        if (smallest_reading > $12 && $12 != "ERROR") { smallest_reading=$12; smallest_sensor="Sensor4" }
        if (largest_reading < $13 && $13 != "ERROR") { largest_reading=$13; largest_sensor="Sensor5" }
        if (smallest_reading > $13 && $13 != "ERROR") { smallest_reading=$13; smallest_sensor="Sensor5" }

        #Print the year, date, month, hour as well as the largest reading, largest sensor, smallest reading and smallest sensor for every line
        print $1, $2, $3, $4, largest_reading, largest_sensor, smallest_reading, smallest_sensor  }'

        echo "===================================="
done

#Part 6, Erro Statistics

#Titles
echo "Sensor Error Statistics"
echo "Year, Month, Day, Sensor1, Sensor2, Sensor3, Sensor4, Sensor5, Total"


for files in $(sorting_log_files $1)
do
        #Same grep and sed commands as in part 4 and part 5
        grep "readouts" $files | sed -e 's/-/ /' -e 's/-/ /' -e 's/:/ /' -e 's/:/ /'|

        #initalize variables to represent how many errors are in each sensor as well as a total error sensor value
        awk ' BEGIN {OFS=",";sensor1=0;sensor2=0;sensor3=0;sensor4=0;sensor5=0;total=0}

        # if any of the fields have are equal to "ERROR", add one to that sensor value total as well as the total variable
        # print at the end the year, month, date and the respective error in each sensor as well as the total errors from all 5 sensors

        {
        if ($9 == "ERROR") {sensor1=sensor1+1; total=total+1}
