FROM cjunius/android-sdk

# Install Node_JS
ARG NODE_JS_VERSION=10.13.0
RUN mkdir /etc/node \
 && mkdir /opt/node \ 
 && wget -q https://nodejs.org/dist/v${NODE_JS_VERSION}/node-v${NODE_JS_VERSION}-linux-x64.tar.xz -O /etc/node-v${NODE_JS_VERSION}-linux-x64.tar.gz \
 && tar -xzf /etc/node-v${NODE_JS_VERSION}-linux-x64.tar.gz -C /etc/node \
 && mv /etc/node/node-v${NODE_JS_VERSION}-linux-x64/* /opt/node/ \
 && rm -rf /etc/node \
 && rm -f /etc/node-v${NODE_JS_VERSION}-linux-x64.tar.gz
ENV PATH ${PATH}:/opt/node/bin
LABEL NODE_JS_VERSION=${NODE_JS_VERSION}

#Configure npm and install Cordova (97.7MB)
RUN npm config set strict-ssl false \
 && npm config set registry http://registry.npmjs.org/ \
 && npm install --verbose -g cordova \
 && npm install --verbose -g cordova-android \
 && npm cache clean --force
 
# Download and install Gradle
ARG GRADLE_VERSION=4.10.2
ENV GRADLE_HOME=/usr/local/gradle-${GRADLE_VERSION}
ENV PATH=$PATH:$GRADLE_HOME/bin
RUN cd /usr/local \
 && wget -q https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -O gradle-${GRADLE_VERSION}-bin.zip && \
 && unzip gradle-${GRADLE_VERSION}-bin.zip && \
 && rm gradle-${GRADLE_VERSION}-bin.zip
LABEL GRADLE_VERSION=${GRADLE_VERSION}

#Install Android SDK Build Tools
ARG BUILD_TOOLS_VERSION=28.0.3
RUN sdkmanager "build-tools;${BUILD_TOOLS_VERSION}"
LABEL BUILD_TOOLS_VERSIONS=${BUILD_TOOLS_VERSION}

#Install Android Support Repository
RUN sdkmanager "extras;android;m2repository"

#Install Android Platform 28
ARG ANDROID_PLATFORM=28
RUN sdkmanager "platforms;android-${ANDROID_PLATFORM}"
LABEL ANDROID_PLATFORM=${ANDROID_PLATFORM}

#Possible Extra
#RUN sdkmanager "platform-tools"
#RUN sdkmanager "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.2"
#RUN sdkmanager "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2"
#RUN sdkmanager "extras;google;m2repository"
#RUN sdkmanager "extras;google;google_play_services"
