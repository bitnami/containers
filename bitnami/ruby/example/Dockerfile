FROM bitnami/ruby:2.4 as builder
ENV RAILS_ENV="production"
COPY . /app
WORKDIR /app
RUN bundle install --no-deployment
RUN bundle install --deployment
RUN bin/rails generate controller Welcome index
RUN bin/bundle exec rake assets:precompile


FROM bitnami/ruby:2.4-prod
ENV RAILS_ENV="production" \
    SECRET_KEY_BASE="your_production_key" \
    RAILS_SERVE_STATIC_FILES="yes"
RUN install_packages libssl1.0.2
COPY --from=builder /app /app
WORKDIR /app
EXPOSE 3000
CMD ["bin/rails", "server"]
