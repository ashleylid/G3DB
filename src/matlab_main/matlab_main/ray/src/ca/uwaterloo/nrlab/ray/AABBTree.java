/**
 * 
 */
package ca.uwaterloo.nrlab.ray;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Axis-aligned bounding box tree for polygon intersection tests. 
 * 
 * @author Bryan Tripp
 */
public class AABBTree {
	
	/**
	 * @param polygons An array of triangles. Each triangle is an array of three points. Each 
	 * 	point is an array of three coordinates.  
	 * @return The root Node of an AABB Tree of the given polygons. 
	 */
	public static Node makeTree(double[][][] polygons) {

		//create bounding box node for each polygon
		List<Node> nodeList = new ArrayList<Node>(polygons.length);
		for (int i = 0; i < polygons.length; i++) {			
			nodeList.add(new LeafNode(polygons[i]));
		}
		
		//sort to ensure that parents have similar children 
		Collections.sort(nodeList);
		Node[] nodes = nodeList.toArray(new Node[nodeList.size()]);
		
		//build tree 
		while (nodes.length > 1) {
			nodes = makeParents(nodes);
		}
		
		return nodes[0];
	}
	
	/**
	 * @param root Root of AABB tree. 
	 * @return A random point within the volume enclosed by the corresponding mesh 
	 */
	public static double[] getRandomPointInVolume(Node root) {
		double[] result = null;
		
		double[][] b = root.myBoundingBox;
		while (result == null) {
			double x = b[0][0] + Math.random() * (b[1][0]-b[0][0]);
			double y = b[0][1] + Math.random() * (b[1][1]-b[0][1]);
			double z = b[0][2] + Math.random() * (b[1][2]-b[0][2]);

			double[] point = {x,y,z};
			if (isInVolume(root, point)) {
				result = point;
			}
		}
		return result;
	}
	
	public static boolean isInVolume(Node root, double[] point) {
		double[] rayDirection = {0,0,-1};
		List<double[]> intersections = root.getIntersections(point, rayDirection);
		boolean result = intersections.size() % 2 == 1;
		return result;
	}
	
	private static Node[] makeParents(Node[] nodes) {
		Node[] result = new Node[(int) Math.ceil((double) nodes.length / 2)];
		
		for (int i = 0; i < result.length; i++) {
			Node child1 = nodes[2*i];
			Node child2 = (nodes.length > 2*i+1) ? nodes[2*i+1] : child1; 
			result[i] = new NonLeafNode(child1, child2);
		}
		
		return result;
	}
	
	/**
	 * A Node in an AABB Tree. Each Node corresponds to a "bounding box" which bounds 
	 * either a single polygon in a mesh (for leaf Nodes), or multiple polygons (for 
	 * non-lead Nodes). The root Node of a tree bounds all the polygons in a mesh. 
	 * 
	 * @author Bryan Tripp
	 */
	public static abstract class Node implements Comparable<Node> {
		public double[][] myBoundingBox; 
		public double[] myCentre;
		public double[] mySize;		
		
		/**
		 * @param boundingBox An array of two 3D points, which are opposite corners of a box. One point 
		 * 	is the minimum boundary in each dimension, and the other is the maximum. E.g. [0,0,0] and
		 * 	[1,1,1] for a unit box with a corner at the origin. 
		 */
		public Node(double[][] boundingBox) {
			myBoundingBox = boundingBox;
			
			myCentre = new double[3];
			mySize = new double[3];
			for (int i = 0; i < 3; i++) {
				myCentre[i] = (boundingBox[1][i] + boundingBox[0][i]) / 2f; 
				mySize[i] = (boundingBox[1][i] - boundingBox[0][i]) / 2f; 
			}
		}
		
		/**
		 * @param origin Origin of a ray (a 3D point). 
		 * @param dir Direction of the ray (3-vector)
		 * @return True if the ray intersects this Node's bounding box. 
		 */
		public boolean intersects(double[] origin, double[] dir) {
			return intersectRayBox(myBoundingBox[0], myBoundingBox[1], origin, dir);			
		}
		
		/**
		 * @param origin Origin of a ray (a 3D point). 
		 * @param dir Direction of the ray (3-vector)
		 * @return List of points at which the ray intersects polygons within this bounding box. 
		 */
		public abstract List<double[]> getIntersections(double[] origin, double[] dir);

		/**
		 * Defines a natural order for sorting. We need this to ensure that a parent has 
		 * similar children. We want to sort first by first dimension, then second, then 
		 * third, ignoring small differences. This is approximated by weighting the centres
		 * in each dimension very differently. 
		 */
		@Override
		public int compareTo(Node other) {
			int result = 0;
			
			double[] weights = {1, .1, .01};
			
			double difference = 0;
			for (int i = 0; i < 3 && result == 0; i++) {
				difference = difference + weights[i] * (this.myCentre[i] - other.myCentre[i]);
			}
			
			if (difference > 0) result = 1;
			if (difference < 0) result = -1;
			
			return result;
		}
	}
	
