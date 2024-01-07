extends Resource

class_name StatUpgradeResource


enum Modifier{
    ADD,
    MULTIPLY,
    SET
}

@export var attribute_name: String
@export var amount: float
@export var modifier: Modifier


func apply(obj):
    match modifier:
        Modifier.ADD:
            Stat.Modify(obj,attribute_name,amount,"+")
        Modifier.MULTIPLY:
            Stat.Modify(obj,attribute_name,amount,"*")
        Modifier.SET:
            Stat.Set(obj,attribute_name,amount)