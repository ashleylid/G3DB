/**
 * 
 */
package ca.uwaterloo.nrlab.ray;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.junit.Assert;
import org.junit.Test;

import ca.uwaterloo.nrlab.ray.AABBTree.LeafNode;
import ca.uwaterloo.nrlab.ray.AABBTree.Node;

/**
 * Unit tests for AABBTree. 
 * 
 * @author Bryan Tripp
 */
public class AABBTreeTest {

	/**
	 * Test method for {@link ca.uwaterloo.nrlab.ray.AABBTree#makeTree(double[][][])}.
	 */
	@Test
	public void testMakeTree() {
		double[][][] p = new double[3][][];
		p[0] = new double[][]{{0,0,0}, {1,1,1}, {0,1,1}};
		p[1] = new double[][]{{1,0,0}, {2,1,1}, {1,1,1}}; //+ve in 1st dim
		p[2] = new double[][]{{0.1,-1,0}, {1.1,0,1}, {0.1,0,1}}; //slightly +ve in first dim, -ve in 2nd
		
		//just testing that it runs
		AABBTree.makeTree(p);
	}
	
	@Test
	public void testSortOrder() {
		double[][][] p = new double[3][][];
		p[0] = new double[][]{{0,0,0}, {1,1,1}, {0,1,1}};
		p[1] = new double[][]{{1,0,0}, {2,1,1}, {1,1,1}}; //+ve in 1st dim
		p[2] = new double[][]{{0.05,-1,0}, {1.05,0,1}, {0.05,0,1}}; //slightly +ve in first dim, -ve in 2nd
		
		List<Node> nodes = new ArrayList<Node>(p.length);
		for (int i = 0; i < p.length; i++) {
			nodes.add(new LeafNode(p[i]));
		}
		
		Collections.sort(nodes);
		
		Assert.assertEquals(0.05, nodes.get(0).myBoundingBox[0][0], .001);
		Assert.assertEquals(0, nodes.get(1).myBoundingBox[0][0], .001);
		Assert.assertEquals(1, nodes.get(2).myBoundingBox[0][0], .001);
	}
	
	@Test
	public void testGetIntersections() {

		//triangular cube faces
		double[][][] p = new double[12][][];
		p[0] = new double[][]{{0,0,0}, {0,0,1}, {0,1,1}};
		p[1] = new double[][]{{0,0,0}, {0,1,0}, {0,1,1}};
		p[2] = new double[][]{{1,0,0}, {1,0,1}, {1,1,1}};
		p[3] = new double[][]{{1,0,0}, {1,1,0}, {1,1,1}};
		p[4] = new double[][]{{0,0,0}, {0,1,0}, {1,1,0}};
		p[5] = new double[][]{{0,0,0}, {1,0,0}, {1,1,0}};
		p[6] = new double[][]{{0,0,1}, {0,1,1}, {1,1,1}};
		p[7] = new double[][]{{0,0,1}, {1,0,1}, {1,1,1}};
		p[8] = new double[][]{{0,0,0}, {0,0,1}, {1,0,1}};
		p[9] = new double[][]{{0,0,0}, {1,0,0}, {1,0,1}};
		p[10] = new double[][]{{0,1,0}, {0,1,1}, {1,1,1}};
		p[11] = new double[][]{{0,1,0}, {1,1,0}, {1,1,1}};
		
		Node root = AABBTree.makeTree(p);	
		
		List<double[]> intersections;
		
		intersections = root.getIntersections(new double[]{.5,.5,2}, new double[]{0,0,-1});
		Assert.assertEquals(2, intersections.size());
		Assert.assertArrayEquals(new double[]{.5, .5, 0}, intersections.get(0), 1e-5);
		Assert.assertArrayEquals(new double[]{.5, .5, 1}, intersections.get(1), 1e-5);
		
		intersections = root.getIntersections(new double[]{.3,.3,.5}, new double[]{0,0,-1});
		Assert.assertEquals(1, intersections.size());
		Assert.assertArrayEquals(new double[]{.3, .3, 0}, intersections.get(0), 1e-5);
		
		double[] point = AABBTree.getRandomPointInVolume(root);
		for (int i = 0; i < 3; i++) {
			Assert.assertTrue(point[i] >= 0);
			Assert.assertTrue(point[i] <= 1);
		}
		
//		System.out.println(toString(point));
	}

