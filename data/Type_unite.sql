/**************************************************************************
	TECH20712 -- Gestion des bases de données
	HEC Montréal, H2021
	Projet Partie 2	

**************************************************************************
	INSERTION DES DONNÉES DANS LES TABLES DE la BD SPVM
	ATTENTION ! Peut prendre plsuieurs minutes,
				ne pas interompre l'exécution.
**************************************************************************/

USE SPVM;
GO

INSERT INTO TYPE_UNITÉ (ID, ABRÉVIATION, NOM) VALUES (	1	,	'APP'		,	'Appartement'	);
INSERT INTO TYPE_UNITÉ (ID, ABRÉVIATION, NOM) VALUES (	2	,	'BUREAU'	,	'Bureau'		);
INSERT INTO TYPE_UNITÉ (ID, ABRÉVIATION, NOM) VALUES (	3	,	'UNITÉ'		,	'Unité'			);
INSERT INTO TYPE_UNITÉ (ID, ABRÉVIATION, NOM) VALUES (	4	,	'APT'		,	'Apartment'		);
INSERT INTO TYPE_UNITÉ (ID, ABRÉVIATION, NOM) VALUES (	5	,	'SUITE'		,	'Suite'			);
INSERT INTO TYPE_UNITÉ (ID, ABRÉVIATION, NOM) VALUES (	6	,	'UNIT'		,	'Unit'			);
INSERT INTO TYPE_UNITÉ (ID, ABRÉVIATION, NOM) VALUES (	7	,	'ETAGE'		,	'Étage'			);
INSERT INTO TYPE_UNITÉ (ID, ABRÉVIATION, NOM) VALUES (	8	,	'FL'		,	'Floor'			);