@tool
class_name stat_editor_save

extends Node


#stat_list is only a string of names of stats
# no values are stored in this list
var stat_list: Array = []


func _ready():
    var json = ResourceLoader.load("res://stat_list.json")
    if json != null:
        stat_list = json.data
    else:
        save()




func save():
    print("saving")
    #remove empty strings
    for stat in stat_list:
        if stat == "":
            stat_list.erase(stat)
    var json = JSON.new()
    json.data = stat_list
    print(ResourceSaver.save(json, "res://stat_list.json",ResourceSaver.FLAG_NONE))


func add_stat(stat_name):
    if stat_list.has(stat_name):
        return
    stat_list.append(stat_name)
    save()

func remove_stat(stat_name):
    if not stat_list.has(stat_name):
        return
    stat_list.erase(stat_name)
    save()

func has_stat(stat_name):
    return stat_list.has(stat_name)