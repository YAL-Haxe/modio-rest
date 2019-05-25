package modio.schema;

/**
 * @see https://docs.mod.io/#mod-object
 */
typedef ModioMod = {
	/**
	 * Unique mod id.
	 */
	var id:Int;
	
	/**
	 * Unique game id.
	 */
	var game_id:Int;
	
	/**
	 * Status of the mod (see status and visibility for details):
	 * 
	 * 0 = Not Accepted
	 * 1 = Accepted
	 * 2 = Archived (potentially out of date or incompatible)
	 * 3 = Deleted
	 * @see https://docs.mod.io/#status-amp-visibility
	 */
	var status:Int;
	
	/**
	 * Visibility of the mod (see status and visibility for details):
	 * 
	 * 0 = Hidden
	 * 1 = Public
	 * @see https://docs.mod.io/#status-amp-visibility
	 */
	var visible:Int;
	
	/**
	 * Contains user data.
	 */
	var submitted_by:ModioUser;
	
	/**
	 * Unix timestamp of date mod was registered.
	 */
	var date_added:Int;
	
	/**
	 * Unix timestamp of date mod was updated.
	 */
	var date_updated:Int;
	
	/**
	 * Unix timestamp of date mod was set live.
	 */
	var date_live:Int;
	
	/**
	 * Maturity options flagged by the mod developer, this is only relevant if the parent game allows mods to be labelled as mature.
	 * 
	 * 0 = None set (default)
	 * 1 = Alcohol
	 * 2 = Drugs
	 * 4 = Violence
	 * 8 = Explicit
	 * ? = Add the options you want together, to enable multiple filters (see BITWISE fields)
	 * @see https://docs.mod.io/#bitwise-and-bitwise-and
	 */
	var maturity_option:Int;
	
	/**
	 * Contains logo data.
	 */
	var logo:ModioLogo;
	
	/**
	 * Official homepage of the mod.
	 */
	var homepage_url:String;
	
	/**
	 * Name of the mod.
	 */
	var name:String;
	
	/**
	 * Path for the mod on mod.io. For example: https://gamename.mod.io/mod-name-id-here
	 */
	var name_id:String;
	
	/**
	 * Summary of the mod.
	 */
	var summary:String;
	
	/**
	 * Detailed description of the mod which allows HTML.
	 */
	var description:String;
	
	/**
	 * description field converted into plaintext.
	 */
	var description_plaintext:String;
	
	/**
	 * Metadata stored by the game developer. Metadata can also be stored as searchable key value pairs, and to individual mod files.
	 * @see https://docs.mod.io/#metadata
	 * @see https://docs.mod.io/#get-all-modfiles
	 */
	var metadata_blob:String;
	
	/**
	 * URL to the mod's mod.io profile.
	 */
	var profile_url:String;
	
	/**
	 * Contains mod media data.
	 */
	var media:ModioModMedia;
	
	/**
	 * Contains modfile data.
	 */
	var modfile:ModioModfile;
	
	/**
	 * Contains stats data.
	 */
	var stats:ModioStats;
	
	/**
	 * Contains key-value metadata.
	 */
	var metadata_kvp:ModioArray<ModioMetadataKVP>;
	
	/**
	 * Contains mod tag data.
	 */
	var tags:ModioArray<ModioModTag>;
}
