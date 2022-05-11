# Recipe App API

## 1. Technologies

### Python

### Django

web framework - build web apps rapidly, object relational mapping, and django admin. ORM - object relacional mapper - covert objects to databases rows.

Django admin - out of the box admin site, manage models and visualize data base

### Django REST framework

Extension to Django, built in authentication, 

Viewsets -  to create the structure of our api and provide all the necessary endpoints for managing objects

Serializers - provide validation all requests to our api and help convert json objects to django databases models

Browsable api to test the web app

## Docker

Containerization of app 

## Travis CI

Automate testing an linting

Email notification when the build app breaks

### Postgres

Production grade database

Relational database

### Test Driven development

- Check if your code works
- Isolate specific code
    - function
    - class
    - API endpoint
- Test stages
    1. Setup - create sample database objects
    2. Execution  -  Call the code
    3. Assertions - Confirm the expected output

Source code for our course: Build a [Backend REST API with Python & Django - Advanced](http://londonapp.dev/django-python-advanced).

## Getting started

To start project, run:

```
docker-compose up
```

The API will then be available at [http://127.0.0.1:8000](http://127.0.0.1:8000).
