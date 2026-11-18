# cachyos + niri dotfiles

personal dotfiles and automated post-install setup for **cachyos linux** running the **niri** scrollable-tiling wayland compositor, dynamically themed with **matugen** and managed via **gnu stow**.

---

## stack overview

| component                | tool / config                                                                         |
| :----------------------- | :------------------------------------------------------------------------------------ |
| **os**                   | cachyos (arch-based)                                                                  |
| **compositor**           | niri (modular kdl layout)                                                             |
| **status bar & widgets** | waybar, ags (`aylurs-gtk-shell`)                                                      |
| **notifications & osd**  | swaync, swayosd, dunst                                                                |
| **launchers**            | fuzzel, rofi                                                                          |
| **theming engine**       | matugen (`gtk-3.0`, `gtk-4.0`, `qt5ct`, `qt6ct`, `kvantum`, terminal & bar templates) |
| **shell & prompt**       | fish (`fisher`, `pure`, `nvm.fish`), starship                                         |
| **terminals**            | kitty, alacritty                                                                      |
| **editors**              | neovim (separate repository), micro                                                   |
| **cli & media**          | yazi, mpd + rmpc, cava, fastfetch, btop, wayvibes                                     |

---

## repository structure

each top-level directory is a **gnu stow package** mirroring `$home`:

```text
.
├── install.sh          # interactive cli installer & stow deployment script
├── copy_config.sh      # helper script to sync local configs into stow packages
├── niri/               # modular niri kdl configs & helper scripts
├── waybar/             # waybar layout, styles, and scripts
├── matugen/            # matugen config.toml, templates, and reload hooks
├── fish/               # fish shell config & fisher plugin manifest
├── kitty/ & alacritty/ # terminal emulator configurations
├── yazi/               # terminal file manager config & themes
├── mpd/ & rmpc/        # music player daemon & terminal client configs
└── ...                 # swaync, swayosd, fuzzel, rofi, gtk/qt themes, shell files
```

---

## quick installation (fresh cachyos setup)

1. **clone this repository:**

   ```bash
   git clone [https://github.com/Xandev-4/xanny-s-dots.git](https://github.com/Xandev-4/xanny-s-dots.git) ~/xanny-dotfiles-stow
   cd ~/xanny-dotfiles-stow
   ```

2. **run the interactive installer:**

   ```bash
   chmod +x install.sh
   ./install.sh
   ```

3. **choose an option from the cli menu:**
   - **`1) full setup`** — installs native & aur packages, symlinks all stow packages into `$home`, clones neovim, enables `mpd`/`ags` user services, and sets fish as the default shell.
   - **`2) install rice packages`** — installs native packages via `pacman` and aur (`yay` or `paru`).
   - **`3) symlink dotfiles`** — backs up conflicting files (`.bashrc`, `.bash_profile`, `.gitconfig`) to `.bak` and links all packages using `stow`.
   - **`4) clone neovim config`** — clones the standalone neovim configuration into `~/.config/nvim`.
   - **`5) enable services & set fish shell`** — enables user systemd units and runs `chsh -s /usr/bin/fish`.

---

## post-install: generating theme colors

generate your initial theme files immediately after stowing by running matugen against any wallpaper:

```bash
matugen image /path/to/wallpaper.png
```

this populates all terminal, bar, gtk, qt, and niri color includes and triggers the configured reload hooks.

---

## keybindings reference (`Mod` = Super / Windows Key)

<details>
<summary><strong>Click to expand Niri keybindings</strong></summary>

### Core Applications & Launchers

| Keybind                    | Action                                        |
| :------------------------- | :-------------------------------------------- |
| `Mod + Return` / `Mod + T` | Open Kitty terminal                           |
| `Alt + Space`              | Open Fuzzel app launcher                      |
| `Mod + B`                  | Open Zen Browser                              |
| `Mod + Shift + B`          | Open Zen Browser (`Xandev` profile)           |
| `Mod + E`                  | Open Dolphin file manager                     |
| `Mod + Y`                  | Open Yazi file manager in Kitty               |
| `Mod + R`                  | Open RMPC music client in Kitty               |
| `Ctrl + Shift + Esc`       | Open Btop system monitor in Kitty             |
| `Mod + N`                  | Launch quick notes script                     |
| `Mod + D`                  | Run `/usr/local/bin/define` dictionary lookup |

