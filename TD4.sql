-- Q2
drop table if exists CARTE cascade;
drop table if exists CLIENT cascade;
drop table if exists DIFFICULTE cascade;
drop table if exists ITINERAIRE cascade;
drop table if exists ITINERAIRE_SORTIE cascade;
drop table if exists PARTICIPATION cascade;
drop table if exists SOMMET cascade;
drop table if exists SORTIE cascade;
/*==============================================================*/
/* Table : CARTE                                                */
/*==============================================================*/
create table CARTE (
  ID_CARTE INTEGER not null,
  REFERENCE_IGN VARCHAR(25) not null,
  TITRE VARCHAR(80) not null,
  constraint CARTE_PK primary key (ID_CARTE)
);
/*==============================================================*/
/* Table : CLIENT                                               */
/*==============================================================*/
create table CLIENT (
  ID_CLIENT INTEGER not null,
  NOM VARCHAR(80),
  PRENOM VARCHAR(80),
  CP CHAR(5),
  RUE VARCHAR(80),
  VILLE VARCHAR(80),
  TEL_FIXE CHAR(10),
  MAIL VARCHAR(30),
  DATE_NAISSANCE DATE,
  constraint CLIENT_PK primary key (ID_CLIENT)
);
-- Nom, prenom, adresse, tel,... sont NULL possible (par défaut si on n'indique pas NOT NULL, c'est NULL possible) i.e. ne sont pas obligés d'être renseignés afin de pouvoir supprimer les données personnelles dans le cadre du RGPD.
/*==============================================================*/
/* Table : DIFFICULTE                                           */
/*==============================================================*/
create table DIFFICULTE (
  CODE_DIFFICULTE CHAR(3) not null,
  LIBELLE_DIFFICULTE VARCHAR(20) not null,
  constraint DIFFICULTE_PK primary key (CODE_DIFFICULTE)
);
/*==============================================================*/
/* Table : ITINERAIRE                                           */
/*==============================================================*/
create table ITINERAIRE (
  ID_SOMMET INTEGER not null,
  ID_ITINERAIRE INTEGER not null,
  NOM VARCHAR(80) not null,
  DIFFICULTE CHAR(3) not null,
  ORIENTATION CHAR(2) not null constraint ITINERAIRE_ORIENTATION_CK check (
    orientation IN ('N', 'NE', 'E', 'SE', 'S', 'SO', 'O', 'NO')
  ),
  DENIVELE INTEGER not null,
  TEMPS_PARCOURS_TH INTEGER not null,
  constraint ITINERAIRE_PK primary key (ID_SOMMET, ID_ITINERAIRE)
);
/*==============================================================*/
/* Table : ITINERAIRE_SORTIE                                    */
/*==============================================================*/
create table ITINERAIRE_SORTIE (
  NUMERO INTEGER not null,
  ID_SOMMET INTEGER not null,
  ID_ITINERAIRE INTEGER not null,
  ID_SORTIE INTEGER not null,
  DUREE_ITINERAIRE INTEGER not null,
  constraint ITINERAIRE_SORTIE_PK primary key (NUMERO),
  constraint ITINERAIRE_SORTIE_UQ unique (ID_SOMMET, ID_ITINERAIRE, ID_SORTIE)
);
/*==============================================================*/
/* Table : PARTICIPATION                                        */
/*==============================================================*/
create table PARTICIPATION (
  ID_CLIENT INTEGER not null,
  ID_SORTIE INTEGER not null,
  Constraint PARTICIPATION_PK primary key (ID_CLIENT, ID_SORTIE)
);
/*==============================================================*/
/* Table : SOMMET                                               */
/*==============================================================*/
create table SOMMET (
  ID_SOMMET INTEGER not null,
  ID_CARTE INTEGER not null,
  NOM_SOMMET VARCHAR(80) not null,
  ALTITUDE INTEGER not null,
  constraint SOMMET_PK primary key (ID_SOMMET)
);
/*==============================================================*/
/* Table : SORTIE                                               */
/*==============================================================*/
create table SORTIE (
  ID_SORTIE INTEGER not null,
  DATE_SORTIE DATE not null,
  METEO VARCHAR(1000),
  COMMENTAIRE VARCHAR(3000),
  constraint SORTIE_PK primary key (ID_SORTIE)
);
alter table
  ITINERAIRE
add
  constraint ITINERAIRE_SOMMET_FK foreign key (ID_SOMMET) references SOMMET (ID_SOMMET);
alter table
  ITINERAIRE
add
  constraint ITINERAIRE_DIFFICULTE_FK foreign key (DIFFICULTE) references DIFFICULTE (CODE_DIFFICULTE);
alter table
  ITINERAIRE_SORTIE
add
  constraint ITINERAIRE_SORTIE_ITI_FK foreign key (ID_SOMMET, ID_ITINERAIRE) references ITINERAIRE (ID_SOMMET, ID_ITINERAIRE);
alter table
  ITINERAIRE_SORTIE
add
  constraint ITINERAIRE_SORTIE_SORTIE_FK foreign key (ID_SORTIE) references SORTIE (ID_SORTIE);
alter table
  PARTICIPATION
add
  constraint PARTICIPATION_CLIENT_FK foreign key (ID_CLIENT) references CLIENT (ID_CLIENT);
alter table
  PARTICIPATION
add
  constraint PARTICIPATION_SORTIE_FK foreign key (ID_SORTIE) references SORTIE (ID_SORTIE);
alter table
  SOMMET
add
  constraint SOMMET_CARTE_FK foreign key (ID_CARTE) references CARTE (ID_CARTE);
-- Q5
  /* suppression si la séquence existe déjà avant de la créer */
  Drop sequence if exists CLIENT_SEQ;
Create sequence CLIENT_SEQ OWNED BY client.id_client;
-- Q6
Alter table
  CLIENT
add
  constraint CLIENT_UQ unique (NOM, PRENOM, TEL_FIXE);
-- Q7
Alter table
  CLIENT
add
  MOBILE char(10);
Alter table
  CLIENT
add
  constraint CLIENT_MOBILE_CK check (
    MOBILE like '06%'
    or MOBILE like '07%'
    or MOBILE IS NULL
  );
-- Penser à rajouter IS NULL sur un CHECK si le champ est NULL possible.
  -- Q8
  create index SOMMET_IDCARTE_IX on SOMMET (ID_CARTE);
create index ITINERAIRE_IDSOMMET_IX on ITINERAIRE (ID_SOMMET);
create index ITINERAIRE_DIFFICULTE_IX on ITINERAIRE (DIFFICULTE);
create index ITINERAIRE_SORTIE_SOM_ITI_IX on ITINERAIRE_SORTIE (ID_SOMMET, ID_ITINERAIRE);
create index ITINERAIRE_SORTIE_IDSORTIE_IX on ITINERAIRE_SORTIE (ID_SORTIE);
create index PARTICIPATION_IDCLIENT_IX on PARTICIPATION (ID_CLIENT);
create index PARTICIPATION_IDSORTIE_IX on PARTICIPATION (ID_SORTIE);
-- Q9
Alter table
  SORTIE
alter column
  DATE_SORTIE
SET
  default current_date;
-- Q10 :
INSERT INTO
  CLIENT (
    ID_CLIENT,
    NOM,
    PRENOM,
    RUE,
    CP,
    VILLE,
    TEL_FIXE,
    MAIL,
    DATE_NAISSANCE,
    MOBILE
  )
VALUES
  (
    Nextval('CLIENT_SEQ'),
    'GILLOT',
    'André',
    'rue des martyrs',
    '74000',
    'Annecy',
    '0450487932',
    'andre.guillot@myspace.fr',
    to_date('1954-06-12', 'YYYY-MM-DD'),
    '0615487932'
  );
INSERT INTO
  CLIENT (
    ID_CLIENT,
    NOM,
    PRENOM,
    RUE,
    CP,
    VILLE,
    TEL_FIXE,
    MAIL,
    DATE_NAISSANCE,
    MOBILE
  )
VALUES
  (
    Nextval('CLIENT_SEQ'),
    'MARTIN',
    'Laurent',
    'allee de la renaissance',
    '69003',
    'Villeurbanne',
    '0450030478',
    'lmartin@noos.com',
    to_date('1980-11-04', 'YYYY-MM-DD'),
    '0656030478'
  );
-- Q11 :
  /*==============================================================*/
  /* Table : CLIENT (Suite insertions)							*/
  /*==============================================================*/
INSERT INTO
  CLIENT (
    ID_CLIENT,
    NOM,
    PRENOM,
    RUE,
    CP,
    VILLE,
    TEL_FIXE,
    MAIL,
    DATE_NAISSANCE,
    MOBILE
  )
VALUES
  (
    Nextval('CLIENT_SEQ'),
    'FACILE',
    'Isabelle',
    'montee de la ruche',
    '74940',
    'Annecy le Vieux',
    '0450325641',
    'facisa@yahoo.fr',
    to_date('1981-05-27', 'YYYY-MM-DD'),
    '0620325641'
  );
INSERT INTO
  CLIENT (
    ID_CLIENT,
    NOM,
    PRENOM,
    RUE,
    CP,
    VILLE,
    TEL_FIXE,
    MAIL,
    DATE_NAISSANCE,
    MOBILE
  )
VALUES
  (
    Nextval('CLIENT_SEQ'),
    'ALFONSO',
    'Gérard',
    'impasse des Lylas',
    '38000',
    'Grenoble',
    '0450751511',
    'gegea@gmail.com',
    to_date('1964-01-05', 'YYYY-MM-DD'),
    '0689751511'
  );
INSERT INTO
  CLIENT (
    ID_CLIENT,
    NOM,
    PRENOM,
    RUE,
    CP,
    VILLE,
    TEL_FIXE,
    MAIL,
    DATE_NAISSANCE,
    MOBILE
  )
VALUES
  (
    Nextval('CLIENT_SEQ'),
    'CARRE',
    'Lucile',
    'rue des cygnes',
    '74600',
    'Seynod',
    '0450102389',
    'lulukaribou@yahoo.fr',
    to_date('1983-10-10', 'YYYY-MM-DD'),
    '0689754517'
  );
INSERT INTO
  CLIENT (
    ID_CLIENT,
    NOM,
    PRENOM,
    RUE,
    CP,
    VILLE,
    TEL_FIXE,
    MAIL,
    DATE_NAISSANCE,
    MOBILE
  )
VALUES
  (
    Nextval('CLIENT_SEQ'),
    'MIFRIDE',
    'Sophie',
    'allee du stade',
    '73000',
    'Chambery',
    '0450275361',
    'smifride@gmail.com',
    to_date('1978-08-27', 'YYYY-MM-DD'),
    '0690753410'
  );
INSERT INTO
  CLIENT (
    ID_CLIENT,
    NOM,
    PRENOM,
    RUE,
    CP,
    VILLE,
    TEL_FIXE,
    MAIL,
    DATE_NAISSANCE,
    MOBILE
  )
VALUES
  (
    Nextval('CLIENT_SEQ'),
    'MARTIN',
    'Stéphane',
    'allee de la renaissance',
    '69003',
    'Villeurbanne',
    '0450841020',
    'smartin@noos.com',
    to_date('1977-03-10', 'YYYY-MM-DD'),
    '0622841000'
  );
INSERT INTO
  CLIENT (
    ID_CLIENT,
    NOM,
    PRENOM,
    RUE,
    CP,
    VILLE,
    TEL_FIXE,
    MAIL,
    DATE_NAISSANCE,
    MOBILE
  )
VALUES
  (
    Nextval('CLIENT_SEQ'),
    'MICHON',
    'Antoine',
    'impasse Grenette',
    '75003',
    'Paris',
    '0450361877',
    'seb_michaut@gmail.com',
    to_date('1979-07-14', 'YYYY-MM-DD'),
    '0625321475'
  );
INSERT INTO
  CLIENT (
    ID_CLIENT,
    NOM,
    PRENOM,
    RUE,
    CP,
    VILLE,
    TEL_FIXE,
    MAIL,
    DATE_NAISSANCE,
    MOBILE
  )
VALUES
  (
    Nextval('CLIENT_SEQ'),
    'JOSSE',
    'Francis',
    'montee des Airelles',
    '74940',
    'Annecy le Vieux',
    '0450455550',
    'utul@camptocamp.org',
    to_date('1980-02-14', 'YYYY-MM-DD'),
    '0610355350'
  );
INSERT INTO
  CLIENT (
    ID_CLIENT,
    NOM,
    PRENOM,
    RUE,
    CP,
    VILLE,
    TEL_FIXE,
    MAIL,
    DATE_NAISSANCE,
    MOBILE
  )
VALUES
  (
    Nextval('CLIENT_SEQ'),
    'FLICK',
    'Marcel',
    'boulevard de la Mandallaz',
    '74960',
    'Cran Gevrier',
    '0450661245',
    'm.flick@caramail.fr',
    to_date('1962-04-23', 'YYYY-MM-DD'),
    '0610355757'
  );
INSERT INTO
  CLIENT (
    ID_CLIENT,
    NOM,
    PRENOM,
    RUE,
    CP,
    VILLE,
    TEL_FIXE,
    MAIL,
    DATE_NAISSANCE,
    MOBILE
  )
VALUES
  (
    Nextval('CLIENT_SEQ'),
    'MERGUES',
    'Clément',
    'boulevard de Teigne',
    '74000',
    'Annecy',
    '0450184569',
    'clemerg@lapooste.net',
    to_date('1984-09-22', 'YYYY-MM-DD'),
    '0610503040'
  );
  /*==============================================================*/
  /* Table : CARTE                                                */
  /*==============================================================*/
INSERT INTO
  CARTE (id_carte, reference_ign, titre)
VALUES
  (1, '3430 Est', 'La Clusaz - Le Grand Bornand');
INSERT INTO
  CARTE (id_carte, reference_ign, titre)
VALUES
  (2, '3431 Ouest', 'Lac d''Annecy');
INSERT INTO
  CARTE (id_carte, reference_ign, titre)
VALUES
  (3, '3432 Est', 'Albertville');
INSERT INTO
  CARTE (id_carte, reference_ign, titre)
VALUES
  (4, '3432 Ouest', 'Massif des Bauges');
INSERT INTO
  CARTE (id_carte, reference_ign, titre)
VALUES
  (5, '3531 Ouest', 'Megève - Col des Aravis');
INSERT INTO
  CARTE (id_carte, reference_ign, titre)
VALUES
  (
    6,
    '3532 Ouest',
    'Massif du Beaufortain - Moûtiers - La Plagne'
  );
INSERT INTO
  CARTE (id_carte, reference_ign, titre)
VALUES
  (
    7,
    '3534 Ouest',
    'Les 3 Vallées - Modane - PN de la Vanoise'
  );
INSERT INTO
  CARTE (id_carte, reference_ign, titre)
VALUES
  (
    8,
    '3630 Ouest',
    'Chamonix - Massif du Mont-Blanc'
  );
INSERT INTO
  CARTE (id_carte, reference_ign, titre)
VALUES
  (9, '3334 Ouest', 'Massif de la Chartreuse Sud');
INSERT INTO
  CARTE (id_carte, reference_ign, titre)
VALUES
  (
    10,
    '3335 Est',
    'Bourg d''Oisans - L''Alpe d''Huez'
  );
INSERT INTO
  CARTE (id_carte, reference_ign, titre)
VALUES
  (11, '284S', 'Mischabel');
INSERT INTO
  CARTE (id_carte, reference_ign, titre)
VALUES
  (12, 'IGMCH-3600-7015', 'Laguna Del Rio');
INSERT INTO
  CARTE (id_carte, reference_ign, titre)
VALUES
  (13, 'IGMCH-3715-7115', 'Laguna de la Laja');
INSERT INTO
  CARTE (id_carte, reference_ign, titre)
VALUES
  (14, 'IGMCH-3815-7130', 'Rioja');
INSERT INTO
  CARTE (id_carte, reference_ign, titre)
VALUES
  (15, 'IGMCH-3915-7145', 'Pucón');
INSERT INTO
  CARTE (id_carte, reference_ign, titre)
VALUES
  (
    16,
    'Tatrzanski Park Narodowy',
    'Mapa Turystyczna - 1/30000'
  );
INSERT INTO
  CARTE (id_carte, reference_ign, titre)
VALUES
  (17, 'IGMCH-3915-7145', 'Pucón');
INSERT INTO
  CARTE (id_carte, reference_ign, titre)
VALUES
  (
    18,
    'Tatrzanski Park Narodowy',
    'Mapa Turystyczna - 1/30000'
  );
  /*==============================================================*/
  /* Table : SOMMET                                               */
  /*==============================================================*/
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (1, 2, 'Aiguille des Calvaires', 2322);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (2, 2, 'Col de Balme', 2481);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (3, 2, 'Tête Pelouse', 2537);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (4, 2, 'Passage du Père', 2377);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (5, 2, 'Trou de la Mouche', 2453);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (6, 2, 'Ambrevetta', 2463);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (7, 2, 'Col des Verts', 2595);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (8, 7, 'Montagnes de Sulens', 1839);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (9, 7, 'Pointe de Mandallaz', 2277);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (10, 7, 'Col des Porthets', 2175);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (11, 7, 'Pointes Sud de la Blonnière', 2369);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (13, 2, 'Tour du Jallouvre', 2250);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (14, 2, 'Col de Balafrasse', 2253);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (16, 3, 'Tournette', 2351);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (17, 4, 'Pointe de Chaurionde', 2173);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (19, 10, 'Les 3 cols', 3323);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (20, 11, 'Chamechaude', 2082);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (22, 12, 'Croix de Chamrousse', 2248);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (23, 12, 'Grand Sorbier', 2536);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (24, 2, 'Porte des Aravis', 2390);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (25, 12, 'Cîme de la Jasse', 2478);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (27, 12, 'Dent du Pra', 2623);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (28, 4, 'Grand Arc', 2484);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (29, 2, 'Pointe de la Carmélite', 2477);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (30, 9, 'Aiguille de Péclet', 3561);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (31, 9, 'Col de Thorens', 3114);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (32, 2, 'De fond en combes', 2453);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (33, 2, 'Pointe du Midi', 2364);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (34, 8, 'Légette du Mirantin', 2353);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (35, 7, 'Col de Tulle', 1920);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (36, 7, 'Etale - Coillu à Bordel', 2080);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (37, 2, 'Col de Châtillon', 1681);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (38, 2, 'Roc des Arces', 1772);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (39, 18, 'Iwaniacka Przelecz', 1459);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (40, 18, 'Grzes', 1653);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (41, 18, 'Kominiarska Przelecz', 1148);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (42, 18, 'Nosalowa Przelecz', 1560);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (43, 18, 'Hala Kondratowa', 1986);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (44, 18, 'Sarnia Skala', 1376);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (45, 13, 'Strahlhorn', 4190);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (46, 13, 'Alphubel', 4206);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (47, 14, 'Volcans Chillan', 3186);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (48, 15, 'Volcan Antuco', 2985);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (49, 16, 'Volcan Lonquimay', 2865);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (50, 1, 'Volcan Llaima', 3125);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (51, 17, 'Volcan Villarica', 2847);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (52, 1, 'Volcan Casablanca', 1990);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (53, 2, 'Roc des Tours', 1994);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (54, 2, 'Croise Baulet', 2236);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (55, 2, 'Tour du Passage du Père', 2453);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (56, 2, 'Croix d''Almet', 2223);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (57, 2, 'Mont Lachat de Châtillon', 2050);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (58, 10, 'Col d''Argentière', 3552);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (60, 1, 'Saeterelvintinden', 972);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (61, 1, 'Trolltinden', 850);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (62, 1, 'Storsandnestinden', 1097);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (63, 1, 'Üloytinden', 1113);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (64, 1, 'Storgalten', 1219);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (65, 1, 'Point 992m sur Soltindan', 992);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (66, 7, 'Mont Charvin', 2409);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (67, 4, 'Pointe de la Sambuy', 2198);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (68, 8, 'Grand Mont', 2686);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (69, 8, 'Pointe de Comborsier', 2534);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (70, 10, 'Pointe des Grands', 3102);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (71, 10, 'Mont Blanc', 4810);
INSERT INTO
  SOMMET(id_sommet, id_carte, nom_sommet, altitude)
