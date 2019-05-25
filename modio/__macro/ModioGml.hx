package modio.__macro;
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

/**
 * ...
 * @author YellowAfterlife
 */
class ModioGml {
	public static function init() {
		Compiler.addGlobalMetadata("modio", '@:build(modio.__macro.ModioGml.setShortName())');
		// mark modio.schema.* structures to be GML-style hashtables
		Compiler.addGlobalMetadata("modio.schema", '@:dsMap');
		// mark modio.enums.* to be hinted in auto-completion
		Compiler.addGlobalMetadata("modio.enums", '@:doc');
	}
	
	/**
	 * Assigns shorter names so that we have `modio_thing` and not `modio_enums_modio_thing`
	 */
	public static function setShortName():Array<Field> {
		var bt:BaseType = switch (Context.getLocalType()) {
			case null: null;
			case TEnum(_.get() => e, _): e;
			case TType(_.get() => t, _): t;
			case TInst(_.get() => c, _): c;
			default: null;
		};
		if (bt != null) {
			var name = bt.name;
			name = sf.opt.SfGmlSnakeCase.toSnakeCase(name);
			bt.meta.add(":native", [macro $v{name}], bt.pos);
			bt.meta.add(":docName", [macro $v{name}], bt.pos);
		}
		return null;
	}
}
