package org.eclipsecon.expdsl.typing

import com.google.inject.Inject
import org.eclipsecon.expdsl.expressions.Type

class ExpressionsTypeConformanceComputer {
	
	@Inject extension ExpressionsTypeProvider
	
	/**
	 * Is type1 assignable to type2, that is, is type1 subtype of type2
	 */
	def boolean isAssignableTo(Type type1, Type type2) {
		if (type2.isString)
			return true
		return type1.eClass == type2.eClass
	}
}