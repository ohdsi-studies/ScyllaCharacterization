@target_subgroup_xref_table_create

DELETE FROM @cohort_database_schema.@cohort_staging_table
WHERE cohort_definition_id IN (SELECT DISTINCT cohort_id FROM #TARGET_SUBGROUP_XREF)
;

INSERT INTO @cohort_database_schema.@cohort_staging_table (
  cohort_definition_id,
  subject_id,
  cohort_start_date,
  cohort_end_date
)
SELECT 
  x.cohort_id,
  t.subject_id,
  t.cohort_start_date,
  t.cohort_end_date
FROM #TARGET_SUBGROUP_XREF x
inner join
(
   select cohort_definition_id, subject_id, cohort_start_date, cohort_end_date
   from @cohort_database_schema.@cohort_staging_table c
) t ON t.cohort_definition_id = x.target_id
inner join
(
   select cohort_definition_id, subject_id, cohort_start_date, cohort_end_date
   from @cohort_database_schema.@cohort_staging_table c
   where c.cohort_definition_id = @subgroup_cohort_id
) s
ON t.subject_id = s.subject_id
WHERE DATEDIFF(dd,t.cohort_start_date,s.cohort_start_date) @lb_operator @lb_subgroup_value
and DATEDIFF(dd,t.cohort_start_date,s.cohort_start_date) @ub_operator @ub_subgroup_value
and s.cohort_end_date >= t.cohort_start_date
;


@target_subgroup_xref_table_drop
