SELECT  
    STUDENT_ID AS SIS_NUMBER
 --   ,DTBL_STUDENTS.STUDENT_GRADUATION_COHORT
 --   ,TEST_NAME
 --   ,TEST_EXTERNAL_CODE AS TEST_WINDOW
 --   ,DTBL_SCHOOLS.SCHOOL_CODE
 --   ,TEST_STUDENT_GRADE
 --   ,YEAR_VALUE AS YEAR
 --   ,TEST_PRODUCT 
 --   ,TEST_SUBJECT AS CONTENT_AREA
 --   ,DTBL_CALENDAR_DATES.DATE_VALUE AS TEST_DATE
 --   ,TEST_SCORE_VALUE AS SCORE
 --   ,TEST_PRIMARY_RESULT AS PERFORMANCE_LEVEL
 --   ,TEST_NAME
	,SIS_SCHOOL_YEAR
 --   ,TEST_CLASS
 --   ,TEST_GROUP
 --   ,TEST_SUBGROUP
    TEST_ADMIN_PERIOD
FROM K12INTEL_DW.FTBL_TEST_SCORES
INNER JOIN K12INTEL_DW.DTBL_TESTS
ON DTBL_TESTS.TESTS_KEY = FTBL_TEST_SCORES.TESTS_KEY 
INNER JOIN K12INTEL_DW.DTBL_STUDENTS 
ON DTBL_STUDENTS.STUDENT_KEY = FTBL_TEST_SCORES.STUDENT_KEY 
INNER JOIN K12INTEL_DW.DTBL_SCHOOLS
ON DTBL_SCHOOLS.SCHOOL_KEY = FTBL_TEST_SCORES.SCHOOL_KEY
INNER JOIN K12INTEL_DW.DTBL_CALENDAR_DATES
ON DTBL_CALENDAR_DATES.CALENDAR_DATE_KEY= FTBL_TEST_SCORES.CALENDAR_DATE_KEY
INNER JOIN K12INTEL_DW.DTBL_SCHOOL_DATES
ON DTBL_SCHOOL_DATES.SCHOOL_DATES_KEY = FTBL_TEST_SCORES.SCHOOL_DATES_KEY 
WHERE TEST_PRODUCT = 'DIBELS Next'
AND TEST_SUBGROUP IN ('TOT','Composite')
AND SIS_SCHOOL_YEAR = '2014'
AND TEST_ADMIN_PERIOD = 'MOY'

--WHERE TEST_NAME LIKE 'SS%'
--WHERE TEST_PRODUCT = 'PARCC'
--AND TEST_SUBGROUP IN ('TOT','Composite')
--AND LOCAL_SCHOOL_YEAR = '2015-2016'
--AND TEST_EXTERNAL_CODE = 'BEG'
--AND STUDENT_ID = '980002497'
--and TEST_CLASS = 'COMPONENT'
--AND TEST_GROUP = 'ela'
--and TEST_SUBGROUP = 'OVERALL'

--eoy END
--moy MID
--use score

--test product = PARCC TEST GROUP = ELA (NO MATH)  TEST PRODUCT = PARCC TEST CLASS = COMPONENT
--3 DIGIT SCOFRES
--******SIS SCHOOL YEAR 14 IS 14-15******
--SCHOOL YEAR IS ACTUAL YEAR THEY TESTED IN - DON'T USE

--2016-2017 NOT DOING DIEBELS DOING STEPPING STONE REPLACEMENT
--USE SIS SCHOOL YEAR
--STRAND AND COMPONENTS - STRAND IS PASS/FAIL 
--for parcc include test subgroup of overall
--COMPONENTS (OVERALL SCORE)
--STRAND IS SUBCATEGORY OF E.G. MATHEMATICS (GEOMETRY, ALGEBRA) IN ELA - READING WRITE COMPREHENSION
--ELA IS ENGLISH LANGUAGE ARTS

--USE STEPPING STONE FOR 2016-2017 TEST_PRODCT = STEPPING STONES SCORE/PERFORMANCE LEVEL test_name like 'ss%'
