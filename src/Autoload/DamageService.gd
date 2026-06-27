extends Node


func apply_damage(target: Node, amount: float, source: Node = null, damage_type: StringName = &"default") -> bool:
	if target == null or amount <= 0.0:
		return false

	if target.has_method("take_damage"):
		target.take_damage(amount, source, damage_type)
		GameEvents.emit_damage_applied(target, amount, source, damage_type)
		return true

	if target.has_method("takeDamage"):
		target.takeDamage(amount)
		GameEvents.emit_damage_applied(target, amount, source, damage_type)
		return true

	return false
