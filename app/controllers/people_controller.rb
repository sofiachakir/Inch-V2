class PeopleController < ApplicationController
  def index
  	@people = Person.all.order(:reference)
  end

  def import
		response = ImportCsv.new(params[:file], Person).perform
		redirect_to people_path, notice: response
	end
end
