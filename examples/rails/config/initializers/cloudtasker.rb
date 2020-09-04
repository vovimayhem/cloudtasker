# frozen_string_literal: true

require 'cloudtasker/unique_job'
require 'cloudtasker/cron'
require 'cloudtasker/batch'

Cloudtasker.configure do |config|
  #
  # GCP Configuration
  #
  # config.gcp_location_id = 'us-east1'
  config.gcp_project_id = ENV.fetch 'GOOGLE_CLOUD_PROJECT', 'some-project'
  config.gcp_queue_prefix = ENV.fetch 'CLOUDTASKER_QUEUE_PREFIX', 'my-app'

  #
  # Domain
  #
  # config.processor_host = 'https://xxxx.ngrok.io'
  # curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url'
  config.processor_host = ENV.fetch 'CLOUDTASKER_PROCESSOR_HOST', 'http://localhost:3000'

  #
  # Uncomment to process tasks via Cloud Task.
  # Requires a ngrok tunnel.
  #
  config.mode = ENV.fetch('CLOUDTASKER_MODE', 'development').to_sym
end

#
# Setup cron job
#
# Cloudtasker::Cron::Schedule.load_from_hash!(
#   'my_worker' => {
#     'worker' => 'CronWorker',
#     'cron' => '* * * * *',
#     'queue' => 'critical',
#     'args' => ['foo']
#   }
# )
