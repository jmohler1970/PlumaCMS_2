component extends="taffy.core.resource" taffy_uri="/traffic/top" {


function get(string datetype = "year", string filterdate = "", string filterEndpoint = "" ) {

	if (!isDate(arguments.filterdate) || argumens.filterdate == "")	{
		arguments.filterdate = now();
	}

	switch (arguments.datetype)	{
		case "day" :
			return rep(QueryToArray(getTopByDay(arguments.filterdate, arguments.filterEndpoint)));
			break;

		case "month" :
			return rep(QueryToArray(getTopByMonth(arguments.filterdate, arguments.filterEndpoint)));
			break;
		}

	return rep(QueryToArray(getTopByYear(arguments.filterdate, arguments.filterEndpoint)));
}


private query function getTopByDay(required date filterdate, required string filterEndpoint) {


	return QueryExecute("
		DECLARE @totalhits int = (
			SELECT	SUM(ID_Count)
			FROM		dbo.vwTraffic WITH (NOLOCK)
			WHERE	CreateDate = CONVERT(date, :myDate)
			)

		SELECT TOP 20 	endpoint, verb,
			SUM(ID_Count)	AS hits,
			@totalhits	AS totalhits

		FROM 	dbo.vwTraffic WITH (NOLOCK)
		WHERE	CreateDate = CONVERT(date, :myDate)
		AND		(endpoint	= :endpoint	OR :endpoint = '')
		GROUP BY	Endpoint, Verb
		order by hits desc
		",
		{ 
			myDate : {value : arguments.filterdate, CFSQLType="CF_SQL_Date" }, 
			endPoint : arguments.endpoint
		}
		);

	}


private query function getTopByMonth(required date filterdate, required string endpoint) {


	return QueryExecute("
		DECLARE @totalhits int = (
			SELECT	SUM(ID_Count)
			FROM		dbo.vwTraffic WITH (NOLOCK)
			WHERE	YEAR(CreateDate) = YEAR(:myDate)
			AND		MONTH(CreateDate) = MONTH(:myDate)
			)

		SELECT TOP 20	endpoint, verb,
			SUM(ID_Count)	AS hits,
			@totalhits	AS totalhits

		FROM 	dbo.vwTraffic WITH (NOLOCK)
		WHERE	year(CreateDate) = YEAR(:myDate)
		AND		month(CreateDate) = MONTH(:myDate)
		AND		(endpoint	= :endpoint	OR :endpoint = '')
		group by	EndPoint, Verb
		order by hits desc
		",
		{ 
			myDate : {value : arguments.filterdate, CFSQLType="CF_SQL_Date" }, 
			endPoint : arguments.endpoint
		}
		);

	}

private query function getTopByYear(required date filterdate, required string endpoint) {

	return QueryExecute("
		DECLARE @totalhits int = (
			SELECT 	SUM(ID_Count)
			FROM		dbo.vwTraffic WITH (NOLOCK)
			WHERE	YEAR(CreateDate) = YEAR(:myDate)
			)


		SELECT TOP 20 	endpoint, verb,
			SUM(ID_Count)	AS hits,
			@totalhits	AS totalhits

		FROM 	dbo.vwTraffic WITH (NOLOCK)
		WHERE	YEAR(CreateDate) = YEAR(:myDate)
		AND		(endpoint	= :endpoint	OR :endpoint = '')
		group by	EndPoint, Verb
		order by hits desc
		",
		{ 
			myDate : {value : arguments.filterdate, CFSQLType="CF_SQL_Date" }, 
			endPoint : arguments.endpoint
		}
		);

	}


} // end component