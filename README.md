# Build a Backend REST API with Python & Django - Advanced

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

## 2. Setting up

- Create github repo

```bash
git clone https://github.com/silveiratcl/recipe-app-api.git
```

## 3. Docker

### 3.1 Dockerfile

Look on [hub.docker.com](http://hub.docker.com) the available images of python

Here we used the python:3.7-alpine

`recipe-app-api/Dockerfile` 

```docker
FROM python:3.7-alpine

#unbuffered mode preventss python buffer outputs 
ENV PYTHONUNBUFFERED 1

#seing and instaling requirements
COPY ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

#defining de dir
RUN mkdir /app
WORKDIR /app
COPY ./app /app

#security, limits the scope of an atTack
RUN adduser -D user 
USER user
```

### 3.2 Requirements file

Installing Django, Django rest framework

Look at the versions spelling  in  Look on [hub.docker.com](http://hub.docker.com) the available images of python

`recipe-app-api/requirements`

```
Django>=2.1.3,<2.2.0
djangorestframework>=3.9.0,<3.10.0
flake8>=3.6.0,<3.7.0
```

### 3.3 Docker build

Create a folder `app` to be populated with the products of docker build/compose steps. Then go to command prompt and build the docker image

```powershell
../recipe-app-api (master) $ docker build .
```

### 3.4 Docker compose

Create an .yml file `recipe-app-api/docker-compose.yml` 

```docker
version: "3"

services:
  app:
    build:
      context: .
    ports:
      - "8000:8000"
    volumes:
      - ./app:/app
    command: >
      sh -c "python manage.py runserver 0.0.0.0:8000"
```

Then go to bash terminal and compose de container

```powershell
../recipe-app-api (master) $ docker-compose build
```

## 4. Create Django project

Creating the django project to start the app. Running the services `app` in command line.

```powershell
$ docker-compose run app sh -c "django-admin.py startproject app ."
```

After started the project, you should see the folder `recipe-app-api/app/app` with those files:
`├───app
│   └───app
└───recipe-app-api` 

## 5. GitHub Actions - Setup automation

### 5.1  ****Register on Docker Hub****

If you don't already have one, head over to [hub.docker.com](https://hub.docker.com/)
 and register for a new free account.

Under Account **Account Settings** > **Security**
, create a new **Access Token**
.

### 5.2  ****Add credentials to your GitHub Repo****

- Open your repo on GitHub and select **Settings > Secrets > Actions.**
- Choose **New repository secrets** (top right):

Add the following two secrets to the repo:

- `DOCKERHUB_USER` - Your Docker Hub username. silveiratcl
- `DOCKERHUB_TOKEN` - Access token created during step 1 above.

0001fc31-6ab1-41de-885c-b9de66b4241d the number to be copied

0001fc31-6ab1-41de-885c-b9de66b4241d

![Untitled](Build%20a%20Backend%20REST%20API%20with%20Python%20&%20Django%20-%20Ad%2047907ff5434747f794b7e86024e2d65d/Untitled.png)

### 5.3  **Add the GitHub Actions configuration file**

Create a new file at .github/workflows/build.yml and add the following contents:

```docker
name: Checks
 
on: [push]
 
jobs:
  test-lint:
    name: Test and Lint
    runs-on: ubuntu-20.04
    steps:
      - name: Login to Docker Hub
        uses: docker/login-action@v1
        with:
          username: ${{ secrets.silveiratcl }}
          password: ${{ secrets.0001fc31-6ab1-41de-885c-b9de66b4241d }}
      - name: Checkout
        uses: actions/checkout@v2
      - name: Test
        run: docker-compose up -d && docker-compose run --rm app sh -c "python manage.py test"
      - name: Lint
        run: docker-compose run --rm app sh -c "flake8"
```

Push the changes, and you should see the GitHub Actions job running under **Actions** on the repo page.

!here could be an error in build.yml on docker user and token  

## 6. Writing a simple unit test

### Simple unit test

Create a function test in app/app called [calc.py](http://calc.py) 

```python
def add(x,y):
    """Add two number together"""
    return x + y
```

Create the unit test in app/app called [test.py](http://test.py) 

TestCase is function from Django to help to run tests. Writing “test” before the names of files and modules Django searches for any Python module starting with "test". This is why you can store your tests in "[tests.py](http://tests.py/)" or "tests/test_something.py"

```python
from django.test import TestCase

from app.calc import add

class CalcTests(TestCase):

    def test_add_numbers(self): #test searches for all tests
        """Test that two numbers are added together"""
        self.assertEqual(add(3,8),11)
```

Them run in container:

```powershell
docker-compose run app sh -c "python manage.py test"
```

 

The output should look like this if everything is ok:

```powershell
silve@Thiago_CS MINGW64 ~/OneDrive/Documentos/Cursos/recipe-app-api (main)
$ docker-compose run app sh -c "python manage.py test"
Creating test database for alias 'default'...
System check identified no issues (0 silenced).
.
----------------------------------------------------------------------
Ran 1 test in 0.000s

OK
Destroying test database for alias 'default'...
```

### Writing a unit test with TDD

```python
from django.test import TestCase

from app.calc import add, subtract

class CalcTests(TestCase):

    def test_add_numbers(self):
        """Test that two numbers are added together"""
        self.assertEqual(add(3,8),11)

    def test_subtract_number(self):
        """Test that values are subtracted and returned"""
        self.assertEqual(subtract(5, 11),6)
```

## 7. Configure Django custom user model

### Creating core app

- Delete [calc.py](http://calc.py) and [test.py](http://test.py)
- run the following command to start the app core

```python
$ docker-compose run app sh -c "python manage.py startapp core"
```

This gonna create a new folder `core` inside app folder

- delete the file [test.py](http://test.py)
- remove the [views.py](http://views.py) on the core app
- create a new folder inside core named `tests`, inside this folder create a file __init__.py

### Add tests for custom user model

create inside tests the file test_models.py 

```python
from django.test import TestCase
from django.contrib.auth import get_user_model

class ModelsTests(TestCase):

    def test_create_user_with_email_successful(self):
        """Test creating a new user with an email is successful"""
        email = 'test@london.com'
        password = 'Testpass123'
        user - get_user_model().objects.create_user(
            email = email,
            password = password
        )

        self.assertEqual(user.email, email)
        self.assertTrue(user.check_password(password))
```

run test

```bash
$ docker-compose run app sh -c "python manage.py test"
```

As expected  the test fails because this test to fail because we haven't created the feature yet.

```bash
Creating test database for alias 'default'...
System check identified no issues (0 silenced).
E
======================================================================
ERROR: test_create_user_with_email_successful (core.tests.test_models.ModelsTests)
Test creating a new user with an email is successful
----------------------------------------------------------------------
Traceback (most recent call last):
  File "/app/core/tests/test_models.py", line 13, in test_create_user_with_email_successful
    password = password
TypeError: create_user() missing 1 required positional argument: 'username'

----------------------------------------------------------------------
Ran 1 test in 0.005s

FAILED (errors=1)
Destroying test database for alias 'default'...
```

### Implement custom user model

Create a user model in our [models.py](http://models.py/) file in the core app and

then  update the [settings.py](http://settings.py/) file to set our custom auth user model.

- create models for user manager and authentication

```python
from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, \
    PermissionsMixin

class UserManager(BaseUserManager): #user manager class

    def create_user(self, email, passoword=None, **extra_fields):
        """Creates and saves a new user"""
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db) 

        return user

class User(AbstractBaseUser, PermissionsMixin):
    """Custom user model that supports using email instead of username"""
    email = models.EmailField(max_length=255, unique=True)
    name = models.Charfield(max_lenght=255)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)

    objects = UserManager()

    USERNAME_FIELD = 'email'
```

- insert  [settings.py](http://settings.py)

```bash
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'core', ##### app core
]

# in the botton
AUTH_USER_MODEL = 'core.User' #core=app, user=model in the app assig user model
```

On termimal make database migrations, which will create a new migrations file.

Which basically it is the instructions for Django to create the model in the real database that we use.

```bash
$ docker-compose run app sh -c "python manage.py makemigrations core"
```

expected output

```bash
$ docker-compose run app sh -c "python manage.py makemigrations core"
Migrations for 'core':
  core/migrations/0001_initial.py
    - Create model User
```

### Normalize email addresses

Now that we have our create user function we can add a new feature to the function to normalize the email address that the users sign up with it's not a required step but it is recommended because the second part of the user

test

```python
def test_new_user_email_normalized(self):
        """Test the email for an new user is normalized"""
        email = 'test@LONDON.COM' 
        user = get_user_model().objetcs.create_user(email, 'test123')

        self.assertEqual(user.email, email.lower())
```

fix in models

```python
class UserManager(BaseUserManager):

    def create_user(self, email, password=None, **extra_fields):
        """Creates and saves a new User"""
        user = self.model(email=self.normalize_email(email), **extra_fields)
        user.set_password(password)
        user.save(using=self._db)

        return user
```

### Add validation for email field

Add validation to ensure that an email field has actually been provided when the create user function is called.

On tests/tests_models.py insert the test:

```python
def test_new_user_invalid_email(self):
        """Test creating user with no email reises error"""
        with self.assertRaises(ValueError):
            get_user_model().objects.create_user(None,'test123')
```

On  models edit create user module:

```python
def create_user(self, email, password=None, **extra_fields):
        """Creates and saves a new User"""
        if not email:
            raise ValueError('Users must have an email address')
        user = self.model(email=self.normalize_email(email), **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
```

### Add support for creating superusers

We have our create user function finished there's just one more function that we need to add to our user model manager and that is the create super user function.

create superuser app/core/models.py 

```python
...
def create_superuser(self, email, password):
        """Create and saves a new super user"""
        user = self.create_user(email, password)
        user.is_staff = True
        user.is_superuser = True
        user.save(using=self._db)

        return user
```

Create the test 

```python
def test_create_new_superuser(self):
        """Test creating a new superuser"""
        user = get_user_model().objects.create_superuser(
            'test@london.com',
            'test123'
        )
        
        self.assertTrue(user.is_superuser)
        self.assertTrue(user.is_staff)
```

 run the test

```python
$ docker-compose run app sh -c "python manage.py test"

#ok
Creating test database for alias 'default'...
System check identified no issues (0 silenced).
....
----------------------------------------------------------------------
Ran 4 tests in 0.176s

OK
Destroying test database for alias 'default'...
```

still having problems on docker flake8 github action

## 8. Set up Django admin

### Adding tests for listing users

Update our Django admin so that we can manage our

custom user model. This will give us a  interface that we can use to

log in and see which users have been created, create users ourselves or

make changes to existing users.

`test/test_admin.py`

```python
from django.test import TestCase, Client
from django.congtrib.auth import get_user_model
from django.urls import reverse

class AdminSiteTests(TestCase):

    def setUp(self):
        self.client = Client()
        self.admin_user = get_user+model().objects.create_superuser(
            email='admin@london.com',
            password ='password123'
        )
        self.client.force_login(self.admin_user)
        self.user = get_user_model().objects.create(
            email='test@london.com',
            password='password123',
            name='Test user full name'
        )

    def test_userd_listed(self):
        """Test that users  are listed on user page"""
        url = reverse('admin:core_user_changelist')
        res = self.client.get(url)

        self.assertContains(res, self.user.name)
        self.assertContains(res, self.user.email)
```

### Modify Django admin to list our custom user model

tests/admin.py

```python

from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin

from core import models

class UserAdmin(BaseUserAdmin):
    ordering = ['id']
    list_display = ['email', 'name']

admin.site.register(models.User, UserAdmin)
```

run the test

```bash
$ docker-compose run app sh -c "python manage.py test"
Creating test database for alias 'default'...
System check identified no issues (0 silenced).
.....
----------------------------------------------------------------------
Ran 5 tests in 0.398s

OK
Destroying test database for alias 'default'...
```

### Modify Django admin to support changing user model

Updating our Django admin to support changing our user model because there's still a few changes that we need to make to our Django admin class to support our custom user model the Edit Page won't work in its current state. So we're going to make some changes to make sure that it does work.

`tests/test_admin.py`

```python
...
def test_user_change_page(self):
        """Test that the user edit page works"""
        url = reverse('admin:core_user_change', args=[self.user.id]) 
        res = self.client.get(url)

        self.assertionEqual(res.status_code, 200)
```

core/admim.py

```python
class UserAdmin(BaseUserAdmin):
    ordering = ['id']
    list_display = ['email', 'name']
    fieldsets = (
    (None, {'fields': ('email', 'password')}),
    (_('Personal Info'), {'fields': ('name',)}),
    (
        _('Permissions'),
        {
            'fields': (
                'is_active',
                'is_staff',
                'is_superuser',
            )
        }
    ),
    (_('Important dates'), {'fields': ('last_login',)}),
)

admin.site.register(models.User, UserAdmin)
```

run test

```python
$ docker-compose run app sh -c "python manage.py test"
Creating test database for alias 'default'...
System check identified no issues (0 silenced).
......
----------------------------------------------------------------------
Ran 6 tests in 0.394s

OK
Destroying test database for alias 'default'...
```

### Modify Django admin to support creating users

There's one last thing we need to change in our Django admin before it will work with our custom user model and that is the add page. This is the page for adding new users in the Django admin.

test/tests_admin.py

```python

```

theris an error here!!!
