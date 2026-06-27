extends Node


func spawn(node: Node, parent: Node = null) -> Node:
	var spawn_parent := parent
	if spawn_parent == null:
		spawn_parent = get_tree().current_scene

	if spawn_parent == null:
		push_error("SpawnService.spawn called without a valid parent or current scene.")
		return node

	spawn_parent.add_child(node)
	GameEvents.emit_node_spawned(node, spawn_parent)
	return node


func spawn_at(node: Node2D, global_spawn_position: Vector2, parent: Node = null) -> Node2D:
	node.global_position = global_spawn_position
	spawn(node, parent)
	node.global_position = global_spawn_position
	return node
