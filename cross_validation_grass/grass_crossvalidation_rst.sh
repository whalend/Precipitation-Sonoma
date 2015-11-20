#!/bin/sh
#
# Written by Jaro Hofierka, for v.surf.rst
#
# this is a script for a cross-validation analysis of RST parameters
# OUTPUT: CSV table
#

# j - smoothing - the number after decimal point, e.g. sm=0.1 is defined as j = 10
# i - tension

INMAP=rain_gauges04
ZCOL=rain04_dys
NPMIN=19 #number of points in INMAP
MASK=dem10m
YEAR=2004 #year of INMAP

OUTFILESTATS=/rain04days_cv1.csv


rm -f $OUTFILESTATS
echo "year,tension,smoothing,mean,mean_abs,population_stddev" > $OUTFILESTATS

j=10
while  [ $j -le 90 ]
do

  i=10
  while  [ $i -le 150 ]
  do
  
  TNS=`echo $i`
  SMTH=`echo $j`
  TNSSMTH=`echo "t"$i"s0"$j `
  echo "Computing tension/smoothing $TNSSMTH..."

   #interpolate sites CV differences:
   v.surf.rst -c input=$INMAP cvdev=rain04days_cv_$TNSSMTH zcolumn=$ZCOL tension="$i" smooth=0."$j" mask=$MASK segmax=700 npmin=$NPMIN --o

   #calculate univariate statistics for sites: 
   eval `v.univar -g rain04days_cv_$TNSSMTH col=flt1 type=point | grep 'tension\|smoothing\|mean\|mean_abs\|population_stddev'`
   echo "$YEAR,$TNS,$SMTH,$mean,$mean_abs,$population_stddev" >> $OUTFILESTATS
   i=`expr $i + 10`
 done

 j=`expr $j + 10`
done
echo  "Finished. Written $OUTFILESTATS"

