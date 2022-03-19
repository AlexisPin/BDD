-- 4ETI - Bases de données
--  Séances 1 & 2 - Requêtes SELECT
-- 2) Requêtes
--1. Afficher la liste de tous les films.
SELECT
  *
FROM
  Film;
– 2.Afficher le titre des films et leur budget pour les films de moins de 20.000.000 $ de – budget et faire afficher au niveau de chaque enregistrement ‘ Film à petit budget ’
SELECT
  titre,
  budget,
  'Film à petit budget' AS "Type"
FROM
  Film
WHERE
  budget <= 20000000;
-- 3. Donner la liste des villes (par ordre croissant) dans lesquelles les personnes résident.
SELECT
  ville
FROM
  Personne
GROUP BY
  ville
ORDER BY
  ville;
-- 4. Afficher toutes les personnes habitant sur une Avenue
SELECT
  *
FROM
  Personne
WHERE
  adresse LIKE '%Avenue%';
-- 5. Afficher toutes les personnes qui n’ont pas renseigné leur numéro de téléphone
SELECT
  *
FROM
  Personne
WHERE
  telephone IS NULL;
-- 6. Afficher pour chaque film le budget en Euros (taux de conversion 1$=0.75€)
SELECT
  titre,
  budget,
  budget * 0.75 AS "budget en euros"
FROM
  Film;
--7. Afficher les films qui ont déjà des entrées valorisées (10€ la place) supérieures à leur budget en euros.
SELECT
  titre,
  budget * 0.75 AS "budget en euros",
  (nb_spectateurs_cumule * 10) AS "recette"
FROM
  Film
WHERE
  (nb_spectateurs_cumule * 10) - (budget * 0.75) > 0;
-- 8. Afficher les cinémas triés par compagnie puis par ville.
  -- Par compagnie
SELECT
  nom,
  compagnie,
  ville
FROM
  Cinema
ORDER BY
  compagnie,
  ville;
-- 9. Rechercher les films qui ont un espace en première position dans leur titre (erreur de saisie)
SELECT
  *
FROM
  Film
WHERE
  titre LIKE ' %';
-- 10. Afficher les programmations qui ont commencé entre le 14 janvier 2013 et le 1 février 2013
SELECT
  *
FROM
  Programmation
WHERE
  Date_deb > '2013-01-14'
  AND Date_deb < '2013-02-01';
-- 11. Affichez les personnes qui ne sont ni Américains, ni Anglais ni Français
SELECT
  nom,
  prenom,
  nationalite
FROM
  Personne
WHERE
  nationalite != 'Americain'
  AND nationalite != 'Francais'
  AND nationalite != 'Anglais';
-- 12. Afficher les films avec leur genre uniquement pour le réalisateur Tarentino.
SELECT
  t1.titre,
  t3.libellegenre,
  t2.nom
FROM
  Film t1
  JOIN Personne t2 on t1.realisateur = t2.numpersonne
  JOIN Genre t3 on t1.genre = t3.numgenre
WHERE
  nom = 'Tarentino';
-- 13. Lister les nom et prénom de tous les acteurs
SELECT
  t2.nom,
  t2.prenom
FROM
  Acteur t1
  JOIN Personne t2 on t1.numpersonne = t2.numpersonne
ORDER BY
  t2.nom;
-- 14. Afficher les noms des réalisateurs habitant une ville commençant par la lettre ’N’
SELECT
  t2.nom,
  t2.prenom,
  t2.ville
FROM
  Film t1
  JOIN Personne t2 on t1.realisateur = t2.numpersonne
WHERE
  t2.ville LIKE 'N%'
GROUP BY
  t2.ville,
  t2.nom,
  t2.prenom
ORDER BY
  t2.nom;
-- 15. Trouver le titre et l’année des comédies dont le budget dépasse 500.000$
SELECT
  t1.titre,
  t1.annee
FROM
  Film t1
  JOIN Genre t2 on t1.genre = t2.numgenre
WHERE
  budget > 500000
  AND t2.libellegenre = 'Comedie';
-- 16. Afficher pour chaque réalisateur (nom, prénom) et chaque film (titre) son salaire à la minute de film
SELECT
  t2.nom,
  t2.prenom,
  t1.titre,
  t1.salaire_real / t1.longueur AS "Salaire du réalisateur à la minute"
FROM
  Film t1
  JOIN Personne t2 on t1.realisateur = t2.numpersonne;
-- 17. Trouver le titre des films qui passent dans un cinéma de la compagnie UGC.
SELECT
  DISTINCT t1.titre
FROM
  Film t1
  JOIN Programmation t2 on t1.numfilm = t2.numfilm
  JOIN Salle t3 on t2.numcinema = t3.numcinema
  JOIN Cinema t4 on t3.numcinema = t4.numcinema
WHERE
  t4.compagnie = 'UGC';
-- 18. Afficher pour chaque film, les nom et prénom des acteurs, leur salaire et leur rôle (afficher le titre du film par ordre alphabétique et le salaire par ordre décroissant).
SELECT
  t1.titre,
  t4.nom,
  t4.prenom,
  t2.salaire,
  t2.role
FROM
  Film t1
  JOIN Distribution t2 on t1.numfilm = t2.numfilm
  JOIN Acteur t3 on t2.numacteur = t3.numacteur
  JOIN Personne t4 on t3.numpersonne = t4.numpersonne
ORDER BY
  t1.titre,
  t2.salaire DESC;
-- 19. Trouver le nom et le prénom des acteurs qui ont eu touché un salaire plus important dans un film particulier que le salaire du réalisateur du même film.
SELECT
  DISTINCT t1.prenom,
  t1.nom
FROM
  Personne t1
  JOIN Acteur t2 on t1.numpersonne = t2.numpersonne
  JOIN Distribution t3 on t2.numacteur = t3.numacteur
  JOIN Film t4 on t3.numfilm = t4.numfilm
WHERE
  t4.salaire_real < t3.salaire;
-- 20. Quels sont les acteurs dramatiques (nom, prénom) qui ont joué dans un film de Hazanavicius
SELECT
  t2.prenom,
  t2.nom
FROM
  Film t1
  JOIN Personne t2 on t1.realisateur = t2.numpersonne
  JOIN Acteur t3 on t2.numpersonne = t3.numpersonne
  JOIN Genre t4 on t3.specialite = t4.numgenre
WHERE
  t4.libellegenre = 'Drame';
-- 21. Donner le nom et le prénom des réalisateurs qui ont joué dans au moins un de leurs propres films
SELECT
  pers2.prenom,
  pers2.nom
FROM
  Film film
  JOIN Personne pers1 on film.realisateur = pers1.numpersonne
  JOIN Distribution dist on film.numfilm = dist.numfilm
  JOIN Acteur act on dist.numacteur = act.numacteur
  JOIN Personne pers2 on act.numpersonne = pers2.numpersonne
  JOIN Genre gen on act.specialite = gen.numgenre
WHERE
  gen.libellegenre = 'Drame'
  AND pers1.nom = 'Hazanavicius';
--21. Donner le nom et le prénom des réalisateurs qui ont joué dans au moins un de leurs propres films