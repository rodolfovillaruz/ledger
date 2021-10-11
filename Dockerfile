FROM ubuntu AS ledger

ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /root/ledger
RUN bash -c '\
  apt-get update && \
  apt-get install -y build-essential cmake doxygen \
    libboost-system-dev libboost-dev python3-dev gettext git \
    libboost-date-time-dev libboost-filesystem-dev \
    libboost-iostreams-dev libboost-python-dev libboost-regex-dev \
    libboost-test-dev libedit-dev libgmp3-dev libmpfr-dev texinfo tzdata \
    python-is-python3'
COPY . .
RUN bash -c './acprep update'

FROM ubuntu
RUN bash -c '\
  ln -fs /usr/share/zoneinfo/Asia/Manila /etc/localtime && \
  apt-get update && \
  apt-get install -y \
    bc \
    libedit-dev \
    libboost-date-time-dev \
    libboost-filesystem-dev \
    libboost-iostreams-dev \
    libboost-regex-dev \
    libmpfr-dev'
COPY --from=ledger /root/ledger/ledger /usr/bin
COPY --from=ledger /root/ledger/libledger.so.3 /usr/lib
ENTRYPOINT [ "ledger" ]