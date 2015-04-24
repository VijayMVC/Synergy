


SELECT
	[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
	,[SCHEDULE].[DEPARTMENT]
	,[SCHEDULE].[COURSE_ID]
	,[SCHEDULE].[COURSE_TITLE]	
	,[STAFF_PERSON].[LAST_NAME]
	,[STAFF_PERSON].[FIRST_NAME]
	,[STAFF_PERSON].[MIDDLE_NAME]
	,REPLACE([STAFF].[BADGE_NUM],'e','') AS [BADGE_NUM]
	,[SCHEDULE].[SECTION_ID]
	,COUNT([SCHEDULE].[SIS_NUMBER]) AS [STUDENT_COUNT]
	
FROM
	APS.ScheduleAsOf(GETDATE()) AS [SCHEDULE]
	
	INNER JOIN 
	rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
	ON 
	[SCHEDULE].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
	
	INNER JOIN 
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
	
	-- Get both primary and secodary staff
	INNER JOIN
	(
	SELECT
		[STAFF_SCHOOL_YEAR_GU]
		,[STAFF_GU]
		,[ORGANIZATION_YEAR_GU]
		,1 AS [PRIMARY_STAFF]
	FROM
		rev.[EPC_STAFF_SCH_YR] AS [STAFF_SCHOOL_YEAR]		
	) AS [ALL_STAFF_SCH_YR]
	ON
   [SCHEDULE].[STAFF_SCHOOL_YEAR_GU] = [ALL_STAFF_SCH_YR].[STAFF_SCHOOL_YEAR_GU]
   
	INNER JOIN
	rev.[EPC_STAFF] AS [STAFF]
	ON
	[ALL_STAFF_SCH_YR].[STAFF_GU] = [STAFF].[STAFF_GU]

	INNER JOIN
	rev.[REV_PERSON] AS [STAFF_PERSON]
	ON
	[STAFF].[STAFF_GU] = [STAFF_PERSON].[PERSON_GU]

WHERE
	[SCHEDULE].[COURSE_ID] IN
('311002',
'3110B2',
'312102',
'330300',
'330472',
'330802',
'3304A2',
'3110D2',
'330812',
'330802',
'312002',
'33040DE2',
'330402',
'330403',
'061C12',
'062C12',
'061C52',
'061C42',
'060C42',
'360402',
'36040C',
'36040DE2',
'360352',
'3603B2',
'360802',
'3604B2',
'360403',
'36035DE2',
'36040C2',
'3604A2',
'062D12',
'062C22',
'061C72',
'060C72',
'360802',
'350402',
'350403',
'350802',
'3504A2',
'060C62',
'161C32',
'35040C',
'35040C2',
'35040DE2',
'3504A2',
'3804B2',
'380502',
'380402',
'38040C',
'38040C2',
'38040DE2',
'MATH150',
'3804B2',
'380112',
'060C82',
'061C82',
'062D22',
'700302062C32',
'700302',
'70030DE2',
'411112',
'411312',
'441312',
'4111B2',
'41131C2',
'411212',
'441112',
'41111DE2',
'4112B2',
'4113B2',
'062MH2',
'062MD2',
'061MD2',
'060MD2',
'421112',
'421312',
'441122',
'441322',
'42111DE2',
'4211B2',
'421212',
'4212B2',
'4213B2',
'062MM2',
'061MM2',
'060MM2',
'441352',
'441152',
'15011',
'150152',
'15011C',
'15011CDE',
'1501B',
'060FA',
'15015',
'150162',
'15011C2',
'15011DE',
'062FA',
'061FADE',
'061FA',
'2505I2',
'250542',
'250582',
'250592',
'250512',
'0654GC2',
'0624C2',
'0604C2',
'2055CGLQ',
'25051DE2',
'25051C2',
'25051C',
'215322',
'0654CC2',
'0614C2',
'205382',
'25061DE2',
'215332',
'0624D2',
'0604D2',
'215422',
'220722',
'245412',
'250642',
'22072DE2',
'25061C',
'210392',
'0654GD2',
'0654CD2',
'0614D2',
'220372',
'25064DE2',
'245312',
'250612',
'250652',
'2055DHMR2',
'25061C2',
'610292',
'610292',
'843002',
'84301C2',
'655002',
'65500DE2',
'6551A2',
'843012',
'84201C2',
'661362',
'661C4C2',
'467002',
'4670B2',
'4670D2',
'480B1',
'48016',
'0612ADE',
'0602A',
'480152',
'48010DE',
'480102',
'063TF',
'0622A',
'0612A',
'480142',
'833592',
'83359C2',
'83359C3',
'830012',
'83301DE2',
'53020',
'530202',
'Band',
'7304E2',
'7304F2',
'7304G2',
'7304H2',
'735442',
'7354G2',
'7354H2',
'7354J2',
'740482',
'7404A2',
'7404B2',
'7404C2',
'750002',
'750192',
'71520DE',
'705122',
'1004DE',
'1004B',
'10043',
'062RG',
'061RG',
'060RG',
'900002',
'610102',
'610103',
'61010C2',
'61010DE',
'616AB',
'610302',
'13011',
'13016',
'130162',
'13011C',
'13011CDE',
'13011DE',
'1301B',
'0621A',
'0611ADE',
'0611A',
'0601A',
'13016DE',
'110112',
'110132',
'110202',
'11011DE2',
'11013DE2',
'1101B2',
'1102I2',
'062KC2',
'061KC2',
'060KC2',
'120192',
'120312',
'120132',
'12013DE2',
'1201B2',
'062RD2',
'061RD2',
'060RD2',
'1011DE2')

GROUP BY
	[Organization].[ORGANIZATION_NAME]
	,[SCHEDULE].[DEPARTMENT]
	,[SCHEDULE].[COURSE_ID]
	,[SCHEDULE].[COURSE_TITLE]	
	,[STAFF_PERSON].[LAST_NAME]
	,[STAFF_PERSON].[FIRST_NAME]
	,[STAFF_PERSON].[MIDDLE_NAME]
	,[STAFF].[BADGE_NUM]
	,[SCHEDULE].[SECTION_ID]
