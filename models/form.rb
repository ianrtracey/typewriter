require_relative './model'

class Form < Model
  @@type = :form

  def initialize(form_id, user_id, attributes)
     super()
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
     super(@@type, doc)
  end

  def self.find(user_id, params)
     super(@@type, user_id, params)
  end
end
