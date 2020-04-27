FROM node:8.14.0-alpine as basis

WORKDIR /opt/flowbroker/orchestrator

RUN apk --no-cache add gcc g++ musl-dev make python bash zlib-dev

COPY orchestrator/package.json ./package.json
COPY orchestrator/package-lock.json ./package-lock.json
RUN npm install


FROM node:8.14.0-alpine
RUN apk add --no-cache tini
ENTRYPOINT ["/sbin/tini", "--"]

COPY --from=basis /opt/flowbroker/orchestrator /opt/flowbroker/orchestrator
WORKDIR /opt/flowbroker/orchestrator
COPY orchestrator ./src

CMD ["node", "src/index.js", "-w", "1", "-s"]
