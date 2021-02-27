# Docker Plugin - Tensorflow.js
> Install Shinobi Plugin with Docker

> Image is based on Ubuntu Bionic (18.04). Node.js 12 is used.

1. Download Repo

```
git clone https://gitlab.com/Shinobi-Systems/docker-plugin-tensorflow.js shinobi-tensorflow
```

2. Enter Repo and Build Image.

```
cd shinobi-tensorflow
docker build --tag shinobi-tensorflow-image:1.0 .
```

3. Launch the plugin.

- `-p '8082:8082/tcp'` is an optional flag if you decide to run the plugin in host mode.
- `-e PLUGIN_HOST='10.1.103.113'` Set this as your Shinobi IP Address.
- `-e PLUGIN_PORT='8080'` Set this as your Shinobi Web Port number.

```
docker run -d --name='shinobi-tensorflow' -e PLUGIN_HOST='10.1.103.113' -e PLUGIN_PORT='8080' -v "$HOME/Shinobi/docker-plugins/tensorflow":'/config':'rw' shinobi-tensorflow-image:1.0
```

### Options (Environment Variables)

| Option           | Description                                                                                                                                                                                               | Default    |
|------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------|
| PLUGIN_NAME      | The plugin's name.                                                                                                                                                                                        | Tensorflow |
| PLUGIN_HOST      | The Shinobi server's Host Address, like IP Address.                                                                                                                                                       | localhost  |
| PLUGIN_PORT      | The Shinobi server's WebSocket Port.                                                                                                                                                                      | 8080       |
| PLUGIN_HOST_PORT | The plugin's running port. This is used when the plugin is used in `host` mode.                                                                                                                           | 8082       |
| PLUGIN_KEY       | The plugin's connection key. Leave this blank to create a random one upon image start.                                                                                                                    | RANDOM     |
| PLUGIN_MODE      | The plugin's connection method. In `client` mode it will create the connection between the Shinobi server. If set to `host` the Shinobi server will be required to initiate the connection to the plugin. | client     |


### Tips

Get Docker Containers
```
docker ps -a
```

Get Images
```
docker images
```

Container Logs
```
docker logs /shinobi-tensorflow
```

Enter the Command Line of the Container
```
docker exec -it /shinobi-tensorflow /bin/bash
```

Stop and Remove
```
docker stop /shinobi-tensorflow
docker rm /shinobi-tensorflow
```
