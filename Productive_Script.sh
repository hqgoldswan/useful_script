# File and folder manipulation
## Copy only folder structure
cd source_dir
find . -type d -depth | cpio -dumpl destination_dir

    cd destination/dir
    find /source/dir -type d -printf "%P\n" | xargs mkdir -p

    ### If you have rsync
    rsync -avz -e ssh --include '*/' --exclude '*' local_source_dir user@host:/dest_dir
    ### Using rsync
    
## Copy all specific file type to "target" folder from "source" folder, keeping folder structure
rsync -a --prune-empty-dirs --include '*/' --include '*.csv' --exclude '*' source/ target/

## Copy all file except one "thefoldertoexclude" folder
rsync -av --progress sourcefolder /destinationfolder --exclude thefoldertoexclude

## find a specific file in a directory/sub-directory
find . -name "*.docx" -type f

## find then remove a specific file in a directory/sub-directory
find . -name "*.docx" -type f -delete

## Remove all file excep folder/file A
rm -rf !(A)

# find who is currently login
w

# Compress file and folder
## Create archive MyProject.20090816 from MyProject sub-directory
tar cvf MyProject.20090816.tar MyProject

## zip file => MyProject.20090816.tar.gz
gzip MyProject.20090816.tar

## Create tar-zipped file => MyProject.20090816.tar.gz
tar czvf MyProject.20090816.tgz MyProject

## Create tar-zipped for current folder
tar czvf myDirectory.tgz .

## Untar a tgz file
tar xzvf MyProject.20090816.tgz

# Split file into multiple smaller files
split -b size_in_byte need_to_split_filename target_filename_prefix
split -l number_of_text_line text_filename_need_to_be_split tartget_text_filename_prefix

## Split in another size unit
### Multiplier: 1000
split -KB
### Multiplier: 1024
split -K
### Multiplier: 1000x1000
split -MB
### Multiplier: 1024x1024
split -M
### G (gigabyte), T (Terabytes), P (betabytes), E (exabytes), Z (zettabytes), Y (yottabytes)

## Combine split files into one
cat splitte_file_name_prefix* > joined_file_name

# Convert binary file to header file
xxd -i binary_file_name > outputfile.h