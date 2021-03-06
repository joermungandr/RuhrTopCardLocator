##
# Controller for the main page and the modal dialog
class OffersController < ApplicationController
  ##
  # Homepage
  # Offers will only be included as json
  def index
    @offers = render_to_string(partial: 'offers/offers.json')
    respond_to do |format|
      format.html {}
    end
  end

  ##
  # Modal dialog with more infos
  def show
    offer = Offer.find params[:id]
    @offer = render_to_string partial: 'offers/offer.json', locals: { offer: offer }
    respond_to do |format|
      format.html { render layout: false }
    end
  end
end
