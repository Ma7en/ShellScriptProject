#! /usr/bin/bash
shopt -s extglob

# When running the file, check the database folder exists or not.
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
    echo "Database:- "
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
connect_to_database() {
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
        cd "$db_name"
        echo pwd
        database_menu
    else
        echo "Database does not exist."
    fi
}
database_menu() {
    while true
    do
        echo "Select an option:- "
        echo "1. Create Table"
        echo "2. List Tables"
        echo "3. Drop Table"
        echo "4. Insert into Table"
        echo "5. Select From Table"
        echo "6. Delete From Table"
        echo "7. Update Table"
        echo "8. Disconnect"

        read -p "Enter choice: " choice

        case $choice in
            1) 
                create_table 
                ;;
            
            2) 
                list_tables 
                ;;
            
            3) 
                drop_table 
                ;;
            
            4) 
                insert_into_table 
                ;;
            
            5) 
                select_from_table 
                ;;
            
            6) 
                delete_from_table 
                ;;
            
            7) 
                update_table 
                ;;
            
            8) 
                disconnect 
                ;;

            
            *) 
                echo "Invalid choice" 
                ;;
        esac
    done
}

# 1. Create table


# 2. List tables
list_tables() {
    # ls -p | grep -v /
    echo "Tables:- "
    ls -F | grep -v /
}

# 3. Drop Table


# 4. Insert into Table


# 5. Select From Table


# 6. Delete From Table


# 7. Update Table


# 8. Disconnect
disconnect() {
    cd ..
    main_menu
}




# Start the application
main_menu

