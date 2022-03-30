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
SELECT
  pers.prenom,
  pers.nom
FROM
  Film film
  JOIN Distribution dist on film.numfilm = dist.numfilm
  JOIN Acteur act on dist.numacteur = act.numacteur
  JOIN Personne pers on act.numpersonne = pers.numpersonne
  JOIN Film film2 on pers.numpersonne = film.realisateur
GROUP BY
  pers.prenom,
  pers.nom;
--22. Donner le nombre de films des années de 2010 à 2012 par genre.
SELECT
  gen.libellegenre,
  COUNT(film.genre) AS "nombre"
FROM
  Genre gen
  JOIN Film film on gen.numgenre = film.genre
WHERE
  film.annee BETWEEN 2010
  AND 2012
GROUP BY
  gen.libellegenre;
-- 23. Quel est le total des salaires des acteurs du film « Intouchables ».
SELECT
  SUM(dist.salaire) AS "Montant des salaires"
FROM
  Film film
  JOIN Distribution dist on film.numfilm = dist.numfilm
WHERE
  film.titre = 'Intouchables';
--24. Donner la moyenne des salaires des acteurs par film, avec le titre et l’année correspondants (pour arrondir fonction : round(valeur, nombre de décimales).
SELECT
  ROUND(SUM(dist.salaire) / COUNT(dist.numfilm), 2) AS "Salaires moyens",
  film.titre,
  film.annee
FROM
  Film film
  JOIN Distribution dist on film.numfilm = dist.numfilm
GROUP BY
  film.titre,
  film.annee;
-- 25. Trouver le genre des films des années 2010 à 2012 dont le budget moyen (du genre) dépasse 30.000.000 $.
SELECT
  gen.libellegenre,
  ROUND(SUM(film.budget) / COUNT(gen.libellegenre), 2) AS "Budget moyen"
FROM
  Film film
  JOIN Genre gen on film.genre = gen.numgenre
WHERE
  film.annee BETWEEN 2010
  AND 2012
GROUP BY
  gen.libellegenre
HAVING
  ROUND(SUM(film.budget) / COUNT(gen.libellegenre), 2) > 30000000;
-- 26. Trouver le titre et l’année du ou des films les plus longs.
SELECT
  film1.titre,
  film1.annee,
  film1.longueur
FROM
  Film film1
WHERE
  film1.longueur = (
    SELECT
      MAX(longueur)
    FROM
      Film
  );
--27.Afficher les acteurs qui ont gagné plus (en tout) que tous les réalisateurs (pour tous les films réalisés)
SELECT
  pers.nom,
  pers.prenom,
  SUM(dist.salaire) AS "Salaire total"
FROM
  Personne pers
  JOIN Acteur act ON pers.numpersonne = act.numpersonne
  JOIN Distribution dist ON act.numacteur = dist.numacteur
  JOIN Film film ON dist.numfilm = film.numfilm
GROUP BY
  pers.nom,
  pers.prenom
HAVING
  SUM(dist.salaire) > (
    SELECT
      MAX(SUM(film.salaire_real)) OVER()
    FROM
      Film film
    GROUP BY
      film.realisateur
    LIMIT
      1
  );
--28. Donner le titre du film qui passe dans le cinéma ayant la plus grande taille d’écran.
SELECT
  film.titre
FROM
  Film film
  JOIN Programmation prog ON film.numfilm = prog.numfilm
  JOIN Salle sall ON prog.numcinema = sall.numcinema
  AND prog.numsalle = sall.numsalle
GROUP BY
  film.titre,
  sall.taille_ecran
HAVING
  sall.taille_ecran = (
    SELECT
      MAX(sall2.taille_ecran)
    FROM
      Salle sall2
  );
--29.Affichez le numéro du film, son titre et en fonction du budget pas chère si < 10 000 000, moyen si <50 000 000 et trop chère dans les autres cas (fonction CASE).
SELECT
  film.numfilm,
  film.titre,
  film.budget,
  CASE
    WHEN film.budget < 10000000 THEN 'pas chère'
    WHEN film.budget < 50000000 THEN 'moyen'
    ELSE 'trop chère'
  END "Importance bubget"
FROM
  Film film
ORDER BY
  "Importance bubget";
-- 30.Affichez pour chaque film la mention film visible si l’année est 2013, film récent si 2012 et film ancien si autre année (fonction CASE)
SELECT
  film.numfilm,
  film.titre,
  CASE
    WHEN film.annee = 2012 THEN 'récent'
    WHEN film.annee = 2013 THEN 'visible'
    ELSE 'ancien'
  END "mention"
FROM
  Film film
ORDER BY
  "mention" DESC;
-- 31. Rechercher les personnes (numéro et nom) qui ne sont ni réalisateur ni acteur
SELECT
  pers.numpersonne,
  pers.nom
FROM
  Personne pers
WHERE
  pers.numpersonne NOT IN (
    SELECT
      film.realisateur
    FROM
      Film film
  )
  AND pers.numpersonne NOT IN (
    SELECT
      act.numpersonne
    FROM
      Acteur act
  );
--32. Afficher les téléphones des personnes et des cinémas uniquement s’ils ont été renseignés
SELECT
  pers.telephone
FROM
  Personne pers
WHERE
  pers.telephone IS NOT NULL
UNION
SELECT
  cine.telephone
FROM
  Cinema cine
WHERE
  cine.telephone IS NOT NULL;
-- 33. Afficher tous les genres de film et les titres des films associés à chaque genre (jointure externe)
SELECT
  gen.libellegenre,
  film.titre
FROM
  Film film FULL
  OUTER JOIN Genre gen ON film.genre = gen.numgenre;
--34. Afficher les cinémas dont les salles n’ont pas été saisies dans la base (jointure externe)
SELECT
  cine.nom
FROM
  Cinema cine FULL
  OUTER JOIN Salle salle ON cine.numcinema = salle.numcinema
WHERE
  salle.numsalle IS NULL;
--35. Afficher les programmations dans toutes les salles de tous les cinémas (même si la salle n’a pas de programmation) (jointure externe)
SELECT
  cine.nom,
  salle.numsalle,
  film.titre,
  prog.date_deb,
  prog.date_fin,
  prog.horaire,
  prog.prix
FROM
  Cinema cine
  LEFT OUTER JOIN Salle salle ON cine.numcinema = salle.numcinema
  LEFT OUTER JOIN Programmation prog ON salle.numcinema = prog.numcinema
  AND salle.numsalle = prog.numsalle
  LEFT OUTER JOIN Film film ON prog.numfilm = film.numfilm;
--36. Afficher les personnes (nom, prénom) qui habitent à côté d’un cinéma (mêmes adresse et ville)
SELECT
  pers.nom,
  pers.prenom
FROM
  Personne pers
WHERE
  pers.adresse IN (
    SELECT
      cine.adresse
    FROM
      Cinema cine
  )
  AND pers.ville IN (
    SELECT
      cine.ville
    FROM
      Cinema cine
  );
--37. Quels sont les acteurs de même âge (i.e. nés la même année) ayant joué ensemble ? Afficher le titre du film, les nom, prénom et année de naissance des acteurs. Remarque : datenais ne contient que l’année de naissance
SELECT
  film.titre,
  pers.nom,
  pers.prenom,
  pers.datenais AS "ANNEE NAISSANCE",
  dist.numfilm
FROM
  Personne pers
  JOIN Acteur act ON pers.numpersonne = act.numpersonne
  JOIN Distribution dist ON act.numacteur = dist.numacteur
  JOIN Film film ON dist.numfilm = film.numfilm
WHERE
  EXISTS (
    SELECT
      'X'
    FROM
      Personne pers2
      JOIN Acteur act2 ON pers2.numpersonne = act2.numpersonne
      JOIN Distribution dist2 ON act2.numacteur = dist2.numacteur
      JOIN Film film2 ON dist2.numfilm = film2.numfilm
    WHERE
      pers2.datenais = pers.datenais
      AND film2.numfilm = film.numfilm
      AND pers2.nom != pers.nom
  );
--38. Afficher les personnes (nom, prénom) qui ne sont pas acteurs. Avec IN (ou NOT IN) puis avec EXISTS (ou NOT EXISTS)
SELECT
  pers.nom,
  pers.prenom
FROM
  Personne pers
WHERE
  NOT EXISTS (
    SELECT
      'X'
    FROM
      Acteur act
    WHERE
      act.numpersonne = pers.numpersonne
  );
SELECT
  pers.nom,
  pers.prenom
FROM
  Personne pers
WHERE
  pers.nom NOT IN (
    SELECT
      pers2.nom
    FROM
      Personne pers2
      JOIN Acteur act ON pers2.numpersonne = act.numpersonne
  );
-- 39.Trouver le titre des films qui passent dans aucun cin é ma ind é pendant (compagnie = ’ indep ’).R é pondre à cette requ ê te de 2 fa ç ons: avec IN (ou NOT IN) et avec EXISTS (ou NOT EXISTS)
SELECT
  film.titre
FROM
  Film film
WHERE
  film.numfilm NOT IN (
    SELECT
      prog.numfilm
    FROM
      Programmation prog
      JOIN Salle salle ON prog.numcinema = salle.numcinema
      AND prog.numsalle = salle.numsalle
      JOIN Cinema cine ON salle.numcinema = cine.numcinema
    WHERE
      cine.compagnie = 'indep'
  );
SELECT
  film.titre
FROM
  Film film
WHERE
  NOT EXISTS (
    SELECT
      'X'
    FROM
      Programmation prog
      JOIN Salle salle ON prog.numcinema = salle.numcinema
      AND prog.numsalle = salle.numsalle
      JOIN Cinema cine ON salle.numcinema = cine.numcinema
    WHERE
      cine.compagnie = 'indep'
      AND film.numfilm = prog.numfilm
  );
--40. Afficher les titres de films qui ont été programmés dans toutes les salles. Vous le ferez de 2 manières : avec COUNT puis avec NOT EXISTS
SELECT
  film.titre
FROM
  Film film
  JOIN Programmation prog ON film.numfilm = prog.numfilm
GROUP BY
  film.titre
HAVING
  count (prog.numsalle) = (
    SELECT
      count(*)
    FROM
      Salle
  );