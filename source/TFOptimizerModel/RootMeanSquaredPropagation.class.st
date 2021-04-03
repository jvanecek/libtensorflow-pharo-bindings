Class {
	#name : #RootMeanSquaredPropagation,
	#superclass : #OptimizationAlgorithm,
	#instVars : [
		'learningRate',
		'rho',
		'momentum',
		'epsilon',
		'meanSquaredAccumByVariable',
		'momentumAccumByVariable'
	],
	#category : 'TFOptimizerModel'
}

{ #category : #Accessing }
RootMeanSquaredPropagation class >> defaultEpsilonValue [

	^1e-07
]

{ #category : #Accessing }
RootMeanSquaredPropagation class >> defaultLearningRate [

	^0.001
]

{ #category : #Accessing }
RootMeanSquaredPropagation class >> defaultMomentumValue [

	^0.0
]

{ #category : #Accessing }
RootMeanSquaredPropagation class >> defaultRhoFactor [

	^0.9
]

{ #category : #'Instance Creation' }
RootMeanSquaredPropagation class >> new [

	^self
		scalingBy: self defaultLearningRate
		decayingBy: self defaultRhoFactor
		momentumSetTo: self defaultMomentumValue
		usingForNumericalStability: self defaultEpsilonValue
]

{ #category : #'Instance Creation' }
RootMeanSquaredPropagation class >> scalingBy: aLearningRate decayingBy: theRhoFactor momentumSetTo: aMomentumConstant usingForNumericalStability: anEpsilonValue [

	^super new
		initializeScalingBy: aLearningRate
		decayingBy: theRhoFactor
		momentumSetTo: aMomentumConstant
		usingForNumericalStability: anEpsilonValue
]

{ #category : #Applying }
RootMeanSquaredPropagation >> apply: aGradient to: aVariable [

	^aVariable currentComputation
		newOperationOf: 'ApplyRMSProp'
		namePrefixed: ('Optimization_<1s>' expandMacrosWith: aVariable operationName)
		withAll: (
			OrderedCollection new
				add: aVariable;
				add: (self meanSquaredAccumulatorFor: aVariable);
				add: (self momentumAccumulatorFor: aVariable);
				add: learningRate;
				add: rho;
				add: momentum;
				add: epsilon;
				add: aGradient;
				yourself)
		describedBy: [:description | ]
]

{ #category : #Initialization }
RootMeanSquaredPropagation >> initializeScalingBy: aLearningRate decayingBy: theRhoFactor momentumSetTo: aMomentumConstant usingForNumericalStability: anEpsilonValue [

	learningRate := aLearningRate.
	rho := theRhoFactor.
	momentum := aMomentumConstant.
	epsilon := anEpsilonValue.
	meanSquaredAccumByVariable := Dictionary new.
	momentumAccumByVariable := Dictionary new
]

{ #category : #Accessing }
RootMeanSquaredPropagation >> meanSquaredAccumulatorFor: aVariable [

	^meanSquaredAccumByVariable
		at: aVariable
		ifAbsentPut: [
			VariableNode on: aVariable currentComputation named: 'ms' filledWithZerosLike: aVariable]
]

{ #category : #Accessing }
RootMeanSquaredPropagation >> momentumAccumulatorFor: aVariable [

	^momentumAccumByVariable
		at: aVariable
		ifAbsentPut: [
			VariableNode on: aVariable currentComputation named: 'mom' filledWithZerosLike: aVariable]
]

{ #category : #Printing }
RootMeanSquaredPropagation >> printOn: aStream [

	aStream nextPutAll: (
		'RMSProp (learning rate: <1p>; rho: <2p>; momentum: <3p>; epsilon: <4p>)'
			expandMacrosWith: learningRate
			with: rho
			with: momentum
			with: epsilon asFloat)
]

{ #category : #Accessing }
RootMeanSquaredPropagation >> shortName [

	^'RMSProp'
]