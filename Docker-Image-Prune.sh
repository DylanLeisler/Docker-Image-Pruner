#! /bin/bash

Help()
{
	echo -e "\n\tAttempts to remove all docker images visible to docker command."
	echo -e "\tAccepts variable amount of arguments."
	echo -e "\tIf the argument is found in an image ID, the image will NOT be deleted."
	echo -e "\tWill only delete child/parent images if -f/--force flag is first arg supplied."
	echo -e "\tSupports regex expressions as arguments.\n"
	exit
}


if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
	Help
else
	echo "Beginning image prune..."
fi

docker images --format {{'json .Repository'}} | sed -E s/\"//g > DELETEABLE-IMAGE-LIST.txt

for arg in "$@" ;
do
	sed -iE /"$arg"/c\\ DELETEABLE-IMAGE-LIST.txt
done


for line in $(cat DELETEABLE-IMAGE-LIST.txt) ;
do
	if [[ "$1" == "-f" ]] || [[ "$1" == "--force" ]]; then 
		docker image rm --force $(docker images -f dangling=true -q)
		docker image rm --force $(docker images --format {{'json .ID'}} $line | sed -E s/\"//g)
	else
		docker image rm $(docker images -f dangling=true -q)
		docker image rm $(docker images --format {{'json .ID'}} $line | sed -E s/\"//g)
	fi
done

rm DELETEABLE-IMAGE-LIST.txt
