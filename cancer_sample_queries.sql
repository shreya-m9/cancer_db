-- Some sample queries to display utility of the database...in the future connecting this to an app/some web interface would be ideal

use cancer_db;

-- Which global reigon are most patients from and what is the average air pollution and population?
select country_reigon, round(avg(aqi), 1) as avg_aqi, round(avg(country_population), 1) as avg_population, count(patient_id) AS patient_count
from patient
join country using (country_id)
group by country_reigon
order by patient_count desc;

-- What cancer is most associated with particulate types of workplace hazards?
select cancer_name, count(cancer_name) as particulate_hazard_count
from patient
join contains using (occupation_id)
join hazards using (hazard_id)
join patient_case using (patient_id)
join cancer using (cancer_id)
where hazards.hazard_type = 'Particulate'
group by cancer_name
order by particulate_hazard_count desc;

-- What is the number of distinct affected genes associated with each cancer, from least to greatest?
select cancer_name, count(distinct gene_id) as gene_count
from cancer 
left join affected_gene using (cancer_id)
group by cancer_name
order by gene_count;

-- What are the 5 most common cancer patient profiles (country and occupation)?
select country_name, occupation_name, cancer_name, count(patient_id) as profile_count
from patient 
join country using (country_id)
join occupation using (occupation_id)
join patient_case using (patient_id)
join cancer using (cancer_id)
group by country_name, occupation_name, cancer_name
order by profile_count desc
limit 5;

-- What type of gene mutation (single nucleotide variant, insertion/deletion, etc.) is most common in the most diagnosed type of cancer?
select cancer_name, mutation_type, count(mutation_type) as mutation_type_count
from affected_gene
join cancer using (cancer_id)
where cancer_id = (
    select cancer_id
    from patient_case
    group by cancer_id
    order by count(distinct patient_id) desc
    limit 1
)
group by cancer_name, mutation_type
order by mutation_type_count desc;

-- Does the most common cancer in Asian patients have a proven pathogenic relationship with any gene? Which ones?
select distinct cancer_name, gene_name, relationship, mutation_type
from patient 
join country using (country_id)
join patient_case using (patient_id)
join cancer on patient_case.cancer_id = cancer.cancer_id
join affected_gene on cancer.cancer_id = affected_gene.cancer_id
join gene using (gene_id)
where country.country_reigon = 'ASIA'
  and affected_gene.relationship = 'Pathogenic'
  and cancer.cancer_id = (
      select cancer_id
      from patient p
      join country c using (country_id)
      join patient_case pc using (patient_id)
      where c.country_reigon = 'ASIA'
      group by pc.cancer_id
      order by count(distinct pc.patient_id) desc
      limit 1
  )
order by gene_name;

-- Do patients in high pollution countries (AQI > 100) get diagnosed at a later stage of cancer than those in lower pollution countries?
select 
    case 
		when aqi > 100 then 'High Pollution'
        else 'Low Pollution' 
    end as pollution_level,
    round(avg(diagnosis_cancer_stage), 0) as avg_stage,
    round(avg(diagnosis_age), 1) as avg_age,
    count(distinct patient_id) as patient_count
from patient
join country using (country_id)
join patient_case using (patient_id)
group by pollution_level
order by avg_stage desc;
         
-- For each profile with a unique high-pollution country (AQI > 100) and occupation that contains a radiation hazard, 
-- what is the average cancer diagnosis age and stage? Which genes are implicated in those cancers?
select country_name, aqi, occupation_name, hazard_name, cancer_name, gene_name, avg_stage, avg_age
from (
	select 
		patient_case.cancer_id, 
        country_name, 
        aqi, 
        occupation_name, 
        hazard_name, 
        round(avg(diagnosis_age), 1) as avg_age, 
        round(avg(diagnosis_cancer_stage), 0) as avg_stage
	from patient
	join country using (country_id)
	join occupation on patient.occupation_id = occupation.occupation_id
	join contains on contains.occupation_id = occupation.occupation_id
	join hazards using (hazard_id)
	join patient_case using (patient_id)
	where aqi > 100 and hazard_type = "Radiation"
	group by country_name, aqi, occupation_name, hazard_name, patient_case.cancer_id) as tmp
join cancer on cancer.cancer_id = tmp.cancer_id
join affected_gene on cancer.cancer_id = affected_gene.cancer_id
join gene using (gene_id)
group by country_name, aqi, occupation_name, hazard_name, cancer_name, gene_name, avg_age, avg_stage 
order by avg_stage desc, avg_age desc;-- Shreya M. : Cancer Project SQL Queries