	/**
	 * A leaf Node in an AABB Tree. The associated bounding box bounds a polygon. 
	 * 
	 * @author Bryan Tripp
	 */
	public static class LeafNode extends Node {
		public double[][] myPolygon;
		
		/**
		 * @param polygon A surface polygon that is to be contained by this Node.
		 */
		public LeafNode(double[][] polygon) {
			super(getPolygonBoundingBox(polygon));
			myPolygon = polygon;
		}

		/**
		 * @param origin Ray origin 
		 * @param dir Ray direction
		 * @return A list of zero or one intersection points (as a List for the convenience of the tree)
		 */
		public List<double[]> getIntersections(double[] origin, double[] dir) {
			List<double[]> result = new ArrayList<double[]>();
			if (this.intersects(origin, dir)) {
				double[] intersection = new double[3];
				if (intersectRayPolygon(myPolygon, origin, dir, intersection)) {
					result.add(intersection);
				}
			}
			return result;
		}
		
		@Override		
		public String toString() {
			return myPolygon[0][0] + " " + myPolygon[0][1] + " " + myPolygon[0][2] + "\r\n";
		}
	}
	
	/**
	 * A non-leaf Node in an AABB Tree. 
	 * 
	 * @author Bryan Tripp
	 */
	public static class NonLeafNode extends Node {
		public Node myChild1;
		public Node myChild2;

		/**
		 * Note: If an odd # of nodes requires one parent to have a single child, pass it to both args.
		 * 
		 * @param child1 A child Node to be bounded by this Node's bounding box. 
		 * @param child2 Another child Node that is also to be bounded by this Node's bounding box. 
		 */
		public NonLeafNode(Node child1, Node child2) {
			super(getBoxBoundingBox(child1.myBoundingBox, child2.myBoundingBox));
			myChild1 = child1;
			myChild2 = child2;
		}
		
		/**
		 * @param origin Origin of ray (x,y,z point)
		 * @param dir Ray direction vector (x,y,z length)
		 * @return List of points (within polygons) with which a given ray intersects.
		 */
		public List<double[]> getIntersections(double[] origin, double[] dir) {
			List<double[]> result = new ArrayList<double[]>();
			
			if (this.intersects(origin, dir)) {
				result.addAll(myChild1.getIntersections(origin, dir));
				if (myChild1 != myChild2) result.addAll(myChild2.getIntersections(origin, dir));
			}
			
			//remove duplicates due to intersections at shared edges and/or vertices
			boolean[] duplicate = new boolean[result.size()];
			for (int i = 0; i < result.size(); i++) {
				for (int j = i+1; j < result.size(); j++) {
					if (same(result.get(i), result.get(j), 1e-8)) {
						duplicate[j] = true;
					}
				}
			}	
			
			for (int i = result.size()-1; i >= 0; i--) {
				if (duplicate[i]) {
					result.remove(i);
				}
			}
			
			return result;
		}

		@Override
		public String toString() {
			return " - \r\n" + myChild1.toString() + ((myChild1 != myChild2) ? myChild2.toString() : "");
		}
		
	}
	
	private static boolean same(double[] a, double[] b, double tolerance) {
		boolean same = true;		
		if (a.length == b.length) {
			for (int i = 0; same && i < a.length; i++) {
				if (Math.abs(a[i]-b[i]) > tolerance) {
					same = false;
				}
			}			
		} else {
			same = false;
		}		
		return same;
	}
	
	/**
	 * @param vertices An array of vertices, which are 3D points that make up the corners
	 * 	of a polygon. 
	 * @return A bounding box that contains the polygon. 
	 */
	public static double[][] getPolygonBoundingBox(double[][] vertices) {
		double[] min = new double[3];
		double[] max = new double[3];
		for (int i = 0; i < 3; i++) {
			min[i] = vertices[0][i];
			max[i] = vertices[0][i];
			for (int j = 1; j < vertices.length; j++) {
				if (vertices[j][i] < min[i]) min[i] = vertices[j][i];
				if (vertices[j][i] > max[i]) max[i] = vertices[j][i];
			}
		}
		
		return new double[][]{min,max};
	}

	/**
	 * @param box1 An array with the min and max corners of a box. 
	 * @param box2 An array with the min and max corners of another box.
	 * @return An array with the min and max corners of a box that contains box1 and box2
	 */
	public static double[][] getBoxBoundingBox(double[][] box1, double[][] box2) {
		double[] min = new double[3];
		double[] max = new double[3];
		for (int i = 0; i < 3; i++) {
			min[i] = Math.min(box1[0][i], box2[0][i]);
			max[i] = Math.max(box1[1][i], box2[1][i]);
		}
		return new double[][]{min,max};
	}
	
