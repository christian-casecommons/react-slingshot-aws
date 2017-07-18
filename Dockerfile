FROM ubuntu:16.04

RUN true && \
  apt update && \
  apt install -y \
    nodejs \
    nodejs-legacy \
    npm \
    git && \
    sysctl fs.inotify.max_user_watches=524288 && \
    sysctl -p && \
    git clone https://github.com/coryhouse/react-slingshot.git && \
    cd react-slingshot && \
    npm run setup && \
    git clone https://github.com/coryhouse/react-slingshot.git /opt/application && \
    cd /opt/application && \
    echo "Y react-slingshot-aws Y Y Y Y" | npm run setup

EXPOSE 3000
WORKDIR /opt/application
ENTRYPOINT ["npm","start"]
CMD ["-s"]
