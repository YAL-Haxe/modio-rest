package modio.core.gml;
import gml.io.Buffer;

/**
 * ...
 * @author YellowAfterlife
 */
class ModioFileToolsGml {
	public static inline function load(path:String):Buffer {
		var data = Buffer.load(file);
		data.position = data.size;
		return data;
	}
	public static inline function cleanup(b:Buffer):Void {
		b.destroy();
	}
	public static inline function getName(path:String):String {
		return SfTools.raw("filename_name")(path);
	}
	public static inline function getExt(path:String):String {
		return SfTools.raw("filename_ext")(path);
	}
}
