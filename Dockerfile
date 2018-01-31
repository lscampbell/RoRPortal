FROM stcenergy/ruby-24-alpine:0.0.4
COPY . /app/
WORKDIR /app
EXPOSE 8080
RUN bundle install --without development test
RUN RACK_ENV=production rake assets:precompile
ENV RAILS_SERVE_STATIC_FILES=1
CMD RACK_ENV=production rackup -p 8080 --host 0.0.0.0
