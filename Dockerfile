FROM golang:1.6-alpine
RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache drill git coreutils bash && \
	  rm -rf /var/cache/apk/* 

RUN go get github.com/washingtonpost/sangrenel && \
    go install github.com/washingtonpost/sangrenel

ADD sangrenel/sangrenel.sh /sangrenel.sh
RUN chmod +x /sangrenel.sh

CMD ["/sangrenel.sh"]
