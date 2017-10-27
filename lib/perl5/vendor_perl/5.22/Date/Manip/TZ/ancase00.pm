package #
Date::Manip::TZ::ancase00;
# Copyright (c) 2008-2017 Sullivan Beck.  All rights reserved.
# This program is free software; you can redistribute it and/or modify it
# under the same terms as Perl itself.

# This file was automatically generated.  Any changes to this file will
# be lost the next time 'tzdata' is run.
#    Generated on: Wed Mar  1 10:08:21 EST 2017
#    Data version: tzdata2017a
#    Code version: tzcode2017a

# This module contains data from the zoneinfo time zone database.  The original
# data was obtained from the URL:
#    ftp://ftp.iana.org/tz

use strict;
use warnings;
require 5.010000;

our (%Dates,%LastRule);
END {
   undef %Dates;
   undef %LastRule;
}

our ($VERSION);
$VERSION='6.58';
END { undef $VERSION; }

%Dates         = (
   1    =>
     [
        [ [1,1,2,0,0,0],[1,1,2,0,0,0],'+00:00:00',[0,0,0],
          '-00',0,[1968,12,31,23,59,59],[1968,12,31,23,59,59],
          '0001010200:00:00','0001010200:00:00','1968123123:59:59','1968123123:59:59' ],
     ],
   1969 =>
     [
        [ [1969,1,1,0,0,0],[1969,1,1,8,0,0],'+08:00:00',[8,0,0],
          '+08',0,[2009,10,17,17,59,59],[2009,10,18,1,59,59],
          '1969010100:00:00','1969010108:00:00','2009101717:59:59','2009101801:59:59' ],
     ],
   2009 =>
     [
        [ [2009,10,17,18,0,0],[2009,10,18,5,0,0],'+11:00:00',[11,0,0],
          '+11',0,[2010,3,4,14,59,59],[2010,3,5,1,59,59],
          '2009101718:00:00','2009101805:00:00','2010030414:59:59','2010030501:59:59' ],
     ],
   2010 =>
     [
        [ [2010,3,4,15,0,0],[2010,3,4,23,0,0],'+08:00:00',[8,0,0],
          '+08',0,[2011,10,27,17,59,59],[2011,10,28,1,59,59],
          '2010030415:00:00','2010030423:00:00','2011102717:59:59','2011102801:59:59' ],
     ],
   2011 =>
     [
        [ [2011,10,27,18,0,0],[2011,10,28,5,0,0],'+11:00:00',[11,0,0],
          '+11',0,[2012,2,21,16,59,59],[2012,2,22,3,59,59],
          '2011102718:00:00','2011102805:00:00','2012022116:59:59','2012022203:59:59' ],
     ],
   2012 =>
     [
        [ [2012,2,21,17,0,0],[2012,2,22,1,0,0],'+08:00:00',[8,0,0],
          '+08',0,[2016,10,21,15,59,59],[2016,10,21,23,59,59],
          '2012022117:00:00','2012022201:00:00','2016102115:59:59','2016102123:59:59' ],
     ],
   2016 =>
     [
        [ [2016,10,21,16,0,0],[2016,10,22,3,0,0],'+11:00:00',[11,0,0],
          '+11',0,[9999,12,31,0,0,0],[9999,12,31,11,0,0],
          '2016102116:00:00','2016102203:00:00','9999123100:00:00','9999123111:00:00' ],
     ],
);

%LastRule      = (
);

1;
