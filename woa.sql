copy (
	select
		aphia.classification->>'speciesid' as speciesid,
		aphia.classification->>'subphylumid' as subphylumid,
		areas.id as areaid,
		case
			when bathymetry < 200 then '<200'
			when bathymetry < 1000 then '200-1000'
			when bathymetry >= 1000 then '>1000'
		end as depth
	from obis.occurrence
	left join obis.aphia on aphia.id = occurrence.aphia
	left join obis.areas on areas.id = any(occurrence.areas)
	where
		dropped is not true
		and absence is not true
		and areas.type = 'iho'
		and aphia.classification ? 'speciesid'
) to stdout with csv header delimiter ',';