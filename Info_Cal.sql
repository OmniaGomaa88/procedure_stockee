
/*==========================================================================*/
/*  PROJET         : CLANDRIER SELMER                                       */
/*==========================================================================*/
/* NOM			   : Info_Cal												*/
/* CREATION        : 2022													*/
/* But             : Creation d'une table de clandrier 						*/
/* Appele par      : SQL SERVER												*/
/*--------------------------------------------------------------------------*/
/* Version! Auteur ! Date       ! Commentaires                              */
/*--------!--------!------------!-------------------------------------------*/
/*    v1  !  OM    ! 01/09/2022 ! Création                                  */
/*		  !		   !            !											*/
/*--------!--------!------------!-------------------------------------------*/

/****** Object:  Table [dbo].[Info_Cal]    Script Date: 31/08/2022 17:10:02 ******/
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Info_Cal') DROP TABLE [dbo].[Info_Cal];
GO

/****** Object:  Table [dbo].[Info_Cal]    Script Date: 31/08/2022 17:10:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Info_Cal]
(
	[IC_Date]		[DATE]			NOT NULL	PRIMARY KEY DEFAULT '2000-01-01',	/* Date   */
	[IC_An]			[int]			NOT NULL	DEFAULT 0 ,							/* année  */
	[IC_Stre]		[int]			NOT NULL	DEFAULT 0 ,							/* Semestre*/
	[IC_Trim]		[int]			NOT NULL	DEFAULT 0 ,						   	/* Trimestre*/
	[IC_Mois]		[int]			NOT	NULL	DEFAULT 0  ,						/* Mois*/
	[IC_Sem]		[int]			NOT NULL	DEFAULT 0,						    /* semaine*/
	[IC_JourAn]		[int]			NOT NULL	DEFAULT 0,						    /* Jour dans l'année */
	[IC_JourMS]		[int]			NOT NULL	DEFAULT 0,						    /* jour dans mois*/
	[IC_JourSem]	[int]			NOT NULL	DEFAULT 0,						    /* jour dans semain*/
	[IC_Mlib]		[nvarchar](20)	NOT NULL	DEFAULT 'ND',						/* nom du mois*/
	[IC_Jlib]		[nvarchar](10)	NOT NULL	DEFAULT 'ND',						/* nom du jour */
	[Ic_DerjMs]		[DATE]			NOT NULL	DEFAULT '2000-01-01',				/* date du dernier jour du mois*/
	[IC_Jtrav]		[FLOAT]			NOT NULL	DEFAULT 0 ,							/* valeur de jour travailler = 1,les weak-end=0	, et le vendredi = 0,5*/
	[IC_Jtyp]		[nvarchar](10)	NOT NULL	DEFAULT 'ND' ,						/* type de jour,RTT,férié,congé ,travail,we*/
	[IC_EcTrRef]	[FLOAT]			NOT NULL	DEFAULT 0 ,							/* nombre de jours travaillés ecoulés depuis le 2000/01/01 */
	[IC_EcTrAn]		[FLOAT]			NOT NULL	DEFAULT 0 ,							/* nombre de jours travaillés ecoulés depuis le premier janvier  */
	[IC_EcTrMs]		[FLOAT]			NOT NULL	DEFAULT 0 ,							/* nombre de jours travaillés ecoulés depuis le debut de mois  */
	[IC_EcTrSem]	[FLOAT]			NOT NULL	DEFAULT 0 ,							/* nombre de jours travaillés ecoulés depuis le debut de la semaine  */
	[IC_TrAn]		[FLOAT]			NOT NULL	DEFAULT 0 ,							/* nombre de jours travaillés dans l'année */
	[IC_TrMs]		[FLOAT]			NOT NULL	DEFAULT 0 ,							/* nombre de jours travaillés dans le mois  */
	[IC_TrSem]		[FLOAT]			NOT NULL	DEFAULT 0 ,							/* nombre de jours travaillés dans la semain */
	[IC_ReAn]		[FLOAT]		    NOT NULL	DEFAULT 0 ,							/* nombre de jours travailler restant jusqu'au 31 decembre  */
	[IC_ReMs]		[FLOAT]			NOT NULL	DEFAULT 0 ,							/* nombre des joures travailler rest jusq'à la fin de mois  */
	[IC_ReSem]		[FLOAT]			NOT NULL	DEFAULT 0 ,							/* nombre des joures travailler rest jusq'à la fin de la semain  */	
) 

GO

CREATE INDEX ix_IC_Date ON Info_Cal(IC_Date);
