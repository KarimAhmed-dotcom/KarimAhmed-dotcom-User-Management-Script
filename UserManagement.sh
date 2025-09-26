#!/bin/bash

while true
do
echo "USER-MANAGMENT INTERFACE"
echo "------------------------"
echo "                        "

#menu
first="show system info" 
second="list of users in /bin/bash"
third="search for user"
forth="add user"
fifth="delete user"
sixth="need user details"
seventh="change user password"
eighth="lock user"
ninth="unlock user"
tenth="exit"

echo "1- $first"
echo "2- $second"
echo "3- $third"
echo "4- $forth"
echo "5- $fifth"
echo "6- $sixth"
echo "7- $seventh"
echo "8- $eighth"
echo "9- $ninth"
echo "10- $tenth"

#user_selection
echo "  "
read -p "Please Select Number From This Menu [1..10] : "  usr_selection
 



case $usr_selection in 
	1)
		echo "Processing $first...... "

		option1="general system info"
		option2="hardware configuration"
		option3="CPU architecture"
		
		echo "1- $option1"
		echo "2- $option2"
		echo "3- $option3"

		read -p "plaese select from options[1..3] : " option
		case $option in
			1)
			echo `uname -a`
			;;
			 2)
                        echo `sudo lshw`
                        ;;
			 3)
                        echo `lscpu`
                        ;;
			*)
            		echo "Invalid selection"
           		;;
		esac

		;;
	2)
                echo "Processing $second......"
		awk -F:  '$7=="/bin/bash" { print ++n, $1, $7 }' /etc/passwd
                #cut -d: -f1,7 /etc/passwd | grep "/bin/bash"
	       	;;
	3)
                echo "Processing $third......"
		read -p "Enter User : " user
		echo "Searching..."

		if grep "$user" /etc/passwd > /dev/null; then
    			echo "User '$user' found."
    			grep "$user" /etc/passwd
		else
    			echo "User '$user' not found."
		fi
                ;;
	4)
                echo "Processing $forth........"
		read -p "Enter new username: " username
		if id "$username" &>/dev/null; then
			echo "User '$username' already exists."
		else
			sudo useradd "$username"
			if [ $? -eq 0 ]; then
				echo "User '$username' added successfully."
				read -s -p "Enter password for $username: " password
				echo
				echo "$username:$password" | sudo chpasswd
				echo "Password set successfully."
			else
				echo "Failed to add user '$username'."
			fi
		fi
		
                ;;
	5)
                echo "Processing $fifth........"
		read -p "Enter User Name For Delete : " username

		if id "$username" &>/dev/null; then
    		home_dir=$(eval echo "~$username")
    		backup_dir="/backup_users"

    		sudo mkdir -p "$backup_dir"

    		if [ -d "$home_dir" ] &>/dev/null; then
        		sudo cp -a "$home_dir" "$backup_dir/${username}_backup"
        		echo "Backup created at $backup_dir/${username}_backup"
    		else
        		echo "Warning: Home directory for $username does not exist. Skipping backup."
    		fi

    		sudo userdel -r "$username" &>/dev/null
    		echo "User '$username' deleted."

		else
    			echo "User '$username' does not exist."
		fi		
			
                ;;
	6)
                echo "Processing $sixth........"
		read -p "Enter username to show details: " username
		if id "$username" &>/dev/null; then
			echo "User details for '$username':"
			grep "$username" /etc/passwd
			id "$username"

			home_dir=$(eval echo "~$username")
			if [ -d "$home_dir" ]; then
				echo "The Home Directory For '$username' is $home_dir"
			else 
				echo "No Home Directory For This User.."
			fi
		else
			echo "This User '$username' Does not Exist"
		fi

                ;;
	7)
                echo "Processing $seventh......"
		read -p "Enter User To Change Password : " username
		if id "$username" &>/dev/null; then
			read -s -p "Enter New Passwd : " newpasswd
			echo "$username:$newpasswd" | sudo chpasswd
			if [ $? -eq 0 ]; then 
				echo "Password for '$username' changed successfully."
			else 
				echo "Failed to change password for '$username'."
			fi
		else 
			echo "User Does Not Exist.."
		fi

                ;;
	8)
                echo "Processing $eighth......."
		read -p "Enter username to lock: " username

		if id "$username" &>/dev/null; then
    		sudo usermod -L "$username"

    		if [ $? -eq 0 ]; then
        		echo "User '$username' has been locked."
    		else
        		echo "Failed to lock user '$username'."
    		fi
		else
    			echo "User '$username' does not exist."
		fi
                ;;
	9)
                echo "Processing $ninth......."
		read -p "Enter username to unlock: " username

		if id "$username" &>/dev/null; then
    		sudo usermod -U "$username"

    		if [ $? -eq 0 ]; then
        		echo "User '$username' has been unlocked."
    		else
        		echo "Failed to unlock user '$username'."
    		fi
		else
    			echo "User '$username' does not exist."
		fi
                ;;
	10)
                echo "Processing $tenth......."
          	 break
		;;
		
	 *)
                echo "Invalid selection"
                ;;
esac
echo " "
read -p "Press Enter to return to the menu..."
clear
done
