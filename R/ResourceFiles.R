getBulkSubgroup <- function() {
  resourceFile <- file.path(getPathToResource(), "BulkSubgroup.csv")
  return(readCsv(resourceFile))
}

getCohortGroupNamesForDiagnostics <- function() {
  return(getCohortGroupsForDiagnostics()$cohortGroup)
}

getCohortGroupsForDiagnostics <- function () {
  resourceFile <- file.path(getPathToResource(), "CohortGroupsDiagnostics.csv")
  return(readCsv(resourceFile))
}

getCohortGroups <- function () {
  resourceFile <- file.path(getPathToResource(), "CohortGroups.csv")
  return(readCsv(resourceFile))
}

getCohortBasedSubgroup <- function() {
  resourceFile <- file.path(getPathToResource(), "CohortsToCreateSubgroup.csv")
  return(readCsv(resourceFile))
}

getFeatures <- function() {
  resourceFile <- file.path(getPathToResource(), "CohortsToCreateFeature.csv")
  return(readCsv(resourceFile))
}

getFeatureTimeWindows <- function() {
  resourceFile <- file.path(getPathToResource(), "featureTimeWindows.csv")
  return(readCsv(resourceFile))
}

getTargetSubgroupXref <- function() {
  resourceFile <- file.path(getPathToResource(), "targetSubgroupXref.csv")
  return(readCsv(resourceFile))
}

#' @export
getCohortsToCreate <- function(cohortGroups = getCohortGroups()) {
  packageName <- getThisPackageName()
  cohorts <- data.frame()
  for(i in 1:nrow(cohortGroups)) {
    c <- readr::read_csv(system.file(cohortGroups$fileName[i], package = packageName, mustWork = TRUE), col_types = readr::cols())
    c$cohortType <- cohortGroups$cohortGroup[i]
    cohorts <- rbind(cohorts, c)
  }
  return(cohorts)  
}

getAllSubgroup <- function() {
  colNames <- c("name", "cohortId", "generationScript") # Use this to subset to the columns of interest
  bulkSubgroup <- getBulkSubgroup()
  bulkSubgroup <- bulkSubgroup[, match(colNames, names(bulkSubgroup))]
  atlasCohortSubgroup <- getCohortBasedSubgroup()
  atlasCohortSubgroup$generationScript <- paste0(atlasCohortSubgroup$cohortId, ".sql")
  atlasCohortSubgroup <- atlasCohortSubgroup[, match(colNames, names(atlasCohortSubgroup))]
  subgroup <- rbind(bulkSubgroup, atlasCohortSubgroup)
  return(subgroup)  
}

getAllStudyCohorts <- function() {
  cohortsToCreate <- getCohortsToCreate()
  targetSubgroupXref <- getTargetSubgroupXref()
  colNames <- c("name", "cohortId")
  cohortsToCreate <- cohortsToCreate[, match(colNames, names(cohortsToCreate))]
  targetSubgroupXref <- targetSubgroupXref[, match(colNames, names(targetSubgroupXref))]
  allCohorts <- rbind(cohortsToCreate, targetSubgroupXref)
  return(allCohorts)
}

#' @export
getAllStudyCohortsWithDetails <- function() {
  cohortsToCreate <- getCohortsToCreate()
  targetSubgroupXref <- getTargetSubgroupXref()
  allSubgroup <- getAllSubgroup()
  colNames <- c("cohortId", "cohortName", "targetCohortId", "targetCohortName", "subgroupCohortId", "subgroupCohortName", "cohortType")
  # Format - cohortsToCreate
  cohortsToCreate$targetCohortId <- cohortsToCreate$cohortId
  cohortsToCreate$targetCohortName <- cohortsToCreate$name
  cohortsToCreate$subgroupCohortId <- 0
  cohortsToCreate$subgroupCohortName <- "All"
  cohortsToCreate <- dplyr::rename(cohortsToCreate, cohortName = "name")
  cohortsToCreate <- cohortsToCreate[, match(colNames, names(cohortsToCreate))]
  # Format - targetSubgroupXref
  stratifiedCohorts <- dplyr::inner_join(targetSubgroupXref, cohortsToCreate[,c("targetCohortId", "targetCohortName")], by = c("targetId" = "targetCohortId"))
  stratifiedCohorts <- dplyr::inner_join(stratifiedCohorts, allSubgroup[,c("cohortId", "name")], by=c("subgroupId" = "cohortId"))
  stratifiedCohorts <- dplyr::rename(stratifiedCohorts, targetCohortId="targetId",subgroupCohortId="subgroupId",cohortName="name.x",subgroupCohortName="name.y")
  stratifiedCohorts <- stratifiedCohorts[,match(colNames, names(stratifiedCohorts))]
  # Bind
  allCohorts <- rbind(cohortsToCreate, stratifiedCohorts)
  return(allCohorts)
}

getThisPackageName <- function() {
  return("ScyllaCharacterization")
}

readCsv <- function(resourceFile) {
  packageName <- getThisPackageName()
  pathToCsv <- system.file(resourceFile, package = packageName, mustWork = TRUE)
  fileContents <- readr::read_csv(pathToCsv, col_types = readr::cols())
  return(fileContents)
}

getPathToResource <- function() {
  return("settings")
}
