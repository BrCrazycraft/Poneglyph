extends CanvasLayer

func _ready() -> void:
	GlobalConfig.project.global_memory.to_absolute("C:/Users/user/Documents/Projects/Apps/PC/EditorGemini/Poneglyph/teste");
	$TreeMemory.config("simu", true);