VALUES
  (72, 7, 'Alpage de Tardevant - Point 2143m', 2143);
  /*==============================================================*/
  /* Table : DIFFICULTE                                           */
  /*==============================================================*/
INSERT INTO
  DIFFICULTE
VALUES
  ('F', 'Facile');
INSERT INTO
  DIFFICULTE
VALUES
  ('PD-', 'Peu difficile -');
INSERT INTO
  DIFFICULTE
VALUES
  ('PD', 'Peu difficile');
INSERT INTO
  DIFFICULTE
VALUES
  ('PD+', 'Peu difficile +');
INSERT INTO
  DIFFICULTE
VALUES
  ('AD-', 'Assez difficile -');
INSERT INTO
  DIFFICULTE
VALUES
  ('AD', 'Assez difficile');
INSERT INTO
  DIFFICULTE
VALUES
  ('AD+', 'Assez difficile +');
INSERT INTO
  DIFFICULTE
VALUES
  ('D', 'Difficile');
  /*==============================================================*/
  /* Table : ITINERAIRE                                           */
  /*==============================================================*/
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (1, 1, 'l''Aiguille', 'PD-', 'NO', '822', 150);
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (1, 2, 'sommet sud-est', 'PD-', 'NO', '870', 150);
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    1,
    3,
    'sommet sud-ouest',
    'PD-',
    'NE',
    '870',
    180
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    1,
    4,
    'sommet nord-ouest',
    'PD+',
    'SE',
    '870',
    240
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (1, 5, 'sommet nord-est', 'PD', 'SO', '870', 200);
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    2,
    1,
    'voie normale du versant nord-ouest',
    'PD',
    'NO',
    '1170',
    240
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    2,
    2,
    'voie normale du versant sud-est',
    'D',
    'SE',
    '1170',
    300
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    3,
    1,
    'par la combe du Grand Crêt',
    'PD',
    'NO',
    '1100',
    210
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    4,
    1,
    'par la combe de Paccaly',
    'PD',
    'NO',
    '940',
    210
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    5,
    1,
    'par la combe de Paccaly',
    'PD+',
    'NO',
    '1010',
    210
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    5,
    2,
    'par la combe du Grand Crêt',
    'PD+',
    'NO',
    '1010',
    210
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    6,
    1,
    'par la combe de Tardevant',
    'PD',
    'NO',
    '1100',
    240
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    7,
    1,
    'par le Val du Bouchet',
    'PD+',
    'O',
    '1415',
    240
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    8,
    1,
    'voie normale par Plan Bois',
    'F',
    'N',
    '720',
    180
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    8,
    2,
    'circuit des Montagnes de Sulens par Plan Bois',
    'PD',
    'NO',
    '1095',
    210
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (9, 1, 'versant sud-ouest', 'F', 'O', '1180', 210);
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    10,
    1,
    'par le vallon des Fours',
    'PD',
    'O',
    '925',
    180
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (11, 1, 'combe sud ouest', 'PD', 'O', '1180', 240);
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    11,
    2,
    'combe à Marion - couloir Nord des Aravis',
    'AD',
    'NE',
    '800',
    150
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    13,
    1,
    'par le lac de Lessy',
    'PD',
    'S',
    '1190',
    300
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    14,
    1,
    'col sud-ouest, par la combe est de la Pointe Blanche',
    'PD+',
    'S',
    '850',
    180
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    14,
    2,
    'col est, versant sud',
    'PD',
    'S',
    '850',
    210
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    14,
    3,
    'col ouest, versant sud',
    'PD',
    'S',
    '850',
    210
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    16,
    1,
    'voie normale du versant nord est',
    'PD',
    'NE',
    '1350',
    270
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    17,
    1,
    'par la petite Chaurionde',
    'AD-',
    'N',
    '1030',
    180
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (19, 1, 'tour classique', 'PD+', 'S', '1090', 420);
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    20,
    1,
    'voie normale depuis le Col de Porte',
    'PD+',
    'O',
    '835',
    150
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    22,
    1,
    'par les lacs Robert',
    'F',
    'NO',
    '960',
    150
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    23,
    1,
    'par les lacs Roberts',
    'AD+',
    'NO',
    '1480',
    270
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    24,
    1,
    'par la combe de la Creuse',
    'PD',
    'NO',
    '1100',
    240
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (25, 1, 'depuis Prabert', 'PD', 'S', '1150', 240);
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (27, 1, 'depuis Prabert', 'AD-', 'S', '1330', 300);
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    28,
    1,
    'voie normale depuis Lieulever',
    'PD+',
    'S',
    '1250',
    270
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    29,
    1,
    'depuis le Reposoir',
    'AD',
    'NO',
    '1450',
    360
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    30,
    1,
    'traversée Sud - Ouest depuis Val Thorens',
    'AD+',
    'NO',
    '1275',
    360
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    31,
    1,
    'depuis Val Thorens',
    'PD',
    'NO',
    '830',
    180
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    32,
    1,
    'Tardevant, Paccaly et Grand Crêt par les couloirs du Milieu et du Tchadar',
    'AD+',
    'S',
    '1550',
    360
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    33,
    1,
    'circuit du Cu Déri',
    'AD',
    'S',
    '1250',
    300
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    34,
    1,
    'par le versant Est depuis le Planey',
    'PD+',
    'E',
    '1150',
    240
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (35, 1, 'versant sud-ouest', 'F', 'O', '670', 150);
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (36, 1, 'en aller/retour', 'D', 'N', '890', 210);
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (37, 1, 'depuis le Bouchet', 'F', 'S', '640', 150);
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    38,
    1,
    'depuis le Bouchet',
    'PD-',
    'S',
    '730',
    165
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    39,
    1,
    'Traversée Hala Ornak - Hala Chocholowska',
    'F',
    'O',
    '680',
    210
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    40,
    1,
    'depuis Hala Chocholowska',
    'F',
    'O',
    '500',
    150
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    41,
    1,
    'Traversée Hala Chocholowska - Dolina Koscieliska',
    'F',
    'O',
    '350',
    240
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    42,
    1,
    'depuis Kasprowy Wierch, par Hala Murowaniec',
    'F',
    'S',
    '60',
    120
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    43,
    1,
    'depuis Kasprowy Wierch',
    'F',
    'NO',
    '185',
    90
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    44,
    1,
    'par le Krokiew depuis le Hala Kondratowa',
    'F',
    'NE',
    '600',
    240
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    45,
    1,
    'voie normale en traversée vers Täschhütte',
    'PD+',
    'NE',
    '1600',
    540
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    46,
    1,
    'depuis Täschhütte en traversée',
    'PD',
    'O',
    '1505',
    420
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    47,
    1,
    'le Nuevo et le Viejo en traversée',
    'PD-',
    'SE',
    '1000',
    240
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    48,
    1,
    'voie normale, depuis la station',
    'PD+',
    'N',
    '1535',
    300
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    49,
    1,
    'voie normale, depuis la station',
    'PD+',
    'NE',
    '1265',
    240
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    50,
    1,
    'par le versant Nord-Est',
    'AD',
    'NE',
    '2110',
    480
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    51,
    1,
    'voie normale, depuis la station',
    'AD-',
    'N',
    '990',
    240
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    52,
    1,
    'voie normale depuis la station Antillanca',
    'PD',
    'O',
    '1140',
    210
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    53,
    1,
    'depuis le Chinaillon',
    'F',
    'SE',
    '630',
    180
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    54,
    1,
    'versant Sud par le petit Croise Baulet',
    'PD',
    'S',
    '1100',
    240
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    55,
    1,
    'circuit depuis les Confins',
    'AD+',
    'S',
    '1400',
    360
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    56,
    1,
    'face Ouest et traversée de la Tête d''Auferrand',
    'AD+',
    'S',
    '1100',
    240
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    57,
    1,
    'couloir Sud-Est par l''arête Sud-Ouest',
    'PD+',
    'O',
    '1010',
    180
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    58,
    1,
    'par le glacier du Tour Noir',
    'PD',
    'E',
    '1000',
    360
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (60, 1, 'face Sud-Ouest', 'PD-', 'O', '972', 210);
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    61,
    1,
    'face Ouest, depuis Akkarvik',
    'PD-',
    'O',
    '850',
    180
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    62,
    1,
    'Traversée Ouest-Est',
    'AD-',
    'O',
    '1097',
    300
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    63,
    1,
    'Traversée de l''île de Ulöya, par Kjelvågtinden',
    'AD',
    'S',
    '1400',
    360
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    64,
    1,
    'traversée Est-Ouest',
    'AD-',
    'NE',
    '1250',
    300
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    65,
    1,
    'par les lacs d''Åborsdalstinden ',
    'AD+',
    'SE',
    '992',
    270
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (66, 1, 'face Ouest', 'AD+', 'O', '1100', 270);
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    67,
    1,
    'depuis la station de Seythenex',
    'AD',
    'N',
    '1048',
    210
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (68, 1, 'depuis Arêches', 'PD', 'NE', '1676', 360);
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    69,
    1,
    'tour par les lacs de la Tempête',
    'PD+',
    'S',
    '1300',
    420
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    70,
    1,
    'par la Croix de Bron',
    'PD',
    'NE',
    '1776',
    420
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    71,
    1,
    'Traversée par les 3 Monts Blancs, arête des Bosses',
    'D',
    'NE',
    '1500',
    540
  );
INSERT INTO
  ITINERAIRE (
    id_sommet,
    id_itineraire,
    nom,
    difficulte,
    orientation,
    denivele,
    temps_parcours_th
  )
