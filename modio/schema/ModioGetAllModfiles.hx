package modio.schema;

/**
 * ...
 * @author YellowAfterlife
 */
typedef ModioGetAllModfiles = {
	/**
	 * Unique id of the file.
	 */
	var id:Int;
	
	/**
	 * Unique id of the mod.
	 */
	var mod_id:Int;
	
	/**
	 * Unix timestamp of date file was added.
	 */
	var date_added:Int;
	
	/**
	 * Unix timestamp of date file was virus scanned.
	 */
	var date_scanned:Int;
	
	/**
	 * Current virus scan status of the file. For newly added files that have yet to be scanned this field will change frequently until a scan is complete:
	 * 
	 * 0 = Not scanned
	 * 1 = Scan complete
	 * 2 = In progress
	 * 3 = Too large to scan
	 * 4 = File not found
	 * 5 = Error Scanning
	 */
	var virus_status:Int;
	
	/**
	 * Was a virus detected:
	 * 
	 * 0 = No threats detected
	 * 1 = Flagged as malicious
	 */
	var virus_positive:Int;
	
	/**
	 * Size of the file in bytes.
	 */
	var filesize:Int;
	
	/**
	 * MD5 hash of the file.
	 */
	var filehash:String;
	
	/**
	 * Filename including extension.
	 */
	var filename:String;
	
	/**
	 * Release version this file represents.
	 */
	var version:String;
	
	/**
	 * Changelog for the file.
	 */
	var changelog:String;
	
	/**
	 * Metadata stored by the game developer for this file.
	 */
	var metadata_blob:String;
}
