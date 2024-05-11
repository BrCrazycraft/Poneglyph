extends CanvasLayer

@onready var config:PanelContainer = $"configurações";
@onready var root:PanelContainer = $style;
@onready var api:LineEdit = $"configurações/Config/mensagem/API_KEY/entrada";
@onready var folder:Label = $"configurações/Config/mensagem/Project/lbl_path";

func _on_config_pressed():
	config.show();


func _on_exit_pressed():
	config.hide();


func _on_btn_salvar_pressed():
	GlobalConfig.API_KEY = api.text;
	config.hide();


func _on_novo_projeto_pressed():
	if GlobalConfig.API_KEY == "":
		add_child(load("res://src/index/node/PopUpErro.tscn").instantiate())
	else:
		get_tree().change_scene_to_packed(load("res://src/workstation/index.tscn"));


func _on_btn_caminho_pressed():
	var expo:Node = load("res://util/explorador de arquivos/explorador.tscn").instantiate();
	expo.target.connect(target_project);
	add_child(expo);


func target_project(target:String) -> void:
	if target.is_absolute_path(): 
		GlobalConfig.project.global_memory.to_absolute(target);
		folder.text = target;
