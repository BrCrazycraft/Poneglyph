extends CanvasLayer

#Referencias
@onready var root:VBoxContainer = $root;
@onready var log_m:Label = $"root/style-space/space-menu/style-tree/tree/config/box/Log_Menssage";
@onready var open:Label = $"root/style-space/space-menu/Container/lbl_open";
@onready var editor_de_codigo:CodeEdit = $"root/style-space/space-menu/Container/CodeEdit"
@onready var super_tree:PanelContainer = $"root/style-space/space-menu/style-tree/tree/root/tree/root";
@onready var export:PanelContainer = $salvando;

func _ready() -> void:
	super_tree.config("", true);
	GlobalConfig.project.init_funcion = open_project;


func _on_linguagem_item_selected():
	editor_de_codigo.text = GlobalConfig.project.in_edit;
	editor_de_codigo.syntax_highlighter = GlobalConfig.Lang.light;
	open.text = GlobalConfig.project.file_path;
	editor_de_codigo.show();


func open_project() -> void:
	editor_de_codigo.text = GlobalConfig.project.in_edit;
	editor_de_codigo.syntax_highlighter = GlobalConfig.Lang.light;
	open.text = GlobalConfig.project.file_path;
	editor_de_codigo.show();


func _on_code_edit_text_changed() -> void: GlobalConfig.project.in_edit = editor_de_codigo.text;


func _on_exportar_pressed():
	if validacao_export():
		export.show();
		$GeminiAPI.API_KEY = GlobalConfig.API_KEY;
		$GeminiAPI.Request = GlobalConfig.Lang.get_prompt(GlobalConfig.project.in_edit);
		$GeminiAPI.make_request();
		log_m.text = "Exportando";
		print($GeminiAPI.Request)
		log_m.add_theme_color_override("font_color", Color.SKY_BLUE);
	else:
		log_m.text = "Nenhum Código aberto";
		log_m.add_theme_color_override("font_color", Color.RED);


func _on_gemini_api_response(text:String):
	var file_store:String = GlobalConfig.project.file_path.substr(0, GlobalConfig.project.file_path.length() - GlobalConfig.project.file_path.get_extension().length()) + "py";
	print(text)
	if text.contains("```python"):
		var exit:String = "";
		var sub:PackedStringArray = text.split("\n");
		for x in range(1, sub.size()-1): exit += sub[x];
		GlobalConfig.project.write_file(file_store, exit);
	else: GlobalConfig.project.write_file(file_store, text);
	export.hide();
	super_tree.update();
	


func _on_sair_pressed():
	get_tree().quit();


func validacao_export() -> bool: return not open.text == "Sem codigo aberto";


func _on_terminal_pressed():
	if GlobalConfig.project.file_path.ends_with(".py"):
		var terminal:Window = load("res://util/terminal/Terminal.tscn").instantiate();
		add_child(terminal);
		terminal.erro.connect(erro);
		terminal.run();
	log_m.text = "Selecione arquivo python";
	log_m.add_theme_color_override("font_color", Color.RED);



func erro() -> void: 
	log_m.text = "Seu PC não possui python";
	log_m.add_theme_color_override("font_color", Color.RED);
