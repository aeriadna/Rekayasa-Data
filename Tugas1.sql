CREATE DATABASE tugas1;

USE tugas1;

CREATE TABLE pokemon (
	pokemon_id VARCHAR(255),
    pokemon_name VARCHAR(255),
    primary_type VARCHAR(255),
    secondary_type VARCHAR(255),
    first_appereance VARCHAR(255),
    generation VARCHAR(255),
    category VARCHAR(255),
    total_base_stats INT,
    hp INT,
    attack INT,
    defense INT,
    special_attack INT,
    special_defense INT,
    speed INT,
    PRIMARY KEY (pokemon_id, pokemon_name)
);

ALTER TABLE pokemon
MODIFY COLUMN pokemon_id INT;

SELECT pokemon_name, COUNT(*) AS duplicate_name
FROM pokemon
GROUP BY pokemon_name
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS empty_count
FROM pokemon
WHERE secondary_type = '';

SELECT primary_type, secondary_type, first_appereance, generation, category, 
       total_base_stats, hp, attack, defense, special_attack, special_defense, speed, 
       COUNT(*) AS duplicate_count
FROM pokemon
GROUP BY primary_type, secondary_type, first_appereance, generation, category, 
         total_base_stats, hp, attack, defense, special_attack, special_defense, speed
HAVING COUNT(*) > 1;

SELECT 
    GROUP_CONCAT(DISTINCT pokemon_name ORDER BY pokemon_name SEPARATOR ', ') AS different_names,
    primary_type, secondary_type, first_appereance, generation, category,
    total_base_stats, hp, attack, defense, special_attack, special_defense, speed,
    COUNT(*) AS duplicate_count
FROM pokemon
GROUP BY primary_type, secondary_type, first_appereance, generation, category,
         total_base_stats, hp, attack, defense, special_attack, special_defense, speed
HAVING COUNT(*) > 1;

SELECT 
    'total_base_stats' AS column_name, AVG(total_base_stats) AS average, STDDEV(total_base_stats) AS std, MAX(total_base_stats) AS max, MIN(total_base_stats) AS min 
FROM pokemon
UNION ALL
SELECT 
    'hp', AVG(hp), STDDEV(hp), MAX(hp), MIN(hp) 
FROM pokemon
UNION ALL
SELECT 
    'attack', AVG(attack), STDDEV(attack), MAX(attack), MIN(attack) 
FROM pokemon
UNION ALL
SELECT 
    'defense', AVG(defense), STDDEV(defense), MAX(defense), MIN(defense) 
FROM pokemon
UNION ALL
SELECT 
    'special_attack', AVG(special_attack), STDDEV(special_attack), MAX(special_attack), MIN(special_attack) 
FROM pokemon
UNION ALL
SELECT 
    'special_defense', AVG(special_defense), STDDEV(special_defense), MAX(special_defense), MIN(special_defense) 
FROM pokemon
UNION ALL
SELECT 
    'speed', AVG(speed), STDDEV(speed), MAX(speed), MIN(speed) 
FROM pokemon;

SELECT 'primary_type' AS column_name, primary_type AS kategori, COUNT(*) AS frekuensi
FROM pokemon GROUP BY primary_type
UNION ALL
SELECT 'secondary_type', secondary_type, COUNT(*)
FROM pokemon GROUP BY secondary_type
UNION ALL
SELECT 'first_appereance', first_appereance, COUNT(*)
FROM pokemon GROUP BY first_appereance
UNION ALL
SELECT 'generation', generation, COUNT(*)
FROM pokemon GROUP BY generation
UNION ALL
SELECT 'category', category, COUNT(*)
FROM pokemon GROUP BY category;

SELECT *
FROM pokemon
WHERE pokemon_name LIKE 'X%';

SELECT * 
FROM pokemon 
WHERE LENGTH(pokemon_name) = (SELECT MAX(LENGTH(pokemon_name)) FROM pokemon);

