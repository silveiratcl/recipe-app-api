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