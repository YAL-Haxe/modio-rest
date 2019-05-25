package modio;
import haxe.extern.EitherType;
/**
 * ...
 * @author YellowAfterlife
 */
typedef ModioFile = EitherType<ModioFilePair, String>;
#if (gml)
typedef ModioFilePair = { name:String, data:gml.io.Buffer }
#else
typedef ModioFilePair = { name:String, data:haxe.io.Bytes }
#end
