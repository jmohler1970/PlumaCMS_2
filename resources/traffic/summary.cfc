component extends="taffy.core.resource" taffy_uri="/traffic/summary" {



function get(string filterDateTime = "") {

	if(arguments.filterDateTime == "")	{
		arguments.filterDateTime = now();
	}

	var stTopEndpoint = {};

	stTopEndpoint["hour"] = QueryToArray(QueryExecute("
		DECLARE @FilterDate datetime = ?

		SELECT 	top 5 count(IP_Checksum) as hits, Endpoint, Verb
		FROM		dbo.Traffic WITH (NOLOCK)
		WHERE	CreateDate BETWEEN DATEADD(n, 0 - DATEPART(n, @FilterDate),		@FilterDate)
							AND DATEADD(n, 0 - DATEPART(n, @FilterDate) + 60, @FilterDate)
		GROUP BY	Endpoint, Verb
		ORDER BY 	Count(Endpoint) DESC
		",
		[LSDateFormat(arguments.filterDateTime, 'yyyy-mm-dd') & ' ' & LSTimeFormat(arguments.filterDateTime, 'HH:MM:SS')]
		));



	stTopEndpoint["day"] = QueryToArray(QueryExecute("
		DECLARE @FilterDate datetime = :filterDate

		SELECT	top 5 count(IP_Checksum) as hits, Endpoint, Verb
		FROM		dbo.Traffic WITH (NOLOCK)
		WHERE	CreateDate BETWEEN DATEADD(HH, 0 - DATEPART(HH, @FilterDate), @FilterDate) AND DATEADD(HH, 0 - DATEPART(HH, @FilterDate) + 24, @FilterDate)
		GROUP BY	EndPoint, Verb
		ORDER BY	Count(EndPoint) DESC
		",
		{filterDate = {value = arguments.filterDateTime, cfsqltype="cf_sql_timestamp"}}
		));


	stTopEndpoint["month"] = QueryToArray(QueryExecute("
		DECLARE @FilterDate date = :filterDate

		SELECT 	top 5 count(IP_Checksum) as hits, EndPoint, Verb
		FROM		dbo.vwTraffic WITH (NOLOCK)
		WHERE	CreateDate BETWEEN DATEADD(d, 0 - DAY(@FilterDate), @FilterDate) AND DATEADD(d, 0 - DAY(@FilterDate) + 30, @FilterDate)
		GROUP BY EndPoint, Verb
		ORDER BY Hits DESC
		",
		{filterDate = {value = arguments.filterDateTime, cfsqltype="cf_sql_date"}}
		));


	return rep({'data' : stTopEndpoint});
	}


} // end component