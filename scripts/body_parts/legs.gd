extends Node2D
class_name Legs 

@onready var sprite: AnimatedSprite2D = $LegsSprite
@onready var body: Body = $".."

var last_frame: int 
var moving: bool = false :
    set(m):
        if moving == m: return
        moving = m
        if moving:
            sprite.play(&"walk")
            sprite.frame = last_frame
        else:
            last_frame = sprite.frame
            sprite.stop()

func _ready():
    sprite.frame_changed.connect(_on_frame_changed)

const WALK_FRAMES: int = 13
const WALK_CYCLE: float = WALK_FRAMES / TAU
const TORSO_WOBBLE: float = PI/10

func _on_frame_changed():
    var frame: int = sprite.frame
    var angle: float = frame / WALK_CYCLE
    var wobble: float = sin(angle) * TORSO_WOBBLE
    body.set_torso_wobble(wobble)