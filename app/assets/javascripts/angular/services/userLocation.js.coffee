angular.module('ruhrTopCardLocator').directive 'ngClickAsync',['$parse', ($parse) ->
  compile: ($element, attr) ->
    fn = $parse(attr.ngClickAsync)
    (scope, element) ->
      element.on 'click', (event) ->
        scope.$evalAsync ->
          fn(scope, {$event:event})
]

angular.module('ruhrTopCardLocator').factory 'UserLocation', ['geolocation', '$timeout', (geolocation, $timeout) ->
  class UserLocation
    constructor: (locateCallback) ->
      @coords = @latLng = null
      @locateCallback = locateCallback

    locateUser: ->
      $timeout =>
        geolocation.getLocation().then (data) =>
          @coords = { latitude: data.coords.latitude, longitude: data.coords.longitude }
          @latLng = new google.maps.LatLng(data.coords.latitude, data.coords.longitude)
          @locateCallback(@latLng)
]