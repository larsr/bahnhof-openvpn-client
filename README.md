## Configure a openvpn instance

1. Put login credentials in `vpn/login.conf`.  Put the _username_ on the first line, 
   and the _password_ on the second line.

2. Build a local instance with the credentials built in, using ./BUILD, or just

       docker build -t bahnhof .

3. Run it with ./RUN,  which does

       docker run \
         -it \
         --cap-add=NET_ADMIN \
         --device /dev/net/tun \
         --name vpn \
         --dns 8.8.8.8 \
         bahnhof


If the instance is stopped it can be restarted with `docker start vpn`,
or just removed and recreated with the above command or `./RUN`.

4. If you want to, check the IP address it got with

       docker exec -ti vpn curl ifconfig.me
  
5. Optional - once you have built your docker image, you do not have to 
   keep this git repository around.

## Usage example

Create an ubuntu server that uses this vpn:

    docker run -it --rm --net=container:vpn ubuntu

Or, create one instance that uses this vpn, and a webserver that
forwards the connection to localhost

    docker rm bit web
    
    docker run -it --name bit --net=container:vpn -d dperson/transmission
    
    docker run -it --name web -p 80:80 -p 443:443 --link vpn:bit \
            -d dperson/nginx -w "http://bit:9091/transmission;/transmission"

With the above, `ngix` will forward http://localhost/transmission to 
"http://bit:9091/transmission" where `bit` is the docker instance named `bit`.
