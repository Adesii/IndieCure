extends EditorProperty

# The main control for editing the property.
var property_control = stat_editor_control.new()
# An internal value of the property.
var current_value

var updated_value
# A guard against internal changes when the property is updated.
var updating = false



var is_resource:bool

func _init():
	# Add the control as a direct child of EditorProperty node.
	add_child(property_control)
	set_bottom_editor(property_control)
	# Make sure the control is able to retain the focus.
	add_focusable(property_control)
	property_control.updated.connect(_on_button_pressed)
	#_on_button_pressed()


func _on_button_pressed():
	# Ignore the signal if the property is currently being updated.
	if (updating):
		return
	updated_value = property_control.statobject
	# Generate a new random integer between 0 and 99.
	emit_changed(get_edited_property(),current_value)


func _update_property():
	# Read the current value from the property.
	var new_value = get_edited_object()[get_edited_property()]
	if (new_value == null):
		if is_resource:
			new_value = StatUpgradeResource.new()
		else:
			new_value = AttributePair.new()
	#print("New value: " + str(new_value) + " Current value: " + str(current_value))
	if (new_value == current_value):
		return

	if(updated_value != null):
		new_value = updated_value
		updated_value = null

	# Update the control with the new value.
	updating = true
	current_value = new_value.duplicate()

	#print("Updating control with value: " + str(current_value))

	current_value.resource_local_to_scene = true
	get_edited_object()[get_edited_property()] = current_value
	
	property_control.statobject = current_value
	property_control.update()
	#print("Updating control with value: " + str(current_value))
	updating = false