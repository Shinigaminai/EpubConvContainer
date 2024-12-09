#!/bin/sh

LOGFILE=/usr/share/nginx/html/monitor.log

file_modified() {
    TIMESTAMP=$(date)
    echo "[$TIMESTAMP]: The file $1$2 was modified" >>$LOGFILE
}

file_created() {
    TIMESTAMP=$(date)
    FILETYPE=$(file --mime-type -b $1$2)
    echo "[$TIMESTAMP]: The file $1$2 of type $FILETYPE was created" >>$LOGFILE
    if $FILETYPE | grep -Eq 'application/vnd.oasis.opendocument.text'; then
        create_epub "$1" "$2"
    fi
}

create_epub() {
    libreoffice --headless --convert-to epub $1$2 >>$LOGFILE
    mv "${2%.*}.epub" /usr/share/nginx/files/
}

echo "Setting up upload folder monitoring"
echo "Monitoring started" >$LOGFILE
inotifywait -q -m -e modify,create,moved_to /usr/share/nginx/files | while read DIRECTORY EVENT FILE; do
    case $EVENT in
    MODIFY)
        file_modified "$DIRECTORY" "$FILE"
        ;;
    CREATE | MOVED_TO)
        file_created "$DIRECTORY" "$FILE"
        ;;
    esac
done
