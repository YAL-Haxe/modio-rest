package modio.schema;

/**
 * ...
 * @author YellowAfterlife
 */
typedef ModioEditMod = {
	/**
	 * Status of a mod. The mod must have at least one uploaded modfile to be 'accepted' or 'archived' (best if this field is controlled by game admins, see status and visibility for details):
	 * 
	 * 0 = Not accepted
	 * 1 = Accepted (game admins only)
	 * 2 = Archived (out of date or incompatible, game admins only)
	 * 3 = Deleted (use the delete mod endpoint to set this status)
	 * @see https://docs.mod.io/#status-amp-visibility
	 * @see https://docs.mod.io/#delete-mod
	 */
	@:optional var status:Int;
	
	/**
	 * Visibility of the mod (best if this field is controlled by mod admins, see status and visibility for details):
	 * 
	 * 0 = Hidden
	 * 1 = Public
	 * @see https://docs.mod.io/#status-amp-visibility
	 */
	@:optional var visible:Int;
	
	/**
	 * Name of your mod. Cannot exceed 80 characters.
	 */
	@:optional var name:String;
	
	/**
	 * Path for the mod on mod.io. For example: https://gamename.mod.io/mod-name-id-here. Cannot exceed 80 characters.
	 */
	@:optional var name_id:String;
	
	/**
	 * Summary for your mod, giving a brief overview of what it's about. Cannot exceed 250 characters.
	 */
	@:optional var summary:String;
	
	/**
	 * Detailed description for your mod, which can include details such as 'About', 'Features', 'Install Instructions', 'FAQ', etc. HTML supported and encouraged.
	 */
	@:optional var description:String;
	
	/**
	 * Official homepage for your mod. Must be a valid URL.
	 */
	@:optional var homepage_url:String;
	
	/**
	 * Maximium number of subscribers for this mod. A value of 0 disables this limit.
	 */
	@:optional var stock:Int;
	
	/**
	 * Choose if this mod contains any of the following mature content. NOTE: The value of this field will default to 0 unless the parent game allows you to flag mature content (see maturity_options field in Game Object).
	 * 
	 * 0 = None set (default)
	 * 1 = Alcohol
	 * 2 = Drugs
	 * 4 = Violence
	 * 8 = Explicit
	 * ? = Add the options you want together, to enable multiple options (see BITWISE fields)
	 * @see https://docs.mod.io/#game-object
	 * @see https://docs.mod.io/#bitwise-and-bitwise-and
	 */
	@:optional var maturity_option:Int;
	
	/**
	 * Metadata stored by the game developer which may include properties as to how the item works, or other information you need to display. Metadata can also be stored as searchable key value pairs, and to individual mod files.
	 * @see https://docs.mod.io/#metadata
	 * @see https://docs.mod.io/#get-all-modfiles
	 */
	@:optional var metadata_blob:String;
}
