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
    @contents.questions.inject({}) do |collection, q|
      question_id = _get_primary_id(q[:id])
      q[:id] = question_id
      if collection[q[:id]].nil?
        collection[q[:id]] = q.merge({:answers => [], :num_choices => 1})
      else
        question = collection[q[:id]]
        question[:num_choices] = question[:num_choices]+1
      end
      collection
    end
  end

  def _get_primary_id(response_id)
    tokens = response_id.to_s.split('_')
    tokens[0..1].join("_")
  end

  def answers
    @contents.responses.map { |r| r[:answers] }
  end

  def form
    answers.map do |answer|
      question_set = questions
      answer.inject(question_set) do |collection, field|
        answer_id = field[0].to_s
        id = _get_primary_id(answer_id)
        if collection[id].nil?
          raise "NO question for id #{id}"
        end
        collection[id][:answers] << field[1]
      question_set
      end
    end
  end
end
