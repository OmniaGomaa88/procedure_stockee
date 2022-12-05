
/****** Object:  StoredProcedure [dbo].[CalDate]    Script Date: 29/09/2022 14:59:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--supprimation de la procedure
DROP PROCEDURE [dbo].[CalDate] 
GO
-- creation de la procedure
CREATE PROCEDURE [dbo].[CalDate] 
	@AnTrt INT			--contient l'anne à Traiter
	
AS
BEGIN -- debut de creat procedure

/*==========================================================================*/
/*  PROJET         : CLANDRIER SELMER                                       */
/*==========================================================================*/
/* NOM			   : CalDate												*/
/* CREATION        : 2022													*/
/* But             : Alimentation d une table de clandrier dinamique		*/
/* Parametres      : Année de traitement									*/
/* Appele par      : SSIS													*/
/*--------------------------------------------------------------------------*/
/* Version! Auteur ! Date       ! Commentaires                              */
/*--------!--------!------------!-------------------------------------------*/
/*    v1  !  OM    ! 01/09/2022 ! Création                                  */
/*		  !		   !            !											*/
/*--------!--------!------------!-------------------------------------------*/

-------------------------------------------DECLARATION DE LES VERIABLES-----------------------------------------------------
	DECLARE				 
		@DeputDate DATE,			-- le deput de le date de l'anné à Traiter
		@FinDate   DATE,			-- le fin de le date    
		@Mois      INT,				-- numero de la mois dans l'année  
		@Sem       INT ,  			-- numero de la semaine de l'année  
		@JourAn    INT	,			-- numero de la jour de l'année   
		@AnExist   BIT ,			-- veriable boolean pour verifier si l'anne à traiter exists ou pas	
		@DateMAX   BIT,				-- veriable boolean pour verifier si la date a passe le 1/10	
		@True 	   BIT = 1,			-- veriable avec valeur 1 pour l'utiliser comme valeur true 
		@False     BIT = 0			-- veriable avec valeur 0 pour l'utiliser comme valeur false 	
-------------------------------------------------INITIALISATION------------------------------------------------------------
	SET @DeputDate = DATEFROMPARTS(@AnTrt, 1, 1)
	SET @FinDate =  DATEFROMPARTS(@AnTrt,12, 31)
	SET @JourAn =   DAY(@DeputDate)
	SET @Sem = 1 
	-- set true ou false si la date passe 1/10 ou pas
	IF  MONTH(GETDATE()) >= 10 
		SET @DateMAX = @True
	ELSE 
		SET @DateMAX = @False
	-- set true ou false  si l'année exist déga ou pas
	IF EXISTS (SELECT ic_date FROM Info_Cal WHERE YEAR(IC_Date) = @AnTrt)
		SET @AnExist = @True
	ELSE 
		SET @AnExist = @False

-------------------------------------------------LE TRAITEMENT----------------------------------------------------------------
	--test si l'anna egale à 2000 et l'annee existe déga dans la clandrier, alore faire rien *ATENTION EXITE*
	IF @AnTrt = 2000 AND (@DateMAX = @False or  @AnExist = @True) RETURN
		
	--set @AnTrt a l'annee suivant si l'année pas egale à l'année par defaut (2000) et la date passe 1/10 
	IF @AnTrt =2000 And @DateMAX = @True
			SET @AnTrt = YEAR(GETDATE()) +1
	--Supprimer les données existant avan insert nouvelle année
		DELETE FROM Info_Cal  
		
	-- insert date,Anne,et nemuro de jour de l'annee
	WHILE @DeputDate <= @FinDate 
	BEGIN
		INSERT INTO Info_Cal(IC_Date,IC_An,IC_Sem,IC_JourAn )
		VALUES (@DeputDate,@AnTrt,@Sem,@JourAn)
	--ajouter un jour de la date et de l'annee aprés de la date l'instraction 
		SET @DeputDate = DATEADD(DAY, 1, @DeputDate)			
		SET  @JourAn = @JourAn +1							
	END 
	-- set semestre
	BEGIN
		UpDATE Info_Cal SET IC_Stre = 1
		WHERE MONTH(IC_Date) <= 6
		UpDATE Info_Cal SET IC_Stre = 2
		WHERE MONTH(IC_Date)>6
	END
	-- set trimster
	BEGIN
		UpDATE Info_Cal SET IC_Trim = ((MONTH(ic_DATE))+2)/3
		WHERE IC_Date <= @FinDate
	END
	-- set numero de mois dans l'anne 
	BEGIN
		Update Info_Cal SET IC_Mois = MONTH(IC_Date)
		WHERE IC_Date <= @FinDate
	END
	-- set numero de la semain
	BEGIN
		UpDATE Info_Cal SET IC_Sem = DATEPART(WEEK,IC_Date)
		WHERE IC_Date <= @FinDate 
	END
	-- set numero de la jourd dans le mois
	BEGIN
		UpDATE Info_Cal SET IC_JourMs =  DAY(IC_Date)
		WHERE IC_Date <= @FinDate  
	END
	-- set numero de jour dans le semain
	BEGIN
		UpDate Info_Cal SET IC_JourSem = DATEPART(WEEKDAY,ic_date)
		WHERE IC_Date <= @FinDate
	END
	-- set Mlib
	BEGIN
		UpDATE Info_Cal SET IC_Mlib = DATENAME(MONTH, IC_Date) 
		WHERE IC_Date <= @FinDate 
	END
	-- set Jlib
	BEGIN
	UpDATE Info_Cal SET IC_Jlib = DATENAME(WEEKDAY, IC_Date)
	WHERE IC_Date <= @FinDate  
	END
	-- set date du dernier jour du mois
	BEGIN
		UpDATE Info_Cal SET IC_DerjMs = DATEADD(MONTH, ((YEAR(IC_Date) - 1900) * 12) + MONTH(IC_Date), -1)
		WHERE IC_Date <= @FinDate
	END
	-- set date du dernier jour du mois
	BEGIN
		UpDATE Info_Cal SET IC_Jtrav = 0 
		WHERE IC_Jlib BETWEEN 'samedi' AND 'dimanche'
		UpDATE Info_Cal SET IC_Jtrav = 0.5
		WHERE IC_Jlib ='vendredi'
		UpDATE Info_Cal SET IC_Jtrav = 1 
		WHERE IC_Jlib  NOT IN ('vendredi','samedi','dimanche')
	END
	-- set le type de jour
	BEGIN
		UpDATE Info_Cal SET IC_Jtyp = 'travail'
		WHERE IC_JourSem BETWEEN 1 AND 5
		UpDATE Info_Cal SET IC_Jtyp = 'we'
		WHERE IC_JourSem BETWEEN 6 AND 7
	END
	
END --END de create procedurre
--------------------------------------------------------------------------------------------------------
GO

