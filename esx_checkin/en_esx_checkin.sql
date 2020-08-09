INSERT INTO `items` (name, label, weight) VALUES
    ('policebadge', 'Policebadge', 1)
;

INSERT INTO `jobs` (name, label) VALUES
  ('offpolice','Off-Duty')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
  ('offpolice',0,'recruit','Recruit',12,'{}','{}'),
  ('offpolice',1,'officer','Officer',24,'{}','{}'),
  ('offpolice',2,'sergeant','Sergeant',36,'{}','{}'),
  ('offpolice',3,'lieutenant','Lieutenant',48,'{}','{}'),
  ('offpolice',4,'boss','Chief',0,'{}','{}'),
;
