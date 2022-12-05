USE [Test]
GO

/****** Object:  StoredProcedure [dbo].[Calcul_info_cal]    Script Date: 23/11/2022 14:06:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP	PROCEDURE [dbo].[Calcul_info_cal]
GO
CREATE PROCEDURE [dbo].[Calcul_info_cal]
@AnTrt INT,		  --contient l'anne à Traiter 
@DebutDate date,  --contient le debut de date de l'anne à Traiter
@DateTrt date	  --contient la date de la champ à traiter 

AS
BEGIN -- debut de creat procedure

/*==========================================================================*/
/*  PROJET         : CLANDRIER SELMER                                       */
/*==========================================================================*/
/* NOM			   : Calcul_info_cal										*/
/* CREATION        : 2022													*/
/* But             : calcule les nombre de jours info_cal					*/
/* Parametres      : Année de traitement,le debut de date,la date à traiter	*/
/* Appele par      : SSIS													*/
/*--------------------------------------------------------------------------*/
/* Version! Auteur ! Date       ! Commentaires                              */
/*--------!--------!------------!-------------------------------------------*/
/*    v1  !  OM    ! 19/10/2022 ! Création                                  */
/*		  !		   !            !											*/
/*--------!--------!------------!-------------------------------------------*/

-------------------------------------------DECLARATION DE LES VERIABLES-----------------------------------------------------
DECLARE
	@PremJrMs	DATE,   -- le premier jour du mois à Traiter
	@DerJrMs	DATE,	-- la dernier jour du mois à traiter 
	@PremJrSem	DATE,   -- le premier jour de la semain à Traiter
	@DerJrSem	DATE,	-- dernier jour de la semain à traiter 
	@DerJrAn	DATE,   -- la dernier jour de l'annee à Traiter
	@JrTvDateTrt FLOAT	-- la valeur de jour de la date à Traiter
--boucle sur toutes les jour de l'annee a traiter
WHILE @DateTrt <= DATEFROMPARTS(@AnTrt,12 , 31) 
	BEGIN
-------------------------------------------------INITIALISATION------------------------------------------------------------
	SET @PremJrMs  = DATEADD(MONTH,	 DATEDIFF(MONTH,0,@DateTrt), 0)						 -- calcule  premier jour du mois 
	SET @DerJrMs   = DATEADD(DAY, -1,DATEADD (MONTH,DATEDIFF(MONTH, 0, @DateTrt) + 1, 0))-- dernier  jour du mois à traiter 
	SET @PremJrSem = DATEADD(DAY, -1*DATEPART(dw, @DateTrt) + @@DATEFIRST ,@DateTrt)	 -- calcule  premier jour de la semain 
	SET @DerJrSem  = DATEADD(DAY,  7-DATEPART(dw, @DateTrt),@DateTrt) 					 -- calcule  dernier jour de la semain
	SET @DerJrAn   = DATEADD(DAY, -1,DATEADD (YEAR ,DATEDIFF(YEAR, 0, @DateTrt) + 1, 0)) -- calcule  la dernier jour de l'annee 
	SET @JrTvDateTrt = (select IC_Jtrav from Info_Cal WHERE IC_Date = @DateTrt )		 -- la valeure de jour de la date à traiter 
-------------------------------------------------LE TRAITEMENT----------------------------------------------------------------
-- set  nombre de jours travaillés ecoulés depuis l'année 2000
	UpDATE Info_Cal SET IC_EcTrRef = (SELECT SUM(IC_Jtrav)FROM Info_Cal  WHERE IC_Date BETWEEN @DebutDate AND @DateTrt) - @JrTvDateTrt	
	WHERE IC_Date = @DateTrt
-- set  nombre de jours travaillés ecoulés depuis le premier janvier
	UpDATE Info_Cal SET IC_EcTrAn = (SELECT SUM(IC_Jtrav)FROM Info_Cal  WHERE IC_Date BETWEEN @DebutDate AND @DateTrt) - @JrTvDateTrt
	WHERE IC_Date = @DateTrt
-- set  nombre de jours travaillés ecoulés depuis le debut de mois 
	UpDATE Info_Cal SET IC_EcTrMs = (SELECT SUM(IC_Jtrav)FROM Info_Cal  WHERE IC_Date BETWEEN @PremJrMs  AND @DateTrt) - @JrTvDateTrt
	WHERE IC_Date = @DateTrt
-- set  nombre de jours travaillés ecoulés depuis le debut de la semaine
	UpDATE Info_Cal SET IC_EcTrSem =(SELECT SUM(IC_Jtrav)FROM Info_Cal WHERE IC_Date BETWEEN @PremJrSem AND @DateTrt) - @JrTvDateTrt	
	WHERE IC_Date = @DateTrt
-- set  nombre de jours travaillés restant jusqu'au 31 decembre
	UpDATE Info_Cal SET IC_ReAn = (SELECT SUM(IC_Jtrav)FROM Info_Cal   WHERE IC_Date BETWEEN @DateTrt  AND @DerJrAn)
	WHERE IC_Date = @DateTrt
-- set  nombre de jours travaillés restant jusq'à la fin de mois
	UpDATE Info_Cal SET IC_ReMs = (SELECT SUM(IC_Jtrav)FROM Info_Cal   WHERE IC_Date BETWEEN @DateTrt  AND @DerJrMs )	
	WHERE IC_Date = @DateTrt
-- set  nombre de jours travaillés restant jusq'à la fin de la semain
	UpDATE Info_Cal SET IC_ReSem = (SELECT SUM(IC_Jtrav)FROM Info_Cal  WHERE IC_Date BETWEEN @DateTrt  AND @DerJrSem)
	WHERE IC_Date = @DateTrt
-- set nombre de jours travaillés  dans l'année
	UpDATE Info_Cal SET IC_TrAn =  IC_EcTrAn + IC_ReAn 
	WHERE IC_An = @AnTrt 
-- set nombre de jours travaillés  dans le mois
	UpDATE Info_Cal SET IC_TrMs =  IC_EcTrMs + IC_ReMs 
	WHERE IC_An = @AnTrt 
-- set nombre de jours travaillés  dans la semain
	UpDATE Info_Cal SET IC_TrSem =  IC_EcTrSem + IC_ReSem 
	WHERE IC_An = @AnTrt
	
	SET @DateTrt = DATEADD(DAY, 1, @DateTrt) 
	END

END --end de create procedure

--------------------------------------------------------------------------------------------------------
GO


