module ExtractHttpMethod
  def http_method(request_action)
    case request_action
    when 'index', 'show'
      'GET'
    when 'create'
      'POST'
    when 'update'
      'PUT'
    when 'destroy'
      'DELETE'
    else
      'BAD_METHOD'
    end
  end
end