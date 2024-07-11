#! /usr/bin/bash
shopt -s extglob

#When running the file, check the database folder exists or not.
if [ ! -d "./DB" ]
then
    echo "Database directory does not exist. Creating..."
    mkdir DB
fi
cd DB
echo "Access DB folder"


# Main menu 
main_menu() {
    while true
    do
        
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
    done

}

# 1 = create a new database
create_database() {
    read -p "Enter database name:- " db_name
    if [[ "$db_name" =~ [[:punct:][:space:]] ]]
    then
        echo "Invalid name. No spaces or special characters allowed."
        return
    fi

    if [[ -z "$db_name" ]]
    then
        echo "Invalid name. Please enter a valid name."
        return
    fi

    if [ -d "$db_name" ]
    then
        echo "Database already exists."
    else
        mkdir "$db_name"
        echo "Database ($db_name) created."
    fi
}

# 2 = list DB 
list_databases() {
    ls -d */
}

# 4 = drop database
drop_database() {
    read -p "Enter database name: " db_name
    if [[ "$db_name" =~ [[:punct:][:space:]] ]]
    then
        echo "Invalid name. No spaces or special characters allowed."
        return
    fi

    if [[ -z "$db_name" ]]
    then
        echo "Invalid name. Please enter a valid name."
        return
    fi

    if [ -d "$db_name" ]
    then
        rm -r "$db_name"
        echo "Database ($db_name) deleted."
    else
        echo "Database does not exist."
    fi
}

# 3 = Contact DB 



# Start the application
main_menu
