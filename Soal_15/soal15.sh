upstream kesatria_numenor {
    server 10.70.1.10:8001;  # elendil
    server 10.70.1.11:8002;  # isildur
    server 10.70.1.12:8003;  # anarion
}

server {
    listen 80;
    server_name elros.K13.com;

    location / {
        proxy_pass http://kesatria_numenor;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
