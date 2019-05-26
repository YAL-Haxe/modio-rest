package modio.schema;

/**
 * ...
 * @author YellowAfterlife
 */
typedef ModioMessage = ModioResponse & {
	var code:Int;
	var message:String;
};
