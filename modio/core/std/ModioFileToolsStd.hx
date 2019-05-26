package modio.core.std;

/**
 * ...
 * @author YellowAfterlife
 */
class ModioFileToolsStd {
	public static inline function load(path:String) {
		#if sys
		return sys.io.File.getBytes(path);
		#else
		throw "Please provide a file pair on non-sys";
		#end
	}
	public static inline function cleanup(_):Void {
		// garbage-collected
	}
	public static inline function getName(path:String):String {
		return haxe.io.Path.withoutDirectory(path);
	}
	public static inline function getExt(path:String):String {
		return haxe.io.Path.extension(path);
	}
}
