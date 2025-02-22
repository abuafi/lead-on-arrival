extends Node2D
class_name Legs 

@onready var sprite: AnimatedSprite2D = $LegsSprite
@onready var body: Body = $".."
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

var last_frame: int 
var moving: bool = false :
    set(m):
        if moving == m: return
        moving = m
        if moving: move()
        else: stop_moving()
var invert: bool = false :
    set(i):
        if invert == i: return
        invert = i 
        sprite.speed_scale = -1 if invert else 1

func move():
    sprite.play(&"walk")
    sprite.frame = last_frame
    if is_instance_valid(audio):
        audio.play()
        audio.finished.connect(audio.play)

func stop_moving():
    last_frame = sprite.frame
    sprite.stop()
    if is_instance_valid(audio):
        if audio.finished.is_connected(audio.play):
            audio.finished.disconnect(audio.play)
        audio.stop()

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