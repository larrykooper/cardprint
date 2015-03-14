module SpreadsheetReader

    # Adapted from gimite (Hiroshi Ichikawa) with thanks
    # https://github.com/gimite/google-drive-ruby

    require "rubygems"
    require "google/api_client"
    require "google_drive"
    @@session = nil

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

    def SpreadsheetReader.get_spreadsheet_data

        # worksheets[0] is first worksheet
        ws = @@session.spreadsheet_by_key(ENV['SPREADSHEET_KEY']).worksheets[0]

        # Get the spreadsheet data by rows
        p ws.rows  #==> [["fuga", "baz"], ["foo", "bar"]]

    end

end