FROM bitnami/node:6-prod

ENV NODE_ENV="production"

COPY . /app

WORKDIR /app

RUN npm install

CMD ["npm", "start"]
