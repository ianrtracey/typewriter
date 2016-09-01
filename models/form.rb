require_relative './model'

class Form < Model
  def initialize(form_id, user_id, attributes)
     super()
     @type = :form
     @form_id = form_id
     @user_id = user_id
     @attributes = attributes
  end

  # need to ultimately abstract to an adapter
  def save
     doc = {
       form_id: @form_id,
       user_id: @user_id
     }.merge(@attributes)
     super(@type, doc)
  end
end
