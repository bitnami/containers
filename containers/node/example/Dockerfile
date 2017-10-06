FROM bitnami/node:6 as builder
ENV NODE_ENV="production"
COPY . /app
WORKDIR /app
RUN npm install

FROM bitnami/node:6-prod
ENV NODE_ENV="production"
COPY --from=builder /app /app
WORKDIR /app
EXPOSE 3000
CMD ["npm", "start"]