VALUES
  (
    72,
    1,
    'par le châlet de Tardevant',
    'PD+',
    'O',
    '1040',
    300
  );
  /*==============================================================*/
  /* Table : SORTIE                                               */
  /*==============================================================*/
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '1',
    current_date -2572,
    'neige excellente (30cm de peuf sur le haut, 10cm en bas); ciel bleu',
    'la neige et les conditions étaient excellentes et des tires avalanches avaient été réalisés. Sur le bas rien n''était tracé mais heureusement on n''était pas tous seuls. Sur la fin le rack-track était passé, ce qui offrait un chemin assez raide. Laurent et Antoine sont remontés à Bergerie une fois arrivés aux télécabines. Pour ma part n''ayant plus de cuisses, j''en ai profité pour prendre quelques photos'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '2',
    current_date -2536,
    'neige brassée et un peu lourde sur le sommet et légèrement soufflée sur le bas (enneigement faible). Ciel dégagé en début de course puis voilé sur la fin avec un peu de neige sur le sommet',
    'malgré un manque de neige plus qu''évident, la neige étaient au rendez-vous dans le couloir (sans non plus atteindre des sommets). Il y en avait quand même assez pour se faire plaisir, surtout sur le bas avec une fine pellicule faiblement givrée. La neige était bien brassée sur le sommet mais sur le bas des endroits vierges ne demandaient qu''à être skier. Malgré une condition physique assez limite, je me suis vraiment fait plaisir dans la montée (surtout après avoir bien récupéré d''une petite fringale apparue 5min après être parti). Le seul bémol de la journée fut l''oubli de mon appareil photos...'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '3',
    current_date -2516,
    'neige trempée au départ, croûtée au milieu et fine couche au sommet, jour blanc et neige à mi-parcours jusqu''au sommet',
    'Point de vue temps, on a eu droit à un jour blanc. A mi-parcours on a eu droit à de la neige. A la descente, une fine pellicule s''était déposée (plaisir); sur le milieu la neige était croûté mais se dégradait (bof); sur le bas, neige archi lourde et pourrie, impossible de faire un virage sauf en conversion (nul à chier). Lors  de cette course on a quand même eu droit à notre petite frayeur. A la montée, nous sommes passés sur une plaque menaçante longue de 50m (bruit sourd caractéristique). Flairant le coup, on est passé l''un après l''autre. Malheureusement, à la descente, cette plaque était partie (petite coulée sur 100m); heureusement sans conséquences. Comme quoi, ce n''est pas parce qu''il y a une trace que ça tient...'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '4',
    current_date -2481,
    'bonne neige dans l''ensemble, jour blanc avec brouillard (éclaircie de 2min à l''arrivée au sommet)',
    'la visibilité était quasi nulle, notamment sur la fin de la descente. Malheureusement nous n''étions pas seuls (au moins 30 personnes...). La neige était assez bonne, plutôt printemps et juste ce qu''il fallait pour se faire plaisir'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '5',
    current_date -2474,
    'neige excellente (de la pure et de la bonne); jour blanc (juste pour changer) et neige à mi-parcours jusqu''au sommet',
    'rando plaisir de chez plaisir. On a fait la trace tout le long. La neige qui tombait a rendu la montée finale (raide) assez fastidieuse, mais quel plaisir à la descente ! Imaginez : pas une trace, seul au monde, une peuf de rêve. Comme si ça ne suffisait pas on a vu ce qui sans doute serait un gypaète !'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '6',
    current_date -2473,
    'les neiges de la veille ont recouverts une fine couche croûté (le dessous était bon); jour blanc avec ciel bleu au dessus de la Tournette',
    'premières constations : y''a pas de neige! Alors on est monté à pied pendant 200m. Au début on était parti pour le col de Tulle. Malheureusement il y avait plus d''herbe que de neige. On s''est donc rabattu sur le vallon des Fours pour monter jusqu''où on pouvait. Une neige fraîche avait recouvert une croûtée sur 5cm. Les skis partaient de temps en temps, mais les couteaux n''étaient pas utiles. Et puis, on s''est bien fait plaisir à la descente. Là aussi petite frayeur, comme à Paccaly. Sauf que là, j''ai vu que ça craignait qu''une fois dedans... La couche en dessous de la neige croûtée était bonne, les risques étaient donc mineurs. Mais on a quand même vu que c''était parti (sur moins de 10m) quand on est redescendu'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '7',
    current_date -2214,
    'enneigement très faible, pas de sous couche (premières neiges). A partir de 2000m, la neige croûtée enferme une neige poudreuse sur une neige dure',
    'départ 7h15 avec mon père. Arrivés à Thônes, coup d''oeil sur Sulens : c''est tout blanc!! mais Sulens c''est nul, alors direction la Clusaz. Arrivés à la station, coup d''?il sur l''Etale : c''est blanc... et jaune... Pas skiable, ptite déprime. Ensuite direction Crêt du Merle pour se faire l''Aiguille. Arrivés au Crêt, on va jeter un coup d''?il, mais pour ma part, je ne me fais pas trop d''illusion... Et là pareil qu''à l''Etale, même pire! cette fois c''est plus vert que blanc... Et puis finalement, zut! on n''est pas venu jusqu''ici pour rien. Alors on chausse, ptite séance photos pour moi et à 8h15 on décolle, mon père devant! Jusqu''au Crêt du Loup, la neige est là (pas plus de 20cm). Elle est fine et poudreuse, mais point de vue sous couche : 0 pointé! Et puis on arrive au Crêt du Loup, donc à 1900m. Je fais la trace : neige croûtée mais dessous c''est bon : poudreuse sur neige dure. Du Crêt à environ 50m en dessous du sommet, c''est largement skiable. Par contre le sommet a complètement été soufflé, y''a que dalle comme neige, juste ce qu''il faut pour monter. 2h après avoir commencé, on atteint le sommet, seuls avec le soleil. Ptite séance photos et on descend. Sur les premiers 50m on skie sur des oeufs, le moindre virage enlève toute la neige. Puis vient la partie skiable. Dur pour moi, après plusieurs mois d''inactivité. La croûte est plus épaisse que je ne pensais, mais sur la fin le soleil est là depuis longtemps et les automatismes reviennent. Trop bien, sauf que ça ne dure que 3min. Ptite pause au Crêt pour saluer les connaissances qui montent, puis on repart. Mon père à ski, moi à pied. Mon père s''en fout il a ses bons vieux Duret, mais moi je tiens à mes Vertical. A 11h15 j''arrive à la voiture (mon père est là depuis 5 bonnes minutes). Voilà, voilà. La neige était là mais malheureusement il n''y avait pas ou peu de sous couche. Mais bon, ça fait quand même du bien de remettre les skis. Je m''en tire quand même avec une belle trace sur un des skis'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '8',
    current_date -2172,
    'manque de neige évident, malgré de fortes chutes de neige en plaine',
    'on est parti d''Annecy à 7h45, alors qu''on avait prévu de partir à 7h (c moi qui ne me suis pas levé...). Une fois les skis chaussés, on s''aperçoit vite qu''il n''y a qu''une fine couche de neige recouvrant un tapis ... d''herbe. Pour couronner le tout, à peine 10 min après le départ, je me chope une fringale et deviens blanc comme neige... Une fois toutes ces mésaventures réglées, en arrivant sous le col, on décide de monter au sommet secondaire coté 1776m : la meilleure neige se trouve ici. Effectivement, une fine pellicule recouvrant une fine sous couche, nous permet de pratiquer un bon ski, mais malheureusement trop court. Seule la combe est skiable, le reste (c''est à dire le chemin) est rempli de caillou. Du coup on a descendu le chemin à pied, avant de rechausser les skis pour descendre les champs'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '9',
    current_date -2158,
    'neige excellente (de la pure et de la bonne); jour blanc (juste pour changer) et neige à mi-parcours jusqu''au sommet',
    'On est parti 45min trop tard. Non pas que ça craignait, mais on est arrivé en bas de la combe en même temps que le soleil. Bref, on s''est retrouvé en plein cagnard sur les 400 derniers mètres... Lors de la descente la neige était assez lourde et plutôt délicate à skier sur le début. Elle avait trop pris le soleil, alors on a piqué à l''ouest pour en trouver une au soleil depuis peu de temps. Et là c''était bon!!! Du coup à trop piquer à l''ouest on s''est retrouvé dans une sorte de petit couloir assez raide juste au dessus des chalets : court mais sympa. Ensuite on a pris l''option de continuer droit sous les chalets pour se retrouver dans une petite combe où là aussi c''était assez bon'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '10',
    current_date -2152,
    'neige très changeante. Poudreux en haut, croûté et glacé sur les 3/4 du parcours',
    'très belle course sans grande difficulté. La montée est continue contrairement aux autres combes des Aravis. La descente n''était pas agréable notamment sur la dernière partie avec une neige excécrable. Cette course nous a surtout permis de reconnaître les différents couloirs que sont le couloir Combaz et Coillu à Bordel, objectifs de la saison'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '11',
    current_date -2131,
    'neige légèrement croutée. Bonne qualité de neige tout de même en partie dû à l''exposition plein nord de cette combe',
    'Laurent m''a prêté ses anciennes peaux encore toutes neuves. Résultat au lieu d''avancer de 2m et de reculer d''1m, bah j''avançais de 2m sans reculer. Beau temps, neige dure, bonnes traces, bref en moins de 2h on était au sommet. Et puis on est allé chercher un petit couloir à l''ouest de la combe. Bien sympa!!'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '12',
    current_date - 2130,
    'bonne neige dans l''ensemble : croûtée derrière l''Aiguille Verte, béton derrière le col du Sosay et transformée dans la combe sud du col du Rasoir. Les 3 cols étaient dépourvus de neige',
    'GENIAL, ENORME!! Les mots manquent pour décrire cette rando. Sans doute l''un des plus beaux circuits des Aravis. Je m''attendais à meilleure neige derrière l''Aiguille Verte, mais le petit couloir derrière le Sosay m''a vraiment fait plaisir. Quant à la montée vers le col du Rasoir, c''est tout simplement l''une des plus belles que j''ai eu à faire. L''horaire était parfait : la neige dans la combe sud du Rasoir était tout juste transformée. De ce fait, il faut faire attention à l''horaire et ne pas partir trop tard (en Février, il faut être au col du Rasoir à grand max 12h). Ce circuit peut être comparé à la course des 3 cols à Cham, mis à part le fait qu''on ne monte pas dans une cabine. C''est dire... ça faisait 2 ans que je voulais y emmener Laurent et je peux vous dire qu''il n''a pas été déçu du voyage (même s''il a mis quelques temps à s''en remettre...). L''idéal pour cette course est de la faire sous la pleine lune. Je l''ai déjà fait et là, ce n''est plus énorme, c''est magique...'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '13',
    current_date - 2094,
    'grand beau. Risque limité. Neige croûtée et inskiable sous le Petit Sulens, gelée sous le Grand, tout juste transformée pour la 3e descente. Bref, 1ère descente pourrie sauf sur la fin, 2e et 3e... du bonheur en boîte',
    'n''ayant pas de compagnon de course, je me suis rétracté sur Sulens avec pour unique objectif bouffer du dénivellé. La première descente m''a un peu déçu, par contre les autres... la dernière était tellement bonne que je suis remonté sur 150m... Contrairement à ce que je pensais, l''horaire était tip top'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '14',
    current_date - 2081,
    'au début grand grand beau, mais malheureusement des nuages sont venus bouchés le sommet et donc la vue... Neige dure',
    'et voilà ! je l''ai enfin faite cette Tournette, depuis le temps qu''on m''en parle. Première constatation : c''est vraiment LA course d''Annecy !!! abusé le peuple... Deuxième constatation : faudra revenir ! et oui malheureusement la vue sur le lac était bouché... et puis même si ça n''avait pas été le cas, il aurait fallu revenir'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '15',
    current_date - 2074,
    'pas un brin de soleil, froid. La neige était gelée et il n''y avait que quelques rares passages avec une fine pellicule bien agréable. Risques d''avalanche minimum',
    'On a dû porter pendant 400m. On aurait pu chausser avant, mais on a préféré monter jusqu''au chalet du Planet. Nous n''avons malheureusement pas eu droit au soleil; la neige n''a donc pas pris le soleil : dommage, car aussi non ça aurait été vraiment bon'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '16',
    current_date - 2073,
    'grand soleil. Froid le matin, puis très doux dès que le soleil pénètrait dans la combe. Neige dure le matin (couteaux) mais très bonne à la descente avec quelques passages encore légèrement poudreux. Neige de printemps sur le bas',
    'très belle randonnée, des conditions idéales, très très bonne journée dans les aravis '
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '17',
    current_date - 2072,
    'grand grand beau avec que du bleu au dessus de nos têtes. Vue la période la neige est de printemps sur le bas de la combe mais dur sous le sommet (crampons)',
    'au départ il faisait assez chaud dans la montée donc dur dur. Puis une fois dans le couloir à proprement dit, il faisait frisquette. On a dû chausser les crampons 200m sous le sommet. En tout cas, à cette période de l''année, la neige est toujours au rendez-vous. Une course à refaire, à refaire et encore à refaire !!!'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '18',
    current_date - 1836,
    'pas de sous couche jusqu''au Crêt du Loup. Plus haut, on a eu droit à toutes les neiges : cartons, lourdes et même peuf...',
    'première sortie de l''année. On est encore rouillé par la saison estivale, mais ça fait plaisir de rechausser les skis. La neige était pas si mal que ça, malgré la période'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '19',
    current_date - 1787,
    'ciel Bleu. Bise forte à partir de la mi-course. Froid polaire. Neige cartonnée sur le haut, poudreuse en de grands endroits pour le reste de la course. Cependant la neige a été soufflée en de nombreux endroits et gare aux plaques à vent dans les traversées',
    'très bonne sortie, bonne qualité de neige, quelques pierres sur le chemin de départ. Sinon il a surtout fait très très froid ...'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '20',
    current_date - 1780,
    'd''abord bouché puis ciel bleu avec côté Thônes entièrement dégagé mais côté Annecy encore bouché. Le manteau est stable, donc risques minimes. Vue l''heure de descente, la neige n''avait pas encore eu le temps de se transformer. On a donc eu droit à toutes les neiges : carton, béton et à de trop rares endroits poudreuse. Résultat : idéale pour la montée mais galère pour la descente',
    'on voulait profiter de la pleine lune mais la météo en a décidé autrement. La montée a donc été assez atypique : on voyait pas grand chose, si ce n''est rien à part les lumières de Thônes et de Manigod. Puis les nuages ont commencé à se trouer en même temps que le soleil a commencé à se lever. La montée finale dans la combe était très ambiance : seul avec deux choucards perdu dans les nuages, et les couleurs étaient magnifiques : tout était orange... En arrivant sous le Fauteuil, les nuages ont laissé place à un ciel bleu azur. La montée au Fauteuil se fait sans trop de difficultés (de belles marches ont été taillées). Et là, comme je m''y attendais, Annecy était tout bouché (comme pour ma première montée). Il faudra donc revenir...'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '21',
    current_date - 1745,
    'grand bain soleil. Frais le matin, puis doux. Neige excellente en général. Un peu dur et crouté sous le col mais très très bon sur tout le reste. Neige légère et très agréable à skier.',
    'superbe, le temps était avec nous, toutes les conditions réunies pour faire une très bonne sortie. Nous avons quand même dû mettre les crampons sur les 100 derniers mètres'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '22',
    current_date - 1742,
    'malheureusement assez couvert au début avant que le soleil ne réussisse à percer. Et puis ça soufflait quand même pas mal... Sous le Trou, côté Grand Crêt, neige béton qui commençait à prendre le soleil. Plus bas la neige avait déjà pris pas mal de soleil, il fallait donc chercher la neige encore à l''ombre',
    'Depuis le temps que je voulais le faire... La traversée de l''arête est aérienne à souhait ! Et en plus quand le vent est de la partie :) La neige derrière le Trou était géniale à skier et plus bas une fois à l''ombre la neige était béton et recouverte de neige soufflée : un régal !'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '23',
    current_date - 1731,
    'assez couvert avec quand même du ciel bleu. L''Etale était complètement bouché. Le couloir est en top condition pour y aller sans poser les skis. Par contre à la descente, la neige s''avère lourde et difficilement skiable',
    'je l''aime de plus en plus ce couloir. En plus là y''avait les conditions pour monter au sommet sans déchausser. Résultat 1h20 pour monter au col !! Prochain objectif : passer sous la barre des 1h... Par contre, descente pas géniale géniale avec une neige assez lourde à skier et qui laissait échapper des blocs après ton passage. Une fois au col j''ai tergiversé 10 bonnes minutes pour savoir si je redescendais sur la Blonnière. Des gars s''engageaient dans le couloir Combaz qui semble en bonnes conditions (le verrou se passe bien apparemment) et ça m''a grave titillé. Mais compte tenu de l''heure (11h); j''ai préféré ne pas y aller. La prochaine fois en partant plus tôt...'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '24',
    current_date - 1724,
    'pas mal bouché sur Cham, mais grand beau une fois aux Grands Montets. Puis complètement bouché une fois au col du Chardonnet pendant 10min. Grand beau par la suite, mais malheureusement des nuages restaient accrochés sur les sommets suisses : pas de Cervin :( . Point de vue température, froid, même très froid jusqu''au col du Chardonnet avant de se choper le caniard pour la montée à la fenêtre de Saleina. Et puis ça soufflait... Point de vue neige, excellente descente sur le glacier des Rognons : neige carton résistante. La descente du col du Chardonnet peut se faire à ski. Malheureusement la descente du glacier du Tour n''était pas fameuse, faute à une neige carton en forme de vagues dues au vent...',
    'course complète : alternance de montées et descentes, altitude, pente raide, etc... bref, tout ce que j''aime. Et qui plus est dans un cadre dont la réputation n''est plus à faire. Ma seule déception vient de la descente du glacier du Tour, pas géniale. On n''a pas pris le meilleure chemin, du coup on s''est retrouvé dans un petit couloir gelé, voire glacé par endroit... Bref, la prochaine fois, on descendra rive gauche puis rive droite sous les séracs (enfin pas trop dessous quand même...) !!!'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '25',
    current_date - 1723,
    'grand grand beau au début limite caniard (10h) puis complètement bouché lors de la descente à 12h. Neige poudreuse dans la combe, après bonne neige de printemps. On peut encore prendre le chemin dans la forêt... sauf sur 3 passages de 5m',
    '3 fois que je fais la Tournette, 3e fois que la vue sur le lac d''Annecy est bouchée :( Ce n''est que partie remise...'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '26',
    current_date - 1700,
    'des nuages ont élu demeure 200m sous le sommet. Neige traffolée gelée. Couteaux obligatoires à la montée et pas commode à skier à la descente ...',
    'première course sur Grenoble. Malheureusement ça n''a pas été très fameux. Manque évident de neige, neige traffolée gelée et le temps n''y était pas... J''ai malheureusement préféré m''arrêter 200m sous le sommet : les nuages bouchaient tout. Mise à part ça, quand les conditions sont là, cette course doit vraiment être sympa. Donc c''est sûr, j''y retournerai !!!'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '27',
    current_date - 1695,
    'tout simplement magnifique : du ciel bleu, du ciel bleu et rien que du ciel bleu. Une petite croûte de regel recouvre 30 à 40 cm de neige fraîche. Compte tenu de l''orientation, cette neige s''est vite transformée en soupe extrêment délicate à skier. Pour ce qui est du chemin dans la forêt, on n''en parle même pas... Point de vue avalanche, méfiate : la neige récente est lourde et des coulées de neige mouillée commencent à tomber, surtout sous les falaises',
    'enfin !!! 3e fois de la saison que je me fais la Tournette, et j''ai enfin pu voir le lac :) (vue qui se passe bien évidemment de commentaire). La montée se fait sans problème, bonnes traces, par contre la descente était un vrai calvaire, surtout dans la forêt. Le chemin en forêt est en neige jusqu''en bas, mais 2 ou 3 portions à la sortie de la forêt sont déjà vierges de neige. La montée au fauteuil se passe sans trop de soucis'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '28',
    current_date - 1689,
    'du grand grand beau au dessus de nos têtes. Par contre au dessus du lac d''Annecy il y avait un beau nuage bleu... Excellente neige gelée qui était tout juste en train de se transformer lors de la descente. Pour la montée, les couteaux étaient presque obligatoires',
    'première sortie dans les Bauges :D Au départ on était parti pour faire Chaurionde et puis on s''est trompé, on est allé à la petite. Du coup on est monté à Chaurionde par la très esthétique arête W (crampons). Vue de la petite, la descente de Chaurionde paraît assez impressionnante, mais finalement... En tout cas, la neige y était gelée à souhait : un vrai régal à la descente. Au départ on a marché sur 200m, on a vu la neige, on a chaussé, on est monté dans la forêt... Grossière erreur :( Le mieux aurait été de continuer le chemin presque jusque sous le chalet de l''Aulp'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '29',
    current_date - 1500,
    'aucune sous couche en dessous de 2000m. Plus haut c''est du bonheur : 20 à 30cm de fraîche sur une neige dure. Grand ciel bleu !',
    '8h35, 2 pressions sur la montre, puis un premier pas et un deuxième... 1h plus tard, la première conversion ! et 30min après la première godille !!! Et voilà ça y est ! la saison 2003-2004 a enfin débuté !!! Nous avons bien évidemment commencé par la saincro sainte montée à l''Aiguille. Mais cette année nous avons fait une variante. Nous avons rejoins le sommet situé juste derrière l''Aiguille. La neige n''était pas très présente sur le bas, mais au dessus de 2000m une excellente sous couche permettait de skier dans 20 voir 30cm de fraîche ! Bref, que du bonheur !! avant de partir slalomer entre les cailloux...'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '30',
    current_date - 1465,
    'une mer de nuages située vers 1000m bouchait tout Grenoble... Au dessus c''était du grand grand bleu. La neige est tombée abondamment ces deux derniers jours. C''est donc peuf peuf et peuf, mais qui s''alourdissait très vite une fois le soleil arrivé. A priori, le risque de coulées était peu marqué, mais méfiance quand même',
    'j''ai couplé cette course avec le Grand Sorbier. Au début je voulais juste découvrir Belledonne, et faire la Croix depuis le Recoin. Et puis je suis tombé sur un parking blindé : pas de doute ça c''est un départ de rando. Juste le temps de se situer sur la carte et de chausser, et me voilà parti. Au bout de peu de temps de montée, je vois tout le monde piquer à gauche. Je suis la masse et découvre avec bonheur que je me dirige vers les lacs Robert à travers une superbe forêt toute blanche. Une fois arrivé aux lacs, une petite discussion avec un randonneur me fait vite laisser la Croix sur ma droite pour monter au Grand Sorbier... Et là encore, bien m''en a pris ! Superbe montée légèrement pentue et se terminant par une petite marche à pied, limite escalade. Depuis le sommet, vue splendide sur tout Belledonne, les Grandes Rousses et les Ecrins. Mais il est déjà temps de descendre et là c''est que du bonheur (à part la mise en route...). Excellente neige bien froide, de quoi bien traffolée !! Me voilà alors de retour à mon objectif premier : monter à la Croix de Chamrousse. Mais la montée au Sorbier a laissé quelques traces. La montée à la Croix sur une piste dammée est alors assez pénible au niveau des cuisses, mais heureusement cela ne prend pas beaucoup de temps. Arrivé à la Croix une question se pose : mais par où descendre ?! Finalement je descends par le couloir Casserousse. La descente se transforme en un vrai calvaire : cuisses mortes et neige vraiment lourde !!! Moi qui était parti pour me taper un petit 600m, je reviens à la voiture épuisé par ces 1500m de dénivellée mais impatient de revenir !'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '31',
    current_date - 1460,
    'une mer de nuages située vers 1000m bouchait tout Grenoble... Au dessus c''était du grand grand bleu. La neige est tombée abondamment ces deux derniers jours. C''est donc peuf peuf et peuf, mais qui s''alourdissait très vite une fois le soleil arrivé. A priori, le risque de coulées était peu marqué, mais méfiance quand même',
    'j''ai couplé cette course avec le Grand Sorbier. Au début je voulais juste découvrir Belledonne, et faire la Croix depuis le Recoin. Et puis je suis tombé sur un parking blindé : pas de doute ça c''est un départ de rando. Juste le temps de se situer sur la carte et de chausser, et me voilà parti. Au bout de peu de temps de montée, je vois tout le monde piquer à gauche. Je suis la masse et découvre avec bonheur que je me dirige vers les lacs Robert à travers une superbe forêt toute blanche. Une fois arrivé aux lacs, une petite discussion avec un randonneur me fait vite laisser la Croix sur ma droite pour monter au Grand Sorbier... Et là encore, bien m''en a pris ! Superbe montée légèrement pentue et se terminant par une petite marche à pied, limite escalade. Depuis le sommet, vue splendide sur tout Belledonne, les Grandes Rousses et les Ecrins. Mais il est déjà temps de descendre et là c''est que du bonheur (à part la mise en route...). Excellente neige bien froide, de quoi bien traffolée !! Me voilà alors de retour à mon objectif premier : monter à la Croix de Chamrousse. Mais la montée au Sorbier a laissé quelques traces. La montée à la Croix sur une piste dammée est alors assez pénible au niveau des cuisses, mais heureusement cela ne prend pas beaucoup de temps. Arrivé à la Croix une question se pose : mais par où descendre ?! Finalement je descends par le couloir Casserousse. La descente se transforme en un vrai calvaire : cuisses mortes et neige vraiment lourde !!! Moi qui était parti pour me taper un petit 600m, je reviens à la voiture épuisé par ces 1500m de dénivellée mais impatient de revenir !'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '32',
    current_date - 1438,
    'du grand ciel bleu. Au sommet ça soufflait pas mal et pendant la montée, on a eu droit à du vent chaud ...',
    'belle course !!! Cette course est peu connue et se fait plutôt en début de saison : on était donc seul au monde !! La neige très inégale a rendu la descente un peu complexe niveau cuisses. On a donc fini sur la piste du Fernuy...'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '33',
    current_date - 1398,
    'du ciel bleu à perte de vue. Extrêment chaud et le peu de vent qui a soufflé était ... chaud. Donc forcément vue l''heure de descente (13h); la neige était de printemps et pas mal lourde',
    'aujourd''hui pas cours ! donc la sortie de rando était inévitable... Quand on m''a parlé de la Cîme de la Jasse, on m''a dit que cette course était à Grenoble ce que la Tournette est à Annecy; et bien c''est vrai ! départ en fôret, montée sous le soleil, la vue sur Grenoble et bien évidemment, du peuple ! même en semaine ... manquait juste un lac ... A part ça, belle course, mais il a fait très très chaud ! On se serait cru au printemps ... Donc neige pas facile à skier en descente, bref de quoi bien ruiner les cuisses ... La route était déneigée jusqu''à la sortie de Prabert, je suis donc parti de là, ce qui rajoute 300m de dénivellée'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '34',
    current_date - 1394,
    'jour blanc ... le plafond était aux alentours des 2000m, donc une fois passée cette altitude, on n''y voyait pas à 10m devant nous ! Et surtout un zef à décorner les boeufs ! La neige était soufflée sur les crêtes (belles plaques de glace); 10cm de neige fraîche en dessous de 2000m, au dessus grosses accumulations, mais la neige était bien froide et surtout compacte. Donc ça tenait',
    'une première pour André dans les Aravis et seulement sa 2e sortie en rando ! Ce qu''on peut dire, c''est qu''on n''a pas traîné à la montée et au dessus de 2000m, on n''y voyait plus rien. 3 personnes étaient devant nous et ont tracé, donc nous, plus grand chose à faire, mais on a bien failli se paumer ... Au Trou de la mouche, énorme congère 20m dessous. Du coup impossible de voir le Trou de là (on a même cru qu''on s''était planté de couloir...) !!! La descente côtée Paccaly fut tout bonnement ... ENORME !!! pas une trace, personne, neige exellente et bien compacte. Bref, du bonheur en boîte !!!'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '35',
    current_date - 1388,
    'du grand ciel bleu, chaud (mais sans plus) et pas un brin de vent. Excellente neige ... de printemps ! neige bien gélée à la montée (couteaux dans la combe SW); mais un vrai régal à la descente car elle avait bien pris le soleil. Bref, conditions idéals ! ',
    'une bien belle course ! le petit couloir est très sympa : ça passe très bien à ski, mais couteaux indispensables. La descente fut un pur régal. La neige gelée du matin avait bien pris le soleil. A la descente on a eu droit à une bonne neige de printemps ! Et puis l''horaire était tip top : excellente descente et de retour à Gre à 14h15 pour être au O''Callaghan une pint à la main pour le match de rugby !!!'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '36',
    current_date - 1387,
    'grand grand ciel bleu au dessus de 1300m, en dessous c''était de la purée pois. On a donc eu droit à une belle mer de nuage durant toute la montée. Neige gelée, les couteaux étaient indispensables une fois sortis de la forêt',
    'la montée dans la forêt est toujours aussi pénible. Nous avons été obligés de mettre les couteaux à la sortie de la forêt pour les garder jusque vers 2000m où on pose les skis. Plus haut il n''y a plus de neige mais la montée à la Croix se fait sans problème à pied. La vue du sommet est par contre gigantesque ! Jura, Aravis, Mont Blanc, Belledonne, Vercors, Massif Central et Chartreuse pour ne citer qu''eux ...'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '37',
    current_date - 1386,
    'grand grand grand beau, du ciel bleu, du soleil, bref un bon ptit caniard à la montée ! Heureusement une petite bise au sommet a fait énormément de bien. Niveau neige, c''étaut une pure neige de printemps bien gorgée de soleil !!',
    '6 ans après me voilà de retour en Vanoise ! Cette fois pour le Grand Arc (et non le Petit). Une belle course avec un début casse pieds dans les arbres et une très belle fin sur une superbe arête ! La descente est un petit régal si on aime la neige de printemps'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '38',
    current_date - 1382,
    'du ciel bleu à perte de vue. Assez froid dans la combe. Le soleil a réchauffé tout ça 200m sous le Passage du Père, mais en échange le vent soufflait pas mal ... Les chutes de neige de la veille n''ont laissé qu''une fine couche fraîche de 5cm qui repose sur une neige bien croûtée et bien trafollée',
    'une petite combe et un petit Trou vite fait histoire de prendre l''air ... car l''arête menant au Trou est toujours aussi aérienne ! (pas trop non plus quand même). Une course toujours aussi sympa dans ces si jolies combes'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '39',
    current_date - 1380,
    'ciel bien bouché au dessus de 3000m mais on y voyait quand même bien. Ambiance humide côté neige : sur le bas, la neige est bien humide et très lourde à skier. Sur le haut la neige est aussi un peu lourde, ça colle ! mais à la descente, c''est une neige assez sympa à skier',
    'quand la météo dit ciel nuageux, maussade, et bien on va dans les combes ! Nous avons été surpris de la neige, on s''attendait à pire. Au dessus de 2000m la neige est très bonne à skier, et il reste même des portions de neige vierge dans cette combe hyper hypra fréquentée. Par contre sur le bas, c''est pas génial à skier, mais on s''en sort'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '40',
    current_date - 1357,
    'du grand grand beau avec du ciel bleu à perte de vue ! Par contre niveau neige, c''était pourrie ! Neige trafollée dur comme du béton ... Bref, couteaux de haut en bas et descente pas terrible (mes cuisses peuvent le confirmer...)',
    'une petite rando à Chamechaude tôt le matin afin d''être à l''heure pour le TD sur le campus...  La neige était complètement daubée et même avec les couteaux c''était galère... Cette sortie ne restera pas gravée dans ma mémoire, mais ça fait du bien après 10 jours de boulot non stop'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '41',
    current_date - 1352,
    'météo maussade avec en matinée un plafond nuageux vers 1500m et du soleil au dessus. Puis vers les 11h cela a commencé à se couvrir de plus en plus. La vue sur le lac d''Annecy n''était pas bouchée. La neige était quand à elle archi lourde, trempée et limite skiable : ça partait facilement sous les pieds dans les pentes raides',
    'pas terrible terrible cette sortie. Remarque c''est pas du tout étonnant vu le temps qu''il a fait ces derniers jours. On est descendu par la face nord est. La neige ultra lourde en descente a bien fait travaillé les cuisses et c''était limite dangereux pour les genoux. Sinon montée toujours aussi agréable. Le chemin dans la forêt se fait encore intégralement à ski, la vue sur le lac est toujours aussi belle et il y a toujours autant de monde sur cette course ...'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '42',
    current_date - 1345,
    'grand ciel bleu, chaud, bref conditions idéales. Et puis niveau neige, bah franchement à part de la peuf, on n''a pas vu grand chose d''autre ... à part l''envers du col du Chardonnet, inskiable (descente sur corde fixe, crampons obligatoires)',
    'aujourd''hui les 3 cols, si on voulait les faire, il fallait prendre la première benne et ne pas traîner en route car gros gros embouteillage au col du Chardonnet. Sinon sortie géniale, avec une neige ... huuuumm ...'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '43',
    current_date - 1338,
    'médiocre. De faibles passages ensoleillés au début et puis du bon mauvais temps : neige au sommet puis pluie vers 1600m. La neige était un poil lourde, mais tout de même agréable à skier. On chausse à 1400m',
    'belle rando avec comme super toile de fond la Pointe Percée. Nous avons marché pas mal, mais à choisir le chemin dans la forêt est à mon avis plus simple à pied. Malheureusement nous avons été pris par le mauvais temps, nous ne sommes donc pas redescendu par le couloir nord ouest mais par la combe de montée'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '44',
    current_date - 1318,
    'des nuages se bloquaient régulièrement au sommet du couloir, sinon beau et surtout chaud. Neige de printemps, donc neige lourde. ça partait facilement dans les pentes raides (expérience faite ...). De nombreuses petites coulées se déclenchaient au dessus des falaises alentoures',
    'il a vraiment fait très chaud, même trop ! dès qu''on allait dans du raide, ça partait sous les pieds. ça monte facilement au col skis aux pieds. Du parking, on marche 2 ptites minutes avant de chausser'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '45',
    current_date - 1310,
    'du ciel en début de journée puis ça s''est peu à peu couvert jusqu''à devenir totalement bouché au dessus de 3200m : de la vraie purée de pois chiche ! Neige excellente ! neige bien froide et même poudreuse dans la descente. Pour la montée finale vers l''Aiguille, ça cramponnait bien !',
    'départ 5h d''Annecy : il pleut ! ptit coup de fil à André qu''on doit récupérer à Albertville et qui est sur la route vers Chambé : il fait beau. Alors on part, mais arrivés à Ugines, grosse rincée. Petite hésitation à Albertville, mais on décide d''y aller quand même. Résultat, arrivés à Val Tho : grand beau ! Le but ne sera pas pour cette fois ! Sinon on n''a pas vu les 800m premiers mètres : tout fait sur la piste dammée ! Après chaud sur le glacier de Chavière puis chouette ambiance pour monter au sommet dans le brouillard et très très belle descente ... à slalomer entre les crevasses. Malheureusement des beaux maux de tête et de ventre sont venus entâchés cette belle journée'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '46',
    current_date - 1108,
    'ciel voilé en début de journée, avec même quelques flocons qui ont laissé place à un petit ciel bleu. Pour ce qui est de la neige, euh ... 5 cm à 1500m et 20cm (et encore !) à 2200m ... bref, c''était skis cailloux',
    'tout a commencé vendredi : météo Cham annonce 40cm à 1800m ! ça y est c''est parti les mails tournent : où on va ? à quelle heure ? etc ... bref, plus trop la tête au taf ... et puis vient le soir. Etat des lieux : c''est pas fameux ! 15cm grand max annoncé à Bergerie. Et puis allez ! les skis sont prêts, c''est décidé demain on se lève et on verra bien ! 8h ce matin à Annecy : c''est pas très gai. On monte quand même avec les skis ... et les chaussures de marche en se disant qu''au pire on ne montera pas pour rien. Arrivés à la Clusaz, aïe ça se gate. Alors direction Balme. Puis arrivés au parking, no comment, demi tour direct, direction le Crêt du Merle. Au crêt, seuls, les têtes sortent timidement de la voiture : 5cm, plein de végétation ! Mais on chausse quand même et nous voilà partis pour l''Aiguille ! Il est 9h30. 10h36, première conversion de la saison ! Les nouvelles chaussures vont bien, pas de soucis. Mais triste constation : au dessus de la gare du Fernuy, nous voilà partis dans un slalom spécial entre ... les pierres. On déchausse au sommet du télésiège de l''Aiguille, pour finir à pied. Puis vient le temps de descendre, mais même avec les skis cailloux, les skis sont mis sur le sac et nous voilà en train de descendre l''Aiguille à pied ! Je chausse quand même au niveau de la gare du Fernuy : l''état de mes skis prouve que ce fut une grave erreur ... Finalement on finit en ski en prenant la piste du Dahu en essayant de retrouver la voiture avec des skis encore entiers'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '47',
    current_date - 1087,
    'du grand ciel bleu à perte de vue. Par contre niveau neige, il faudra revenir : il n''y a rien ! On ne trouve de la neige skiable qu''à partir de 2800m ...',
    'j''étais venu passer le week-end à Val Thorens. Devant le peu d''enneigement, j''ai délaissé les remontées mécaniques pour chausser les peaux. Il n''y a vraiment pas de neige. Je me suis fait enfermer sur le glacier de Chavière : que de la glace vive autour de moi. Obligé de déchausser ... A l''origine je comptais aller à Gébroulaz, mais la soirée de la veille avait laissé quelques traces ...'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '48',
    current_date - 1080,
    'mauvais temps. Neige et bien bouché même si l''on sentait que le ciel bleu était pas loin. Il est tombé 30 à 40cm de neige fraîche, qui repose sur de l''herbe. Donc ça touche ...',
    'ça y est ! elle est enfin arrivée cette neige ! Mais gros risques annoncés, donc direction la combe de Balme. Les pisteurs n''avaient encore rien fait partir, on a donc dû s''arrêter à la gare du TC de Balme. Du coup petite course, mais on est monté au dessus des 1000m/h grâce à une montée sur piste damée'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '49',
    current_date - 1067,
    'le ciel était au beau fixe : du ciel bleu à perte de vue et du soleil qui tapait fort. La neige était poudreuse à de nombreux endroits et une fine couche croûtée recouvrait une neige poudreuse à quelques endroits. La neige était quand globalement assez lourde',
    'les conditions avalancheuses n''étant pas très rassurantes, je me suis tourné vers le col de Tulles et sa faible pente. Puis arrivé sur place j''ai vite bifurqué vers le col des Porthets. La montée était vraiment agréable grâce à une belle trace de montée. Il y a encore quelques pans vierges, de quoi faire de belles traces dans une neige que j''ai trouvé plutôt lourde et assez difficile à skier avec mes cuisses qui commençaient à crier un peu famine ... Du col, on a pû voir que la Goenne est un peu tracée (mais pas beaucoup) et la Tournette est complètement tracée ...'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '50',
    current_date - 1059,
    'du grand ciel bleu, chaud et lorsqu''on le voyait, le soleil tapait fort. Petit foehn en bas de la combe de Tardevant et petit vent frais aux différents cols et sommets atteints. Dans les combes, dans les pentes à l''ombre, la neige est froide et compacte avec à des endroits une très fine couche de regel : neige pas très agréable à skier. Dans les pentes plutôt orientées sud et globalement en dessous de 1800m, la neige est difficilement skiable à cause d''une bonne couche de regel. Le couloir de descente de la Tête de Paccaly est gelé : un vrai toboggan. Par contre, dans les couloirs du Milieu et du Tchadar, c''est de la poudreuse légèrement soufflée : un vrai bonheur !',
    'noël 2000 je découvre sous mon sapin le topo sur les Aravis de Shahshahani. Premier feuilletage et mon regard s''arrête tout de suite sur une course où il n''y rien de moins que 4 pages pour la décrire : 3 combes et 2 couloirs dont je n''imaginais même pas l''existence ... Voilà donc 4 ans que cette course me fait envie. 4 ans sans pouvoir la faire : mauvaises conditions, manque de temps, etc ... Mais cette année, c''est la bonne ! Renseignements pris le vendredi au forum du CAF, les conditions sont là ! Alors rendez-vous avec André le lendemain à 7h30 à Saint-Jean de Sixt. Séb, l''aixois,  s''invite à la fête : il n''est jamais allé skier dans les Aravis ... Arrivés au parking des Confins, mes deux accolites me demandent "alors où tu nous emmènes ?" "bah d''abord là, puis là, et après on revient par là et on replonge là !" "euh ... pas tout pigé" "pas grave, vous verrez sur place !". 8h20 c''est le départ et 1h10 plus tard nous voilà au pied du couloir du Tchadar : pas une trace et il est en bonne condition ! On en salive déjà ... On fait la trace jusqu''au sommet de Tardevant. Sommet parce que je ne savais pas exactement où était le col qui permettait de plonger dans Paccaly (chose qui m''a valu quelques remarques : "mais t''es bien du coin ?", "mais t''es sûr que t''es né ici ?", ...). Après une petite descente peaux encore sous les skis et une montée en traversée un peu expo, on atteint enfin ce fameux col. Le couloir plongeant dans Paccaly est un vrai toboggan : inskiable.'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '51',
    current_date - 1058,
    'ciel nuageux, gros zef au sommet. Neige froide et plutôt lourde dans les endroits où elle n''est pas tracée. La combe est en train de devenir une vraie piste',
    'au début je comptais aller dans la combe à Marion à la Blonnière, mais le couloir n''est pas purgé. Je me suis donc rabattu sur les combes des Aravis et celle du Grand Crêt. A la descente il valait mieux prendre la piste (là où c''était vraiment tout tracé) plutôt qu''aller chercher la neige vierge assez difficile à skier et casse cuisses ! '
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '52',
    current_date - 1052,
    'comme depuis maintenant plus de 2 semaines, le ciel est beau fixe, pas un nuage à l''horizon, à part dans la vallée. A la montée dans Balafrasse, la neige était gelée, couteaux obligatoires. Dans le Cu Déri puis dans la combe Sauvage, c''était poudreux : 10cm de fraîche recouvrait une très fine épaisseur de neige croûtée qui elle recouvrait une bonne neige fraîche et cohérente. Dans la combe de Montarquis, c''était de la belle neige de printemps',
    'ça c''est ce qu''on peut appeler une très belle course, voire même magnifique ! On est parti tôt, on était donc seul (au début ...); chose assez rare sur Balafrasse. L''horaire assez matinal nous a aussi permis d''observer de magnifiques bouquetins ! La montée à Balafrasse s''est faite sur une neige gelée où les couteaux étaient obligatoire. A certains endroits, même avec les couteaux c''était un peu galère. On a atteint à pied le col sous la Pointe du Midi, mais d''autres personnes y sont arrivés sans déchausser. La descente dans Cu Déri puis la combe Sauvage était tout bonnement excellente : de la vraie peuf ! bref du bonheur en boîte !! La descente de Montarquis était en neige de printemps, la aussi du vrai bonheur en boîte ! On a encore eu le loisir d''admirer la faune, mais cette fois c''était un chamois. La descente étant tellement bonne on est descendu un peu trop bas. Le manque de neige sous la Pointe Dzérat nous a obligés a regagner à pied les chalets de la Colombière. Et, là aussi rebelotte, encore des bouquetins ! J''en reviendrais presque à regretter de ne pas avoir vu le gypaète ...'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '53',
    current_date - 1051,
    'encore et encore du ciel bleu ... Sur le bas, c''est de la neige d''avril, puis sous le sommet on a eu droit à de la neige de saison : froide et bien compacte : un peu difficile à skier, mais quand même assez bonne pour se faire plaisir. Quelques rares passages en très bonne poudreuse',
    'première fois que j''allais aventurer mes spatules dans le coin et j''ai pas été déçu ! Déjà on voit tout de suite qu''on se trouve dans le théâtre de la Pierra Menta : des randonneurs en collant avançant comme des F1 à perte de vue ! Et puis le cadre est vraiment magnifique. Sinon on est monté en voiture jusqu''aux Granges et il y avait tout juste assez de neige pour monter aux Chenalettes. Après belle neige gelée rendant les couteaux quasi obligatoire jusqu''au sommet. La descente était en neige de printemps mais pas encore totalement réchauffée par le soleil pourtant énormément présent. J''ai quand même réussi à trouver une petite pente en vraie poudreuse qui m''a fait remettre les peaux'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '54',
    current_date - 1038,
    'du grand ciel bleu et des températures largement en dessous du 0°C. La neige était là et bien compacte mais avec de jolis gobelets en surface ...',
    'vu le risque 4 annoncé, nous avons fait un petit col de Tulle. Première sortie de l''année pour le Laurent : il est encore un peu rouillé mais ça devrait vite revenir... La descente était  assez bonne, mais elle n''a pas non plus atteint des sommets'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '55',
    current_date - 1031,
    'air frais, ciel bleu et grand soleil (limite trop) : une météo parfaite. Par contre la neige n''est pas excellente. Sur le haut la neige est toute soufflée : 5cm de croûtée au dessus de 30cm de poudreuse. Sur le bas, la croûte est moins importante, mais la neige est plutôt lourde',
    'c''est la sortie des premières : première rando avec le André, première rando complète pour le André et première rando tout court pour le Gérard. Et la Blonnière pour une première, c''est pas un cadeau ! Surtout quand on ne maîtrise pas les conversions, que le soleil tape, qu''il y a 1200m de dénivellée et quand la trace fait le tour de la terre ... Bref, à un moment on a bien cru qu''on avait perdu le Gérard (une petite descente de 200m s''est donc imposée pour aller le récupérer) et sur la fin Laurent et moi avons bien cru qu''on allait perdre les deux ! (je crois qu''ils nous en veulent un peu de ne pas les avoir attendu dans les 100 derniers mètres ...) Sinon la montée était bien belle, le goulet passe sans trop de soucis majeur. Par contre la descente n''était vraiment pas fameuse : neige assez difficile à skier car croûtée sur le haut puis lourde sur la fin. On a aperçu une colonie dans le Coillu à Bordel qui a l''air en top condition. Par contre, ce n''est pas du tout le cas du Combaz qui est carrément inskiable ...'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '56',
    current_date - 1030,
    'des nuages cachent le soleil mais laisse apercevoir du ciel bleu. Le goulet est en neige pourrie alors que le couloir est en top condition : neige froide compacte',
    'la veille on était à la Blonnière et on a vu que le Coillu était en top condition. Alors aujourd''hui on y est allé et on s''est régalé ! On a posé les skis vers 1900m. La suite de la montée dans le couloir était facile grâce à de superbes marches. Le Chauchefoin a l''air aussi en conditions, mais on n''y est pas allé. Sans doute une prochaine fois ...'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '57',
    current_date - 1017,
    'du mauvais temps avec une chute de neige continue et du froid. En dessous de la neige fraîche qui tombait (10cm); la neige était assez croûtée',
    'on a tracé la 3ème montée des Pointes du Midi. Une fois descendus, on s''est rendu compte que la 2ème descente avait été mal tracée et rejoignait la 3ème montée beaucoup trop tôt. Alors on est remonté jusqu''aux Touillettes pour certains, plus haut pour d''autres, pour déjalonner puis rejalonner la descente. La neige était croûtée à de pas mal d''endroits, ce qui a rendu la descente pas terrible terrible, mais quand on a refait la descente, là la neige était vraiment bonne !'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '58',
    current_date - 1016,
    'de tout : de la neige, du soleil voilé, du vent et du froid ! La neige était là en quantité et en qualité',
    'avec Antoine, on est monté molo pour pas prendre trop chaud car nous étions tous les 2 en poste pour la course des Pointes du Midi : lui au col de Châtillon, moi à l''endroit où les coureurs mettaient les skis sur le sac. On a attendu que tous les coureurs passent pour faire l''arête ... splendide ! Puis lui est redescendu au Bouchet, moi à la Joyère où j''ai eu droit à un bon verre de vin chaud. Neige extra bonne, mais malheureusement descente trop courte'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '59',
    current_date - 1012,
    'ça neigeotait, il faisait froid et la neige était là en quantité et poudreuse',
    'on voulait se faire une petite randonnée sous la plein lune. La pleine lune était bien là, mais entre nous et elle, il y avait malheureusement un gros nuage ... Donc pas de pleine lune, mais une superbe trace de montée, un superbe guide : le chien de Plan Bois qui nous a accompagné du début à la fin. Et une neige ... mais une neige ! une poudreuse jamais vue à Sulens ... Bref, la descente fut du bonheur en boîte !'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '60',
    current_date - 1009,
    'il a fait très très froid. Le soleil a été visible à de nombreux moments, mais globalement le ciel était couvert. La neige était poudreuse partout, même si elle a été croûtée sur un court passage lors de la descente',
    'je n''ai jamais vu une neige comme ça à la Tournette ! une superbe poudreuse qui ne demandait qu''à être tracée ! Il y a tellement de neige en ce moment que j''ai dû me garer en dessous des Chappes au niveau de la dernière maison habitée. ça a eu pour conséquence de rallonger la montée (1500m de dénivellée) mais surtout de rallonger la descente ! Je suis descendu par la face Nord Est : géniale ! Et en plus tout ceux qui montaient à la Tournette descendaient par l''itinéraire de montée. Du coup j''ai fait l''intégralité de la descente seul avec la poudre ...'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '61',
    current_date - 1002,
    'ciel couvert et température convenable : on n''a pas eu froid. Risque 3 annoncé, 50cm (voire plus) de neige poudreuse de chez poudreuse qui reposait sur une neige de bonne cohésion',
    'nous voilà partis dans la vallée de Chocholowska, direction le refuge du même nom ! On a fait un petit tour en traineau ! 8km de plat c''est long, et puis c''est assez sympa le traîneau. Au début on voulait monter à 3 dans le traîneau et les 3 autres se faisaient tirer. Mais les hommes en collant ont commencé à s''engueuler. Du coup on a fait 2 traineaux de 3. Les traineaux s''arrêtent, la ballade est finie, mais problème : il est où le refuge ?! euh ... bah en fait manque de bol, on s''est trompé de dolina car nous sommes dans la Kosciekiska Dolina ... Obligé de s''improviser une petite rando et de mettre les peaux pour monter au Hala Ornak. Arrivés au refuge, rencontre avec 2 groupes de français : un de Chambé, l''autre d''Annecy (tiens ! comme le monde est petit). Une petite saucisse, une petit pint et nous voilà repartis pour monter au Iwaniacka Przelecz, chacun 2 sacs sur le dos et dont un de 25kg (à l''origine on devait pas se planter de vallée ...). André a fait les 80 derniers mètres à pied, la faute à une peau qui ne voulait plus coller ... En tout cas la montée s''est faite entièrement en forêt : superbe !<br>Pour la descente on est sorti de la trace et on a tiré tout droit dans la forêt. La forêt était assez dense mais ça passait bien. On a fini par tomber sur un ruisseau : obligé de la longer. Assez galère, surtout pour Stéphane bien bien crevé qui découvrait (la joie ?) de la rando et de la descente en forêt.<br>4h après l''horaire prévue on a fini par récupérer la bonne vallée (Chocholowska, à prononcer Rorolowska ...) et le chemin. On a atteind le Chocholowska Hala de nuit après une bien belle ballade !'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '62',
    current_date - 1001,
    'neige dans la forêt, puis une fois sortis, grosses conditions : vent, froid et neige. Obligés de faire la trace dans 50cm de neige fraîche. Crêtes soufflées. Descente dans la forêt dans 50cm voire plus de neige de fraîche',
    'au début on voulait monter au Rakon, mais les grosses conditions nous ont contraints à s''arrêter au Grzes. La descente dans la forêt était du pur bonheur en boîte. Tellement bon, qu''après avoir bu la bière et pris un petit repas, on a rechaussé les skis. Stéphane est resté au refuge. On s''est arrêté à 1450m, là où on n''avait pas encore tracé la forêt. Et là, comme à la première descente, du pur bonheur en boîte ! Alors on est reparti pour une 3ème. On a lâché André dans la montée vers 1400m : problème de peau, une tendeur a pété ... Là Fred a sorti en direction de Antoine et moi un "dites les gars, ça vous dit pas d''accélérer, juste histoire de voir ce que c''est un bon rythme ?" Alors on a accéléré ... On a tiré jusqu''à la sortie de la forêt, puis Antoine a tracé dans 50cm de poudre en traversée jusque sous le Grzes afin de se retrouver au dessus d''une petit combe (1570m); ce qui a fini de l''achever (quant à Fred, on n''en parle même pas, ça fait depuis la sortie de la forêt qu''il est plus là ...). La descente de cette petite combe s''est faite dans une neige de cinéma : 50cm jusqu''à 1m de poudreuse sur une couche béton ! On en a pris plein la figure. Mais après plan (un peu ...) galère dans la forêt : on a attéri sur un ruisseau qu''on a dû longer. On est tombé x fois dans des trous, Fred en surf en a un peu bavé. Mais en arrivant au refuge, Stéphane et André nous attendaient déjà avec les pints de bière sur la table ...'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '63',
    current_date - 1000,
    'chute de neige faible, neige encore et toujours poudreuse (encore tombée au moins 30cm pendant la nuit)',
    'les descentes de la veille ayant été tellement bonnes, on n''a pas pû s''empécher d''y retourner une dernière fois avant de quitter la Dolina Chocholowska. On a fait la même chose que la veille lors de la 2ème montée : on s''est arrêté à 1450m, nos traces de la veille ayant disparues pendant la nuit ... Là encore, ça se passe de commentaires, à part que c''était du pur bonheur en boîte ...'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '64',
    current_date - 999,
    'ciel couvert, pas de neige. Neige toujours en quantité et en qualité',
    'après un dernier repas au Hala Chocholowska, on est donc reparti avec nos gros sacs (à l''origine on devait pas se planter de vallée ...) en direction de la Kosciekiska Dolina. Dans la montée vers le Kominiarska Przelecz, on a profité du Polana Jamy pour faire un arrêt saucisson - rebloch'' (après plus de 1500 bornes de route et 3j dans le fond du sac, il était en top condition ...). La descente du col n''est pas très prononcée. Stéphane, Fred et moi sommes restés en peau, alors que Antoine, Laurent et André "je suis pas venu ici pour faire de la montée" les ont enlevés. Mais on a trouvé une petite pente sans épicéas. André a immédiatement plongé dedans, suivi de Laurent puis Antoine. Stéphane et Fred ont continué en peau, mais je me suis décidé à les enlever. Puis pendant que j''enlevais mes peaux, Fred est remontée à tout de vitesse : pas possible pour lui de louper cette petite clairière en entendant les cris des autres ... Et effectivement, ça valait bien le coup de les enlever ces peaux ... Une fois de plus de la neige légère à souhait ... Puis on a rephoqué pour monter à Kominiarski Przyslop. André a encore perdu ses peaux et a du coup (encore) fini à pied ... Petite pause au Przyslop puis descente vers la Kosciekiska Dolina toujours dans le même type de neige, mais cette fois on a dû se contenter du sentier ... On a fini à ski sur le chemin de la Dolina, moi à pied et les surfeurs ... en voiture tractés par une zx ... Et pour finir on s''est bien évidemment arrêté au bar de la Dolina pour une ptite pint !'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '65',
    current_date - 998,
    'gros froid, de la neige et du vent sur les crêtes. Conditions vraiment tendues, risque 4. -11°C au thermomètre du refuge, -23°C et vent de 40km/h annoncé à Kasprowy Wierch ... du coup tous les cols et sommets sont ... interdits ...',
    'on a passé la nuit au Hala Murowaniec. La veille on est monté par la benne et sommes descendus directement au refuge. Stéphane et Fred se sont offerts une petite remontée par le télésiège et ont un peu galérer pour atteindre le refuge ... Ce jour là personne n''avait trop la forme. On était censé faire une journée dans la station puis dormir au refuge, mais le matin en se levant, en plus de la gueule de bois due à la soirée arrosée, on a encore pris un coup derrière la caboche en voyant qu''il nous manquait 2 paires de ski sur le toit de la voiture : Laurent et André se font fait voler leurs skis, vraisemblablement au petit matin ... Donc direction la police pour Laurent et moi, pendant que les autres louaient des skis ... A l''origine on était monté passer une nuit au Hala Murowaniec afin d''atteindre la région des lacs par le Zarawtowa Turnia. Les gardes du parc ne nous ont pas déconseillés d''y aller mais nous ont tout simplement interdit d''y aller ... Du coup, itinéraire de repli : descendre à Kuznice pour monter au Hala Kondratowa via la Dolina Stare Szalaziska. On a donc pris la direction du Nosalowa Przelecz. Mais manque de bol, au moment où on quitte la trace, un garde se trouvait dans les parages ... Du coup retour sur la trace, et attente du garde qui nous courait après ... Et là son premier mot fût : "passport !". Et ouais, un petit contrôle d''identité en pleine montagne ... même aux frontières on n''y a pas eu droit ... Le garde nous explique alors qu''on est obligé de monter au Nosalowa Przelecz et de prendre l''itinéraire de descente qui mène à Kuznice. On s''est donc plié aux instructions et on a profité du temps qu''on avait pour faire un petit igloo. La descente sur le chemin vers Kuznice fut assez difficile compte tenu du froid et du chemin assez plat et donc pas trop agréable pour les surfeurs ... Heureusement un petit bar nous attendait à Kuznice ...'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '66',
    current_date - 997,
    'grosses conditions : de la neige, du vent, peu de visu et un très gros froid. -23°C, vent de 40km/h au Kasprowy Wierch. Neige carton au sommet puis poudreuse mais assez dense sur le bas',
    'on est remonté dans cette jolie benne qui nous monte au Kasprowy Wierch. Là on a eu droit à LA blague de la semaine de Stéphane : "mes jumelles, je vais les appeler Fa et Bet" ... Jusqu''à présent on avait froid, mais bon, on était encore loin des -30°C qu''on nous annonçait quand on était en France et qu''on se renseignait sur les conditions en Pologne... et bah finalement ... On a vraiment eu très froid au sommet du Kasprowy Wierch. On a évité de trop traîné pour chausser ... Mais André a voulu faire durer le plaisir et a un peu galérer pour chausser ses TLT ... enfin, celles de Antoine ... A la descente on avait vraiment peu de visu, le vent assez fort n''arrangeait pas le tout. Puis on a eu droit a un peu plus de visu, une neige poudreuse mais assez dense. On a alors enchaîné les virages jusqu''à ce que Stéphane et Fred se retrouvent dans 1m de peuf ! galère de surfeur en vue ... Plus bas on est tombé sur une piste damée, juste le temps de tailler 2 3 courbes et nous voilà remettant les peaux pour une petite montée. Là un petit coup de turbo nous a permis de vite attérir dans la superbe Kondratowa Dolina. Et pour la première fois depuis le début du séjour, on a enfin pu voir les sommets environnants. Mais manque de bol, le froid a eu raison de nos appareils photos ...'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '67',
    current_date - 996,
    'enfin du beau temps avec vue sur tous les monts environnants. 0°C au refuge, pas un brin de vent. Et il a encore neigé pendant la nuit ...',
    'dernière journée de ski dans le Tatras ... La descente du Hala Kondratowa est un vrai parcours de skieur cross ! avec virages relevés et surtout ses accrochages, Laurent et André peuvent en témoigner ... Puis montée à l''hôtel Kalatowki : ça nous a fait bizarre de devoir mettre les peaux sur une piste rouge ... La petite pente raide juste avant l''hôtel a vaincu Stéphane qui a préféré la contourner ... Puis on est monté direction le Przelecz Bialego et juste avant, on a pris plein Nord en direction du Mala Krokview puis du Krokview en prenant soin de ne pas sortir de la forêt pour éviter de se faire prendre par les gardes du parc. On a eu droit à un gros vent au Krokview. Petite galère pour Stéphane pour atteindre la petite combe de descente. Mais une fois dedans, ce fût une fois de plus du bonheur en boîte ! même si la neige n''était plus si légère que les jours précédents. On a une fois de plus attéri sur un ruisseau qui a eu raison de Stéphane : grosse grosse galère pour lui. Et une fois atteint le chemin de la Dolina Bialego, on a eu droit à un "passport !". Et oui, un garde du parc qui passait par là (par hasard ?) nous attendait. Heureusement Antoine a réussi à le convaincre que nous étions passés par là à cause du risque avalancheux. On s''en tire donc avec nos noms inscrits sur son carnet et la prochaine fois "mandaté !". Stéphane, complètement démonté est descendu à Pod Skocznia et le reste de la troupe est monté au Czerwona Przelecz. On s''est fait une petite montée à plus de 800m/h, histoire de nous finir. On a encore croisé des Français ... de Chambé ! (le monde est vraiment petit, surtout qu''on les a encore croisés le soir dans un resto à Zakopane) Du Sarnia Skala la vue sur Zakopane est vraiment superbe et il était temps pour moi que le voyage s''arrête : mon tendeur pète alors que j''enlève pour la dernière fois ma dernière peau ... A la descente, on a scrupuleusement respecté les consignes du garde : rester sur le chemin.'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '68',
    current_date - 989,
    'du grand ciel bleu et de la chaleur. Neige de printemps sur le bas (croûtée à la montée, chauffée à la descente), neige poudreuse dans le couloir',
    'vue la chaleur qui a régnée pendant la semaine, on s''est replié dans le couloir Nord histoire de trouver de la bonne neige (le but étant aussi de se remettre dans de la pente). Au début on était parti cool sans se presser et puis 200m sous le sommet, j''ai entendu un "eh Francis, fais gaffe, jvais rattrapper" venant de André. Donc on s''est un peu tiré la bourre sur la fin pendant que Laurent et Sophie finissaient peinard. La neige était globalement bonne, on monte sans soucis au sommet les skis aux pieds. Du col, on a pû voir qu''il y avait des gars dans le Combaz : ça a l''air de passer. Sur le bas, à la descente, on a eu droit à de la vraie neige de printemps. Et pour la petite histoire, André ne m''a pas rattrapé ...'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '69',
    current_date - 975,
    'météo bouchée au levé, puis un grand ciel bleu tout le long de la course. ça a commencé à souffler fort à partir de l''Adlerpass et ce jusqu''au sommet. Par la suite, on a eu chaud ... très chaud ... Depuis le Strahlhorn jusque vers 3500m, on a eu de la neige froide et bien compacte, agréable à skier, plus humide par la suite. La descente de l''Allalinpass était faiblement croûtée. La descente vers Täschhütte était en neige de printemps tip top. Mais malheureusement à partir de 3000m elle devient très rare ...',
    'au levé on a un peu eu les boules quand on s''est inqiété du temps : c''était tout bouché ! Et puis comme par magie, ça s''est tout dégagé d''un coup ! Alors on est partis sur un rythme tranquille, histoire de facilement avalé ce long plat vers l''Adlerpass. Mais le paysage magnifique nous a aidés à vite faire passer le temps. Une fois à l''Adlerpass on a commencé à avoir du vent, qui ne nous a pas lâché jusqu''au sommet. Au sommet, bien évidemment vue superbe qui se passe de commentaires. Le lendemain nous devons aller à l''Alphubel en dormant à Täschhütte (warf! 1600m de dév à plus de 3000m !). Alors on n''a pas traîné, on a enchaîné la première descente, puis on est remonté à l''Allalinpass, puis petite descente et là petite remontée en plein caniard pour atteindre une crête qui nous a permis de descendre à Täschhütte dans une pure bonne neige de printemps. Mais la descente s''est vite finie en slalom entre les cailloux à partir de 3000m. On a dû poser les skis 100m avant le refuge'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '70',
    current_date - 974,
    'un grand beau temps exceptionnel. Assez froid le matin avec un léger zef. Une fois à Alphubeljoch, grosse grosse chaleur, sans aucun air frais. Neige carton puis poudreuse à la montée. A la descente on a surtout eu droit à une excellente neige poudreuse, mais surchauffée donc humide à certains endroits',
    'nous avons fait demi tour à 10h40 au pied des pentes raides sommitales orientées Est ( 3900m environ) et surchauffées ce dimanche sans un souffle d''air à cette altitude. Le sommet n''a donc pas été fait. Il y avait cependant une trace de la veille franchissant à pied une rimaye et parvenant au sommet. Compte tenu des conditions il aurait fallu être au moins une heure et demi plus tôt à cet endroit'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '71',
    current_date - 818,
    'un grand ciel bleu avec un grand soleil. Un bon vent soufflait au sommet (peut être 50km/h). Bonne neige de printemps, d''abord gelée à la montée puis bien réchauffée à la descente : un régal !',
    'après une journée seulement de mauvais temps, nous avons eu droit au soleil ! Première course de la saison et surtout du voyage. Du coup on a pris les remontées et on n''a fait que 1000m de dénivellée. On a d''abord fait le Nuevo puis le Viejo : superbe enchaînement ! La descente fut un pur régal. Bref, notre voyage commence de la meilleure des manières, espérons que ca durera !'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '72',
    current_date - 816,
    'd''abord un petit nuage au 2/3 sous le sommet qui s''est vite estompé pour laisser place à un grand ciel bleu. Au début la neige était croutée grâce à un bon regel nocturne, mais 400m sous le sommet elle ressemblait plus à de la glace qu''à de la neige, ce qui nous a contraint à mettre les crampons 150m sous le sommet',
    'quand nous sommes arrivés la veille à la "station", on s''est cru dans un véritable no man''s land : il n''y avait pas une âme qui vive ! Heureusement nous avons entendu du bruit dans une barraque et sommes allés toquer pour demander où trouver un endroit pour se loger. On nous a indiqués le ''casino'' qui est en fait la cafétéria de la "station" avec possibilité de dormir dans des dortoirs assez ... rudimentaires, surtout humides et où le chauffage est quasi inexistant ! Nous avons été accueillis par la mère qui ne pipait pas un mot de ce qu''on disait. Mais heureusement ''el nino'' a traverser la station pour nous accueillir ! Le dortoir est bien humide et la douche ne donne pas envie d''en prendre une ... Mais ''el nino'' est toujours dispo dès qu''il y a un pépin ! Style quand à 22h la chasse d''eau ne fonctionne pas, il sera toujours là pour venir la réparer et tranformer le chiotte en vraie fontaine ...<br>Bref nous n''avons pas top bien dormi et le lendemain, il faisait heureusement grand ciel bleu. Au bout de 2h30 j''étais déja en haut, Laurent arrivant 30 minutes plus tard sur ce petit bout de cratère, de tout juste 10m de diamètre ! Nous avons mis les crampons 150m sous le sommet, mais Laurent a trouvé une pente pour descendre en ski depuis le haut. Moi j''ai chaussé 100m plus bas. Après la neige glacée sur 200m, la neige fut un pur regal ! une vraie bonne neige de printemps qui malheureusement est devenue bien lourde sur les 500 derniers mètres'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '73',
    current_date - 814,
    'grand ciel bleu, pas un nuage à l''horizon et pas un brin de vent ! Sous le télésiege, la neige de printemps a bien gelée pendant la nuit. Par la suite, ça se complique, la neige est devenue béton de chez béton jusqu''au sommet',
    'ce volcan ne restera pas le plus grand souvenir du voyage. Le volcan est certes superbe, mais les conditions n''étaient pas là. La neige complètement béton nous a obligés à chausser les crampons 400m sous le sommet. Nous avons dû descendre ces mêmes 400m en crampons. Par contre dans de bonnes conditions, la descente doit être un vrai bonheur ! Depuis le sommet, on se croirait au Charvin : 10m de descente puis aucune vue sur la suite ... Mais là la descente s''est faite sur une neige béton qui a bien fait souffrir les cuisses ...'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '74',
    current_date - 813,
    'un ciel bleu à perte de vue du début à la fin de la journée. Par contre, côté neige ... aïe ! neige de printemps gelée le matin qui commence à se transformer en glace à partir de 2200m (couteaux). Plus haut la neige est tellement soufflée qu''elle devient presque de la glace. Du coup obligés de mettre les crampons à 2500m ...',
    'l''avantage des voyages c''est qu''on fait souvent des rencontres ... Nous avons rencontré Sam et Fred (deux anglais de Londres) il y a 4 jours à l''Antuco (eux venaient de le terminer, nous devions le faire le lendemain). Et par le plus grand des hasards, nous nous sommes retrouvés à la Suizandina ! Nous avons décidé de faire une sortie ensemble et pas n''importe laquelle : le Llaima et ses 2100m de dénivelée !<br>Malheureusement Fred n''a pas eu le courage de se lever, nous sommes donc partis à 3 dans le pickup rouge, Sam l''anglais au volant, conduite à gauche ... Au bout d''une petite heure de piste, nous sommes enfin au pied de ce volcan, qui est tout bonnement ... magnifique ! De la fumée s''échappe de son sommet, les araucarias posés à ses pieds ne sont qu''une invitation à skier ce volcan.<br>Le début se passe sur de la neige de printemps bien regelée durant la nuit, mais vers 2200m, les premières congères apparaissent, la neige est glacée et le soleil omniprésent la transforme presque en mirroir. J''insiste en couteaux alors que Sam et Laurent mettent déjà les crampons. Je me retrouve marcheur comme eux vers 2500m, au pied de l''arête : c''est parti pour 600m de crampons ! La montée est très ambiance entre le vent qui souffle fort, la glace bleue croisée ci et là et les parcelles de pierres volcaniques fumantes !<br>Victime de crampes, Laurent abandonne 350m sous le sommet. Nous nous retrouvons Sam et moi pour les derniers mètres sous un vent de plus en plus fort.<br>A 14h10, après 6h de montée, nous atteignons enfin le sommet ! Une épaisse fumée s''échappe du volcan.'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '75',
    current_date - 810,
    'après 3 jours de grand beau et surtout de gros vent rendant l''accès au volcan totalement impossible, le temps est parfait : ciel bleu et pas un brin de vent. Seul bémol, un nuage tenace au sommet mélangé aux fumées nous a empêchés d''admirer le panorama. Là encore, comme les sorties précédentes, niveau neige ... euh ... comment dire ... pourrie ! oui je crois que c''est le terme malheureusement. Couteaux d''entrée de jeu puis crampons au milieu : on a skié sur de la glace. Le vent quasi permanent dans le coin a modelé le manteau neigeux en de grandes vagues : aïe aïe ! dur dur la descente',
    'nous avons pris les remontées mécaniques contre 3000 pesos par personne (à condition de compter sa monnaie ...) qui nous font gagner 600m de dénivelée et presque 2h ...<br>Après 3 jours de vent à Pucon, la station est enfin ouverte, l''accès au volcan est enfin possible. Remarque, cela ne nous a pas dérangés vu que nous sommes arrivés la veille à Pucon.<br>Nous avons dû mettre d''entrée de jeu les couteaux, la faute à une neige béton et tout vaguelée. Puis 450m sous le sommet, c''est au tour des crampons de faire leur apparition, la faute à la neige devenue glace.<br>Après avoir slalomé (oui, c''est bien le terme) entre les groupes organisés, nous retrouvons le groupe d''américains croisés 2 jours plus tôt à la Suizandina. Nous terminons l''ascension ensemble et au sommet nous arrivons dans un paysage quasiment lunaire, où les nuages se mélangent aux fumées s''échappant du cratère. Cette impression est amplifiée par un bruit sourd, qui s''amplifie au fur et à mesure que nous approchons du cratère ... Oui ! ce bruit s''échappe bien du cratère et nous ne comprenons vraiment ce que c''est que lorsque les nuages se dissipent pour nous laisser entrevoir le fond du cratère où ... des jets de lave s''échappent !!! à moins de 100m de nous ... '
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '76',
    current_date - 807,
    'no comment sur la météo : un ciel bleu bleu, pas de vent et de la chaleur. Bref, c''est le printemps ! météo de printemps, neige de printemps ! un pur régal printanier ! et on n''a même pas eu besoin de mettre les couteaux !',
    'marre de rencontrer de la glace sur chacun des volcans précédents, nous avons opté pour un volcan dans le sud et bas. Et nous n''avons pas été déçus !<br>La pente finale est vraiment géniale ! Super régulière, neige tout juste transformée, un vrai bonheur à la montée ! Quant à la descente, ça se passe de commentaire !'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '77',
    current_date - 736,
    'assez froid dans l''ensemble, mais les quelques rayons de soleil que nous avons eu en début de journée nous ont bien réchauffés. Puis les nuages sont arrivés et la descente s''est faite sous une chute de petits flocons de neige. Niveau neige, il n''y a pas de sous couche, 20cm dans le meilleur des cas. La neige est sans cohésion : c''est du sucre en poudre. Le vent a dû souffler fort durant la nuit : les crêtes sont dénudées et il y a à certains endroits de bonnes accumulations. A la montée, ça skie, mais à la descente ça ne suffit pas ...',
    'première (grosse) chute de neige de la saison, première sortie de la saison (... dans les Aravis). Bien évidemment, il n''y a pas assez de neige mais il y en a bien assez pour sortir les skis caillourx, remettre les peaux et se fait plaisir à la montée. Par contre niveau descente, obligé de mettre les skis sur le dos'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '78',
    current_date - 723,
    'un beau stratus vers les 1500m rendait le départ froid et sombre. Mais une fois au dessus, c''était grand soleil et chaud ! La neige est là en quantité, sauf sur le col légèrement soufflé. C''est de la bonne poudreuse de partout, certes un peu lourde sous le sommet. Dans les pentes sud, des reptations commencent à montrer le bout de leur nez',
    'jamais vu autant de monde ! Le col était carrément rempli de randonneurs sur toute sa longueur. Heureusement, on n''est pas parti très tôt, du coup 5min après avoir atteint le sommet, tout le monde a attaqué la descente et on s''est retrouvé à un nombre plus respectable. La neige était vraiment bonne, même si un peu lourde sous le col'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '79',
    current_date - 709,
    'un grand ciel bleu de partout. A l''ombre il faisait assez frais, le petit vent n''arrangeant pas le tout. Par contre, une fois au soleil, la crème solaire était de rigueur. La neige n''est poudreuse qu''à de rares endroits. Ailleurs elle est plutôt lourde et un peu carton : le vent a fait son effet ...',
    'j''avais tellement adoré cette course l''an dernier, que je n''ai pu m''empêcher d''y retourner pour essayer mes nouveaux skis !<br>Malheureusement j''ai un peu été déçu par la neige. Certes elle est assez bonne dans l''ensemble, mais je m''attendais à mieux. Le couloir du Milieu était tout tracé,le Tchadar aussi, mais moins. Et celui qui descend sur Paccaly quand on vient de Tardevant n''était pas du tout tracé et était en top bonnes conditions !'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '80',
    current_date - 705,
    'du grand ciel bleu, quelques fois caché par des nuages passagers. Par contre, il faisait assez froid ... La chute de neige de la veille a laissé 10cm de sucre en poudre sur une neige carton et tracée',
    'la Tournette, toujours fidèle à elle même. On a chaussé vers 900m, là où la route n''est plus déneigée. La chute de neige de la veille a fait du bien pour la descente : une belle neige pour faire de belles traces. La vue sur le lac d''Annecy était malheureusement bouchée ...'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '81',
    current_date - 695,
    'un grand ciel bleu et une bonne chaleur. La neige était légèrement croûtée et un poil lourde. On trouvait quand même de la poudreuse à de rares endroits protégés du soleil',
    'première sortie en ski de rando pour Isabelle ! Très belle course d''initiation avec très peu de monde comparée à l''Aiguille Verte toute proche. Globalement les conditions de neige n''ont pas rendu la descente très agréable. La descente entre le sommet et le col n''est pas géniale géniale compte tenu du fait qu''il faut slalomer entre les creux du plateau'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '82',
    current_date - 681,
    'ciel dégagé lors des premières conversions dans la forêt, puis ça a commencé à se couvrir jusqu''à se retrouver dans le brouillard au petit Croise Baulet. En montant au Croise Baulet, à partir de 2100m, on s''est retrouvé sous un beau ciel bleu avec un beau soleil. Par la suite, les nuages ont repris le dessus. Là où la neige n''a pas pris le soleil (forêt, lisière de forêt); la neige est poudreuse à souhait. Par contre, sous le sommet la neige exposée au soleil est un peu lourde et carton à de rares endroits. Sous le petit Croise Baulet, la neige est carton et gelée',
    'vus les risques annoncés (risque 3); nous nous sommes rabattus sur une pente sud, peu pentue. Nous avons donc choisis le Croise Baulet. La montée sous les nuages nous a malheureusement bouchés le panorama. La montée vers le sommet depuis le col vaut le détour. La pente sous le sommet était assez sympa à skier, quoique la neige était un peu lourde. Sous le petit, c''est devenu carton et à de rares endroits poudreux'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '83',
    current_date - 673,
    'ciel bouché pendant toute la course. Le vent soufflait de façon soutenable au Trou de la Mouche, par contre il était assez fort au col de la Forclaz. Dans la combe de Paccaly la neige est un peu lourde et légèrement humidifiée (pas de regel). Dans le couloir Est sous le Passage du Père, possible plaque à vent dans le début du couloir que l''on a contourné en longeant par la droite sous les falaises. 3 ou 4 coulées ont eu lieu en amont du replat de la combe de tré le Crot. Lors de la remontée vers le col de la Forclaz, des pentes peuvent paraître douteuses : 10cm de neige fraîche sur une neige gelée. Les derniers 100m pour atteindre le col sont cartons. Le sommet de la combe de la Forclaz est tout soufflé avec pas mal de transports de neige (vagues). Dans le milieu de la combe, deux belles coulées ont eu lieu. Globalement la neige est lourde, difficilement skiable',
    'la veille j''appelle Antoine et tombe sur son répondeur. Et 10min plus tard, Antoine, un collègue de Antoine, m''appelle et me propose le Tour du Passage du Père. Ne connaissant pas, j''accèpte, bien qu''un peu soucieux vis à vis du risque 3 annoncé. Au final, je ne regrette pas ! Encore un nouvel itinéraire de découvert dans les combes des Aravis. Ces combes, on a beau les avoir fait 20 fois, on trouve toujours quelque chose à y faire. Le tour est vraiment superbe et l''envers des combes est si sauvage. Seul regret de la course, la neige pas terrible et des conditions avalancheuses limites'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '84',
    current_date - 667,
    'on a eu droit à un grand ciel bleu à perte de vue et du chaud. Une mer de nuage à 1300m recouvre la vallée. En face Sud, c''est de la neige de printemps. A la montée dans Balafrasse la neige est gelée, alors que dans la combe de Montarquis, la neige a bien eu le temps de se réchauffer pour donner une super bonne neige de printemps. Dans le Cu Déri, la neige est tassée et froide. Plus bas dans la combe Sauvage, la neige est carton',
    'première rando avec le Clément. André est aussi de la partie. Pour lui, c''est sa deuxième sortie en ski de rando ! Superbe course avec un bon ptit groupe. On s''est arrêté au col sous la Pointe du Midi, on n''est pas monté au sommet. La descente dans la combe de Montarquis était du pur bonheur. Tellement bonne qu''on n''a pas traversé pour rejoindre les chalets de la Colombière dans Balafrasse. Nous avons tiré tout droit jusqu''à la route. Cela nous a rajouté 200m de dénivellé pour revenir au col de la Colombière. Mais la super bonne neige dans Montarquis en valait vraiment la peine'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '85',
    current_date - 660,
    'un grand ciel bleu. Très froid à l''ombre, mais une fois au soleil, ça chauffait. Les chutes de neige de l''avant veille ont déposé une fine pellicule sur une neige complétement béton. On a dû mettre les couteaux à la montée au Rasoir. A la descente de ce col, la neige était bien poudreuse mais on skiait sur une neige béton qui a bien fait travailler les cuisses',
    'au départ, il faisait très froid (-10°); mais une fois que nous nous sommes retrouvés au soleil, on a immédiatement posé les couches. La traversée sous l''Aiguille Verte n''était pas super évidente, avec cette fine pellicule de neige sur de la neige béton. L''ambiance dans la combe du lac de Lessy est toujours aussi sauvage et ... froid ! La montée au col du Rasoir est toujours aussi superbe et sa descente a été un vrai bonheur sur le haut, puis un petit calvaire sur le bas, faute à la neige béton qui a bien fait travaillé les cuisses'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '86',
    current_date - 659,
    'du grand ciel bleu quasiment toute la journée. Le ciel a commencé à s''obscurcir à la fin de la journée. Dans la combe des Fours, une fine couche de neige fraîche repose sur une neige béton. L''arête Nord-Ouest de la Croix d''Almet est toute soufflée. La neige dans la combe Nord-Ouest sous la tête d''Auferrand est poudreuse',
    'aujourd''hui c''était l''anniversaire de Francis ! alors obligé de faire une superbe course, et on l''a faite ! La montée à la Croix d''Almet était un peu ambiance. La bouteille de rouge était bien évidemment au rendez-vous au sommet.  Malheureusement nous n''avons pas pû descendre directement sous le sommet, la neige n''étant pas au rendez-vous. Nous sommes descendus rive gauche, dans une neige poudreuse qui reposait sur une neige béton. La descente sous la Tête d''Auferrand, dans les vernes, était toute poudreuse : du bonheur en boîte !'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '99',
    current_date - 646,
    'du grand beau temps au début, puis ciel couvert',
    'on a débuté le traçage par monter l''arête Sud-Ouest puis descendre le couloir Sud-Est. Au châlet du Char on est remonté au Mont Lachat. Certains sont passés par l''arête Nord-Est, d''autres par la combe Nord-Est avant de redescendre pour se restaurer. On a fini la journée à 17h40 par une montée aux Acrets par le plan Chenaz'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '100',
    current_date - 645,
    'un grand ciel bleu et lègerement chaud',
    'on a peaufiné la trace jusqu''au sommet. Par contre à la descente, on a fait la trace ! petite galère car on n''a pas tout de suite réussi à trouver une ouverture dans la forêt pour atteindre les Touillettes ... et les concurrents n''étaient pas loin ...'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '101',
    current_date - 632,
    'un ciel bleu voilé en début de journée qui a tendu vers un ciel gris en fin de journée',
    'c''était une collective du CAF et on a vraiment mis beaucoup de temps ... surtout dans la descente du col du Chardonnet et la montée vers la fenêtre de Saleina qui était pour une fois atteignable à ski. Dernière la fenêtre il y a avait une crevasse assez impressionnante. La descente sur le glacier du Tour est fidèle à elle-même : des passages pourris entre des passages bien top'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '118',
    current_date - 358,
    'les grosses chutes de neige des 3 jours précédents ont laissé place à un grand ciel bleu et un soleil généreux. La neige est là, enfin ! Au dessus de 1900m, 40cm de fraîche. Il y a un peu de sous couche, on ne touche pas, sauf sur les faces soufflées (pente sous le sommet). Plus bas, c''est assez aléatoire, mais globalement mes skis cailloux n''ont pas souffert',
    'enfin elle est arrivée ! il aura fallu attendre, mais elle est enfin là ! alors direction l''Aiguille ... comme un peu près le tout Annecy ... abusé le monde qu''il y avait ... Il y avait tellement de neige que je suis parti du parking de la Ruade. Malheureusement mes compagnons habituels m''ont un peu délaissé, préférant les voyages lointains ou les copines ... Tant pis pour eux ! Car c''est donc seul que j''ai pu retrouver les joies de la montée en peau de phoque et surtout le bonheur de la descente dans 40cm de fraîche ! Par contre j''y ai un peu perdu mes cuisses ...'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '119',
    current_date - 335,
    'neige puis ciel dégagé avant que la neige ne refasse son apparition. Les chutes de neige de la nuit ont posé à peine 20cm à 1000m et à peine 40cm à 1600m. Au dessus, c''est tout soufflé',
    'André l''exilé réunionnais a enfin fait son retour dans le coin. Qu''il neige ou pas, rien ne pouvait l''empêcher de remettre ses skis au pied ! On est donc allé faire un tour au milieu des châlets sous le Roc des Arces. On a fait le petit couloir sous le sommet à coups de conversions histoire de voir si le André n''avait rien perdu; et il n''a rien perdu le saligot ! Au début on voulait  descendre dans sur Blay mais vu le manque de neige on est descendu dans les arcos versant Nord. On a alors remis les peaux pour monter au col de Châtillon. De là une pure descente dans la neige fraîchement tombée et super légère nous attendait. Un vrai petit bonheur en boîte !'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '120',
    current_date - 633,
    'jour blanc, neige, neige et neige. Conditions super humides et assez chaud (0°). La neige était du coup bien lourde',
    'la météo annonçait du mauvais temps et elle ne s''est pas trompée. La limite pluie neige était juste au dessus d''où on est parti. La neige qui tombait était plutôt humide. Du coup on s''est arrêté un peu trempé à la bergerie au pied de la petite combe qui donne accès au vallon des Fours. Heureusement on n''était pas monté les mains vides et le rebloch'' de Laurent fut un vrai régal huuummm'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '121',
    current_date - 310,
    'il faisait assez froid au parking (-10°); mais ce froid n''a pas trop été gênant durant la montée. Le vent l''amplifiait de temps en temps dans la combe. Mais le soleil (car il y en a eu toute la journée !) a vite fait monter le thermomètre. Sous le sommet, dans les zones à l''ombre, une fine croûte de 2-3cm couvre une neige poudreuse de 20cm. Au dessus de 2000m, la neige est tantôt poudreuse tantôt recouverte de cette croûte suivant les orientations. Plus bas (1800m); elle est poudreuse mais il y a peu si ce n''est aucune sous couche',
    'une première vraie rando pour Isabelle ! Il n''y avait vraiment pas grand monde dans les combes aujourd''hui. Dans Tardevant, on était en tout et pour tout 12 ... L''ambiance assez froide ne nous a pas gênés dans la montée, mais on a quand même préféré prendre la trace de montée sous le soleil. Une fois au soleil il faisait vraiment chaud ! La descente était dans l''ensemble super bonne jusqu''au châlet de Tardevant. Après, c''est la cata, il n''y a pas de sous couche !'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '122',
    current_date - 303,
    'ciel moutonneux en début de journée qui s''est vite dégagé pour laisser place à un large ciel bleu ensoleillé. Un petit vent rafraîchissait de temps en temps l''atmosphère. nNeige froide et compacte, croûtée à certains endroits. Sur le retour vers la station, il y a peu de neige, des zones de glaces dépassent',
    'vu le manque de neige général, nous avions décidé d''aller sur Chamonix et de se faire le col du Chardonnet. Sauf qu''une fois au sommet des Grands Montets, on s''est rendu compte que la montée n''était pas faisable (pied du glacier dans les rochers, séracs bien bien apparemments). Du coup on s''est rabattu sur le col du Tour Noir. Arrivés au pied du glacier des Améthystes, la taille des séracs à contourner contrastait avec la belle pente du glacier du Tour Noir. On est donc finalement monté au col d''Argentière ! La montée est vraiment sympa et super homogène, sans grosse difficulté, sauf sur la fin où la pente se raidit un peu. La descente ne fut pas transcendante : neige compacte, croûtée à des endroits (et les cuisses qui crient famine). Le retour à la station est assez "technique" avec des passages étroits où la glace a dû mal à être recouverte par la neige ... En tout cas ce fut une super belle journée !'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '123',
    current_date - 296,
    'la météo n''annonçait pas de précipitation dans la matinée, elle s''est plantée ! De faibles flocons tombaient, l''horizon était plus que bouchée au dessus de 1600m. Les chutes de neige des jours précédents ont apporté de l''épaisseur en plus, mais ce n''est pas encore le nirvana. De plus la neige récente est plutôt lourde et humide ',
    'c''est ce qu''on appelle un but météo ! Les précipitations annoncées dans l''après-midi sont arrivées plus tôt que prévues et au dessus du col de la Colombière, on ne voyait pas à 10m ! On s''est donc arrêté au col.'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '124',
    current_date - 289,
    'un ciel bleu légèrement voilé et une grosse chaleur. Un petit vent frais venait de temps en temps nous rafraîchir. Compte tenu de notre horaire, la neige avait déjà bien réchauffé à la montée. Elle tenait bien sous les skis à part à de rares endroits. A la descente, les pentes au soleil étaient en soupe, celles à l''ombre avaient déjà bien commencées à se durcir. Par contre à la limite de l''ombre, on a eu droit à une pure neige de printemps !',
    'malgré l''échec de la semaine dernière, on est retourné à Balafrasse. Cette fois la météo avait vu juste, mais on aurait aussi dû écouter Bison Fûté ... Résultat, on était un peu en retard sur l''horaire prévue et on a eu droit à une montée sous une belle chaleur. En tout cas, la descente a été fidèle à ses habitudes : un vrai régal dans une super bonne neige de printemps ! '
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '125',
    current_date - 282,
    'pluie au Grand Bornand qui s''est transformée en neige en milieu de matinée. Ensuite on a eu une succession de neige, soleil, neige, ... Sur l''arête, le vent soufflait vraiment fort. On ne trouve presque plus de neige en dessous de 1300m. La neige tombée est assez lourde et il y a d''assez grosses accumulations dans le couloir. La neige avait une bonne cohésion et glissait sur 50cm au passage d''un skieur',
    'vu le peu de neige on est parti du sommet du télécabine de la Joyère pour remonter le long de la route jusqu''à Plan Baudry. Le vent soufflait vraiment fort sur l''arête et au sommet on ne voyait pas à 10m. On est descendu dans un couloir qui nous a fait attérir dans la combe de la Nouvelle. Grosses accumulations dans le couloir, mais ça tenait. On a ensuite réempeauté deux fois afin de retrouver la route de montée ... qui n''était plus enneigée ...'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '126',
    current_date - 268,
    'grand ciel bleu au dessus des combes, mais par contre gros vent sur le dernier tier de la montée. Les chutes de neige de la veille ont déposé une couche de 20 à 40cm. Cette couche repose sur une neige carton. Elle est souvent poudreuse mais s''alourdit vite une fois au soleil',
    'sortie classique dans les combes. Grand Crêt est toujours aussi blindée ! Le vent était assez impressionnant mais pas gênant. Nous avons basculé dans Bella Cha pour la descente. Là par contre il n''y avait pas un chat (juste un couple) et surtout ... pas une trace ! 40cm de neige fraîche dans le haut de la combe, 20cm dans le bas ... du pur bonheur en boîte !'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '127',
    current_date - 260,
    'le ciel était couvert (on a été 5 min dans les nuages). Il faisait bon, froid sans plus. Un petit vent venait de temps en temps nous rafraîchir. Sur le dôme, la neige était plutôt carton. Dans les vernes, la neige s''est assez vite réchauffée, juste ce qu''il faut',
    'première rando du séjour dans les fjords norvégiens. Le cadre est vraiment époustouflant ! à en devenir aveugle ... Ce fut une petite rando bien sympa histoire de se mettre en jambe. Le groupe est assez hétérogène, mais tout le monde est arrivé au sommet. On est monté direct dans les vernes, dans la pente, où le groupe a complètement explosé ! Une fois sorti, tout le monde est monté à son rythme. Nous avons rencontré 3 norvégiens au sommet, sortis de nulle part : beau temps annoncé jusqu''à jeudi ! mais bon, on est en Norvège ... La descente sur le dôme ne fut pas extra dans une neige vraiment carton. Par contre dans les vernes la neige était un peu plus souple et bien meilleur mais c''était du slalom.'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '128',
    current_date - 259,
    'ciel nuageux, mais on pouvait voir au loin l''horizon. On a eu droit à un petit vent à la montée, mais rien au sommet. Neige carton et soufflée, idéale à la montée. A la descente, dans Trollhola, fine couche de neige en sucre sur une neige béton',
    'à priori pas grand chose d''intéressant à la montée : petite pente au départ, le long d''une très laide ligne électrique, puis un espèce de dôme jusqu''au sommet, surmonté d''une antenne. Non l''intérêt de la sortie n''est pas là, car le décor est tout bonnement magnifique et qui se passe de commentaire. Au sommet, on a droit à une vue à 360° sur les fjords et sur le pôle Nord (tout tout au fond). La neige était carton à la montée, idéale, surtout pour Sophie. Bernard et Gérald, les deux capitaines, nous ont rejoint plus tard au sommet.\r\nUn groupe est descendu par l''itinéraire de montée (neige vraiment pas terrible à leurs dires); un autre est descendu dans Trollhola, la face Ouest. Petite pente au départ, sur une neige en sucre : du vrai bonheur ! Plus bas, la neige était gelée, très casse patte !\r\nOn a fini la journée par un exo arva à Akkarvik sous le soleil, une bière à la main, amenée par Tyffaine et Benoît'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '129',
    current_date - 258,
    'jour blanc et gros vent à 600m. De temps en temps, des petits flocons de neige tombaient. La visibilité s''est un peu améliorée en fin de journée. Neige compacte à la montée et à la descente : un petit régal. Gelée sur la fin',
    'malheureusement les conditions ne nous ont pas permises d''aller au sommet. Nous nous sommes arrêtés au point coté 657m. Du coup nous avons descendus le vallon du Trolldalen. Super bonne neige froide et compacte au début puis gelée sur la fin avant une longue longue traversée dans les arcos pour rejoindre le point de rendez-vous.\r\nNous avons un peu attendu le bâteau. Chacun s''est occupé à sa guise : pendant que certains transformaient leur pelle en luge, d''autres creusaient des trous et enterraient les skis au Francky ...'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '130',
    current_date - 257,
    'un ciel bleu à perte de vue, vent au sommet. ',
    'l''orgie ! On était en plein milieu d''une carte postale !\r\nIl a neigé hier soir et ce matin il faisait grand beau ! La journée s''annonçait bien.\r\nLe bâteau nous a déposés à Hamnnes pour monter au Kjelvågtinden, puis au Ulöytinden et au Blåtinden. Gérald était de la partie.\r\nLe début se passe dans les vernes puis dans une montée régulière, pas vraiment pentue. Gérard, André et Gérald sont partis devant faire la trace.\r\nLes trois se sont arrêtés sur une bosse à 1020m. Je les ai rejoint et avec Gérard et André nous sommes redescendus sur 350m, face à la mer, dans une neige compacte mais qui laissait faire de belles traces. Nous sommes remontés et sommes arrivés en même temps que Vaness, Anne-Pascale et Antoine. Le vent soufflait fort, il faisait assez froid, alors que bizarrement la première fois que nous avons atteint cette bosse, il n''y avait pas un brin de vent ...\r\nGérald, Vaness et Corinne sont redescendus au bâteau alors que les autres ont continué en direction du Kjelvågtinden. Nous sommes passés sous ce sommet puis avons continué jusqu''au Ulöytinden. Françoise, Gérard et moi sommes montés au sommet, les autres s''arrêtant 50m dessous. Du sommet la vue est tout bonnement magnifique ! Pas un nuage à l''horizon ...\r\nNous sommes descendus dans le vallon du Golpervaggi. D''abord dans une neige carton puis dans une neige de cinéma : 20cm à 30cm de poudreuse vierge super légère ! Tellement bonne que nous nous sommes arrêtés au début des vernes et sommes remontés sur 600m pour se faire une ptite descente en plus ! Là encore la descente était tout bonnement orgiesque ! Pas une trace, le rêve !'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '131',
    current_date - 256,
    'beau temps en début de rando qui s''est empiré au fil de la montée. Au sommet on ne voyait plus à 10m et ça soufflait fort. A la montée, la neige était dure, idéale pour monter. A la descente la neige était lourde et profonde, dure à skier au début, puis plus souple sur la fin',
    'au début, on a bien cru qu''on allait avoir droit à une journée de rêve avec ce ciel bleu matinal. Malheureusement, le ciel s''est vite couvert. On ne voyait plus à 10m et ça soufflait très fort. On s''est donc arrêté peu avant le sommet. La traversée sous le Kalddalstindev est vraiment superbe. La remontée du Gammvikblåisen est un peu longuette mais il y a vraiment de la pente sous le col. Si en plus on y ajoute les sales conditions ... En tout cas certaines personnes n''ont pas été refroidies par ces conditions et ça ne les a pas empêchées de faire certains arrêts (...) en plein milieu de la montée ... Au début de la descente la neige était assez lourde à skier et sans visu ce n''était pas très marrant. Plus bas la neige et la visu étaient bien meilleures. De quoi se faire bien plaisir. Nous avons attéri directement au port : même pas besoin d''enlever les skis pour monter dans le bâteau !'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '132',
    current_date - 255,
    'ciel bleu mais vent dantesque (50-60km/h) sur le bas qui s''est finalement calmé au milieu de la montée. La neige était donc carton lors de la montée. A la descente, dans le couloir Sud-Ouest, la neige était décaillée puis poudreuse lourde. Le reste de la descente était aussi en poudreuse lourde',
    'une dernière course de notre voyage dans les fjords entamé une semaine plus tôt, mais quelle course ! Nous avons vraiment eu droit à un vent monstrueux ! Même pas la peine de pousser sur les jambes, ça montait tout seul ! Peu avant la bosse à 694m, Vaness, Virginie, Caro, Dominique et Antoine ont préféré renoncé et sont allés se balader autour des lacs. Les autres ont continué tant bien que mal dans ce vent à décorner les boeufs, sauf pour Francky, revenu de nul part et qui est monté comme une fusée "marre d''être derrière" comme il dit ! Peu avant le sommet, Anne-Pascale et Francky se sont arrêtés sur un replat. Ils ont été rejoints par Gérald qui était parti devant et qui descendait déjà avec un autre groupe de français du bâteau Caroline Mathilde. Les autres ont continué dans la pente finale, le vent s''étant (presque miraculeusement) arrêté. La pente s''accentue crescendo. Françoise et Laurent, puis Corinne, Sophie et André se sont arrêtés peu avant le sommet, nous laissant seuls Christian, Max et moi allés au sommet. La descente du sommet engageait un petit peu, mais sans plus. Au pied de la pente finale, Gérald, Sophie, Laurent et moi sommes descendus dans le couloir Sud-Ouest, vraiment énorme ! Les autres sont descendus à côté dans une pente moins raide. Nous avons attéri dans les lacs, ce qui nous a valu une longue poussée sur les bâtons, sauf pour Sophie qui a carrément remis les raquettes ! Francky, André et moi avons un peu tardé sur la fin de la descente, le Francky s''étant accordé quelques séquences vidéo sur une petite corniche. Une superbe course pour finir ce séjour démentiel !'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '133',
    current_date - 247,
    'que du bonheur ! un grand ciel bleu, pas trop chaud, un petit vent de temps en temps pour nous rafraîchir et une neige ! ... la chute de la veille a posé 20cm de poudreuse légère sur une neige béton ... que du bonheur !',
    'superbe journée ! Il en aura fallu du temps, mais on a enfin pu faire une rando avec le Clément. On a vraiment eu droit à de superbes conditions : du ciel bleu et une neige poudreuse à souhait comme il est rare d''en voir à la Tournette ... Par contre il y a toujours autant de monde ... A la descente, nous nous sommes arrêtés au refuge du Rosairy pour une ptite assiette du Rosairy huuumm ... et qui plus est, André le gardien a sorti la bouteille de gnole. Que du bonheur !'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '134',
    current_date - 246,
    'ciel voilé toute la journée et petit vent sous le sommet. Neige dure à la montée. La neige à l''abri du vent est poudreuse mais un peu lourde. Sous le sommet, la pente à 45° est très dure ou un peu poudreuse suivant les sections. Sur le bas de la combe, la neige commençait à se décailler. Partir une petite heure plus tard et la neige aurait sans doute été idéale',
    'première au Charvin pour moi ! Faute de neige, nous avons dû monter 150m à pied, jusqu''au bar des Fontanettes. La montée dans la combe Ouest se fait très bien, même si la neige était un peu dur par endroit. Nous avons monté l''arête en crampons. Sophie est redescendu à l''épaule pour chausser. Je suis descendu directement sous le sommet. A des endroits, la neige était vraiment béton, à d''autres endroits, poudreuse mais lourde. Pente vraiment ambiance à souhait ! Au milieu de la combe, nous avons trouvé rive gauche une superbe neige poudreuse. A la fin de la combe nous avons tiré Sud-Ouest, tellement la neige était bonne (gelée en train de se décaillée). Du coup nous avons fini dans la forêt et avons dû finir à pied sur la route pour retrouver la voiture ...'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '135',
    current_date - 240,
    'grosse grosse chaleur, à peine altérée par un très léger vent au sommet. Neige gelée à la montée, transformée à la descente. Sous le sommet, la neige est en sucre',
    'il a fait très très chaud ! Nous avons dû porter sur 150m. Au début, nous comptions nous arrêter à la Petite Sambuy, mais des marches ayant été taillées sous la Pointe de la Sambuy, Gérard, André et moi y sommes allés, laissant Sophie et Laurent à la Petit Sambuy. Il y a une belle pente sous le sommet, léger 45°, mais vraiment pas long et plus impressionante à la montée qu''à la descente. A la descente, la neige avait déjà bien eu le temps de chauffer et nous avons donc eu droit à une excellente neige de printemps ! ... sauf aux endroits encore à l''ombre, où là c''était vraiment tape cuisses ...'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '136',
    current_date - 239,
    'grand ciel bleu et chaud. Neige déjà bien réchauffée lors de notre passage. Dans certaines pentes Sud-Ouest, la neige était tout juste décaillée. Nous avons eu droit à du grézille puis de la pluie discontinue au chalet de Chizeraz en fin d''après-midi',
    'première étape de notre périple dans le Beaufortain ! Sophie le surfeur raquettiste est de la partie, Laurent a (enfin) sorti ses skis télémark et Isabelle est fin prête à passer pour la 1ère fois 2 jours en montagne skis au pied !\r\nDépart tout doux. Nous avons pris les remontées jusqu''au col de la Forclaz. Donc petite ballade, mais vue l''heure tardive il valait mieux car il faisait déjà extrêmement chaud ! \r\nNous sommes descendus sous l''épaule cotée 2553m où nous avons trouvé une bonne neige de printemps, tout juste décaillée à certains endroits et à peine lourde ailleurs. \r\nNous avons alors longé les lacs de la Tempête pour rejoindre le chalet de Chizeraz. Incroyable le contraste entre le monde au Grand Mont et la solitude rencontrée côté lacs !'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '137',
    current_date - 238,
    'grand ciel bleu et très très très chaud. A la 1ère montée depuis les lacs de la Tempête, faible couche de neige gelée (il a plu la veille). Dans la combe Sud-Ouest sous Comborsier, la neige était déjà bien décailléé (descente à 9h15) et lors de la remontée vers Comborsier, la neige commençait à devenir soupe (~10h). \r\nDans la descente vers les lacs de la Tempête, neige dure avec une fine couche de grézille, tip top. La montée vers le Passage du Dard et sa descente était en soupe',
    'deuxième étape de notre périple dans le Beaufortain ! \r\nNous avons dormi dans le chalet de Chizeraz. Tip top pour 4 personnes, super bien équipé, super bonne soirée ! \r\nNous avons démarré à 7h50, mais partir 30min plus tôt aurait été sans doute mieux. On a vraiment été seul tout le long, il n''y avait que nous 4 pour admirer ce paysage magnifique ! Super rando, super neige dans les descentes mais grosse grosse chaleur à chaque montée. \r\nLa descente vers le Planey fut un peu galère mais on s''est vite remis de tout ça grâce à un bon petit repas au restaurant La Marmotte au pied des remontées du Planey !'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '138',
    current_date - 233,
    'il a fait extrêmement chaud ! Des nuages passaient de temps en temps au dessus de nos têtes, mais pas assez pour nous donner de bonnes zones d''ombres. A partir de 3000m le vent soufflait assez fort et nous a bien rafraîchit. Nous avons eu droit à une neige de printemps en orientation Nord-Est sur le glacier de Bron mais carton au Nord sur le glacier des Grands, pas très très skiable',
    'superbe belle course proposée par Gérard ! Le cadre est vraiment superbe et on ne peut pas dire qu''il y aie vraiment beaucoup de monde ! \r\nNous avons dû porter pendant 1h sur 300m. On a fait l''erreur de remonter le ruisseau rive gauche dans les arcos, alors qu''un superbe chemin nous attendait de l''autre côté ... \r\nNous avons été pris par l''horaire et nous nous sommes arrêtés à la Croix de Bron (pour les français) ou de Béron (pour les suisses). Nous avons descendus le glacier des Grands. La neige n''était malheureusement pas superbe, car carton et très difficile à skier. Sauf sur le bas, où elle était tout juste réchauffée. \r\nBref, une super belle sortie où on reviendra forcément !'
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '139',
    current_date - 26,
    'un grand ciel bleu dans la matinée. Les nuages ont commencé à venir vers 13h pour définitivement s''installer dans l''après midi. Neige de glacier donc dur ou carton suivant les endroits au dessus de 3500m et qui s''assouplit plus bas, mais sans devenir soupe',
    'sacré p_ d''enf_ de Antoine !!!\r\nTout commence la veille vendredi. Coup de fil du Laurent : "Antoine propose le Tacul demain voire le Mont Blanc. Mais bon, je suis un peu malade et lui a mal au dos, donc on risque de ne faire que le Tacul" "ok ! ça roule". Samedi matin, rendez 7h pour prendre la 1ère benne de 7h30. Arrivé à Cham à 6h45 et là Laurent s''exclame "merde mon baudard !". Coup de fil au Antoine, obligé de faire demi-tour pour aller chercher un baudard. Au final, on ne prend que la benne de 8h15 ! Cette fois c''est sûr, le Mont Blanc ça sera pour la prochaine fois !\r\nArrivé au sommet de la benne, mais à peine le temps d''admirer le spectacle que le Antoine a déjà descendu l''arête. A peine le temps de chausser les skis que le Antoine est déjà au col du Midi. Laurent : "''tain il est bien speed le Antoine !" Francis : "je sais pas qu''il nous traffique, mais il a une idée derrière la tête ...".\r\nDescente donc de l''Aiguille jusqu''au col du Midi puis montée à l''Epaule du Tacul. Antoine distille ses conseils "bien respirer et surtout ne pas s''arrêter plus de 3 minutes". A peine le temps de mettre les skis sur le dos pour passer une rimaye au tier de la pente du Tacul que le Antoine est déjà reparti (c''est sûr il nous prépare un truc). On fini en skis jusqu''au col du Tacul et là le Antoine nous sort "bon on continue ?!" "oh ? t''es sûr ?" "Alleeeeer ... bon on va au col du Maudit et on avise, ok ?" "ok!". Mais bon, Laurent et moi connaissons déjà l''avis ...\r\nOn s''engage donc dans la montée au Maudit. '
  );
