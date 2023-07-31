#!/bin/bash

#Funktionen:
#	Entfernt Leerzeichen, die nicht exestieren sollten
#	Entfernt den Beistrich am Ende der Punkte

running=true
folder="Student Manager"

if ! [[ -f $folder ]] 
then
	mkdir -p $folder
fi

cd $folder

while $running ; do
	
	clear
	
	echo "Bitte wählen sie eine der folgenden Optionen aus: "

	echo "[1] Schüler/in hinzufügen"
	echo "[2] Schüler/in entfernen"
	echo "[3] Schüler/in bearbeiten"
	echo "[4] Bewertung anzeigen"
	echo "[5] Notenrechner"
	echo "[6] exit"
	
	read -p "# " option
	case $option in
		"1") #new Schüler/in
			clear
			read -p "Bitte geben sie die Martikelnummer ein: " id
			
			while [[ $id -gt 9999 ]]
			do
				clear
				echo "Die Martikelnummer darf nicht größer als '9999' sein!"
				read -p "Bitte geben sie die Martikelnummer ein: " id
			done
			
			id=${id/" "/""} #Entfernt unerwünschte Leerzeichen
			
			id_lenght=${#id} #Länge der id wird gespeichert
			if [[ $id_lenght -lt 4 ]]
			then
				file=$(printf "%0"$((4-id_lenght))"d"$id".txt") #Fügt den Dateinamen zusammen
			else
				file=$id".txt"
			fi
			
			if [[ -f $file ]]
			then
				echo "Der/Die Schüler/in mit der Martikernummer '"$id"' existiert bereits"
			else
				touch $file
				echo "Der/Die Schüler/in mit der Martikernummer '"$id"' wurde erstellt"
			fi
			echo ""
			read -p "Drücken Sie die Enter-Taste  um zum Menü zurück zukehren..."
		;;
		"2") #remove Schüler/in
		clear
		files=() # Initialisiert das Array
		
		echo "Bitte wählen Sie eine der Martikelnummern aus, die unten aufgelistet werden(Zahl eingeben, die daneben in der [] steht):"
		
		echo ""
		echo "[0] Abbrechen"
		i=1
		for f in * #Geht alle Dateien im Ordner 'SuS' durch
		do
			if [[ $f == "*" ]]
			then
				file="*"
				echo ""
				echo "Es exestieren kein/e Schüler/innen. Bitte fügen Sie eine/n Schüler/in hinzu."
				break
			else
				echo "["$i"] "${f/".txt"/""} #Ausgabe der Dateien (${f/".txt"/""}: Ersetzt den String ".txt" mit "")
				files[$i]=$f #Fügt die Datei zum Array hinzu
				i=$(($i+1)) #Erhöht die Variable i um 1
			fi
		done
		
		if ! [[ $file == "*" ]]
		then
			read -p "# " id
		
			if ! [[ $id -eq 0 ]]
			then
				file=${files[$id]}	
				
				while(true)
				do
					read -p "Möchten sie diesen Schüler/in wirklich entfernen?[J/N]: " conf
					
					id_lenght=${#id}
					
					if [[ $conf == "J" ]] #Bestätigung
					then
						echo ""
						if [[ -f $file ]]
						then
							rm $file
							echo "Der/Die Schüler/in wurde entfernt"
						else
							echo "Die Datei exestiert nicht."
						fi
						break
					elif [[ $conf == "N" ]]
					then
						break
					fi
				done
			fi
		fi
		echo ""
		read -p "Drücken Sie die Enter-Taste  um zum Menü zurück zukehren..." 
		;;
		"3") #edit Bewertung
		clear
		echo "Bitte wählen Sie eine der Martikelnummern aus, die unten aufgelistet werden(Zahl eingeben, die daneben in der [] steht):"
		files=() # Initialisiert das Array
		
		echo ""
		echo "[0] Abbrechen"
		
		i=1
		for f in * #Geht alle Dateien im Ordner 'SuS' durch
		do
			if [[ $f == "*" ]]
			then
				file="*"
				echo ""
				echo "Es gibt aktuell keine Schüler/innen. Bitte fügen sie eine/n Schüler/in hinzu."
				break
			else
				echo "["$i"] "${f/".txt"/""} #Ausgabe der Dateien
				files[$i]=$f #Fügt die Datei zum Array 
				i=$(($i+1)) #Erhöht die Variable i um 1
			fi
		done
		
		if ! [[ $f == "*" ]]
		then
			read -p "# " id
			
			if ! [[ $id -eq 0 ]]
			then
				file=${files[$id]}	
			
				echo ""
				if [[ -f $file ]]
				then
					while(true)
					do
						clear
						wssplit=($(<$file))
						wsss=${#wssplit[@]}
						
						if [[ $wsss -eq 0 ]]
						then
							echo "Für diesen/diese Schüler/in gibt es keine eingetragenen Bewertungen."
						fi
						
						for ((i=0;i<$wsss;i++))
						do
							ws=${wssplit[i]}

							IFS=',' read -r -a evaluationsplit <<< ${ws} # Teilen des Strings am Char ','
							IFS=':' read -r -a wsnumsplit <<< ${evaluationsplit[0]} # Teilen des Strings am Char ':'
							
							wsnum=${wsnumsplit[0]}
							wsnss=${#wsnumsplit[@]}
							evss=${#evaluationsplit[@]}

							echo "-------------------Arbeitsauftrag "$wsnum"-------------------"
							echo ""
								if ! [[ ${wsnumsplit[1]} == "" ]]
								then
									echo "		   1 --> "${wsnumsplit[1]}" Punkte"							
								fi
								
								for ((j=1;j<$evss;j++))
								do
									echo "		   "$(($j+1))" --> "${evaluationsplit[$j]}" Punkte"
								done
							echo ""
							echo "------------------------------------------------------"
							echo ""
							echo ""
						done
						
						echo "Bitte wählen Sie eine der Optioen aus: "
						echo "[1] Bewertung hinzufügen"
						if [[ $wsss -gt 0 ]]
						then
						echo "[2] Bewertung löschen"
						echo "[3] Bewertung bearbeiten"
						fi
						
						echo "[4] Zurück zum Hauptmenü"
						read -p "# " opt
						
						case $opt in
							"1")
							echo ""
							
							id=""
							wsnum=""
							points=""
											
							while(true)
							do
								#----------------Eingabe der Daten-----------------
								read -p "Aufgabenblatt Nr: " wsnum
								read -p "Punkte für SuS "$id": " points
								#----------------Eingabe der Daten-----------------
								
								clear
								exists=0
								for ((i=0;i<$wsss;i++))
								do
									ws=${wssplit[i]}
									IFS=',' read -r -a evaluationsplit <<< ${ws} # Teilen des Strings am Char ','
									IFS=':' read -r -a wsnumsplit <<< ${evaluationsplit[0]} # Teilen des Strings am Char ':'
							
									if [[ ${wsnumsplit[0]} -eq $wsnum ]]
									then
										exists=1
									fi
								done
								
								if [[ $exists -eq 1 ]]
								then
									echo "Diese Bewertung exestiert bereits!"
								elif [[ $wsnum == "" ]]
								then
									echo "Es muss eine Aufgabenblatt Nummer eingegeben werden!"
								elif [[ $points == "" ]]
								then
									echo "Es müssen Punkte angegeben werden!"
								else
									break
								fi
							done
							
							
							ws=${wssplit[i]}
							
							IFS=',' read -r -a evaluationsplit <<< ${ws} # Teilen des Strings am Char ','
							IFS=':' read -r -a wsnumsplit <<< ${evaluationsplit[0]} # Teilen des Strings am Char ':'
							
							if ! [[ ${wsnumsplit[0]} -eq $wsnum ]]
							then
								#------Entfernung der Leerzeichen------
								id=${id/" "/""}
								wsnum=${wsnum/" "/""}
								points=${points/" "/""}
								#------Entfernung der Leerzeichen------
								
								id_lenght=${#id} #Speichert die länge der Variable 'id' ab
								lastchar=${points: -1} #Speichert das letzte Zeichen der Variable 'points' ab
								
								if [[ $lastchar == "," ]] #Wenn das letzte Zeichen der Variable 'points' ein ',' ist, wird dieser entfernt.
								then
									points=${points::-1} #Letztes Zeichen wird entfernt
								fi
								
								clear 
								
								#----------------Bestätigung-----------------
								
								echo "Bitte ueberprüfen Sie ihre Eingaben "
								echo "Aufgabenblatt Nr: "$wsnum
								echo "Punkte für SuS "$id": "$points
								#----------------Bestätigung-----------------
								
								while(true) #Läuft so lange, bis entweder J oder N eingegeben wurde
								do
									read -p  "[J/N]: " conf
									
									if [[ $conf == "J" ]]
									then
								
										if [[ -f $file ]] #Wenn der Schüler exestiert
										then
											echo $wsnum":"$points >> $file #Daten werden im Format <Aufgabeblatt Nr>:<punkte[,punkte,punkte...]
											
											echo "Die Bewertung dem/der Schühler/in wurde hinzugefügt."
										else
											echo "Diese/Dieser Schüler/in existiert nicht."
										fi
										break
										
									elif [[ $conf == "N" ]]
									then
										break
									fi
								done					
							else
								echo "Diese Bewertung exestiert bereits!"
							fi
							
							read -p "Drücken Sie die Enter-Taste um zum Bewertungenmenü zurück zu kommen..."
							;;
							"2")
							
							clear
							echo "Wählen Sie eine Bewertung aus:"
							
							for (( j=0;j<$wsss; j++))
							do
								localws=${wssplit[j]}
								IFS=',' read -r -a evaluationsplit <<< $localws # Teilen des Strings am Char ','
								IFS=':' read -r -a wsnumsplit <<< ${evaluationsplit[0]} # Teilen des Strings am Char ':'
								
								echo "["$((j+1))"] Bewertung Nr. "${wsnumsplit[0]}
							done
							
							read -p "# " id
							
							wssplit[$((id-1))]=""
							wsnumber=${wsnums[$((id-1))]}
							echo -n > $file
							for ((j=0;j<${#wssplit[@]};j++))
							do
								ws=${wssplit[$j]}
								if ! [[ $ws == "" ]]
								then
									echo "Writing: "$ws
									echo $ws >> $file
								fi
							done
							echo "Die Bewertung '"$wsnumber"' wurde entfernt."
							echo ""
							echo ""
							
							echo "Drücken Sie die Enter-Taste um zum Hauptmenü zutück zu kehren..."
							read
							;;
							"3")
							
							clear
							
							echo "Wählen Sie eine Bewertung aus:"
							wsnums=()
							for (( j=0;j<$wsss; j++))
							do
								localws=${wssplit[j]}
								IFS=',' read -r -a evaluationsplit <<< $localws # Teilen des Strings am Char ','
								IFS=':' read -r -a wsnumsplit <<< ${evaluationsplit[0]} # Teilen des Strings am Char ':'
								
								echo "["$((j+1))"] Bewertung Nr. "${wsnumsplit[0]}
								wsnums[$j]=${wsnumsplit[0]}
							done
							
							read -p "# " id
							ws=${wssplit[$((id-1))]}
							
							while(true)
							do
								IFS=',' read -r -a evaluationsplit <<< ${ws} # Teilen des Strings am Char ','
								IFS=':' read -r -a wsnumsplit <<< ${evaluationsplit[0]} # Teilen des Strings am Char ':'
								
								wsnum=${wsnumsplit[0]}
								wsnss=${#wsnumsplit[@]}
								evss=${#evaluationsplit[@]}
							
								clear
								#--------------------------------Arbeitsauftrag mit Punkten ausgeben------------

								echo "-------------------Arbeitsauftrag "$wsnum"-------------------"
								echo ""
									if ! [[ ${wsnumsplit[1]} == "" ]]
									then
										echo "		   1 --> "${wsnumsplit[1]}" Punkte"
									fi
									
									for ((j=1;j<$evss;j++))
									do
										echo "		   "$(($j+1))" --> "${evaluationsplit[$j]}" Punkte"
									done
								echo ""
								echo "------------------------------------------------------"
								echo ""
								echo ""
								
								#--------------------------------Arbeitsauftrag mit Punkten ausgeben------------
								
								echo "Bitte wählen Sie eine Option aus:"
								echo ""
								echo "[1] Punkte hinzufügen"
								echo "[2] Punkte entfernen"
								echo "[3] Zurück"
								
								read -p "# " opt
								case $opt in
									"1")		
									read -p "Bitte geben Sie die Punkte ein, die Sie hinzufügen möchten:" points
									
									lastchar=${points: -1} #Speichert das letzte Zeichen der Variable 'points' ab
									if [[ $lastchar == "," ]] #Wenn das letzte Zeichen der Variable 'points' ein ',' ist, wird dieser entfernt.
									then
										points=${points::-1} #Letztes Zeichen wird entfernt
									fi
									
									ws=$ws","$points
									wssplit[$((id-1))]=$ws
									
									echo -n > $file
									for ((j=0;j<${#wssplit[@]};j++))
									do
										localws=${wssplit[j]}
										if ! [[ $localws == "" ]]
										then
											echo "Writing: "$localws
											echo $localws >> $file
										fi
									done
									echo "Die Punkte '"$points"' wurden hinzugefügt."
									read -p "Drücken Sie die Enter-Taste um zum Punktemenü zurück zu kehren..."
									;;
									"2")
#									for (( j=0;j<$wsss; j++))
#									do								
										read -p "Biite geben Sie die Zahl ein, die neben den Punkten oben steht: " pointsnum
										
										points=$((points-1))
										pointsnum=$((pointsnum-1))
										
										if [[ $pointsnum -eq 0 ]]
										then
											wsnumsplit[1]=""	
										else
											evaluationsplit[pointsnum]=""										
										fi
										
										ws=$wsnum":"
										for ((j=0;j<$((evss+1));j++))
										do
											if [[ $j -eq 0 ]]
											then
												if ! [[ ${wsnumsplit[1]} == "" ]]
												then
													ws=$ws""${wsnumsplit[1]}
												fi
											fi
											
											if [[ $j > 0 ]]
											then
												if ! [[ ${evaluationsplit[j]} == "" ]]
												then
													ws=$ws","${evaluationsplit[j]}
												fi
											fi
										done
										
										wssplit[$((id-1))]=$ws
										echo -n > $file
										for ((j=0;j<${#wssplit[@]};j++))
										do
											localws=${wssplit[$j]}
											if ! [[ $localws == "" ]]
											then
												echo "Writing: "$localws
												echo $localws >> $file
											fi
										done
										echo "Die Punkte auf der Position '"$((pointsnum+1))"' wurden entfernt."
#									done
									read -p "Drücken Sie die Enter-Taste um zum Punktemenü zurück zu kehren..."
									;;
									"3")
									break;
									;;
								esac
									
							done
							
							if [[ $exists == 0 ]]
							then
								echo "Dieser Arbeitsauftrag '"$wsnumber"'exestiert nicht!"
							fi
							;;
							"4")
							break
							;;
						esac
					done
				fi
			else
				echo "Die Datei exestiert nicht."
			fi
		fi
		echo ""
		;;
		"4") #print Schüler/in
			clear
			echo "Bitte wählen Sie eine der Martikelnummern aus, die unten aufgelistet werden(Zahl eingeben, die daneben in der [] steht):"
			
			files=() # Initialisiert das Array
			
			echo ""
			echo "[0] Abbrechen"
			i=1
			for f in * #Geht alle Dateien im Ordner 'SuS' durch
			do
				if [[ $f == "*" ]]
				then
					file="*"
					echo ""
					echo "Es gibt aktuell keine Schüler/innen. Bitte fügen sie eine/n Schüler/in hinzu."
					break
				else
					echo "["$i"] "${f/".txt"/""} #Ausgabe der Dateien
					files[$i]=$f #Fügt die Datei zum Array 
					i=$(($i+1)) #Erhöht die Variable i um 1
				fi
			done
			
			if ! [[ $f == "*" ]]
			then
				read -p "# " id

				if ! [[ $id -eq 0 ]]
				then
					file=${files[$id]}
					echo ""
					if [[ -f $file ]]
					then
						clear
						wssplit=($(<$file))
						wsss=${#wssplit[@]}
						
						if [[ $wsss -eq 0 ]]
						then
							echo "Für diesen/diese Schüler/in gibt es keine eingetragenen Bewertungen."
						fi
						
						for ((i=0;i<$wsss;i++))
						do
							ws=${wssplit[i]}

							IFS=',' read -r -a evaluationsplit <<< ${ws} # Teilen des Strings am Char ','
							IFS=':' read -r -a wsnumsplit <<< ${evaluationsplit[0]} # Teilen des Strings am Char ':'
							
							wsnum=${wsnumsplit[0]}
							wsnss=${#wsnumsplit[@]}
							evss=${#evaluationsplit[@]}

							echo "-------------------Arbeitsauftrag "$wsnum"-------------------"
							echo ""
								if ! [[ ${wsnumsplit[1]} == "" ]]
								then
									echo "		   1 --> "${wsnumsplit[1]}" Punkte"									
								fi
								
								for ((j=1;j<$evss;j++))
								do
									echo "		   "$(($j+1))" --> "${evaluationsplit[$j]}" Punkte"
								done
							echo ""
							echo "------------------------------------------------------"
							echo ""
							echo ""
						done
					else
						echo "Die Datei exestiert nicht."
					fi			
				fi
			fi
			echo ""
			read -p "Drücken Sie die Enter-Taste  um zum Menü zurück zukehren..."
		;;
		"5") #calculate Note
		clear
		echo "Bitte wählen Sie eine der Martikelnummern aus, die unten aufgelistet werden(Zahl eingeben, die daneben in der [] steht):"
		echo ""
		echo "[0] Abbrechen"
		i=1
		for f in * #Geht alle Dateien im Ordner 'SuS' durch
		do
			if [[ $f == "*" ]] #Wenn es keine Dateien giebt, wird der Benutzer darüber informiert
			then
				file="*"
				echo ""
				echo "Es gibt aktuell keine Schüler/innen. Bitte fügen sie eine/n Schüler/in hinzu."
				break
			else
				echo "["$i"] "${f/".txt"/""} #Ausgabe der Dateien ohne das '.txt'
				files[$i]=$f #Fügt die Datei zum Array 
				i=$(($i+1)) #Erhöht die Variable i um 1
			fi
		done
		
		if ! [[ $f == "*" ]] #Wenn Dateien exestieren
		then
			read -p "# " id
			
			if ! [[ $id -eq 0 ]]
			then
				file=${files[$id]}
				
				echo ""
				if [[ -f $file ]]
				then
					resulttext=()
					
					clear
					wssplit=($(<$file))
					arraypos=0
					points=()
					percentages=()
					votes=()
					wsnums=()
					for ((i=0;i<${#wssplit[@]};i++))
					do						
						ws=${wssplit[i]}
						
						IFS=',' read -r -a evaluationsplit <<< ${ws} # Teilen des Strings am Char ','
						IFS=':' read -r -a wsnumsplit <<< ${evaluationsplit[0]} # Teilen des Strings am Char ':'
						
						wsnum=${wsnumsplit[0]}
						wsnss=${#wsnumsplit[@]}
						evss=${#evaluationsplit[@]}
						result=0;
						
						read -p "Bitte gieb die größt möglichen Punkte für den Arbeitsauftrag "${wsnum}" ein: " maxpoint
						read -p "Bitte gieb die kleinst mögliche Note für den Arbeitsauftrag "${wsnum}" ein: " minvote
						read -p "Bitte gieb die größt mögliche Note für den Arbeitsauftrag "${wsnum}" ein: " maxvote
						
						if [[ $wsnum -gt 0 ]]
						then
							result=${wsnumsplit[1]}
						else
							echo "Für diesen/diese Schüler/in gibt es keine eingetragenen Bewertungen."
						fi

						if [[ $evss > 1 ]]
						then
							
							for ((j=1;j<$evss;j++)) # Geht alle Punkte zwischen dem ',' durch und addiert sie.
							do
								evaluation=${evaluationsplit[j]}
								result=$((result+evaluation)) #Addieren der nächsten Punkte
							done
						else
							result=${wsnumsplit[1]}
						fi
						
						percentage=$(python3 -c "print(("$result"/"$maxpoint")*100)") # Berechnung der Prozente
						percentage=$(python3 -c "print(round("$percentage",2))")
						vote=$(python3 -c "print(("$result"/"$maxpoint")*10)") # Berechnung der Note
						vote=$(python3 -c "print(round("$vote",2))")
						 	
						if [[ $(python3 -c "if("$vote" < "$minvote"): print('1')") == "1" ]]
						then
							vote=$minvote
						fi
						
						if [[ $(python3 -c "if("$vote" > "$maxvote"): print('1')") == "1" ]]
						then
							vote=$maxvote
						fi
						
						points[arraypos]=$result
						maxpoints[arraypos]=$maxpoint
						wsnums[arraypos]=$wsnum
						votes[arraypos]=$vote
						percentages[arraypos]=$percentage
						resulttext[$i]="Aufgabenblatt Nr."$wsnum": "$result"/"$maxpoint" Punkte --> Prozent: "$percentage"% | Note: "$vote
						clear
						for ((j=0;j<${#resulttext[@]};j++))
						do
							echo ${resulttext[j]}
						done
						arraypos=$((arraypos+1))
					done
					
					result=0;
					for ((j=0;j<${#votes[@]};j++))
					do
						result=$(python3 -c "print("$result"+"${votes[j]}")")	
					done
					
					result=$(python3 -c "print("$result"/"${#votes[@]}")")
					echo "Durchschnitt: "$result
					
					echo ""
					echo ""
					while(true)
					do
						read -p "Möchten sie dieses Ergebnis abspeichern?[J/N]: " conf
						
						if [[ $conf == "N" || $conf == "J" ]]
						then
							break
						fi
					done
					
					if [[ $conf == "J" ]]
					then
						read -p "Bitte geben sie den Dateipfad ohne die Dateiendung ein: " path
						cd ..
						clear
						
						txtpath=$path".txt"
						csvpath=$path".csv"
						
						resulttextlength=${#resulttext[@]}
						
						echo -n > $txtpath
						echo -n > $csvpath
						
						echo "Arbeitsauftrag;Punkte;Prozent;Note" > $csvpath
						for (( j=0; j<$arraypos; j++)) 
						do
							line=${resulttext[j]}
							echo "Writing: "$line" --> "$txtpath 
							echo $line >> $txtpath
							
							line=${wsnums[j]}";"${points[j]}"/"${maxpoints[j]}";"${percentages[j]}";"${votes[j]/./,}
							line=${line/./,}
							echo "Writing: "$line" --> "$csvpath
							echo $line >> $csvpath
						done
						echo "" >> $txtpath
						echo "Durchschnitt: "$result >> $txtpath
						
						echo "" >> $csvpath
						echo "Durchschnitt" >> $csvpath
						echo ${result/./,} >> $csvpath
						
						if ! [[ $(cat $txtpath) == "" || $(cat $csvpath) == "" ]]
						then
							echo ""
							echo "Die Informationen wurden abgespeichert!"
						else
							echo "Es ist ein Fehler aufgetreten!"					
						fi
						cd $folder	
					fi
				fi
			else
				echo "Die Datei exestiert nicht."
			fi
		fi
		
		echo ""
		read -p "Drücken Sie die Enter-Taste  um zum Menü zurück zukehren..."
			
		;;
		"6") #exit
		running=false
		clear
		;;
	esac
done
