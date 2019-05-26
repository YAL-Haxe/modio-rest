package modio.core.gml;
import gml.io.Buffer;

/**
 * ...
 * @author YellowAfterlife
 */
@:forward(rewind)
abstract ModioBufGml(Buffer) to Buffer {
	public var length(get, never):Int;
	private inline function get_length() {
		return this.position;
	}
	public inline function new() {
		this = new gml.io.Buffer(1024, Grow, 1);
	}
	public inline function add(s:String):Void {
		this.writeChars(s);
	}
	public inline function addData(b:gml.io.Buffer) {
		this.writeBufferExt(b, 0, b.position);
	}
	public inline function addChar(c:Int):Void {
		this.writeByte(c);
	}
	public inline function toString():String {
		this.writeByte(0);
		this.rewind();
		return this.readString();
	}
}