use cancer_db;

-- Which global reigon are most patients from and what is the average air pollution and population?
select country_reigon, round(avg(aqi), 1) as avg_aqi, round(avg(country_population), 1) as avg_population, count(patient_id) AS patient_count
from patient
join country using (country_id)
group by country_reigon
order by patient_count desc;

-- What cancer is most associated with particulate types of workplace hazards?
select cancer_name, count(cancer_name) as particulate_hazard_count
from patient
join contains using (occupation_id)
join hazards using (hazard_id)
join patient_case using (patient_id)
join cancer using (cancer_id)
where hazards.hazard_type = 'Particulate'
group by cancer_name
order by particulate_hazard_count desc;

-- What is the number of distinct affected genes associated with each cancer, from least to greatest?
select cancer_name, count(distinct gene_id) as gene_count
from cancer 
left join affected_gene using (cancer_id)
group by cancer_name
order by gene_count;

-- What are the 5 most common cancer patient profiles (country and occupation)?
select country_name, occupation_name, cancer_name, count(patient_id) as profile_count
from patient 
join country using (country_id)
join occupation using (occupation_id)
join patient_case using (patient_id)
join cancer using (cancer_id)
group by country_name, occupation_name, cancer_name
order by profile_count desc
limit 5;

-- What type of gene mutation (single nucleotide variant, insertion/deletion, etc.) is most common in the most diagnosed type of cancer?
select cancer_name, mutation_type, count(mutation_type) as mutation_type_count
from affected_gene
join cancer using (cancer_id)
where cancer_id = (
    select cancer_id
    from patient_case
    group by cancer_id
    order by count(distinct patient_id) desc
    limit 1
)
group by cancer_name, mutation_type
order by mutation_type_count desc;

-- Does the most common cancer in Asian patients have a proven pathogenic relationship with any gene? Which ones?
select distinct cancer_name, gene_name, relationship, mutation_type
from patient 
join country using (country_id)
join patient_case using (patient_id)
join cancer on patient_case.cancer_id = cancer.cancer_id
join affected_gene on cancer.cancer_id = affected_gene.cancer_id
join gene using (gene_id)
where country.country_reigon = 'ASIA'
  and affected_gene.relationship = 'Pathogenic'
  and cancer.cancer_id = (
      select cancer_id
      from patient p
      join country c using (country_id)
      join patient_case pc using (patient_id)
      where c.country_reigon = 'ASIA'
      group by pc.cancer_id
      order by count(distinct pc.patient_id) desc
      limit 1
  )
order by gene_name;

-- Do patients in high pollution countries (AQI > 100) get diagnosed at a later stage of cancer than those in lower pollution countries?
select 
    case 
		when aqi > 100 then 'High Pollution'
        else 'Low Pollution' 
    end as pollution_level,
    round(avg(diagnosis_cancer_stage), 0) as avg_stage,
    round(avg(diagnosis_age), 1) as avg_age,
    count(distinct patient_id) as patient_count
from patient
join country using (country_id)
join patient_case using (patient_id)
group by pollution_level
order by avg_stage desc;
         
-- For each profile with a unique high-pollution country (AQI > 100) and occupation that contains a radiation hazard, 
-- what is the average cancer diagnosis age and stage? Which genes are implicated in those cancers?
select country_name, aqi, occupation_name, hazard_name, cancer_name, gene_name, avg_stage, avg_age
from (
	select 
		patient_case.cancer_id, 
        country_name, 
        aqi, 
        occupation_name, 
        hazard_name, 
        round(avg(diagnosis_age), 1) as avg_age, 
        round(avg(diagnosis_cancer_stage), 0) as avg_stage
	from patient
	join country using (country_id)
	join occupation on patient.occupation_id = occupation.occupation_id
	join contains on contains.occupation_id = occupation.occupation_id
	join hazards using (hazard_id)
	join patient_case using (patient_id)
	where aqi > 100 and hazard_type = "Radiation"
	group by country_name, aqi, occupation_name, hazard_name, patient_case.cancer_id) as tmp
join cancer on cancer.cancer_id = tmp.cancer_id
join affected_gene on cancer.cancer_id = affected_gene.cancer_id
join gene using (gene_id)
group by country_name, aqi, occupation_name, hazard_name, cancer_name, gene_name, avg_age, avg_stage 
order by avg_stage desc, avg_age desc;