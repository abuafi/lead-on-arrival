extends RigidBody2D
class_name Pickup

@export var pickup_resource: PackedPickup

@onready var pickup_area: Area2D = $PickupArea
@onready var sprite: Sprite2D = $Sprite

const PICKUP_SCENE: PackedScene = preload("res://scenes/base_pickup.tscn")

static func from_packed(packed: PackedPickup) -> Pickup:
    var pickup: Pickup = PICKUP_SCENE.instantiate()
    pickup.pickup_resource = packed
    return pickup

func _ready():
    sprite.texture = pickup_resource.pickup_texture
    pickup_area.body_entered.connect(_on_area_body_entered)

func _on_area_body_entered(body: Node2D):
    if body is CharacterEntity:
        var entity: CharacterEntity = body
        pickup_resource.on_pickup(entity)
        queue_free()

func set_unpickable():
    pickup_area.monitoring = false
    var timer: SceneTreeTimer = get_tree().create_timer(0.8, false)
    timer.timeout.connect(func():
        pickup_area.monitoring = true
    )
