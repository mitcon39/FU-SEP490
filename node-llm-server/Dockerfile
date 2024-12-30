FROM node:22 as build
WORKDIR /usr/app
COPY ./package.json ./package.json
COPY ./package-lock.json ./package-lock.json
RUN npm install 
COPY ./src ./src
COPY ./eslint.config.js ./eslint.config.js
COPY ./tsconfig.json ./tsconfig.json
RUN npm run build

FROM node:22-alpine
WORKDIR /usr/app
COPY --from=build /usr/src/app/dist .
CMD ["node", "index.js"]