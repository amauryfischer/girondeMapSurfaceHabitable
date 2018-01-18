map = null
info = null
legend = null
mLegend = null
geojsons = []
@getColor = (d) ->
  if d > 15000
    return '#800026'
  if d > 11000
    return '#BD0026'
  if d > 9000
    return '#E31A1C'
  if d > 6000
    return '#FC4E2A'
  if d > 3000
    return '#FD8D3C'
  if d > 1000
    return '#FEB24C'
  if d > 1
    return '#FED976'
  return '#FFEDA0'
@getStyle = (feature) ->
  {
    fillColor: getColor(feature.properties.surf_ha),
    weight: 1,
    opacity: 1,
    color: 'black',
    opacity: 0.7,
    fillOpacity: 0.7
  }
@highlightfunction = (e) ->
  e.target.setStyle({
    weight: 3.5,
    color: "#666"
    dashArray: '',
    fillOpacity: 0.7,
    opacity: 1
  })
  if (!L.Browser.ie && !L.Browser.opera && !L.Browser.edge)
    e.target.bringToFront();
  info.update(e.layer.feature.properties);
@resetHighlight = (e) ->
  for elem in geojsons
    elem.resetStyle(e.layer);
  info.update
@zoom = (e) ->
  map.fitBounds(e.target.getBounds());

$ ->
  map = L.map('map').setView([45.1114, -0.7529], 11);
  L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png').addTo(map);
  for elem in girondeCompleted["features"]
    geojson = L.geoJSON(elem,{style: getStyle}).on({
        mouseover: highlightfunction,
        mouseout: resetHighlight,
        click: zoom
    }).addTo(map)
    geojsons.push(geojson)

  info = L.control();
  info.onAdd = (map) ->
    this._div = L.DomUtil.create('div');
    this.update();
    return this._div;

  info.update = (props) ->
    this._div.innerHTML = '<div class="collection card"><h6>Mettez la souris sur une commune, ou cliquez dessus</h6></div>'
    if props != undefined
      theLegend = """
      <div class=\"info legend leaflet-control\">
        <div><i style=\"background:#800026\"></i> 15000+ </div>
        <div><i style=\"background:#BD0026\"></i> 11000-15000 </div>
        <div><i style=\"background:#E31A1C\"></i> 9000-11000 </div>
        <div><i style=\"background:#FC4E2A\"></i> 6000-9000 </div>
        <div><i style=\"background:#FD8D3C\"></i> 3000-6000 </div>
        <div><i style=\"background:#FEB24C\"></i> 1000-3000 </div>
        <div><i style=\"background:#FED976\"></i> 500-1000 </div>
        <div><i style=\"background:#FFEDA0\"></i> 1-500 </div>
      </div>
      """
      this._div.innerHTML = '<div class="collection card"><div class="collection-item"><h6>Surface Habitable : '+props.surf_ha+'</h6></div></div>'+theLegend

  info.addTo(map);
  1+1
