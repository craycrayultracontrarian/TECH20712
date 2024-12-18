/*
22 Novembre 
Simona Bronevitsky 11316059 Yihan Hu 11330613 Jules Lemee 11303810
Le projet consiste à créer et exécuter des requêtes sur la base de données du SPVM pour analyser 
les données d'interventions et générer des rapports. Cela permet d'identifier des tendances, 
d'optimiser la prise de décision, et d'améliorer la gestion des ressources.
*/


USE master;
GO

-- Abandon forcé de la base de données si elle existe

IF DB_ID('SPVM') IS NOT NULL
BEGIN
    ALTER DATABASE SPVM SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE SPVM;
END;
GO




GO
DROP DATABASE IF EXISTS SPVM;
GO
CREATE DATABASE SPVM;
GO
USE SPVM;
GO

-- nous allons d'abord créer les tables sans référence à des clés étrangères pour éviter les conflits

DROP TABLE IF EXISTS GENRE;
CREATE TABLE GENRE
(
    ID_GENRE INT PRIMARY KEY,
    CODE NVARCHAR(30) NOT NULL,
    DÉSIGNATION NVARCHAR(50) NOT NULL,
    SALUTATION NVARCHAR(50),
    ABRÉVIATION NVARCHAR(50)
);

DROP TABLE IF EXISTS CATÉGORIE_INTERVENTION;
CREATE TABLE CATÉGORIE_INTERVENTION
(
    ID INT PRIMARY KEY,
    LIBELLÉ NVARCHAR(50) NOT NULL,
    [DESCRIPTION] NVARCHAR(500) NOT NULL
);

DROP TABLE IF EXISTS QUART_TRAVAIL;
CREATE TABLE QUART_TRAVAIL
(
    ID INT PRIMARY KEY,
    LIBELLÉ NVARCHAR(50) NOT NULL,
    HEURE_DÉBUT NVARCHAR(50) NOT NULL,
    HEURE_FIN NVARCHAR(50) NOT NULL
);

DROP TABLE IF EXISTS TYPE_RUE;
CREATE TABLE TYPE_RUE
(
    ID INT PRIMARY KEY,
    ABRÉVIATION NVARCHAR(50) NOT NULL,
    DÉSIGNATION NVARCHAR(50) NOT NULL
);

DROP TABLE IF EXISTS POINT_CARDINAL;
CREATE TABLE POINT_CARDINAL
(
    ID INT PRIMARY KEY,
    ABRÉVIATION NVARCHAR(50) NOT NULL,
    DIRECTION NVARCHAR(50) NOT NULL
);

DROP TABLE IF EXISTS TYPE_UNITÉ;
CREATE TABLE TYPE_UNITÉ
(
    ID INT PRIMARY KEY,
    ABRÉVIATION NVARCHAR(50) NOT NULL,
    NOM NVARCHAR(50) NOT NULL
);

-- nous pouvons maintenant créer des tables dont les clés étrangères renvoient aux tables que nous venons de créer (une « deuxième couche », si vous voulez).

DROP TABLE IF EXISTS INTERVENTION;
CREATE TABLE INTERVENTION
(
    ID_INTERVENTION INT PRIMARY KEY,
    ID_CATEGORIE INT NOT NULL FOREIGN KEY REFERENCES CATÉGORIE_INTERVENTION(ID),
    DATE_INCIDENT DATE NOT NULL,
    ID_QUART_TRAVAIL INT NOT NULL FOREIGN KEY REFERENCES QUART_TRAVAIL(ID)
);

DROP TABLE IF EXISTS ADRESSE;
CREATE TABLE ADRESSE
(
    ID_ADRESSE INT PRIMARY KEY,
    NO_CIVIQUE INT NOT NULL,
    TYPE_RUE_ID INT NOT NULL  FOREIGN KEY REFERENCES TYPE_RUE(ID),
    NOM NVARCHAR(50) NOT NULL,
    PRÉPOSITION NVARCHAR(50),
    POINT_CARDINAL_ID INT FOREIGN KEY REFERENCES POINT_CARDINAL(ID),
    UNITÉ NVARCHAR(50),
    TYPE_UNITÉ_ID INT FOREIGN KEY REFERENCES TYPE_UNITÉ(ID),
    CODE_POSTAL NVARCHAR(50) NOT NULL
);

-- « troisème couche »

DROP TABLE IF EXISTS POSTE_DE_QUARTIER;
CREATE TABLE POSTE_DE_QUARTIER
(
    ID_PDQ INT PRIMARY KEY,
    ID_ADRESSE INT FOREIGN KEY REFERENCES ADRESSE(ID_ADRESSE)
);

-- « quatrième couche »

