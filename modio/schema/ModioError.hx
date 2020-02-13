package modio.schema;

/**
 * ...
 * @author YellowAfterlife
 */
typedef ModioError = {
	code:Int,
	message:String,
	errors:ModioDictionary<String>,
}
