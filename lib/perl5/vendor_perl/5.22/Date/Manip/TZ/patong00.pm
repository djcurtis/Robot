package #
Date::Manip::TZ::patong00;
# Copyright (c) 2008-2017 Sullivan Beck.  All rights reserved.
# This program is free software; you can redistribute it and/or modify it
# under the same terms as Perl itself.

# This file was automatically generated.  Any changes to this file will
# be lost the next time 'tzdata' is run.
#    Generated on: Wed Mar  1 10:08:24 EST 2017
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
        [ [1,1,2,0,0,0],[1,1,2,12,19,20],'+12:19:20',[12,19,20],
          'LMT',0,[1900,12,31,11,40,39],[1900,12,31,23,59,59],
          '0001010200:00:00','0001010212:19:20','1900123111:40:39','1900123123:59:59' ],
     ],
   1900 =>
     [
        [ [1900,12,31,11,40,40],[1901,1,1,0,0,40],'+12:20:00',[12,20,0],
          '+1220',0,[1940,12,31,11,39,59],[1940,12,31,23,59,59],
          '1900123111:40:40','1901010100:00:40','1940123111:39:59','1940123123:59:59' ],
     ],
   1940 =>
     [
        [ [1940,12,31,11,40,0],[1941,1,1,0,40,0],'+13:00:00',[13,0,0],
          '+13',0,[1999,10,6,12,59,59],[1999,10,7,1,59,59],
          '1940123111:40:00','1941010100:40:00','1999100612:59:59','1999100701:59:59' ],
     ],
   1999 =>
     [
        [ [1999,10,6,13,0,0],[1999,10,7,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2000,3,18,12,59,59],[2000,3,19,2,59,59],
          '1999100613:00:00','1999100703:00:00','2000031812:59:59','2000031902:59:59' ],
     ],
   2000 =>
     [
        [ [2000,3,18,13,0,0],[2000,3,19,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2000,11,4,12,59,59],[2000,11,5,1,59,59],
          '2000031813:00:00','2000031902:00:00','2000110412:59:59','2000110501:59:59' ],
        [ [2000,11,4,13,0,0],[2000,11,5,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2001,1,27,11,59,59],[2001,1,28,1,59,59],
          '2000110413:00:00','2000110503:00:00','2001012711:59:59','2001012801:59:59' ],
     ],
   2001 =>
     [
        [ [2001,1,27,12,0,0],[2001,1,28,1,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2001,11,3,12,59,59],[2001,11,4,1,59,59],
          '2001012712:00:00','2001012801:00:00','2001110312:59:59','2001110401:59:59' ],
        [ [2001,11,3,13,0,0],[2001,11,4,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2002,1,26,11,59,59],[2002,1,27,1,59,59],
          '2001110313:00:00','2001110403:00:00','2002012611:59:59','2002012701:59:59' ],
     ],
   2002 =>
     [
        [ [2002,1,26,12,0,0],[2002,1,27,1,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2016,11,5,12,59,59],[2016,11,6,1,59,59],
          '2002012612:00:00','2002012701:00:00','2016110512:59:59','2016110601:59:59' ],
     ],
   2016 =>
     [
        [ [2016,11,5,13,0,0],[2016,11,6,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2017,1,14,12,59,59],[2017,1,15,2,59,59],
          '2016110513:00:00','2016110603:00:00','2017011412:59:59','2017011502:59:59' ],
     ],
   2017 =>
     [
        [ [2017,1,14,13,0,0],[2017,1,15,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2017,11,4,12,59,59],[2017,11,5,1,59,59],
          '2017011413:00:00','2017011502:00:00','2017110412:59:59','2017110501:59:59' ],
        [ [2017,11,4,13,0,0],[2017,11,5,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2018,1,20,12,59,59],[2018,1,21,2,59,59],
          '2017110413:00:00','2017110503:00:00','2018012012:59:59','2018012102:59:59' ],
     ],
   2018 =>
     [
        [ [2018,1,20,13,0,0],[2018,1,21,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2018,11,3,12,59,59],[2018,11,4,1,59,59],
          '2018012013:00:00','2018012102:00:00','2018110312:59:59','2018110401:59:59' ],
        [ [2018,11,3,13,0,0],[2018,11,4,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2019,1,19,12,59,59],[2019,1,20,2,59,59],
          '2018110313:00:00','2018110403:00:00','2019011912:59:59','2019012002:59:59' ],
     ],
   2019 =>
     [
        [ [2019,1,19,13,0,0],[2019,1,20,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2019,11,2,12,59,59],[2019,11,3,1,59,59],
          '2019011913:00:00','2019012002:00:00','2019110212:59:59','2019110301:59:59' ],
        [ [2019,11,2,13,0,0],[2019,11,3,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2020,1,18,12,59,59],[2020,1,19,2,59,59],
          '2019110213:00:00','2019110303:00:00','2020011812:59:59','2020011902:59:59' ],
     ],
   2020 =>
     [
        [ [2020,1,18,13,0,0],[2020,1,19,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2020,10,31,12,59,59],[2020,11,1,1,59,59],
          '2020011813:00:00','2020011902:00:00','2020103112:59:59','2020110101:59:59' ],
        [ [2020,10,31,13,0,0],[2020,11,1,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2021,1,16,12,59,59],[2021,1,17,2,59,59],
          '2020103113:00:00','2020110103:00:00','2021011612:59:59','2021011702:59:59' ],
     ],
   2021 =>
     [
        [ [2021,1,16,13,0,0],[2021,1,17,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2021,11,6,12,59,59],[2021,11,7,1,59,59],
          '2021011613:00:00','2021011702:00:00','2021110612:59:59','2021110701:59:59' ],
        [ [2021,11,6,13,0,0],[2021,11,7,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2022,1,15,12,59,59],[2022,1,16,2,59,59],
          '2021110613:00:00','2021110703:00:00','2022011512:59:59','2022011602:59:59' ],
     ],
   2022 =>
     [
        [ [2022,1,15,13,0,0],[2022,1,16,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2022,11,5,12,59,59],[2022,11,6,1,59,59],
          '2022011513:00:00','2022011602:00:00','2022110512:59:59','2022110601:59:59' ],
        [ [2022,11,5,13,0,0],[2022,11,6,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2023,1,14,12,59,59],[2023,1,15,2,59,59],
          '2022110513:00:00','2022110603:00:00','2023011412:59:59','2023011502:59:59' ],
     ],
   2023 =>
     [
        [ [2023,1,14,13,0,0],[2023,1,15,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2023,11,4,12,59,59],[2023,11,5,1,59,59],
          '2023011413:00:00','2023011502:00:00','2023110412:59:59','2023110501:59:59' ],
        [ [2023,11,4,13,0,0],[2023,11,5,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2024,1,20,12,59,59],[2024,1,21,2,59,59],
          '2023110413:00:00','2023110503:00:00','2024012012:59:59','2024012102:59:59' ],
     ],
   2024 =>
     [
        [ [2024,1,20,13,0,0],[2024,1,21,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2024,11,2,12,59,59],[2024,11,3,1,59,59],
          '2024012013:00:00','2024012102:00:00','2024110212:59:59','2024110301:59:59' ],
        [ [2024,11,2,13,0,0],[2024,11,3,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2025,1,18,12,59,59],[2025,1,19,2,59,59],
          '2024110213:00:00','2024110303:00:00','2025011812:59:59','2025011902:59:59' ],
     ],
   2025 =>
     [
        [ [2025,1,18,13,0,0],[2025,1,19,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2025,11,1,12,59,59],[2025,11,2,1,59,59],
          '2025011813:00:00','2025011902:00:00','2025110112:59:59','2025110201:59:59' ],
        [ [2025,11,1,13,0,0],[2025,11,2,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2026,1,17,12,59,59],[2026,1,18,2,59,59],
          '2025110113:00:00','2025110203:00:00','2026011712:59:59','2026011802:59:59' ],
     ],
   2026 =>
     [
        [ [2026,1,17,13,0,0],[2026,1,18,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2026,10,31,12,59,59],[2026,11,1,1,59,59],
          '2026011713:00:00','2026011802:00:00','2026103112:59:59','2026110101:59:59' ],
        [ [2026,10,31,13,0,0],[2026,11,1,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2027,1,16,12,59,59],[2027,1,17,2,59,59],
          '2026103113:00:00','2026110103:00:00','2027011612:59:59','2027011702:59:59' ],
     ],
   2027 =>
     [
        [ [2027,1,16,13,0,0],[2027,1,17,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2027,11,6,12,59,59],[2027,11,7,1,59,59],
          '2027011613:00:00','2027011702:00:00','2027110612:59:59','2027110701:59:59' ],
        [ [2027,11,6,13,0,0],[2027,11,7,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2028,1,15,12,59,59],[2028,1,16,2,59,59],
          '2027110613:00:00','2027110703:00:00','2028011512:59:59','2028011602:59:59' ],
     ],
   2028 =>
     [
        [ [2028,1,15,13,0,0],[2028,1,16,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2028,11,4,12,59,59],[2028,11,5,1,59,59],
          '2028011513:00:00','2028011602:00:00','2028110412:59:59','2028110501:59:59' ],
        [ [2028,11,4,13,0,0],[2028,11,5,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2029,1,20,12,59,59],[2029,1,21,2,59,59],
          '2028110413:00:00','2028110503:00:00','2029012012:59:59','2029012102:59:59' ],
     ],
   2029 =>
     [
        [ [2029,1,20,13,0,0],[2029,1,21,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2029,11,3,12,59,59],[2029,11,4,1,59,59],
          '2029012013:00:00','2029012102:00:00','2029110312:59:59','2029110401:59:59' ],
        [ [2029,11,3,13,0,0],[2029,11,4,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2030,1,19,12,59,59],[2030,1,20,2,59,59],
          '2029110313:00:00','2029110403:00:00','2030011912:59:59','2030012002:59:59' ],
     ],
   2030 =>
     [
        [ [2030,1,19,13,0,0],[2030,1,20,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2030,11,2,12,59,59],[2030,11,3,1,59,59],
          '2030011913:00:00','2030012002:00:00','2030110212:59:59','2030110301:59:59' ],
        [ [2030,11,2,13,0,0],[2030,11,3,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2031,1,18,12,59,59],[2031,1,19,2,59,59],
          '2030110213:00:00','2030110303:00:00','2031011812:59:59','2031011902:59:59' ],
     ],
   2031 =>
     [
        [ [2031,1,18,13,0,0],[2031,1,19,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2031,11,1,12,59,59],[2031,11,2,1,59,59],
          '2031011813:00:00','2031011902:00:00','2031110112:59:59','2031110201:59:59' ],
        [ [2031,11,1,13,0,0],[2031,11,2,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2032,1,17,12,59,59],[2032,1,18,2,59,59],
          '2031110113:00:00','2031110203:00:00','2032011712:59:59','2032011802:59:59' ],
     ],
   2032 =>
     [
        [ [2032,1,17,13,0,0],[2032,1,18,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2032,11,6,12,59,59],[2032,11,7,1,59,59],
          '2032011713:00:00','2032011802:00:00','2032110612:59:59','2032110701:59:59' ],
        [ [2032,11,6,13,0,0],[2032,11,7,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2033,1,15,12,59,59],[2033,1,16,2,59,59],
          '2032110613:00:00','2032110703:00:00','2033011512:59:59','2033011602:59:59' ],
     ],
   2033 =>
     [
        [ [2033,1,15,13,0,0],[2033,1,16,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2033,11,5,12,59,59],[2033,11,6,1,59,59],
          '2033011513:00:00','2033011602:00:00','2033110512:59:59','2033110601:59:59' ],
        [ [2033,11,5,13,0,0],[2033,11,6,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2034,1,14,12,59,59],[2034,1,15,2,59,59],
          '2033110513:00:00','2033110603:00:00','2034011412:59:59','2034011502:59:59' ],
     ],
   2034 =>
     [
        [ [2034,1,14,13,0,0],[2034,1,15,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2034,11,4,12,59,59],[2034,11,5,1,59,59],
          '2034011413:00:00','2034011502:00:00','2034110412:59:59','2034110501:59:59' ],
        [ [2034,11,4,13,0,0],[2034,11,5,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2035,1,20,12,59,59],[2035,1,21,2,59,59],
          '2034110413:00:00','2034110503:00:00','2035012012:59:59','2035012102:59:59' ],
     ],
   2035 =>
     [
        [ [2035,1,20,13,0,0],[2035,1,21,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2035,11,3,12,59,59],[2035,11,4,1,59,59],
          '2035012013:00:00','2035012102:00:00','2035110312:59:59','2035110401:59:59' ],
        [ [2035,11,3,13,0,0],[2035,11,4,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2036,1,19,12,59,59],[2036,1,20,2,59,59],
          '2035110313:00:00','2035110403:00:00','2036011912:59:59','2036012002:59:59' ],
     ],
   2036 =>
     [
        [ [2036,1,19,13,0,0],[2036,1,20,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2036,11,1,12,59,59],[2036,11,2,1,59,59],
          '2036011913:00:00','2036012002:00:00','2036110112:59:59','2036110201:59:59' ],
        [ [2036,11,1,13,0,0],[2036,11,2,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2037,1,17,12,59,59],[2037,1,18,2,59,59],
          '2036110113:00:00','2036110203:00:00','2037011712:59:59','2037011802:59:59' ],
     ],
   2037 =>
     [
        [ [2037,1,17,13,0,0],[2037,1,18,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2037,10,31,12,59,59],[2037,11,1,1,59,59],
          '2037011713:00:00','2037011802:00:00','2037103112:59:59','2037110101:59:59' ],
        [ [2037,10,31,13,0,0],[2037,11,1,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2038,1,16,12,59,59],[2038,1,17,2,59,59],
          '2037103113:00:00','2037110103:00:00','2038011612:59:59','2038011702:59:59' ],
     ],
   2038 =>
     [
        [ [2038,1,16,13,0,0],[2038,1,17,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2038,11,6,12,59,59],[2038,11,7,1,59,59],
          '2038011613:00:00','2038011702:00:00','2038110612:59:59','2038110701:59:59' ],
        [ [2038,11,6,13,0,0],[2038,11,7,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2039,1,15,12,59,59],[2039,1,16,2,59,59],
          '2038110613:00:00','2038110703:00:00','2039011512:59:59','2039011602:59:59' ],
     ],
   2039 =>
     [
        [ [2039,1,15,13,0,0],[2039,1,16,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2039,11,5,12,59,59],[2039,11,6,1,59,59],
          '2039011513:00:00','2039011602:00:00','2039110512:59:59','2039110601:59:59' ],
        [ [2039,11,5,13,0,0],[2039,11,6,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2040,1,14,12,59,59],[2040,1,15,2,59,59],
          '2039110513:00:00','2039110603:00:00','2040011412:59:59','2040011502:59:59' ],
     ],
   2040 =>
     [
        [ [2040,1,14,13,0,0],[2040,1,15,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2040,11,3,12,59,59],[2040,11,4,1,59,59],
          '2040011413:00:00','2040011502:00:00','2040110312:59:59','2040110401:59:59' ],
        [ [2040,11,3,13,0,0],[2040,11,4,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2041,1,19,12,59,59],[2041,1,20,2,59,59],
          '2040110313:00:00','2040110403:00:00','2041011912:59:59','2041012002:59:59' ],
     ],
   2041 =>
     [
        [ [2041,1,19,13,0,0],[2041,1,20,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2041,11,2,12,59,59],[2041,11,3,1,59,59],
          '2041011913:00:00','2041012002:00:00','2041110212:59:59','2041110301:59:59' ],
        [ [2041,11,2,13,0,0],[2041,11,3,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2042,1,18,12,59,59],[2042,1,19,2,59,59],
          '2041110213:00:00','2041110303:00:00','2042011812:59:59','2042011902:59:59' ],
     ],
   2042 =>
     [
        [ [2042,1,18,13,0,0],[2042,1,19,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2042,11,1,12,59,59],[2042,11,2,1,59,59],
          '2042011813:00:00','2042011902:00:00','2042110112:59:59','2042110201:59:59' ],
        [ [2042,11,1,13,0,0],[2042,11,2,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2043,1,17,12,59,59],[2043,1,18,2,59,59],
          '2042110113:00:00','2042110203:00:00','2043011712:59:59','2043011802:59:59' ],
     ],
   2043 =>
     [
        [ [2043,1,17,13,0,0],[2043,1,18,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2043,10,31,12,59,59],[2043,11,1,1,59,59],
          '2043011713:00:00','2043011802:00:00','2043103112:59:59','2043110101:59:59' ],
        [ [2043,10,31,13,0,0],[2043,11,1,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2044,1,16,12,59,59],[2044,1,17,2,59,59],
          '2043103113:00:00','2043110103:00:00','2044011612:59:59','2044011702:59:59' ],
     ],
   2044 =>
     [
        [ [2044,1,16,13,0,0],[2044,1,17,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2044,11,5,12,59,59],[2044,11,6,1,59,59],
          '2044011613:00:00','2044011702:00:00','2044110512:59:59','2044110601:59:59' ],
        [ [2044,11,5,13,0,0],[2044,11,6,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2045,1,14,12,59,59],[2045,1,15,2,59,59],
          '2044110513:00:00','2044110603:00:00','2045011412:59:59','2045011502:59:59' ],
     ],
   2045 =>
     [
        [ [2045,1,14,13,0,0],[2045,1,15,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2045,11,4,12,59,59],[2045,11,5,1,59,59],
          '2045011413:00:00','2045011502:00:00','2045110412:59:59','2045110501:59:59' ],
        [ [2045,11,4,13,0,0],[2045,11,5,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2046,1,20,12,59,59],[2046,1,21,2,59,59],
          '2045110413:00:00','2045110503:00:00','2046012012:59:59','2046012102:59:59' ],
     ],
   2046 =>
     [
        [ [2046,1,20,13,0,0],[2046,1,21,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2046,11,3,12,59,59],[2046,11,4,1,59,59],
          '2046012013:00:00','2046012102:00:00','2046110312:59:59','2046110401:59:59' ],
        [ [2046,11,3,13,0,0],[2046,11,4,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2047,1,19,12,59,59],[2047,1,20,2,59,59],
          '2046110313:00:00','2046110403:00:00','2047011912:59:59','2047012002:59:59' ],
     ],
   2047 =>
     [
        [ [2047,1,19,13,0,0],[2047,1,20,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2047,11,2,12,59,59],[2047,11,3,1,59,59],
          '2047011913:00:00','2047012002:00:00','2047110212:59:59','2047110301:59:59' ],
        [ [2047,11,2,13,0,0],[2047,11,3,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2048,1,18,12,59,59],[2048,1,19,2,59,59],
          '2047110213:00:00','2047110303:00:00','2048011812:59:59','2048011902:59:59' ],
     ],
   2048 =>
     [
        [ [2048,1,18,13,0,0],[2048,1,19,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2048,10,31,12,59,59],[2048,11,1,1,59,59],
          '2048011813:00:00','2048011902:00:00','2048103112:59:59','2048110101:59:59' ],
        [ [2048,10,31,13,0,0],[2048,11,1,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2049,1,16,12,59,59],[2049,1,17,2,59,59],
          '2048103113:00:00','2048110103:00:00','2049011612:59:59','2049011702:59:59' ],
     ],
   2049 =>
     [
        [ [2049,1,16,13,0,0],[2049,1,17,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2049,11,6,12,59,59],[2049,11,7,1,59,59],
          '2049011613:00:00','2049011702:00:00','2049110612:59:59','2049110701:59:59' ],
        [ [2049,11,6,13,0,0],[2049,11,7,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2050,1,15,12,59,59],[2050,1,16,2,59,59],
          '2049110613:00:00','2049110703:00:00','2050011512:59:59','2050011602:59:59' ],
     ],
   2050 =>
     [
        [ [2050,1,15,13,0,0],[2050,1,16,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2050,11,5,12,59,59],[2050,11,6,1,59,59],
          '2050011513:00:00','2050011602:00:00','2050110512:59:59','2050110601:59:59' ],
        [ [2050,11,5,13,0,0],[2050,11,6,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2051,1,14,12,59,59],[2051,1,15,2,59,59],
          '2050110513:00:00','2050110603:00:00','2051011412:59:59','2051011502:59:59' ],
     ],
   2051 =>
     [
        [ [2051,1,14,13,0,0],[2051,1,15,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2051,11,4,12,59,59],[2051,11,5,1,59,59],
          '2051011413:00:00','2051011502:00:00','2051110412:59:59','2051110501:59:59' ],
        [ [2051,11,4,13,0,0],[2051,11,5,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2052,1,20,12,59,59],[2052,1,21,2,59,59],
          '2051110413:00:00','2051110503:00:00','2052012012:59:59','2052012102:59:59' ],
     ],
   2052 =>
     [
        [ [2052,1,20,13,0,0],[2052,1,21,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2052,11,2,12,59,59],[2052,11,3,1,59,59],
          '2052012013:00:00','2052012102:00:00','2052110212:59:59','2052110301:59:59' ],
        [ [2052,11,2,13,0,0],[2052,11,3,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2053,1,18,12,59,59],[2053,1,19,2,59,59],
          '2052110213:00:00','2052110303:00:00','2053011812:59:59','2053011902:59:59' ],
     ],
   2053 =>
     [
        [ [2053,1,18,13,0,0],[2053,1,19,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2053,11,1,12,59,59],[2053,11,2,1,59,59],
          '2053011813:00:00','2053011902:00:00','2053110112:59:59','2053110201:59:59' ],
        [ [2053,11,1,13,0,0],[2053,11,2,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2054,1,17,12,59,59],[2054,1,18,2,59,59],
          '2053110113:00:00','2053110203:00:00','2054011712:59:59','2054011802:59:59' ],
     ],
   2054 =>
     [
        [ [2054,1,17,13,0,0],[2054,1,18,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2054,10,31,12,59,59],[2054,11,1,1,59,59],
          '2054011713:00:00','2054011802:00:00','2054103112:59:59','2054110101:59:59' ],
        [ [2054,10,31,13,0,0],[2054,11,1,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2055,1,16,12,59,59],[2055,1,17,2,59,59],
          '2054103113:00:00','2054110103:00:00','2055011612:59:59','2055011702:59:59' ],
     ],
   2055 =>
     [
        [ [2055,1,16,13,0,0],[2055,1,17,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2055,11,6,12,59,59],[2055,11,7,1,59,59],
          '2055011613:00:00','2055011702:00:00','2055110612:59:59','2055110701:59:59' ],
        [ [2055,11,6,13,0,0],[2055,11,7,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2056,1,15,12,59,59],[2056,1,16,2,59,59],
          '2055110613:00:00','2055110703:00:00','2056011512:59:59','2056011602:59:59' ],
     ],
   2056 =>
     [
        [ [2056,1,15,13,0,0],[2056,1,16,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2056,11,4,12,59,59],[2056,11,5,1,59,59],
          '2056011513:00:00','2056011602:00:00','2056110412:59:59','2056110501:59:59' ],
        [ [2056,11,4,13,0,0],[2056,11,5,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2057,1,20,12,59,59],[2057,1,21,2,59,59],
          '2056110413:00:00','2056110503:00:00','2057012012:59:59','2057012102:59:59' ],
     ],
   2057 =>
     [
        [ [2057,1,20,13,0,0],[2057,1,21,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2057,11,3,12,59,59],[2057,11,4,1,59,59],
          '2057012013:00:00','2057012102:00:00','2057110312:59:59','2057110401:59:59' ],
        [ [2057,11,3,13,0,0],[2057,11,4,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2058,1,19,12,59,59],[2058,1,20,2,59,59],
          '2057110313:00:00','2057110403:00:00','2058011912:59:59','2058012002:59:59' ],
     ],
   2058 =>
     [
        [ [2058,1,19,13,0,0],[2058,1,20,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2058,11,2,12,59,59],[2058,11,3,1,59,59],
          '2058011913:00:00','2058012002:00:00','2058110212:59:59','2058110301:59:59' ],
        [ [2058,11,2,13,0,0],[2058,11,3,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2059,1,18,12,59,59],[2059,1,19,2,59,59],
          '2058110213:00:00','2058110303:00:00','2059011812:59:59','2059011902:59:59' ],
     ],
   2059 =>
     [
        [ [2059,1,18,13,0,0],[2059,1,19,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2059,11,1,12,59,59],[2059,11,2,1,59,59],
          '2059011813:00:00','2059011902:00:00','2059110112:59:59','2059110201:59:59' ],
        [ [2059,11,1,13,0,0],[2059,11,2,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2060,1,17,12,59,59],[2060,1,18,2,59,59],
          '2059110113:00:00','2059110203:00:00','2060011712:59:59','2060011802:59:59' ],
     ],
   2060 =>
     [
        [ [2060,1,17,13,0,0],[2060,1,18,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2060,11,6,12,59,59],[2060,11,7,1,59,59],
          '2060011713:00:00','2060011802:00:00','2060110612:59:59','2060110701:59:59' ],
        [ [2060,11,6,13,0,0],[2060,11,7,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2061,1,15,12,59,59],[2061,1,16,2,59,59],
          '2060110613:00:00','2060110703:00:00','2061011512:59:59','2061011602:59:59' ],
     ],
   2061 =>
     [
        [ [2061,1,15,13,0,0],[2061,1,16,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2061,11,5,12,59,59],[2061,11,6,1,59,59],
          '2061011513:00:00','2061011602:00:00','2061110512:59:59','2061110601:59:59' ],
        [ [2061,11,5,13,0,0],[2061,11,6,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2062,1,14,12,59,59],[2062,1,15,2,59,59],
          '2061110513:00:00','2061110603:00:00','2062011412:59:59','2062011502:59:59' ],
     ],
   2062 =>
     [
        [ [2062,1,14,13,0,0],[2062,1,15,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2062,11,4,12,59,59],[2062,11,5,1,59,59],
          '2062011413:00:00','2062011502:00:00','2062110412:59:59','2062110501:59:59' ],
        [ [2062,11,4,13,0,0],[2062,11,5,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2063,1,20,12,59,59],[2063,1,21,2,59,59],
          '2062110413:00:00','2062110503:00:00','2063012012:59:59','2063012102:59:59' ],
     ],
   2063 =>
     [
        [ [2063,1,20,13,0,0],[2063,1,21,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2063,11,3,12,59,59],[2063,11,4,1,59,59],
          '2063012013:00:00','2063012102:00:00','2063110312:59:59','2063110401:59:59' ],
        [ [2063,11,3,13,0,0],[2063,11,4,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2064,1,19,12,59,59],[2064,1,20,2,59,59],
          '2063110313:00:00','2063110403:00:00','2064011912:59:59','2064012002:59:59' ],
     ],
   2064 =>
     [
        [ [2064,1,19,13,0,0],[2064,1,20,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2064,11,1,12,59,59],[2064,11,2,1,59,59],
          '2064011913:00:00','2064012002:00:00','2064110112:59:59','2064110201:59:59' ],
        [ [2064,11,1,13,0,0],[2064,11,2,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2065,1,17,12,59,59],[2065,1,18,2,59,59],
          '2064110113:00:00','2064110203:00:00','2065011712:59:59','2065011802:59:59' ],
     ],
   2065 =>
     [
        [ [2065,1,17,13,0,0],[2065,1,18,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2065,10,31,12,59,59],[2065,11,1,1,59,59],
          '2065011713:00:00','2065011802:00:00','2065103112:59:59','2065110101:59:59' ],
        [ [2065,10,31,13,0,0],[2065,11,1,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2066,1,16,12,59,59],[2066,1,17,2,59,59],
          '2065103113:00:00','2065110103:00:00','2066011612:59:59','2066011702:59:59' ],
     ],
   2066 =>
     [
        [ [2066,1,16,13,0,0],[2066,1,17,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2066,11,6,12,59,59],[2066,11,7,1,59,59],
          '2066011613:00:00','2066011702:00:00','2066110612:59:59','2066110701:59:59' ],
        [ [2066,11,6,13,0,0],[2066,11,7,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2067,1,15,12,59,59],[2067,1,16,2,59,59],
          '2066110613:00:00','2066110703:00:00','2067011512:59:59','2067011602:59:59' ],
     ],
   2067 =>
     [
        [ [2067,1,15,13,0,0],[2067,1,16,2,0,0],'+13:00:00',[13,0,0],
          '+13',0,[2067,11,5,12,59,59],[2067,11,6,1,59,59],
          '2067011513:00:00','2067011602:00:00','2067110512:59:59','2067110601:59:59' ],
        [ [2067,11,5,13,0,0],[2067,11,6,3,0,0],'+14:00:00',[14,0,0],
          '+14',1,[2068,1,14,12,59,59],[2068,1,15,2,59,59],
          '2067110513:00:00','2067110603:00:00','2068011412:59:59','2068011502:59:59' ],
     ],
);

%LastRule      = (
   'zone'   => {
                'dstoff' => '+14:00:00',
                'stdoff' => '+13:00:00',
               },
   'rules'  => {
                '01' => {
                         'flag'    => 'ge',
                         'dow'     => '7',
                         'num'     => '15',
                         'type'    => 'w',
                         'time'    => '03:00:00',
                         'isdst'   => '0',
                         'abb'     => '+13',
                        },
                '11' => {
                         'flag'    => 'ge',
                         'dow'     => '7',
                         'num'     => '1',
                         'type'    => 'w',
                         'time'    => '02:00:00',
                         'isdst'   => '1',
                         'abb'     => '+14',
                        },
               },
);

1;