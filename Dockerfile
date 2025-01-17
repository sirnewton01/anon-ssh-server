FROM golang:buster

WORKDIR /go/src/app

COPY . .
RUN go get -u ./...
RUN go install ./...

FROM debian:buster-slim
COPY --from=0 /go/bin/gemini /sbin
COPY --from=0 /go/bin/ssh-capsule-server /sbin
COPY --from=0 /go/bin/capsule /sbin

ENV HOST_KEY_LOC=/srv/hostkey
ENV CAPSULE_LOC=/srv/capsule

RUN apt-get update && apt-get install -y --no-install-recommends openssh-client git rsync openssl make && apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ssh-capsule-server ${HOST_KEY_LOC} ${CAPSULE_LOC}

