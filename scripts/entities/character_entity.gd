extends CharacterBody2D
class_name CharacterEntity 

@onready var head: Head = $Body/Head
@onready var body: Body = $Body
@onready var death_sound: AudioStreamPlayer2D = $DeathSound

@export var default_equip: PackedEquippablePickup = null

signal picked_weapon(weapon: Weapon)

var current_traincar: Traincar = null

func pickup_weapon(weapon: Weapon):
    body.equip_weapon(weapon, true)
    picked_weapon.emit(weapon)

func get_current_traincar() -> Traincar:
    return current_traincar

func _on_tree_entered():
    current_traincar = get_node(^"../../../..")
    # Traincar/NavRegion/Level/EntityHolder/Entity

func play_death_sound(traincar: Traincar):
    remove_child(death_sound)
    traincar.add_child(death_sound)
    death_sound.pitch_scale = randf_range(0.5, 1.5)
    death_sound.play()
    await death_sound.finished
    traincar.remove_child(death_sound)
    death_sound.queue_free()

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

func bullet_hit(bullet: Bullet):
    var dir: Vector2 = bullet.global_position - global_position
    dir = - dir.normalized()
    body.drop_weapon(dir)
    play_death_sound(get_current_traincar())
    queue_free()

func make_noise():
    get_current_traincar().make_noise(self)