DROP TABLE IF EXISTS COUVERTURE;
CREATE TABLE COUVERTURE
(
    ID_COUVERTURE NVARCHAR(30) PRIMARY KEY,
    ID_PDQ INT FOREIGN KEY REFERENCES POSTE_DE_QUARTIER(ID_PDQ),
    NOM NVARCHAR(100) NOT NULL    
);

DROP TABLE IF EXISTS AGENT;
CREATE TABLE AGENT
(
    MATRICULE INT PRIMARY KEY,
    GENRE INT NOT NULL FOREIGN KEY REFERENCES GENRE(ID_GENRE),
    PRENOM NVARCHAR(50) NOT NULL,
    NOM NVARCHAR(50) NOT NULL,
    PDQ INT NOT NULL FOREIGN KEY REFERENCES POSTE_DE_QUARTIER(ID_PDQ),
);

-- « cinquième couche »

DROP TABLE IF EXISTS INTERVENTION_AGENT;
CREATE TABLE INTERVENTION_AGENT
(
    MATRICULE_AGENT INT FOREIGN KEY REFERENCES AGENT(MATRICULE),
    ID_INTERVENTION INT FOREIGN KEY REFERENCES INTERVENTION(ID_INTERVENTION),
    EST_RAPORTEUR NVARCHAR(50),
    PRIMARY KEY (MATRICULE_AGENT,ID_INTERVENTION)
);

DROP TABLE IF EXISTS DIVISION_ADMINISTRATIVE;
CREATE TABLE DIVISION_ADMINISTRATIVE 
(
    ID_DIVISION NVARCHAR(30) PRIMARY KEY REFERENCES COUVERTURE(ID_COUVERTURE) ,
    ID_ADRESSE INT NOT NULL FOREIGN KEY REFERENCES ADRESSE(ID_ADRESSE),
);

-- « sixième couche »

DROP TABLE IF EXISTS QUARTIER;
CREATE TABLE QUARTIER 
( 
    NUM_QUARTIER NVARCHAR(30) PRIMARY KEY REFERENCES COUVERTURE(ID_COUVERTURE),
    ID_DIVISION NVARCHAR(30) NOT NULL FOREIGN KEY REFERENCES DIVISION_ADMINISTRATIVE(ID_DIVISION) ,
    NB_LOGEMENTS INT,
);

DROP TABLE IF EXISTS VILLE;
CREATE TABLE VILLE
(
    ID_VILLE NVARCHAR(30) PRIMARY KEY REFERENCES DIVISION_ADMINISTRATIVE(ID_DIVISION),
    [POPULATION] INT NOT NULL,
    NB_LOGEMENTS INT,
    SUPERFICIE_TERRESTRE FLOAT NOT NULL,
);

-- "seventh and final layer"

DROP TABLE IF EXISTS ARRONDISSEMENT;
CREATE TABLE ARRONDISSEMENT 
(
    ID_ARRONDISSEMENT NVARCHAR(30) PRIMARY KEY REFERENCES DIVISION_ADMINISTRATIVE(ID_DIVISION),
    ID_VILLE NVARCHAR(30) NOT NULL FOREIGN KEY REFERENCES VILLE(ID_VILLE),
    PERIMÈTRE FLOAT,
    SUPERFICIE FLOAT,
);

DROP TABLE IF EXISTS ENTITÉ;
CREATE TABLE ENTITÉ 
(
    ID_ENTITÉ NVARCHAR(30) PRIMARY KEY REFERENCES DIVISION_ADMINISTRATIVE(ID_DIVISION),
    ID_VILLE NVARCHAR(30) NOT NULL FOREIGN KEY REFERENCES VILLE(ID_VILLE),
    [DESCRIPTION] NVARCHAR(100) NOT NULL,
    NOM_CODE NVARCHAR(50) NOT NULL,
);



-- Ici, nous détaillerons nos déclencheurs pour garantir qu'il n'y a pas d'héritage entre les autres tables.
-- Nous nous concentrons sur les tables suivantes : Entité, Ville, Arrondissement, Division Administrative et Quartier.
-- Nous voulons nous assurer que la clé primaire de ce que nous essayons d'insérer n'existe pas ailleurs.
-- Si c'était le cas, nos données n'auraient pas de sens, car la clé primaire est également une clé étrangère provenant de la même source.

-- DIVISION_ADMINISTRATIVE a 3 sous-tables : ARRONDISSEMENT, VILLE et ENTITÉ.
-- Il y a également QUARTIER, qui n'a pas de sous-tables.

-- Ces 5 tables partagent toutes un "parent" : COUVERTURE. Elles obtiennent leur clé primaire à partir de ce parent.

