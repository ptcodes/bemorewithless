class AddressesController < ApplicationController
  def subregion_options
    @model = params[:model]
    render partial: 'subregion_options'
  end
end
