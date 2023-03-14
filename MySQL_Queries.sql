
USE substance_addiction;

-- change diseaseID to nonbrain_diseaseID in nonbrain_patient_disease table

ALTER TABLE nonbrain_patient_disease
CHANGE COLUMN diseaseID nonbrain_diseaseID INT(11);

ALTER TABLE brain_patient_disease
CHANGE COLUMN diseaseID brain_diseaseID INT(11);

ALTER TABLE patients_information
CHANGE COLUMN ID patientID INT(11);

-- Query 1: The count of patient in each category of substance abuse

SELECT 
  SUM(CASE WHEN su.substance_name = 'Alcohol Related Disorder' THEN 1 ELSE 0 END) AS alcohol,
  SUM(CASE WHEN su.substance_name = 'Drug Substance Disorder' THEN 1 ELSE 0 END) AS drug,
  SUM(CASE WHEN su.substance_name = 'Opioid Related Disorder' THEN 1 ELSE 0 END) AS opioid,
  SUM(CASE WHEN su.substance_name = 'Smoke(d)' THEN 1 ELSE 0 END) AS cigarettes,
  SUM(CASE WHEN su.substance_name = 'Cannabis use' THEN 1 ELSE 0 END) AS cannabis
FROM patients_information p
JOIN substance_use_patient sup ON p.patientID = sup.patientID
JOIN substance_use su ON sup.substance_useID = su.substance_useID;

-- Query 2: Among the patients that are addicted to any substance what is the most often non brain related disease observed

SELECT nrd.disease_name, 
	COUNT(nbpd.patientID) AS patient_count
FROM nonbrain_related_disease nrd
JOIN nonbrain_patient_disease nbpd ON nbpd.nonbrain_diseaseID = nrd.nonbrain_diseaseID
JOIN substance_use_patient sup ON sup.patientID = nbpd.patientID
JOIN substance_use su ON su.substance_useID = sup.substance_useID 
AND su.substance_name = 'substance related disorder'
GROUP BY nrd.disease_name
ORDER BY patient_count DESC;

-- Query 3: Among the patients that are addicted to any substance what is the most often brain related disease observed

SELECT brd.disease_name, 
	COUNT(bpd.patientID) AS patient_count
FROM brain_related_disease brd
JOIN brain_patient_disease bpd ON bpd.brain_diseaseID = brd.brain_diseaseID
JOIN substance_use_patient sup ON sup.patientID = bpd.patientID
JOIN substance_use su ON su.substance_useID = sup.substance_useID 
AND su.substance_name = 'substance related disorder'
GROUP BY brd.disease_name
ORDER BY patient_count DESC;

-- Query 4: Criminal justice and substance abuse

SELECT pi.`Criminal Justice Status`,
    COUNT(DISTINCT sp.patientID) AS total_patients,
    COUNT(DISTINCT CASE WHEN su.substance_name = 'substance related disorder' THEN sp.patientID END) 
			AS substance_related_patients,
    ROUND(COUNT(DISTINCT CASE WHEN su.substance_name = 'substance related disorder' THEN sp.patientID
                END) / COUNT(DISTINCT sp.patientID) * 100, 2) AS percentage
FROM patients_information pi
JOIN substance_use_patient sp ON pi.patientID = sp.patientID
JOIN substance_use su ON sp.substance_useID = su.substance_useID
GROUP BY pi.`Criminal Justice Status`
ORDER BY percentage DESC;

-- Query 5: What religous profile is most affected by addiction in propotion

SELECT pi.`Religious Preference`,
    COUNT(DISTINCT sp.patientID) AS total_patients,
    COUNT(DISTINCT CASE WHEN su.substance_name = 'substance related disorder' THEN sp.patientID END) 
			AS substance_related_patients,
    ROUND(COUNT(DISTINCT CASE WHEN su.substance_name = 'substance related disorder' THEN sp.patientID
                END) / COUNT(DISTINCT sp.patientID) * 100, 2) AS percentage
FROM patients_information pi
JOIN substance_use_patient sp ON pi.patientID = sp.patientID
JOIN substance_use su ON sp.substance_useID = su.substance_useID
GROUP BY pi.`Religious Preference`
ORDER BY percentage DESC;
    


