FROM dsyer/eduk8s-initializr-test:latest as initializr

FROM node:current as node
RUN mkdir /work
WORKDIR /work
ADD https://codeload.github.com/eduk8s/eduk8s-vscode-helper/zip/4cdcfbb593119aef45f3af5fa552f3c1a817c85b /work/extension.zip
RUN unzip extension.zip 
RUN rm extension.zip
RUN cd eduk8s-vscode-helper-* && npm install && npm run vsce-package && mv *.vsix ..

# Install vscode-spring-initializr forked extension. Replace the original vscode Initializr extension
RUN mkdir /initializr-work
WORKDIR /initializr-work
ADD https://github.com/BoykoAlex/vscode-spring-initializr/archive/customize.zip /initializr-work/initializr-extension.zip
RUN unzip initializr-extension.zip 
RUN rm initializr-extension.zip
RUN cd vscode-spring-initializr-* \
    && npm install \
    && npm install vsce --save-dev \
    && ./node_modules/.bin/vsce package \
    && mv *.vsix /initializr-work

FROM quay.io/eduk8s/pkgs-code-server:200617.031609.8e8a4e1 AS code-server

COPY --from=node --chown=1001:0 /work/eduk8s-vscode-helper-0.0.1.vsix /tmp/eduk8s-vscode-helper-0.0.1.vsix
RUN mkdir /opt/code-server/java-extensions && \
    /opt/code-server/bin/code-server --extensions-dir /opt/code-server/java-extensions --install-extension /tmp/eduk8s-vscode-helper-0.0.1.vsix && \
    rm /tmp/*.vsix

COPY --from=node --chown=1001:0 /initializr-work/vscode-spring-initializr-0.4.8.vsix /tmp/vscode-spring-initializr-0.4.8.vsix
RUN /opt/code-server/bin/code-server --extensions-dir /opt/code-server/java-extensions --install-extension /tmp/vscode-spring-initializr-0.4.8.vsix && \
    rm /tmp/*.vsix

FROM quay.io/eduk8s/jdk11-environment:200701.051914.7abd512

COPY --from=initializr --chown=1001:0 /opt/. /opt/.
COPY --chown=1001:0 initializr/start-initializr /opt/eduk8s/sbin
COPY --chown=1001:0 initializr/initializr.conf /opt/eduk8s/etc/supervisor/

# RUN mkdir -p /home/eduk8s/.local/share/code-server/ && cp -r /opt/extensions /home/eduk8s/.local/share/code-server

# Remove original vscode-initializr extension before the new forked installed
RUN rm -rf /opt/code-server/extensions/vscjava.vscode-spring-initializr* \
    && rm -rf /opt/vscode-spring-initializr

COPY --from=code-server --chown=1001:0 /opt/code-server/java-extensions /opt/code-server/extensions

# Modify code-server settings to open projects in the current workspace by default
RUN jq '."spring.initializr.defaultOpenProjectMethod"="Add to Workspace"' ~/.local/share/code-server/User/settings.json > ~/temp_settings.json \
    && mv ~/temp_settings.json ~/.local/share/code-server/User/settings.json

COPY --chown=1001:0 . /home/eduk8s/
RUN mv /home/eduk8s/workshop /opt/workshop && rm -rf /home/eduk8s/initializr
RUN fix-permissions /home/eduk8s

ENV EDITOR_HOME=/opt/workshop/exercises.code-workspace

