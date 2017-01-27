BEGIN TRAN
EXECUTE AS LOGIN='QueryFileUser'
GO


--ORDER BY
--	T1.[sis_NUMBER]


insert into 
	rev.EPC_STU_SCH_YR

--values(
--STUDENT_SCHOOL_YEAR_GU,
--STUDENT_GU,
--ORGANIZATION_YEAR_GU,
--YEAR_GU,
--REPORTED_TO_STATE_NOSHOW,
--REPORTED_TO_STATE_LEAVE,
--OLD_SIS_STUDENT_NUM,
--GRADE,
--GRADE_EXIT_CODE,
--USER_CODE1,
--USER_CODE2,
--USER_CODE3,
--USER_CODE4,
--USER_CODE5,
--USER_CODE6,
--USER_CODE7,
--USER_CODE8,
--USER_CODE9,
--ENTER_DATE,
--ENTER_CODE,
--LEAVE_DATE,
--LEAVE_CODE,
--HOMEROOM_SECTION_GU,
--LAST_HOMEROOM_SECTION_GU,
--INSTRUCTIONAL_SETTING,
--COUNSELOR_SCHOOL_YEAR_GU,
--LOCKER_NUMBER,
--TRACK_GU,
--PROGRAM_CODE,
--EXTEND_LEARNING_PROGRAM,
--SPECIAL_ENROLLMENT_CODE,
--ACCESS_504,
--SPECIAL_PROGRAM_CODE,
--VOCATIONAL,
--IVEP,
--TECH_PREP,
--YEAR_END_STATUS,
--BUS_ROUTE_TO_SCHOOL,
--BUS_ROUTE_FROM_SCHOOL,
--TUTION_PAYER_CODE,
--NEXT_SCHOOL_GU,
--NEXT_GRADE_LEVEL,
--HAS_CHANGED_FLAG,
--STATUS,
--HOMEBOUND,
--DISTRICT_OF_RESIDENCE,
--FTE,
--SUMMER_WITHDRAWL_CODE,
--SUMMER_WITHDRAWL_DATE,
--TITLE_1_PROGRAM,
--TITLE_1_SERVICE,
--TITLE_1_EXIT,
--LAST_ACTIVITY_DATE,
--LAST_SCHOOL_GU,
--EXCLUDE_ADA_ADM,
--ALLOW_TYLENOL,
--ALLOW_MEDICATION,
--ATTEND_PERMIT_CODE,
--ATTEND_PERMIT_DATE,
--SCHOOL_RESIDENCE_GU,
--NEXT_TRACK_GU,
--FORBID_AUTO_DIAL,
--NO_SHOW_STUDENT,
--SCHED_HOUSE,
--SCHED_TEAM,
--SCHED_EXEMPT_HOUSE,
--SCHED_EXEMPT_TEAM,
--SCHED_LOW_PERIOD,
--SCHED_HIGH_PERIOD,
--SCHED_BALANCE,
--SCHED_STAMP,
--WITHDRAWAL_REASON_CODE,
--DENY_PHOTO_INTERVIEW,
--ABS_REPORT_POLICY,
--STATEMENT_OF_AWARENESS,
--REGISTRATION_RECEIVED,
--REGISTRATION_UPDATED,
--CAME_FROM,
--MOVED_TO,
--ENR_USER_1,
--ENR_USER_2,
--ENR_USER_3,
--ENR_USER_DD_4,
--ENR_USER_DD_5,
--ENR_USER_DD_6,
--ENR_USER_NUM_1,
--ENR_USER_NUM_2,
--ENR_USER_NUM_3,
--ENR_USER_NUM_4,
--ENR_USER_NUM_5,
--ENR_USER_CHECK_1,
--ENR_USER_CHECK_2,
--ENR_USER_CHECK_3,
--USER_NUM1,
--USER_NUM2,
--USER_NUM3,
--USER_NUM4,
--USER_NUM5,
--USER_NUM6,
--USER_NUM7,
--USER_NUM8,
--USER_DATE1,
--USER_DATE2,
--USER_DATE3,
--USER_DATE4,
--USER_CHECK1,
--USER_CHECK2,
--USER_CHECK3,
--USER_CHECK4,
--USER_CHECK5,
--USER_CHECK6,
--USER_CHECK7,
--USER_CHECK8,
--TRANSPORTATING_DISTRICT,
--PXP_OCR_LOCKED_IN,
--PXP_OCR_LOCKED_IN_DT,
--PXP_OCR_VALIDATED,
--PXP_OCR_VALIDATED_DT,
--RECEIVER_SCHOOL,
--SPEC_ED_SCH_OF_ATT,
--OVERRIDE_FORCE_STS,
--CAHSEE_ELA_RETAKE,
--CAHSEE_MATH_RETAKE,
--SUMMER_SCHOOL_GU,
--SUMMER_GRADE_LEVEL,
--DISTRICT_SPED_ACCOUNT,
--ENR_USER_DD_1,
--ENR_USER_DD_2,
--ENR_USER_DD_3,
--PICK_UP_TRANSPORT_TYPE,
--PICK_UP_BUS_STOP,
--PICK_UP_TRANSPORT_TIME,
--PICK_UP_COMMENT,
--PICK_UP_LOCATION_TYPE,
--PICK_UP_ADDRESS_GU,
--DROP_OFF_TRANSPORT_TYPE,
--DROP_OFF_BUS_STOP,
--DROP_OFF_TRANSPORT_TIME,
--DROP_OFF_COMMENT,
--DROP_OFF_LOCATION_TYPE,
--DROP_OFF_ADDRESS_GU,
--SPEC_TRANS_REQ_COMMENT,
--TRANSPORT_ELIGIBLE,
--PICK_UP_SCHOOL_GU,
--DROP_OFF_SCHOOL_GU,
--COMPLETION_STATUS,
--PICK_UP_TRANS_REAS_CODE,
--PICK_UP_TRANS_REAS_DATE,
--DROP_OFF_TRANS_REAS_CODE,
--DROP_OFF_TRANS_REAS_DATE,
--CHANGE_DATE_TIME_STAMP,
--CHANGE_ID_STAMP,
--ADD_DATE_TIME_STAMP,
--ADD_ID_STAMP,
--EXP_CODE,
--EXP_TIME_CODE,
--CB_LAST_REQUEST_UPDATE,
--RESPON_DISTRICT,
--RESPON_SCHOOL,
--SERV_DISTRICT,
--SERV_SCHOOL,
--SCHOOL_CHOICE_STATUS,
--FULL_TIME_VIRTUAL,
--LEAVE_UNATTENDED,
--SCH_START_TIME,
--SCH_DISMISS_TIME,
--PICK_UP_RESP_PERSON,
--PICK_UP_RESP_PHONE,
--DROP_OFF_RESP_PERSON,
--DROP_OFF_RESP_PHONE,
--SPCL_PRGM_TCH_SCH_YR_GU,
--TRANSPORT_REQUEST_DATE,
--TRANSPORT_START_DATE,
--ENTERED_BY_USER,
--NEXT_SCH_ATTEND,
--SPED_1ST_SEM_REIMBRSMNT,
--SPED_2ND_SEM_REIMBRSMNT,
--TRUANCY_CONFERENCE,
--SR_USER_CODE_DD_01,
--SR_USER_CODE_DD_02,
--SR_USER_CODE_DD_03,
--SR_USER_CODE_DD_04,
--SR_USER_CODE_DD_05,
--SR_USER_CODE_DD_06,
--SR_USER_CODE_DD_07,
--SR_USER_CODE_DD_08,
--SR_USER_CODE_DD_09,
--SR_USER_CODE_DD_10,
--SR_USER_CODE_DD_11,
--SR_USER_CODE_DD_12,
--SR_USER_CODE_DD_13,
--SR_USER_CODE_DD_14,
--SR_USER_CODE_DD_15,
--SR_USER_CODE_DD_16,
--SR_USER_CODE_DD_17,
--SR_USER_CODE_DD_18,
--SR_USER_CODE_DD_19,
--SR_USER_CODE_DD_20,
--SR_USER_CHECK_01,
--SR_USER_CHECK_02,
--SR_USER_CHECK_03,
--SR_USER_CHECK_04,
--SR_USER_CHECK_05,
--SR_ENR_USER_NUM_01,
--SR_ENR_USER_NUM_02,
--SR_ENR_USER_NUM_03,
--SR_ENR_USER_NUM_04,
--SR_ENR_USER_NUM_05,
--SR_ENR_USER_DD_01,
--SR_ENR_USER_DD_02,
--SR_ENR_USER_DD_03,
--SR_ENR_USER_DD_04,
--SR_ENR_USER_DD_05,
--SR_ENR_USER_DD_06,
--SR_ENR_USER_DD_07,
--SR_ENR_USER_DD_08,
--SR_ENR_USER_DD_09,
--SR_ENR_USER_DD_10,
--SR_ENR_USER_DD_11,
--SR_ENR_USER_DD_12,
--SR_ENR_USER_DD_13,
--SR_ENR_USER_DD_14,
--SR_ENR_USER_DD_15,
--SR_ENR_USER_DD_16,
--SR_ENR_USER_DD_17,
--SR_ENR_USER_DD_18,
--SR_ENR_USER_DD_19,
--SR_ENR_USER_DD_20,
--SR_ENR_USER_CHECK_01,
--SR_ENR_USER_CHECK_02,
--SR_ENR_USER_CHECK_03,
--SR_ENR_USER_CHECK_04,
--SR_ENR_USER_CHECK_05,
--SR_ENR_USER_CHECK_06,
--SR_ENR_USER_CHECK_07,
--SR_ENR_USER_CHECK_08,
--SR_ENR_USER_CHECK_09,
--SR_ENR_USER_CHECK_10,
--OPT_OUT_MEDICAL_STATE,
--OPT_OUT_MEDICAL_FED,
--SCH_COMPL_CODE,
--SPED_REIMBRSMNT_DSBLT_CD,
--SPED_SUM_SEM_REIMBRSMNT,
--SR_ENR_TEXT_1,
--SR_ENR_TEXT_2,
--SR_ENR_TEXT_3,
--SR_ENR_TEXT_4,
--SR_ENR_TEXT_5,
--SR_ENR_TEXT_6,
--SR_ENR_TEXT_7,
--SR_ENR_TEXT_8,
--SR_ENR_TEXT_9,
--SR_ENR_TEXT_10,
--SR_USER_DATE_1,
--SR_USER_DATE_2,
--SR_USER_DATE_3,
--SR_USER_DATE_4,
--SR_USER_DATE_5,
--SR_USER_NUM_1,
--SR_USER_NUM_2,
--SR_USER_NUM_3,
--SR_USER_NUM_4,
--SR_USER_NUM_5,
--SR_USER_TEXT_1,
--SR_USER_TEXT_2,
--SR_USER_TEXT_3,
--SR_USER_TEXT_4,
--SR_USER_TEXT_5,
--SR_USER_TEXT_6,
--SR_USER_TEXT_7,
--SR_USER_TEXT_8,
--SR_USER_TEXT_9,
--SR_USER_TEXT_10,
--MILITARY_COMPACT_STATUTE,
--SUB_SCHOOL,
--COLLEGE_ENROLLED,
--PREVIOUS_LOCATION_TYPE,
--PREVIOUS_YEAR_END_STATUS,
--STU_CTDS_NUMBER,
--REPORTING_SCHOOL,
--COUNTY_RESIDENT,
--PREV_IN_GRADE,
--COUNTY_RESIDENT_NEW,
--NON_RESIDENT,
--CONTINUOUS_STATE,
--CONTINUOUS_SCHOOL,
--CONTINUOUS_DISTRICT,
--STATE_FUNDING_STATUS,
--STU_INSTRUCTIONAL_HOURS,
--SR_ENR_USER_DATE_01,
--SR_ENR_USER_DATE_02,
--SR_ENR_USER_DATE_03,
--SR_ENR_USER_DATE_04,
--SR_ENR_USER_DATE_05,
--PUPIL_ATT_INFO,
--ALLOW_IBUPROFEN,
--INIT_NINTH_GRADE_YEAR,
--ENR_PATHWAY,
--NEXT_ENR_PATHWAY,
--NYR_EXCLUDE,
--BUS_ESTIMATED_MILEAGE,
--COURSE_OF_STUDY,
--DROP_OFF_BUS_NUMBER,
--PICK_UP_BUS_NUMBER,
--STANDARD_DAY_MINUTES,
--EMPLOYED_WHILE_ENROLLED,
--HOME_SCHOOLED,
--MILITARY_CONNECTION,
--PK_FUNDING_SOURCE,
--MANUAL_FTE_OVERRIDE,
--OVERRIDE_CONT_AND_FUNDING,
--SMR_WITHDRAWAL_REASON_CODE,
--SR_USER_CODE_DD_21,
--SR_USER_CODE_DD_22,
--) 

