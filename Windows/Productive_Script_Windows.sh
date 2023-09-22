### Copy only folder structure in windows
xcopy /t /e "C:\Your Folder" "C:\New Folder"
# /t = Copies the subdirectory structure, but not the files

# /e = Copies subdirectories, including any empty ones

## or using following command
robocopy "C:\Your Folder" "C:\New Folder" /e /xf *
# same as above but without displaying the status:
robocopy "C:\Your Folder" "C:\New Folder" /e /xf * >null
# same as above and creates a log (overwrites existing log):
robocopy "C:\Your Folder" "C:\New Folder" /e /xf * /log:yourlogfile.log
# same as above and appends to log (appends to existing log):
robocopy "C:\Your Folder" "C:\New Folder" /e /xf * /log+:yourlogfile.log
# /e = Copies subdirectories, including empty ones.

# /xf = Excludes files matching the specified names or paths. Wildcards “*” and “?” are accepted