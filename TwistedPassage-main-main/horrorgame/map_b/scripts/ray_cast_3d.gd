extends RayCast3D

var colliding = false
var key = 'interact'
var int_text  # Reference to the interaction UI text
var pickup_text  # Reference to the interaction UI text
var total_collectables = null

@onready var collectable_text = get_node('/root/' + get_tree().current_scene.name + '/interface/Collectable')

func _ready():
	Emitter.add_listener('collider_is_colliding', Callable(self, 'collider_is_colliding'))
	int_text = get_node('/root/' + get_tree().current_scene.name + '/interface/interact')
	pickup_text = get_node('/root/' + get_tree().current_scene.name + '/interface/pickup')

func collider_is_colliding(value):
	if value is Dictionary:
		if 'colliding' in value:
			colliding = value.colliding
		if 'key' in value:
			key = value.key
	
func _process(_delta):
	if total_collectables == null:
		total_collectables = Collectable.items.size()
		
	if is_colliding():
		var hit = get_collider()
		if hit:
			var collider_parent = hit.get_parent()
			if collider_parent:
				Emitter.emit('colliding',collider_parent.name)
				Emitter.emit('hit_colliding',collider_parent)
			else:
				Emitter.emit('colliding',hit.name)
				Emitter.emit('hit_colliding',hit.name)
	
		var interactable = find_interactable(hit)

		if interactable:
			var props_name = interactable.get_parent().name
			
			if not colliding:
				int_text.visible = true
				
			Emitter.emit('interacting', props_name)
			
			if Input.is_action_just_pressed(key):
				interactable.interact()
		else:
			Emitter.emit('not_interacting', 'none')
				
			int_text.visible = false
	else:
		Emitter.emit('not_interacting', 'none')
		Emitter.emit('collider_is_colliding', {'colliding': false, 'key': 'interact'}) # Reset the key 
		int_text.visible = false
		pickup_text.visible = false
		
	if total_collectables:
		if (total_collectables - Collectable.items.size()) == 8:
			Emitter.emit('complete_keys')
		collectable_text.text = 'Keys Collected: ' + str(total_collectables - Collectable.items.size())   +  '/'  + str(total_collectables)


func find_interactable(node):
	while node:
		if node.has_method("interact"):
			return node
		node = node.get_parent()
	return null  # Explicitly return null if no interactable object is found
