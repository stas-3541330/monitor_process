FROM debian:12-slim

RUN apt-get update && apt-get install -y curl bash procps

COPY monitor_process.sh /usr/local/bin/monitor_process.sh
RUN chmod +x /usr/local/bin/monitor_process.sh

CMD ["bash", "-c", "while true; do /usr/local/bin/monitor_process.sh; sleep 60; done"]

