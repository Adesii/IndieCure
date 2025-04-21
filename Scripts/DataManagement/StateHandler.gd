extends Node
class_name StateHandler

# This class is responsible for managing the game state and saving/loading it.
# Useful for quests and progress tracking.
@export var current_state: Dictionary = {}

func save_state(path: String) -> bool:
    return false

func load_state(path: String) -> bool:
    return false


#region Quest Handling:

func quest_started(quest: QuestResource):
    pass

func quest_objective_added(quest: QuestResource, objective: QuestObjective):
    pass

func quest_objective_completed(quest: QuestResource, objective: QuestObjective):
    pass

func quest_completed(quest: QuestResource):
    pass

func condition_query_requested(type: String, key: String, value: Variant, requester: QuestCondition):
    pass

#endregion