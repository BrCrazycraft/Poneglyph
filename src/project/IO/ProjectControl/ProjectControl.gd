class_name ProjectControl extends Object;

var global_memory:Memory = Memory.new();
var file_path:String = "";
var init_funcion:Callable = func(): pass;
var in_edit:String = "";

func ls_fold(path:String, param:Memory.LS_ARGS) -> Array[String]:
	if path.begins_with("/"): path = path.substr(1, path.length());
	if path == "" or path.get_base_dir() == "/": return global_memory.ls(param);
	var cd:Memory = global_memory.clone();
	cd.cd(path);
	return cd.ls(param);

func rename_fold(path:String, new_name:String) -> void:
	if path.begins_with("/"): path = path.substr(1, path.length());
	if path == "" or path.get_base_dir() == "/":
		global_memory.rename(new_name);
		in_edit = global_memory.dir_path;
	else:
		var cd:Memory = global_memory.clone();
		cd.cd(path.get_base_dir());
		cd.rename(new_name, path.get_file());


func remove_fold(path:String) -> void:
	if path.begins_with("/"): path = path.substr(1, path.length());
	var cd:Memory = global_memory.clone();
	cd.cd(path.get_base_dir());
	cd.remove(path.get_file());


func open(path:String) -> void:
	if not in_edit == "": 
		write_file(file_path, in_edit);
	if path.begins_with("/"): path = path.substr(1, path.length());
	var cd:Memory = global_memory.clone();
	cd.cd(path.get_base_dir());
	var extension:String = path.get_extension();
	if not extension == "":
		if extension == "txt": GlobalConfig.Lang = TextLang.new();
		if extension == "wano": GlobalConfig.Lang = PLang.new();
		if extension == "py": GlobalConfig.Lang = PythonLang.new();
	in_edit = cd.read(path.get_file());
	file_path = path;
	init_funcion.call();

		


func write_file(path:String, content:String) -> void:
	if path.begins_with("/"): path = path.substr(1, path.length());
	var cd:Memory = global_memory.clone();
	cd.cd(path.get_base_dir());
	if cd.has(path.get_file()) and in_edit != "":
		cd.write(path.get_file(), [content]);
	else:
		cd.mkfl(path.get_file(), content);


func mkdir(path:String, name:String) -> void:
	if path.begins_with("/"): path = path.substr(1, path.length());
	if path == "":
		global_memory.mkdir(name);
	else:
		var cd:Memory = global_memory.clone();
		cd.cd(path.get_base_dir());
		cd.mkdir(name);


func get_absolute() -> String:
	if file_path.ends_with(".py"):
		var exit:Memory = global_memory.clone();
		exit.cd(file_path.get_base_dir());
		return exit.dir_path + "/" + file_path.get_file();
	return "<null>";
