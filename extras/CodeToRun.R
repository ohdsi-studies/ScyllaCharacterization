# Please see code in extras/ProjectSetup.R to ensure
# you have installed and initialized "renv" for this
# project.
library(ScyllaCharacterization)

# Specify where the temporary files (used by the Andromeda package) will be created:
andromedaTempFolder <- if (Sys.getenv("ANDROMEDA_TEMP_FOLDER") == "") "~/andromedaTemp" else Sys.getenv("ANDROMEDA_TEMP_FOLDER")
options(andromedaTempFolder = andromedaTempFolder)

# Details for connecting to the server:
dbms = Sys.getenv("DBMS")
user <- if (Sys.getenv("DB_USER") == "") NULL else Sys.getenv("DB_USER")
password <- if (Sys.getenv("DB_PASSWORD") == "") NULL else Sys.getenv("DB_PASSWORD")
connectionString <- if (Sys.getenv("DB_CONNECTION_STRING") == "") NULL else Sys.getenv("DB_CONNECTION_STRING")
server = Sys.getenv("DB_SERVER")
port = Sys.getenv("DB_PORT")
# For Oracle: define a schema that can be used to emulate temp tables:
oracleTempSchema <- NULL

if (!is.null(connectionString)) {
  connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = dbms,
                                                                  connectionString = connectionString,
                                                                  user = user,
                                                                  password = password)
  
} else {
  connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = dbms,
                                                                  server = server,
                                                                  user = user,
                                                                  password = password,
                                                                  port = port)
  
}

# Details specific to the database:
databaseId <- "CDM_HealthVerity_COVID_v1304"
databaseName <- "CDM_HealthVerity_COVID_v1304"
databaseDescription <- "CDM_HealthVerity_COVID_v1304"

# Details for connecting to the CDM and storing the results
cdmDatabaseSchema <- "cdm_1304"
cohortDatabaseSchema <- "ohdsi_results_1304"
cohortTable <- paste0("AS_ScyllaChar_", databaseId)
cohortStagingTable <- paste0(cohortTable, "_stg")
featureSummaryTable <- paste0(cohortTable, "_smry")
minCellCount <- 5

# Set the folder for holding the study output
projectRootFolder <- "E:/ScyllaCharacterization"
outputFolder <- file.path(projectRootFolder, databaseId)
if (!dir.exists(outputFolder)) {
  dir.create(outputFolder)
}
setwd(outputFolder)

# Details for running the study.
cohortIdsToExcludeFromExecution <- c()
cohortIdsToExcludeFromResultsExport <- NULL

# Run cohort diagnostics -----------------------------------
runCohortDiagnostics(connectionDetails = connectionDetails,
                     cdmDatabaseSchema = cdmDatabaseSchema,
                     cohortDatabaseSchema = cohortDatabaseSchema,
                     cohortStagingTable = cohortStagingTable,
                     oracleTempSchema = oracleTempSchema,
                     cohortIdsToExcludeFromExecution = cohortIdsToExcludeFromExecution,
                     exportFolder = outputFolder,
                     databaseId = databaseId,
                     databaseName = databaseName,
                     databaseDescription = databaseDescription,
                     minCellCount = minCellCount)

# Use the next command to review cohort diagnostics and replace "target" with
# one of these options: "target", "subgroup", "feature"
# CohortDiagnostics::launchDiagnosticsExplorer(file.path(outputFolder, "diagnostics", "target"))

# Use this to run the study. The results will be stored in a zip file called 
# 'Results_<databaseId>.zip in the outputFolder. 
runStudy(connectionDetails = connectionDetails,
         cdmDatabaseSchema = cdmDatabaseSchema,
         cohortDatabaseSchema = cohortDatabaseSchema,
         cohortStagingTable = cohortStagingTable,
         cohortTable = cohortTable,
         featureSummaryTable = featureSummaryTable,
         oracleTempSchema = cohortDatabaseSchema,
         exportFolder = outputFolder,
         databaseId = databaseId,
         databaseName = databaseName,
         databaseDescription = databaseDescription,
         cohortIdsToExcludeFromExecution = cohortIdsToExcludeFromExecution,
         cohortIdsToExcludeFromResultsExport = cohortIdsToExcludeFromResultsExport,
         incremental = TRUE,
         minCellCount = minCellCount) 


# Use the next set of commands to compress results
# and view the output.
#preMergeResultsFiles(outputFolder)
#launchShinyApp(outputFolder)

# For uploading the results. You should have received the key file from the study coordinator:
keyFileName <- "E:/ScyllaCharacterization/study-data-site-covid19.dat"
userName <- "study-data-site-covid19"

# When finished with reviewing the diagnostics, use the next command
# to upload the diagnostic results
#uploadDiagnosticsResults(outputFolder, keyFileName, userName)


# When finished with reviewing the results, use the next command
# upload study results to OHDSI SFTP server:
#uploadStudyResults(outputFolder, keyFileName, userName)
