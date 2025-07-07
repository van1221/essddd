// src/components/MapComponent.js (Simplified)
import React from 'react';
import { MapContainer, TileLayer, Marker, Popup } from 'react-leaflet';
import 'leaflet/dist/leaflet.css';
import L from 'leaflet'; // Import Leaflet for custom icon

// Fix for default marker icon in Leaflet
delete L.Icon.Default.prototype._get  IconUrl;
L.Icon.Default.mergeOptions({
    iconRetinaUrl: require('leaflet/dist/images/marker-icon-2x.png'),
    iconUrl: require('leaflet/dist/images/marker-icon.png'),
    shadowUrl: require('leaflet/dist/images/marker-shadow.png'),
});

function MapComponent({ stations }) {
    // Centered around Kolkata for this example
    const defaultCenter = [22.5726, 88.3639];
    const zoomLevel = 13;

    return (
        <div className="map-container">
            <h2>Charging Stations</h2>
            <MapContainer center={defaultCenter} zoom={zoomLevel} style={{ height: '500px', width: '100%' }}>
                <TileLayer
                    url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                    attribution='&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
                />
                {stations.map(station => (
                    <Marker key={station.id} position={[station.latitude, station.longitude]}>
                        <Popup>
                            <h3>{station.name}</h3>
                            <p>Address: {station.address}</p>
                            <p>Power: {station.power_kw} kW</p>
                            <p>Connector: {station.connector_type}</p>
                            <p>Status: <strong className={station.status}>{station.status.replace(/_/g, ' ')}</strong></p>
                        </Popup>
                    </Marker>
                ))}
            </MapContainer>
        </div>
    );
}

export default MapComponent;
