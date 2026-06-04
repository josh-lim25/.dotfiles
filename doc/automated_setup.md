# GNU Stow
What it does in a sentence: everything in `.dotfiles/` is effectively "placed" in $HOME as is via symlinks, meaning `~/.config/nvim/` is a symlink to `.dotfiles/.config/nvim/`. Just a pointer.
- *Q*: Why does my directory structure look different from most people that use stow? 
- *A*: I just have strong disagreements with the default naming convention of stow. The package structure is unintuitive to me and it makes everything so much more confusing than it has to be. Stow uses this "package_name for directories" convention, which I'd assume is trying to multiple stowed configurations more easily (maybe?). If you want to reorganize stuff that way, be my guest; examples of how that works are at the end so go there.
- Think about why you want to use stow (i.e., what's the purpose of stow?). The point is to keep config files meaningful to you in one nice place, so that you can use `git` or some other vcs to store it for you, rather than locally.
- With that in mind, stow comes into the picture by making symlinks for you, putting these "references" where they *should* be, and simply having those refs point to the *actual* file, as stored in `~/.dotfiles`.
    - That's it. Stow just makes pointers, which point to the *actual files stored in your dotfiles directory*, and *placing those pointers* in all the places they're "supposed to be" (i.e., according to the [XDG base directory spec](https://wiki.archlinux.org/title/XDG_Base_Directory)). 

```sh
# A view INSIDE a simplified ~/.dotfiles, with many files omitted.
# Note how the structure looks EXACTLY the same as "$HOME":
.
├── .config
│   ├── sway
│   │   └── config
│   ├── swaylock
│   │   └── config
├── .gitconfig
├── .gitignore
├── misc
│   ├── hotkeys.md
│   └── TODO.md
├── .stow-global-ignore
├── .vimrc
└── .zshrc
```

## Explanation
- Simply running `stow .` in `~/.dotfiles` (or `stow .dotfiles` in `~`) will create symlinks just as you'd expect, as per the file structure. Meaning, every file and directory in `~/.dotfiles` gets treated as though it were in `~`; everything sort of "collapses" in on itself.
- If you still don't get it, say you ran `stow ~/.dotfiles` in `~`:
    - Take some file in your dotfiles, like `~/.dotfiles/.zshrc`. After running `stow .` in `~/.dotfiles`, a new symlink (`~/.zshrc`) would be created **in "$HOME"** and linked to `~/.dotfiles/.zshrc`. Run `ls -al`. You'd see `~/.zshrc -> ~/.dotfiles/.zshrc`.
    - How about directories? You'd see something similar: running `ll ./sway` in `~/.config`, you'd see `./sway/ -> ~/.dotfiles/.config/sway`. It's like the `.dotfiles` part just "disappears" from the path name for the name of the link, which is where the config file was "supposed to go."
- Understanding the "stow logic," i.e., how it actually goes about doing all this stuff:
    1. Start in your dotfiles directory (e.g., `~/.dotfiles`).
    2. For each file in `~/.dotfiles`, create a symlink in the corresponding location in "$HOME". This symlink will point to the *actual* file (i.e., the file in `~/.dotfiles`), located "one level up" (e.g., the `.zshrc` symlink/reference/pointer EXISTS WITHIN `~/.zshrc`, but the ACTUAL file is in `~/.dotfiles/.zshrc`).
    3. For each directory in `~/.dotfiles`, check if it has any nested directories, and if it does recursively repeat step 2 and 3 until you reach a "leaf directory."
    4. Else (if there are no other nested directories), create a symlink in the PARENT directory (remember, from "$HOME") that points to the current directory itself.


## TAKEAWAY
- If you still didn't get it, sorry—I really tried. ALL YOU REALLY NEED TO DO is mirror the *directory structure* of your "$HOME" (where all the config files are "supposed to be") within your dotfiles directory. You're just preserving the structure of the various config files in `~` as-is (meaning as you'd normally expect those files to be under "$HOME"), just placing them in `~/dotfiles` instead.
- **IMPORTANT**: The "same directory structure" is the really important bit. The reason stow knows where to place these symlinks in "$HOME" is *because* the structure of `~/.dotfiles` is the same as "$HOME". That's why `~/.config/nvim` -> `~/.dotfiles/.config/nvim`. The symlink appears in "$HOME" *as if it were just the config file* (i.e., no `~/.dotfiles` prefix on the pathname). This is what I meant by the directory structure "collapsing": the symlink is placed in the *same location* as the original config file would be, as if `~/.dotfiles` doesn't exist. Symlinks are cool
- **IMPORTANT**: stow works with symlinks at the **file and directory level**, and it doesn't require you to have subdirectories like `vim/`, `zsh/`, `sway/`, etc., SO LONG AS the file structure is EXACTLY the same. This is why I don't need to do all this weird package stuff.
- So to recap, by running `stow .` you:
    1. Take all the files and directories from `~/.dotfiles`, as they are.
    2. Create symlinks (in "$HOME") that point to the stuff in `~/.dotfiles`, *as if you had manually placed them there*.

## Diff Approach
- If this isn't thorough enough for you, go through the [docs](https://www.gnu.org/software/stow/manual/stow.html#Introduction).
- When you run `stow <package-name>`, stow will essentially:
    - Look for a directory in `~/.dotfiles/<package-name>`.
    - If that directory exists, it will then create symlinks for the files inside that directory, linking them to the corresponding locations in "$HOME".
    - `stow vim` symlinks files from `/.dotfiles/.vimrc` and any other related files into the correct locations in `$HOME`.
    - `stow config/sway` symlinks files from `~/.dotfiles/.config/sway` into `$HOME/.config/sway`.

