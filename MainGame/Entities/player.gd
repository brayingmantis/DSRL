extends CharacterBody2D

var TILE_SIZE: Vector2 = ProjectSettings.get_setting("global/tile_size")
var TILE_SIZE_FLOAT: float = 16

@export var HPBar: HPBar

#@onready var max_hp = $HPComponent.max_hp
#@onready var hp = $HPComponent.hp

@onready var hp_component: HpComponent = $HPComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent

@onready var up_ray: RayCast2D = $RayCastComponent/UpRayCast2D
@onready var down_ray: RayCast2D = $RayCastComponent/DownRayCast2D
@onready var left_ray: RayCast2D = $RayCastComponent/LeftRayCast2D
@onready var right_ray: RayCast2D = $RayCastComponent/RightRayCast2D
@onready var up_left_ray: RayCast2D = $RayCastComponent/UpLeftRayCast2D
@onready var up_right_ray: RayCast2D = $RayCastComponent/UpRightRayCast2D
@onready var down_left_ray: RayCast2D = $RayCastComponent/DownLeftRayCast2D
@onready var down_right_ray: RayCast2D = $RayCastComponent/DownRightRayCast2D

var sprite_pos_tween: Tween # for smooth animation

signal movement_action
#signal melee_action

func _ready() -> void:
	InputStack.register_input_callback(player_input) # input
	HPBar._setup_hp_bar(hp_component.hp) # hp bar
	$PlayerSprite.modulate = Color.WHITE # colour
	#hp = 10 # called in HPComponent

func player_input(event: InputEvent) -> void:
	
	if event.is_released():
		return # don't do anything on key up
	
	# Movement actions
	var move_dir := Vector2.ZERO
	
	if event.is_action("move_up") and !up_ray.is_colliding():
		move_dir += Vector2.UP
		global_position += move_dir * TILE_SIZE
		emit_signal("movement_action")
		print("Moved up")
	elif event.is_action("move_down") and !down_ray.is_colliding():
		#hitbox_component.position.y += TILE_SIZE_FLOAT
		move_dir += Vector2.DOWN
		global_position += move_dir * TILE_SIZE
		emit_signal("movement_action")
		print("Moved down")
	elif event.is_action("move_left") and !left_ray.is_colliding():
		move_dir += Vector2.LEFT
		global_position += move_dir * TILE_SIZE
		emit_signal("movement_action")
		print("Moved left")
	elif event.is_action("move_right") and !right_ray.is_colliding():
		move_dir += Vector2.RIGHT
		global_position += move_dir * TILE_SIZE
		emit_signal("movement_action")
		print("Moved right")
	elif event.is_action("move_upright") and !up_right_ray.is_colliding():
		move_dir += Vector2.UP + Vector2.RIGHT
		global_position += move_dir * TILE_SIZE
		emit_signal("movement_action")
		print("Moved up-right")
	elif event.is_action("move_upleft") and !up_left_ray.is_colliding():
		move_dir += Vector2.UP + Vector2.LEFT
		global_position += move_dir * TILE_SIZE
		emit_signal("movement_action")
		print("Moved up-left")
	elif event.is_action("move_downright") and !down_right_ray.is_colliding():
		move_dir += Vector2.DOWN + Vector2.RIGHT
		global_position += move_dir * TILE_SIZE
		emit_signal("movement_action")
		print("Moved down-right")
	elif event.is_action("move_downleft") and !down_left_ray.is_colliding():
		move_dir += Vector2.DOWN + Vector2.LEFT
		global_position += move_dir * TILE_SIZE
		emit_signal("movement_action")
		print("Moved down-left")
	
	# smooth animation (credit Mostly Mad Productions)
	$PlayerSprite.global_position -= move_dir * TILE_SIZE
	if sprite_pos_tween:
		sprite_pos_tween.kill()
	sprite_pos_tween = create_tween()
	sprite_pos_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_pos_tween.tween_property($PlayerSprite, "global_position", global_position, 0.185).set_trans(Tween.TRANS_SINE)
	
	# Perform actions
	if event.is_action("heal"): # r key
		hp_component.heal(1)
	if event.is_action("take_damage"): # t key
		hp_component.damage(FighterComponent.new())
	if event.is_action("Menu"):
		game_quit()
	
	# Melee actions
	if event.is_action("move_up") and up_ray.is_colliding():
		hurtbox_component.animation_player.play("melee_up")
		print("Melee attacked up to hit ", up_ray.get_collider())
	if event.is_action("move_down") and down_ray.is_colliding():
		hurtbox_component.animation_player.play("melee_down")
		print("Melee attacked down to hit ", down_ray.get_collider())
	if event.is_action("move_left") and left_ray.is_colliding():
		hurtbox_component.animation_player.play("melee_left")
		print("Melee attacked left to hit ", left_ray.get_collider())
	if event.is_action("move_right") and right_ray.is_colliding():
		hurtbox_component.animation_player.play("melee_right")
		print("Melee attacked right to hit ", right_ray.get_collider())
	if event.is_action("move_upleft") and up_left_ray.is_colliding():
		hurtbox_component.animation_player.play("melee_upleft")
		print("Melee attacked up-left to hit ", up_left_ray.get_collider())
	if event.is_action("move_upright") and up_right_ray.is_colliding():
		hurtbox_component.animation_player.play("melee_upright")
		print("Melee attacked up-right to hit ", up_right_ray.get_collider())
	if event.is_action("move_downleft") and down_left_ray.is_colliding():
		hurtbox_component.animation_player.play("melee_downleft")
		print("Melee attacked down-left to hit ", down_left_ray.get_collider())
	if event.is_action("move_downright") and down_right_ray.is_colliding():
		hurtbox_component.animation_player.play("melee_downright")
		print("Melee attacked down-right to hit ", down_right_ray.get_collider())

# hp bar
func _on_hp_component_hp_changed(current: float, max: float) -> void:
	HPBar.change_value(current)

func _on_hp_component_death() -> void:
	print("YOU DIED")
	queue_free()

func game_quit() -> void:
	get_tree().quit()
