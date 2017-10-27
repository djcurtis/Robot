package #
Date::Manip::TZ::ashovd00;
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
        [ [1,1,2,0,0,0],[1,1,2,6,6,36],'+06:06:36',[6,6,36],
          'LMT',0,[1905,7,31,17,53,23],[1905,7,31,23,59,59],
          '0001010200:00:00','0001010206:06:36','1905073117:53:23','1905073123:59:59' ],
     ],
   1905 =>
     [
        [ [1905,7,31,17,53,24],[1905,7,31,23,53,24],'+06:00:00',[6,0,0],
          '+06',0,[1977,12,31,17,59,59],[1977,12,31,23,59,59],
          '1905073117:53:24','1905073123:53:24','1977123117:59:59','1977123123:59:59' ],
     ],
   1977 =>
     [
        [ [1977,12,31,18,0,0],[1978,1,1,1,0,0],'+07:00:00',[7,0,0],
          '+07',0,[1983,3,31,16,59,59],[1983,3,31,23,59,59],
          '1977123118:00:00','1978010101:00:00','1983033116:59:59','1983033123:59:59' ],
     ],
   1983 =>
     [
        [ [1983,3,31,17,0,0],[1983,4,1,1,0,0],'+08:00:00',[8,0,0],
          '+08',1,[1983,9,30,15,59,59],[1983,9,30,23,59,59],
          '1983033117:00:00','1983040101:00:00','1983093015:59:59','1983093023:59:59' ],
        [ [1983,9,30,16,0,0],[1983,9,30,23,0,0],'+07:00:00',[7,0,0],
          '+07',0,[1984,3,31,16,59,59],[1984,3,31,23,59,59],
          '1983093016:00:00','1983093023:00:00','1984033116:59:59','1984033123:59:59' ],
     ],
   1984 =>
     [
        [ [1984,3,31,17,0,0],[1984,4,1,1,0,0],'+08:00:00',[8,0,0],
          '+08',1,[1984,9,29,15,59,59],[1984,9,29,23,59,59],
          '1984033117:00:00','1984040101:00:00','1984092915:59:59','1984092923:59:59' ],
        [ [1984,9,29,16,0,0],[1984,9,29,23,0,0],'+07:00:00',[7,0,0],
          '+07',0,[1985,3,30,16,59,59],[1985,3,30,23,59,59],
          '1984092916:00:00','1984092923:00:00','1985033016:59:59','1985033023:59:59' ],
     ],
   1985 =>
     [
        [ [1985,3,30,17,0,0],[1985,3,31,1,0,0],'+08:00:00',[8,0,0],
          '+08',1,[1985,9,28,15,59,59],[1985,9,28,23,59,59],
          '1985033017:00:00','1985033101:00:00','1985092815:59:59','1985092823:59:59' ],
        [ [1985,9,28,16,0,0],[1985,9,28,23,0,0],'+07:00:00',[7,0,0],
          '+07',0,[1986,3,29,16,59,59],[1986,3,29,23,59,59],
          '1985092816:00:00','1985092823:00:00','1986032916:59:59','1986032923:59:59' ],
     ],
   1986 =>
     [
        [ [1986,3,29,17,0,0],[1986,3,30,1,0,0],'+08:00:00',[8,0,0],
          '+08',1,[1986,9,27,15,59,59],[1986,9,27,23,59,59],
          '1986032917:00:00','1986033001:00:00','1986092715:59:59','1986092723:59:59' ],
        [ [1986,9,27,16,0,0],[1986,9,27,23,0,0],'+07:00:00',[7,0,0],
          '+07',0,[1987,3,28,16,59,59],[1987,3,28,23,59,59],
          '1986092716:00:00','1986092723:00:00','1987032816:59:59','1987032823:59:59' ],
     ],
   1987 =>
     [
        [ [1987,3,28,17,0,0],[1987,3,29,1,0,0],'+08:00:00',[8,0,0],
          '+08',1,[1987,9,26,15,59,59],[1987,9,26,23,59,59],
          '1987032817:00:00','1987032901:00:00','1987092615:59:59','1987092623:59:59' ],
        [ [1987,9,26,16,0,0],[1987,9,26,23,0,0],'+07:00:00',[7,0,0],
          '+07',0,[1988,3,26,16,59,59],[1988,3,26,23,59,59],
          '1987092616:00:00','1987092623:00:00','1988032616:59:59','1988032623:59:59' ],
     ],
   1988 =>
     [
        [ [1988,3,26,17,0,0],[1988,3,27,1,0,0],'+08:00:00',[8,0,0],
          '+08',1,[1988,9,24,15,59,59],[1988,9,24,23,59,59],
          '1988032617:00:00','1988032701:00:00','1988092415:59:59','1988092423:59:59' ],
        [ [1988,9,24,16,0,0],[1988,9,24,23,0,0],'+07:00:00',[7,0,0],
          '+07',0,[1989,3,25,16,59,59],[1989,3,25,23,59,59],
          '1988092416:00:00','1988092423:00:00','1989032516:59:59','1989032523:59:59' ],
     ],
   1989 =>
     [
        [ [1989,3,25,17,0,0],[1989,3,26,1,0,0],'+08:00:00',[8,0,0],
          '+08',1,[1989,9,23,15,59,59],[1989,9,23,23,59,59],
          '1989032517:00:00','1989032601:00:00','1989092315:59:59','1989092323:59:59' ],
        [ [1989,9,23,16,0,0],[1989,9,23,23,0,0],'+07:00:00',[7,0,0],
          '+07',0,[1990,3,24,16,59,59],[1990,3,24,23,59,59],
          '1989092316:00:00','1989092323:00:00','1990032416:59:59','1990032423:59:59' ],
     ],
   1990 =>
     [
        [ [1990,3,24,17,0,0],[1990,3,25,1,0,0],'+08:00:00',[8,0,0],
          '+08',1,[1990,9,29,15,59,59],[1990,9,29,23,59,59],
          '1990032417:00:00','1990032501:00:00','1990092915:59:59','1990092923:59:59' ],
        [ [1990,9,29,16,0,0],[1990,9,29,23,0,0],'+07:00:00',[7,0,0],
          '+07',0,[1991,3,30,16,59,59],[1991,3,30,23,59,59],
          '1990092916:00:00','1990092923:00:00','1991033016:59:59','1991033023:59:59' ],
     ],
   1991 =>
     [
        [ [1991,3,30,17,0,0],[1991,3,31,1,0,0],'+08:00:00',[8,0,0],
          '+08',1,[1991,9,28,15,59,59],[1991,9,28,23,59,59],
          '1991033017:00:00','1991033101:00:00','1991092815:59:59','1991092823:59:59' ],
        [ [1991,9,28,16,0,0],[1991,9,28,23,0,0],'+07:00:00',[7,0,0],
          '+07',0,[1992,3,28,16,59,59],[1992,3,28,23,59,59],
          '1991092816:00:00','1991092823:00:00','1992032816:59:59','1992032823:59:59' ],
     ],
   1992 =>
     [
        [ [1992,3,28,17,0,0],[1992,3,29,1,0,0],'+08:00:00',[8,0,0],
          '+08',1,[1992,9,26,15,59,59],[1992,9,26,23,59,59],
          '1992032817:00:00','1992032901:00:00','1992092615:59:59','1992092623:59:59' ],
        [ [1992,9,26,16,0,0],[1992,9,26,23,0,0],'+07:00:00',[7,0,0],
          '+07',0,[1993,3,27,16,59,59],[1993,3,27,23,59,59],
          '1992092616:00:00','1992092623:00:00','1993032716:59:59','1993032723:59:59' ],
     ],
   1993 =>
     [
        [ [1993,3,27,17,0,0],[1993,3,28,1,0,0],'+08:00:00',[8,0,0],
          '+08',1,[1993,9,25,15,59,59],[1993,9,25,23,59,59],
          '1993032717:00:00','1993032801:00:00','1993092515:59:59','1993092523:59:59' ],
        [ [1993,9,25,16,0,0],[1993,9,25,23,0,0],'+07:00:00',[7,0,0],
          '+07',0,[1994,3,26,16,59,59],[1994,3,26,23,59,59],
          '1993092516:00:00','1993092523:00:00','1994032616:59:59','1994032623:59:59' ],
     ],
   1994 =>
     [
        [ [1994,3,26,17,0,0],[1994,3,27,1,0,0],'+08:00:00',[8,0,0],
          '+08',1,[1994,9,24,15,59,59],[1994,9,24,23,59,59],
          '1994032617:00:00','1994032701:00:00','1994092415:59:59','1994092423:59:59' ],
        [ [1994,9,24,16,0,0],[1994,9,24,23,0,0],'+07:00:00',[7,0,0],
          '+07',0,[1995,3,25,16,59,59],[1995,3,25,23,59,59],
          '1994092416:00:00','1994092423:00:00','1995032516:59:59','1995032523:59:59' ],
     ],
   1995 =>
     [
        [ [1995,3,25,17,0,0],[1995,3,26,1,0,0],'+08:00:00',[8,0,0],
          '+08',1,[1995,9,23,15,59,59],[1995,9,23,23,59,59],
          '1995032517:00:00','1995032601:00:00','1995092315:59:59','1995092323:59:59' ],
        [ [1995,9,23,16,0,0],[1995,9,23,23,0,0],'+07:00:00',[7,0,0],
          '+07',0,[1996,3,30,16,59,59],[1996,3,30,23,59,59],
          '1995092316:00:00','1995092323:00:00','1996033016:59:59','1996033023:59:59' ],
     ],
   1996 =>
     [
        [ [1996,3,30,17,0,0],[1996,3,31,1,0,0],'+08:00:00',[8,0,0],
          '+08',1,[1996,9,28,15,59,59],[1996,9,28,23,59,59],
          '1996033017:00:00','1996033101:00:00','1996092815:59:59','1996092823:59:59' ],
        [ [1996,9,28,16,0,0],[1996,9,28,23,0,0],'+07:00:00',[7,0,0],
          '+07',0,[1997,3,29,16,59,59],[1997,3,29,23,59,59],
          '1996092816:00:00','1996092823:00:00','1997032916:59:59','1997032923:59:59' ],
     ],
   1997 =>
     [
        [ [1997,3,29,17,0,0],[1997,3,30,1,0,0],'+08:00:00',[8,0,0],
          '+08',1,[1997,9,27,15,59,59],[1997,9,27,23,59,59],
          '1997032917:00:00','1997033001:00:00','1997092715:59:59','1997092723:59:59' ],
        [ [1997,9,27,16,0,0],[1997,9,27,23,0,0],'+07:00:00',[7,0,0],
          '+07',0,[1998,3,28,16,59,59],[1998,3,28,23,59,59],
          '1997092716:00:00','1997092723:00:00','1998032816:59:59','1998032823:59:59' ],
     ],
   1998 =>
     [
        [ [1998,3,28,17,0,0],[1998,3,29,1,0,0],'+08:00:00',[8,0,0],
          '+08',1,[1998,9,26,15,59,59],[1998,9,26,23,59,59],
          '1998032817:00:00','1998032901:00:00','1998092615:59:59','1998092623:59:59' ],
        [ [1998,9,26,16,0,0],[1998,9,26,23,0,0],'+07:00:00',[7,0,0],
          '+07',0,[2001,4,27,18,59,59],[2001,4,28,1,59,59],
          '1998092616:00:00','1998092623:00:00','2001042718:59:59','2001042801:59:59' ],
     ],
   2001 =>
     [
        [ [2001,4,27,19,0,0],[2001,4,28,3,0,0],'+08:00:00',[8,0,0],
          '+08',1,[2001,9,28,17,59,59],[2001,9,29,1,59,59],
          '2001042719:00:00','2001042803:00:00','2001092817:59:59','2001092901:59:59' ],
        [ [2001,9,28,18,0,0],[2001,9,29,1,0,0],'+07:00:00',[7,0,0],
          '+07',0,[2002,3,29,18,59,59],[2002,3,30,1,59,59],
          '2001092818:00:00','2001092901:00:00','2002032918:59:59','2002033001:59:59' ],
     ],
   2002 =>
     [
        [ [2002,3,29,19,0,0],[2002,3,30,3,0,0],'+08:00:00',[8,0,0],
          '+08',1,[2002,9,27,17,59,59],[2002,9,28,1,59,59],
          '2002032919:00:00','2002033003:00:00','2002092717:59:59','2002092801:59:59' ],
        [ [2002,9,27,18,0,0],[2002,9,28,1,0,0],'+07:00:00',[7,0,0],
          '+07',0,[2003,3,28,18,59,59],[2003,3,29,1,59,59],
          '2002092718:00:00','2002092801:00:00','2003032818:59:59','2003032901:59:59' ],
     ],
   2003 =>
     [
        [ [2003,3,28,19,0,0],[2003,3,29,3,0,0],'+08:00:00',[8,0,0],
          '+08',1,[2003,9,26,17,59,59],[2003,9,27,1,59,59],
          '2003032819:00:00','2003032903:00:00','2003092617:59:59','2003092701:59:59' ],
        [ [2003,9,26,18,0,0],[2003,9,27,1,0,0],'+07:00:00',[7,0,0],
          '+07',0,[2004,3,26,18,59,59],[2004,3,27,1,59,59],
          '2003092618:00:00','2003092701:00:00','2004032618:59:59','2004032701:59:59' ],
     ],
   2004 =>
     [
        [ [2004,3,26,19,0,0],[2004,3,27,3,0,0],'+08:00:00',[8,0,0],
          '+08',1,[2004,9,24,17,59,59],[2004,9,25,1,59,59],
          '2004032619:00:00','2004032703:00:00','2004092417:59:59','2004092501:59:59' ],
        [ [2004,9,24,18,0,0],[2004,9,25,1,0,0],'+07:00:00',[7,0,0],
          '+07',0,[2005,3,25,18,59,59],[2005,3,26,1,59,59],
          '2004092418:00:00','2004092501:00:00','2005032518:59:59','2005032601:59:59' ],
     ],
   2005 =>
     [
        [ [2005,3,25,19,0,0],[2005,3,26,3,0,0],'+08:00:00',[8,0,0],
          '+08',1,[2005,9,23,17,59,59],[2005,9,24,1,59,59],
          '2005032519:00:00','2005032603:00:00','2005092317:59:59','2005092401:59:59' ],
        [ [2005,9,23,18,0,0],[2005,9,24,1,0,0],'+07:00:00',[7,0,0],
          '+07',0,[2006,3,24,18,59,59],[2006,3,25,1,59,59],
          '2005092318:00:00','2005092401:00:00','2006032418:59:59','2006032501:59:59' ],
     ],
   2006 =>
     [
        [ [2006,3,24,19,0,0],[2006,3,25,3,0,0],'+08:00:00',[8,0,0],
          '+08',1,[2006,9,29,17,59,59],[2006,9,30,1,59,59],
          '2006032419:00:00','2006032503:00:00','2006092917:59:59','2006093001:59:59' ],
        [ [2006,9,29,18,0,0],[2006,9,30,1,0,0],'+07:00:00',[7,0,0],
          '+07',0,[2015,3,27,18,59,59],[2015,3,28,1,59,59],
          '2006092918:00:00','2006093001:00:00','2015032718:59:59','2015032801:59:59' ],
     ],
   2015 =>
     [
        [ [2015,3,27,19,0,0],[2015,3,28,3,0,0],'+08:00:00',[8,0,0],
          '+08',1,[2015,9,25,15,59,59],[2015,9,25,23,59,59],
          '2015032719:00:00','2015032803:00:00','2015092515:59:59','2015092523:59:59' ],
        [ [2015,9,25,16,0,0],[2015,9,25,23,0,0],'+07:00:00',[7,0,0],
          '+07',0,[2016,3,25,18,59,59],[2016,3,26,1,59,59],
          '2015092516:00:00','2015092523:00:00','2016032518:59:59','2016032601:59:59' ],
     ],
   2016 =>
     [
        [ [2016,3,25,19,0,0],[2016,3,26,3,0,0],'+08:00:00',[8,0,0],
          '+08',1,[2016,9,23,15,59,59],[2016,9,23,23,59,59],
          '2016032519:00:00','2016032603:00:00','2016092315:59:59','2016092323:59:59' ],
        [ [2016,9,23,16,0,0],[2016,9,23,23,0,0],'+07:00:00',[7,0,0],
          '+07',0,[9999,12,31,0,0,0],[9999,12,31,7,0,0],
          '2016092316:00:00','2016092323:00:00','9999123100:00:00','9999123107:00:00' ],
     ],
);

%LastRule      = (
);

1;