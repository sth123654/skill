; button_window.il
; Cadence SKILL script: creates a window with a button.
; Clicking the button executes run_script.sh via the shell.
;
; Usage (in Cadence CIW or load from .cdsinit):
;   load("button_window.il")
;   createButtonWindow()

; ---------------------------------------------------------------------------
; Callback: invoked when the user clicks the button
; ---------------------------------------------------------------------------
procedure( buttonWindowCallback()
  let( (scriptPath result)

    ; Build an absolute path to run_script.sh that lives beside this file.
    ; hiGetPoint returns nil in a load context, so we resolve the path
    ; relative to the Cadence working directory.  Adjust the path below if
    ; you keep the shell script in a different location.
    scriptPath = strcat( simplifyFilename("./") "/" "run_script.sh" )

    printf("INFO: Executing shell script: %s\n" scriptPath)

    ; ipcBeginProcess launches an external process asynchronously.
    result = ipcBeginProcess(
      strcat("bash " scriptPath)
      ""                             ; input string (none)
      'buttonWindowOutputCallback    ; stdout callback
      'buttonWindowOutputCallback    ; stderr callback
      'buttonWindowDoneCallback      ; done callback
    )

    if( result == nil
      then
        warn("buttonWindowCallback: failed to launch shell script '%s'" scriptPath)
      else
        printf("INFO: Shell script process started (pid handle: %L)\n" result)
    )
  )
) ; procedure buttonWindowCallback

; ---------------------------------------------------------------------------
; ipcBeginProcess output handler
; ---------------------------------------------------------------------------
procedure( buttonWindowOutputCallback(pid data)
  printf("SCRIPT OUTPUT: %s" data)
) ; procedure buttonWindowOutputCallback

; ---------------------------------------------------------------------------
; ipcBeginProcess done handler
; ---------------------------------------------------------------------------
procedure( buttonWindowDoneCallback(pid exitCode)
  printf("INFO: Shell script finished with exit code %d\n" exitCode)
) ; procedure buttonWindowDoneCallback

; ---------------------------------------------------------------------------
; Main entry point: build and display the window
; ---------------------------------------------------------------------------
procedure( createButtonWindow()
  let( (runButton theForm)

    ; Create the button that will call the shell script
    runButton = hiCreateButton(
      ?name        'runScriptButton
      ?buttonText  "Execute Shell Script"
      ?callback    "buttonWindowCallback()"
    )

    ; Create the form (window) and embed the button
    theForm = hiCreateAppForm(
      ?name         'buttonWindowForm
      ?formTitle    "SKILL Button Window"
      ?fields       list( runButton )
      ?buttonLayout 'Close
    )

    ; Display the window (non-modal)
    hiFormDisplay( theForm )

    printf("INFO: Button window opened.\n")
  )
) ; procedure createButtonWindow
