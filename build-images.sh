
docker build -f ./docker/simple.Dockerfile --target base -t jgkawell/sawyer:simple ./docker
docker build -f ./docker/simple.Dockerfile --target nvidia -t jgkawell/sawyer:simple-nvidia ./docker

docker build -f ./docker/custom.Dockerfile --target base -t jgkawell/sawyer:custom ./docker
docker build -f ./docker/custom.Dockerfile --target nvidia -t jgkawell/sawyer:custom-nvidia ./docker
