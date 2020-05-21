FROM boykoalex/eduk8s-initializr-test:latest as initializr

FROM quay.io/eduk8s/jdk11-environment:master

COPY --from=initializr --chown=1001:0 /opt/. /opt/.
COPY initializr/start-initializr /opt/eduk8s/sbin
COPY initializr/initializr.conf /opt/eduk8s/etc/supervisor/

COPY --chown=1001:0 . /home/eduk8s/
RUN mv /home/eduk8s/workshop /opt/workshop && rm -rf /home/eduk8s/initializr
RUN fix-permissions /home/eduk8s