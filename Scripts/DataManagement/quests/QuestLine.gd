extends Resource
class_name QuestLine
# List of quests in this line
@export var quests: Array[QuestItem] = []

var current_quest_index: int = 0
var quest_condition_to_listen_for: String


func init_quest_line():
    Questify.quest_completed.connect(on_quest_completed)
    var q = quests[current_quest_index]
    Questify.start_quest(q.quest.instantiate())
    if current_quest_index < quests.size() - 2:
        quest_condition_to_listen_for = quests[current_quest_index + 1].condition


func on_quest_completed(quest: QuestResource):
    if quest_condition_to_listen_for.is_empty():
        if quest.name == quests[current_quest_index].quest.name:
            next_quest()
            return
    if quest_condition_to_listen_for == "q:" + quest.name:
        next_quest()
        return


func next_quest():
    if current_quest_index < quests.size() - 1:
        current_quest_index += 1
        var nextQuest = quests[current_quest_index]
        if current_quest_index < quests.size() - 2:
            quest_condition_to_listen_for = quests[current_quest_index + 1].condition
        else:
            quest_condition_to_listen_for = ""
        Questify.start_quest(nextQuest.quest.instantiate())
    else:
        print("No more quests in this line.")