extends CharacterBody3D

@export var SPEED: float = 2.0
@export var JUMP_VELOCITY: float = 5.0
@export var brush_strength: float = 0.5
@export var brush_radius: int = 1

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera = $Camera3D
@onready var walk_sound: AudioStreamPlayer3D = $WalkSound
@onready var parent: Terrain = $".."

func _physics_process(delta):
    # Add the gravity.
    if not is_on_floor():
        velocity.y -= gravity * delta

    # Handle Jump.
    if Input.is_action_pressed("ui_accept") and is_on_floor():
        velocity.y = JUMP_VELOCITY
    elif Input.is_key_pressed(KEY_SHIFT) and not is_on_floor():
        velocity.y = -JUMP_VELOCITY

    # Get the input direction and handle the movement/deceleration.
    # As good practice, you should replace UI actions with custom gameplay actions.
    var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

    if direction:
        if not walk_sound.playing:
            walk_sound.play()

        velocity.x = direction.x * SPEED
        velocity.z = direction.z * SPEED
    else:
        walk_sound.stop()
        velocity.x = move_toward(velocity.x, 0, SPEED)
        velocity.z = move_toward(velocity.z, 0, SPEED)

    move_and_slide()

func _input(event):
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
        var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
        var ray_settings: PhysicsRayQueryParameters3D  =  PhysicsRayQueryParameters3D.create($Camera3D.global_position, $Camera3D.project_ray_normal(event.position) * 1000, 0x1)
        var result: Dictionary = space_state.intersect_ray(ray_settings)

        if result:
            var chunk: ChunkInstance = result.collider.get_parent()
            parent.terraform_world(chunk, result.position, brush_strength, brush_radius)

func _unhandled_input(event):
    if event is InputEventMouseButton:
        Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    elif event.is_action_pressed(("ui_cancel")):
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        if event is InputEventMouseMotion:
            camera.rotate_x(-event.relative.y*0.005)
            camera.rotation.x = max(min(camera.rotation.x, deg_to_rad(90)), deg_to_rad(-90))
            rotate_y(-event.relative.x*0.005)
