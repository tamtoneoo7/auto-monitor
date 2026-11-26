FROM node:22-alpine@sha256:1314fb30ec37592d5845e5a160d522c0e680972aa534549940b8d73bde88481a AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:22-alpine@sha256:1314fb30ec37592d5845e5a160d522c0e680972aa534549940b8d73bde88481a
ENV NODE_ENV=production NITRO_HOST=0.0.0.0 NITRO_PORT=3000
WORKDIR /app
COPY --from=build /app/.output ./.output
# The runtime only needs the node binary. npm, yarn and corepack are build tools:
# removing them also removes the libraries they bundle (and their vulnerabilities).
RUN rm -rf /usr/local/lib/node_modules/npm /usr/local/lib/node_modules/corepack \
           /usr/local/bin/npm /usr/local/bin/npx /usr/local/bin/corepack \
           /opt/yarn-* /usr/local/bin/yarn /usr/local/bin/yarnpkg
USER node
EXPOSE 3000
CMD ["node",".output/server/index.mjs"]
