class ApplicationController < ActionController::API
  include Response
  include ExtractHttpMethod
  include ExceptionHandler
  include BatchJobSubmitter
end
