FROM alpine:latest

RUN apk add wget --update --no-cache

ENV FFMPEG_VERSION="ffmpeg-n5.1-latest-linux64-gpl-5.1"
RUN wget -q https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/${FFMPEG_VERSION}.tar.xz
RUN tar -xvf ${FFMPEG_VERSION}.tar.xz
RUN mv ${FFMPEG_VERSION}/bin/* /usr/bin/
RUN rm -rf ${FFMPEG_VERSION}*

FROM amazon/aws-lambda-provided:al2

# Copy ffmpeg
COPY --from=0 /usr/bin/ffmpeg /usr/bin/ffmpeg
COPY --from=0 /usr/bin/ffprobe /usr/bin/ffprobe

# Copy our bootstrap and make it executable
WORKDIR /var/runtime/
COPY docker/scripts/bootstrap bootstrap
RUN chmod 755 bootstrap

# Copy our function code and make it executable
WORKDIR /var/task/
COPY docker/scripts/functions .
RUN chmod 755 -R .

# Set the handler
# by convention <fileName>.<handlerName>
CMD [ "echo.sh.handler" ]