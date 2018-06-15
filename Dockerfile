FROM alpine:edge AS build_po4a

ADD https://github.com/mquinson/po4a/archive/master.zip /tmp/po4a.zip
RUN unzip /tmp/po4a.zip


FROM alpine:edge AS po4a

RUN apk update
RUN apk upgrade --available
RUN apk add --no-cache perl gettext perl-unicode-linebreak
RUN rm -rf /var/cache/apk/*

COPY --from=build_po4a /po4a-master/lib /po4a/lib
COPY --from=build_po4a /po4a-master/po /po4a/po
COPY --from=build_po4a /po4a-master/extension /po4a/extension
COPY --from=build_po4a /po4a-master/scripts /po4a/scripts
COPY --from=build_po4a /po4a-master/share /po4a/share
COPY --from=build_po4a /po4a-master/po4a* /po4a/

ENV PERLLIB /po4a/lib
ENV PATH="/po4a:${PATH}"

VOLUME /src
WORKDIR /src
