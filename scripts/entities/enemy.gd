extends CharacterEntity
class_name Enemy

@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var detection_area: DetectionArea = $Body/Head/DetectionArea

var detected_player: Player = null
var target_pickup: Pickup = null 
var last_heard_noise: Vector2 = Vector2(INF, INF) :
    set(n):
        last_heard_noise = n
        if last_heard_noise.is_finite():
            aware.emit(self)

signal player_detected(player: Player)
signal aware(enemy: Enemy)

func _ready():
    add_to_group(&"hostile")
    detection_area.player_detected.connect(_on_player_detected)
    get_current_traincar().noise.connect(_on_noise)
    
    super._ready()

func _on_player_detected(player: Player):
    detected_player = player
    player_detected.emit(player)
    aware.emit(self)

func _physics_process(_delta):
    body.set_velocity(velocity)
    apply_forces()

func _on_noise(pos: Vector2):
    last_heard_noise = pos 

func has_heard_noise():
    return last_heard_noise.is_finite()