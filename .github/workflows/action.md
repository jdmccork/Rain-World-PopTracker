# Discord Webhook Action

These are some github actions I use on my packs.

Feel free to use as you see fit.

## validation-lax/strict.yml

This action automatically validates JSON against official PopTracker schemas using
the [PopTracker pack-checker-action](https://github.com/PopTracker/pack-checker-action).

You can select validation with either the [lax](https://poptracker.github.io/schema/packs/)
or [strict](https://poptracker.github.io/schema/packs/strict/) schema.

It triggers on push or pull requests, and can also be run manually.
