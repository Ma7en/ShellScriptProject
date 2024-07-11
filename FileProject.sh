#!/bin/bash

# Main Menu
main_menu() {
  echo "Main Menu:"
  echo "1. Create Database"
  echo "2. List Databases"
  echo "3. Connect To Database"
  echo "4. Drop Database"
  echo "5. Exit"
  read -p "Choose an option: " option

  case $option in
    1) create_database ;;
    2) list_databases ;;
    3) connect_to_database ;;
    4) drop_database ;;
    5) exit 0 ;;
    *) echo "Invalid option"; main_menu ;;
  esac
}

# Functions for Main Menu
create_database() {
  read -p "Enter database name: " db_name
  mkdir -p "$db_name" && echo "Database '$db_name' created."
  main_menu
}

list_databases() {
  echo "Databases:"
  ls -d */
  main_menu
}

connect_to_database() {
  read -p "Enter database name: " db_name
  if [ -d "$db_name" ]; then
    cd "$db_name" || exit
    database_menu "$db_name"
  else
    echo "Database '$db_name' not found."
    main_menu
  fi
}

drop_database() {
  read -p "Enter database name to drop: " db_name
  rm -r "$db_name" && echo "Database '$db_name' dropped."
  main_menu
}

database_menu() {
  local db_name=$1
  echo "Connected to '$db_name' database."
  echo "Database Menu:"
  echo "1. Create Table"
  echo "2. List Tables"
  echo "3. Drop Table"
  echo "4. Insert into Table"
  echo "5. Select From Table"
  echo "6. Delete From Table"
  echo "7. Update Table"
  echo "8. Disconnect"
  read -p "Choose an option: " option

  case $option in
    1) create_table ;;
    2) list_tables ;;
    3) drop_table ;;
    4) insert_into_table ;;
    5) select_from_table ;;
    6) delete_from_table ;;
    7) update_table ;;
    8) cd ..; main_menu ;;
    *) echo "Invalid option"; database_menu "$db_name" ;;
  esac
}
