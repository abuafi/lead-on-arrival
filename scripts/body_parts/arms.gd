extends Node2D
class_name Arms

var sprites: Array[Sprite2D]
@onready var current_sprite: Sprite2D = $ArmsSprite
@onready var weapon_container: Node2D = $WeaponContainer

func _ready():
    for child: Node in get_children():
        if child is Sprite2D:
            sprites.append(child)
            child.hide()
    current_sprite.show()

func set_arms_sprite(arms_sprite: NodePath = ^"ArmsSprite"):
    var sprite = get_node(arms_sprite)
    current_sprite.hide()
    current_sprite = sprite
    sprite.show()
    if sprite.has_node(^"WeaponMarker"):
        var marker: Marker2D = sprite.get_node(^"WeaponMarker")
        weapon_container.transform = marker.transform

func get_weapon() -> Weapon:
    return weapon_container.get_child(0)

func discard_weapon() -> void:
    var weapon: Weapon = get_weapon()
    if is_instance_valid(weapon): 
        weapon.discard()
        weapon_container.remove_child(weapon)

func set_weapon(weapon: Weapon):
    discard_weapon()
    if not is_instance_valid(weapon):
        set_arms_sprite()
    else:
        weapon_container.add_child(weapon)
        set_arms_sprite(weapon.weapon_resource.arms_sprite)
        
