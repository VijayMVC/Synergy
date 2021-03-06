/**
 * $Revision: 227 $
 * $LastChangedBy: e201594 $
 * $LastChangedDate: 2014-10-13 10:09:18 -0600 (Mon, 13 Oct 2014) $
 *
 * This query can help locate table/field from business object/property or vice/versa.
 * Out of the box, you must change what/how you are looking for.  As such, it may not be
 * a panacea for tracking down certian things (especially if you are looking for the
 * lookup that is associated with it) but it may be a good start.
 */
SELECT
	SynObject.NAMESPACE
	,SynObject.NAME AS ObjectName
	,Prop.PROPERTY_NAME
	,Prop.TYPE
	,Prop.LOOKUP_TYPE
	,LookupDef.LOOKUP_NAMESPACE 
	,LookupDef.LOOKUP_DEF_CODE
	,Prop.LABEL
	,Bind.TABLE_NAME
	,Bind.COLUMN_NAME
FROM
	rev.REV_BOD_OBJECT AS SynObject
	INNER JOIN
	rev.REV_BOD_OBJECT_PROP As Prop
	ON
	SynObject.BOD_OBJECT_GU = Prop.BOD_OBJECT_GU
	
	INNER JOIN
	rev.REV_BOD_OBJECT_PROP_BIND AS Bind
	ON
	Prop.BOD_OBJECT_PROP_GU = Bind.BOD_OBJECT_PROP_GU
	
	LEFT JOIN
	rev.REV_BOD_LOOKUP_DEF AS LookupDef
	ON
	Prop.SRC_LOOKUP = LookupDef.LOOKUP_DEF_GU
WHERE
	--SynObject.NAME LIKE '%SpedStudent%'
	Prop.PROPERTY_NAME LIKE '%LevelIntegration%'
	-- TABLE_NAME LIKE '%CFG%'
	--LABEL LIKE '%Enabled%'