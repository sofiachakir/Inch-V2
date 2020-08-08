class BuildingsController < ApplicationController
  def index
  	@buildings = Building.all.order(:reference)
  end

  def import
		ImportCsv.new(params[:file], Building).perform
		redirect_to buildings_path
	end
end
