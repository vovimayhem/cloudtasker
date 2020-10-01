# frozen_string_literal: true

module Cloudtasker
  # Cloudtasker Railtie
  class Railtie < ::Rails::Railtie
    JOB_ADAPTR_PATH = 'active_job/queue_adapters/cloudtasker_adapter'

    initializer 'cloudtasker', before: :load_config_initializers do
      Rails.application.routes.append do
        mount Cloudtasker::WorkerController, at: '/cloudtasker'
      end
    end

    config.before_configuration do
      require JOB_ADAPTR_PATH if defined?(::ActiveJob::Railtie)
    end

    config.after_initialize do
      require "#{JOB_ADAPTR_PATH}/job_wrapper" if defined?(::ActiveJob::Railtie)
    end
  end
end