### Custom Utilities, Theme & Session

| Keybind                                | Action                                          |
| :------------------------------------- | :---------------------------------------------- |
| `Mod + V`                              | Clipboard history manager (`rofi` + `cliphist`) |
| `Mod + .` / `Mod + Shift + .`          | Emoji picker / Kaomoji picker (`fuzzel`)        |
| `Alt + C`                              | Color picker (`hyprpicker`)                     |
| `Mod + A`                              | Cycle wallpaper (`awww`)                        |
| `Mod + Shift + W`                      | Open Rofi wallpaper picker                      |
| `Mod + Shift + X`                      | Reload Waybar                                   |
| `Alt + K`                              | Toggle Wayvibes keyboard sound auto-volume      |
| `Alt + L`                              | Lock screen (`swaylock`)                        |
| `Mod + P`                              | Open Waybar power menu                          |
| `Mod + Shift + P`                      | Power off monitors                              |
| `Mod + Shift + /`                      | Toggle Niri built-in hotkey overlay             |
| `Mod + Shift + E` / `Ctrl + Alt + Del` | Exit Niri session                               |

### Window & Column Navigation (Scrollable Tiling)

| Keybind                                 | Action                                                 |
| :-------------------------------------- | :----------------------------------------------------- |
| `Mod + H/J/K/L` or `Arrows`             | Focus column left/right or window down/up              |
| `Mod + Shift + H/J/K/L`                 | Move column left/right or window down/up               |
| `Mod + Home` / `Mod + End`              | Jump to first / last column                            |
| `Mod + Ctrl + Home/End`                 | Move column to first / last position                   |
| `Mod + U` / `Mod + I` or `Page_Down/Up` | Switch workspace down / up                             |
| `Mod + 1..9` / `Mod + Shift + 1..9`     | Focus workspace `1–9` / Move column to workspace `1–9` |
| `Mod + [` / `Mod + ]`                   | Consume or expel window left / right                   |
| `Mod + W`                               | Toggle tabbed column display                           |
| `Mod + F` / `Mod + Shift + F`           | Maximize column / True fullscreen window               |
| `Mod + Ctrl + F`                        | Expand column to available width                       |
| `Mod + Ctrl + R` / `Mod + Shift + R`    | Cycle preset column widths / window heights            |
| `Mod + -` / `Mod + =`                   | Shrink / grow column width by 10%                      |
| `Mod + Shift + -` / `Mod + Shift + =`   | Shrink / grow window height by 10%                     |
| `Mod + Shift + C` / `Mod + Ctrl + C`    | Center active column / Center all visible columns      |
| `Mod + Alt + Space`                     | Toggle floating window                                 |
| `Mod + Q`                               | Close focused window                                   |
| `Mod + O`                               | Toggle Niri workspace overview                         |

### Screenshots & Hardware Keys

| Keybind                        | Action                                                            |
| :----------------------------- | :---------------------------------------------------------------- |
| `Print`                        | Interactive region screenshot (saved to `~/Pictures/Screenshots`) |
| `Ctrl + Print` / `Alt + Print` | Fullscreen / Active window screenshot (saved to disk)             |
| `Ctrl + Shift + Print`         | Fullscreen screenshot (clipboard only)                            |
| `Shift + Alt + Print`          | Active window screenshot (clipboard only)                         |
| `XF86AudioRaise/Lower/Mute`    | Volume control via SwayOSD (up to 150%)                           |
| `XF86AudioMicMute`             | Toggle microphone mute (`wpctl`)                                  |
| `XF86AudioPlay/Next/Prev`      | Media playback control (`playerctl`)                              |
| `XF86MonBrightnessUp/Down`     | Display brightness control                                        |

</details>

---

## syncing local changes back to the repo

to pull updated configurations from `~/.config` and `$home` back into their respective stow packages before committing:

```bash
chmod +x copy_config.sh
./copy_config.sh
```
