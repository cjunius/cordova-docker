FROM cjunius/android-sdk

# Download and install Gradle
ARG GRADLE_VERSION=4.10.2
ENV GRADLE_HOME=/usr/local/gradle-${GRADLE_VERSION}
ENV PATH=$PATH:$GRADLE_HOME/bin
RUN cd /usr/local \
 && wget -q https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -O gradle-${GRADLE_VERSION}-bin.zip \
 && unzip gradle-${GRADLE_VERSION}-bin.zip \
 && rm gradle-${GRADLE_VERSION}-bin.zip \
 && mkdir /root/.gradle \
 && echo ore.gradle.jvmargs=-Xmx2560M >> /root/.gradle/gradle.properties \
 && echo org.gradle.configureondemand=true >> /root/.gradle/gradle.properties
LABEL GRADLE_VERSION=${GRADLE_VERSION}

# Install Node_JS
ARG NODE_JS_VERSION=10.13.0
RUN mkdir /opt/node \
 && cd /opt/node \
 && wget -q https://nodejs.org/dist/v${NODE_JS_VERSION}/node-v${NODE_JS_VERSION}-linux-x64.tar.xz -O node-v${NODE_JS_VERSION}-linux-x64.tar.xz \
 && tar -xf node-v${NODE_JS_VERSION}-linux-x64.tar.xz \
 && rm -f node-v${NODE_JS_VERSION}-linux-x64.tar.xz
ENV PATH ${PATH}:/opt/node/node-v${NODE_JS_VERSION}-linux-x64/bin
LABEL NODE_JS_VERSION=${NODE_JS_VERSION}

#Configure npm and install Cordova (97.7MB)
RUN npm config set strict-ssl false \
 && npm config set registry http://registry.npmjs.org/ \
 && npm install --verbose -g cordova \
 && npm install --verbose -g cordova-android \
 && npm cache clean --force

#Install Android SDK Build Tools
ARG BUILD_TOOLS_VERSION=28.0.3
RUN sdkmanager "build-tools;${BUILD_TOOLS_VERSION}"
LABEL BUILD_TOOLS_VERSION=${BUILD_TOOLS_VERSION}

#Install Android Platform 28
ARG ANDROID_PLATFORM=28
RUN sdkmanager "platforms;android-${ANDROID_PLATFORM}"
LABEL ANDROID_PLATFORM=${ANDROID_PLATFORM}

#Create Cordova Test App
RUN mkdir /testapp \
 && cordova create /testapp \
 && cd /testapp \
 && cordova platform add android \
 && cordova build android --verbose \
 && cd / \
 && rm -rf /testapp
 
 RUN cd / && du -h -d 1 || exit 0
