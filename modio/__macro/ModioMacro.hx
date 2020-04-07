package modio.__macro;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;
import haxe.macro.Compiler;

/**
 * ...
 * @author YellowAfterlife
 */
class ModioMacro {
	/**
	 * You give a schema-style typedef and we'll genereate all reqAdd*s for it!
	 */
	public static macro function reqAddTypedef(x:Expr) {
		switch (Context.typeExpr(x).t) {
			case TType(_.get() => t, _): {
				var a = switch (t.type) {
					case TAnonymous(_.get() => v): v;
					default: throw Context.error("Expected a typedef mapping to anon type", x.pos);
				}
				var out:Array<Expr> = [];
				for (fd in a.fields) switch (fd.type) {
					case TType(_.get() => { name: "ModioFile" }, _): {
						out.push(macro reqSetMultipart());
						break;
					};
					default:
				}
				for (fd in a.fields) {
					var ft = fd.type;
					switch (ft) {
						case TAbstract(_.get() => { name: "Null", module: "StdTypes" }, p): {
							ft = p[0];
						};
						default:
					}
					var fn = switch (ft) {
						case TAbstract(_.get() => {name:"Bool"}, _): macro reqAddBool;
						case TType(_.get() => { name: "ModioFile" }, _): macro reqAddFile;
						case TType(_.get() => { name: "ModioArray" }, _): macro reqAddArray;
						default: macro reqAdd;
					}
					var fs = fd.name;
					var add = macro $fn($v{fs}, $x.$fs);
					if (fd.meta.has(":optional")) add = macro if ($x.$fs != null) $add;
					out.push(add);
				}
				return { pos: x.pos, expr: EBlock(out)};
			};
			default: throw Context.error("Expected a typedef", x.pos);
		}
	}
	
	public static macro function reqMultipartBoundaryCharsGen():Expr {
		var r:String = "_-";
		for (c in "a".code ... "z".code + 1) r += String.fromCharCode(c);
		for (c in "A".code ... "Z".code + 1) r += String.fromCharCode(c);
		for (c in "0".code ... "9".code + 1) r += String.fromCharCode(c);
		return macro $v{r};
	}
}
