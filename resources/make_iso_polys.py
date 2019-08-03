import networkx as nx
from shapely.geometry import Point, LineString, Polygon
import geopandas as gpd

def make_iso_polys(G, center_node='25473293', trip_times=[1,5,10,15], \
                   edge_buff=25, node_buff=50, infill=False,\
                   crs='+proj=utm +zone=30 +ellps=WGS84 +datum=WGS84 +units=m +no_defs'):

    isochrone_polys = []
    
    for trip_time in sorted(trip_times, reverse=True):
        
        subgraph = nx.ego_graph(G, center_node, radius=trip_time, distance='time')
        node_points = []
        
        for node, data in subgraph.nodes(data=True):
            node_points.append(Point((data['x'], data['y'])))
        nodes_gdf = gpd.GeoDataFrame({'id': subgraph.nodes()}, geometry=node_points)
        nodes_gdf = nodes_gdf.set_index('id')

        edge_lines = []
        for n_fr, n_to in subgraph.edges():
            f = nodes_gdf.loc[n_fr].geometry
            t = nodes_gdf.loc[n_to].geometry
            edge_lines.append(LineString([f,t]))

        n = nodes_gdf.buffer(node_buff).geometry
        e = gpd.GeoSeries(edge_lines).buffer(edge_buff).geometry
        all_gs = list(n) + list(e)
        new_iso = gpd.GeoSeries(all_gs).unary_union
        
        # try to fill in surrounded areas so shapes will appear 
        #    solid and blocks without white space inside them
        if infill:
            new_iso = Polygon(new_iso.exterior)
        isochrone_polys.append(new_iso)
        
    return isochrone_polys
