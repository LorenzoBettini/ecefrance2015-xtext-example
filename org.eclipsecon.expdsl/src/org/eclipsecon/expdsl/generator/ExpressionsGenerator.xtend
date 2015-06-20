/*
 * generated by Xtext
 */
package org.eclipsecon.expdsl.generator

import com.google.inject.Inject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator
import org.eclipsecon.expdsl.expressions.AbstractElement
import org.eclipsecon.expdsl.expressions.And
import org.eclipsecon.expdsl.expressions.BoolConstant
import org.eclipsecon.expdsl.expressions.Comparison
import org.eclipsecon.expdsl.expressions.Equality
import org.eclipsecon.expdsl.expressions.Expression
import org.eclipsecon.expdsl.expressions.ExpressionsModel
import org.eclipsecon.expdsl.expressions.IntConstant
import org.eclipsecon.expdsl.expressions.Minus
import org.eclipsecon.expdsl.expressions.MulOrDiv
import org.eclipsecon.expdsl.expressions.Not
import org.eclipsecon.expdsl.expressions.Or
import org.eclipsecon.expdsl.expressions.Plus
import org.eclipsecon.expdsl.expressions.StringConstant
import org.eclipsecon.expdsl.expressions.Variable
import org.eclipsecon.expdsl.expressions.VariableRef
import org.eclipsecon.expdsl.typing.ExpressionsTypeProvider
import org.eclipsecon.expdsl.typing.ExpressionsTypeUtils

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class ExpressionsGenerator implements IGenerator {

	@Inject extension ExpressionsTypeUtils
	@Inject extension ExpressionsTypeProvider
	
	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		resource.allContents.toIterable.filter(typeof(ExpressionsModel)).forEach[
			val origFileName = resource.URI.lastSegment
			val javaClassName = origFileName.substring(0, origFileName.lastIndexOf('.')).toFirstUpper
			fsa.generateFile('''expressions/«javaClassName».java''', 
				compileToJava(javaClassName)
			)
		]
	}

	def compileToJava(ExpressionsModel model, String javaClassName) {
		'''
		package expressions;
		
		@SuppressWarnings("all")
		public class «javaClassName» {
			public void eval() {
				«model.elements.map[compileElementToJava].join("")»
			}
		}
		'''
	}

	def String compileElementToJava(AbstractElement e) {
		if (e instanceof Variable) {
			'''
			«e.declaredType.javaRepresentation» «e.name» = «e.expression.compileToJava»;
			'''
		} else {
			'''
			System.out.println("" + «(e as Expression).compileToJava»);
			'''
		}
	}

	def dispatch String compileToJava(IntConstant e) {
		e.value.toString
	}

	def dispatch String compileToJava(BoolConstant e) {
		e.value
	}

	def dispatch String compileToJava(StringConstant e) {
		'''"«e.value»"'''
	}

	def dispatch String compileToJava(VariableRef e) {
		e.variable.name
	}

	def dispatch String compileToJava(Not e) {
		"!(" + e.expression.compileToJava + ")"
	}

	def dispatch String compileToJava(MulOrDiv e) {
		'''(«e.left.compileToJava» «e.op» «e.right.compileToJava»)'''
	}

	def dispatch String compileToJava(Minus e) {
		'''(«e.left.compileToJava» «e.op» «e.right.compileToJava»)'''
	}

	def dispatch String compileToJava(Plus e) {
		'''(«e.left.compileToJava» «e.op» «e.right.compileToJava»)'''
	}

	def dispatch String compileToJava(And e) {
		'''(«e.left.compileToJava» «e.op» «e.right.compileToJava»)'''
	}

	def dispatch String compileToJava(Or e) {
		'''(«e.left.compileToJava» «e.op» «e.right.compileToJava»)'''
	}

	def dispatch String compileToJava(Equality e) {
		if (e.left.inferredType.isString) {
			'''(«e.left.compileToJava».equals(«e.right.compileToJava») «e.op» true)'''
		} else {
			'''(«e.left.compileToJava» «e.op» «e.right.compileToJava»)'''
		}
	}

	def dispatch String compileToJava(Comparison e) {
		if (e.left.inferredType.isString) {
			'''(«e.left.compileToJava».compareTo(«e.right.compileToJava») «e.op» 0)'''
		} else {
			'''(«e.left.compileToJava» «e.op» «e.right.compileToJava»)'''
		}
	}

}
