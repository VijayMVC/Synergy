USE
Assessments
GO

BEGIN TRAN


SELECT
	[DISTRICT CODE] AS DISTNO
	,[LOCATION CODE] AS SCHNUMB
	,'Rose-Ann McKernan' AS DEP
	,'MCKERNAN@aps.edu' AS DEPMAIL
	,student_id AS STID
	,[STUDENT ID] AS STID_2
	,[FIRST NAME LONG] AS FNAME
	,[LAST NAME LONG] AS LNAME
	,[MIDDLE INITIAL] AS MI
	,'' AS TID
	,'' AS TFNAME
	,'' AS TLNAME
	--,CASE	
	--	WHEN ASSESSMENT_ID = '8011' THEN 'World History and Geography 9 12 V001'
	--	WHEN assessment_id = '8013' THEN 'English Language Arts III Reading 11 11 V002'
	--	WHEN assessment_id = '8014' THEN 'English Language Arts III Writing 11 11 V002'
	--	WHEN assessment_id = '8015' THEN 'English Language Arts IV Reading 12 12 V001'
	--	WHEN assessment_id = '8016' THEN 'English Language Arts IV Writing 12 12 V001'
	--	WHEN assessment_id = '8017' THEN 'US History 9 12 V002'
	--	WHEN assessment_id = '8018' THEN 'Health Education 6 12 V001'
	--	WHEN assessment_id = '8019' THEN 'Social Studies 6 6 V001'
	--	WHEN assessment_id = '8021' THEN 'Algebra II 10 12 V002'
	--	WHEN assessment_id = '8025' THEN 'Spanish I 7 12 V001'
	--	WHEN assessment_id = '8026' THEN 'Biology 9 12 V003'
	--	WHEN assessment_id = '8028' THEN 'Spanish Language Arts III Reading 11 11 V001'
	--	WHEN assessment_id = '8036' THEN 'Chemistry 9 12 V003'
	--	WHEN assessment_id = '8067' THEN 'INTEGRATED GENERAL SCIENCE 6 8 V001'
	--	WHEN assessment_id = '8074' THEN 'Spanish Language Arts III Writing 11 11 V001'
	--	WHEN assessment_id = '8077' THEN 'Physical Education 9 12 V001'
	--	WHEN assessment_id = '8078' THEN 'Introduction to Art 9 12 V001'
	--	WHEN assessment_id = '8082' THEN 'Introduction to Art 6 8 V001'
	--	WHEN assessment_id = '8083' THEN 'Introduction to Art 4 5 V001'
	--	WHEN assessment_id = '8084' THEN 'Physical Education 4 5 V001'
	--	WHEN assessment_id = '8085' THEN 'Physical Education 6 8 V001'
	--	WHEN assessment_id = '8086' THEN 'Music 4 5 V001'
	--	WHEN assessment_id = '8111' THEN 'Music 9 12 V001'
	--END AS [TEST]
	,STARS_name AS TEST
	,'' AS VNO
	,'' AS NOITEMS
	,'' AS COURSEID
	,'20150401' AS TESTDATE
	,'Y' AS ITEMDATA
	,[1] AS Q1
	,[2] AS Q2
	,[3] AS Q3
	,[4] AS Q4
	,[5] AS Q5
	,[6] AS Q6
	,[7] AS Q7
	,[8] AS Q8
	,[9] AS Q9
	,[10] AS Q10
	,[11] AS Q11
	,[12] AS Q12
	,[13] AS Q13
	,[14] AS Q14
	,[15] AS Q15
	,[16] AS Q16
	,[17] AS Q17
	,[18] AS Q18
	,[19] AS Q19
	,[20] AS Q20
	,[21] AS Q21
	,[22] AS Q22
	,[23] AS Q23
	,[24] AS Q24
	,[25] AS Q25
	,[26] AS Q26
	,[27] AS Q27
	,[28] AS Q28
	,[29] AS Q29
	,[30] AS Q30
	,[31] AS Q31
	,[32] AS Q32
	,[33] AS Q33
	,[34] AS Q34
	,[35] AS Q35
	,[36] AS Q36
	,[37] AS Q37
	,[38] AS Q38
	,[39] AS Q39
	,[40] AS Q40
	,[41] AS Q41
	,[42] AS Q42
	,[43] AS Q43
	,[44] AS Q44
	,[45] AS Q45
	,[46] AS Q46
	,[47] AS Q47
	,[48] AS Q48
	,[49] AS Q49
	,[50] AS Q50
	,[51] AS Q51
	,[53] AS Q52
	,[53] AS Q53
	,[54] AS Q54
	,[55] AS Q55
	,[56] AS Q56
	,[57] AS Q57
	,[58] AS Q58
	,[59] AS Q59
	,[60] AS Q60
	,[61] AS Q61
	,[62] AS Q62
FROM
(	
SELECT  
	   EOC.[assessment_id]
      ,EOC.[assessment_name]
      ,[student_id]
      ,[student_name]
      ,[answer]
      ,question_number
      ,STUD.[MIDDLE INITIAL]
      ,STUD.[DISTRICT CODE]
      ,STUD.[LOCATION CODE]
      ,STUD.[FIRST NAME LONG]
      ,STUD.[LAST NAME LONG]
	  ,STUD.[STUDENT ID]
		
	  ,CS.STARS_name
      --,question_number as qn
      --,question_number
  FROM [EOC_exam_data] AS EOC
  LEFT JOIN
  [046-WS02].[db_STARS_History].dbo.STUDENT AS STUD
  ON EOC.student_id = STUD.[ALTERNATE STUDENT ID]
  AND STUD.SY = '2015'
  AND STUD.Period = '2015-06-01'

  LEFT JOIN
  Eoc_Cut_Scores AS CS
  ON
  CS.assessment_id = EOC.assessment_id
  
  
)AS T1
PIVOT (MAX(answer) for question_number IN ([1], [2], [3], [4], [5], [6], [7], [8], [9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52],[53],[54],[55],[56],[57],[58],[59],[60],[61],[62])) piv

WHERE assessment_ID IN ('8660','8653','8669','8668','8213','8657','8670','8663','8214','8676','8666','8673','8675','8677','8215','8678','8189','8680','8681','8192','8191','8652')
--AND [STUDENT ID] = '100011964'
--ORDER BY STID
ROLLBACK