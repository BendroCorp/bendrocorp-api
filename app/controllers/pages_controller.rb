class PagesController < ApplicationController
  # Root route
  def hello
    render status: 200, json: { message: 'Hi! Welcome to the BendroCorp API!' }
  end

  # CATCH ALL 404 ROUTE
  def not_found
    render status: 404, json: { message: 'The endpoint you are looking for does not exist!' }
  end
end
