class_name Emitter extends Node

static var listeners: Array[Dictionary] = []

static func add_listener(key: String, callback: Callable):
	var values = {
		"key": key,
		"callback": callback,
	}
	
	listeners.push_back(values)
	
static func emit(key:String, value = null):
	for listener in listeners:
		if listener and listener.key == key and listener.callback.is_valid():
			if value == null:
				listener.callback.call()  # No arguments
			else:
				listener.callback.call(value)  # Pass value as argument
