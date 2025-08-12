#!/bin/bash

rsync -aP website/ ubuntu@public_ip_of_the_remote_server:/static-site