	/**
	 * @param vertices An array of 3 vertices that make up a triangle
	 * @param origin Origin of a ray (a point)
	 * @param dir Direction of a ray (a 3-vector)
	 * @param intersection An empty 3D point in which to put point of intersection, if any
	 * @return True if the ray intersects the polygon
	 */
	public static boolean intersectRayPolygon(double[][] vertices, double[] origin, double[] dir, double[] intersection) {
		//this method is from http://geomalgorithms.com/a06-_intersect-2.html
		boolean result = false;
		assert (vertices.length == 3): "Expected a triangle"; 		
		
		//edges
		double[] u = minus(vertices[2], vertices[0]);
		double[] v = minus(vertices[1], vertices[0]);
		
		double[] n = normal(u, v);		
		double den = dot(n, dir);
		boolean intersectsPlane = false;
		double[] intrsctn = new double[3];
		if (Math.abs(den) > 1e-12) {
			double r = dot(n, minus(vertices[0], origin)) / den;
			if (r > 0) {
				intrsctn = plus(origin, prod(dir, r));
				intersectsPlane = true;
			}
		}		
		
		if (intersectsPlane) { //check if within triangle
			double[] w = minus(intrsctn, vertices[0]);
			double uu = dot(u, u);
			double uv = dot(u, v);
			double wv = dot(w, v);
			double vv = dot(v, v);
			double wu = dot(w, u);
			
			double s = (uv*wv - vv*wu) / (uv*uv - uu*vv);
			double t = (uv*wu - uu*wv) / (uv*uv - uu*vv);
			
			if (s >= 0 && t >= 0 && s+t <= 1) {
				System.arraycopy(intrsctn, 0, intersection, 0, intrsctn.length);
				result = true;
			}
		}
		
		return result;	
	}
	
	//surface normal from triangle of points (from cross product) 
	private static double[] normal(double[] u, double[] v) {
		return new double[]{u[1]*v[2]-u[2]*v[1], u[2]*v[0]-u[0]*v[2], u[0]*v[1]-u[1]*v[0]};
	}
	
	// ----- some nuisance math functions to avoid importing a library ------- 
	private static double[] prod(double[] a, double b) {
		double[] result = new double[a.length];
		for (int i = 0; i < a.length; i++) {
			result[i] += a[i]*b;
		}
		return result;
	}

	private static double dot(double[] a, double[] b) {
		double result = 0;
		for (int i = 0; i < a.length; i++) {
			result += a[i]*b[i];
		}
		return result;
	}
	
	private static double[] minus(double[] a, double[] b) {
		double[] result = new double[a.length];
		for (int i = 0; i < a.length; i++) {
			result[i] = a[i] - b[i];
		}
		return result;
	}
	
	private static double[] plus(double[] a, double[] b) {
		double[] result = new double[a.length];
		for (int i = 0; i < a.length; i++) {
			result[i] = a[i] + b[i];
		}
		return result;
	}
	// -------------------------------------------------------------------------- 
	
	/**
	 * Note: this is a port of C code from Fast Ray-Box Intersection by Andrew Woo, in 
	 * "Graphics Gems", Academic Press, 1990. The original code is here: 
	 * http://tog.acm.org/resources/GraphicsGems/gems/RayBox.c
	 * 
	 * @param minB Minimum bound of axis-aligned box in x,y,z. 
	 * @param maxB Maximum bound of axis-aligned box in x,y,z.
	 * @param origin Origin of ray (x,y,z point)
	 * @param dir Direction of ray
	 * @return true if the ray hits the box
	 */
	public static boolean intersectRayBox(double[] minB, double[] maxB, double[] origin, double[] dir) {
		int nDim = minB.length;		
		assert nDim == 2 || nDim == 3;
		
		/* Find candidate planes */
		boolean[] middle = new boolean[nDim];
		double[] candidatePlane = new double[nDim];
		for (int i = 0; i < nDim; i++) {
			if (origin[i] < minB[i]) {
				candidatePlane[i] = minB[i];
			} else if (origin[i] > maxB[i]) {
				candidatePlane[i] = maxB[i];
			} else {
				middle[i] = true;
			}
		}
		
		boolean originInBox = true;
		for (int i = 0; i < nDim; i++) {
			if (!middle[i]) originInBox = false;
		}
		if (originInBox) return true;
		
		double[] maxT = new double[nDim];
		for (int i = 0; i < nDim; i++) {
			if (!middle[i] && Math.abs(dir[i]) > Double.MIN_VALUE) {
				maxT[i] = (candidatePlane[i]-origin[i]) / dir[i];
			} else {
				maxT[i] = -1;
			}
		}
		
		int whichPlane = 0;
		for (int i = 0; i < nDim; i++) {
			if (maxT[whichPlane] < maxT[i]) whichPlane = i;
		}

		/* Check final candidate actually inside box */
		if (maxT[whichPlane] < 0.) return false;
		
		double coord[] = new double[nDim]; //we don't need to return this, so we don't 
		for (int i = 0; i < nDim; i++) {
			if (whichPlane != i) {
				coord[i] = origin[i] + maxT[whichPlane] *dir[i];
				if (coord[i] < minB[i] || coord[i] > maxB[i])
					return false;
			} else {
				coord[i] = candidatePlane[i];
			}
		}
		
		return true;  
	}
	
}
