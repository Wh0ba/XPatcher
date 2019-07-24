#!/usr/bin/env bash


cd "$(dirname "$0")"








function deb2ipa {

	
	mkdir tmp 
	
	mkdir ipa
	
	echo "created directories"
	
	dpkg-deb -R "$1" tmp

	echo "unpacked"

	chmod -R 0777 tmp
	 
	cd tmp

	echo "changed "

	mv Applications Payload

	echo "renamed"

	zip -q -r Payload.zip Payload
	
	filename=$(echo $1 | sed 's/\.deb$/.ipa/')

	mv Payload.zip ../ipa/$filename

	cd ..

	echo "out"

	rm -r tmp

	#rm *.deb

	echo "Done"
	echo "Converted $1 to $filename"
	echo "Stored the file in the ipa folder"

	#sleep 0.1s
}







unset options i 
while IFS= read -r -d $'\0' f; do
	options[i++]="$f" 
done < <(find ./ -maxdepth 1 -type f -name "*.deb" -print0 )

select opt in "${options[@]}" "Stop the script"; do
	case $opt in
		*.deb)
			echo "deb package $opt selected"
			# processing
			deb2ipa $opt
			break
			;;
		"Stop the script")
			echo "Exiting"
			break
			;;
		*)
			echo "not a number"
			;;
	esac
done





