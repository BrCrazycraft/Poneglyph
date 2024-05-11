class_name Memory extends Object
#===============================================================================
#		Sinais
#===============================================================================

signal catch(e:Exception);

#===============================================================================
#		Variaveis
#===============================================================================
enum LS_ARGS {
	READ_NAME,
	READ_ABSOLUTE,
	FILES,
	FILES_ABSOLUTE,
	DIR,
	DIR_ABSOLUTE
}

## Variavel que determina o caminho atual do explorador
var dir_path:String;
##Variavel que determina o limite em que o arquivo pode chegar
var limit_path:String;

#===============================================================================
#		Funções
#===============================================================================
func _init(path:String="c:/") -> void:
	dir_path = path;
	limit_path = path;

##Retorna todos os itens de uma diretorio
func ls(args:LS_ARGS=LS_ARGS.READ_NAME) -> Array[String]:
	if args == LS_ARGS.READ_NAME:
		var exit:Array[String] = [];
		exit.append_array(DirAccess.get_directories_at(dir_path));
		exit.append_array(DirAccess.get_files_at(dir_path));
		return exit;
	elif args == LS_ARGS.DIR:
		var exit:Array[String] = [];
		exit.append_array(DirAccess.get_directories_at(dir_path));
		return exit;
	elif args == LS_ARGS.FILES:
		var exit:Array[String] = [];
		exit.append_array(DirAccess.get_files_at(dir_path));
		return exit;
	elif args == LS_ARGS.READ_ABSOLUTE:
		var exit:Array[String] = [];
		for x:String in ls(): exit.append(dir_path + "/" + x);
		return exit;
	elif args == LS_ARGS.FILES_ABSOLUTE:
		var exit:Array[String] = [];
		for x:String in ls(LS_ARGS.FILES): exit.append(dir_path + "/" + x);
		return exit;
	elif args == LS_ARGS.DIR_ABSOLUTE:
		var exit:Array[String] = [];
		for x:String in ls(LS_ARGS.FILES): exit.append(dir_path + "/" + x);
		return exit;
	return []

##Verifica se o caminhp existe dentro da pasta
func has(path:String) -> bool:
	if DirAccess.open(dir_path) == null: return false;
	return DirAccess.open(dir_path).file_exists(path) or DirAccess.open(dir_path).dir_exists(path);


##Retorna o caminho do arquivo
func find(path:String, absolute:bool=false) -> String:
	while path.ends_with("/"): path = path.substr(0, path.length()-1);
	if has(path) and path != "":
		if absolute == true and path.is_absolute_path():
			return path;
		elif absolute == false and path.is_relative_path():
			return path;
		elif absolute == true and path.is_relative_path():
			return dir_path + "/" + path;
		elif absolute == false and path.is_absolute_path():
			return path.substr(dir_path.length()+1, path.length());
		catch.emit(Exception.throw("Erro no caminho escrito"));
	return "<null>";



##Entra num diretorio do arquivo
func enter(path:String) -> bool:
	var absolute:String = find(path, true);
	if not absolute == "<null>" and not absolute.contains("."):
		dir_path = absolute;
		return true;
	catch.emit(Exception.throw("Caminho não pode ser acessado"));
	return false;


##Retorna um caminho
func back() -> void:
	var new_path:String = "";
	var splited:PackedStringArray = dir_path.split("/");
	splited.remove_at(splited.size()-1)
	for x in splited.size(): new_path += splited[x] + "/";
	dir_path = new_path;


##Retorna um objeto
func cd(path:String) -> bool:
	var old:String = dir_path;
	for x in path.split("/"):
		if x == "..": back();
		else: if not enter(x): 
			dir_path = old; 
			catch.emit(Exception.throw("Camiho com erro"));
			return false;
		while dir_path.ends_with("/"): dir_path = dir_path.substr(0, dir_path.length()-1);
	return true;


##ler um arquivo
func read(file_name:String) -> String:
	if has(file_name) and file_name.contains("."):
		var exit:String = "";
		var file:FileAccess = FileAccess.open(dir_path + "/" + file_name, FileAccess.READ);
		exit = file.get_as_text();
		file.close();
		return exit;
	catch.emit(Exception.throw("Arquivo não pode ser lido"));
	return ""


##Escreve num arquivo
func write(file_name:String, content:Array[String]) -> bool:
	if has(file_name) and file_name.contains("."):
		var file:FileAccess = FileAccess.open(dir_path + "/" + file_name, FileAccess.WRITE);
		print("salvando:",file.get_path_absolute());
		for x in content:
			file.store_string(x);
		file.close();
		return true;
	catch.emit(Exception.throw("Arquivo não encontrado"));
	return false;


func mkfl(file_name:String, content:String) -> void:
	if not has(file_name):
		var file:FileAccess = FileAccess.open(dir_path + "/" + file_name, FileAccess.WRITE);
		file.store_string(content);
		file.close();
	catch.emit(Exception.throw("Arquivo ja existe"))


##Renomeia um arquivo
func rename(new_name:String, item:String="") -> bool:
	if item == "":
		var file:DirAccess = DirAccess.open(dir_path.substr(0, dir_path.get_base_dir().length()+1));
		file.rename(dir_path.get_file(), new_name);
		return true;
	elif has(item):
		var file:DirAccess = DirAccess.open(dir_path);
		file.rename(item, new_name + "." + item.get_extension());
		return true;
	catch.emit(Exception.throw("Arquivo não encontrado"));
	return false;


##Remove um arquivo
func remove(name:String="") -> void:
	if name == "":
		OS.move_to_trash(dir_path);
		back();
	elif has(name):
		var path:String = find(name, true);
		if not path == "<null>": OS.move_to_trash(path);
		else: catch.emit(Exception.throw("Não existe esse arquivo"));


##Muda o caminho para um novo absoluto
func to_absolute(path:String) -> bool:
	if path != dir_path and DirAccess.dir_exists_absolute(path): 
		dir_path = path;
		return true;
	return false;


##Cria uma nova pasta
func mkdir(name:String) -> void:
	DirAccess.make_dir_absolute(dir_path + "/" + name);


##Duplica os arquivos
func clone() -> Memory:
	var exit:Memory = Memory.new();
	exit.dir_path = dir_path;
	return exit;
