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

func terraform(center: Vector3i, strength: float, radius: int) -> void:
    for dz in range(-radius, radius + 1):
        for dy in range(-radius, radius + 1):
            for dx in range(-radius, radius + 1):
                var pos = center + Vector3i(dx, dy, dz)
                if _is_in_bounds(pos):
                    var distance = Vector3(dx, dy, dz).length()
                    if distance <= radius:
                        var falloff = 1.0 - (distance / radius)
                        var old_val = read(pos.x, pos.y, pos.z)
                        var new_val = clamp(old_val + strength * falloff, -1.0, 1.0)
                        write(pos.x, pos.y, pos.z, new_val)

func _is_in_bounds(pos: Vector3i) -> bool:
    return (
        pos.x >= 0 and pos.x < resolution and
        pos.y >= 0 and pos.y < resolution and
        pos.z >= 0 and pos.z < resolution
    )
