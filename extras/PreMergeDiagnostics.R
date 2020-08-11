outputFolder <- "E:/ScyllaCharacterization/Diagnostics"
CohortDiagnostics::preMergeDiagnosticsFiles(file.path(outputFolder,"target"))
CohortDiagnostics::preMergeDiagnosticsFiles(file.path(outputFolder,"feature"))
CohortDiagnostics::preMergeDiagnosticsFiles(file.path(outputFolder,"subgroup"))