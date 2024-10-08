FROM python:latest
RUN yum update -y
RUN yum install -y git python3-pip python3-setuptools
RUN git clone https://github.com/nyrahul/wisecow.git
WORKDIR /wisecow
RUN pip3 install requirements.txt
EXPOSE 7000
CMD ["python3", "./app.py"]