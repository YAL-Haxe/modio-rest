package modio.schema;

/**
 * @see https://docs.mod.io/#schemauser_object
 * @author YellowAfterlife
 */
typedef ModioUser = {
	/**
	 * Unique id of the user.
	 */
	var id:Int;
	
	/**
	 * Path for the user on mod.io. For example: https://mod.io/members/username-id-here Usually a simplified version of their username.
	 */
	var name_id:String;
	
	/**
	 * Username of the user.
	 */
	var username:String;
	
	/**
	 * Unix timestamp of date the user was last online.
	 */
	var date_online:Int;
	
	/**
	 * Contains avatar data.
	 */
	var avatar:ModioAvatar;
	
	/**
	 * Timezone of the user, format is country/city.
	 */
	var timezone:String;
	
	/**
	 * Users language preference. See localization for the supported languages.
	 * @see https://docs.mod.io/#localization
	 */
	var language:String;
	
	/**
	 * URL to the user's mod.io profile.
	 */
	var profile_url:String;
}
