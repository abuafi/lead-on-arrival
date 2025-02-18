extends PackedPickup
class_name PackedEquippablePickup

@export var equippable_scene: PackedScene

func on_pickup(player: Player):
    super.on_pickup(player)
    print(player, " equipped ", equippable_scene )
