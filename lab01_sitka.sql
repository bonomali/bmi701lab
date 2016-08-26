# The MIT License (MIT)
# 
#   Copyright (c) 2016 Wei-Hung Weng
# 
#   Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#   
#   The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE. 
# 
# Title : BMI701 Lab 1: SQL
# Author : Wei-Hung Weng
# Created : 08/25/2016
# Comment : sitka

DROP DATABASE IF EXISTS sitka;
CREATE DATABASE sitka
DEFAULT CHARACTER SET = 'ascii' COLLATE = 'ascii_general_ci';
USE sitka;  

CREATE TABLE `sitka`.`sitka` (
  `index` INT(3) NOT NULL COMMENT '',
  `size` FLOAT NULL COMMENT '',
  `date` VARCHAR(10) COMMENT '',
  `dob` VARCHAR(10) COMMENT '',
  `tree` INT(2) NULL COMMENT '',
  `treat` VARCHAR(8) NULL COMMENT '',
  PRIMARY KEY (`index`) COMMENT '');

TRUNCATE TABLE sitka.sitka;

LOAD DATA LOCAL INFILE '/Users/weng/Desktop/lab5_sitka.csv' 
INTO TABLE sitka.sitka
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;