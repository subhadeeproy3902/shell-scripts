echo "*******************************************"
echo "*                                         *"
echo "*            Welcome to Studcrud!         *"
echo "*                                         *"
echo "*******************************************"
echo ""
echo "Studcrud is an intuitive student record management application."
echo "With Studcrud, you can:"
echo "  - Add new student records"
echo "  - Delete existing student records"
echo "  - Sort records by roll number or name"
echo "  - Convert text to uppercase or lowercase"
echo "  - Toggle the case of text"
echo "  - View and manage your student records efficiently."
echo ""
echo "This application is designed to simplify the process of managing student data,"
echo "making it easier for educators and administrators to keep track of student information."
echo ""
echo "Developed by Subhadeep Roy."
echo ""
echo "*******************************************"
echo "*                                         *"
echo "*         Thank you for using Studcrud!   *"
echo "*                                         *"
echo "*******************************************"
echo 
echo
echo
echo
echo "******************************************* MENU *******************************************"
echo
echo
echo "1. Add a student record"
echo "2. Delete a student record"
echo "3. Sort the student records accd to roll number store them in Sorted_roll.dat"
echo "4. Sort the student records acc to name store them in Sorted_name.dat"
echo "5. Convert Lowercase to Uppercase store them in LtoU.dat"
echo "6. Convert Uppercase to Lowercase store them in UtoL.dat"
echo "7. Toggle Case and store in Toggle.dat"
echo "8. Find unique names name store in Temp.dat"
echo "9. Display records in Students.dat"
echo "10. Display records in Sorted_roll.dat"
echo "11. Display records in Sorted_name.dat"
echo "12. Display records in LtoU.dat"
echo "13. Display records in UtoL.dat"
echo "14. Display records in Toggle.dat"
echo "15. Display records in Temp.dat"
echo "16. Exit the application and check github :)"
echo

inf="Students.dat"
outfr="Sorted_roll.dat"
outfn="Sorted_name.dat"
ltou="LtoU.dat"
utol="UtoL.dat"
toggle="Toggle.dat"
tempf="Temp.dat"

for file in "$inf" "$outfr" "$outfn" "$ltou" "$utol" "$toggle" "$tempf"; do
  if [[ ! -f $file ]]; then
    touch "$file"
  fi
done

