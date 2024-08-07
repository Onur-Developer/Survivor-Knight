extends Node


signal experience_collected(value:float)
signal ability_upgrade_added(upgrade:AbilityUpgrade, current_upgrades:Dictionary)


func emit_experience_collected(value:float):
	experience_collected.emit(value)


func emit_ability_upgrade_added(upgrade:AbilityUpgrade, current_upgrades:Dictionary):
	ability_upgrade_added.emit(upgrade,current_upgrades)


func disconnect_upgrade(coming_func,upgrade:AbilityUpgrade, current_upgrades:Dictionary):
	if upgrade.max_quantity == current_upgrades[upgrade.id]["quantity"]:
		ability_upgrade_added.disconnect(coming_func)
