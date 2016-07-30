class JsonFailureApp < Devise::FailureApp
  def respond
    if request.format == :json || request.content_type == 'application/json'
      json_failure
    else
      super
    end
  end

  def json_failure
    self.status = 401
    self.content_type = 'json'
    self.response_body = '{"errors" : ["authentication error"]}'
  end
end
