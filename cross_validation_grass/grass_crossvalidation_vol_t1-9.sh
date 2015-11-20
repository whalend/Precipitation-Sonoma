#!/bin/sh
#
# Written by Jaro Hofierka, for v.vol.rst
#
# this is a script for a cross-validation analysis of RST parameters
# OUTPUT: CSV table
#

# j - smoothing - the number after decimal point, e.g. sm=0.1 is defined as j = 10
# i - tension

INMAP=rain14_3d
WCOL=totppt_mm
NPMIN=5 #number of points in INMAP
YEAR=2014 #year of INMAP

OUTFILESTATS=/rain14_3d_cv2.csv

######### nothing to change below

rm -f $OUTFILESTATS
echo "year,tension,smoothing,mean,mean_abs,population_stddev" > $OUTFILESTATS


j=10
while  [ $j -le 90 ]
do

  i=1
  while  [ $i -le 9 ]
  do
  
    TNS=`echo $i`
    SMTH=`echo $j`
    TNSSMTH=`echo "t"$i"s0"$j" `
    echo "Computing tension/smoothing $TNSSMTH..."

     #interpolate sites CV differences:
     v.vol.rst -c input=$INMAP cvdev=rain14_3d_cv_$TNSSMTH wcolumn=$WCOL tension="$i" smooth=0."$j" npmin=$NPMIN segmax=700 --o

     #calculate univariate statistics for sites: 
     eval `v.univar -g rain14_3d_cv_$TNSSMTH col=flt1 type=point | grep 'tension\|smoothing\|mean\|mean_abs\|population_stddev'`
     echo "$YEAR,$TNS,$SMTH,$mean,$mean_abs,$population_stddev" >> $OUTFILESTATS
     i=`expr $i + 1`
  done

j=`expr $j + 10`
done
