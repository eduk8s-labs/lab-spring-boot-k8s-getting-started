FROM dsyer/eduk8s-initializr-test:latest as initializr

FROM node:current as node
RUN mkdir /work
WORKDIR /work
ADD https://codeload.github.com/eduk8s/eduk8s-vscode-helper/zip/891aa7e6a56552b8990eeb45ab0b9c9a1b8703a9 /work/extension.zip
RUN unzip extension.zip 
RUN rm extension.zip
RUN cd eduk8s-vscode-helper-* && npm install && npm run vsce-package && mv *.vsix ..

FROM quay.io/eduk8s/pkgs-code-server:200617.031609.8e8a4e1 AS code-server

COPY --from=node --chown=1001:0 /work/eduk8s-vscode-helper-0.0.1.vsix /tmp/eduk8s-vscode-helper-0.0.1.vsix
RUN mkdir /opt/code-server/java-extensions && \
    /opt/code-server/bin/code-server --extensions-dir /opt/code-server/java-extensions --install-extension /tmp/eduk8s-vscode-helper-0.0.1.vsix && \
    rm /tmp/*.vsix

FROM quay.io/eduk8s/jdk11-environment:200701.051914.7abd512

COPY --from=initializr --chown=1001:0 /opt/. /opt/.
COPY --chown=1001:0 initializr/start-initializr /opt/eduk8s/sbin
COPY --chown=1001:0 initializr/initializr.conf /opt/eduk8s/etc/supervisor/

# RUN mkdir -p /home/eduk8s/.local/share/code-server/ && cp -r /opt/extensions /home/eduk8s/.local/share/code-server

COPY --from=code-server --chown=1001:0 /opt/code-server/java-extensions /opt/code-server/extensions

# Install vscode-spring-initializr forked extension. Replace the original vscode Initializr extension
RUN cd /opt \
    && git clone --single-branch --branch customize https://github.com/BoykoAlex/vscode-spring-initializr \
    && cd vscode-spring-initializr \
    && npm install \
    && npm install vsce --save-dev \
    && ./node_modules/.bin/vsce package \
    && rm -rf /opt/code-server/extensions/vscjava.vscode-spring-initializr* \
    && /opt/code-server/bin/code-server --install-extension ./vscode-spring-initializr-0.4.8.vsix \
    && cd ~ \
    && rm -rf /opt/vscode-spring-initializr

# Modify code-server settings to open projects in the current workspace by default
RUN jq '."spring.initializr.defaultOpenProjectMethod"="Add to Workspace"' ~/.local/share/code-server/User/settings.json > ~/temp_settings.json \
    && mv ~/temp_settings.json ~/.local/share/code-server/User/settings.json

COPY --chown=1001:0 . /home/eduk8s/
RUN mv /home/eduk8s/workshop /opt/workshop && rm -rf /home/eduk8s/initializr
RUN fix-permissions /home/eduk8s
