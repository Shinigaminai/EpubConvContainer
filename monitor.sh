#!/bin/sh

LOGFILE=/usr/share/nginx/html/monitor.log

file_modified() {
    TIMESTAMP=$(date)
    echo "[$TIMESTAMP]: The file $1$2 was modified" >>$LOGFILE

file_created() {
    TIMESTAMP=$(date)
    FILETYPE=$(file --mime-type -b $2)
    echo "[$TIMESTAMP]: The file $1$2 of type $FILETYPE was created" >>$LOGFILE
    libreoffice --headless --convert-to epub $1$2 >>$LOGFILE
    mv "${FILE%.*}.epub" /usr/share/nginx/files/
}

echo "Setting up upload folder monitoring"
echo "Monitoring started" >$LOGFILE
inotifywait -q -m -r -e modify,create /usr/share/nginx/files | while read DIRECTORY EVENT FILE; do
    case $EVENT in
    MODIFY*)
        file_modified "$DIRECTORY" "$FILE"
        ;;
    CREATE*)
        file_created "$DIRECTORY" "$FILE"
        ;;
    esac
done
