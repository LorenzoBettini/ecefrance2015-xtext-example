package org.eclipsecon.expdsl.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipsecon.expdsl.ExpressionsInjectorProvider
import org.eclipsecon.expdsl.typing.ExpressionsTypeUtils
import org.junit.Test
import org.junit.runner.RunWith

import static org.eclipsecon.expdsl.typing.ExpressionsTypeProvider.*

import static extension org.junit.Assert.*

@RunWith(XtextRunner)
@InjectWith(ExpressionsInjectorProvider)
class ExpressionsTypeUtilsTest {
	
	@Inject extension ExpressionsTypeUtils

	@Test def void testStringRepresentation() {
		"int".assertEquals(intType.stringRepresentation)
		"string".assertEquals(stringType.stringRepresentation)
		"bool".assertEquals(boolType.stringRepresentation)
	}

	@Test def void testJavaRepresentation() {
		"int".assertEquals(intType.javaRepresentation)
		"String".assertEquals(stringType.javaRepresentation)
		"boolean".assertEquals(boolType.javaRepresentation)
	}
}