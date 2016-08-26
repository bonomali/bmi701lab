USE gwas;
SELECT * FROM gwas;
SELECT * FROM gwas LIMIT 5;
SELECT gene FROM gwas WHERE chr_id = 22;
SELECT distinct gene, trait, p_value FROM gwas WHERE allele like 'A' ORDER BY p_value;
SELECT gene, trait FROM gwas WHERE trait like '%diabetes_';
SELECT gene, trait FROM gwas WHERE trait like '%diabetes%';
SELECT gene, trait FROM gwas WHERE trait like 'diabetes';
SELECT GROUP_CONCAT(DISTINCT gene SEPARATOR ',') FROM gwas WHERE chr_id = 3;


USE sitka;
SELECT * FROM sitka LIMIT 1;
SELECT count(*) FROM sitka;
SELECT avg(size) FROM sitka;
SELECT min(size) FROM sitka;
SELECT max(size) FROM sitka;
SELECT stddev(size) FROM sitka;
SELECT tree, avg(size) FROM sitka GROUP BY tree;


USE snomedct;
SELECT curr_description_f.conceptid, curr_description_f.term, curr_textdefinition_f.term 
FROM curr_description_f LEFT JOIN curr_textdefinition_f 
ON curr_description_f.conceptid LIKE curr_textdefinition_f.conceptid
WHERE curr_description_f.conceptid LIKE '%777%' LIMIT 30;


USE sitka;
SELECT * FROM sitka WHERE treat LIKE '%ozo%';
SELECT * FROM (SELECT * FROM sitka WHERE treat LIKE '%ozo%') oz WHERE size > 5.0;

