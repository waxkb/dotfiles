# 1. Reduce the "Settling Time"
# latexmk waits for 'recorder' files to stabilize. 
# Reducing this makes it react faster to your :w
$sleep_time = 0.1; 

# 2. Use a faster previewer update method
# Since you use Zathura, it handles refreshes via file signals.
# This ensures latexmk doesn't 'pause' to ask the viewer to update.
$pdf_update_method = 2;
$pdf_update_signal = 'SIGHUP';

# 3. Silence the "Checking" logs
# This reduces the processing time latexmk spends parsing its own logs.
$silent = 1;

# 4. Don't pause on errors
# If you make a typo, latexmk won't hang waiting for input.
# It will just finish the fail-run and wait for your next fix.
$force_mode = 1;
