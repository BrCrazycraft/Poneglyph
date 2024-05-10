@tool class_name ScriptObject extends Object

var name:String;
var type:String;
var extension:String;
var code:String;
var light:CodeHighlighter;
var prompt:String;
var convert:String = "";


func _to_string() -> String:
	return "<{0} type=\"{1}\" extension=\"{2}\">{3}</{0}>".format([name,type,extension,code])
