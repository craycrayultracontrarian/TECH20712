/**************************************************************************
	TECH20712 -- Gestion des bases de donn�es
	HEC Montr�al, H2021
	Projet Partie 2	

**************************************************************************
	INSERTION DES DONN�ES DANS LES TABLES DE la BD SPVM
	ATTENTION ! Peut prendre plsuieurs minutes,
				ne pas interompre l'ex�cution.
**************************************************************************/

USE SPVM;
GO



INSERT INTO CAT�GORIE_INTERVENTION (ID, LIBELL�, [DESCRIPTION]) VALUES (	1	,	'Infractions entrainant la mort'	,	'Meurtre au premier degr�, meurtre au deuxi�me degr�, homicide involontaire, infanticide, n�gligence criminelle, et tous autres types d�infractions entra�nant la mort'	);
INSERT INTO CAT�GORIE_INTERVENTION (ID, LIBELL�, [DESCRIPTION]) VALUES (	2	,	'Introduction'						,	'Introduction par effraction dans un �tablissement public ou une r�sidence priv�e, vol d�arme � feu dans une r�sidence'	);
INSERT INTO CAT�GORIE_INTERVENTION (ID, LIBELL�, [DESCRIPTION]) VALUES (	3	,	'M�fait'							,	'Graffiti et dommage de biens religieux, de v�hicule ou dommage g�n�ral et tous autres types de m�faits'	);
INSERT INTO CAT�GORIE_INTERVENTION (ID, LIBELL�, [DESCRIPTION]) VALUES (	4	,	'Vol dans / sur v�hicule � moteur'	,	'vol du contenu d�un v�hicule � moteur (voiture, camion, motocyclette, etc.) ou d�une pi�ce de v�hicule (roue, parechoc, etc.)'	);
INSERT INTO CAT�GORIE_INTERVENTION (ID, LIBELL�, [DESCRIPTION]) VALUES (	5	,	'Vol de v�hicule � moteur'			,	'vol de voiture, camion, motocyclette, motoneige tracteur avec ou sans remorque, v�hicule de construction ou de ferme, tout-terrain'	);
INSERT INTO CAT�GORIE_INTERVENTION (ID, LIBELL�, [DESCRIPTION]) VALUES (	6	,	'Vols qualifi�s'					,	'Vol accompagn� de violence de commerce, institution financi�re, personne, sac � main, v�hicule blind�, v�hicule, arme � feu, et tous autres types de vols qualifi�s'	);


INSERT INTO QUART_TRAVAIL (ID, LIBELL�, HEURE_D�BUT, HEURE_FIN) VALUES (	1	,	'JOUR'	,	'08:01:00'	,	'16:00:59'	);
INSERT INTO QUART_TRAVAIL (ID, LIBELL�, HEURE_D�BUT, HEURE_FIN) VALUES (	2	,	'SOIR'	,	'16:01:00'	,	'00:00:59'	);
INSERT INTO QUART_TRAVAIL (ID, LIBELL�, HEURE_D�BUT, HEURE_FIN) VALUES (	3	,	'NUIT'	,	'00:01:00'	,	'08:00:59'	);

