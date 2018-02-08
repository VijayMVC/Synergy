select * from rev.EPC_TEST AS TEST
where TEST_GU = '080D965E-1FE4-4460-8F57-C19547515C7A'

select * from rev.EPC_TEST_PART
where TEST_GU = '080D965E-1FE4-4460-8F57-C19547515C7A'

select * from [EPC_GRAD_REQ_DEF_TST_GRPYT] AS MINS
where TEST_GU = '080D965E-1FE4-4460-8F57-C19547515C7A'

select DISTINCT TEST_NAME, PART.PART_DESCRIPTION, TEST_REQ_MIN_SCORE, MINS.TEST_GU, PART.TEST_GU, MINS.TEST_GU, PART.TEST_PART_GU from
rev.EPC_TEST AS TEST
JOIN
EPC_GRAD_REQ_DEF_TST_GRPYT AS MINS
ON 
TEST.TEST_GU = MINS.TEST_GU
JOIN
REV.EPC_TEST_PART AS PART
ON PART.TEST_PART_GU = MINS.TEST_PART_GU
WHERE TEST_REQ_MIN_SCORE IS NOT NULL
ORDER BY TEST_NAME,PART_DESCRIPTION