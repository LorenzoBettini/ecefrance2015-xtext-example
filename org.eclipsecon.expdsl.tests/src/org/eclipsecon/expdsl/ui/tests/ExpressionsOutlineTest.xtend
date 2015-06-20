package org.eclipsecon.expdsl.ui.tests

import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.ui.tests.editor.outline.AbstractOutlineWorkbenchTest
import org.eclipsecon.expdsl.ExpressionsUiInjectorProvider
import org.eclipsecon.expdsl.ui.internal.ExpressionsActivator
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(ExpressionsUiInjectorProvider))
class ExpressionsOutlineTest extends AbstractOutlineWorkbenchTest {
	
	override protected getEditorId() {
		ExpressionsActivator.ORG_ECLIPSECON_EXPDSL_EXPRESSIONS
	}

	@Test
	def void testOutlineOfExpDslFile() {
		'''
int i = 0
string s = "a"
s + i
bool b = false
		'''.assertAllLabels(
'''
test
  int i
  string s
  expression
  bool b
'''
		)
	}

}