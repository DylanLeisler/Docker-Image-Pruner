# Docker-Image-Pruner
Simple bash script that allows you to delete all docker images while providing exceptions as arguments


	Attempts to remove all docker images visible to docker command.
	Accepts variable amount of arguments.
	If the argument is found in an image ID, the image will NOT be deleted.
	Will only delete child/parent images if -f/--force flag is first arg supplied.
	Supports regex expressions as arguments.
