class PeopleController < ApplicationController
  def index
  	@people = Person.all.order(:reference)
  end

  def import
		ImportCsv.new(params[:file], Person).perform
		redirect_to people_path
	end
end
