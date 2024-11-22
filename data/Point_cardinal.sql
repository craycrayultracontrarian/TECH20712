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

INSERT INTO POINT_CARDINAL (ID, ABRÉVIATION, DIRECTION) VALUES (	1	,	'E'		,	'Est'			);
INSERT INTO POINT_CARDINAL (ID, ABRÉVIATION, DIRECTION) VALUES (	2	,	'N'		,	'Nord'			);
INSERT INTO POINT_CARDINAL (ID, ABRÉVIATION, DIRECTION) VALUES (	3	,	'NE'	,	'Nord-est'		);
INSERT INTO POINT_CARDINAL (ID, ABRÉVIATION, DIRECTION) VALUES (	4	,	'NO'	,	'Nord-ouest'	);
INSERT INTO POINT_CARDINAL (ID, ABRÉVIATION, DIRECTION) VALUES (	5	,	'O'		,	'Ouest'			);
INSERT INTO POINT_CARDINAL (ID, ABRÉVIATION, DIRECTION) VALUES (	6	,	'S'		,	'Sud'			);
INSERT INTO POINT_CARDINAL (ID, ABRÉVIATION, DIRECTION) VALUES (	7	,	'SE'	,	'Sud-est'		);
INSERT INTO POINT_CARDINAL (ID, ABRÉVIATION, DIRECTION) VALUES (	8	,	'SO'	,	'Sud-ouest'		);
