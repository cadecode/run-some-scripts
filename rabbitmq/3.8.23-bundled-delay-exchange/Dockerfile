FROM rabbitmq:3.8.23-management

LABEL org.opencontainers.image.description="A docker image for rabbitmq with delay exchange plugin bundled." \
      org.opencontainers.image.source="https://github.com/cadecode/run-some-scripts/tree/main/rabbitmq/3.8.23-bundled-delay-exchange" \
      # org.opencontainers.image.documentation="" \
      # org.opencontainers.image.url="" \
      org.opencontainers.image.authors="Cade Li <cadecode@foxmail.com>" \
      org.opencontainers.image.title="rabbitmq" \
      org.opencontainers.image.version="3.8.23-bundled-delay-exchange" \
      org.opencontainers.image.base.name="rabbitmq:3.8.23-management"

ENV DELAY_PLUGIN_URL https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases/download/3.8.17/rabbitmq_delayed_message_exchange-3.8.17.8f537ac.ez

ADD ${DELAY_PLUGIN_URL} /plugins/

RUN chmod 777 /plugins/rabbitmq_delayed_message_exchange-3.8.17.8f537ac.ez \
    && rabbitmq-plugins enable --offline rabbitmq_delayed_message_exchange

