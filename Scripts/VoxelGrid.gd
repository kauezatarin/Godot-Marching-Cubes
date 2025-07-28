class_name VoxelGrid
extends Object

var _data: PackedFloat32Array
var resolution: int

func _init(grid_resolution: int) -> void:
    self.resolution = grid_resolution
    self._data.resize(grid_resolution * grid_resolution * grid_resolution)
    self._data.fill(1.0)

func read(x: int, y: int, z: int) -> float:
    return self._data[x + self.resolution * (y + self.resolution * z)]

func write(x: int, y: int, z: int, value: float) -> void:
    self._data[x + self.resolution * (y + self.resolution * z)] = value
