#!/bin/sh

file_modified() {
    TIMESTAMP=$(date)
    echo "[$TIMESTAMP]: The file $1$2 was modified" >>/monitor.log
}

file_created() {
    TIMESTAMP=$(date)
    FILETYPE=$(file --mime-type -b $2)
    echo "[$TIMESTAMP]: The file $1$2 of type $FILETYPE was created" >>/monitor.log
    libreoffice --headless --convert-to epub $1$2 >>/monitor.log
    mv "${FILE%.*}.epub" /usr/share/nginx/files/
}

echo "Setting up upload folder monitoring"
echo "Monitoring started" >/monitor.log
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
