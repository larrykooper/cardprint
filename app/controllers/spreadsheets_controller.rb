class SpreadsheetsController < ApplicationController

    def authorize
    	SpreadsheetReader.authorize
    	render :nothing => true
	end

	def get_data
	end

end