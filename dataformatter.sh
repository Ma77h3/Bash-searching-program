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
