#!/bin/bash

openssl req -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=KR/ST=SeoulL=Seoul/O=42Seoul/OU=hyi/CN=localhost" -keyout private.key -out public.key
chmod 600 public.key private.key
#mkdir /etc/ssl
mv public.key /etc/ssl/
mv private.key /etc/ssl/
