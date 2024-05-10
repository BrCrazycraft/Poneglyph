class_name Project extends Object

static var path:String = "";
static var API_KEY:String = "";


static func resolve_path(relative:String) -> String:
	return path + "/" + relative;


static func delete(absolute:String) -> void:
	ProjectScript.delete(absolute);


static func save(path:String, content:ScriptObject) -> void:
	ProjectScript.save(resolve_path(path) + "/", content);


static func save_all() -> void:
	ProjectScript.save_all();
