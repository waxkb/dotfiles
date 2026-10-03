<#
.SYNOPSIS
  Installs everything needed to run this Neovim config on Windows.

.DESCRIPTION
  Uses winget for system tools and (optionally) Mason inside Neovim for
  language servers. The script is idempotent: re-running it is safe.
  Individual failures never abort the script; they are reported at the
  end with pointers to windows-install.md for manual steps.

  Run from an elevated PowerShell only if you need symlinks without
  Developer Mode enabled (see windows-install.md).

.PARAMETER WithVsBuildTools
  Also install Visual Studio Build Tools (C++ workload, several GB).
  This is the officially recommended C compiler for nvim-treesitter on
  Windows. By default a lighter LLVM clang setup is installed instead;
  only use this switch if parser compilation fails (see
  windows-install.md).

.PARAMETER SkipSymlink
  Do not link this repo's config into %LOCALAPPDATA%\nvim.

.PARAMETER SkipMason
  Do not run headless :MasonInstall for language servers.

.PARAMETER Languages
  Which language toolchains to install. Default is "all" (same setup as
  Linux). Pick one or more groups to keep things light, e.g. a
  Java-only laptop:

    .\windows-install.ps1 -Languages java

  Available groups:
    java  - OpenJDK 21 + jdtls (heavy: JDK download)
    python- uv, ruff, ty (Python LSP)
    lua   - StyLua + lua-language-server
    rust  - Rust toolchain (rustup) + rust-analyzer (heavy: toolchain download)
    cpp   - LLVM (clang-format + clang, also the default C compiler for
            treesitter parser builds; heavy: several hundred MB)
    tex   - SumatraPDF viewer + Strawberry Perl + latexindent (heavy: Perl download;
            the TeX distro itself is always a manual install, see the .md)
    shell - shfmt + Node.js + bash-language-server

  Core tools (git, Neovim, ripgrep, fd, fzf, bat, tree-sitter CLI, zig,
  Nerd Font) are always installed.

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File windows-install.ps1
.EXAMPLE
  powershell -ExecutionPolicy Bypass -File windows-install.ps1 -Languages java
#>
[CmdletBinding()]
param(
  [switch]$WithVsBuildTools,
  [switch]$SkipSymlink,
  [switch]$SkipMason,
  [ValidateSet("all", "java", "python", "lua", "rust", "cpp", "tex", "shell")]
  [string[]]$Languages = @("all")
)

$ErrorActionPreference = "Continue"
$Failed = @()

$WantAll = $Languages -contains "all"
function Test-LanguageGroup([string]$Name) { return $WantAll -or ($Languages -contains $Name) }
$WantJava   = Test-LanguageGroup "java"
$WantPython = Test-LanguageGroup "python"
$WantLua    = Test-LanguageGroup "lua"
$WantRust   = Test-LanguageGroup "rust"
$WantCpp    = Test-LanguageGroup "cpp"
$WantTex    = Test-LanguageGroup "tex"
$WantShell  = Test-LanguageGroup "shell"

$Picked = @()
foreach ($g in @("java", "python", "lua", "rust", "cpp", "tex", "shell")) {
  if (Test-LanguageGroup $g) { $Picked += $g }
}
Write-Host ("Language groups: {0}" -f ($Picked -join ", ")) -ForegroundColor Yellow

