extends CharacterBody2D
class_name CharacterEntity 

@onready var head: Head = $Body/Head
@onready var body: Body = $Body

@export var default_equip: PackedEquippablePickup = null

func get_current_traincar() -> Traincar:
    var holder: Node2D = get_parent()
    var traincar: Traincar = holder.get_parent()
    return traincar

func _ready():
    if is_instance_valid(default_equip):
        default_equip.equip_to_entity(self)

signal moved(position: Vector2)

func apply_forces():
    if moved.get_connections().size() > 0:
        var prev_position: Vector2 = global_position
        move_and_slide()
        if not prev_position.is_equal_approx(global_position):
            moved.emit(global_position)
    else: move_and_slide()