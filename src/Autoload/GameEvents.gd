extends Node

signal score_changed(score: float)
signal multiscore_changed(multiscore: float)
signal health_changed(current_hp: int, max_hp: int)
signal ship_stats_changed(stats: Dictionary)
signal bonus_applied(bonus_type: StringName, source: Node)
signal node_spawned(node: Node, parent: Node)


func emit_score_changed(score: float) -> void:
	score_changed.emit(score)


func emit_multiscore_changed(multiscore: float) -> void:
	multiscore_changed.emit(multiscore)


func emit_health_changed(current_hp: int, max_hp: int) -> void:
	health_changed.emit(current_hp, max_hp)


func emit_ship_stats_changed(stats: Dictionary) -> void:
	ship_stats_changed.emit(stats)


func emit_bonus_applied(bonus_type: StringName, source: Node) -> void:
	bonus_applied.emit(bonus_type, source)


func emit_node_spawned(node: Node, parent: Node) -> void:
	node_spawned.emit(node, parent)
