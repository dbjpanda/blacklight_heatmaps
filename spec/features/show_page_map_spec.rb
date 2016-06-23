require 'spec_helper'

feature 'Show map map', js: true do
  it 'renders a leaflet map' do
    visit solr_document_path '43037890'
    expect(page).to have_css '.leaflet-map-pane'
    # Zoomed to Kazakhstan
    expect(page).to have_css 'img[src="http://b.basemaps.cartocdn.com/light_all/4/11/5.png"]'
  end
end