INSERT INTO
  SORTIE (ID_SORTIE, DATE_SORTIE, METEO, COMMENTAIRE)
VALUES
  (
    '146',
    current_date - 16,
    'première neige de l''année tombée en belle quantité. Il y avait bien 30cm à 50cm de fraîche suivant les endroits. Par contre, il n''y avait bien évidemment pas de sous-couche. Sinon il a fait très froid (-10° à la voiture le matin) mais on a eu droit à un grand ciel bleu. Léger vent sous le sommet',
    'première neige, première rando de l''année. Et ça fait du bien ! On a délaissé la sacro sainte Aiguille (déjà toute tracée et sans doute blindée aujourd''hui) pour aller dans l''Alpage de Tardevant : un plan de André "J''y suis allé cet été, c''est chouette et on devrait pas trop toucher". La montée à pied dans la forêt était un peu longuette, mais une fois sortie ... que du bonheur ! Superbe cadre, superbe pente. André nous a encore fait un de ces plans dont il a le secret: "J''y suis allé cet été, faut monter là". Résultat avec Sophie et Yann, ils sont allés se faire une suée et ont fait un joli détour ... Nous sommes montés un peu plus haut que le point 2143m, vers un col assez évident à droite. La neige dans l''alpage, excepté le manque de sous couche, est carrément démente. Légère à souhait, faiblement cartonnée à de rares endroits. Bref, à la descente, si on oublie les deux trois touchettes, ce n''était que du bonheur !!! Une belle première !'
  );
  /*==============================================================*/
  /* Table : PARTICIPATION                                               */
  /*==============================================================*/
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 1);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (8, 1);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 1);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (11, 1);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 2);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (7, 2);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 3);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 3);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 4);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 4);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 5);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 5);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 6);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 6);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (7, 7);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 7);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 8);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 8);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 9);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 9);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 10);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 10);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 11);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 11);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 12);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 12);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 13);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 14);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (4, 14);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (3, 14);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 14);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 14);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (8, 15);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 15);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 16);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 16);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 17);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 17);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 18);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (3, 18);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 19);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 19);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 20);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 20);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 21);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 21);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 22);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 23);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 24);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 24);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (4, 24);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (7, 24);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (8, 24);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 25);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 26);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 27);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 27);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 28);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (4, 28);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (5, 28);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 28);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 28);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (7, 29);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 29);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 30);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 31);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 32);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 32);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 33);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 34);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 34);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 35);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 35);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 35);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 36);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 36);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (8, 37);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 37);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (7, 37);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 38);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 39);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (7, 39);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 40);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 41);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (7, 41);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 42);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 42);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (3, 42);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (4, 42);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (5, 42);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 42);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (7, 42);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 43);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 43);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (3, 43);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (4, 43);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (5, 43);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 43);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (7, 43);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 44);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 44);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (7, 44);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (8, 44);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 45);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 45);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 45);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (3, 45);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 45);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (7, 45);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 46);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 46);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 47);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 48);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 48);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 49);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 50);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (8, 50);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 50);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 51);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (5, 51);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 52);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 52);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (5, 53);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 53);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 53);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (3, 53);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (7, 53);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (8, 53);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 54);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 54);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 55);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 56);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 56);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 57);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (3, 57);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (4, 57);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (5, 57);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 57);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (8, 57);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 58);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (8, 58);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 59);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 59);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 60);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 61);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 61);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 61);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 61);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (8, 61);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (7, 61);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 62);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 62);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 62);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 62);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (8, 62);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (7, 62);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 63);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 63);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 63);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 63);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (8, 63);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (7, 63);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 64);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 64);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 64);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 64);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (8, 64);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (7, 64);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 65);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 65);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 66);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 66);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (8, 66);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (7, 66);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 67);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 67);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 67);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 67);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (8, 67);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (7, 67);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 68);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 68);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 68);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 68);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 69);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 69);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (4, 69);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (3, 69);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (5, 69);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 69);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 70);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 70);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (4, 70);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (3, 70);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (5, 70);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 70);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 71);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 71);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 72);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 72);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 73);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 73);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 74);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 74);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 75);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 75);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 76);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 76);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (3, 77);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 77);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (3, 78);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 78);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 79);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (7, 80);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 80);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (3, 81);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 81);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 82);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 82);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (8, 83);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 83);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 84);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 84);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 84);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 84);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 85);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 85);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 86);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 86);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 86);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 86);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 99);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (3, 99);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (4, 99);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (5, 99);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 99);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (7, 99);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 100);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (3, 100);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (4, 100);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (5, 100);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 100);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (7, 100);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 101);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 101);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (4, 101);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (5, 101);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 101);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (7, 101);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (8, 101);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 118);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 119);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 119);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 120);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 120);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 121);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (3, 121);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 121);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 122);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 122);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (4, 122);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 123);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 123);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (4, 123);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (3, 123);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 124);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (3, 124);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 125);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (3, 125);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (4, 125);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (5, 125);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 125);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (7, 125);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (3, 126);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 126);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 127);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 127);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 127);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 127);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (8, 127);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (7, 127);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 128);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 128);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 128);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 128);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (8, 128);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (7, 128);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 129);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 129);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 129);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 129);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (8, 129);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (7, 129);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 130);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 130);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 130);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 130);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (8, 130);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (7, 130);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 131);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 131);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 131);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 131);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (8, 131);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (7, 131);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 132);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 132);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 132);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 132);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (8, 132);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (7, 132);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 133);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 133);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 133);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 134);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 134);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 135);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 135);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 135);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (4, 135);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 135);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 136);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (3, 136);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 136);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 136);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 137);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (3, 137);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 137);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 137);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 138);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 138);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (4, 138);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (3, 138);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (7, 138);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 139);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 139);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (8, 139);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (2, 146);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (4, 146);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (9, 146);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (1, 146);
INSERT INTO
  PARTICIPATION (ID_CLIENT, ID_SORTIE)
