# TypeWriter
This is a *very* simple word processor, written in Lua, for the Love2D engine.

## Usage
To run the program, make sure `love` is available in your path, then run:
```sh
love . <filename>
```

## Keybinds
- `esc` closes the editor, saving your work.
- `f11` makes the editor fullscreen.
- `ctrl-+/-` increases/decreases your current font size.
- `ctrl-s` saves the file.
- `bkspc` removes the previous character.
- The scroll wheel scrolls the viewport, or if `ctrl` is held, zooms.

There is no way to manipulate text that is already written, other than to delete it.
There is also no way to format text.
This is why I've chosen to name the project TypeWriter.

## Configuration
The default configuration is included in `config.lua`, which is loaded as Lua code, and may alter the editor state and implementation arbitrarily.
You can use this to extend the editor in an Emacs-like fashion, in theory.
