@tool class_name ProjectScript extends Object

static var tree:Dictionary = {}

static func save(path:String, content:ScriptObject) -> void:
	var full_path:String = path + content.name + "." + content.extension
	if FileAccess.file_exists(full_path):
		var file:FileAccess = FileAccess.open(full_path, FileAccess.WRITE);
		file.store_string(content.code);
		file.close();
	else:
		DirAccess.make_dir_absolute(path);
		var file:FileAccess = FileAccess.open(full_path, FileAccess.WRITE);
		file.store_string(content.code);
		file.close();


static func delete(abosulute_path:String) -> void:
	print(abosulute_path)
	OS.move_to_trash(abosulute_path);


static func index_toLight(index:int) -> CodeHighlighter:
	if index == 0:
		return ScriptNoCode.new("").light;
	elif index == 1:
		return ScriptWRITE.new("").light;
	return null


static func create_index(index:int, code:String="", name:String="") -> ScriptObject:
	if index == 0:
		return ScriptNoCode.new(name, code);
	elif index == 1:
		return ScriptWRITE.new(name, code);
	return null;


static func save_all() -> void:
	for key:String in tree.keys():
		var value:ScriptObject = tree[key];
		if FileAccess.file_exists(key):
			var file:FileAccess = FileAccess.open(key, FileAccess.WRITE);
			file.store_string(value.code);
			file.close();
		else:
			DirAccess.make_dir_absolute(key.substr(0, key.length() - (value.name + "." + value.extension).length()))
			var file:FileAccess = FileAccess.open(key, FileAccess.WRITE);
			file.store_string(value.code);
			file.close();


static func add_script(path:String, code:ScriptObject) -> bool:
	if tree.has(path):
		return true;
	else:
		tree[path] = code;
		return false;


static func get_text(path:String) -> String:
	if tree.has(path):
		return tree[path].code
	else:
		return ""

static func set_text(path:String, text:String) -> bool:
	if tree.has(path):
		tree[path].code = text;
		return true;
	return false;


static func get_highlight(path:String) -> CodeHighlighter:
	if tree.has(path):
		return tree[path].light;
	return null;


static func export() -> void:
	for key:String in ProjectScript.tree.keys():
		var value:ScriptObject = ProjectScript.tree[key];
		var new_key:String = key.substr(0,key.length() - key.get_extension().length()) + "py"
		if FileAccess.file_exists(new_key):
			var file:FileAccess = FileAccess.open(new_key, FileAccess.WRITE);
			file.store_string(value.convert);
			file.close();
		else:
			DirAccess.make_dir_absolute(new_key.get_base_dir());
			var file:FileAccess = FileAccess.open(new_key, FileAccess.WRITE);
			file.store_string(value.convert);
			file.close();
