
# Table of Contents

1.  [Features](#orgddd9904)
2.  [Notes](#org892d3ab)
    1.  [Startup speed](#org8bdc512)
    2.  [Naming conventions (WIP)](#org9ec5f4f)



<a id="orgddd9904"></a>

# Features

-   **Blazingly fast**.
    
    TTY starts in 0.3s on Mac M1 and 0.8s on a VPS with 1 core CPU and
    1GB RAM. The GUI starts in 0.45s on Mac M1. You can even `export
      EDITOR="emacs -nw"` and feel no perceptible startup difference
    comparing to vim! (See [2.1](#org8bdc512) for additional details.)

-   **Robust**
    
    Package versions are locked and under version control, so no
    breaking changes are expected.

-   **All-around**
    
    This configuration works well on both TTY and GUI. Compatability on
    TTY is not compromised, while GUI features, including `xwidget`, are
    also well-configured.


<a id="org892d3ab"></a>

# Notes


<a id="org8bdc512"></a>

## Startup speed

Startup speed is measured using `(emacs-init-time)`.

However note that this metric may fool you.  If you load some packages
in `emacs-startup-hook` or `after-init-hook`, then `(emacs-init-time)`
cannot properly measure your real startup time. Packages loaded at
`emacs-start-hook` and `after-init-hook` are actually not lazy loaded,
they are loaded during your startup anyway. Using those hooks only
fools `(emacs-init-time)` and contributes nothing to the startup
time. This configuration tries to be honest and truly lazy loads.


<a id="org9ec5f4f"></a>

## Naming conventions (WIP)

-   A symbol prefixed with `my:` indicates it is a function.

-   A symbol prefixed with `my$` indicates it is a variable.

-   A symbol prefixed with `my%` indicates it is a macro.

-   A symbol prefixed with `my~` indicates it is a mode.
    
    (or variables/functions bounded by that mode. e.g. `my~foo-mode` or
    `my~foor-mode-hook`).

-   A symbol prefixed with `my*` indicates it is generated via closure or macro.

-   A symbol prefixed with `my&` indicates it is a special symbol like faces.

