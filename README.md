# Learn Gameboy

This is a selection of some experimentations i've done to learn to program for the Gameboy

This has been done with the help of [@ISSOtm](https://github.com/ISSOtm) tutorial on how to dev on Gameboy in ASM Z80. (You can [find it here](https://eldred.fr/gb-asm-tutorial/index.html))
and the official documentation provided by Nintendo in 1999.

## What's inside ?

This is a list of what you can find inside and which folder correspond to what.

- `helloworld` : A Basic Hello World
- `vblank` : An experimentation to see what the screen does if you try to edit display not during vblank (not recommended)
- `scrolling` : Hello world but with scrolling

## Get the roms

The roms can be find in the release of this project. Each rom correspond to a folder of the project

## Build the project

You can build the project with the help of `RGBASM`. You can install it [following this instructions](https://github.com/rednex/rgbds#1-installing-rgbds).
Then, you can build the project doing :

```sh
make all
```

And tada ! All roms rom should have appear, ready to be used on an emulator or on a flash cartrige.
