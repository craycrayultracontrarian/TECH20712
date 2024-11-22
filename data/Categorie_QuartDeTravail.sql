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



INSERT INTO CATÉGORIE_INTERVENTION (ID, LIBELLÉ, [DESCRIPTION]) VALUES (	1	,	'Infractions entrainant la mort'	,	'Meurtre au premier degré, meurtre au deuxième degré, homicide involontaire, infanticide, négligence criminelle, et tous autres types d’infractions entraînant la mort'	);
INSERT INTO CATÉGORIE_INTERVENTION (ID, LIBELLÉ, [DESCRIPTION]) VALUES (	2	,	'Introduction'						,	'Introduction par effraction dans un établissement public ou une résidence privée, vol d’arme à feu dans une résidence'	);
INSERT INTO CATÉGORIE_INTERVENTION (ID, LIBELLÉ, [DESCRIPTION]) VALUES (	3	,	'Méfait'							,	'Graffiti et dommage de biens religieux, de véhicule ou dommage général et tous autres types de méfaits'	);
INSERT INTO CATÉGORIE_INTERVENTION (ID, LIBELLÉ, [DESCRIPTION]) VALUES (	4	,	'Vol dans / sur véhicule à moteur'	,	'vol du contenu d’un véhicule à moteur (voiture, camion, motocyclette, etc.) ou d’une pièce de véhicule (roue, parechoc, etc.)'	);
INSERT INTO CATÉGORIE_INTERVENTION (ID, LIBELLÉ, [DESCRIPTION]) VALUES (	5	,	'Vol de véhicule à moteur'			,	'vol de voiture, camion, motocyclette, motoneige tracteur avec ou sans remorque, véhicule de construction ou de ferme, tout-terrain'	);
INSERT INTO CATÉGORIE_INTERVENTION (ID, LIBELLÉ, [DESCRIPTION]) VALUES (	6	,	'Vols qualifiés'					,	'Vol accompagné de violence de commerce, institution financière, personne, sac à main, véhicule blindé, véhicule, arme à feu, et tous autres types de vols qualifiés'	);


INSERT INTO QUART_TRAVAIL (ID, LIBELLÉ, HEURE_DÉBUT, HEURE_FIN) VALUES (	1	,	'JOUR'	,	'08:01:00'	,	'16:00:59'	);
INSERT INTO QUART_TRAVAIL (ID, LIBELLÉ, HEURE_DÉBUT, HEURE_FIN) VALUES (	2	,	'SOIR'	,	'16:01:00'	,	'00:00:59'	);
INSERT INTO QUART_TRAVAIL (ID, LIBELLÉ, HEURE_DÉBUT, HEURE_FIN) VALUES (	3	,	'NUIT'	,	'00:01:00'	,	'08:00:59'	);

