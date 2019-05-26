package modio.schema;

/**
 * ...
 * @author YellowAfterlife
 */
typedef ModioAccessToken = ModioResponse & {
	var code:Int;
	var access_token:String;
}
