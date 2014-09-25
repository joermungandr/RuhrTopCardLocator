##
# Save a Offer from a offer parser
class ParseOffer
  extend Surrounded::Context

  initialize :parser, :offer

  def self.call(parser)
    new(parser, Offer.find_or_create_by(name: parser.name)).call
  end

  def call
    offer.update_attributes! parser.as_attributes
    offer
  end
  trigger :call

  role :parser do
    def as_attributes
      {
        description: description,
        street: street,
        city: city,
        website: website,
        category: category
      }
    end
  end
end