extends Node3D

const preloadKeys = preload("res://map_b/Walls/props_key.tscn")
#const preloadPadlock = preload("res://Walls/props_padlock.tscn")

# Function to filter lockers and chests
func locker_and_chest(child):
	var r = RegEx.new()
	r.compile("Props_(Chest|Locker|tabledesk)\\d?|table_office\\d?|normal_t\\d?")
	return r.search(child.name) != null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Filter and shuffle children
	var filtered_children = self.get_children().filter(locker_and_chest)
	var keyCount = GameManager.max_keys

	# Ensure keyCount does not exceed the number of available children
	keyCount = min(keyCount, filtered_children.size())

	# Use a set to track selected indices
	var selected_indices = []
	var keys = []

	while keyCount > 0:
		var rand = randi() % filtered_children.size()
		# Check if the index is already selected
		if rand not in selected_indices:
			selected_indices.append(rand)
			keyCount -= 1
			keys.push_back(rand)
			
	keys.sort()
	
	var index = 0
	
	for child in filtered_children:
		if keys.find(index) != -1:
			var key = preloadKeys.instantiate().duplicate()
			key.name = 'Keys' + str(index)
			child.add_child(key)
			Collectable.addItem({ name: 'Key', 'value': key})
			
			# Regex for positioning
			var re = RegEx.new()
			re.compile("Props_Chest\\d?")
			
			var re1 = RegEx.new()
			re1.compile("table_office\\d?")
			
			var re2 = RegEx.new()
			re2.compile("normal_t\\d?")
			
			var re3 = RegEx.new()
			re3.compile("Props_tabledesk\\d?")
			
			# Adjust positions based on child name
			if re1.search(child.name) != null:  # table_office
				key.transform.origin = Vector3(-0.711, 0.755, 0.664)
				#padlock.transform.origin = Vector3(-0.605, -0.819, 0.759)
			elif re2.search(child.name) != null:  # table
				# Handle "table" case
				key.transform.origin = Vector3(-0.703, 0.613, -0.058)
				#padlock.transform.origin = Vector3(-0.284, child_size.y / 0.052, 0)
			elif re3.search(child.name) != null:  # tabledesk
				key.transform.origin = Vector3(0.266,0.793,0.973)
			elif re.search(child.name) != null:  # Props_Chest
				var child_size = child.get_aabb().size
				key.transform.origin = Vector3(0, child_size.y / 2, 0)
			else:
				# Default positioning
				var child_size = child.get_aabb().size
				key.transform.origin = Vector3(0, child_size.y * -0.48, 0)
			
		index += 1
