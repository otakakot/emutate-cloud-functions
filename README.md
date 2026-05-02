# emulate-cloud-functions

This project is initialized with the following commands.

```shell
gonew github.com/GoogleCloudPlatform/go-templates/functions/httpfn github.com/otakakot/emulate-cloud-functions
```

# Local

```shell
make up
```

```shell
make reload
```

```shell
make down
```

# Test

```shell
make e2e
```

```shell
make e2e2cloud
```

# Add

```shell
./script/add.sh ${function}
```

# Deploy

```shell
./script/deploy.sh ${function}
```

# Destroy

```shell
./script/destroy.sh ${function}
```
