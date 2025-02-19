extends Node2D
class_name Weapon

@onready var muzzle: Marker2D = $Muzzle

@export var weapon_resource: PackedEquippablePickup = null

var entity: CharacterEntity = null
var body: Body = null

func discard():
    print("Weapon discarded")
    queue_free()

func _input(event: InputEvent) -> void:
    if not is_inside_tree(): return
    if event.is_action_pressed(&"shoot"):
        handle_shoot()

const BULLET_SCENE: PackedScene = preload("res://scenes/bullet.tscn")
func handle_shoot():
    var bullet: Bullet = BULLET_SCENE.instantiate()
    var traincar: Traincar = entity.get_current_traincar()
    
    var initial_targets: Array[CharacterEntity] = traincar.get_targetable_entities(entity)
    var initial_target: CharacterEntity = initial_targets.pick_random() # TODO change this later
    traincar.add_entity(bullet, muzzle)
    bullet.set_target(initial_target)