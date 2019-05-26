package modio.core.std;
import haxe.io.*;

/**
 * ...
 * @author YellowAfterlife
 */
@:forward(length)
abstract ModioBufStd(BytesOutput) {
	public inline function new() {
		this = new BytesOutput();
	}
	public inline function add(s:String):Void {
		this.writeString(s);
	}
	public inline function addData(b:Bytes) {
		this.writeBytes(b, 0, b.length);
	}
	public inline function addChar(c:Int) {
		this.writeByte(c);
	}
	public inline function toBytes() {
		return this.getBytes();
	}
	public function toString() {
		var b = this.getBytes();
		return b.getString(0, b.length);
	}
}