VALUES
  (6, 146);
  /*==============================================================*/
  /* Table : ITINERAIRE_SORTIE                                               */
  /*==============================================================*/
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (1, 1, 2, 1, 200);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (2, 1, 4, 1, 220);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (3, 1, 1, 3, 250);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (4, 1, 2, 3, 200);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (5, 3, 1, 4, 180);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (6, 14, 1, 5, 180);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (7, 10, 1, 6, 200);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (8, 1, 1, 7, 150);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (9, 1, 2, 7, 150);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (10, 8, 1, 8, 170);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (11, 14, 2, 9, 200);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (12, 14, 1, 9, 150);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (13, 11, 1, 10, 200);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (14, 13, 1, 12, 275);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (15, 8, 2, 13, 225);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (17, 16, 1, 14, 280);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (18, 7, 1, 15, 340);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (19, 6, 1, 16, 270);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (20, 9, 1, 19, 180);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (21, 35, 1, 19, 210);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (22, 19, 1, 24, 480);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (23, 20, 1, 26, 120);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (24, 17, 1, 28, 300);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (25, 1, 2, 29, 135);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (26, 1, 1, 29, 150);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (27, 22, 1, 30, 330);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (28, 23, 1, 31, 330);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (29, 22, 1, 32, 225);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (30, 25, 1, 33, 265);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (31, 27, 1, 33, 300);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (32, 28, 1, 37, 270);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (33, 29, 1, 43, 360);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (34, 30, 1, 45, 300);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (35, 31, 1, 47, 190);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (36, 33, 1, 52, 200);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (37, 34, 1, 53, 250);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (38, 36, 1, 56, 180);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (39, 37, 1, 57, 300);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (40, 38, 1, 57, 300);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (41, 39, 1, 61, 300);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (42, 40, 1, 62, 150);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (43, 41, 1, 64, 300);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (44, 42, 1, 65, 190);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (45, 43, 1, 66, 80);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (46, 44, 1, 67, 300);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (47, 45, 1, 69, 570);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (48, 46, 1, 70, 345);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (49, 47, 1, 71, 195);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (50, 5, 1, 72, 270);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (51, 5, 2, 72, 300);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (52, 50, 1, 74, 480);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (53, 52, 1, 76, 180);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (54, 53, 1, 81, 240);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (55, 54, 1, 82, 210);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (56, 55, 1, 83, 390);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (57, 56, 1, 86, 350);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (58, 57, 1, 99, 480);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (59, 58, 1, 122, 300);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (60, 14, 3, 124, 220);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (61, 60, 1, 127, 230);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (62, 61, 1, 128, 210);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (63, 62, 1, 129, 240);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (64, 63, 1, 130, 380);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (65, 64, 1, 131, 320);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (66, 65, 1, 132, 270);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (67, 66, 1, 134, 270);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (68, 67, 1, 135, 180);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (69, 68, 1, 136, 130);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (70, 69, 1, 137, 450);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (71, 70, 1, 138, 480);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (72, 71, 1, 139, 480);
INSERT INTO
  ITINERAIRE_SORTIE (
    NUMERO,
    ID_SOMMET,
    ID_ITINERAIRE,
    ID_SORTIE,
    DUREE_ITINERAIRE
  )
