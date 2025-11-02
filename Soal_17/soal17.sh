upstream Kesatria_Lorien {
    server 10.70.2.10:8004;
    server 10.70.2.11:8005;
    server 10.70.2.12:8006;
}

server {
    listen 80;
    server_name pharazon.K13.com;

    location / {
        proxy_pass http://Kesatria_Lorien;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header Authorization $http_authorization;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
