extends Node2D
class_name Arms

var sprites: Array[Sprite2D]
@export var current_sprite: Sprite2D
@onready var weapon_container: Node2D = $WeaponContainer
@onready var body: Body = $".."

func _ready():
    for child: Node in get_children():
        if child is Sprite2D:
            sprites.append(child)
            child.hide()
    
    if has_weapon():
        var weapon: Weapon = get_weapon()
        body.call_deferred(&"equip_weapon", weapon)

    current_sprite.show()

func set_arms_sprite(arms_sprite: NodePath = ^"ArmsSprite"):
    var sprite = get_node(arms_sprite)
    current_sprite.hide()
    current_sprite = sprite
    sprite.show()
    if sprite.has_node(^"WeaponMarker"):
        var marker: Marker2D = sprite.get_node(^"WeaponMarker")
        weapon_container.transform = marker.transform

func has_weapon() -> bool:
    return weapon_container.get_child_count() > 0

func get_weapon() -> Weapon:
    if not has_weapon(): return null
    else: return weapon_container.get_child(0)

func remove_weapon() -> void:
    var weapon: Weapon = get_weapon()
    if is_instance_valid(weapon): 
        weapon_container.remove_child(weapon)

func drop_weapon(dir: Vector2) -> void:
    var weapon: Weapon = get_weapon()
    if is_instance_valid(weapon): 
        weapon_container.remove_child(weapon)
        weapon.drop(body.entity.get_current_traincar(), dir)

func set_weapon(weapon: Weapon):
    remove_weapon()
    if not is_instance_valid(weapon):
        set_arms_sprite()
    else:
        weapon_container.add_child(weapon)
        set_arms_sprite(weapon.weapon_resource.arms_sprite)
        