	/**
	 * Test method for {@link ca.uwaterloo.nrlab.ray.AABBTree#intersectRayPolygon(double[][], double[], double[], double[])}.
	 */
	@Test
	public void testIntersectRayPolygon() {
		double[][] vertices = {{0,0,0}, {0,0,1}, {0,1,1}};
		double[] intersection = new double[3];

		double[] origin;
		double[] dir;
		boolean intersects;
		
		origin = new double[]{1,.3,.7};
		dir = new double[]{-1,0,0};
		intersects = AABBTree.intersectRayPolygon(vertices, origin, dir, intersection);
		Assert.assertTrue(intersects);

		origin = new double[]{1,.7,.3};
		dir = new double[]{-1,0,0};
		intersects = AABBTree.intersectRayPolygon(vertices, origin, dir, intersection);
		Assert.assertFalse(intersects);
		
		origin = new double[]{1,.3,.7};
		dir = new double[]{0,1,0};
		intersects = AABBTree.intersectRayPolygon(vertices, origin, dir, intersection);
		Assert.assertFalse(intersects);
		
		origin = new double[]{1,0,0};
		dir = new double[]{-1,0,0};
		intersects = AABBTree.intersectRayPolygon(vertices, origin, dir, intersection);
		Assert.assertTrue(intersects);

		origin = new double[]{1,0,0};
		dir = new double[]{1,0,0};
		intersects = AABBTree.intersectRayPolygon(vertices, origin, dir, intersection);
		Assert.assertFalse(intersects);
		
		origin = new double[]{1,0,0};
		dir = new double[]{-1,0,1}; //on angle to other corner
		intersects = AABBTree.intersectRayPolygon(vertices, origin, dir, intersection);
		Assert.assertTrue(intersects);

		origin = new double[]{1,0,0};
		dir = new double[]{-1,0,1.01}; //on angle past other corner
		intersects = AABBTree.intersectRayPolygon(vertices, origin, dir, intersection);
		Assert.assertFalse(intersects);

		origin = new double[]{1,0,0};
		dir = new double[]{-1,0,1.01}; //on angle past other corner
		intersects = AABBTree.intersectRayPolygon(vertices, origin, dir, intersection);
		Assert.assertFalse(intersects);

		vertices = new double[][]{{.5,.5,0}, {.5,-.5,.5}, {-.5,.5,.5}};
		origin = new double[]{1,1,1};
		dir = new double[]{-1,-1,-1}; 
		intersects = AABBTree.intersectRayPolygon(vertices, origin, dir, intersection);
		Assert.assertTrue(intersects);
	
		vertices = new double[][]{{-8.5524,2.5360,-0.8949}, {-8.9189,2.0826,1.6472}, {-10.3807, 3.5311, 1.6066}};
        origin = new double[]{-9.4,2.75,20};
        dir = new double[]{0,0,-1};
        intersects = ca.uwaterloo.nrlab.ray.AABBTree.intersectRayPolygon(vertices, origin, dir, intersection);
		Assert.assertTrue(intersects);       	
	}

	/**
	 * Test method for {@link ca.uwaterloo.nrlab.ray.AABBTree#intersectRayBox(double[], double[], double[], double[])}.
	 */
	@Test
	public void testIntersectRayBox() {
		double[] minB = new double[]{-1,-1,-1};
		double[] maxB = new double[]{1,1,1};
		double[] origin = new double[]{0,0,10};
		double[] dir = new double[]{.1,.1,-1};	
		Assert.assertTrue(AABBTree.intersectRayBox(minB, maxB, origin, dir));
		long startTime = System.currentTimeMillis();
		for (int i = 0; i < 1000000; i++) {
			AABBTree.intersectRayBox(minB, maxB, origin, dir);
		}
		long endTime = System.currentTimeMillis();
		Assert.assertTrue((endTime-startTime) < 1000);
		System.out.println("1 million ray-box intersection tests took " + (endTime-startTime) + "ms");
		
		//test ray origin inside box
		origin = new double[]{0,0,0};
		dir = new double[]{.1,.1,-1};	
		Assert.assertTrue(AABBTree.intersectRayBox(minB, maxB, origin, dir));
	}
	
//	private static String toString(double[] x) {
//		StringBuffer b = new StringBuffer("[");
//		for (int i = 0; i < x.length; i++) {
//			b.append(x[i]);
//			if (i < x.length -1) {
//				b.append(",");
//			}
//		}
//		b.append("]");
//		return b.toString();
//	}

}
