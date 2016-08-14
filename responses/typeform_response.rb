class TypeformResponse
  attr_reader :contents
  Struct.new("TypeformResponse",:http_status, :questions,:responses, :stats)

  def initialize(response_body)
    @contents = Struct::TypeformResponse.new(response_body[:http_stats],
                                             response_body[:questions],
                                             response_body[:responses],
                                             response_body[:stats]
                                            )
  end

  def questions
    @contents.questions.map do |q|
      q.merge({:id => q[:id].to_sym })
    end
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
    merged_form.map do |entry|
      entry.inject({}) do |collection, field|
        question = field[:question]
        group = question[:group].to_sym
        binding.pry
        if collection.include? group
          collection[group] << field
        else
          collection[group] = [field]
        end
      end
    end
  end
end
