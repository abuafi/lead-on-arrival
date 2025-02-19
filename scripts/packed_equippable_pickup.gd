extends PackedPickup
class_name PackedEquippablePickup

@export var weapon_scene: PackedScene
@export var arms_sprite: NodePath = ^"ArmsSingleSprite"

func on_pickup(player: Player):
    super.on_pickup(player)
    if not is_instance_valid(weapon_scene): return
    var weapon: Weapon = weapon_scene.instantiate()
    weapon.weapon_resource = self
    player.body.equip_weapon(weapon)