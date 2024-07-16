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
create_table() {
    read -p "Enter table name:- " table_name

    if [[ "$table_name" =~ [[:space:][:punct:]] ]]
    then
        echo "Invalid name. No spaces or special characters allowed."
        return
    fi

    if [[ -z "$table_name" ]]
    then
        echo "Invalid name. Please enter a valid name."
        return
    fi

    if [ -f "$table_name" ]
    then
        echo "Table already exists."
    else
        touch "$table_name"

        read -p "Enter number of fields:- " num_columns
        echo Please enter the ID field in the first box.

        declare -A fields
        header=""
        
        for (( i=1; i<=num_columns; i++ ))
        do
            read -p "Enter field $i name:- " col_name
            read -p "Enter field $i type (int/string):- " col_type
            fields[$col_name]=$col_type
            header+="$col_name($col_type):"

        done

        header=${header::-1}

        echo "$header" > "${table_name}.meta"

        echo "Table ($table_name) created."
    fi
}


# 2. List tables
list_tables() {
    # ls -p | grep -v /
    echo "Tables:- "
    ls -F | grep -v /
}


# 3. Drop Table
drop_table() {
    read -p "Enter table name:- " table_name

    if [[ "$table_name" =~ [[:space:][:punct:]] ]]
    then
        echo "Invalid name. No spaces or special characters allowed."
        return
    fi

    if [[ -z "$table_name" ]]
    then
        echo "Invalid name. Please enter a valid name."
        return
    fi

    if [ -f "$table_name" ]
    then
        rm "$table_name" "${table_name}.meta"
        echo "Table ($table_name) deleted."
    else
        echo "Table does not exist."
    fi
}


#4. Inser into Table
insert_into_table() {
    list_tables_not_meta

    read -p "Enter table name:- " table_name

    if [[ "$table_name" =~ [[:space:][:punct:]] ]]
    then
        echo "Invalid name. No spaces or special characters allowed."
        return
    fi

    if [[ -z "$table_name" ]]
    then
        echo "Invalid name. Please enter a valid name."
        return
    fi

    if [[ -f "$table_name.meta" && -f "$table_name" ]]
    then
        columns=$(cat "$table_name.meta")
        echo "Columns: $columns"
        cat "$table_name"
        
        IFS=':' read -r -a col_array <<< "$columns"
        entry=""
        
        for col in "${col_array[@]}"
        do
            IFS=':' read -r -a col_def <<< "$col"
            
            read -p "Enter ${col_def[0]}:- " value

            entry+="$value:"
        done

        entry=${entry%:}
        echo "$entry" >> "$table_name"
        echo "Inserted into '$table_name'."
        
    else
        echo "Table ($table_name) not found."
    fi


}




# 5. Select From Table



select_from_table() {
    
    read -p "Enter table name:- " table_name
    
    if [[ "$table_name" =~ [[:space:][:punct:]] ]]
    then
        echo "Invalid name. No spaces or special characters allowed."
        return
    fi

    if [[ -z "$table_name" ]]
    then
        echo "Invalid name. Please enter a valid name."
        return
    fi


    if [ -f "$table_name" ]
    then
        echo "Select an option:- "
        echo "1. Select all"
        echo "2. Select by column"
        echo "3. Select by id"
        
        read -p "Enter choice:- " choice

        case $choice in
            1) 
                cat "$table_name.meta"
                cat "$table_name"
                ;;
            
            2)
                select_by_column "$table_name" 
                ;;

            3)
                select_by_id "$table_name" 
                ;;

            *) 
                echo "Invalid choice" 
                ;;
        esac

    else
        echo "Table does not exist."
        return
    fi


}
select_by_column() {
    meta_file="$table_name.meta"
    data_file="$table_name"

    IFS=':' read -r -a columns < "$meta_file"

    echo "Select a column to display (select a number):- "
    for i in "${!columns[@]}"
    do
        echo "$(($i + 1)). ${columns[$i]}"
    done

    read -p "Enter choice: " choice
    choice=$((choice - 1))

    if [ $choice -ge 0 ] && [ $choice -lt ${#columns[@]} ]
    then
        column_name=${columns[$choice]}
        echo "Selected column: $column_name"

        awk -v col=$((choice + 1)) -F':' '
        {
            print $col
        }
        ' "$data_file"
    else
        echo "Invalid choice."
    fi
}
select_by_id() {
    data_file="$table_name"

    mapfile -t data < "$data_file"

    echo "Available IDs:- "
    for i in "${!data[@]}"
    do
        IFS=':' read -r -a fields <<< "${data[$i]}"
        echo "ID: ${fields[0]}"
    done

    read -p "Enter ID choice: " choice_id

    found=false

    for i in "${!data[@]}"
    do
        IFS=':' read -r -a fields <<< "${data[$i]}"
        if [ "${fields[0]}" == "$choice_id" ]
        then
            echo "Selected data: ${data[$i]}"
            found=true
            break
        fi
    done

    if [ "$found" = false ]
    then
        echo "ID not found."
    fi
}

# 6. Delete From Table


# 7. Update Table


# 8. Disconnect
disconnect() {
    cd ..
    main_menu
}




# Start the application
main_menu

