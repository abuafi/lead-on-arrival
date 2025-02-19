extends Node2D
class_name Weapon

@export var weapon_resource: PackedEquippablePickup = null

func discard():
    print("Weapon discarded")
    queue_free()