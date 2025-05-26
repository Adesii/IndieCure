extends Resource

@export var name: String = ""
@export var description: String = ""

var is_active: bool = false
var is_selected: bool = false

func select():
    if not is_active:
        print("Cannot select an inactive sub-quest.")
        return

    is_selected = true
    State.set_value("active_sub_quest", name)
    State.sendmessage("sq_" + name)

    # Notify other systems about the selection
    print("Sub-quest selected: ", name)

func cancel():
    if not is_active:
        print("Cannot cancel an inactive sub-quest.")
        return

    is_selected = false
    State.set_value("active_sub_quest", "")
    State.sendmessage("sq_" + name)

    # Notify other systems about the cancellation
    print("Sub-quest cancelled: ", name)

func info():
    if not is_active:
        print("Cannot show info for an inactive sub-quest.")
        return

    print("Info for sub-quest: ", name)
    print(description)

# This function should be called when the sub-quest is started or made active
func activate():
    is_active = true

# This function should be called when the sub-quest is completed or made inactive
func deactivate():
    is_active = false