SELECT	

NEWID() AS STUDENT_SCHOOL_YEAR_GU,
T2.STUDENT_GU AS	STUDENT_GU,
'EE2BBE7E-088A-4F67-B13D-0AF2D0847C45' AS	ORGANIZATION_YEAR_GU,
'F7D112F7-354D-4630-A4BC-65F586BA42EC' AS	YEAR_GU,
NULL AS	REPORTED_TO_STATE_NOSHOW,
NULL AS	REPORTED_TO_STATE_LEAVE,
NULL AS	OLD_SIS_STUDENT_NUM,
T2.VALUE_CODE AS	GRADE,
NULL AS	GRADE_EXIT_CODE,
NULL AS	USER_CODE1,
NULL AS	USER_CODE2,
NULL AS	USER_CODE3,
NULL AS	USER_CODE4,
NULL AS	USER_CODE5,
NULL AS	USER_CODE6,
NULL AS	USER_CODE7,
NULL AS	USER_CODE8,
NULL AS	USER_CODE9,
'2016-11-14 00:00:00' AS	ENTER_DATE,
'CONC' AS	ENTER_CODE,
NULL AS	LEAVE_DATE,
NULL AS	LEAVE_CODE,
NULL AS	HOMEROOM_SECTION_GU,
NULL AS	LAST_HOMEROOM_SECTION_GU,
NULL AS	INSTRUCTIONAL_SETTING,
NULL AS	COUNSELOR_SCHOOL_YEAR_GU,
NULL AS	LOCKER_NUMBER,
NULL AS	TRACK_GU,
NULL AS	PROGRAM_CODE,
'N' AS	EXTEND_LEARNING_PROGRAM,
NULL AS	SPECIAL_ENROLLMENT_CODE,
NULL AS	ACCESS_504,
NULL AS	SPECIAL_PROGRAM_CODE,
'N' AS	VOCATIONAL,
NULL AS	IVEP,
NULL AS	TECH_PREP,
NULL AS	YEAR_END_STATUS,
NULL AS	BUS_ROUTE_TO_SCHOOL,
NULL AS	BUS_ROUTE_FROM_SCHOOL,
NULL AS	TUTION_PAYER_CODE,
NULL AS	NEXT_SCHOOL_GU,
NULL AS	NEXT_GRADE_LEVEL,
'N' AS	HAS_CHANGED_FLAG,
NULL AS	STATUS,
'N' AS	HOMEBOUND,
NULL AS	DISTRICT_OF_RESIDENCE,
NULL AS	FTE,
NULL AS	SUMMER_WITHDRAWL_CODE,
NULL AS	SUMMER_WITHDRAWL_DATE,
NULL AS	TITLE_1_PROGRAM,
NULL AS	TITLE_1_SERVICE,
NULL AS	TITLE_1_EXIT,
'2016-11-14 00:00:00' AS	LAST_ACTIVITY_DATE,
NULL AS	LAST_SCHOOL_GU,
'2' AS	EXCLUDE_ADA_ADM,
'N' AS	ALLOW_TYLENOL,
NULL AS	ALLOW_MEDICATION,
NULL AS	ATTEND_PERMIT_CODE,
NULL AS	ATTEND_PERMIT_DATE,
'CFC6326C-D678-4338-AA70-21C5ADC4753E' AS	SCHOOL_RESIDENCE_GU,
NULL AS	NEXT_TRACK_GU,
'N' AS	FORBID_AUTO_DIAL,
'N' AS	NO_SHOW_STUDENT,
NULL AS	SCHED_HOUSE,
NULL AS	SCHED_TEAM,
'N' AS	SCHED_EXEMPT_HOUSE,
'N' AS	SCHED_EXEMPT_TEAM,
NULL AS	SCHED_LOW_PERIOD,
NULL AS	SCHED_HIGH_PERIOD,
NULL AS	SCHED_BALANCE,
NULL AS	SCHED_STAMP,
NULL AS	WITHDRAWAL_REASON_CODE,
NULL AS	DENY_PHOTO_INTERVIEW,
'N' AS	ABS_REPORT_POLICY,
'N' AS	STATEMENT_OF_AWARENESS,
'N' AS	REGISTRATION_RECEIVED,
NULL AS	REGISTRATION_UPDATED,
NULL AS	CAME_FROM,
NULL AS	MOVED_TO,
NULL AS	ENR_USER_1,
NULL AS	ENR_USER_2,
NULL AS	ENR_USER_3,
NULL AS	ENR_USER_DD_4,
NULL AS	ENR_USER_DD_5,
NULL AS	ENR_USER_DD_6,
NULL AS	ENR_USER_NUM_1,
NULL AS	ENR_USER_NUM_2,
NULL AS	ENR_USER_NUM_3,
NULL AS	ENR_USER_NUM_4,
NULL AS	ENR_USER_NUM_5,
'N' AS	ENR_USER_CHECK_1,
'N' AS	ENR_USER_CHECK_2,
'N' AS	ENR_USER_CHECK_3,
NULL AS	USER_NUM1,
NULL AS	USER_NUM2,
NULL AS	USER_NUM3,
NULL AS	USER_NUM4,
NULL AS	USER_NUM5,
NULL AS	USER_NUM6,
NULL AS	USER_NUM7,
NULL AS	USER_NUM8,
NULL AS	USER_DATE1,
NULL AS	USER_DATE2,
NULL AS	USER_DATE3,
NULL AS	USER_DATE4,
'N' AS	USER_CHECK1,
'N' AS	USER_CHECK2,
'N' AS	USER_CHECK3,
'N' AS	USER_CHECK4,
'N' AS	USER_CHECK5,
'N' AS	USER_CHECK6,
'N' AS	USER_CHECK7,
'N' AS	USER_CHECK8,
NULL AS	TRANSPORTATING_DISTRICT,
'N' AS	PXP_OCR_LOCKED_IN,
NULL AS	PXP_OCR_LOCKED_IN_DT,
'N' AS	PXP_OCR_VALIDATED,
NULL AS	PXP_OCR_VALIDATED_DT,
NULL AS	RECEIVER_SCHOOL,
NULL AS	SPEC_ED_SCH_OF_ATT,
'N' AS	OVERRIDE_FORCE_STS,
'N' AS	CAHSEE_ELA_RETAKE,
'N' AS	CAHSEE_MATH_RETAKE,
NULL AS	SUMMER_SCHOOL_GU,
NULL AS	SUMMER_GRADE_LEVEL,
NULL AS	DISTRICT_SPED_ACCOUNT,
NULL AS	ENR_USER_DD_1,
NULL AS	ENR_USER_DD_2,
NULL AS	ENR_USER_DD_3,
NULL AS	PICK_UP_TRANSPORT_TYPE,
NULL AS	PICK_UP_BUS_STOP,
NULL AS	PICK_UP_TRANSPORT_TIME,
NULL AS	PICK_UP_COMMENT,
NULL AS	PICK_UP_LOCATION_TYPE,
NULL AS	PICK_UP_ADDRESS_GU,
NULL AS	DROP_OFF_TRANSPORT_TYPE,
NULL AS	DROP_OFF_BUS_STOP,
NULL AS	DROP_OFF_TRANSPORT_TIME,
NULL AS	DROP_OFF_COMMENT,
NULL AS	DROP_OFF_LOCATION_TYPE,
NULL AS	DROP_OFF_ADDRESS_GU,
NULL AS	SPEC_TRANS_REQ_COMMENT,
NULL AS	TRANSPORT_ELIGIBLE,
NULL AS	PICK_UP_SCHOOL_GU,
NULL AS	DROP_OFF_SCHOOL_GU,
NULL AS	COMPLETION_STATUS,
NULL AS	PICK_UP_TRANS_REAS_CODE,
NULL AS	PICK_UP_TRANS_REAS_DATE,
NULL AS	DROP_OFF_TRANS_REAS_CODE,
NULL AS	DROP_OFF_TRANS_REAS_DATE,
NULL AS	CHANGE_DATE_TIME_STAMP,
NULL AS	CHANGE_ID_STAMP,
'2016-11-14 00:00:00' AS	ADD_DATE_TIME_STAMP,
'71ADF389-3618-4650-9088-48D11EA84CA2' AS	ADD_ID_STAMP,
NULL AS	EXP_CODE,
NULL AS	EXP_TIME_CODE,
NULL AS	CB_LAST_REQUEST_UPDATE,
NULL AS	RESPON_DISTRICT,
NULL AS	RESPON_SCHOOL,
NULL AS	SERV_DISTRICT,
NULL AS	SERV_SCHOOL,
NULL AS	SCHOOL_CHOICE_STATUS,
NULL AS	FULL_TIME_VIRTUAL,
'N' AS	LEAVE_UNATTENDED,
NULL AS	SCH_START_TIME,
NULL AS	SCH_DISMISS_TIME,
NULL AS	PICK_UP_RESP_PERSON,
NULL AS	PICK_UP_RESP_PHONE,
NULL AS	DROP_OFF_RESP_PERSON,
NULL AS	DROP_OFF_RESP_PHONE,
NULL AS	SPCL_PRGM_TCH_SCH_YR_GU,
NULL AS	TRANSPORT_REQUEST_DATE,
NULL AS	TRANSPORT_START_DATE,
NULL AS	ENTERED_BY_USER,
NULL AS	NEXT_SCH_ATTEND,
NULL AS	SPED_1ST_SEM_REIMBRSMNT,
NULL AS	SPED_2ND_SEM_REIMBRSMNT,
'N' AS	TRUANCY_CONFERENCE,
NULL AS	SR_USER_CODE_DD_01,
NULL AS	SR_USER_CODE_DD_02,
NULL AS	SR_USER_CODE_DD_03,
NULL AS	SR_USER_CODE_DD_04,
NULL AS	SR_USER_CODE_DD_05,
NULL AS	SR_USER_CODE_DD_06,
NULL AS	SR_USER_CODE_DD_07,
NULL AS	SR_USER_CODE_DD_08,
NULL AS	SR_USER_CODE_DD_09,
NULL AS	SR_USER_CODE_DD_10,
NULL AS	SR_USER_CODE_DD_11,
NULL AS	SR_USER_CODE_DD_12,
NULL AS	SR_USER_CODE_DD_13,
NULL AS	SR_USER_CODE_DD_14,
NULL AS	SR_USER_CODE_DD_15,
NULL AS	SR_USER_CODE_DD_16,
NULL AS	SR_USER_CODE_DD_17,
NULL AS	SR_USER_CODE_DD_18,
NULL AS	SR_USER_CODE_DD_19,
NULL AS	SR_USER_CODE_DD_20,
'N' AS	SR_USER_CHECK_01,
'N' AS	SR_USER_CHECK_02,
'N' AS	SR_USER_CHECK_03,
'N' AS	SR_USER_CHECK_04,
'N' AS	SR_USER_CHECK_05,
NULL AS	SR_ENR_USER_NUM_01,
NULL AS	SR_ENR_USER_NUM_02,
NULL AS	SR_ENR_USER_NUM_03,
NULL AS	SR_ENR_USER_NUM_04,
NULL AS	SR_ENR_USER_NUM_05,
NULL AS	SR_ENR_USER_DD_01,
NULL AS	SR_ENR_USER_DD_02,
NULL AS	SR_ENR_USER_DD_03,
NULL AS	SR_ENR_USER_DD_04,
NULL AS	SR_ENR_USER_DD_05,
NULL AS	SR_ENR_USER_DD_06,
NULL AS	SR_ENR_USER_DD_07,
NULL AS	SR_ENR_USER_DD_08,
NULL AS	SR_ENR_USER_DD_09,
NULL AS	SR_ENR_USER_DD_10,
NULL AS	SR_ENR_USER_DD_11,
NULL AS	SR_ENR_USER_DD_12,
NULL AS	SR_ENR_USER_DD_13,
NULL AS	SR_ENR_USER_DD_14,
NULL AS	SR_ENR_USER_DD_15,
NULL AS	SR_ENR_USER_DD_16,
NULL AS	SR_ENR_USER_DD_17,
NULL AS	SR_ENR_USER_DD_18,
NULL AS	SR_ENR_USER_DD_19,
NULL AS	SR_ENR_USER_DD_20,
'N' AS	SR_ENR_USER_CHECK_01,
'N' AS	SR_ENR_USER_CHECK_02,
'N' AS	SR_ENR_USER_CHECK_03,
'N' AS	SR_ENR_USER_CHECK_04,
'N' AS	SR_ENR_USER_CHECK_05,
'N' AS	SR_ENR_USER_CHECK_06,
'N' AS	SR_ENR_USER_CHECK_07,
'N' AS	SR_ENR_USER_CHECK_08,
'N' AS	SR_ENR_USER_CHECK_09,
'N' AS	SR_ENR_USER_CHECK_10,
NULL AS	OPT_OUT_MEDICAL_STATE,
NULL AS	OPT_OUT_MEDICAL_FED,
NULL AS	SCH_COMPL_CODE,
NULL AS	SPED_REIMBRSMNT_DSBLT_CD,
NULL AS	SPED_SUM_SEM_REIMBRSMNT,
NULL AS	SR_ENR_TEXT_1,
NULL AS	SR_ENR_TEXT_2,
NULL AS	SR_ENR_TEXT_3,
NULL AS	SR_ENR_TEXT_4,
NULL AS	SR_ENR_TEXT_5,
NULL AS	SR_ENR_TEXT_6,
NULL AS	SR_ENR_TEXT_7,
NULL AS	SR_ENR_TEXT_8,
NULL AS	SR_ENR_TEXT_9,
NULL AS	SR_ENR_TEXT_10,
NULL AS	SR_USER_DATE_1,
NULL AS	SR_USER_DATE_2,
NULL AS	SR_USER_DATE_3,
NULL AS	SR_USER_DATE_4,
NULL AS	SR_USER_DATE_5,
NULL AS	SR_USER_NUM_1,
NULL AS	SR_USER_NUM_2,
NULL AS	SR_USER_NUM_3,
NULL AS	SR_USER_NUM_4,
NULL AS	SR_USER_NUM_5,
NULL AS	SR_USER_TEXT_1,
NULL AS	SR_USER_TEXT_2,
NULL AS	SR_USER_TEXT_3,
NULL AS	SR_USER_TEXT_4,
NULL AS	SR_USER_TEXT_5,
NULL AS	SR_USER_TEXT_6,
NULL AS	SR_USER_TEXT_7,
NULL AS	SR_USER_TEXT_8,
NULL AS	SR_USER_TEXT_9,
NULL AS	SR_USER_TEXT_10,
'N' AS	MILITARY_COMPACT_STATUTE,
NULL AS	SUB_SCHOOL,
'N' AS	COLLEGE_ENROLLED,
NULL AS	PREVIOUS_LOCATION_TYPE,
'P' AS	PREVIOUS_YEAR_END_STATUS,
NULL AS	STU_CTDS_NUMBER,
NULL AS	REPORTING_SCHOOL,
'N' AS	COUNTY_RESIDENT,
'N' AS	PREV_IN_GRADE,
'Y' AS	COUNTY_RESIDENT_NEW,
'N' AS	NON_RESIDENT,
NULL AS	CONTINUOUS_STATE,
NULL AS	CONTINUOUS_SCHOOL,
NULL AS	CONTINUOUS_DISTRICT,
NULL AS	STATE_FUNDING_STATUS,
NULL AS	STU_INSTRUCTIONAL_HOURS,
NULL AS	SR_ENR_USER_DATE_01,
NULL AS	SR_ENR_USER_DATE_02,
NULL AS	SR_ENR_USER_DATE_03,
NULL AS	SR_ENR_USER_DATE_04,
NULL AS	SR_ENR_USER_DATE_05,
NULL AS	PUPIL_ATT_INFO,
'N' AS	ALLOW_IBUPROFEN,
NULL AS	INIT_NINTH_GRADE_YEAR,
NULL AS	ENR_PATHWAY,
NULL AS	NEXT_ENR_PATHWAY,
'N' AS	NYR_EXCLUDE,
NULL AS	BUS_ESTIMATED_MILEAGE,
NULL AS	COURSE_OF_STUDY,
NULL AS	DROP_OFF_BUS_NUMBER,
NULL AS	PICK_UP_BUS_NUMBER,
NULL AS	STANDARD_DAY_MINUTES,
'N' AS	EMPLOYED_WHILE_ENROLLED,
'N' AS	HOME_SCHOOLED,
NULL AS	MILITARY_CONNECTION,
NULL AS	PK_FUNDING_SOURCE,
'N' AS	MANUAL_FTE_OVERRIDE,
'N' AS	OVERRIDE_CONT_AND_FUNDING,
NULL AS	SMR_WITHDRAWAL_REASON_CODE,
NULL AS	SR_USER_CODE_DD_21,
NULL AS	SR_USER_CODE_DD_22


FROM
(

Select STU.STUDENT_GU, t1.*, LU.VALUE_CODE


FROM
	OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from CSISTUDENT.csv'
                ) AS [T1]

INNER JOIN REV.EPC_STU AS STU

ON
	T1.[SIS_NUMBER] = STU.SIS_NUMBER 

INNER JOIN
	APS.LookupTable('K12' , 'GRADE') as LU
ON
	LU.VALUE_DESCRIPTION = T1.GRADE
)
AS T2

COMMIT


	