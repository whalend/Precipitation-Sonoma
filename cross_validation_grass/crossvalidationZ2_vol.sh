#!/bin/sh
#
# Written by Jaro Hofierka, for v.vol.rst
#
# this is a script for a cross-validation analysis of RST parameters
# OUTPUT: CSV table
#

# j - smoothing - the number after decimal point, e.g. sm=0.1 is defined as j = 10
# i - tension
# z - zscale multiplier for z-axis variable, not sure what influence this will have

INMAP=rain14_3d
WCOL=rain14_dys
NPMIN=10 #number of points in INMAP
YEAR=2014 #year of INMAP

OUTFILESTATS=/rain14days_3d_cvz2.csv

######### nothing to change below

rm -f $OUTFILESTATS
echo "year,tension,smoothing,scale,mean,mean_abs,population_stddev" > $OUTFILESTATS

z=10
while  [ $z -le 100 ]
do

  j=10
  while  [ $j -le 90 ]
  do

    i=1
    while  [ $i -le 9 ]
    do
  
    TNS=`echo $i`
    SMTH=`echo $j`
    Z=`echo $z`
    TNSSMTHZ=`echo "t"$i"s0"$j"z"$z `
    echo "Computing tension/smoothing $TNSSMTHZ..."

     #interpolate sites CV differences:
     v.vol.rst -c input=$INMAP cvdev=rain14days_3d_cv_$TNSSMTHZ wcolumn=$WCOL tension="$i" smooth=0."$j" zscale="$z" npmin=$NPMIN segmax=700 --o

     #calculate univariate statistics for sites: 
     eval `v.univar -g rain14days_3d_cv_$TNSSMTHZ col=flt1 type=point | grep 'tension\|smoothing\|mean\|mean_abs\|population_stddev'`
     echo "$YEAR,$TNS,$SMTH,$Z,$mean,$mean_abs,$population_stddev" >> $OUTFILESTATS
     i=`expr $i + 1`
    done

    j=`expr $j + 10`
  done
z=`expr $z + 10`
done
echo  "Finished. Written $OUTFILESTATS"

