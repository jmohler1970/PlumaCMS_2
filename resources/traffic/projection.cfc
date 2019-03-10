component extends="taffy.core.resource" taffy_uri="/traffic/projection" {


function get() {

	return rep({
		"thisHour" 	: getThisHour(now()),
		"thisDay" 	: getThisDay(now()),
		"thisMonth" 	: getThisMonth(now())
	});
}


private struct function getThisHour(required string filterDateTime) 	{

	var stResult = {"hitCount" : 0, "userCount" : 0};

	stResult.append(QueryGetRow(QueryExecute("
		DECLARE @FilterDateTime datetime = ?

		SELECT 	COUNT(IP_Checksum) AS hitCount, COUNT(DISTINCT IP_Checksum) AS userCount
		FROM		dbo.Traffic WITH (NOLOCK)
		WHERE	CreateDate BETWEEN DATEADD(n, 0 - DATEPART(n, @FilterDateTime), 		@FilterDateTime)
							AND DATEADD(n, 0 - DATEPART(n, @FilterDateTime) + 60, 	@FilterDateTime)
		",
		[LSDateFormat(arguments.filterDateTime, 'yyyy-mm-dd') & ' ' & LSTimeFormat(arguments.filterDateTime, 'HH:MM:SS')]
		), 1));

	stResult.append(getProjection(stResult, arguments.filterDateTime));

	return stResult;
	}


private struct function getThisDay(required string filterDateTime) 	{

	var stResult = {"hitCount" : 0, "userCount" : 0};

	stResult.append(QueryGetRow(QueryExecute("
		DECLARE @FilterDate date = :filterDate

		SELECT 	COUNT( IP_Checksum) AS hitCount, COUNT(DISTINCT IP_Checksum) AS userCount
		FROM		dbo.vwTraffic WITH (NOLOCK)
		WHERE	CreateDate = :filterDate
		",
		{filterDate = {value = arguments.filterDateTime, cfsqltype="cf_sql_date"}}
		), 1));

	stResult.append(getProjection(stResult, arguments.filterDateTime));

	return stResult;
	}


private struct function getThisMonth(required string filterDateTime) 	{

	var stResult = {"hitCount" : 0, "userCount" : 0};

	stResult.append(QueryGetRow(QueryExecute("
		SELECT 	COUNT( IP_Checksum) AS hitCount, COUNT(DISTINCT IP_Checksum) AS userCount
		FROM		dbo.vwTraffic WITH (NOLOCK)
		WHERE	CreateDate BETWEEN DATEFROMPARTS(YEAR(:filterDate), MONTH(:filterDate), 1) AND EOMONTH(:FilterDate)
		",
		{filterDate : {value : arguments.filterDateTime, cfsqltype : "cf_sql_date"}}
		), 1));

	stResult.append(getProjection(stResult, arguments.filterDateTime));

	return stResult;
	}



private struct function getProjection(required struct HitData, required string filterDateTime)  {

	var stResult = {"projectionHitCount" : 0, "projectionUserCount" : 0};

	if (dayofyear(arguments.FilterDateTime) < dayofyear(now())) {
		stResult.projectionHitCount =  arguments.HitsData.hitCount;
		stResult.projectionUserCount =  arguments.HitData.userCount;
		}
	else if (val(minute(arguments.FilterDateTime))) {
		stResult.projectionHitCount = round(60 / minute(arguments.FilterDateTime) * arguments.HitData.hitCount);
		stResult.projectionUserCount = round(60 / minute(arguments.FilterDateTime) * arguments.HitData.userCount);
		}

	return stResult;
	}



} // end component

