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
echo 


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
                exit 
                # break
                ;;
        
            *) 
                echo "Invalid choice"
                ;;
        esac
    done

}


# 1 = Create a new database
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
    ls -d *
}


# 4 = drop database
drop_database() {
    list_databases

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


    if ! [ -d "$db_name" ]
    then
        echo "Database ($db_name) does not exist."
        return
    fi

    read -p "Are you sure you want to delete the database? (y/n):- " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]
    then 
        rm -r "$db_name"
        echo "Database ($db_name) deleted."
    fi
}


# 3 = Contact DB
connect_to_database() {
    list_databases

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
        cd "$db_name"
        echo `pwd`
        database_menu
    else
        echo "Database ($db_name) does not exist."
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

        read -p "Enter choice:- " choice

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

# Display tables without .meta
list_tables_not_meta () {
    echo "Tables:- "
    ls -p | grep -v / | grep -v '\.meta$'
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

    if [[ -f "$table_name" || -f "$table_name.meta" ]]
    then
        echo "Table ($table_name) already exists."
    else
        touch "$table_name"

        read -p "Enter number of fields:- " num_columns
        if [[ "$num_columns" =~ [[:space:][:punct:]] ]]
        then
            echo "Invalid number. No spaces or special characters allowed."
            return
        fi

        if ! [[ "$num_columns" =~ ^[0-9]+$ ]]
        then
            echo "Invalid number. Please enter a valid number."
            return
        fi

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
    echo "Tables:- "
    ls -p | grep -v /
    # ls -F | grep -v /
}


# 3. Drop Table
drop_table() {
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



    if ! [ -f "$table_name" ]
    then
        echo "Table ($table_name) does not exist."
        return
    fi

    read -p "Are you sure you want to delete the table? (y/n):- " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]
    then 
        rm -f "$table_name" "${table_name}.meta"
        echo "Table ($table_name) deleted."
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

    read -p "Enter ID choice:- " choice_id

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
delete_from_table() {
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

    if [ -f "$table_name" ]
    then
    
        echo "Select an option:- "
        echo "1. Delete all"
        echo "2. Delete by column"
        
        read -p "Enter choice:- " choice

        case $choice in
            1) 
                delete_all_data "$table_name" 
                ;;

            2) 
                delete_by_column "$table_name" 
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
delete_all_data() {
    data_file="$table_name"

    read -p "Are you sure you want to delete all data? (y/n):- " confirm

    if [[ "$confirm" =~ ^[Yy]$ ]]
    then
        > "$data_file"
        echo "All data has been deleted."
    else
        echo "Operation cancelled."
    fi
}
delete_by_column() {
    data_file="$table_name"
    meta_file="$table_name.meta"

    read -p "Are you sure you want to delete column ? (y/n):- " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]
    then 
        return
    fi
    

    cat $meta_file
    read -p "Enter column name:- " column_name

    if [[ "$column_name" =~ [[:space:][:punct:]] ]]
    then
        echo "Invalid value. No spaces or special characters allowed."
        return
    fi

    if ! grep -q -w "$column_name" "$meta_file"
    then
        echo "Column name ($column_name) not found in the file ($meta_file)."
        return
    fi

    cat $data_file

    read -p "Enter value to delete by:- " value

    if [[ "$value" =~ [[:space:][:punct:]] ]]
    then
        echo "Invalid value. No spaces or special characters allowed."
        return
    fi

    if ! grep -q -w "$value" "$data_file"
    then
        echo "Value not found in the file."
        return
    fi

    grep -v -w -F -e "$value" "$data_file" > tmp_file && mv tmp_file "$data_file"
    echo "Rows with ($column_name) = ($value) have been deleted."
}


# 7. Update Table
update_table() {
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

    data_file="$table_name" 
    meta_file="$table_name.meta"

    echo "Select the column (number) you want to update:- "
    columns=$(head -n 1 "$meta_file" | tr ':' '\n')
    
    select column in $columns
    do
        if [[ -n "$column" ]]
        then
            break
        else
            echo "Invalid selection. Please try again."
        fi
    done

    echo "Current rows in the table:- "
    cat "$data_file"
    echo 

    read -p "Enter the (ID) of the row to update:- " id

    if ! grep -q "^$id:" "$data_file"
    then
        echo "ID not found in the table."
        return
    fi

    read -p "Enter the new value for $column:- " new_value

    old_row=$(grep "^$id:" "$data_file")
    IFS=':' read -r -a row_array <<< "$old_row"
    column_index=$(echo "$columns" | nl -w1 -s: | grep -w "$column" | cut -d: -f1)

    row_array[$((column_index - 1))]="$new_value"
    new_row=$(IFS=:; echo "${row_array[*]}")

    grep -v "^$id:" "$data_file" > tmp_file
    echo "$new_row" >> tmp_file
    mv tmp_file "$data_file"

    echo "Row updated successfully."

}


# 8. Disconnect
disconnect() {
    cd ..
    main_menu
}




# Start the application
main_menu

