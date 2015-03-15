class SpreadsheetsController < ApplicationController

    def authorize
        @data = SpreadsheetReader.authorize
        respond_to do |format|
            format.json {
                render json: @data
            }
            format.text {
                render :text => @data
            }
        end
	end

	def get_data
	end

end