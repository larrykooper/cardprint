module SpreadsheetReader

    # Adapted from gimite (Hiroshi Ichikawa) with thanks
    # https://github.com/gimite/google-drive-ruby

    require "rubygems"
    require "google/api_client"
    require "google_drive"
    require "json"

    @@session = nil
    @@headings = [:lo_number, :on_now, :has_card, :on_tdl_for_max?,
       :tag, :long_description, :would_make_me_happy?, :priority,
       :g_r, :create_date, :finishable?, :card_description, :prio_notes,
       :swiss_cheese, :project?, :bucket_list?]

    def SpreadsheetReader.authorize
        # Authorizes with OAuth and gets an access token.
        client = Google::APIClient.new(
            :application_name => 'Card Printer',
            :application_version => '0.0.1'
        )
        auth = client.authorization
        auth.client_id = ENV['CLIENT_ID']
        auth.client_secret = ENV['CLIENT_SECRET']
        auth.scope =
            "https://www.googleapis.com/auth/drive " +
            "https://spreadsheets.google.com/feeds/"
        auth.redirect_uri = "http://localhost"

        # ********* HERE *********************

        print("1. Open this page:\n%s\n\n" % auth.authorization_uri)
        print("2. Enter the authorization code shown in the page: ")
        auth.code = $stdin.gets.chomp
        auth.fetch_access_token!
        access_token = auth.access_token

        # Creates a session.
        @@session = GoogleDrive.login_with_oauth(access_token)
        SpreadsheetReader.get_spreadsheet_data
    end

    def SpreadsheetReader.convert_data(data_as_array)
        hashes_array = Array.new
        first_row = true
        data_as_array.each do |row_array|
            if not first_row
                data_hash = {}
                i = 0
                row_array.each do |cell_string|
                    data_hash[@@headings[i]] = cell_string
                    i += 1
                end
                hashes_array << data_hash
            else
                first_row = false
            end
        end
        hashes_array
    end

    def SpreadsheetReader.get_spreadsheet_data
        # worksheets[0] is first worksheet
        ws = @@session.spreadsheet_by_key(ENV['SPREADSHEET_KEY']).worksheets[0]

        # Return the spreadsheet data by rows
        # As: [["fuga", "baz"], ["foo", "bar"]]
        data_as_array = ws.rows
        hashes_array = SpreadsheetReader.convert_data(data_as_array)
        hashes_array.to_json
    end

end