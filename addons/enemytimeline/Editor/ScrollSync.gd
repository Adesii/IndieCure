@tool
extends HSplitContainer

@export var ScrollFirst : ScrollContainer
@export var ScrollSecond : ScrollContainer

var oldScrollFirst : float = 0
var oldScrollSecond : float = 0

var oldScrollSizeFirst : float = 0
var oldScrollSizeSecond : float = 0

func _ready() -> void:
	oldScrollFirst = ScrollFirst.scroll_vertical
	oldScrollSecond = ScrollSecond.scroll_vertical

	oldScrollSizeFirst = ScrollFirst.size.y
	oldScrollSizeSecond = ScrollSecond.size.y


func _process(delta: float) -> void:
	if ScrollFirst == null or ScrollSecond == null:
		return
	if oldScrollFirst != ScrollFirst.scroll_vertical:
		ScrollSecond.scroll_vertical = ScrollFirst.scroll_vertical
		oldScrollFirst = ScrollFirst.scroll_vertical
		oldScrollSecond = ScrollSecond.scroll_vertical
	elif oldScrollSecond != ScrollSecond.scroll_vertical:
		ScrollFirst.scroll_vertical = ScrollSecond.scroll_vertical
		oldScrollSecond = ScrollSecond.scroll_vertical
		oldScrollFirst = ScrollFirst.scroll_vertical

	# if first size is smaller change the second min size
	if ScrollFirst.size.y < oldScrollSizeFirst:
		ScrollSecond.size_flags_vertical = 0
		ScrollSecond.size.y = oldScrollSizeSecond + (oldScrollSizeFirst - ScrollFirst.size.y)
		oldScrollSizeFirst = ScrollFirst.size.y
		oldScrollSizeSecond = ScrollSecond.size.y
	# if second size is smaller change the first min size
	elif ScrollSecond.size.y < oldScrollSizeSecond:
		ScrollFirst.size_flags_vertical = 0
		ScrollFirst.size.y = oldScrollSizeFirst + (oldScrollSizeSecond - ScrollSecond.size.y)
		oldScrollSizeFirst = ScrollFirst.size.y
		oldScrollSizeSecond = ScrollSecond.size.y
