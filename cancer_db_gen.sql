-- This script generates the schema and data for a database that helps explore the relationship between patient background and their cancer cases in order to find meaningful patterns. 

DROP DATABASE IF EXISTS cancer_db;
CREATE DATABASE IF NOT EXISTS cancer_db;
USE cancer_db;

CREATE TABLE IF NOT EXISTS country (
  country_id INT PRIMARY KEY AUTO_INCREMENT,
  country_name VARCHAR(45) NOT NULL,
  country_population BIGINT NOT NULL,
  country_reigon VARCHAR(45) NOT NULL,
  aqi DECIMAL NOT NULL);

LOAD DATA INFILE '/usr/local/mysql/country_data.csv'
INTO TABLE country
FIELDS TERMINATED BY ','
IGNORE 1 LINES
(country_name, country_reigon, aqi, country_population);

CREATE TABLE IF NOT EXISTS occupation (
  occupation_id INT PRIMARY KEY,
  occupation_name VARCHAR(45) NOT NULL,
  occupation_industry VARCHAR(45) NOT NULL);
  
INSERT INTO occupation (occupation_id, occupation_name, occupation_industry)
VALUES
(1, 'Coal Miner', 'Mining'),
(2, 'Asbestos Removal Worker', 'Construction'),
(3, 'Petroleum Refinery Operator', 'Oil & Gas'),
(4, 'Pesticide Applicator', 'Agriculture'),
(5, 'Radiologist', 'Healthcare'),
(6, 'Firefighter', 'Emergency Services'),
(7, 'Shipyard Welder', 'Manufacturing'),
(8, 'Chemical Plant Technician', 'Chemical Industry'),
(9, 'Software Engineer', 'Technology'),
(10, 'Accountant', 'Finance'),
(11, 'Teacher', 'Education'),
(12, 'Truck Driver', 'Transportation'),
(13, 'Farmer', 'Agriculture'),
(14, 'Nurse', 'Healthcare'),
(15, 'Office Administrator', 'Corporate');

CREATE TABLE IF NOT EXISTS patient (
  patient_id INT PRIMARY KEY,
  sex VARCHAR(45) NOT NULL,
  country_id INT NOT NULL,
  occupation_id INT NOT NULL,
  FOREIGN KEY (country_id)
    REFERENCES country (country_id),
  FOREIGN KEY (occupation_id)
    REFERENCES occupation (occupation_id)
);

INSERT INTO patient (patient_id, sex, country_id, occupation_id)
VALUES
(1,  'Male',   29,  1),   -- China (AQI 156), Coal Miner
(2,  'Male',   61,  3),   -- India (AQI 162), Petroleum Refinery Operator
(3,  'Female', 63,  8),   -- Iran (AQI 248), Chemical Plant Technician
(4,  'Male',   64,  1),   -- Iraq (AQI 214), Coal Miner
(5,  'Male',   111, 4),   -- Saudi Arabia (AQI 272), Pesticide Applicator
(6,  'Female', 111, 6),   -- Saudi Arabia (AQI 272), Firefighter
(7,  'Male',   29,  7),   -- China (AQI 156), Shipyard Welder
(8,  'Female', 61,  2),   -- India (AQI 162), Asbestos Removal Worker
(9,  'Male',   106, 3),   -- Qatar (AQI 183), Petroleum Refinery Operator
(10, 'Female', 63,  8),   -- Iran (AQI 248), Chemical Plant Technician
(11, 'Male',   10,  1),   -- Bahrain (AQI 163), Coal Miner
(12, 'Male',   11,  7),   -- Bangladesh (AQI 141), Shipyard Welder
(13, 'Female', 29,  4),   -- China (AQI 156), Pesticide Applicator
(14, 'Male',   64,  6),   -- Iraq (AQI 214), Firefighter
(15, 'Female', 99,  2),   -- Pakistan (AQI 91), Asbestos Removal Worker
(16, 'Male',   61,  5),   -- India (AQI 162), Radiologist
(17, 'Female', 135, 6),   -- United States (AQI 112), Firefighter
(18, 'Male',   135, 1),   -- United States (AQI 112), Coal Miner
(19, 'Female', 88,  8),   -- Mexico (AQI 101), Chemical Plant Technician
(20, 'Male',   97,  7),   -- Nigeria (AQI 105), Shipyard Welder
(21, 'Female', 135, 9),   -- United States, Software Engineer
(22, 'Male',   134, 11),  -- United Kingdom, Teacher
(23, 'Female', 44,  15),  -- France, Office Administrator
(24, 'Male',   49,  10),  -- Germany, Accountant
(25, 'Female', 23,  14),  -- Canada, Nurse
(26, 'Male',   7,   12),  -- Australia, Truck Driver
(27, 'Female', 52,  13),  -- Greece, Farmer
(28, 'Male',   18,  15),  -- Brazil, Office Administrator
(29, 'Female', 109, 14),  -- Russia, Nurse
(30, 'Male',   119, 12);  -- Spain, Truck Driver