-- Ainsi, lors de nos déclencheurs, nous devons nous assurer que la clé primaire que nous voulons insérer n'existe pas ailleurs.

-- QUARTIER vérifiera la duplication de clé primaire avec DIVISION_ADMINISTRATIVE.
-- DIVISION_ADMINISTRATIVE vérifiera avec QUARTIER.
-- Les sous-tables vérifieront entre elles ainsi qu'avec QUARTIER (par exemple : ENTITÉ vérifiera VILLE, ARRONDISSEMENT et QUARTIER).

-- Entité 

GO
USE SPVM;
GO
DROP TRIGGER IF EXISTS dbo.ENTITÉ_TRIGGER;
GO
CREATE TRIGGER dbo.ENTITÉ_TRIGGER ON ENTITÉ AFTER INSERT
AS
BEGIN
    DECLARE @ID_TOCHECK NVARCHAR(30);
    DECLARE @SOURCE NVARCHAR(30);
    DECLARE @STATUS INT; -- Si 1, l'insertion est erronée et nous devons imprimer notre erreur. Si 0 : tout va bien.
    SET @ID_TOCHECK = (SELECT ID_ENTITÉ FROM INSERTED);
    BEGIN
    	IF EXISTS (SELECT NUM_QUARTIER FROM QUARTIER WHERE NUM_QUARTIER = @ID_TOCHECK)
            BEGIN
                SET @STATUS = 1
                SET @SOURCE = 'QUARTIER'
            END
        ELSE IF EXISTS (SELECT ID_VILLE FROM VILLE WHERE ID_VILLE = @ID_TOCHECK)
            BEGIN
                SET @STATUS = 1
                SET @SOURCE = 'VILLE'
            END
        ELSE IF EXISTS (SELECT ID_ARRONDISSEMENT FROM ARRONDISSEMENT WHERE ID_ARRONDISSEMENT = @ID_TOCHECK)
            BEGIN
                SET @STATUS = 1
                SET @SOURCE = 'ARRONDISSEMENT'
            END
        ELSE
            BEGIN
                SET @STATUS = 0
            END

        IF @STATUS = 1
            BEGIN
                PRINT('clé [ID_ENTITÉ = '+@ID_TOCHECK+'] pour nouvel "ENTITÉ" déjà utilisée ailleurs (Table '+@SOURCE+'). Insertion dans "ENTITÉ" impossible.');
				ROLLBACK TRANSACTION;
            END
	END;
END;
GO

-- Ville
DROP TRIGGER IF EXISTS dbo.VILLE_TRIGGER;
GO
CREATE TRIGGER dbo.VILLE_TRIGGER ON VILLE AFTER INSERT
AS
BEGIN
    DECLARE @ID_TOCHECK NVARCHAR(30);
    DECLARE @SOURCE NVARCHAR(30);
    DECLARE @STATUS INT; 
    SET @ID_TOCHECK = (SELECT ID_VILLE FROM INSERTED);
    BEGIN
    	IF EXISTS (SELECT NUM_QUARTIER FROM QUARTIER WHERE NUM_QUARTIER = @ID_TOCHECK)
            BEGIN
                SET @STATUS = 1
                SET @SOURCE = 'QUARTIER'
            END
        ELSE IF EXISTS (SELECT ID_ENTITÉ FROM ENTITÉ WHERE ID_ENTITÉ = @ID_TOCHECK)
            BEGIN
                SET @STATUS = 1
                SET @SOURCE = 'ENTITÉ'
            END
        ELSE IF EXISTS (SELECT ID_ARRONDISSEMENT FROM ARRONDISSEMENT WHERE ID_ARRONDISSEMENT = @ID_TOCHECK)
            BEGIN
                SET @STATUS = 1
                SET @SOURCE = 'ARRONDISSEMENT'
            END
        ELSE
            BEGIN
                SET @STATUS = 0
            END

        IF @STATUS = 1
            BEGIN
                PRINT('clé [ID_VILLE = '+@ID_TOCHECK+'] pour nouvel "VILLE" déjà utilisée ailleurs (Table '+@SOURCE+'). Insertion dans "VILLE" impossible.');
				ROLLBACK TRANSACTION;
            END
	END;
END;
GO

