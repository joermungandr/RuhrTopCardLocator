angular.module('ruhrTopCardLocator').factory 'UserLocation',
['geolocation', '$timeout', 'usSpinnerService', (geolocation, $timeout, usSpinnerService) ->
  class UserLocation
    constructor: (locateCallback) ->
      @locateCallback = locateCallback

    locateUser: ->
      $timeout =>
        window.geolocation ||= geolocation
        window.geolocation.getLocation().then (data) =>
          @latLng = new L.LatLng(data.coords.latitude, data.coords.longitude)
          @locateCallback(@latLng)
]