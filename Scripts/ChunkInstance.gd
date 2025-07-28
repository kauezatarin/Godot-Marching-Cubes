class_name ChunkInstance
extends MeshInstance3D

var grid: VoxelGrid
var debug: bool = false

func _ready() -> void:
    if debug:
        debug_grid()

func debug_grid() -> void:
    for x in range(grid.resolution):
        for y in range(grid.resolution):
            for z in range(grid.resolution):
                var label: Label3D = Label3D.new()
                var value: float = grid.read(x, y, z)

                label.text = "(%d, %d, %d) \n %f" % [x, y, z, value]
                label.position = Vector3(x, y, z)
                label.billboard = BaseMaterial3D.BILLBOARD_ENABLED

                add_child(label)

func remove_labels() -> void:
    for child in get_children():
        if child is Label3D:
            child.queue_free()

func remove_collision() -> void:
    for child in get_children():
        if child is StaticBody3D:
            child.queue_free()
