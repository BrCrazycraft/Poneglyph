extends Window

signal erro();

@onready var code:RichTextLabel = $style/root/load;

func run() -> void:
	if test_python():
		run_code();
	else:
		erro.emit();
		queue_free();

func test_python() -> bool:
	var exit:Array[String] = [];
	OS.execute("python", ["--version"], exit);
	return exit[0].contains("Python 3");


func run_code() -> void:
	var exit:Array[String];
	OS.execute("python", [GlobalConfig.project.get_absolute()], exit);
	var strs:String = "";
	for x in exit:
		strs += x;
	code.clear();
	code.text = strs;
	print(exit, "=>", GlobalConfig.project.get_absolute());

func _on_close_requested():
	queue_free();
