extends RigidBody2D
class_name Pickup

@export var pickup_texture: Texture2D

@export var weapon_scene: PackedScene
@export var arms_sprite: NodePath = ^"ArmsSingleSprite"

func on_pickup(player: CharacterEntity):
    equip_to_entity(player)

func equip_to_entity(entity: CharacterEntity):
    if not is_instance_valid(weapon_scene): return
    var weapon: Weapon = weapon_scene.instantiate()
    entity.pickup_weapon(weapon)

@onready var pickup_area: Area2D = $PickupArea
@onready var sprite: Sprite2D = $Sprite

const PICKUP_SCENE: PackedScene = preload("res://scenes/gun_pickup.tscn")

func _ready():
    sprite.texture = pickup_texture
    pickup_area.body_entered.connect(_on_area_body_entered)

func _on_area_body_entered(body: Node2D):
    if body is CharacterEntity:
        var entity: CharacterEntity = body
        on_pickup(entity)
        queue_free()

func set_unpickable():
    pickup_area.monitoring = false
    var timer: SceneTreeTimer = get_tree().create_timer(0.8, false)
    timer.timeout.connect(func():
        pickup_area.monitoring = true
    )
