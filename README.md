# skill

## SKILL Button Window

This project demonstrates a Cadence SKILL GUI window containing a **Button** that executes a shell script when clicked.

### Files

| File | Description |
|------|-------------|
| `button_window.il` | SKILL script – creates the window and wires up the button callback |
| `run_script.sh`    | Shell script that is invoked when the button is clicked |

### How it works

1. **`button_window.il`** defines three procedures:
   - `createButtonWindow()` – builds a `hiCreateAppForm` window with a single `hiCreateButton` and displays it.
   - `buttonWindowCallback()` – called when the button is clicked; uses `ipcBeginProcess` to run `run_script.sh` asynchronously.
   - `buttonWindowOutputCallback` / `buttonWindowDoneCallback` – print the script's stdout/stderr and exit code to the CIW log.

2. **`run_script.sh`** is a plain Bash script.  Replace its body with whatever shell commands your workflow requires.

### Usage

1. Open Cadence Virtuoso and make sure the working directory contains both files, **or** edit the `scriptPath` variable inside `button_window.il` to point to the absolute location of `run_script.sh`.

   Make `run_script.sh` executable (first-time setup):
   ```bash
   chmod +x run_script.sh
   ```

2. Load the SKILL file from the CIW (Command Interpreter Window):

   ```skill
   load("button_window.il")
   ```

   Or add the line above to your `.cdsinit` so it is loaded automatically on startup.

3. Open the window:

   ```skill
   createButtonWindow()
   ```

4. Click **"Execute Shell Script"** in the window.  Output from the script appears in the CIW log.

### Customising the shell script

Edit `run_script.sh` to perform any task – running simulations, post-processing results, sending notifications, etc.  The script is executed with `bash`, so any valid Bash code is supported.
