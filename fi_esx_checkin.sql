INSERT INTO `items` (name, label, weight) VALUES
    ('policebadge', 'Virkamerkki', 1)
;

INSERT INTO `jobs` (name, label) VALUES
  ('offpolice','Vapaalla')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
  ('offpolice',0,'recruit','Nuorempi konstaapeli',12,'{}','{}'),
  ('offpolice',1,'officer','Vanhempi konstaapeli',24,'{}','{}'),
  ('offpolice',2,'sergeant','Komissario',36,'{}','{}'),
  ('offpolice',3,'lieutenant','YliKomissaario',48,'{}','{}'),
  ('offpolice',4,'boss','Päällikkö',0,'{}','{}'),
;
