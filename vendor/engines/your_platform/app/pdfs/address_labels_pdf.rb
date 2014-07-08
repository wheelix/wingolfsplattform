require 'prawn/measurement_extensions'

class AddressLabelsPdf < Prawn::Document
  
  def initialize(addresses, options = {title: '', updated_at: Time.zone.now})
    super(page_size: 'A4', top_margin: 5.mm, bottom_margin: 5.mm, left_margin: 10.mm, right_margin: 10.mm)
    
    @document_title = options[:title]
    @document_updated_at = options[:updated_at]
    @required_page_count = (addresses.count / 24).round + 1
        
    define_grid columns: 3, rows: 8, gutter: 5.mm
    
    for p in (0..(@required_page_count - 1))
      page_header
      page_footer
      
      for y in 0..7
       for x in 0..2
         grid(y, x).bounding_box do
           text addresses[p * 24 + y * 3 + x], size: 10.pt
         end
       end
      end
      start_new_page if p < (@required_page_count - 1)
    end
    
    # grid.show_all
  end
  
  def page_header_text
    "Druck auf Zweckform 3475, 70x36 mm², 24 Stk pro Blatt, DIN-A4"
  end
  def page_header
    bounding_box([0, 29.15.cm], width: 18.5.cm, height: 0.5.cm) do
      text page_header_text, size: 8.pt, align: :center
    end
  end
  def page_footer_text
    "#{Rails.application.class.parent_name}: #{@document_title}, Datenstand: #{I18n.localize(@document_updated_at)}, Seite #{page_number} von #{@required_page_count}"
  end
  def page_footer
    bounding_box([0, -0.2.cm], width: 18.5.cm, height: 0.5.cm) do
      text page_footer_text, size: 8.pt, align: :center
    end
  end
end