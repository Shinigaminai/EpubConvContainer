!/bin/sh

file_modified() {
    TIMESTAMP=$(date)
    echo "[$TIMESTAMP]: The file $1$2 was modified" >>monitor_log
}

file_created() {
    TIMESTAMP=$(date)
    echo "[$TIMESTAMP]: The file $1$2 was created" >>monitor_log
    if [[ $2 == =~ \.odw$ ]]
    then
        libreoffice --headless --convert-to epub $1$2
    fi
}

echo "Setting up upload folder monitoring"
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
