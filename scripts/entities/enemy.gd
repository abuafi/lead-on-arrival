extends CharacterEntity
class_name Enemy

@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var detection_area: DetectionArea = $Body/Head/DetectionArea

var detected_player: Player = null 

signal player_detected(player: Player)

func _ready():
    add_to_group(&"hostile")
    detection_area.player_detected.connect(_on_player_detected)
    super._ready()

func _on_player_detected(player: Player):
    player_detected.emit(player)

func _physics_process(_delta):
    body.set_velocity(velocity)
    apply_forces()