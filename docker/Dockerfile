FROM debian:oldstable

ARG HEAP="16G"
ARG OTP_JAR="otp-1.3.0-shaded.jar"
ARG REG=1

ENV HEAP=$HEAP
ENV OTP_JAR=$OTP_JAR
ENV REG=$REG

WORKDIR /otp

COPY . /otp

RUN apt-get update && apt-get install -y \
  wget \
  openjdk-8-jre \
  libbz2-dev \
  zlib1g-dev \
  bzip2

RUN ./build.sh $HEAP $OTP_JAR $OSM $REG

CMD ["./run.sh", "-c", "echo $HEAP $OTP_JAR $REG"]
