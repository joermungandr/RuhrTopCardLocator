describe "RuhrTopCard Locator", () ->

  beforeEach module('ruhrTopCardLocator')

  it "definies Offer", inject (Offer) ->
    expect(Offer).toBeDefined()

  describe "Offer", () ->
    valid_offer_json = {
      id: 1
      name: "Test Offer"
      coords:
        longitude: 10
        latitude: 20
      category: "Erlebnis, Spaß und Action"
      kind: "Eintritt frei"
      rating: 3
    }


    beforeEach inject (Offer) ->
      @offer = new Offer(valid_offer_json)

    it "loads a free offer", ->
      expect(@offer.id).toBe(1)
      expect(@offer.name).toBe('Test Offer')
      expect(@offer.coords.longitude).toBe(10)
      expect(@offer.coords.latitude).toBe(20)
      expect(@offer.category).toBe("Erlebnis, Spaß und Action")
      expect(@offer.kind).toBeNotDefined
      expect(@offer.rating).toBe(3)

    describe 'mark an offer as visited', ->
      it 'is visited', ->
        @offer.markAsVisited()
        expect(@offer.visited).toBe true

      it 'is saved to cookie', inject ($localStorage) ->
        @offer.markAsVisited()
        expect($localStorage.alreadyVisted).toEqual [1]

    describe 'mark an offer as not visited', ->
      beforeEach inject ($localStorage) ->
        $localStorage.alreadyVisted = [1]

      it 'is visited', ->
        @offer.markAsNotVisited()
        expect(@offer.visited).toBe false

      it 'is saved to cookie', inject ($localStorage) ->
        @offer.markAsNotVisited()
        expect($localStorage.alreadyVisted).toEqual []

    describe 'filter with distance', ->
      beforeEach ->
        @offer.distanceToUser = 2000 # Meters

      it "shows that an offer is in range", ->
        maxDistance = 3 # Kilometers
        expect(@offer.inRangeOf(maxDistance)).toBe(true)

      it "shows that an offer is not in range", ->
        maxDistance = 1 # Kilometers
        expect(@offer.inRangeOf(maxDistance)).toBe(false)