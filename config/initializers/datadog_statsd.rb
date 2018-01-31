require 'datadog/statsd'
host = ENV['STATSD_HOST'] || 'dd-agent'
$statsd = Datadog::Statsd.new host