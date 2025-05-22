extends Resource
class_name QuestLine
# List of quests in this line
@export var quests: Array[QuestItem] = []
var instance_quests: Array[QuestItem] = []

var current_quest_index: int = 0
var quest_condition_to_listen_for: String


func init_quest_line():
	Questify.quest_completed.connect(on_quest_completed)
	for q in quests:
		var ql := QuestItem.new()
		ql.quest = q.quest.instantiate()
		ql.condition = q.condition
		instance_quests.append(ql)
	var q = instance_quests[current_quest_index]
	Questify.start_quest(q.quest)
	if current_quest_index < instance_quests.size() - 2:
		quest_condition_to_listen_for = instance_quests[current_quest_index + 1].condition


func on_quest_completed(quest: QuestResource):
	if not quest:
		pass
	if quest_condition_to_listen_for.is_empty():
		if current_quest_index >= instance_quests.size() or instance_quests[current_quest_index] == null or instance_quests[current_quest_index].quest == null:
			return

		if quest.name == instance_quests[current_quest_index].quest.name:
			next_quest()
			return
	if quest_condition_to_listen_for == "q:" + quest.name:
		next_quest()
		return


func next_quest():
	if current_quest_index < instance_quests.size() - 1:
		current_quest_index += 1
		var nextQuest = instance_quests[current_quest_index]
		if current_quest_index < quests.size() - 2:
			quest_condition_to_listen_for = instance_quests[current_quest_index + 1].condition
		else:
			quest_condition_to_listen_for = ""
		Questify.start_quest(nextQuest.quest)
	else:
		print("No more quests in this line.")
