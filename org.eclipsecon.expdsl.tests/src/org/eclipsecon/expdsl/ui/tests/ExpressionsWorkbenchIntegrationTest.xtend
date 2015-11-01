package org.eclipsecon.expdsl.ui.tests

import org.eclipse.core.resources.IMarker
import org.eclipse.core.resources.IResource
import org.eclipse.xtext.junit4.ui.AbstractWorkbenchTest
import org.eclipse.xtext.ui.XtextProjectHelper
import org.junit.Before
import org.junit.Test

import static org.eclipse.xtext.junit4.ui.util.JavaProjectSetupUtil.*

import static extension org.eclipse.xtext.junit4.ui.util.IResourcesSetupUtil.*

class ExpressionsWorkbenchIntegrationTest extends AbstractWorkbenchTest {

	val TEST_PROJECT = "mytestproject"
	
	@Before
	override void setUp() {
		super.setUp
		createJavaProject(TEST_PROJECT) => [
			project.addNature(XtextProjectHelper.NATURE_ID)
		]
	}
	
	def void checkProgram(String contents, int expectedErrors) {
		createFile(TEST_PROJECT + "/src/test.expdsl", contents)
		waitForBuild();
		val markers = root.findMarkers(IMarker.PROBLEM, true, IResource.DEPTH_INFINITE).
			filter[
				getAttribute(IMarker.SEVERITY, IMarker.SEVERITY_INFO) == IMarker.SEVERITY_ERROR
			]
		assertEquals(
			"expecting " + expectedErrors + " but got errors:\n" +
			markers.map[getAttribute(IMarker.LOCATION) + 
				", " + getAttribute(IMarker.MESSAGE)].join("\n"),
			expectedErrors, 
			markers.size
		)
	}

	@Test
	def void testValidProgram() {
		checkProgram("int i = 0", 0)
	}

	@Test
	def void testNotValidProgram() {
		// expect one error: unresolved variable reference
		checkProgram("foo", 1)
	}
}