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
    case $FILETYPE in
    'application/vnd.oasis.opendocument.text' | 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' | 'application/msword' | 'application/rtf')
        create_epub "$1" "$2"
        ;;
    'application/epub+zip') ;;
    *)
        echo "Not supported filetype $FILETYPE" >>$LOGFILE
        ;;
    esac
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
