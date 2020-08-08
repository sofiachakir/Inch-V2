class BuildingsController < ApplicationController
  def index
  	@buildings = Building.all.order(:reference)
  end

  def import
		response = ImportCsv.new(params[:file], Building).perform
		redirect_to buildings_path, notice: response
	end
end
