package #
Date::Manip::TZ::inkerg00;
# Copyright (c) 2008-2017 Sullivan Beck.  All rights reserved.
# This program is free software; you can redistribute it and/or modify it
# under the same terms as Perl itself.

# This file was automatically generated.  Any changes to this file will
# be lost the next time 'tzdata' is run.
#    Generated on: Wed Mar  1 10:08:23 EST 2017
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
          '-00',0,[1949,12,31,23,59,59],[1949,12,31,23,59,59],
          '0001010200:00:00','0001010200:00:00','1949123123:59:59','1949123123:59:59' ],
     ],
   1950 =>
     [
        [ [1950,1,1,0,0,0],[1950,1,1,5,0,0],'+05:00:00',[5,0,0],
          '+05',0,[9999,12,31,0,0,0],[9999,12,31,5,0,0],
          '1950010100:00:00','1950010105:00:00','9999123100:00:00','9999123105:00:00' ],
     ],
);

%LastRule      = (
);

1;
