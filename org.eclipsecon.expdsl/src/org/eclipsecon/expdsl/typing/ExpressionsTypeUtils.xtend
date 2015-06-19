package org.eclipsecon.expdsl.typing

import org.eclipsecon.expdsl.expressions.BoolType
import org.eclipsecon.expdsl.expressions.IntType
import org.eclipsecon.expdsl.expressions.StringType
import org.eclipsecon.expdsl.expressions.Type

class ExpressionsTypeUtils {
	def String representation(Type type) {
		switch (type) {
			IntType: "int"
			StringType: "string"
			BoolType: "boolean"
			default: "Unknown"
		}
	}
}