# Godot 4 Migration Summary

This note summarizes the main fixes made while updating the project for the current Godot 4.x API and runtime behavior.

## GDScript API Updates

- Replaced old export syntax:
  - `@export (float) var value`
  - with `@export var value: float`.
- Replaced `File.new()` save/load code with `FileAccess`.
- Replaced numeric `String(value)` conversion with `str(value)`.
- Replaced `InputEventAction.button_pressed` with `pressed`.
- Replaced `CharacterBody2D.set_velocity(...)` with direct `velocity = ...`.
- Replaced old `AnimatedSprite2D.playing = true/false` usage with `play()` and `stop()`.

## Bonus Pickup Fixes

- Fixed active bonus inheritance:
  - `extends Bonus` was replaced with `extends ActiveBonus`.
- Added missing base groups to inherited bonus scenes:
  - active bonuses now include `ActiveBonus`;
  - passive bonuses now include `PassiveBonus`.
- Moved bonus pickup handling into `MC.apply_bonus(area)`.
- Bonus objects now call `MC.apply_bonus(self)` when they collide with the player.
- Added duplicate protection with `bonus_applied` metadata.
- Fixed bonus physics layers:
  - bonus base scenes now use physics layer 7 (`bonus`);
  - the player collision mask now includes the bonus layer.
- Added diagnostic logs for spawn, pickup, applied effects, and bonus audio playback.
- Increased active/passive bonus sound volume from `-25 dB` to `-12 dB`.

## Visibility Notifier Signals

- Replaced invalid Godot 3 signal usage:
  - `viewport_exited`
  - with Godot 4 `screen_exited`.
- Updated active and passive base bonus scenes and scripts accordingly.

## Enemy And Boss Death Animations

- Disabled looping on `Death` animations for enemies and boss scenes.
- Made enemy and boss death logic idempotent so repeated damage does not restart death.
- Death animations now start explicitly with `play("Death")` and reset to frame 0.
- `ShooterEnemy` and `BattleEnemy` now call `super._ready()` so base enemy initialization and signal connections run.
- Boss death now ignores delayed attacks after death.

## Meteorite Destruction Effects

- Added duplicate death protection for meteorites.
- Fixed destruction effect positioning:
  - effect position is now calculated from the center of the meteorite sprite;
  - this avoids offsets caused by `Sprite2D.centered = false` and local sprite offsets.
- Meteorite particle effects are configured before emission starts.
- Added `MeteoriteEffect.start_effect()` to start particles after texture, transform, and scale are set.
- Set particles to world coordinates with `local_coords = false`.
- Adjusted particle spread/direction/random velocity for outward debris movement.
- Added diagnostic logs showing effect position, meteorite origin, sprite position, scale, and texture.

## Texture Sharpness

- Pixel-art blurriness was fixed through Godot texture filtering settings:
  - set project/canvas texture filtering to `Nearest`;
  - disable mipmaps where needed.

## Verification

- Project was checked with Godot 4.7 headless editor loading.
- `World.tscn` was launched headlessly to catch script/runtime errors.
- Remaining forced-exit resource warnings from `--quit-after` were not tied to GDScript API failures.

## Technical Debt Before Gameplay Redesign

Before changing the core gameplay direction away from the current left-to-right runner structure, the project needs a cleanup pass. The current prototype is useful as a combat sandbox, but many systems are tightly coupled to the old flow.

### High-Risk Areas

- `MC.gd` currently owns too many responsibilities:
  - movement;
  - shooting;
  - health;
  - shield logic;
  - active and passive bonuses;
  - temporary effects;
  - audio feedback;
  - death handling;
  - direct interaction with world/spawner state.
- Many scripts rely on hard-coded scene paths and `get_tree().current_scene`.
- Gameplay objects communicate through groups and string checks such as `ActiveBonus`, `PassiveBonus`, `damageable`, `addDamage`, and `boss`.
- Enemy subclasses can accidentally skip base initialization when overriding `_ready()`.
- Runner assumptions are embedded in object movement:
  - enemies move from right to left;
  - meteorites move from right to left;
  - bonuses move from right to left;
  - spawners create objects as a constant stream.
- Stats and runtime state are mixed together. For example, exported player stats are also mutated directly during a run.
- Save data is still a loose dictionary without schema versioning or migration logic.
- HUD and GUI read game state directly instead of reacting to signals/events.
- Meteorite folders and spawners have duplicate/overlapping structures that should be consolidated.

### Recommended Refactor Before New Gameplay

- Split the player ship into smaller systems:
  - `ShipMovement`;
  - `ShipHealth`;
  - `WeaponController`;
  - `ShieldController`;
  - `BonusReceiver`;
  - `ShipStats`;
  - `ShipAudio`.
- Introduce a central stats/modifier model:
  - base stats;
  - current stats;
  - temporary modifiers;
  - passive modifiers;
  - permanent progression modifiers.
- Replace group-driven bonus logic with data-driven resources:
  - `UpgradeResource`;
  - `PickupResource`;
  - effect type;
  - value;
  - duration;
  - stack rules.
- Introduce a consistent damage contract:
  - common `take_damage(...)`;
  - damage amount;
  - source;
  - damage type;
  - optional knockback/status effects.
- Replace direct `current_scene.add_child(...)` calls with explicit spawn points or a `SpawnService` / `WorldSpawner`.
- Use signals for UI updates:
  - `health_changed`;
  - `score_changed`;
  - `stat_changed`;
  - `bonus_applied`;
  - `contract_updated`.
- Consolidate meteorite implementation into one base scene plus data/config variants.
- Add a debug logging flag so temporary migration logs can be disabled without removing useful diagnostic code.

### Preparation For New Direction

The next design direction should not be built directly on top of the existing `World.tscn` runner loop. Instead, create isolated test scenes:

- `SideViewSectorTest.tscn`
  - no forced left-to-right autoscroll;
  - free movement inside a bounded sector;
  - hand-placed meteorites;
  - small enemy groups;
  - one pickup/container;
  - one exit objective;
  - one mini-boss.
- `TopDownSectorTest.tscn`
  - top-down ship movement;
  - shooting in the new perspective;
  - enemies approaching from multiple directions;
  - one resource pickup;
  - one upgrade choice;
  - one mini-boss.

The old left-to-right loop can remain as a reference or fallback mode, but it should not be the foundation for contracts, sectors, ship builds, or long-term progression.

### Systems Needed For The Redesign

- `SectorController` for starting, tracking, and completing a sector.
- `ContractResource` for session objectives and rewards.
- `RunState` for current run stats, upgrades, resources, and temporary modifiers.
- `UpgradeChoiceUI` for choosing one of several upgrades during a run.
- `EncounterController` for enemy waves, hand-authored encounters, and sector hazards.
- `ProgressionSaveData` with versioned save structure.

### Main Guideline

Treat the current project as a combat prototype, not as the final architecture. Preserve the useful pieces: ship control, shooting, collisions, enemies, meteorites, bonuses, boss ideas, and pixel-art assets. Rebuild the gameplay loop around sectors, choices, contracts, and ship builds only after the core systems above are made less coupled and easier to test.
