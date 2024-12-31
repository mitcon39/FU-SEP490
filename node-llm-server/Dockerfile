FROM node:22 AS build
WORKDIR /usr/app
COPY ./package.json ./package.json
COPY ./package-lock.json ./package-lock.json
RUN npm install 
COPY ./eslint.config.js ./eslint.config.js
COPY ./tsconfig.json ./tsconfig.json
COPY ./src ./src
RUN npm run build

FROM node:22
WORKDIR /usr/app
COPY --from=build /usr/app/node_modules ./node_modules
COPY --from=build /usr/app/models ./models
COPY --from=build /usr/app/dist ./dist
CMD ["node", "./dist/index.js"]