while true;
do
	echo
	read -p "Enter your choice: " choice
	echo
	case $choice in
		1)
			while true;
			do
				read -p "Enter Student Name: " name
				if [[ -z "$name" ]];
				then
					echo "Name can't be empty. Please enter a valid name."
				else
					break
				fi
			done

			while true;
			do
				read -p "Enter Roll No.: " roll
				if [[ $roll =~ ^[1-9][0-9]*$ ]];
				then
					if grep -q "|$roll|" "$inf";
					then
						echo "Roll number already exists. Please enter a unique roll number"
					else
						break
					fi
				else
					echo "Invalid roll number. Please enter a positive number."
				fi
			done

			while true;
			do
				read -p "Enter phone number (10 digits): " phone
				if [[ $phone =~ ^[0-9]{10}$ ]];
				then
					break
				else
					echo "Invalid Phone Number. Please enter a 10-digit number."
				fi
			done

			while true;
			do
				read -p "Enter address: " address
				if [[ -z "$address" ]];
				then
					echo "Address can't be empty. Please enter a valid address."
				else
					break
				fi
			done

			echo "$name|$roll|$phone|$address" >> "$inf"
			echo "Student record added successfully"
			;;
		2)
			read -p "Enter roll number of the student to delete: " roll
			if grep -q "|$roll|" "$inf";
			then
				t=$(mktemp)
				grep -v "|$roll|" "$inf" > "$t"
				mv "$t" "$inf"
				echo "Student record deleted successfully."
			else
				echo "Roll No. $roll not found in the records."
			fi
			;;
		3)
			read -p "Enter the sorting order (asc/desc): " order
			if [[ "$order" == "asc" ]];
			then
				sort -t '|' -k2,2n "$inf" > "$outfr"
				echo "Student records sorted in ascending order by roll number and saved to $outfr"

			elif [[ "$order" == "desc" ]];
			then
				sort -t '|' -k2,2nr "$inf" > "$outfr"
				echo "Student records sorted in descending order by roll number and saved to $outfr"
			else
				echo "Invalid sorting order. Please enter 'asc' or 'desc'"
			fi
			;;
		4)
			
			read -p "Enter the sorting order (asc/desc): " order
			if [[ "$order" == "asc" ]];
			then
				sort -t '|' -k1,2n "$inf" > "$outfn"
				echo "Student records sorted in ascending order by name and saved to $outfn"
			elif [[ "$order" == "desc" ]];
			then
				sort -t '|' -k1,2nr "$inf" > "$outfn"
				echo "Student records sorted in descending order by name and saved to $outfn"
			else
				echo "Invalid sorting order. Please enter 'asc' or 'desc'"
			fi
			;;
		5)
			tr '[:lower:]' '[:upper:]' < "$inf" > "$ltou"
			echo "Converted lowercase to uppercase and saved to $ltou."
			;;
		6)
			tr '[:upper:]' '[:lower:]' < "$inf" > "$utol"
			echo "Converted uppercase to lowercase and saved to $utol."
			;;
		7)
			awk '{
				for(i=1;i<=length($0);i++) {
					c=substr($0,i,1);
					if (c ~ /[a-z]/)
						printf "%s", toupper(c);
					else if (c ~ /[A-Z]/)
						printf "%s", tolower(c);
					else
						printf "%s", c;
				}
				printf "\n";
			}' "$inf" > "$toggle"
			echo "Toggled case and saved to $toggle."
			;;
		8)
			if [[ ! -s $inf ]];
			then
				echo "The file is empty."
			else
				names=$(cut -d '|' -f1 "$inf" | sort -u) : > "$tempf"
				for n in $names;
				do
					grep "^$n|" "$inf" | head -1 >> "$tempf"
				done
				echo "All the unique student records have been saved in $tempf."
			fi
			;;	
		9)
			if [[ ! -s $inf ]];
			then
				echo "The file is empty."
			else
				read -p "Do you want to display all records or specific records? (all/range): " display
				echo
				if [[ "$display" == "all" ]];
				then
					awk -F'|' 'BEGIN {printf "%-20s %-30s %-30s %-30s\n", "Name", "Roll", "Phone", "Address"; print "----------------------------------------------------------------------------------------------" }
				{ printf "%-20s %-30s %-30s %-30s\n", $1, $2, $3, $4 }' "$inf"
				elif [[ "$display" == "range" ]];
				then
					while true;
					do
						read -p "Enter the start line number: " start
						read -p "Enter the destination line number: " end
						echo
						if [[ "$start" =~ ^[0-9]+$ ]] && [[ "$end" =~ ^[0-9]+$ ]] && [[ "$start" -gt 0 ]] && [[ "$end" -gt 0 ]];
						then
							total=$(wc -l < "$inf")
							if [[ "$start" -le "$end" ]] && [[ "$end" -le "$total" ]];
							then
								awk -v start="$start" -v end="$end" -F'|' 'NR>=start && NR<=end { printf "%-20s %-30s %-30s %-30s\n", $1, $2, $3, $4 }' "$inf"
							else
								echo "Invalid range."
							fi	
							break
						else
							echo "Invalid input. Please enter valid positive integers for lline numbers."
						fi
					done
				else
					echo "Invalid choice. Please enter 'all' or 'range'."
				fi
			fi
			;;

		10)
			if [[ ! -s $outfr ]];
			then
				echo "The file is empty."
			else
				read -p "Do you want to display all records or specific records? (all/range): " display
				echo
				if [[ "$display" == "all" ]];
				then
					awk -F'|' 'BEGIN {printf "%-20s %-30s %-30s %-30s\n", "Name", "Roll", "Phone", "Address"; print "----------------------------------------------------------------------------------------------" }
				{ printf "%-20s %-30s %-30s %-30s\n", $1, $2, $3, $4 }' "$outfr"
				elif [[ "$display" == "range" ]];
				then
					while true;
					do
						read -p "Enter the start line number: " start
						read -p "Enter the destination line number: " end
						echo
						if [[ "$start" =~ ^[0-9]+$ ]] && [[ "$end" =~ ^[0-9]+$ ]] && [[ "$start" -gt 0 ]] && [[ "$end" -gt 0 ]];
						then
							total=$(wc -l < "$outfr")
							if [[ "$start" -le "$end" ]] && [[ "$end" -le "$total" ]];
							then
								awk -v start="$start" -v end="$end" -F'|' 'NR>=start && NR<=end { printf "%-20s %-30s %-30s %-30s\n", $1, $2, $3, $4 }' "$outfr"
							else
								echo "Invalid range."
							fi	
							break
						else
							echo "Invalid input. Please enter valid positive integers for lline numbers."
						fi
					done
				else
					echo "Invalid choice. Please enter 'all' or 'range'."
				fi
			fi
			;;

		11)
			if [[ ! -s $outfn ]];
			then
				echo "The file is empty."
			else
				read -p "Do you want to display all records or specific records? (all/range): " display
				echo
				if [[ "$display" == "all" ]];
				then
					awk -F'|' 'BEGIN {printf "%-20s %-30s %-30s %-30s\n", "Name", "Roll", "Phone", "Address"; print "----------------------------------------------------------------------------------------------" }
				{ printf "%-20s %-30s %-30s %-30s\n", $1, $2, $3, $4 }' "$outfn"
				elif [[ "$display" == "range" ]];
				then
					while true;
					do
						read -p "Enter the start line number: " start
						read -p "Enter the destination line number: " end
						echo

						if [[ "$start" =~ ^[0-9]+$ ]] && [[ "$end" =~ ^[0-9]+$ ]] && [[ "$start" -gt 0 ]] && [[ "$end" -gt 0 ]];
						then
							total=$(wc -l < "$outfn")
							if [[ "$start" -le "$end" ]] && [[ "$end" -le "$total" ]];
							then
								awk -v start="$start" -v end="$end" -F'|' 'NR>=start && NR<=end { printf "%-20s %-30s %-30s %-30s\n", $1, $2, $3, $4 }' "$outfn"
							else
								echo "Invalid range."
							fi	
							break
						else
							echo "Invalid input. Please enter valid positive integers for lline numbers."
						fi
					done
				else
					echo "Invalid choice. Please enter 'all' or 'range'."
				fi
			fi
			;;

		12)
			if [[ ! -s $ltou ]];
			then
				echo "The file is empty."
			else
				read -p "Do you want to display all records or specific records? (all/range): " display
				echo
				if [[ "$display" == "all" ]];
				then
					awk -F'|' 'BEGIN {printf "%-20s %-30s %-30s %-30s\n", "Name", "Roll", "Phone", "Address"; print "----------------------------------------------------------------------------------------------" }
				{ printf "%-20s %-30s %-30s %-30s\n", $1, $2, $3, $4 }' "$ltou"
				elif [[ "$display" == "range" ]];
				then
					while true;
					do
						read -p "Enter the start line number: " start
						read -p "Enter the destination line number: " end
						echo
						if [[ "$start" =~ ^[0-9]+$ ]] && [[ "$end" =~ ^[0-9]+$ ]] && [[ "$start" -gt 0 ]] && [[ "$end" -gt 0 ]];
						then
							total=$(wc -l < "$ltou")
							if [[ "$start" -le "$end" ]] && [[ "$end" -le "$total" ]];
							then
								awk -v start="$start" -v end="$end" -F'|' 'NR>=start && NR<=end { printf "%-20s %-30s %-30s %-30s\n", $1, $2, $3, $4 }' "$ltou"
							else
								echo "Invalid range."
							fi	
							break
						else
							echo "Invalid input. Please enter valid positive integers for lline numbers."
						fi
					done
				else
					echo "Invalid choice. Please enter 'all' or 'range'."
				fi
			fi
			;;

		13)
			if [[ ! -s $utol ]];
			then
				echo "The file is empty."
			else
				read -p "Do you want to display all records or specific records? (all/range): " display
				echo
				if [[ "$display" == "all" ]];
				then
					awk -F'|' 'BEGIN {printf "%-20s %-30s %-30s %-30s\n", "Name", "Roll", "Phone", "Address"; print "----------------------------------------------------------------------------------------------" }
				{ printf "%-20s %-30s %-30s %-30s\n", $1, $2, $3, $4 }' "$utol"
				elif [[ "$display" == "range" ]];
				then
					while true;
					do
						read -p "Enter the start line number: " start
						read -p "Enter the destination line number: " end
						echo

						if [[ "$start" =~ ^[0-9]+$ ]] && [[ "$end" =~ ^[0-9]+$ ]] && [[ "$start" -gt 0 ]] && [[ "$end" -gt 0 ]];
						then
							total=$(wc -l < "$utol")
							if [[ "$start" -le "$end" ]] && [[ "$end" -le "$total" ]];
							then
								awk -v start="$start" -v end="$end" -F'|' 'NR>=start && NR<=end { printf "%-20s %-30s %-30s %-30s\n", $1, $2, $3, $4 }' "$utol"
							else
								echo "Invalid range."
							fi	
							break
						else
							echo "Invalid input. Please enter valid positive integers for lline numbers."
						fi
					done
				else
					echo "Invalid choice. Please enter 'all' or 'range'."
				fi
			fi
			;;

		14)
			if [[ ! -s $toggle ]];
			then
				echo "The file is empty."
			else
				read -p "Do you want to display all records or specific records? (all/range): " display
				echo
				if [[ "$display" == "all" ]];
				then
					awk -F'|' 'BEGIN {printf "%-20s %-30s %-30s %-30s\n", "Name", "Roll", "Phone", "Address"; print "----------------------------------------------------------------------------------------------" }
				{ printf "%-20s %-30s %-30s %-30s\n", $1, $2, $3, $4 }' "$toggle"
				elif [[ "$display" == "range" ]];
				then
					while true;
					do
						read -p "Enter the start line number: " start
						read -p "Enter the destination line number: " end
						
						echo
						if [[ "$start" =~ ^[0-9]+$ ]] && [[ "$end" =~ ^[0-9]+$ ]] && [[ "$start" -gt 0 ]] && [[ "$end" -gt 0 ]];
						then
							total=$(wc -l < "$toggle")
							if [[ "$start" -le "$end" ]] && [[ "$end" -le "$total" ]];
							then
								awk -v start="$start" -v end="$end" -F'|' 'NR>=start && NR<=end { printf "%-20s %-30s %-30s %-30s\n", $1, $2, $3, $4 }' "$toggle"
							else
								echo "Invalid range."
							fi	
							break
						else
							echo "Invalid input. Please enter valid positive integers for lline numbers."
						fi
					done
				else
					echo "Invalid choice. Please enter 'all' or 'range'."
				fi
			fi
			;;

		15)
			if [[ ! -s $temp ]];
			then
				echo "The file is empty."
			else
				read -p "Do you want to display all records or specific records? (all/range): " display
				echo
				if [[ "$display" == "all" ]];
				then
					awk -F'|' 'BEGIN {printf "%-20s %-30s %-30s %-30s\n", "Name", "Roll", "Phone", "Address"; print "----------------------------------------------------------------------------------------------" }
				{ printf "%-20s %-30s %-30s %-30s\n", $1, $2, $3, $4 }' "$temp"
				elif [[ "$display" == "range" ]];
				then
					while true;
					do
						read -p "Enter the start line number: " start
						read -p "Enter the destination line number: " end
						echo

						if [[ "$start" =~ ^[0-9]+$ ]] && [[ "$end" =~ ^[0-9]+$ ]] && [[ "$start" -gt 0 ]] && [[ "$end" -gt 0 ]];
						then
							total=$(wc -l < "$temp")
							if [[ "$start" -le "$end" ]] && [[ "$end" -le "$total" ]];
							then
								awk -v start="$start" -v end="$end" -F'|' 'NR>=start && NR<=end { printf "%-20s %-30s %-30s %-30s\n", $1, $2, $3, $4 }' "$temp"
							else
								echo "Invalid range."
							fi	
							break
						else
							echo "Invalid input. Please enter valid positive integers for lline numbers."
						fi
					done
				else
					echo "Invalid choice. Please enter 'all' or 'range'."
				fi
			fi
			;;
		16)
			echo "Exiting the application. Redirecting to GitHub..."
      			sleep 2
     			if [[ "$OSTYPE" == "linux-gnu"* ]]; then
				xdg-open "https://github.com/subhadeeproy3902"
		      	elif [[ "$OSTYPE" == "darwin"* ]]; then
				open "https://github.com/subhadeeproy3902"
		     	elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
				start "" "https://github.com/subhadeeproy3902"
		      	else
				echo "Unsupported OS. Please open the link manually: https://github.com/subhadeeproy3902"
		      	fi
		      	exit 0
			;;
		*)
			echo "Invalid option. Please try again."
			;;
	esac
done
