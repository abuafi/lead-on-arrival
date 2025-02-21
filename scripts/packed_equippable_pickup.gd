extends PackedPickup
class_name PackedEquippablePickup

@export var weapon_scene: PackedScene
@export var arms_sprite: NodePath = ^"ArmsSingleSprite"

func on_pickup(player: CharacterEntity):
    super.on_pickup(player)
    equip_to_entity(player)

func equip_to_entity(entity: CharacterEntity):
    if not is_instance_valid(weapon_scene): return
    var weapon: Weapon = weapon_scene.instantiate()
    weapon.weapon_resource = self
    entity.pickup_weapon(weapon)
