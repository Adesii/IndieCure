@tool
extends EditorPlugin

var popup_scene = preload ("res://addons/itemcreator/test.tscn")
var popup: PopupPanel

func _enter_tree() -> void:
	# add a button option to right click menu of a folder
	add_tool_menu_item("Create New Weapon/Item", create_new_weapon_item)

func _exit_tree() -> void:
	remove_tool_menu_item("Create New Weapon/Item")
	popup.queue_free()

func create_new_weapon_item() -> void:
	print("Create New Weapon/Item")
	if popup == null:
		#popup.queue_free()
		popup = popup_scene.instantiate()
		get_editor_interface().get_base_control().add_child(popup)
	#deep_print(get_editor_interface().get_file_system_dock())
	#print("gotpath: ", get_editor_interface().get_file_system_dock().get_child(0).get_child(0).get_child(2).text)
	var filepath = popup.get_node("%FilePath") as Label
	filepath.text = get_editor_interface().get_file_system_dock().get_child(0).get_child(0).get_child(2).text # TODO: This will 100% fail when something about the filesystem dock changes... good luck :)
	pathToCreateAt = filepath.text
	var create = popup.get_node("%CreateButton") as Button
	create.pressed.connect(on_create)
	
	popup.reset_size()
	popup.popup_centered()

var pathToCreateAt = ""
func on_create() -> void:
	var iname = popup.get_node("%ItemName") as LineEdit
	var itype = popup.get_node("%ItemType") as OptionButton

	print("Creating new item: ", iname.text, " of type: ", itype.get_item_text(itype.selected))

	var diracces = DirAccess.open(pathToCreateAt)
	if !diracces.dir_exists(iname.text):
		diracces.make_dir(iname.text)

	var scene = Node2D.new()
	scene.name = iname.text
	var sceme = PackedScene.new()
	sceme.pack(scene)
	ResourceSaver.save(sceme, pathToCreateAt + "/" + iname.text + "/" + iname.text + ".tscn")

	# create a new item by creating a folder and putting a resource file of type InventoryItem in it and a empty 2d scene
	var inventoryItem = InventoryItem.new()
	inventoryItem.name = iname.text
	inventoryItem.scene = load(pathToCreateAt + "/" + iname.text + "/" + iname.text + ".tscn")
	inventoryItem.type = InventoryItem.ITEM_TYPE.WEAPON if itype.selected == 0 else InventoryItem.ITEM_TYPE.ABILITY
	print(ResourceSaver.save(inventoryItem, pathToCreateAt + "/" + iname.text + "/" + iname.text + ".tres"))

	#popup.queue_free()
	popup.hide()

func deep_print(node: Node, depth: int=0, maxdepth: int=5) -> void:
	print("\t".repeat(depth) + node.name)
	if depth >= maxdepth:
		return
	for child in node.get_children():
		deep_print(child, depth + 1)
