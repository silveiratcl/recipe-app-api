FROM python:3.7-alpine

#unbuffered mode preventss python buffer outputs 
ENV PYTHONUNBUFFERED 1

#seing and instaling requirements
COPY ./requirements.txt /requirements.txt
RUN apk add --update --no-cache postgresql-client
RUN apk add --update --no-cache  --virtual .tmp-build-deps \
         gcc libc-dev linux-headers postgresql-dev
RUN pip install -r /requirements.txt
RUN apk del .tmp-build-deps

#defining de dir
RUN mkdir /app
WORKDIR /app
COPY ./app /app

#security, limits the scope of an atTack    
RUN adduser -D user 
USER user