# Steps to create the gwas and sitka databases

1. Visit the lab material website (https://github.com/ckbjimmy/bmi701lab)
2. If you use git, then you can git clone the github repo to your laptop OR 
you can just download the zip file to somewhere in your laptop OR just directly download [here](http://bit.ly/2cEPgmH)
(let's say the downloaded path is /Users/YOUR_NAME/Downloads/bmi701lab-master/)

  - ![git](https://raw.githubusercontent.com/ckbjimmy/bmi701lab/master/img/01_git.png)

3. Make sure your MySQL Server is running. If you use the MySQL Server downloaded from MySQL website, 
you may check the running status in "System Preferences >> MySQL" and see whether server status is running

  - If you can't run the server after checking the system preferences, please check if you can restart it from terminal while executing "mysql.server restart" or "/usr/local/bin/mysql.server start"
  - If the server still not works, then try the solutions from 
  [this website](https://coolestguidesontheplanet.com/start-stop-mysql-from-the-command-line-terminal-osx-linux/) works for you
  (note that this should be executed in your terminal)
  - If you still can run the server, you can send me a mail [ckbjimmy@gmail.com](ckbjimmy@gmail.com) and we can try to set up a time to solve the problem

4. Open MySQL Workbench, click on the dolphin button (may not be "Local instance 3306" on your screen, but you can still open it)

  - If the MySQL Workbench asks for the password, it will be the password you have entered during the MySQL Server installation
  - ![mysql1](https://raw.githubusercontent.com/ckbjimmy/bmi701lab/master/img/01_mysql1.png)

5. Once getting into the MySQL Workbench screen, you can click on the folder icon at the leftmost of the bar, 
and open the file "lab01_gwas.sql" in the folder that you have downloaded (or git clone) from github

  - ![mysql2](https://raw.githubusercontent.com/ckbjimmy/bmi701lab/master/img/01_mysql2.png)

6. The first part of this SQL script is creating the database 'gwas', the second part is creating the table 'gwas', 
and the third part is to load the 'lab01_gwas.txt' into your 'gwas' database. To be noticed, you need to edit the path in 
line 62 to the place where you put the 'lab01_gwas.txt'. For example, change '/Users/weng/Desktop/GWASCatalogDump.txt' to 
'/Users/YOUR_NAME/Downloads/bmi701lab-master/lab01_gwas.txt'

7. Click on the lightning button (shown in the above figure, the left one) to execute the SQL script

  - You will see the warning after execution. This is normal since the 'marker_accession' column actually has duplicated items and it can't be the primary key. However here we just want to show how to create the schema, table and load the data, so it's fine.

8. Refresh the schema to see whether the 'gwas' schema is there (refresh button is the left one)
  - ![schema](https://raw.githubusercontent.com/ckbjimmy/bmi701lab/master/img/01_schema.png)

9. Expand the 'gwas' schema and you can see the 'gwas' table inside. You can click on the third button (next to the screw driver) to see the content of the table
  - ![table](https://raw.githubusercontent.com/ckbjimmy/bmi701lab/master/img/01_table.png)

10. Now the 'gwas' table is there, and you can start playing with the SQL syntax in the [slides](https://github.com/ckbjimmy/bmi701lab/blob/master/lab01.pdf) (or directly copy them from [code](https://github.com/ckbjimmy/bmi701lab/blob/master/lab01.sql))
  - ![query](https://raw.githubusercontent.com/ckbjimmy/bmi701lab/master/img/01_query.png)

11. You can use the same steps to import the 'lab01_sitka.csv', just remember to change the path

- Feel free to mail me at [ckbjimmy@gmail.com](ckbjimmy@gmail) if you want to discuss more about the steps!
