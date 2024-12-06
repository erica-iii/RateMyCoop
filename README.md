# Fall 2024 CS 3200 Project: Rate My Co-op

Group Members: Erica Indman, Margaret Palaia, Kellyn Small, Nathaniel Mercer-Garber, and Kennedy Wiles

## Prerequisites

- A GitHub Account
- A terminal-based or GUI git client
- VSCode with the Python Plugin
- A distrobution of Python running on your laptop (Choco (for Windows), brew (for Macs), miniconda, Anaconda, etc). 

## Current Project Components

Currently, there are three major components which will each run in their own Docker Containers:

- Streamlit App in the `./app` directory
- Flask REST api in the `./api` directory
- SQL files in the `./database-files` directory


## Controlling the Containers

- `docker compose up -d` to start all the containers in the background
- `docker compose down` to shutdown and delete the containers
- `docker compose up db -d` only start the database container (replace db with the other services as needed)
- `docker compose stop` to "turn off" the containers but not delete them. 


## Accessing the RestAPI

The RestAPI can be accessed on localhost port 4000 with the following blueprints and url prefixes:

- advisors,     /a
- students,     /s
- systemadmin,  /sa
- employers,    /e


## Accessing the Streamlit App

The streamlit app can be on localhost port 8501. Currently, four personas are supported to simulate the main functionalities of our app:

- Student
- SystemAdministrator
- Co-op Advisor
- Employer

 
