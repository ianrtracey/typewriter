class TypeformResponse
  attr_reader :contents, :offset
  Struct.new("TypeformResponse", :http_status, :questions, :responses, :stats)

  def initialize(response_body, attributes)
    @contents = Struct::TypeformResponse.new(response_body[:http_stats],
                                             response_body[:questions],
                                             response_body[:responses],
                                             response_body[:stats]
                                            )
    @offset = attributes[:offset]
  end

  def has_more?
    response_stats = @contents[:stats][:responses]
    number_of_responses_seen = response_stats[:showing]*@offset
    if number_of_responses_seen < response_stats[:completed]
      return true
    end
    return false
  end

  def questions
    @contents.questions.map do |q|
      question_type = tokenize_question(q)
      question = merge({:id => q[:id].to_sym })
      question.merge(question_type)
    end
  end

  def tokenize_question(question_id)
    tokens = question_id.to_s.split('_')
    if tokens[0] == "list"
      return {:type => :list, :list_id => tokens[1]}
    end
    return {:type => tokens[0].to_sym}
  end

  def answers
    @contents.responses.map { |r| r[:answers] }
  end

  def form
    merged_form = answers.map do |answer|
      answer.keys.map do |field|
        associated_question = questions.find { |q| q[:id] == field }
        {
         :answer => answer[field],
         :question => associated_question
        }
      end
    end
    binding.pry
    merged_form.map do |entry|
      entry.inject({}) do |collection, field|
        question = field[:question]
        group = question[:group].to_s
        if group.nil?
          group = question[:field_id].to_s
        end
        if !collection[group].nil?
          collection[group] << field
        else
          collection[group] = [field]
        end
        collection
      end
    end
    merged_form.each do |group, field|
    # need the ability to collect the list_<id>_<choice> items that are found
    end
  end
end
