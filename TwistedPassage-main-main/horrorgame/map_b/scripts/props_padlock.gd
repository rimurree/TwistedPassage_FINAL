extends MeshInstance3D

@onready var pickup_text = get_node('/root/World/interface/pickup')
@onready var int_text = get_node('/root/World/interface/interact')

var hit_collider = ''

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventEmitter.add_listener('not_interacting', Callable(self, 'not_interacting'))
	EventEmitter.add_listener('hit_colliding', Callable(self, 'colliding'))

func not_interacting(value):
	pickup_text.visible = false
	int_text.visible = false
	EventEmitter.emit('collider_is_colliding', {'colliding': false, 'key': 'interact'})

func find_mesh(mesh):
	while mesh and mesh is not MeshInstance3D:
		mesh = mesh.get_parent()
	return mesh
		

func colliding(value):
	print(value)
	if str(value).containsn('Padlock'):
		hit_collider = value
		print(hit_collider)
		int_text.visible = false
		pickup_text.visible = true
		
		EventEmitter.emit('collider_is_colliding', {'colliding': true, 'key': 'pickup'})
		
func interact():
	#Collectable.items = Collectable.items.filter(func(item):
		#return item['Props'] != "Padlock" or item['value'].name != hit_collider
	#)
			
	queue_free()
			
