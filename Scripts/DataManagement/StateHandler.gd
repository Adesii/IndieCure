extends Node

func _ready():
	Questify.quest_started.connect(quest_started)
	Questify.quest_completed.connect(quest_completed)
	Questify.quest_objective_added.connect(quest_objective_added)
	Questify.quest_objective_completed.connect(quest_objective_completed)
	Questify.condition_query_requested.connect(condition_query_requested)

	registernode(self, "dialogue_request", handle_dialogue_request)
	registernode(self, "stage_request", handle_stage_request)
	registernode(self, "portal_request", handle_portal_request)
	registernode(self, "quest_available_request", handle_quest_available_request)
	registernode(self, "quest_objective_request", handle_quest_objective_request)

	LimboConsole.register_command(set_value, "set", "sets a value in the current state")
	LimboConsole.add_argument_autocomplete_source("set", 0,
		func():
			if current_state.has("value_store"):
				return current_state["value_store"].keys()
			return [])


# This class is responsible for managing the game state and saving/loading it.
# Useful for quests and progress tracking.
@export var current_state: Dictionary = {}

func save_state(path: String) -> bool:
	return false

func load_state(path: String) -> bool:
	return false

func set_value(key: String, value: Variant) -> void:
	if current_state.has("value_store"):
		current_state["value_store"][key] = value
	else:
		current_state["value_store"] = {}
		current_state["value_store"][key] = value
	
	if messagedictionary.has("l_" + key):
		State.sendmessage("l_" + key, [value])

func get_value(key: String) -> Variant:
	if current_state.has("value_store"):
		if current_state["value_store"].has(key):
			var variable = current_state["value_store"][key]
			if variable is String:
				var new_var = str_to_var(variable)
				if new_var != null:
					return new_var
			return variable
	return null


#region Quest Handling:

func quest_started(quest: QuestResource):
	print("Start quest: ", quest.name)
	pass

func quest_objective_added(quest: QuestResource, objective: QuestObjective):
	print("Quest objective added: ", quest.name, " - ", objective.description)
	pass

func quest_objective_completed(quest: QuestResource, objective: QuestObjective):
	sendmessage("quest_objective_completed", [quest, objective])
	print("Quest objective completed: ", quest.name, " - ", objective.description)
	for objective_metadata in objective.get_meta_list():
		var prefix := objective_metadata.get_slice("_", 0)
		match prefix:
			"d": # dialogue
				sendmessage("dialogue_request", [objective_metadata.replace("d_", "")])
			"stage": # stage
				sendmessage("stage_request", [objective_metadata.replace("stage_", "")])
			"p": # portal to another stage
				sendmessage("portal_request", [objective_metadata.replace("p_", "")])
			"qa": # quest available, unlocks new quests for selection in the hub
				sendmessage("quest_available_request", [objective_metadata.replace("qa_", "")])
			"qo": # quest objective, enables a node this the name in the scenetree
				sendmessage("quest_objective_request", [objective_metadata.replace("qo_", "")])
	pass

func quest_completed(quest: QuestResource):
	print("Quest completed: ", quest.name)
	pass

func condition_query_requested(type: String, key: String, value: Variant, requester: QuestCondition) -> void:
	if type.begins_with("var:"):
		var operator := type.get_slice(":", 1)
		var variable = get_value(key)
		var result := false
		match operator:
			type, "eq", "==":
				result = variable == value
			type, "neq", "!=":
				result = variable != value
			type, "gt", ">":
				assert(not variable is bool, "Cannot compare bool with other types")
				result = variable > value
			type, "gte", ">=":
				assert(not variable is bool, "Cannot compare bool with other types")
				result = variable >= value
			type, "lt", "<":
				assert(not variable is bool, "Cannot compare bool with other types")
				result = variable < value
			type, "lte", "<=":
				assert(not variable is bool, "Cannot compare bool with other types")
				result = variable <= value
			_:
				printerr("Unknown operator: ", operator)
		requester.set_completed(result)
	#print("type: ", type, " key: ", key, " value: ", value, "result: ", requester)


#endregion

#region Message Handling:
var messagedictionary = {}

func registernode(node: Node, message: String, callback: Callable):
	if not messagedictionary.has(message):
		messagedictionary[message] = []
	messagedictionary[message].append([node, callback])

func sendmessage(message: String, args: Array = []):
	if message.begins_with("set:"):
		var key_value = message.replace("set:", "").split(":")
		var key = key_value[0]
		var value = key_value[1]
		set_value(key, value)

	if messagedictionary.has(message):
		for node in messagedictionary[message]:
			var c = node[1] as Callable
			if c.is_valid():
				if c.get_argument_count() == 0:
					c.call()
				else:
					c.call(args)
			else:
				printerr("This should not happen. callable parameter isn't a callable")
			
#endregion


#region Request handler:

func handle_dialogue_request(dialogue_name):
	print("Dialogue requested: ", dialogue_name)
	pass

func handle_stage_request(request):
	print("Stage Modifier Requested: ", request)
	pass

func handle_portal_request(portal_request):
	print("Portal Requested: ", portal_request)
	pass

func handle_quest_available_request(request):
	print("Quest Available Requested: ", request)
	pass

func handle_quest_objective_request(request):
	var quests_node = Global.current_scene.get_node("Quests")
	if quests_node:
		var request_node = quests_node.get_node(request)
		if request_node:
			request_node.process_mode = ProcessMode.PROCESS_MODE_PAUSABLE
			request_node.visible = true
		else:
			printerr("Request node not found for: ", request)
	else:
		printerr("Quests node not found")

#endregion