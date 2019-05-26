package modio.schema;

/**
 * ...
 * @author YellowAfterlife
 */
typedef ModioAddModfile = {
	/**
	 * The binary file for the release. For compatibility you should ZIP the base folder of your mod, or if it is a collection of files which live in a pre-existing game folder, you should ZIP those files. Your file must meet the following conditions:
	 * 
	 * - File must be zipped and cannot exceed 10GB in filesize
	 * - Mods which span multiple game directories are not supported unless the game manages this
	 * - Mods which overwrite files are not supported unless the game manages this
	 */
	var filedata:ModioFile;
	
	/**
	 * Version of the file release.
	 */
	@:optional var version:String;
	
	/**
	 * Changelog of this release.
	 */
	@:optional var changelog:String;
	
	/**
	 * Default value is true. Label this upload as the current release, this will change the modfile field on the parent mod to the id of this file after upload.
	 * 
	 * NOTE: If the active parameter is true, a MODFILE_CHANGED event will be fired, so game clients know there is an update available for this mod.
	 * @see https://docs.mod.io/#get-all-mod-events
	 */
	@:optional var active:Bool;
	
	/**
	 * MD5 of the submitted file. When supplied the MD5 will be compared against the uploaded files MD5. If they don't match a 422 Unprocessible Entity error will be returned.
	 */
	@:optional var filehash:String;
	
	/**
	 * Metadata stored by the game developer which may include properties such as what version of the game this file is compatible with. Metadata can also be stored as searchable key value pairs, and to the mod object.
	 * @see https://docs.mod.io/#metadata
	 * @see https://docs.mod.io/#edit-mod
	 */
	@:optional var metadata_blob:String;
}
