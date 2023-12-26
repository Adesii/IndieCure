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


func apply():
    match modifier:
        Modifier.ADD:
            Stat.Modify(Global.player,attribute_name,amount,"+")
        Modifier.MULTIPLY:
            Stat.Modify(Global.player,attribute_name,amount,"*")
        Modifier.SET:
            Stat.Set(Global.player,attribute_name,amount)