docker rm $(docker stop $(docker ps -a -q --filter ancestor=web2py-gunicorn --format="{{.ID}}"))
docker rm $(docker stop $(docker ps -a -q --filter ancestor=web2py-nginx --format="{{.ID}}"))

docker network rm web2py-net
#docker network create web2py-net
docker network create --subnet=172.25.0.0/16 web2py-net

docker build -t web2py-gunicorn -f web2py-gunicorn .
docker build -t web2py-nginx -f web2py-nginx .

docker run -d --net web2py-net -v applications:/home/web2py/web2py/applications -p 9005:9005 --name web2py-gunicorn --ip 172.25.0.22 web2py-gunicorn
# docker exec -it web2py-gunicorn  bash

sleep 2
ping -c1 -n 172.25.0.22
docker run --net web2py-net busybox ping -c1 -n web2py-gunicorn
echo "------------------------------------------------------------------"
curl -I 172.25.0.22:9005

docker run -d --net web2py-net --name web2py-nginx --ip 172.25.0.23 web2py-nginx
# docker exec -it web2py-nginx  bash

sleep 2
ping -c1 -n 172.25.0.23
docker run --net web2py-net busybox ping -c1 -n web2py-nginx
echo "------------------------------------------------------------------"
curl -I 172.25.0.23

docker network ls
docker network inspect web2py-net
docker volume ls
docker volume inspect applications
docker ps -a
docker ps
