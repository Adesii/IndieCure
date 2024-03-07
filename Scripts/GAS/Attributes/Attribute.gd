extends RefCounted

class_name Attribute

var current_value: float
var base_value: float
var max_value: float

var attribute_name: String
var ownerinfo

signal value_changed
signal value_changing

signal value_maxed

func _init(start_value, owner_info, attributename):
    self.base_value = start_value
    self.current_value = start_value
    self.max_value = start_value
    self.ownerinfo = owner_info
    self.attribute_name = attributename

func set_value(new_value):
    set_new_value(new_value)
    value_changed.emit(self, ownerinfo)
    return self

func get_value():
    return self.current_value

func modify_value(value, modifieroperator):
    if modifieroperator == "+":
        set_new_value(self.current_value + value)
        if current_value >= max_value:
            value_maxed.emit(self, ownerinfo)
    elif modifieroperator == "-":
        set_new_value(self.current_value - value)
    elif modifieroperator == "*":
        set_new_value(self.current_value * value)
    elif modifieroperator == "/":
        set_new_value(self.current_value / value)
    else:
        print("Invalid modifier operator")

    value_changed.emit(self, ownerinfo)
    return self

func get_value_scaled():
    return self.current_value / self.max_value

func set_new_value(new_value):
    var new_values = new_value
    value_changing.emit(self, ownerinfo, new_value)
    self.current_value = new_values