 #When running the file, check the database folder exists or not.
 #!/bin/bash
if [ ! -d "./DB" ]
then
    echo "Database directory does not exist. Creating..."
    mkdir DB
fi
cd DB
echo "Access DB folder"







# main menu 
main_menu() {
    echo "Select an option:- "
    echo "1- Create Database"
    echo "2- List Databases"
    echo "3- Connect To Database"
    echo "4- Drop Database"
    echo "5- Exit"
    read -p "Enter your selection number:- " choice

    case $choice in
        1) 
            create_database 
            ;;

        2) 
            list_databases 
            ;;

        3) 
            connect_to_database 
            ;;

        4) 
            drop_database 
            ;;

        5) 
            # exit 
            break
            ;;
    
        *) 
            echo "Invalid choice"
            ;;
    esac

}



# Start the application
while true
do
    main_menu
done