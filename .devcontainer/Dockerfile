FROM oraclelinux:9

ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=1000

# Install Oracle Instant Client (sqlplus) and MySQL client
RUN dnf -y install oracle-instantclient-release-23ai-el9 \
    && dnf -y install \
        oracle-instantclient-basic \
        oracle-instantclient-sqlplus \
        mysql \
        git sudo unzip tar which \
    && dnf clean all

# Create non-root user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -m -s /bin/bash --uid $USER_UID --gid $USER_GID $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

ENV PATH="/usr/lib/oracle/23/client64/bin:${PATH}"
ENV LD_LIBRARY_PATH="/usr/lib/oracle/23/client64/lib"

USER $USERNAME
