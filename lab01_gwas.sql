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
# Comment : GWAS catalog dump

DROP DATABASE IF EXISTS gwas;
CREATE DATABASE gwas
DEFAULT CHARACTER SET = 'ascii' COLLATE = 'ascii_general_ci';
USE gwas;  

CREATE TABLE `gwas`.`gwas` (
  `marker_accession` INT(9) NOT NULL COMMENT '',
  `marker_type_name` VARCHAR(10) NULL COMMENT '',
  `chr_id` VARCHAR(2) NULL COMMENT '',
  `chr_pos` INT(9) NULL COMMENT '',
  `p_value` FLOAT NULL COMMENT '',
  `pubmed_id` VARCHAR(8) NULL COMMENT '',
  `author` VARCHAR(255) NULL COMMENT '',
  `journal` VARCHAR(255) NULL COMMENT '',
  `pubmed_link` VARCHAR(1024) NULL COMMENT '',
  `study` TEXT(65535) NULL COMMENT '',
  `allele` VARCHAR(1) NULL COMMENT '',
  `trait` TEXT(65535) NULL COMMENT '',
  `gene` VARCHAR(255) NULL COMMENT '',
  `or_per_copy` FLOAT NULL COMMENT '',
  `platform` VARCHAR(255) NULL COMMENT '',
  `ci_95` VARCHAR(64) NULL COMMENT '',
  `chr_location` VARCHAR(8) NULL COMMENT '',
  `initial_size` VARCHAR(1024) NULL COMMENT '',
  `replicate_size` VARCHAR(1024) NULL COMMENT '',
  `merged` INT(1) NULL COMMENT '',
  `cur_snp_id` INT(9) NULL COMMENT '',
  `snp_gene_symbols` VARCHAR(16) NULL COMMENT '',
  `snp_gene_ids` VARCHAR(10) NULL COMMENT '',
  `snp_gene_validated` INT(1) NULL COMMENT '',
  PRIMARY KEY (`marker_accession`) COMMENT '');

TRUNCATE TABLE gwas.gwas;

LOAD DATA LOCAL INFILE '/Users/weng/Desktop/GWASCatalogDump.txt' 
INTO TABLE gwas.gwas
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;