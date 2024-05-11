class_name RegexS extends Object;

static func find(str:String, pattern:String) -> bool:
	var regex:RegEx = RegEx.create_from_string(pattern);
	return not regex.search(str) == null;

