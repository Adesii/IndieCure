extends Resource
class_name QuestItem

@export var quest: QuestResource
# The Condition to unlock this quest. if empty, the quest will be unlocked if the previous quest is completed.
@export var condition: String
