Executing the study package
===========================================================================================

**NOTE**: This guide assumes you have performed the steps in the [study package setup guide](STUDY-PACKAGE-SETUP.md). 

This guide will take you through the process of running the study to produce cohort diagnostics and the characterization results. 

## .Renviron setup

To start, we'll create a file called `.Renviron` to hold the settings specific to your environment such as the details to connect to your CDM database. 

The [study package setup guide](STUDY-PACKAGE-SETUP.md) referenced the `projectRootFolder` directory which we will use the run the study and hold the results. In this directory, create a new file named `.Renviron` (**file name is case sensitive**) and paste in the following values:

````
DBMS = "redshift"
DB_CONNECTION_STRING = "jdbc:redshift://server:5439/database"
DB_USER = "database_user_name_goes_here"
DB_PASSWORD = "super_secret_password_goes_here"
````