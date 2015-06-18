package org.eclipsecon.expdsl.util

import org.eclipsecon.expdsl.expressions.AbstractElement
import org.eclipsecon.expdsl.expressions.ExpressionsModel
import org.eclipsecon.expdsl.expressions.Variable

import static org.eclipse.emf.ecore.util.EcoreUtil.*

import static extension org.eclipse.xtext.EcoreUtil2.*

class ExpressionsModelUtil {
	def variablesDefinedBefore(AbstractElement e) {
		val allElements = 
			e.getContainerOfType(typeof(ExpressionsModel)).
				elements
		val containingElement = allElements.findFirst[isAncestor(it, e)]
		allElements.subList(0, allElements.indexOf(containingElement)).
			typeSelect(typeof(Variable))
	}
}