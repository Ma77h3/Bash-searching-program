#1/bin/sh



sed -e 's/-/,/g1' -e 's/,/-/g3' < $1 | grep "readouts" |awk 'BEGIN {sensor1=5;sensor2=6;sensor3=7;sensor4=8;sensor5=9}
{ if ($5 == "ERROR") { print $1, $sensor1, $6, $7, $8, $9 } }
{ if ($6 == "ERROR") { $6 = $sensor2;sensor1=$5;sensor3=$7;sensor4=$8;sensor5=$9 } }
{ if ($7 == "ERROR") { $7 = $sensor3;sensor1=$5;sensor2=$6;sensor4=$8;sensor5=$9 } }
{ if ($8 == "ERROR") { $8 = $sensor4;sensor1=$5;sensor2=$6;sensor3=$7;sensor5=$9 } }
{ if ($9 == "ERROR") { $9 = $sensor5;sensor1=$5;sensor2=$6;sensor3=$7;sensor4=$8 } }
{ else { print $0; sensor1=5;sensor2=6;sensor3=7;sensor4=8;sensor5=9 } }
END{print $0}'




#sed -e 's/-/,/g1' -e 's/,/-/g3' < $1 | grep "readouts" |awk 'BEGIN {sensor=2} { print $sensor; sensor=5 } '
