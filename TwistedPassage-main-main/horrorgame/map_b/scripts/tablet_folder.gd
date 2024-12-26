extends Node3D

@onready var note_label = get_node("/root/" + get_tree().current_scene.name + "/interface/PanelContainer/Label")
@onready var panel_container = get_node("/root/" + get_tree().current_scene.name + "/interface/PanelContainer")

var is_note_visible = false  # Tracks if a note is being displayed

func _ready():
	note_label.visible = false  # Hide the note label initially
	panel_container.visible = false
	
	Emitter.add_listener('not_interacting', Callable(self, 'not_interacting'))

func not_interacting(v):
	close_note()

func interact():
	display_note()

func display_note():
	if Input.is_action_just_pressed("interact"):
		note_label.visible = true  # Show the note
		panel_container.visible = true
		is_note_visible = true  # Mark the note as visible

func close_note():
	note_label.visible = false  # Hide the note
	is_note_visible = false  # Allow the player to interact again
	panel_container.visible = false
