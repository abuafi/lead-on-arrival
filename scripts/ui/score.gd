extends HBoxContainer
class_name Score 

@onready var text_label: Label = $Label
@onready var label: RichTextLabel = $ScoreLabel

var total_score: int = 0
var level_score: int = 0
var game_started: bool = false
var high_score: int = 0

var level_tween: Tween = null
var level: int = 0

func _ready():
    load_data()
    label.text = str(high_score)

const LEVEL_BASE_SCORE: int = 1000
func on_level_ready(_level: int):
    self.level = _level
    if is_instance_valid(level_tween):
        level_tween.kill()
        total_score += level_score
        level_score = 0
    var tens: int = (level / 10) + 1
    level_score = LEVEL_BASE_SCORE * tens
    level_tween = create_tween()
    level_tween.tween_property(self, ^"level_score", 0, 20.)

func start_game():
    game_started = true
    text_label.text = "Score: "

func _process(_delta):
    if not game_started: return
    label.clear()
    label.add_text(str(total_score))
    if level_score > 0:
        label.add_text(" + " + str(level_score))

func on_level_reloaded():
    if is_instance_valid(level_tween):
        level_tween.kill()
        var tens: int = (level / 10) + 1
        level_score = LEVEL_BASE_SCORE * tens
        level_tween = create_tween()
        level_tween.tween_property(self, ^"level_score", 0, 20.)

func save_high_score():
    var saved_options: Dictionary
    var save_file: FileAccess = FileAccess.open("user://options.json", FileAccess.READ)
    if is_instance_valid(save_file):
        var _text: String = save_file.get_as_text()
        save_file.close()
        saved_options = JSON.parse_string(_text)
    saved_options['high_score'] = total_score
    var json_string: String = JSON.stringify(saved_options)

    save_file = FileAccess.open("user://options.json", FileAccess.WRITE)
    save_file.store_line(json_string)
    save_file.close()
    
func load_data():
    var save_file: FileAccess = FileAccess.open("user://options.json", FileAccess.READ)
    if not is_instance_valid(save_file): return
    var text: String = save_file.get_as_text()
    var saved_options = JSON.parse_string(text)
    var keys: Array = saved_options.keys()

    if not saved_options: 
        save_file.close()
        return
    if 'high_score' not in keys: 
        save_file.close()
        return

    high_score = saved_options['high_score'] 
    save_file.close()