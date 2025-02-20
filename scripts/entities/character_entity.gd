extends CharacterBody2D
class_name CharacterEntity 

@onready var head: Head = $Body/Head
@onready var body: Body = $Body

@export var default_equip: PackedEquippablePickup = null

var current_traincar: Traincar = null

func get_current_traincar() -> Traincar:
    return current_traincar

func _on_tree_entered():
    current_traincar = get_node(^"../../../..")
    # Traincar/NavRegion/Level/EntityHolder/Entity

func _init() -> void:
    tree_entered.connect(_on_tree_entered)

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