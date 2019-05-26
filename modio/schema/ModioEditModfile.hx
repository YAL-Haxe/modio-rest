package modio.schema;

/**
 * ...
 * @author YellowAfterlife
 */
typedef ModioEditModfile = {
	/**
	 * Version of the file release.
	 */
	@:optional var version:String;
	
	/**
	 * Changelog of this release.
	 */
	@:optional var changelog:String;
	
	/**
	 * Label this upload as the current release.
	 * 
	 * NOTE: If the active parameter causes the parent mods modfile parameter to change, a MODFILE_CHANGED event will be fired, so game clients know there is an update available for this mod.
	 * @see https://docs.mod.io/#get-all-mod-events
	 */
	@:optional var active:Bool;
	
	/**
	 * Metadata stored by the game developer which may include properties such as what version of the game this file is compatible with. Metadata can also be stored as searchable key value pairs, and to the mod object.
	 * @see https://docs.mod.io/#metadata
	 * @see https://docs.mod.io/#edit-mod
	 */
	@:optional var metadata_blob:String;
}
