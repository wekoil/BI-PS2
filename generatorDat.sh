#!/usr/bin/awk -f
BEGIN {
   a=100
   srand()
   for (i=1;i<1000;i++) {
      a+=rand()-0.5
      print a
   }
}