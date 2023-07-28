-- Declare start and end variables
DECLARE @start DATE = '2022-01-22';
DECLARE @end DATE = '2022-12-31';
-- This is some sql code that extracts all claims by specific PFros, as outlined by NPI below.

-- Check if the temporary table exists and drop it if it does
IF OBJECT_ID('tempdb..#ValueSetListMy2023') IS NOT NULL
    DROP TABLE #ValueSetListMy2023;

-- Create a temporary table
CREATE TABLE #ValueSetListMy2023 (Code VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS);

-- Insert values into the temporary table
INSERT INTO #ValueSetListMy2023 (Code)
VALUES ('1528415650'), ('1528415650'), ('1932373867'), ('1891969879'), ('1891969879'), ('1679747505'), ('1679747505'), ('1760656698'), ('1760656698'), ('1669646592'), ('1669646592'), ('1164799987'), ('1437599230'), ('1811454754'), ('1467751511'), ('1467751511'), ('1073935326'), ('1073935326'), ('1497815567'), ('1366884413'), ('1366884413'), ('1851735369'), ('1407257595'), ('1992816060');

-- Query to retrieve data from the claims.dbo.shcavos table
SELECT DISTINCT
	shcavos.primaryID, 
	id.BCBSMedicaidId AS MemberID,
	shcavos.AHCCCSID,
	shcavos.MemberCounty,
	shcavos.MemberZipCode,
	shcavos.MemberACCGSA,
	shcavos.ra,
	shcavos.begDate,
	shcavos.svccode,
	shcavos.ProviderName,
	shcavos.Placesvc,
	shcavos.ProviderType,
	shcavos.calcnetpd,
	shcavos.units,
	shcavos.PaySource,
	shcavos.PlanType,
	shcavos.AdmitDate,
	shcavos.DischargeDate,
	shcavos.RenderingProviderNpi,
	shcavos.RenderingProviderCounty,
	shcavos.RenderingProviderZipCode,
    shcavos.PrimaryDiagnosis,
    shcavos.Dx1,
    shcavos.Dx2,
    shcavos.Dx3,
    shcavos.Dx4,
    shcavos.Dx5,
    shcavos.Dx6,
    shcavos.Dx7,
    shcavos.Dx8,
    shcavos.Dx9,
    shcavos.Dx10,
    shcavos.Dx11,
    shcavos.Dx12,
    CASE WHEN v.Code IS NOT NULL THEN 'True' ELSE 'False' END AS MatchFound
FROM claims.dbo.shcavos AS shcavos
LEFT JOIN GlobalMembers.dbo.ClientIdPlus id ON shcavos.primaryID = id.primaryID
LEFT JOIN #ValueSetListMy2023 AS v ON shcavos.RenderingProviderNpi COLLATE SQL_Latin1_General_CP1_CI_AS = v.Code
                                    OR shcavos.Dx1 COLLATE SQL_Latin1_General_CP1_CI_AS = v.Code
                                    OR shcavos.Dx2 COLLATE SQL_Latin1_General_CP1_CI_AS = v.Code
                                    OR shcavos.Dx3 COLLATE SQL_Latin1_General_CP1_CI_AS = v.Code
                                    OR shcavos.Dx4 COLLATE SQL_Latin1_General_CP1_CI_AS = v.Code
                                    OR shcavos.Dx5 COLLATE SQL_Latin1_General_CP1_CI_AS = v.Code
                                    OR shcavos.Dx6 COLLATE SQL_Latin1_General_CP1_CI_AS = v.Code
                                    OR shcavos.Dx7 COLLATE SQL_Latin1_General_CP1_CI_AS = v.Code
                                    OR shcavos.Dx8 COLLATE SQL_Latin1_General_CP1_CI_AS = v.Code
                                    OR shcavos.Dx9 COLLATE SQL_Latin1_General_CP1_CI_AS = v.Code
                                    OR shcavos.Dx10 COLLATE SQL_Latin1_General_CP1_CI_AS = v.Code
                                    OR shcavos.Dx11 COLLATE SQL_Latin1_General_CP1_CI_AS = v.Code
                                    OR shcavos.Dx12 COLLATE SQL_Latin1_General_CP1_CI_AS = v.Code
WHERE shcavos.begDate BETWEEN @start AND @end
AND CASE WHEN v.Code IS NOT NULL THEN 'True' ELSE 'False' END = 'True'
AND shcavos.EncounterStatus = 'AP';