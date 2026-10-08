# Neovim on Windows — install guide

The config itself is Windows-compatible (no `sh`, no hardcoded Unix
paths, OS-aware viewer/formatter selection). This file covers what the
[installer script](windows-install.ps1) cannot do fully automatically,
plus how to verify and troubleshoot the setup.

## 0. Prerequisites

- Windows 10 1809+ or Windows 11.
- `winget` available (`winget --version`). It ships with
  [App Installer](https://apps.microsoft.com/detail/9nblggh4nns1) from
  the Microsoft Store.
- This repo cloned somewhere, e.g. `C:\Users\<you>\dotfiles`.

## 1. Run the installer

```powershell
cd C:\Users\<you>\dotfiles\nvim
powershell -ExecutionPolicy Bypass -File .\windows-install.ps1
```

Only need one or two languages on this machine? Pass `-Languages`
(default is `all`, i.e. the full Linux-equivalent setup):

```powershell
# Java-only laptop, for example:
powershell -ExecutionPolicy Bypass -File .\windows-install.ps1 -Languages java

# Python + Lua:
powershell -ExecutionPolicy Bypass -File .\windows-install.ps1 -Languages python,lua
```

Available groups: `java`, `python`, `lua`, `rust`, `cpp`, `tex`,
`shell`. Re-running later with more groups just adds what's missing —
the script skips anything already installed.

What it installs via winget (skipping anything already present):

| Tool | winget id | Group | Used by |
|---|---|---|---|
| Git | `Git.Git` | core (always) | lazy.nvim bootstrap, gitsigns, fugitive, autosave autocmd |
| Neovim | `Neovim.Neovim` | core (always) | everything |
| ripgrep | `BurntSushi.ripgrep.MSVC` | core (always) | fzf-lua grep / live-grep |
| fd | `sharkdp.fd` | core (always) | fzf-lua file finder |
| fzf | `junegunn.fzf` | core (always) | fzf-lua backend |
| bat | `sharkdp.bat` | core (always) | fzf-lua previews |
| tree-sitter CLI | `tree-sitter.tree-sitter-cli` | core (always) | nvim-treesitter (`main` branch requires CLI ≥ 0.26.1) |
| GCC (WinLibs) | `BrechtSanders.WinLibs.POSIX.UCRT` | core (always) | C compiler for treesitter parser builds |
| JetBrainsMono Nerd Font | `NerdFonts.JetBrainsMono` | core (always) | statusline/tabline glyphs |
| shfmt | `mvdan.shfmt` | `shell` | conform (bash/zsh) |
| Node.js LTS | `OpenJS.NodeJS.LTS` | `shell` | `bash-language-server` (via Mason) |
| StyLua | `JohnnyMorganz.StyLua` | `lua` | conform (lua) |
| lua-language-server | `LuaLS.lua-language-server` | `lua` | LSP |
| uv | `astral-sh.uv` | `python` | Python provider; installs `ty` (Python LSP) |
| ruff | `astral-sh.ruff` | `python` | conform (python) |
| LLVM | `LLVM.LLVM` | `cpp` | conform (`clang-format`); `clang` also works as C compiler |
| OpenJDK 21 | `Microsoft.OpenJDK.21` | `java` | `jdtls` (Java LSP) |
| Rustup | `Rustlang.Rustup` | `rust` | cargo/rustfmt + stable toolchain |
| SumatraPDF | `SumatraPDF.SumatraPDF` | `tex` | vimtex viewer on Windows |
| Strawberry Perl | `StrawberryPerl.StrawberryPerl` | `tex` | `latexindent` (conform, tex) |

It also (all idempotent, all best-effort):

1. Installs `ty` via `uv tool install ty` and adds `%USERPROFILE%\.local\bin` to your user `PATH` (`python` group only).
2. Installs the stable Rust toolchain via `rustup` if `cargo` is missing (`rust` group only).
3. Sets user env `CC=gcc` when MSVC is absent but GCC was installed (falls back to `CC=clang` if only LLVM is present), so treesitter parser builds find a compiler (warns if no compiler at all — re-run the script, which installs GCC by default, or use `-WithVsBuildTools`).
4. Symlinks this repo's `.config/nvim` to `%LOCALAPPDATA%\nvim`.
5. Runs headless plugin sync + `:MasonInstall` for the servers of the selected groups only (`bash-language-server`, `jdtls`, `rust-analyzer`, `latexindent`).
6. Prints a version table covering the selected groups; anything `MISSING` is retried below.

Afterwards **open a brand-new terminal** (PATH changes need it) and
continue here.

## 2. Manual steps (installer can't do these)

### 2.1 Symlink, if the script skipped it

Creating symlinks needs **Developer Mode** *or* an elevated shell:

- Enable Developer Mode: Settings → System → For developers → Developer Mode → On, **or**
- Run PowerShell **as Administrator**, then:

```powershell
# Remove/rename any existing %LOCALAPPDATA%\nvim first (back it up!)
New-Item -ItemType SymbolicLink `
  -Path "$env:LOCALAPPDATA\nvim" `
  -Target "C:\Users\<you>\dotfiles\nvim\.config\nvim"
```

Verify: `nvim --headless "+echo stdpath('config')" "+qa"` should print
the symlinked path.

### 2.2 Terminal font

Set your terminal (Windows Terminal → Settings → Defaults → Appearance,
or whatever terminal you use) to **JetBrainsMono Nerd Font**. Without a
Nerd Font the statusline icons render as boxes.

### 2.3 TeX distribution (for vimtex + `latexindent`)

winget has no reliable TeX Live package, so install one manually:

- **MiKTeX** (recommended on Windows): https://miktex.org/download —
  during setup choose “Install missing packages on the fly: Yes”.
- or **TeX Live**: https://tug.org/texlive/windows.html.

Then confirm `latexmk` and `pdflatex` are on `PATH`:

```powershell
latexmk --version; pdflatex --version
```

The config uses SumatraPDF on Windows (`vimtex_view_method = general`
+ SumatraPDF). For forward/inverse search, in SumatraPDF go to
Settings → Options → “Set inverse search command-line” and enter:

```
nvim --headless -c "VimtexInverseSearch %l '%f'"
```

### 2.4 Java formatter (`astyle`)

conform.nvim formats Java with `astyle`, which has no winget package.
Either install it manually (https://astyle.sourceforge.net → add to
`PATH`), via `scoop install astyle`, or ignore it: the config sets
`lsp_format = "fallback"`, so Java files still get formatted by `jdtls`.

### 2.5 C# / anything Nix-specific

`nixfmt` is disabled automatically on Windows (`conform.lua`). No action.

### 2.6 First launch inside Neovim

```powershell
nvim
```

1. Wait for lazy.nvim to finish cloning plugins (check with `<leader>l` → `:Lazy`).
2. Run `:Mason` and confirm the servers for your groups show as installed (`jdtls` for java, `bash-language-server` for shell, `rust-analyzer` for rust, `latexindent` for tex); install any missing with `i` or `:MasonInstall <name>`.
3. Run `:checkhealth` — `git`, `rg`, `fd`, clipboard, plus your groups' providers (`node`, `python3`, …) should all be OK. (`python3` is satisfied by `uv python install` if absent: run `uv python install` once.)
4. Open a file in your language and confirm the LSP attaches (e.g. Java → `jdtls`); missing servers degrade silently.

## 3. Troubleshooting

| Symptom | Cause / fix |
|---|---|
| `:TSUpdate` / parser install fails with “C compiler” error | Make sure `gcc` is on PATH (`gcc --version`), restart the terminal, then `:TSUpdate` again. Re-run the installer (it installs GCC via WinLibs by default); only if that still fails, install the official compiler with `-WithVsBuildTools` (downloads several GB). |
| `tree-sitter` version < 0.26.1 | `winget upgrade --id tree-sitter.tree-sitter-cli --exact`; nvim-treesitter `main` requires ≥ 0.26.1. |
| `<leader>i` live-grep does nothing | `rg` not on PATH — new terminal, else `winget install BurntSushi.ripgrep.MSVC`. |
| Boxes instead of icons | Terminal font isn't the Nerd Font (§2.2). |
| PDF never opens / viewer error | Install SumatraPDF and a TeX distro (§2.3); `:VimtexInfo` shows the exact command attempted. |
| `spell` files downloading on first markdown buffer | Normal — Neovim fetches `en_us` spellfiles once; needs internet. |
| `Undotree` mapping missing / `ui2` error | You're on Neovim stable < 0.12; both are guarded with `pcall` and simply skipped. Install a nightly only if you want them. |
| Autosave commit does nothing | `git` not on PATH, or the file isn't in a git repo — silent by design (`autocmds.lua`). |
| `nvim` still old after install | PATH order / stale terminal — open a new terminal; `where nvim` should point at `C:\Program Files\Neovim\bin\nvim.exe`. |

## 4. What's Windows-aware in the config (for future edits)

- `lua/plugins/conform.lua` — no NixOS `/run/…` path; `shfmt` resolved from `PATH`; `nixfmt` only registered off-Windows.
- `lua/config/options.lua` — `undodir` under `stdpath("state")`, directory created at startup.
- `lua/config/autocmds.lua` — autosave git commit uses `vim.system({"git", …})`, no `sh`.
- `lua/plugins/vimtex.lua` — `zathura` on Unix, SumatraPDF on Windows.
- `lua/plugins/luasnip.lua` — snippets loaded from `stdpath("config")/LuaSnip`.
- `lua/plugins/treesitter.lua` — looks for `parser/*.dll` on Windows, `*.so` elsewhere.
- `init.lua` — `vim._core.ui2` and `packadd nvim.undotree` guarded for pre-0.12 builds.
