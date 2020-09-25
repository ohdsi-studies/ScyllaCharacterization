outputFolder <- "E:/ScyllaCharacterization/Diagnostics"
CohortDiagnostics::preMergeDiagnosticsFiles(file.path(outputFolder,"target"))
CohortDiagnostics::preMergeDiagnosticsFiles(file.path(outputFolder,"feature"))
CohortDiagnostics::preMergeDiagnosticsFiles(file.path(outputFolder,"subgroup"))
ScyllaCharacterization::launchDiagnosticsShinyApp(file.path(outputFolder,"target"))

resultsDir <- "E:/ScyllaCharacterization/Results"
ScyllaCharacterization::preMergeResultsFiles(resultsDir)
ScyllaCharacterization::launchShinyApp(resultsDir)