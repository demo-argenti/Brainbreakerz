@tool
extends HBoxContainer

@export var bus_name : String = "":
	set(value):
		bus_name = value
		if label==null: return
		label.text = bus_name

@onready var reset_button: TextureButton = $ResetButton
@onready var spin_box: HSlider = $VBoxContainer/SpinBox
@onready var label: Label = $Label


func _ready() -> void:
	label.text = bus_name
	var bus_idx = AudioServer.get_bus_index(bus_name)
	spin_box.value = AudioServer.get_bus_volume_linear(bus_idx)


#func _process(delta: float) -> void:
	#pass


func _on_reset_button_pressed() -> void: spin_box.value = 1.0

# TODO do we want to use match instead here
# and not force ourselves to use the actual bus names for the labels?
func _on_spin_box_value_changed(value: float) -> void:
	if Engine.is_editor_hint(): return
	
	var bus = AudioServer.get_bus_index(bus_name)
	assert(bus >= 0)
	
	AudioServer.set_bus_volume_linear(bus,value)
	Prefs.volume.set(bus_name.to_lower(),value)
