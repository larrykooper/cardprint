class CardDrawer

    require 'prawn'

    @@mydata = [["Column heading 0", "Column heading 1", "Column heading 2"], ["foo", "strawberry", "This is some more data"], ["bar", "banana", "Yet more data"], ["baz", "pineapple", "Even some more data"]]


    @@card_rows_per_page = 5
    @@card_height - 144
    @@card_width = 267.5
    @@lo_number_column = 0
    @@card_description_column = 11
    @@left_margin_of_number = 12
    @@left_margin_of_description = 25
    @@right_margin = 20
    @@y_position_of_top_number = 710
    @@y_position_of_top_description = 690

    def self.nbr_cards_to_print
        @@mydata.size - 1
    end

    def self.draw_page(starting_data_index)

        stroke_axis

        # Here we draw a page's worth of boxes
        [5, 4, 3, 2, 1].each do |page_row_from_bottom|
            bounding_box([0, page_row_from_bottom * @@card_height], :width => @@card_width, :height => @@card_height) do
                stroke_bounds
            end
            bounding_box([@@card_width, page_row_from_bottom * @@card_height], :width => @@card_width, :height => @@card_height) do
                stroke_bounds
            end
        end

        # Here we draw a page's worth of data

        data_index = starting_data_index

        (0..(@@card_rows_per_page - 1)).each do |card_row|

            # card on left

            text_box(@@mydata[data_index][@@lo_number_column],
                :at =>[@@left_margin_of_number, @@y_position_of_top_number - card_row * @@card_height],
                :width => @@card_width - (@@left_margin_of_description + @@right_margin))

            text_box(@@mydata[data_index][@@card_description_column],
                :at =>[@@left_margin_of_description, @@y_position_of_top_description - card_row * @@card_height],
                :width => @@card_width - (@@left_margin_of_description + @@right_margin))

            data_index += 1
            if data_index > $nbr_cards_to_print
                break
            end

            # card on right
            text_box(@@mydata[data_index][@@lo_number_column],
                :at =>[@@left_margin_of_number + @@card_width, @@y_position_of_top_number - card_row * @@card_height],
                :width => @@card_width - (@@left_margin_of_description + @@right_margin))

            text_box(@@mydata[data_index][@@card_description_column],
                :at =>[@@left_margin_of_description + @@card_width, @@y_position_of_top_description - card_row * @@card_height],
                :width => @@card_width - (@@left_margin_of_description + @@right_margin))

            data_index += 1
            if data_index > $nbr_cards_to_print
                break
            end
        end # (0.. card_rows_per_page - 1).each do
    end # self.draw_page

    def self.generate_document

        filename = 'cards.pdf'
        number_of_pages = ((self.nbr_cards_to_print - 1) / 10) + 1

        Prawn::Document.generate(filename) do
            starting_data_index = 1
            (1..number_of_pages).each do |page|
                self.draw_page(starting_data_index)
                if page != number_of_pages
                    start_new_page
                    starting_data_index += 10
                end
            end
        end
    end

end