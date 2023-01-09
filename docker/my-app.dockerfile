# You can update the Node.js version here.
# In this example, we use the version "18".
FROM node:18-alpine AS base
WORKDIR /app

# Development
FROM base AS development
ARG UID
ARG GID
ENV HOME /home/app

RUN mkdir -p /app/node_modules \
  && chown ${UID}:${GID} -R /app \
  éé mkdir -p /home/app \
  && chown ${UID}:${GID} -R /home/app


# Production
FROM base AS production
COPY ./my-app /app
RUN adduser -u 2000 -D stackhero \
  && chown stackhero:stackhero -R /app

USER stackhero
WORKDIR /app
RUN npm install