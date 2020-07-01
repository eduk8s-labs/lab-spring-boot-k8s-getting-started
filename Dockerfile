FROM dsyer/eduk8s-initializr-test:latest as initializr

FROM node:current as node
RUN mkdir /work
WORKDIR /work
RUN curl https://codeload.github.com/kdvolder/eduk8s-vscode-helper/zip/master > extension.zip
RUN unzip extension.zip 
RUN rm extension.zip
RUN cd eduk8s-vscode-helper-master && npm install && npm run vsce-package && ls -la *.vsix

FROM quay.io/eduk8s/pkgs-code-server:200617.031609.8e8a4e1 AS code-server

COPY --from=node /work/eduk8s-vscode-helper-master/eduk8s-vscode-helper-0.0.1.vsix /tmp/eduk8s-vscode-helper-0.0.1.vsix
RUN mkdir /opt/code-server/java-extensions && \
    /opt/code-server/bin/code-server --extensions-dir /opt/code-server/java-extensions --install-extension /tmp/eduk8s-vscode-helper-0.0.1.vsix


FROM quay.io/eduk8s/jdk11-environment:master

COPY --from=initializr --chown=1001:0 /opt/. /opt/.
COPY --chown=1001:0 initializr/start-initializr /opt/eduk8s/sbin
COPY --chown=1001:0 initializr/initializr.conf /opt/eduk8s/etc/supervisor/

# RUN mkdir -p /home/eduk8s/.local/share/code-server/ && cp -r /opt/extensions /home/eduk8s/.local/share/code-server

COPY --from=code-server --chown=1001:0 /opt/code-server/java-extensions /opt/code-server/extensions

COPY --chown=1001:0 /dashboard-customization/dashboard.pug /opt/gateway/views/dashboard.pug
COPY --chown=1001:0 /dashboard-customization/dashboard.js /opt/gateway/routes/dashboard.js

COPY --chown=1001:0 . /home/eduk8s/
RUN mv /home/eduk8s/workshop /opt/workshop && rm -rf /home/eduk8s/initializr
RUN fix-permissions /home/eduk8s
