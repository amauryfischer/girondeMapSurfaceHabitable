var geojsons, info, legend, mLegend, map;

map = null;

info = null;

legend = null;

mLegend = null;

geojsons = [];

this.getColor = function(d) {
  if (d > 15000) {
    return '#800026';
  }
  if (d > 11000) {
    return '#BD0026';
  }
  if (d > 9000) {
    return '#E31A1C';
  }
  if (d > 6000) {
    return '#FC4E2A';
  }
  if (d > 3000) {
    return '#FD8D3C';
  }
  if (d > 1000) {
    return '#FEB24C';
  }
  if (d > 1) {
    return '#FED976';
  }
  return '#FFEDA0';
};

this.getStyle = function(feature) {
  return {
    fillColor: getColor(feature.properties.surf_ha),
    weight: 1,
    opacity: 1,
    color: 'black',
    opacity: 0.7,
    fillOpacity: 0.7
  };
};

this.highlightfunction = function(e) {
  e.target.setStyle({
    weight: 3.5,
    color: "#666",
    dashArray: '',
    fillOpacity: 0.7,
    opacity: 1
  });
  if (!L.Browser.ie && !L.Browser.opera && !L.Browser.edge) {
    e.target.bringToFront();
  }
  return info.update(e.layer.feature.properties);
};

this.resetHighlight = function(e) {
  var elem, i, len;
  for (i = 0, len = geojsons.length; i < len; i++) {
    elem = geojsons[i];
    elem.resetStyle(e.layer);
  }
  return info.update;
};

this.zoom = function(e) {
  return map.fitBounds(e.target.getBounds());
};

$(function() {
  var elem, geojson, i, len, ref;
  map = L.map('map').setView([45.1114, -0.7529], 11);
  L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png').addTo(map);
  ref = girondeCompleted["features"];
  for (i = 0, len = ref.length; i < len; i++) {
    elem = ref[i];
    geojson = L.geoJSON(elem, {
      style: getStyle
    }).on({
      mouseover: highlightfunction,
      mouseout: resetHighlight,
      click: zoom
    }).addTo(map);
    geojsons.push(geojson);
  }
  info = L.control();
  info.onAdd = function(map) {
    this._div = L.DomUtil.create('div');
    this.update();
    return this._div;
  };
  info.update = function(props) {
    var theLegend;
    this._div.innerHTML = '<div class="collection card"><h6>Mettez la souris sur une commune, ou cliquez dessus</h6></div>';
    if (props !== void 0) {
      theLegend = "<div class=\"info legend leaflet-control\">\n  <div><i style=\"background:#800026\"></i> 15000+ </div>\n  <div><i style=\"background:#BD0026\"></i> 11000-15000 </div>\n  <div><i style=\"background:#E31A1C\"></i> 9000-11000 </div>\n  <div><i style=\"background:#FC4E2A\"></i> 6000-9000 </div>\n  <div><i style=\"background:#FD8D3C\"></i> 3000-6000 </div>\n  <div><i style=\"background:#FEB24C\"></i> 1000-3000 </div>\n  <div><i style=\"background:#FED976\"></i> 500-1000 </div>\n  <div><i style=\"background:#FFEDA0\"></i> 1-500 </div>\n</div>";
      return this._div.innerHTML = '<div class="collection card"><div class="collection-item"><h6>Surface Habitable : ' + props.surf_ha + '</h6></div></div>' + theLegend;
    }
  };
  info.addTo(map);
  return 1 + 1;
});
