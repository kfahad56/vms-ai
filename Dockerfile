FROM nvcr.io/nvidia/cuda-arm64:11.0-devel-ubuntu18.04

ENV TFJS_HW=gpu \
    PLUGIN_NAME=Tensorflow \
    PLUGIN_HOST=localhost \
    PLUGIN_PORT=8080 \
    PLUGIN_HOST_PORT=8082 \
    PLUGIN_KEY=RANDOM \
    PLUGIN_MODE=client \
    CUDA_VISIBLE_DEVICES=0

RUN apt update -y
RUN apt install wget curl net-tools -y

# Install Node.js
RUN wget https://deb.nodesource.com/setup_12.x
RUN chmod +x setup_12.x
RUN ./setup_12.x
RUN apt install nodejs -y
RUN rm setup_12.x

RUN mkdir -p /home/shinobi-plugins/tensorflow /config
WORKDIR /home/shinobi-plugins/tensorflow

COPY tensorflow /home/shinobi-plugins/tensorflow
RUN apt install -y python build-essential
RUN apt install -y \
                make \
                g++ \
                gcc \
                node-pre-gyp \
                sudo

RUN npm i npm@latest -g && \
    npm install pm2 -g

RUN apt-get install -y python build-essential

RUN npm install @tensorflow/tfjs@1.7.3 \
                @tensorflow/tfjs-converter@1.7.3 \
                @tensorflow/tfjs-core@1.7.3 \
                @tensorflow/tfjs-layers@1.7.3 \
                @tensorflow/tfjs-node@1.7.3 \
                @tensorflow/tfjs-node-gpu@1.7.3 \
                @tensorflow-models/coco-ssd@2.0.3 \
                dotenv@8.2.0 \
                express@4.16.2 \
                moment@2.19.2 \
                socket.io@2.0.4 \
                socket.io-client@1.7.4

RUN chmod -f +x /home/shinobi-plugins/tensorflow/init.sh


VOLUME ["/config"]

EXPOSE 8082

ENTRYPOINT ["/home/shinobi-plugins/tensorflow/init.sh"]

WORKDIR  node_modules/@tensorflow/tfjs-node-gpu/scripts

COPY custom-binary.json custom-binary.json

WORKDIR node_modules\@tensorflow

RUN chmod -R 777 tfjs-node-gpu/*

WORKDIR node_modules\@tensorflow\tfjs-node-gpu

RUN npm install --unsafe-perm

WORKDIR /home/shinobi-plugins/tensorflow

CMD [ "pm2-docker", "pm2.yml" ]
