component extends="taffy.core.resource" taffy_uri="/traffic/details" {


function get() {

	return rep({
		"thisHour" 	: getHour(now(), ''),
		"thisDay" 	: getDay(now(), ''),
		"thisMonth" 	: getMonth(now(), '')
	});
}

private array function getDay(required date filterDate, required string filterEndpoint) hint="Data broken down by hour of the day" {

	return QueryToArray(QueryExecute("

		SELECT	x_axis, SUM(p_axis) AS p_axis, SUM(y_axis) AS y_axis
		FROM	(
			SELECT	datepart(hour, Createdate) as x_axis, 0 AS p_axis, count(CreateDate) as y_axis
			FROM 	dbo.Traffic WITH (NOLOCK)
			WHERE	CONVERT(date, CreateDate) = :filterDate
			AND		(endpoint	= :endpoint	OR :endpoint = '')
			GROUP BY	datepart(hour, Createdate)

			UNION ALL

			SELECT	datepart(hour, Createdate) as x_axis, count(CreateDate) AS p_axis, 0 as y_axis
			FROM 	dbo.Traffic WITH (NOLOCK)
			WHERE	DATEADD(d, 1, CONVERT(date, CreateDate)) = :filterDate
			AND		(endpoint	= :endpoint	OR :endpoint = '')
			GROUP BY	datepart(hour, Createdate)
			) A
		GROUP BY x_axis
		ORDER BY x_axis
		",
		{
			"filterDate" 		: { value : arguments.filterdate, cfsqltype : "CF_SQL_date"},
			"filterEndpoint" 	: { value : arguments.endpoint, cfsqltype : "CF_SQL_varchar"}
		}
	));
}	


private array function getMonth(required date filterDate, required string filterEndpoint) hint="Data broken down by day of the month" {


	return QueryToArray(QueryExecute("
		DECLARE @lastMonth date = DateAdd(mo, -1, :filterDate)

		SELECT	x_axis, SUM(p_axis) AS p_axis, SUM(y_axis) AS y_axis
		FROM	(
			SELECT	DAY(CreateDate) as x_axis, 0 AS p_axis, count(1) as y_axis
			FROM 	dbo.vwTraffic WITH (NOLOCK)
			WHERE	year(CreateDate) = YEAR(:filterDate)
			AND		month(CreateDate) = MONTH(:filterDate)
			AND		(endpoint	= :endpoint	OR :endpoint = '')
			GROUP BY DAY(CreateDate)

			UNION ALL

			SELECT	DAY(DateAdd(mm, 1, CreateDate)) as x_axis, count(1) AS p_axis, 0 as y_axis
			FROM 	dbo.vwTraffic WITH (NOLOCK)
			WHERE	year(CreateDate) = YEAR(@lastMonth)
			AND		month(CreateDate) = MONTH(@lastMonth)
			AND		(endpoint	= :endpoint	OR :endpoint = '')
			GROUP BY DAY(DateAdd(mm, 1, CreateDate))
			) A
		GROUP BY x_axis
		ORDER BY x_axis
		",
		{
			"filterDate" 		: { value : arguments.filterdate, cfsqltype : "CF_SQL_date"},
			"filterEndpoint" 	: { value : arguments.endpoint, cfsqltype : "CF_SQL_varchar"}
		}
	));
}



private query function getYear(required date filterDate, required string filterEndpoint) hint="Data broken down by month of the year" {


	return QueryToArray(QueryExecute("
		SELECT	x_axis, SUM(p_axis) AS p_axis, SUM(y_axis) AS y_axis
		FROM	(
			SELECT	MONTH(CreateDate) as x_axis, 0 AS p_axis, count(1) as y_axis
			FROM 	dbo.vwTraffic WITH (NOLOCK)
			WHERE	YEAR(CreateDate) = YEAR(:filterDate)
			AND		(endpoint	= :endpoint	OR :endpoint = '')
			GROUP BY MONTH(CreateDate)

			UNION ALL

			SELECT	MONTH(DateAdd(yy, 1, CreateDate)) as x_axis, count(1) AS p_axis, 0 as y_axis
			FROM 	dbo.vwTraffic WITH (NOLOCK)
			WHERE	YEAR(CreateDate) = YEAR(:filterDate) - 1
			AND		(endpoint	= :endpoint	OR :endpoint = '')
			GROUP BY MONTH(DateAdd(yy, 1, CreateDate))
			) A
		GROUP BY x_axis
		ORDER BY x_axis
		",
		{
			"filterDate" 		: { value : arguments.filterdate, cfsqltype : "CF_SQL_date"},
			"filterEndpoint" 	: { value : arguments.endpoint, cfsqltype : "CF_SQL_varchar"}
		}
	));
}



} // end component