-- Arrondissement
DROP TRIGGER IF EXISTS dbo.ARRONDISSEMENT_TRIGGER;
GO
CREATE TRIGGER dbo.ARRONDISSEMENT_TRIGGER ON ARRONDISSEMENT AFTER INSERT
AS
BEGIN
    DECLARE @ID_TOCHECK NVARCHAR(30);
    DECLARE @SOURCE NVARCHAR(30);
    DECLARE @STATUS INT;
    SET @ID_TOCHECK = (SELECT ID_ARRONDISSEMENT FROM INSERTED);
    BEGIN
    	IF EXISTS (SELECT NUM_QUARTIER FROM QUARTIER WHERE NUM_QUARTIER = @ID_TOCHECK)
            BEGIN
                SET @STATUS = 1
                SET @SOURCE = 'QUARTIER'
            END
        ELSE IF EXISTS (SELECT ID_VILLE FROM VILLE WHERE ID_VILLE = @ID_TOCHECK)
            BEGIN
                SET @STATUS = 1
                SET @SOURCE = 'VILLE'
            END
        ELSE IF EXISTS (SELECT ID_ENTITÉ FROM ENTITÉ WHERE ID_ENTITÉ = @ID_TOCHECK)
            BEGIN
                SET @STATUS = 1
                SET @SOURCE = 'ENTITÉ'
            END
        ELSE
            BEGIN
                SET @STATUS = 0
            END

        IF @STATUS = 1
            BEGIN
                PRINT('clé [ID_ARRONDISSEMENT = '+@ID_TOCHECK+'] pour nouvel "ARRONDISSEMENT" déjà utilisée ailleurs (Table '+@SOURCE+'). Insertion dans "ARRONDISSEMENT" impossible.');
				ROLLBACK TRANSACTION;
            END
	END;
END;
GO
-- Division Administrative
DROP TRIGGER IF EXISTS dbo.ENTITÉ_DIVISION_ADMINISTRATIVE;
GO
CREATE TRIGGER dbo.ENTITÉ_DIVISION_ADMINISTRATIVE ON DIVISION_ADMINISTRATIVE AFTER INSERT
AS
BEGIN
    DECLARE @ID_TOCHECK NVARCHAR(30);
    DECLARE @SOURCE NVARCHAR(30);
    DECLARE @STATUS INT; 
    SET @ID_TOCHECK = (SELECT ID_DIVISION FROM INSERTED);
    BEGIN
    	IF EXISTS (SELECT NUM_QUARTIER FROM QUARTIER WHERE NUM_QUARTIER = @ID_TOCHECK)
            BEGIN
                SET @STATUS = 1
                SET @SOURCE = 'QUARTIER'
            END
        ELSE
            BEGIN
                SET @STATUS = 0
            END

        IF @STATUS = 1
            BEGIN
                PRINT('clé [ID_DIVISION = '+@ID_TOCHECK+'] pour nouvel "DIVISION_ADMINISTRATIVE" déjà utilisée ailleurs (Table '+@SOURCE+'). Insertion dans "DIVISION_ADMINISTRATIVE" impossible.');
				ROLLBACK TRANSACTION;
            END
	END;
END;
GO
-- Quartier
SELECT * FROM QUARTIER
DROP TRIGGER IF EXISTS dbo.QUARTIER_TRIGGER;
GO
CREATE TRIGGER dbo.QUARTIER ON QUARTIER AFTER INSERT
AS
BEGIN
    DECLARE @ID_TOCHECK NVARCHAR(30);
    DECLARE @SOURCE NVARCHAR(30);
    DECLARE @STATUS INT; 
    SET @ID_TOCHECK = (SELECT NUM_QUARTIER FROM INSERTED);
    BEGIN
		IF EXISTS (SELECT ID_ENTITÉ FROM ENTITÉ WHERE ID_ENTITÉ = @ID_TOCHECK)
            BEGIN
                SET @STATUS = 1
                SET @SOURCE = 'ENTITÉ'
            END
        ELSE IF EXISTS (SELECT ID_VILLE FROM VILLE WHERE ID_VILLE = @ID_TOCHECK)
            BEGIN
                SET @STATUS = 1
                SET @SOURCE = 'VILLE'
            END
        ELSE IF EXISTS (SELECT ID_ARRONDISSEMENT FROM ARRONDISSEMENT WHERE ID_ARRONDISSEMENT = @ID_TOCHECK)
            BEGIN
                SET @STATUS = 1
                SET @SOURCE = 'ARRONDISSEMENT'
            END
		ELSE IF EXISTS (SELECT ID_DIVISION FROM DIVISION_ADMINISTRATIVE WHERE ID_DIVISION = @ID_TOCHECK)
            BEGIN
                SET @STATUS = 1
                SET @SOURCE = 'DIVISION_ADMINISTRATIVE'
            END
        ELSE
            BEGIN
                SET @STATUS = 0
            END

        IF @STATUS = 1
            BEGIN
                PRINT('clé [NUM_QUARTIER = '+@ID_TOCHECK+'] pour nouvel "QUARTIER" déjà utilisée ailleurs (Table '+@SOURCE+'). Insertion dans "QUARTIER" impossible.');
				ROLLBACK TRANSACTION;
            END
	END;
END;
GO

