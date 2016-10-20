require 'sidekiq'
require_relative '../api/api'

class FormImportWorker
  include Sidekiq::Worker

  def perform(api_key, form_id)
    response = API::Typeform.get_form(form_id,
                                      1,
                                      api_key)
    if response.form.nil?
      throw "Import error, form cant be found"
      return
    end
    form_collection = db.forms
    form_collection.insert_one(
      {
        form_id: form_id,
        status: "Importing",
        user_id: "ianrtracey",
        questions: response.questions,
        form: response.form,
        states: [],
        actions: []
      }
    )
  end
end
