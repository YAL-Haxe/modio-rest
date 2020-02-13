package modio;
import haxe.DynamicAccess;

/**
 * ...
 * @author YellowAfterlife
 */
#if gml
@:forward(get, set)
abstract ModioDictionary<T>(gml.ds.HashTable<String, T>) {
	public function keys():Array<String> {
		var k = this.findFirst();
		var n = this.size();
		var r = gml.NativeArray.createEmpty(n);
		for (i in 0 ... n) {
			r[i] = k;
			k = this.findNext(k);
		}
		return r;
	}
}
#else
typedef ModioDictionary<T> = DynamicAccess<T>;
#end