CREATE TABLE IF NOT EXISTS cancer (
  cancer_id INT PRIMARY KEY,
  cancer_name VARCHAR(45) NOT NULL,
  mortality_rate_pct DECIMAL(5, 1) NOT NULL
);

INSERT INTO cancer (cancer_id, cancer_name, mortality_rate_pct)
VALUES
(1, 'Lung',              30.2),
(2, 'Breast',            10.4),
(3, 'Colon and Rectum',  12.7),
(4, 'Prostate',          18.9),
(5, 'Melanoma',          2.0),
(6, 'Brain',             4.4),
(7, 'Hodgkin Lymphoma',  0.2);

CREATE TABLE IF NOT EXISTS patient_case (
  case_id INT PRIMARY KEY,
  diagnosis_age INT NOT NULL,
  diagnosis_cancer_stage INT NOT NULL,
  diagnosis_year INT NOT NULL,
  patient_id INT NOT NULL,
  cancer_id INT NOT NULL,
  FOREIGN KEY (patient_id)
    REFERENCES patient (patient_id),
  FOREIGN KEY (cancer_id)
    REFERENCES cancer (cancer_id)
);

INSERT INTO patient_case (case_id, diagnosis_age, diagnosis_cancer_stage, diagnosis_year, patient_id, cancer_id)
VALUES
(1,  68, 3, 2019, 1,  1),   -- Coal Miner, China -> Lung
(2,  71, 2, 2021, 2,  1),   -- Refinery Worker, India -> Lung
(3,  65, 3, 2020, 3,  3),   -- Chemical Worker, Iran -> Colon and Rectum
(4,  69, 4, 2018, 4,  1),   -- Coal Miner, Iraq -> Lung
(5,  72, 3, 2022, 5,  5),   -- Pesticide, Saudi Arabia -> Melanoma
(6,  58, 2, 2021, 6,  1),   -- Firefighter, Saudi Arabia -> Lung
(7,  66, 3, 2023, 7,  1),   -- Shipyard Welder, China -> Lung
(8,  70, 2, 2020, 8,  1),   -- Asbestos Worker, India -> Lung
(9,  63, 3, 2022, 9,  3),   -- Refinery Worker, Qatar -> Colon and Rectum
(10, 67, 2, 2021, 10, 3),   -- Chemical Worker, Iran -> Colon and Rectum
(11, 74, 4, 2019, 11, 1),   -- Coal Miner, Bahrain -> Lung
(12, 55, 2, 2022, 12, 1),   -- Shipyard Welder, Bangladesh -> Lung
(13, 68, 1, 2023, 13, 5),   -- Pesticide, China -> Melanoma
(14, 61, 3, 2020, 14, 1),   -- Firefighter, Iraq -> Lung
(15, 73, 2, 2021, 15, 1),   -- Asbestos Worker, Pakistan -> Lung
(16, 67, 1, 2023, 16, 6),   -- Radiologist, India -> Brain
(17, 52, 2, 2022, 17, 1),   -- Firefighter, USA -> Lung
(18, 69, 3, 2020, 18, 1),   -- Coal Miner, USA -> Lung
(19, 64, 2, 2021, 19, 3),   -- Chemical Worker, Mexico -> Colon and Rectum
(20, 71, 3, 2019, 20, 1),   -- Shipyard Welder, Nigeria -> Lung
(21, 45, 1, 2023, 21, 2),   -- Software Engineer, USA -> Breast
(22, 58, 2, 2022, 22, 7),   -- Teacher, UK -> Hodgkin Lymphoma
(23, 62, 1, 2023, 23, 2),   -- Office Admin, France -> Breast
(24, 70, 2, 2021, 24, 4),   -- Accountant, Germany -> Prostate
(25, 66, 1, 2022, 25, 2),   -- Nurse, Canada -> Breast
(26, 67, 2, 2020, 26, 3),   -- Truck Driver, Australia -> Colon and Rectum
(27, 59, 1, 2023, 27, 5),   -- Farmer, Greece -> Melanoma
(28, 72, 3, 2021, 28, 4),   -- Office Admin, Brazil -> Prostate
(29, 68, 2, 2022, 29, 1),   -- Nurse, Russia -> Lung
(30, 64, 2, 2023, 30, 6),   -- Truck Driver, Spain -> Brain
(31, 70, 2, 2023, 1, 3),   -- Coal Miner, China -> diagnosed with Colon and Rectum after Lung
(32, 71, 4, 2020, 4,  1),   -- Coal Miner, Iraq -> Lung (second Iraq coal miner)
(33, 65, 2, 2022, 11, 1),   -- Coal Miner, Bahrain -> Lung (second Bahrain coal miner)
(34, 63, 3, 2021, 18, 1),   -- Coal Miner, USA -> Lung (second USA coal miner)
(35, 58, 2, 2023, 7,  1);   -- Shipyard Welder, China -> Lung (second China welder)

CREATE TABLE IF NOT EXISTS gene (
  gene_id INT PRIMARY KEY,
  gene_name VARCHAR(45) NOT NULL,
  chromosome INT NOT NULL
);

