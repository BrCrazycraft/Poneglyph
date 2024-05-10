extends CanvasLayer

#Referencias
@onready var root:VBoxContainer = $root;
@onready var open:Label = $"root/style-space/space-menu/Container/lbl_open";
@onready var editor_de_codigo:CodeEdit = $"root/style-space/space-menu/Container/CodeEdit"
@onready var super_tree:SuperTree = $"root/style-space/space-menu/style-tree/tree/root/tree/SuperTree"
@onready var export:PanelContainer = $salvando;


func _on_linguagem_item_selected(index):
	editor_de_codigo.syntax_highlighter = ProjectScript.index_toLight(index);


func _on_salvar_pressed():
	Project.save_all();


func open_project(instance:String) -> void:
	editor_de_codigo.text = ProjectScript.get_text(instance);
	editor_de_codigo.syntax_highlighter = ProjectScript.get_highlight(instance);
	open.text = instance;


func _on_code_edit_text_changed():
	var r = ProjectScript.set_text(open.text, editor_de_codigo.text)
	if (r == false):
		print("-------------------------------------")
		print("Falso")
		print(open.text)
		print(ProjectScript.tree)


func _on_exportar_pressed():
	export.show();
	$GeminiAPI.API_KEY = Project.API_KEY;
	$GeminiAPI.Request = ProjectScript.tree[open.text].prompt + ProjectScript.tree[open.text].code
	$GeminiAPI.make_request();


func _on_gemini_api_response(text:String):
	if text.contains("```python"):
		var exit:String = "";
		var sub:Array[String] = text.split("\n");
		for x in range(1, sub.size()-1):
			exit += sub[x];
		ProjectScript.tree[open.text].convert = exit;
	else:
		ProjectScript.tree[open.text].convert = text;
	ProjectScript.export();
	export.hide();
	


func _on_sair_pressed():
	get_tree().quit();
