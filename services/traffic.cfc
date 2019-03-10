component {

void function add(required string endpoint, required string verb) output="false"	{

	queryExecute("
		DECLARE @offset smallint = ?

		INSERT
		INTO dbo.Traffic(EndPoint, Verb, IP_checksum, User_Agent, createDate)
		VALUES (?, ?, CHECKSUM(?), LEFT(?, 255), DateAdd(hh, @offset, getDate()) )
		",
		[application.config.Traffic.TZOffset, arguments.endpoint, arguments.verb, cgi.remote_addr, cgi.http_user_agent]
		);
}



} // end component
