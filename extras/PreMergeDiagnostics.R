outputFolder <- "E:/ScyllaCharacterization/Diagnostics"
CohortDiagnostics::preMergeDiagnosticsFiles(file.path(outputFolder,"target"))
CohortDiagnostics::preMergeDiagnosticsFiles(file.path(outputFolder,"feature"))
CohortDiagnostics::preMergeDiagnosticsFiles(file.path(outputFolder,"subgroup"))

resultsDir <- "E:/ScyllaCharacterization/Results"
ScyllaCharacterization::preMergeResultsFiles(resultsDir)
ScyllaCharacterization::launchShinyApp(resultsDir)