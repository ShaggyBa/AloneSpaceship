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
