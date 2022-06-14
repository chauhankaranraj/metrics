FROM registry.access.redhat.com/ubi8/python-38:1-96.1654148946

USER root

RUN yum install -y git

# Set user and group
ARG USER="metricsuser"
ARG GROUP="metrics"
ARG UID="1000"
ARG GID="101"
RUN groupadd -g ${GID} ${GROUP}
RUN useradd -u ${UID} -g ${GROUP} -s /bin/sh -m ${USER}

# Switch to user
USER ${UID}:${GID}
WORKDIR /home/${USER}

# Get metrics project files
RUN git clone --branch container-img-def https://github.com/chauhankaranraj/metrics.git
WORKDIR metrics

# Install dependencies - why can we not do this as nonroot?
USER root
RUN pip install pip==22.1.2 setuptools==62.4.0 wheel==0.37.1 build==0.8.0
RUN pip install tqdm micropipenv && micropipenv install
USER ${UID}:${GID}