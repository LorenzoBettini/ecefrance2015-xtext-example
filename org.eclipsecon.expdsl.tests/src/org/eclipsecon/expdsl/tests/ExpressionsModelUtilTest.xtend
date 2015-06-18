package org.eclipsecon.expdsl.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipsecon.expdsl.ExpressionsInjectorProvider
import org.eclipsecon.expdsl.expressions.ExpressionsModel
import org.eclipsecon.expdsl.util.ExpressionsModelUtil
import org.junit.Test
import org.junit.runner.RunWith

import static extension org.junit.Assert.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(ExpressionsInjectorProvider))
class ExpressionsModelUtilTest {
	
	@Inject extension ParseHelper<ExpressionsModel>
	@Inject extension ExpressionsModelUtil

	@Test def void variablesBeforeVariable() {
		'''
		true		// (0)
		int i = 0	// (1)
		i + 10		// (2)
		int j = i	// (3)
		i + j		// (4)
		'''.parse => [
			assertVariablesDefinedBefore(0, "")
			assertVariablesDefinedBefore(1, "")
			assertVariablesDefinedBefore(2, "i")
			assertVariablesDefinedBefore(3, "i")
			assertVariablesDefinedBefore(4, "i,j")
		]
	}

	def void assertVariablesDefinedBefore(ExpressionsModel model, 
				int elemIndex, CharSequence expectedVars) {
		expectedVars.assertEquals(
			model.elements.get(elemIndex).variablesDefinedBefore.
			map[name].join(",")
		)
	}
}