package modio.enums;
import haxe.extern.EitherType;

/**
 * @author YellowAfterlife
 */
@:keep enum ModioFilter {
	FullText(text:String);
	Equal(field:String, value:ModioFilterValue);
	NotEqual(field:String, value:ModioFilterValue);
	Like(field:String, value:String);
	NotLike(field:String, value:String);
	In(field:String, values:ModioFilterValues);
	NotIn(field:String, values:ModioFilterValues);
	Max(field:String, value:Int);
	Min(field:String, value:Int);
	SmallerThan(field:String, value:Int);
	GreaterThan(field:String, value:Int);
	BitwiseAnd(field:String, value:Int);
}
typedef ModioFilterValue = EitherType<String, Int>;
typedef ModioFilterValues = Array<ModioFilterValue>;
