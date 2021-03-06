class PagesController < ApplicationController
  # Root route
  def hello
    render status: 200, json: { message: 'Hi! Welcome to the BendroCorp primary API!' }
  end

  # CATCH ALL 404 ROUTE
  def not_found
    render status: 404, json: { message: 'We are sorry the endpoint you are looking for does not exist!' }
  end
end
