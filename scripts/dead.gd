extends RigidBody2D

@onready var sprite: Sprite2D = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    var tween: Tween = create_tween()
    tween.tween_property(
        sprite, 
        "modulate", 
        Color(0.3, 0.3, 0.3), 
        0.5)