function Install-WingetPackage {
  param(
    [Parameter(Mandatory)][string]$Id,
    [string]$Command,   # binary to probe, e.g. "rg" (skipped if empty)
    [string]$Note = ""
  )
  if ($Command -and (Get-Command $Command -ErrorAction SilentlyContinue)) {
    Write-Host "[ok] $Command already on PATH ($Id)" -ForegroundColor Green
    return
  }
  Write-Host "--> winget install $Id $Note" -ForegroundColor Cyan
  winget install --id $Id --exact --silent `
    --accept-source-agreements --accept-package-agreements
  if ($LASTEXITCODE -ne 0) {
    Write-Warning "[fail] $Id exited with code $LASTEXITCODE"
    $script:Failed += $Id
  }
}

# ---------------------------------------------------------------- winget ---
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
  Write-Error "winget was not found. Install 'App Installer' from the Microsoft Store, then re-run this script."
  exit 1
}

# Core: git (lazy.nvim bootstrap + gitsigns + fugitive + autosave),
# Neovim itself, and the tools fzf-lua shells out to. Always installed.
Install-WingetPackage -Id "Git.Git"                    -Command "git"
Install-WingetPackage -Id "Neovim.Neovim"               -Command "nvim"
Install-WingetPackage -Id "BurntSushi.ripgrep.MSVC"    -Command "rg"
Install-WingetPackage -Id "sharkdp.fd"                  -Command "fd"
Install-WingetPackage -Id "junegunn.fzf"                -Command "fzf"
Install-WingetPackage -Id "sharkdp.bat"                -Command "bat"

# nvim-treesitter (main branch) needs tree-sitter-cli >= 0.26.1 plus
# tar/curl (both ship with Windows 10/11) and a C compiler (see the
# cpp group / -WithVsBuildTools below).
Install-WingetPackage -Id "tree-sitter.tree-sitter-cli" -Command "tree-sitter"

# Small general-purpose compiler fallback, always installed.
Install-WingetPackage -Id "Zig.Zig"                    -Command "zig"

# A patched font so statusline/tabline glyphs render correctly.
Install-WingetPackage -Id "NerdFonts.JetBrainsMono"    -Command "" `
  -Note "(set your terminal font to it afterwards, see windows-install.md)"

if ($WantShell) {
  Write-Host "=== shell group ===" -ForegroundColor Yellow
  Install-WingetPackage -Id "mvdan.shfmt"         -Command "shfmt"
  Install-WingetPackage -Id "OpenJS.NodeJS.LTS"   -Command "node" `
    -Note "(provides npm for bash-language-server)"
}

if ($WantLua) {
  Write-Host "=== lua group ===" -ForegroundColor Yellow
  Install-WingetPackage -Id "JohnnyMorganz.StyLua"      -Command "stylua"
  Install-WingetPackage -Id "LuaLS.lua-language-server" -Command "lua-language-server"
}

if ($WantPython) {
  Write-Host "=== python group ===" -ForegroundColor Yellow
  Install-WingetPackage -Id "astral-sh.uv"   -Command "uv" `
    -Note "(provides Python for ruff/ty; installs 'ty' below)"
  Install-WingetPackage -Id "astral-sh.ruff" -Command "ruff"
}

if ($WantCpp) {
  Write-Host "=== cpp group ===" -ForegroundColor Yellow
  Install-WingetPackage -Id "LLVM.LLVM" -Command "clang-format" `
    -Note "(also provides clang for treesitter parser builds)"
}

if ($WantJava) {
  Write-Host "=== java group ===" -ForegroundColor Yellow
  Install-WingetPackage -Id "Microsoft.OpenJDK.21" -Command "java" `
    -Note "(required by jdtls)"
}

if ($WantRust) {
  Write-Host "=== rust group ===" -ForegroundColor Yellow
  Install-WingetPackage -Id "Rustlang.Rustup" -Command "cargo" `
    -Note "(provides cargo/rustfmt; installs stable toolchain below)"
}

if ($WantTex) {
  Write-Host "=== tex group ===" -ForegroundColor Yellow
  # LaTeX: viewer for vimtex + Perl for latexindent (conform).
  Install-WingetPackage -Id "SumatraPDF.SumatraPDF"         -Command "SumatraPDF"
  Install-WingetPackage -Id "StrawberryPerl.StrawberryPerl"  -Command "perl"
}

if ($WithVsBuildTools) {
  # Installed separately (not via the helper) because it needs the
  # workload override to include the C++ compiler.
  if (Get-Command cl -ErrorAction SilentlyContinue) {
    Write-Host "[ok] cl already on PATH (VS Build Tools present)" -ForegroundColor Green
  } else {
    Write-Host "--> winget install Microsoft.VisualStudio.2022.BuildTools (+ VCTools workload)" -ForegroundColor Cyan
    winget install --id Microsoft.VisualStudio.2022.BuildTools --exact --silent `
      --accept-source-agreements --accept-package-agreements `
      --override "--wait --passive --add Microsoft.VisualStudio.Workload.VCTools"
    if ($LASTEXITCODE -ne 0) {
      Write-Warning "[fail] VS Build Tools exited with code $LASTEXITCODE"
      $script:Failed += "Microsoft.VisualStudio.2022.BuildTools"
    }
  }
}

# ------------------------------------------------- refresh PATH in-session ---
# winget updates the machine/user PATH; pick that up without a reboot.
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + `
            [System.Environment]::GetEnvironmentVariable("Path", "User")

# 'ty' (Python type checker / LSP) ships via uv; make sure its bin dir is
# on the user PATH so Neovim can find it.
$UvBin = Join-Path $HOME ".local\bin"
if ($WantPython) {
  if ((Get-Command uv -ErrorAction SilentlyContinue) -and -not (Get-Command ty -ErrorAction SilentlyContinue)) {
    Write-Host "--> uv tool install ty" -ForegroundColor Cyan
    uv tool install ty
    if ($LASTEXITCODE -ne 0) { $script:Failed += "uv tool install ty" }
  }
  $UserPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
  if ($UserPath -notlike "*$UvBin*") {
    [System.Environment]::SetEnvironmentVariable("Path", "$UserPath;$UvBin", "User")
    $env:Path += ";$UvBin"
    Write-Host "[ok] added $UvBin to user PATH (log out/in to finalize)" -ForegroundColor Green
  }
}

# rust-analyzer needs nothing extra, but rustfmt (conform) and cargo
# need a toolchain: install stable via rustup if it's missing.
if ($WantRust -and (Get-Command rustup -ErrorAction SilentlyContinue) -and -not (Get-Command cargo -ErrorAction SilentlyContinue)) {
  Write-Host "--> rustup toolchain install stable --profile minimal" -ForegroundColor Cyan
  rustup toolchain install stable --profile minimal
  if ($LASTEXITCODE -ne 0) { $script:Failed += "rustup toolchain install stable" }
}

# Point the C-compiler probe at LLVM clang when MSVC is not installed.
# (The officially recommended setup is -WithVsBuildTools instead.)
if (-not (Get-Command cl -ErrorAction SilentlyContinue)) -and (Get-Command clang -ErrorAction SilentlyContinue)) {
  [System.Environment]::SetEnvironmentVariable("CC", "clang", "User")
  $env:CC = "clang"
  Write-Host "[ok] CC=clang registered for treesitter parser builds" -ForegroundColor Green
} elseif (-not (Get-Command cl -ErrorAction SilentlyContinue) -and -not (Get-Command clang -ErrorAction SilentlyContinue)) {
  Write-Warning "[skip] no C compiler (cl/clang) found; treesitter parser builds need one."
  Write-Warning "       Re-run with '-Languages <groups>,cpp' or '-WithVsBuildTools' if ':TSUpdate' fails."
}

# ------------------------------------------------------------- symlink -------
if (-not $SkipSymlink) {
  $Source = Join-Path $PSScriptRoot ".config" "nvim"
  $Target = Join-Path $env:LOCALAPPDATA "nvim"
  if (-not (Test-Path $Source)) {
    Write-Warning "[fail] config source not found: $Source (did you move this script?)"
    $Failed += "symlink (source missing)"
  } elseif (Test-Path $Target) {
    $Item = Get-Item $Target -Force
    $PointsAtSource = $Item.LinkType -eq "SymbolicLink" -and $Item.Target -eq $Source
    if ($PointsAtSource) {
      Write-Host "[ok] %LOCALAPPDATA%\nvim already links to this repo" -ForegroundColor Green
    } else {
      Write-Warning "[skip] $Target already exists and is not our link; move it aside, then re-run (see windows-install.md)."
      $Failed += "symlink (target exists)"
    }
  } else {
    try {
      New-Item -ItemType SymbolicLink -Path $Target -Target $Source -ErrorAction Stop | Out-Null
      Write-Host "[ok] linked $Target -> $Source" -ForegroundColor Green
    } catch {
      Write-Warning "[fail] could not create symlink (enable Developer Mode or run as admin): $_"
      $Failed += "symlink (see windows-install.md)"
    }
  }
}

# ----------------------------------------------------------------- Mason -----
# mason.nvim is enabled in this config; install the servers that have no
# winget package (or are easier to manage via Mason). This takes two
# headless invocations: first sync all plugins with lazy.nvim (blocking),
# then install the Mason packages with an explicit wait loop, because
# :MasonInstall returns immediately and `+qa` would abort it mid-install.
if (-not $SkipMason) {
  if (Get-Command nvim -ErrorAction SilentlyContinue) {
    Write-Host "--> nvim --headless (sync plugins via lazy.nvim)" -ForegroundColor Cyan
    nvim --headless "+Lazy! sync" "+qa" 2>&1 | Out-Null
    # Only the servers for the selected language groups. Mapping:
    #   shell -> bash-language-server | lua -> (winget lua-language-server)
    #   python -> (winget ruff + uv ty) | java -> jdtls
    #   rust -> rust-analyzer | tex -> latexindent | cpp -> (winget clang-format)
    $MasonPkgs = @()
    if ($WantShell) { $MasonPkgs += "bash-language-server" }
    if ($WantJava)  { $MasonPkgs += "jdtls" }
    if ($WantRust)  { $MasonPkgs += "rust-analyzer" }
    if ($WantTex)   { $MasonPkgs += "latexindent" }
    $MasonScript = Join-Path ([System.IO.Path]::GetTempPath()) "nvim-mason-setup.lua"
    if ($MasonPkgs.Count -eq 0) {
      Write-Host "[ok] no Mason packages needed for the selected language groups" -ForegroundColor Green
    } else {
    # Pass the package list into the Lua script via an env var (avoids
    # quoting a PowerShell array into Lua source).
    $env:NVIM_MASON_PKGS = $MasonPkgs -join ","
    @'
local pkgs = {}
for name in string.gmatch(os.getenv("NVIM_MASON_PKGS") or "", "[^,]+") do
  table.insert(pkgs, name)
end
vim.opt.rtp:append(vim.fn.stdpath("data") .. "/lazy/mason.nvim")
local has_registry, registry = pcall(require, "mason-registry")
if not has_registry then
  io.stderr:write("mason-registry not available (did Lazy sync fail?)\n")
  vim.cmd("cquit 1")
end
require("mason").setup()
registry.refresh(function()
  for _, name in ipairs(pkgs) do
    local found, pkg = pcall(registry.get_package, name)
    if found and not pkg:is_installed() then
      pkg:install()
    end
  end
end)
local done = vim.wait(300000, function()
  for _, name in ipairs(pkgs) do
    local found, pkg = pcall(registry.get_package, name)
    if not (found and pkg:is_installed()) then
      return false
    end
  end
  return true
end, 1000)
if not done then
  io.stderr:write("timed out waiting for Mason packages\n")
  vim.cmd("cquit 1")
end
'@ | Set-Content -Path $MasonScript -Encoding utf8
    Write-Host ("--> nvim --headless (MasonInstall {0})" -f ($MasonPkgs -join ", ")) -ForegroundColor Cyan
    nvim --headless -l $MasonScript 2>&1 | Out-Null
    Remove-Item Env:\NVIM_MASON_PKGS -ErrorAction SilentlyContinue
    Remove-Item $MasonScript -ErrorAction SilentlyContinue
    if ($LASTEXITCODE -ne 0) {
      Write-Warning "[fail] Mason package install (open nvim and run :MasonInstall <name> manually)"
      $Failed += "MasonInstall (see windows-install.md)"
    }
    } # end if ($MasonPkgs.Count -eq 0) else
  } else {
    Write-Warning "[skip] nvim not on PATH yet; open a new terminal and run :Mason manually."
    $Failed += "MasonInstall (nvim not on PATH)"
  }
}

# ------------------------------------------------------------ health check ---
Write-Host ""
Write-Host "=== tool versions ===" -ForegroundColor Yellow
$VersionArg = @{ zig = "version" }  # `zig --version` is invalid; it's `zig version`
# Binaries Mason drops into nvim-data are NOT on the terminal PATH
# (mason.nvim prepends them inside Neovim only); probe their real path.
$MasonBin = Join-Path $env:LOCALAPPDATA "nvim-data\mason\bin"
$ProbePath = @{
  "rust-analyzer" = Join-Path $MasonBin "rust-analyzer.exe"
}
$CheckCmds = @("nvim", "git", "rg", "fd", "fzf", "bat", "tree-sitter", "zig")
if ($WantShell)  { $CheckCmds += @("shfmt", "node") }
if ($WantLua)    { $CheckCmds += @("stylua", "lua-language-server") }
if ($WantPython) { $CheckCmds += @("uv", "ty", "ruff") }
if ($WantCpp)    { $CheckCmds += @("clang-format") }
if ($WantJava)   { $CheckCmds += @("java") }
if ($WantRust)   { $CheckCmds += @("cargo", "rustc", "rust-analyzer") }
if ($WantTex)    { $CheckCmds += @("perl") }
foreach ($cmd in $CheckCmds) {
  if ($ProbePath.ContainsKey($cmd)) {
    if (Test-Path $ProbePath[$cmd]) {
      $ver = try { (& $ProbePath[$cmd] --version 2>$null | Select-Object -First 1) } catch { "?" }
      Write-Host ("  {0,-20} {1}  (via Mason)" -f $cmd, $ver)
    } else {
      Write-Host ("  {0,-20} MISSING (run :MasonInstall {0})" -f $cmd) -ForegroundColor Red
    }
    continue
  }
  $found = Get-Command $cmd -ErrorAction SilentlyContinue
  if ($found) {
    $arg = if ($VersionArg.ContainsKey($cmd)) { $VersionArg[$cmd] } else { "--version" }
    $ver = try { (& $cmd $arg 2>$null | Select-Object -First 1) } catch { "?" }
    Write-Host ("  {0,-20} {1}" -f $cmd, $ver)
  } else {
    Write-Host ("  {0,-20} MISSING" -f $cmd) -ForegroundColor Red
  }
}

Write-Host ""
if ($Failed.Count -eq 0) {
  Write-Host "All done. Open a NEW terminal and run nvim." -ForegroundColor Green
} else {
  Write-Warning "Finished with $($Failed.Count) issue(s): $($Failed -join ', ')"
  Write-Warning "See windows-install.md for the manual fallbacks."
}
