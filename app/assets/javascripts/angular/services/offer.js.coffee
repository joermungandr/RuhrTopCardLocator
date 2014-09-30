angular.module("template/rating/rating.html", []).run ["$templateCache", ($templateCache) ->
  $templateCache.put("template/rating/rating.html",
    "<span ng-mouseleave=\"reset()\" ng-keydown=\"onKeydown($event)\" tabindex=\"0\" role=\"slider\" aria-valuemin=\"0\" aria-valuemax=\"{{range.length}}\" aria-valuenow=\"{{value}}\">\n" +
    "    <i ng-repeat=\"r in range track by $index\" ng-mouseenter=\"enter($index + 1)\" ng-click=\"rate($index + 1)\" class=\"fa\" ng-class=\"$index < value && (r.stateOn || 'fa-star') || (r.stateOff || 'fa-star-o')\">\n" +
    "        <span class=\"sr-only\">({{ $index < value ? '*' : ' ' }})</span>\n" +
    "    </i>\n" +
    "</span>");
]

angular.module('ruhrTopCardLocator').factory 'Offer', ['ipCookie', '$modal', (ipCookie, $modal) ->
  class Offer
    constructor: (offer_json) ->
      @id = offer_json.id
      @name = offer_json.name
      @kind = @chooseKind(offer_json.kind)
      @category = offer_json.category unless @kind
      @coords = { latitude: offer_json.latitude, longitude: offer_json.longitude }
      @latLng = new google.maps.LatLng @coords.latitude, @coords.longitude
      @distanceToUser = null
      @visited = _.contains ipCookie("alreadyVisted"), @id
      @rating = offer_json.google_place_rating

    # Calculate distance to another location
    distanceTo: (otherLatLng) ->
      return unless otherLatLng?
      window.google.maps.geometry.spherical.computeDistanceBetween(@latLng, otherLatLng)

    # Calculate and save distance to user
    refreshDistanceToUser: (userLatLng) ->
      @distanceToUser = @.distanceTo(userLatLng)

    # Save the info in a cookie
    markAsVisited: ->
      alreadyVisted = ipCookie("alreadyVisted") || []
      alreadyVisted.push(@id)
      ipCookie("alreadyVisted", _.uniq(alreadyVisted), expires: 365)
      @visited = true

    # Save the info in a cookie
    markAsNotVisited: ->
      alreadyVisted = ipCookie("alreadyVisted") || []
      alreadyVisted = _.without(alreadyVisted, @id)
      ipCookie("alreadyVisted", alreadyVisted, expires: 365)
      @visited = false

    # opens the modal with more infos
    openInfo: ->
      modalInstance = $modal.open
        templateUrl: "offers/#{@id}"

    inRangeOf: (maxDistance) ->
      return true unless maxDistance?
      @distanceToUser <= maxDistance * 1000

    chooseKind: (kind) ->
      return 'half-price' if kind == 'Halber Preis'
      return 'special' if kind.contains 'Special'
]