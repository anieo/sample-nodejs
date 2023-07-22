FROM node:18-alpine as builder

ENV APP sample
ENV MAIN_DIR /home/$APP
ENV PATH $MAIN_DIR/node_modules/.bin:$PATH
ENV TINI_VERSION v0.19.0

RUN apk add --no-cache tini

RUN addgroup -S $APP && adduser  -G $APP -S $APP
RUN chown -R ${APP}:${APP} "/home/${APP}"
# Install dependencies
WORKDIR $MAIN_DIR
USER $APP
COPY --chown=$APP:$APP package*.json ./
RUN npm install

# NOTE: use .dockerignore, put folders under one app or specify paths here,
# but do not copy ALL files
COPY . .

ENTRYPOINT ["/sbin/tini", "--"]

# Run your program under Tini
CMD ["npm", "start"]