LOAD DATA INFILE '/usr/local/mysql/gene_data.csv'
INTO TABLE gene
FIELDS TERMINATED BY ','
IGNORE 1 LINES
(gene_name, chromosome, gene_id);

CREATE TABLE IF NOT EXISTS affected_gene (
  mutation_type VARCHAR(45) NOT NULL,
  relationship VARCHAR(45) NOT NULL,
  cancer_id INT NOT NULL,
  gene_id INT NOT NULL,
  PRIMARY KEY (cancer_id, gene_id, mutation_type),
  FOREIGN KEY (cancer_id)
    REFERENCES cancer (cancer_id),
  FOREIGN KEY (gene_id)
    REFERENCES gene (gene_id)
);
LOAD DATA INFILE '/usr/local/mysql/affected_gene_final.csv'
INTO TABLE affected_gene
FIELDS TERMINATED BY ','
IGNORE 1 LINES
(mutation_type, relationship, cancer_id, gene_id);

CREATE TABLE IF NOT EXISTS hazards (
  hazard_id INT PRIMARY KEY,
  hazard_name VARCHAR(45) NOT NULL,
  hazard_type VARCHAR(45) NOT NULL
);

INSERT INTO hazards (hazard_id, hazard_name, hazard_type)
VALUES
(1,  'Coal Dust',              'Particulate'),
(2,  'Asbestos Fibers',        'Particulate'),
(3,  'Silica Dust',            'Particulate'),
(4,  'Benzene',                'Chemical'),
(5,  'Formaldehyde',           'Chemical'),
(6,  'Pesticide Residue',      'Chemical'),
(7,  'Ionizing Radiation',     'Radiation'),
(8,  'UV Radiation',           'Radiation'),
(9,  'Diesel Exhaust',         'Particulate'),
(10, 'Heavy Metals',           'Chemical'),
(11, 'Smoke Inhalation',       'Particulate'),
(12, 'Welding Fumes',          'Particulate'),
(13, 'Radon Gas',              'Radiation'),
(14, 'Nitrogen Dioxide',       'Chemical'),
(15, 'Polycyclic Aromatic Hydrocarbons', 'Chemical');

CREATE TABLE IF NOT EXISTS contains (
  occupation_id INT NOT NULL,
  hazard_id INT NOT NULL,
  PRIMARY KEY (hazard_id, occupation_id),
  FOREIGN KEY (occupation_id)
    REFERENCES occupation (occupation_id),
  FOREIGN KEY (hazard_id)
    REFERENCES hazards (hazard_id)
);

INSERT INTO contains (occupation_id, hazard_id)
VALUES
(1,  1),   -- Coal Miner -> Coal Dust
(1,  3),   -- Coal Miner -> Silica Dust
(1,  13),  -- Coal Miner -> Radon Gas
(2,  2),   -- Asbestos Removal Worker -> Asbestos Fibers
(2,  3),   -- Asbestos Removal Worker -> Silica Dust
(3,  4),   -- Petroleum Refinery Operator -> Benzene
(3,  9),   -- Petroleum Refinery Operator -> Diesel Exhaust
(3,  15),  -- Petroleum Refinery Operator -> Polycyclic Aromatic Hydrocarbons
(4,  6),   -- Pesticide Applicator -> Pesticide Residue
(4,  10),  -- Pesticide Applicator -> Heavy Metals
(5,  7),   -- Radiologist -> Ionizing Radiation
(6,  11),  -- Firefighter -> Smoke Inhalation
(6,  5),   -- Firefighter -> Formaldehyde
(6,  9),   -- Firefighter -> Diesel Exhaust
(7,  12),  -- Shipyard Welder -> Welding Fumes
(7,  2),   -- Shipyard Welder -> Asbestos Fibers
(7,  10),  -- Shipyard Welder -> Heavy Metals
(8,  4),   -- Chemical Plant Technician -> Benzene
(8,  5),   -- Chemical Plant Technician -> Formaldehyde
(8,  10),  -- Chemical Plant Technician -> Heavy Metals
(9,  8),   -- Software Engineer -> UV Radiation (screen exposure, minor)
(10, 8),   -- Accountant -> UV Radiation
(12, 9),   -- Truck Driver -> Diesel Exhaust
(12, 14),  -- Truck Driver -> Nitrogen Dioxide
(13, 6),   -- Farmer -> Pesticide Residue
(13, 8),   -- Farmer -> UV Radiation
(14, 5),   -- Nurse -> Formaldehyde
(14, 7),   -- Nurse -> Ionizing Radiation
(15, 8);   -- Office Administrator -> UV Radiation

CREATE INDEX idx_patient_country ON patient(country_id);
CREATE INDEX idx_patient_occupation ON patient(occupation_id);
CREATE INDEX idx_patient_case_patient ON patient_case(patient_id);
CREATE INDEX idx_patient_case_cancer ON patient_case(cancer_id);
CREATE INDEX idx_affected_gene_cancer ON affected_gene(cancer_id);
CREATE INDEX idx_affected_gene_gene ON affected_gene(gene_id);