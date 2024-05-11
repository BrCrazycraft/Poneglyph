class_name AbsLang extends Object;

var light:CodeHighlighter;
var prompt:String;
var extension:String;


func get_prompt(code:String) -> String:
	return prompt + code;
