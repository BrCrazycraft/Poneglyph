class_name Exception extends Object

var name:String;
var err:String;

static func throw(new_err:String, new_name:String="Exception") -> Exception:
	return Exception.new(new_name, new_err);


func _init(new_name:String="", new_err:String="") -> void:
	name = new_name;
	err = new_err;


func _to_string() -> String:
	return name + ": " + err; 
	
