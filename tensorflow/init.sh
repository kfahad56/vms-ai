#!/bin/sh
set -e
TFJS_HW_lowercase="$(echo "$TFJS_HW" | awk '{print tolower($0)}')"
echo "Removing existing Tensorflow Node.js modules..."
# npm uninstall @tensorflow/tfjs-node-gpu --unsafe-perm
# npm uninstall @tensorflow/tfjs-node --unsafe-perm
# npm install yarn -g --unsafe-perm --force
# if [ "$TFJS_HW_lowercase" = "cpu" ]; then
#     npm install @tensorflow/tfjs-node-gpu@1.7.3 --unsafe-perm
# else
#     npm install @tensorflow/tfjs-node@1.7.3 --unsafe-perm
# fi
# npm install --unsafe-perm
if [ ! -e "./conf.json" ]; then
    echo "Creating conf.json"
    sudo cp conf.sample.json conf.json
else
    echo "conf.json already exists..."
fi
cd /home/shinobi-plugins/tensorflow
if [ -e "/config/conf.json" ]; then
    sudo cp /config/conf.json conf.json
fi
if [ ! -e "./conf.json" ]; then
    sudo cp conf.sample.json conf.json
fi
if [ "$PLUGIN_KEY" = "RANDOM" ]; then
    newPluginKey="$(head -c 64 < /dev/urandom | sha256sum | awk '{print substr($1,1,60)}')"
else
    newPluginKey="$PLUGIN_KEY"
fi
node ./modifyConfigurationForPlugin.js tensorflow key=$newPluginKey tfjsBuild=$TFJS_HW_lowercase plug=$PLUGIN_NAME host=$PLUGIN_HOST port=$PLUGIN_PORT mode=$PLUGIN_MODE hostPort=$PLUGIN_HOST_PORT maxRetryConnection=100
echo "TF_FORCE_GPU_ALLOW_GROWTH=true" > "./.env"
echo "#CUDA_VISIBLE_DEVICES=0,2" >> "./.env"
echo "Plugin key to be added to Shinobi conf.json is : "
echo "\"$PLUGIN_NAME\":\"$newPluginKey\""
sudo cp conf.json /config/conf.json

# Execute Command
echo "Starting $PLUGIN_NAME plugin for Shinobi ..."
exec "$@"
