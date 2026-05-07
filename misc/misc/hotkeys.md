# ZED
- `gl`: multicursors


# FZF
- `f`: general "find file and edit"
- `ff`: fuzzy find files with rg, then edit
- `CTRL-T`: file picker
- `ALT-C`: better cd

- `^G^B`           <!-- branches   -->
- `^G^E`           <!-- each_ref   -->
- `^G^F`           <!-- files      -->
- `^G^H`           <!-- hashes     -->
- `^G^L`           <!-- reflogs   -->
- `^G^R`           <!-- remotes    -->
- `^G^S`           <!-- stashes    -->
- `^G^T`           <!-- tags       -->
- `^G^W`           <!-- worktrees  -->

# TMUX
- `<prefix>Y` : copy `$(pwd)`
- `<prefix>&` : kill window (with all the panes)
- `<S-Left>`: move tmux window to left
- `<S-Right>`: move tmux window to right
- `<prefix>space`: freeze frame (modified)
- `<prefix>t`: toggle/switch layouts (modified)
maybe prefix V and H for copying cwd first

---

# VIM
- `<leader>gj`: next git hunk
- `<leader>gk`: prev git hunk
- `<leader>dj`: next diagnostic msg
- `<leader>dk`: prev diagnostic msg
- Really been liking `xs` for stuff like `, `
- `q:`: open the "command line window," press enter on command. Up, down work.
- `@`: re-run the most recent command you entered

- `yc`: "yank copy"
- `<leader>so`: shell output
- `<leader>;`: for the back and forth
- `<leader>v`: select last paste, last yank otherwise

## NAVIGATION
- `<leader>j`: next buffer
- `<leader>k`: prev buffer
- `<leader>db`: delete buffer

## MACROS
- `@f`: formatter, "stuff" -> "- `stuff`"
- *Note*: two below use `gcc`, so comment is required for macro and based on `ft`
- `@h`: config block header, "-- header" -> "-- [[ HEADER ]] {{"
- `@s`: config block subheadings," -- subheader" -> "-- [[ SUBHEADER ]] "
- `@c`: checklist
    - *Note*: can't actually use insert mode `<C-l>` because of snippet expansion
- `@t`: todo, on a newline it'll give you `- [ ] []()`

## PLUGIN-RELATED
### GIT
- `<leader>gj`: next git hunk (next change down)
- `<leader>gk`: prev git hunk (next change up)

### MINI-AI
- *Note*: in place of `d` and `a` would be any verb (`y`, `c`, etc) and any qualifier (`i`).
- *Note*: `n` and `l` exist
- `daf`: ***Function***
- `daa`: ***Argument***
- `dab`: Alias for [( *a {bb} )]
- `daq`: Alias for ", ', or `
- `da?`: Manually input left, right
- `dat`: tag

- `va`: [V]isually select [A]round [)]paren
- `yinq`: [Y]ank [I]nside [N]ext [']quote
- `ci`: [C]hange [I]nside [']quote
- `saiw`: [S]urround [A]dd [I]nner [W]ord [)]Paren
- `sd`: [S]urround [D]elete [']quotes
- `sr`: [S]urround [R]eplace [)] [']

### FZF
- `<leader>fd`: find diagnostics
---
