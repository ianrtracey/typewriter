require 'sidekiq'

class FormImportWorker
  include Sidekiq::Worker

  def perform(user, form_id)
    logger.info "Doing some work..."
    sleep(5)
    str = "user_id #{user[:user_id]}, form_id #{form_id}"
    File.open('/Users/iantracey/code/typeform-backend/workers/worker.log', 'w') { |file| file.write(str) }
  end
end
