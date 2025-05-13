extends Node

func _ready():
	Questify.quest_started.connect(quest_started)
	Questify.quest_completed.connect(quest_completed)
	Questify.quest_objective_added.connect(quest_objective_added)
	Questify.quest_objective_completed.connect(quest_objective_completed)
	Questify.condition_query_requested.connect(condition_query_requested)

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
				if new_var == null:
					return variable
				else:
					return new_var
			return variable
		else:
			return null
	else:
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
