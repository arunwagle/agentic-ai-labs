-- =============================================================================
-- Member Claims Sample Queries - workshop
-- Metric View: aira_test.aibi_workshop_mv_schema.member_claims_metric_view_workshop
-- =============================================================================

-- =============================================================================
-- FINANCIAL OVERVIEW
-- =============================================================================

-- Q1: Monthly financial summary — total paid, PMPM, and rolling 3-month PMPM
-- Business Question: What are the monthly cost trends and how does the smoothed PMPM compare?
SELECT
  service_month,
  MEASURE(total_paid) AS total_paid,
  MEASURE(unique_members) AS members,
  MEASURE(member_months) AS member_months,
  MEASURE(pmpm) AS pmpm,
  MEASURE(rolling_3m_pmpm) AS rolling_3m_pmpm
FROM aira_test.aibi_workshop_mv_schema.member_claims_metric_view_workshop
GROUP BY service_month
ORDER BY service_month;

-- Q2: Top 5 cost drivers by Line of Business
-- Business Question: Which lines of business have the highest total paid amounts?
SELECT
  line_of_business,
  MEASURE(total_paid) AS total_paid,
  MEASURE(total_claims) AS total_claims,
  MEASURE(pmpm) AS pmpm,
  MEASURE(avg_paid_per_claim) AS avg_paid_per_claim
FROM aira_test.aibi_workshop_mv_schema.member_claims_metric_view_workshop
GROUP BY line_of_business
ORDER BY total_paid DESC;

-- =============================================================================
-- CLAIMS ANALYSIS
-- =============================================================================

-- Q3: Claims operational metrics — denial rate, clean claim rate, pay-to-billed
-- Business Question: How efficient is our claims processing pipeline?
SELECT
  service_month,
  MEASURE(denial_rate) AS denial_rate,
  MEASURE(clean_claim_rate) AS clean_claim_rate,
  MEASURE(payment_to_billed_ratio) AS pay_to_billed,
  MEASURE(payment_to_allowed_ratio) AS pay_to_allowed
FROM aira_test.aibi_workshop_mv_schema.member_claims_metric_view_workshop
GROUP BY service_month
ORDER BY service_month;

-- Q4: Average paid per claim by claim type (Institutional vs Professional)
-- Business Question: How do inpatient and outpatient costs compare?
SELECT
  claim_type,
  MEASURE(total_claims) AS total_claims,
  MEASURE(total_paid) AS total_paid,
  MEASURE(avg_paid_per_claim) AS avg_paid_per_claim,
  MEASURE(lines_per_claim) AS lines_per_claim
FROM aira_test.aibi_workshop_mv_schema.member_claims_metric_view_workshop
GROUP BY claim_type
ORDER BY total_paid DESC;

-- Q5: Inpatient vs Outpatient paid amounts by month
-- Business Question: What is the monthly trend for institutional vs professional spending?
SELECT
  service_month,
  MEASURE(inpatient_paid) AS inpatient_paid,
  MEASURE(outpatient_paid) AS outpatient_paid,
  MEASURE(total_paid) AS total_paid
FROM aira_test.aibi_workshop_mv_schema.member_claims_metric_view_workshop
GROUP BY service_month
ORDER BY service_month;

-- =============================================================================
-- MEMBER DEMOGRAPHICS
-- =============================================================================

-- Q6: Member distribution by age group and sex
-- Business Question: What is the demographic profile of our claims population?
SELECT
  member_age_group,
  member_sex,
  MEASURE(unique_members) AS member_count,
  MEASURE(total_paid) AS total_paid,
  MEASURE(avg_paid_per_member) AS avg_paid_per_member
FROM aira_test.aibi_workshop_mv_schema.member_claims_metric_view_workshop
GROUP BY member_age_group, member_sex
ORDER BY member_age_group, member_sex;

-- Q7: Members by state — geographic distribution
-- Business Question: Where are our highest-cost member populations located?
SELECT
  member_state,
  MEASURE(unique_members) AS member_count,
  MEASURE(total_paid) AS total_paid,
  MEASURE(pmpm) AS pmpm,
  MEASURE(claims_per_1000_members) AS claims_per_1000
FROM aira_test.aibi_workshop_mv_schema.member_claims_metric_view_workshop
GROUP BY member_state
ORDER BY total_paid DESC
LIMIT 15;

-- =============================================================================
-- UTILIZATION & PROVIDER
-- =============================================================================

-- Q8: Claims per 1,000 members and utilization by LOB
-- Business Question: Which insurance products have the highest utilization rates?
SELECT
  line_of_business,
  MEASURE(claims_per_1000_members) AS claims_per_1000,
  MEASURE(claims_per_member) AS claims_per_member,
  MEASURE(lines_per_claim) AS lines_per_claim,
  MEASURE(unique_members) AS member_count
FROM aira_test.aibi_workshop_mv_schema.member_claims_metric_view_workshop
GROUP BY line_of_business
ORDER BY claims_per_1000 DESC;

-- Q9: Provider specialty rankings by total paid
-- Business Question: Which provider specialties are driving the most cost?
SELECT
  provider_specialty,
  MEASURE(total_paid) AS total_paid,
  MEASURE(total_claims) AS total_claims,
  MEASURE(avg_paid_per_claim) AS avg_paid_per_claim,
  MEASURE(par_provider_rate) AS par_provider_rate
FROM aira_test.aibi_workshop_mv_schema.member_claims_metric_view_workshop
WHERE provider_specialty IS NOT NULL
GROUP BY provider_specialty
ORDER BY total_paid DESC
LIMIT 10;

-- Q10: Participating provider rate trend
-- Business Question: Is our in-network utilization improving over time?
SELECT
  service_month,
  MEASURE(par_provider_rate) AS par_provider_rate,
  MEASURE(par_paid) AS par_paid,
  MEASURE(total_paid) AS total_paid
FROM aira_test.aibi_workshop_mv_schema.member_claims_metric_view_workshop
GROUP BY service_month
ORDER BY service_month;

-- =============================================================================
-- WINDOW MEASURES & TRENDS
-- =============================================================================

-- Q11: Month-over-month member growth with rolling PMPM
-- Business Question: How is membership trending alongside cost per member?
SELECT
  service_month,
  MEASURE(current_month_members) AS current_members,
  MEASURE(previous_month_members) AS prior_members,
  MEASURE(mom_active_member_growth) AS mom_growth,
  MEASURE(rolling_3m_pmpm) AS rolling_3m_pmpm
FROM aira_test.aibi_workshop_mv_schema.member_claims_metric_view_workshop
GROUP BY service_month
ORDER BY service_month;

-- Q12: Denial trends by month and line status
-- Business Question: Are denial rates improving or worsening over time?
SELECT
  service_month,
  line_status,
  MEASURE(total_claim_lines) AS line_count,
  MEASURE(total_paid) AS total_paid
FROM aira_test.aibi_workshop_mv_schema.member_claims_metric_view_workshop
GROUP BY service_month, line_status
ORDER BY service_month, line_status;
