component extends="taffy.core.resource" taffy_uri="/traffic/filters" {


function get() {

	var qResult = QueryExecute("
		SELECT DISTINCT EndPoint 
		FROM dbo.vwTraffic WITH (NOLOCK)
		WHERE CreateDate > DateAdd(mm, -3, getDate()) 
		ORDER BY EndPoint
		",
		[], 
		{cachedwithin = createtimespan(0,1,0,0)}
	);

	return rep(valueArray(qResult, "Endpoint"));

}

} // end component