package org.eclipsecon.expdsl.ui.tests

import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.junit.ui.AbstractContentAssistTest
import org.eclipsecon.expdsl.ExpressionsUiInjectorProvider
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(ExpressionsUiInjectorProvider))
class ExpressionsContentAssistTest extends AbstractContentAssistTest {

	@Test
	def void testVariableReference() {
		newBuilder.append("int i = 10 1+").assertProposal('i')
	}

	@Test
	def void testProposals() {
		newBuilder.append("int i = 10 1+").
			assertText('!', '"Value"', '(', '+', '1', 'false', 'i', 'true')
	}

	@Test
	def void testForwardVariableReference() {
		// specify cursor position with <|>
		newBuilder.append("<|> int i = 10 ").assertNoProposalAtCursor("i")
		// i must not be present in proposals, before its definition
	}

	@Test
	def void testForwardVariableReference2() {
		// specify the cursor character explicitly
		newBuilder.append("int k=0 int j=1 1+  int i = 10 ").
			//                               ^
			assertTextAtCursorPosition("+", 1,
			'!', '"Value"', '(', '+', '1', 'false', 'j', 'k', 'true')
		// i must not be present in proposals, before its definition
		// but j and k must be there
	}

	@Test
	def void testProposeOnlyIntegerVariablesInMultiplication() {
		newBuilder.append("string s='a' int k=0 int j=1 1*   ").
			//                                            ^
			assertTextAtCursorPosition("*", 1,
			'!', '"Value"', '(', '*', '1', 'false', 'j', 'k', 'true')
		// s must not be present in proposals: it has the wrong type
	}

}