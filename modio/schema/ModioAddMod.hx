package modio.schema;

/**
 * ...
 * @author YellowAfterlife
 */
typedef ModioAddMod = {
	/**
	 * Visibility of the mod (best if this field is controlled by mod admins, see status and visibility for details):
	 * 
	 * 0 = Hidden
	 * 1 = Public (default)
	 * @see https://docs.mod.io/#status-amp-visibility
	 */
	@:optional var visible:Int;
	
	/**
	 * Image file which will represent your mods logo. Must be gif, jpg or png format and cannot exceed 8MB in filesize. Dimensions must be at least 512x288 and we recommended you supply a high resolution image with a 16 / 9 ratio. mod.io will use this image to make three thumbnails for the dimensions 320x180, 640x360 and 1280x720.
	 */
	var logo:ModioFile;
	
	/**
	 * Name of your mod.
	 */
	var name:String;
	
	/**
	 * Path for the mod on mod.io. For example: https://gamename.mod.io/mod-name-id-here. If no name_id is specified the name will be used. For example: 'Stellaris Shader Mod' will become 'stellaris-shader-mod'. Cannot exceed 80 characters.
	 */
	@:optional var name_id:String;
	
	/**
	 * Summary for your mod, giving a brief overview of what it's about. Cannot exceed 250 characters.
	 */
	var summary:String;
	
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
	
	/**
	 * An array of strings that represent what the mod has been tagged as. Only tags that are supported by the parent game can be applied. To determine what tags are eligible, see the tags values within tag_options column on the parent Game Object.
	 * @see https://docs.mod.io/#game-object
	 */
	@:optional var tags:ModioArray<String>;
}
