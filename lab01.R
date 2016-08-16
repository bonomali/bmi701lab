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
# Title : BMI701 Lab 1: RDB
# Author : Wei-Hung Weng
# Created : 08/16/2016
# Comment : 


# List of packages for session
.packages <- c("RMySQL", "RPostgreSQL", "sqldf")
# Install CRAN packages (if not already installed)
.inst <- .packages %in% installed.packages()
if(length(.packages[!.inst]) > 0) install.packages(.packages[!.inst])
# Load packages into session 
lapply(.packages, library, character.only=TRUE)


# connection
con = dbConnect(MySQL(), user="root", password="", 
                dbname="hpo", host="127.0.0.1")

dbListTables(con)

dbGetQuery(con, "select * from term limit 5")
dbGetQuery(con, "select * from term2term limit 5")
dbGetQuery(con, "select * from term_definition limit 5")

# join table

# disconnection
cons = dbListConnections(MySQL())
for (con in cons) {dbDisconnect(con)}
cons = dbListConnections(dbDriver("PostgreSQL"))
for (con in cons) {dbDisconnect(con)}
rm(con, cons)

