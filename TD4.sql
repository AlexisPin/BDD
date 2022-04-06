-- Q2
-- DROP TABLE A ECRIRE
DROP TABLE IF EXISTS CARTE CASCADE;
DROP TABLE IF EXISTS CLIENT CASCADE;
DROP TABLE IF EXISTS PARTICIPATION CASCADE;
DROP TABLE IF EXISTS SORTIE CASCADE;
DROP TABLE IF EXISTS ITINERAIRE_SORTIE CASCADE;
DROP TABLE IF EXISTS ITINERAIRE CASCADE;
DROP TABLE IF EXISTS DIFFICULTE CASCADE;
DROP TABLE IF EXISTS SOMMET CASCADE;
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
  NOM VARCHAR(80) not null,
  PRENOM VARCHAR(80) not null,
  RUE VARCHAR(200) not null,
  CP CHAR(5) not null,
  VILLE VARCHAR(80) not null,
  TEL_FIXE CHAR(10) not null,
  MAIL VARCHAR(30),
  DATE_NAISSANCE DATE not null,
  constraint CLIENT_PK primary key (ID_CLIENT),
  constraint UQ_NOM UNIQUE(NOM),
  constraint UQ_PRENOM UNIQUE(PRENOM),
  constraint UQ_TEL_FIXE UNIQUE(TEL_FIXE)
);
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
  ORIENTATION CHAR(2) not null,
  DENIVELE INTEGER not null,
  TEMPS_PARCOURS_TH INTEGER not null,
  constraint ITINERAIRE_PK primary key (ID_SOMMET, ID_ITINERAIRE),
  constraint CK_ORIENTATION_ITINERAIRE CHECK (
    ORIENTATION in ('N', 'NE', 'E', 'SE', 'S', 'SO', 'O', 'NO')
  )
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
  constraint NUMERO_PK primary key (NUMERO),
  constraint UQ_ID_SOMMET unique(ID_SOMMET),
  constraint UQ_ID_ITINERAIRE unique(ID_ITINERAIRE),
  constraint UQ_ID_SORTIE unique(ID_SORTIE)
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
-- ALTER TABLE POUR CREER LES FOREIGN KEY A ECRIRE
ALTER TABLE
  SOMMET
ADD
  CONSTRAINT FK_SOMMET_CARTE FOREIGN KEY (ID_CARTE) REFERENCES CARTE (ID_CARTE);
ALTER TABLE
  ITINERAIRE
ADD
  CONSTRAINT FK_ITINERAIRE_SOMMET FOREIGN KEY (ID_SOMMET) REFERENCES SOMMET (ID_SOMMET);
ALTER Table
  ITINERAIRE
ADD
  CONSTRAINT FK_ITINEERAIRE_DIFFICULTE FOREIGN KEY (DIFFICULTE) REFERENCES DIFFICULTE (CODE_DIFFICULTE);
ALTER Table
  ITINERAIRE_SORTIE
ADD
  CONSTRAINT FK_ITINERAIRE_SORTIE_SORTIE FOREIGN KEY (ID_SORTIE) REFERENCES SORTIE (ID_SORTIE);
ALTER Table
  ITINERAIRE_SORTIE
ADD
  CONSTRAINT FK_ITINERAIRE_SORTIE_ITINERAIRE FOREIGN KEY (ID_ITINERAIRE, ID_SOMMET) REFERENCES ITINERAIRE (ID_ITINERAIRE, ID_SOMMET);
ALTER TABLE
  PARTICIPATION
ADD
  CONSTRAINT FK_PARTICIPATION_CLIENT FOREIGN KEY (ID_CLIENT) REFERENCES CLIENT (ID_CLIENT);
ALTER TABLE
  PARTICIPATION
ADD
  CONSTRAINT FK_PARTICIPATION_SORTIE FOREIGN KEY (ID_SORTIE) REFERENCES SORTIE (ID_SORTIE);