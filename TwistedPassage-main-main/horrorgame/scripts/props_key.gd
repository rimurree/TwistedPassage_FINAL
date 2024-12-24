extends MeshInstance3D

@onready var pickup_text = get_node('/root/World/UI/pickup_text')
@onready var int_text = get_node('/root/World/UI/interact_text')


var hit_collider = ''

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Emitter.add_listener('not_interacting', Callable(self, 'not_interacting'))
	Emitter.add_listener('colliding', Callable(self, 'colliding'))

func not_interacting(_value):
	pickup_text.visible = false
	int_text.visible = false
	Emitter.emit('collider_is_colliding', {'colliding': false, 'key': 'interact'})
	
func colliding(value):
	if str(value).containsn('Key') and Collectable.items.size() > 0:
		hit_collider = value
		int_text.visible = false
		# Only show the pickup text if the key is 'pickup'
		pickup_text.visible = true 
		Emitter.emit('collider_is_colliding', {'colliding': true, 'key': 'pickup'})
	else:
		pickup_text.visible = false 
		
func interact():
	Collectable.items = Collectable.items.filter(func(item):
		return item['Props'] != "Key" or item['value'].name != hit_collider
	)
			
	queue_free()
			