SELECT primary_type, COUNT(*) AS total_count
FROM pokemon
GROUP BY primary_type
ORDER BY total_count DESC
LIMIT 1;

SELECT pokemon_name, generation
FROM pokemon
WHERE secondary_type <> '';

SELECT pokemon_id, pokemon_name, hp, attack, defense, special_attack, special_defense, speed
FROM pokemon
WHERE special_attack > (SELECT AVG(special_attack) FROM pokemon);

SELECT pokemon_name, total_base_stats, attack
FROM pokemon
WHERE attack < (SELECT AVG(attack) FROM pokemon);

SELECT pokemon_name, total_base_stats, defense
FROM pokemon
WHERE defense BETWEEN 100 AND 150;

SELECT pokemon_name
FROM pokemon
WHERE total_base_stats > (SELECT AVG(total_base_stats) FROM pokemon)
  AND attack < (SELECT AVG(attack) FROM pokemon);

SELECT pokemon_name, total_base_stats,
       CASE 
           WHEN total_base_stats >= 601 THEN 'Sangat Kuat (OP/Legenda)'
           WHEN total_base_stats >= 500 THEN 'Kuat'
           WHEN total_base_stats >= 300 THEN 'Sedang'
           ELSE 'Lemah'
       END AS kategori
FROM pokemon
ORDER BY total_base_stats DESC;

SELECT generation, pokemon_name, total_base_stats
FROM pokemon
WHERE category = 'legendary'
ORDER BY generation ASC, total_base_stats DESC;

SELECT generation, AVG(total_base_stats) AS avg_tbs
FROM pokemon
WHERE category = 'legendary'
GROUP BY generation
ORDER BY generation;

SELECT pokemon_name, category, 'HP' AS stat_type, max_stat
FROM (SELECT pokemon_name, category, hp AS max_stat FROM pokemon ORDER BY hp DESC LIMIT 1) AS hp_max
UNION ALL
SELECT pokemon_name, category, 'Attack', max_stat
FROM (SELECT pokemon_name, category, attack AS max_stat FROM pokemon ORDER BY attack DESC LIMIT 1) AS attack_max
UNION ALL
SELECT pokemon_name, category, 'Defense', max_stat
FROM (SELECT pokemon_name, category, defense AS max_stat FROM pokemon ORDER BY defense DESC LIMIT 1) AS defense_max
UNION ALL
SELECT pokemon_name, category, 'Special Attack', max_stat
FROM (SELECT pokemon_name, category, special_attack AS max_stat FROM pokemon ORDER BY special_attack DESC LIMIT 1) AS sp_atk_max
UNION ALL
SELECT pokemon_name, category, 'Special Defense', max_stat
FROM (SELECT pokemon_name, category, special_defense AS max_stat FROM pokemon ORDER BY special_defense DESC LIMIT 1) AS sp_def_max
UNION ALL
SELECT pokemon_name, category, 'Speed', max_stat
FROM (SELECT pokemon_name, category, speed AS max_stat FROM pokemon ORDER BY speed DESC LIMIT 1) AS speed_max;


WITH strongest AS (
    SELECT pokemon_name, attack, special_attack 
    FROM pokemon 
    ORDER BY attack DESC 
    LIMIT 1
)
SELECT COUNT(*) AS total_bad_pokemon
FROM pokemon p, strongest s
WHERE p.hp <= (s.attack + s.special_attack - p.defense - p.special_defense);

WITH most_defensive AS (
    SELECT defense, attack, speed 
    FROM pokemon 
    ORDER BY defense DESC 
    LIMIT 1
),
faster_pokemon AS (
    SELECT COUNT(*) AS fast_count
    FROM pokemon p, most_defensive d
    WHERE p.attack > d.attack AND p.speed > d.speed
),
total_pokemon AS (
    SELECT COUNT(*) AS total_count FROM pokemon
)
SELECT 
    (f.fast_count * 100.0 / t.total_count) AS percentage_faster
FROM faster_pokemon f, total_pokemon t;

