# rabbitmq

> A docker image for rabbitmq bundled some plugins，such as delay-message-exchange plugin
> 
> More about: https://github.com/cadecode/run-some-scripts/tree/main/rabbitmq

## Usage

Pull image

```shell
docker pull cadecode/rabbitmq:3.8.23-bundled-delay-exchange
```

Run compose

```shell
docker compose up -d
```

## Tag

### bundled-delay-exchange

It works just like the docker official rabbitmq image, except that you can use delay exchange plugin directly in your application.