VALUES
  (73, 72, 1, 146, 360);
-- Q12 :
Alter table
  client
add
  column etat_client char(2) default 'A';
Alter table
  client
add
  constraint ck_client_etat_client check (etat_client in ('A', 'NA'));
Update
  client
set
  etat_client = 'NA'
where
  id_client not in (
    select
      distinct(id_client)
    from
      participation p
      join sortie s on p.id_sortie = s.id_sortie
    where
      current_date - s.date_sortie < 730
  );
  /*La requête SELECT permet d'établir la liste des participants actifs. La mise à jour de la table des clients ne concerne que ceux qui ne sont pas dans cette liste*/
  --Q13
SELECT
  somm.nom_sommet as "sommet",
  iti.nom as "itineraire",
  case
    when difficulte = 'F'
    or difficulte = 'PD-'
    or difficulte = 'PD' THEN 'Tout public'
    when difficulte = 'PD+'
    or difficulte = 'AD-'
    or difficulte = 'AD' THEN 'Activité sportive occasionnelle'
    when difficulte = 'AD+'
    or difficulte = 'D' THEN 'Sportif confirmé'
  end "public"
from
  sommet somm
  join itineraire iti on somm.id_sommet = iti.id_sommet;
--Q14
  drop table if exists sommet_carte;
CREATE TABLE SOMMET_CARTE AS
SELECT
  id_sommet,
  nom_sommet,
  altitude,
  reference_ign,
  titre as "titre_carte"
FROM
  SOMMET SOM
  JOIN CARTE CART ON SOM.ID_CARTE = CART.ID_CARTE;

--Q15
