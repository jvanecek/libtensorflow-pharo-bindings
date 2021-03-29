Class {
	#name : #TensorFlowCAPITest,
	#superclass : #TestCase,
	#instVars : [
		'library'
	],
	#category : #TensorFlowCoreTests
}

{ #category : #graphs }
TensorFlowCAPITest >> addGraphTwoInputsInt64 [
	| graph in1 in2 |
	graph := TFGraph create.
	in1 := graph placeholder: 'in1' type: TFTensor typeInt64.
	in2 := graph placeholder: 'in2' type: TFTensor typeInt64.
	graph
		add: 'add'
		described: [ :description | 
			description addInput: (in1 output: 0).
			description addInput: (in2 output: 0) ].
	^ graph
]

{ #category : #graphs }
TensorFlowCAPITest >> asStringGraphType: type [
	| graph in |
	graph := TFGraph create.
	in := graph placeholder: 'in' type: type.
	graph asString: 'out' described: [ :description | description addInput: (in output: 0) ].
	^ graph
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> assertElementsOf: tensorArray are: allElementsArray [
	self assert: allElementsArray equals: (TFTensor elementsOf: tensorArray)
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> assertRankOf: aMultidimensionalTensor is: anInteger [
	| rank |
	rank := TFTensor rankOf: aMultidimensionalTensor.
	self
		assert: rank = anInteger
		description:
			'The rank is ' , rank printString , ' and should have been '
				, anInteger printString
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> assertShapeOf: aMultidimensionalTensor is: anArray [
	| shape |
	shape := TFTensor shapeOf: aMultidimensionalTensor.
	self
		assert: shape = anArray
		description:
			'The shape is ' , shape printString , ' and should have been '
				, anArray printString
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> assertSizeOf: aMultidimensionalTensor is: anInteger [
	| size |
	size := TFTensor sizeOf: aMultidimensionalTensor.
	self
		assert: size = anInteger
		description: 'The size is ', size printString, ' and should have been ', anInteger printString
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> assertTensor: aTF_Tensor elementsEquals: tensorArray [
	self assert: aTF_Tensor allElements equals: tensorArray
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> assertTensor: aTF_Tensor streamEquals: tensorArray [
	| strm |
	strm := aTF_Tensor asStream.
	tensorArray do: [:each |
		self assert: each equals: strm next]

]

{ #category : #'testing strings' }
TensorFlowCAPITest >> assertTensorFromStrings: strings shape: shape [
	| tensor |
	tensor := TFTensor fromStrings: strings shape: shape.
	self assert: shape equals: tensor shape.
	self assert: strings equals: tensor allStrings
]

{ #category : #graphs }
TensorFlowCAPITest >> concatGraphInputList [
	| graph in1 in2 concat dimension dimensionValue inputs |
	graph := TFGraph create.
	dimensionValue := TFTensor fromInt32: 0.
	dimension := graph const: 'const' value: dimensionValue.
	in1 := graph placeholder: 'in1' type: TFTensor typeInt64.
	in2 := graph placeholder: 'in2' type: TFTensor typeInt64.
	inputs := Array with: (in1 output: 0) with: (in2 output: 0).
	concat := graph
		concat: 'concat'
		described: [ :description | 
			description addInput: (dimension output: 0).
			description addInputs: inputs.
			description at: 'N' putInt: 2.
			description at: 'T' putType: TFTensor typeInt64 ].
	concat.
	^ graph
]

{ #category : #graphs }
TensorFlowCAPITest >> concatGraphInputListNoSizeNoType [
	| graph in1 in2 concat dimension dimensionValue inputs |
	graph := TFGraph create.
	dimensionValue := TFTensor fromInt32: 0.
	dimension := graph const: 'const' value: dimensionValue.
	in1 := graph placeholder: 'in1' type: TFTensor typeInt64.
	in2 := graph placeholder: 'in2' type: TFTensor typeInt64.
	inputs := Array with: (in1 output: 0) with: (in2 output: 0).
	concat := graph
		concat: 'concat'
		described: [ :description | 
			description addInput: (dimension output: 0).
			description addInputs: inputs ].
	concat.
	^ graph
]

{ #category : #graphs }
TensorFlowCAPITest >> concatGraphInputListWrongSize [
	| graph in1 in2 concat dimension dimensionValue inputs |
	graph := TFGraph create.
	dimensionValue := TFTensor fromInt32: 0.
	dimension := graph const: 'const' value: dimensionValue.
	in1 := graph placeholder: 'in1' type: TFTensor typeInt64.
	in2 := graph placeholder: 'in2' type: TFTensor typeInt64.
	inputs := Array with: (in1 output: 0) with: (in2 output: 0).
	concat := graph
		concat: 'concat'
		described: [ :description | 
			description addInput: (dimension output: 0).
			description addInputs: inputs.
			description at: 'N' putInt: 0 ].
	concat.
	^ graph
]

{ #category : #graphs }
TensorFlowCAPITest >> concatGraphInputListWrongType [
	| graph in1 in2 concat dimension dimensionValue inputs |
	graph := TFGraph create.
	dimensionValue := TFTensor fromInt32: 0.
	dimension := graph const: 'const' value: dimensionValue.
	
	in1 := graph placeholder: 'in1' type: TFTensor typeInt64.
	in2 := graph placeholder: 'in2' type: TFTensor typeInt64.
	inputs := Array with: (in1 output: 0) with: (in2 output: 0).
	concat := graph concat: 'concat' described: [:description |
		description addInput: (dimension output: 0).
		description addInputs: inputs.
		description at: 'T' putType: TFTensor typeInt32.
	].
	concat.
	^ graph
]

{ #category : #graphs }
TensorFlowCAPITest >> constant2x2FloatGraphDef [
	" This GraphDef corresponds to simple Graph, defined as
	
	a = tf.constant([[-1.1, -2.1],[-1.2,-2.2]], name='a')
	
	saved as ProtoBuf "

	^ #[16r0A 16r42 16r0A 16r01 16r61 16r12 16r05 16r43 16r6F 16r6E 16r73 16r74 16r2A 16r29 16r0A 16r05 16r76 16r61 16r6C 16r75 16r65 16r12 16r20 16r42 16r1E 16r08 16r01 16r12 16r08 16r12 16r02 16r08 16r02 16r12 16r02 16r08 16r02 16r22 16r10 16rCD 16rCC 16r8C 16rBF 16r66 16r66 16r06 16rC0 16r9A 16r99 16r99 16rBF 16rCD 16rCC 16r0C 16rC0 16r2A 16r0B 16r0A 16r05 16r64 16r74 16r79 16r70 16r65 16r12 16r02 16r30 16r01 16r0A 16r0C 16r0A 16r04 16r69 16r6E 16r69 16r74 16r12 16r04 16r4E 16r6F 16r4F 16r70 16r22 16r02 16r08 16r11]
		asString
]

{ #category : #graphs }
TensorFlowCAPITest >> constant2x2FloatGraphFromDef [
	^ TFGraph fromString: self constant2x2FloatGraphDef
]

{ #category : #graphs }
TensorFlowCAPITest >> constantFloatGraphDef [
	" This GraphDef corresponds to simple Graph, defined as
		
		tf.constant(0.42, name='a')
		
		saved as ProtoBuf "
	^ #[16r0A 16r2E 16r0A 16r01 16r61 16r12 16r05 16r43 16r6F 16r6E 16r73 16r74 16r2A 16r15 16r0A 16r05 16r76 16r61 16r6C 16r75 16r65 16r12 16r0C 16r42 16r0A 16r08 16r01 16r12 16r00 16r2A 16r04 16r3D 16r0A 16rD7 16r3E 16r2A 16r0B 16r0A 16r05 16r64 16r74 16r79 16r70 16r65 16r12 16r02 16r30 16r01 16r0A 16r0C 16r0A 16r04 16r69 16r6E 16r69 16r74 16r12 16r04 16r4E 16r6F 16r4F 16r70 16r22 16r02 16r08 16r0F]
		asString
]

{ #category : #graphs }
TensorFlowCAPITest >> constantFloatGraphFromDef [
	^ TFGraph fromString: self constantFloatGraphDef
]

{ #category : #graphs }
TensorFlowCAPITest >> constantInt32GraphDef [
	" This GraphDef corresponds to simple Graph, defined as
	
		tf.constant(0.42, name='a')
		
	 saved as ProtoBuf "
	^ #[
 16r0A 16r2B 16r0A 16r01 16r61 16r12 16r05 16r43 16r6F 16r6E 16r73 16r74 16r2A 16r12 16r0A 16r05
 16r76 16r61 16r6C 16r75 16r65 16r12 16r09 16r42 16r07 16r08 16r03 16r12 16r00 16r3A 16r01 16r2A
 16r2A 16r0B 16r0A 16r05 16r64 16r74 16r79 16r70 16r65 16r12 16r02 16r30 16r03 16r0A 16r0C 16r0A
 16r04 16r69 16r6E 16r69 16r74 16r12 16r04 16r4E 16r6F 16r4F 16r70 16r22 16r02 16r08 16r0F] asString
]

{ #category : #graphs }
TensorFlowCAPITest >> constantInt32GraphFromDef [
	^ TFGraph fromString: self constantInt32GraphDef
]

{ #category : #graphs }
TensorFlowCAPITest >> constantInt64Graph [
	| graph operation constant |
	graph := TFGraph create.
	constant := TFTensor fromInt64: 16r4242424242424242.
	operation := graph const: 'a' value: constant.
	self deny: operation isNull.
	^ graph
]

{ #category : #graphs }
TensorFlowCAPITest >> constantInt64GraphDef [
	" This GraphDef corresponds to simple Graph, defined as
	
		tf.constant(0.42, name='a')
		
	 saved as ProtoBuf "
^ #[
	10 12 10 4 105 110 105 116 18 4 78 111 79 112 10 51 10 1 97 18 5 67 111 110 115 116 42 11 10 5 100 116 121 112 101 18 2 48 9 42 26 10 5 118 97 108 117 101 18 17 66 15 8 9 18 0 82 9 194 132 137 146 164 200 144 161 66 18 0 34 2 8 15] asString
]

{ #category : #graphs }
TensorFlowCAPITest >> constantInt64GraphFromDef [
	^ TFGraph fromString: self constantInt64GraphDef
]

{ #category : #graphs }
TensorFlowCAPITest >> decodeCSVGraphDefaults: anArrayOfTF_Tensors [
	| graph records defaults |
	
	graph := TFGraph create.
	records := (graph placeholder: 'records' type: TFTensor typeString) output: 0.
	defaults := Array new: anArrayOfTF_Tensors size.
	
	anArrayOfTF_Tensors withIndexDo: [:each :index |
		| one |
		one := (graph const: 'default',index printString value: each) output: 0.
		defaults at: index put: one].
	graph newOperation: 'DecodeCSV' named: 'output' described: [:description |
		description addInput: records.
		description addInputs: defaults].
	
	^ graph
]

{ #category : #graphs }
TensorFlowCAPITest >> emptyGraph [
	^ TFGraph fromString: self emptyGraphDef
]

{ #category : #graphs }
TensorFlowCAPITest >> emptyGraphDef [
	" This GraphDef corresponds to an Empty Graph (no operations), saved as ProtoBuf "

	^ #[16r0A 16r0C 16r0A 16r04 16r69 16r6E 16r69 16r74 16r12 16r04 16r4E 16r6F 16r4F 16r70 16r22 16r02 16r08 16r0F]
		asString
]

{ #category : #graphs }
TensorFlowCAPITest >> floatAsStringGraph [
	| graph const |
	graph := self constantFloatGraphFromDef.
	const := graph operationNamed: 'a'.
	graph asString: 'output' described: [ :description | description addInput: (const output: 0) ].
	^ graph
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> get2x2FloatFromGraphDef [
	| graph session const result |
	graph := self constant2x2FloatGraphFromDef.
	
	const := (graph operationNamed: 'a') output: 0.
	session := TFSession on: graph.
	result := session runOutput: const.
	
	^ result
]

{ #category : #graphs }
TensorFlowCAPITest >> mulGraphOneInputInt64 [
	| graph constant const in |
	graph := TFGraph create.
	constant := TFTensor fromInt64: 16r0606060606060606.
	in := graph placeholder: 'in' type: constant type.
	const := graph const: 'const' value: constant.
	graph
		mul: 'mul'
		described: [ :description | 
			description addInput: (in output: 0).
			description addInput: (const output: 0) ].
	^ graph
]

{ #category : #graphs }
TensorFlowCAPITest >> mulGraphTwoInputsInt64 [
	| graph constant const in1 in2 mul1 |
	graph := TFGraph create.
	constant := TFTensor fromInt64: 16r0101010101010101.
	in1 := graph placeholder: 'in1' type: constant type.
	in2 := graph placeholder: 'in2' type: constant type.
	const := graph const: 'const' value: constant.
	mul1 := graph
		mul: 'mul1'
		described: [ :description | 
			description addInput: (const output: 0).
			description addInput: (in1 output: 0) ].
	graph
		mul: 'mul2'
		described: [ :description | 
			description addInput: (mul1 output: 0).
			description addInput: (in2 output: 0) ].
	^ graph
]

{ #category : #graphs }
TensorFlowCAPITest >> mulGraphTwoInputsInt64ConstTensorDeleted [
	| graph constant const in1 in2 mul1 |
	graph := TFGraph create.
	constant := TFTensor fromInt64: 16r2121212121212121.
	in1 := graph placeholder: 'in1' type: constant type.
	in2 := graph placeholder: 'in2' type: constant type.
	const := graph const: 'const' value: constant.
	constant delete.
	constant := TFTensor fromInt64: 16r2222222222222222.
	constant delete.
	mul1 := graph
		mul: 'mul1'
		described: [ :description | 
			description addInput: (const output: 0).
			description addInput: (in1 output: 0) ].
	graph
		mul: 'mul2'
		described: [ :description | 
			description addInput: (mul1 output: 0).
			description addInput: (in2 output: 0) ].
	^ graph
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> runFloatAsStringGraph [
	| session graph output result |
	graph := self floatAsStringGraph.
	session := TFSession on: graph.
	output := graph operationNamed: 'output'.
	result := session runOperation: output output: (output output: 0).
	^ result
]

{ #category : #initialization }
TensorFlowCAPITest >> setUp [
	super setUp.
	library := TensorFlowCAPI current
]

{ #category : #initialization }
TensorFlowCAPITest >> should: aBlock raiseError: aString [
	| message |
	message := 'No Error was signaled'.
	aBlock ifError: [:description :receiver | message := description].
	self assert: 'Error: ',aString isEqualSkippingSeparatorsTo: message.
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testAddControlInput [
	| graph in op result |
	self skip. 
	graph := TFGraph create.
	in := graph const: 'const' value: (TFTensor fromInt64: 12345678).
	op := graph
		newOperation: 'Mul'
		named: 'out'
		described: [ :description | 
			description
				addInput: (in output: 0);
				addInput: (in output: 0);
				addControlInput: (in output: 0) ].
	result := (TFSession on: graph) runOutput: (op output: 0).
	self assert: 12345678 * 12345678 equals: result allInt64s first
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testAllInitializers [
	| graph pisTensor initializers |
	graph := TFGraph create.
	pisTensor := TFTensor fromFloats: #(3.14 3.1415 3.141516).
	graph variable: 'var1' initialValue: pisTensor.
	graph variable: 'var2' initialValue: pisTensor.
	graph variable: 'var3' initialValue: pisTensor.
	initializers := graph allInitializers.
	self assert: initializers size equals: 3.
	self assert: 'var1_initializer' equals: initializers first name.
	self assert: 'var2_initializer' equals: initializers second name.
	self assert: 'var3_initializer' equals: initializers third name
]

{ #category : #'testing graph' }
TensorFlowCAPITest >> testAllOperations [
	| graph pisTensor operations names |
	graph := TFGraph create.
	pisTensor := TFTensor fromFloats: #(3.14 3.1415 3.141516).
	graph variable: 'var1' initialValue: pisTensor.
	graph variable: 'var2' initialValue: pisTensor.
	graph variable: 'var3' initialValue: pisTensor.
	operations := graph allOperations.
	self assert: operations size equals: 9.
	names := #(
				'var1' 'var1_initialValue' 'var1_initializer'
				'var2' 'var2_initialValue' 'var2_initializer'
				'var3' 'var3_initialValue' 'var3_initializer').
	names
		with: operations
		do: [ :name :op | self assert: name equals: op name ]
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testAllVariables [
	| graph pisTensor var1 vars var2 var3 |
	graph := TFGraph create.
	pisTensor := TFTensor fromFloats: #(3.14 3.1415 3.141516).
	var1 := graph variable: 'var1' initialValue: pisTensor.
	var2 := graph variable: 'var2' initialValue: pisTensor.
	var3 := graph variable: 'var3' initialValue: pisTensor.
	vars := graph allVariables.
	self assert: vars size equals: 3.
	self assert: vars first equals: var1.
	self assert: vars second equals: var2.
	self assert: vars third equals: var3
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testArrayFromStream [
	| t template array |
	t := 1.0 asTensor.
	template := #(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17) readStream.
	
	array := t arrayFromStream: template reset shape: (TensorShape vectorSized: 10).
	self assert: #(1 2 3 4 5 6 7 8 9 10) equals: array.
	
	array := t arrayFromStream: template reset shape: (TensorShape matrixSized: 2 by: 8).
	self assert: #((1 2 3 4 5 6 7 8) (9 10 11 12 13 14 15 16)) equals: array.
	
	array := t arrayFromStream: template reset shape: (TensorShape withDimensionsSized: #(2 4 2)).
	self assert: #(((1 2) (3 4) (5 6) (7 8)) ((9 10) (11 12) (13 14) (15 16))) equals: array.
	
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testAsBooleanTensor [
	self testAsBooleanTensor: true shape: #().
	self testAsBooleanTensor: #(true false true false) shape: #(4).
	self testAsBooleanTensor: #((true false true false) (false true false true)) shape: #(2 4).

]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testAsBooleanTensor: anArray shape: shapeArray [
	| tensor index bools |
	tensor := anArray asBooleanTensor.
	self assert: tensor shape equals: shapeArray.
	index := 1.
	bools := tensor allElements.
	TFTensor
		elementsOf: anArray
		do: [ :each | 
			self assert: (bools at: index) equals: each.
			index := index + 1 ]
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testAsFloatTensor [
	self testAsFloatTensor: 1 shape: #().
	self testAsFloatTensor: #(1 2 3 4) shape: #(4).
	self testAsFloatTensor: #((1 2 3 4) (3.14 1.71 2.12 -7.8)) shape: #(2 4).

]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testAsFloatTensor: tensorArray shape: shapeArray [
	| tensor index floats |
	tensor := tensorArray asFloatTensor.
	
	index := 1.
	floats := tensor allFloats.
	TFTensor elementsOf: tensorArray do: [:each |
		self assert: ((floats at: index) closeTo: each).
		index := index + 1].

	self assert: tensor shape equals: shapeArray
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testAsInt32Tensor [
	self testAsInt32Tensor: 1 shape: #().
	self testAsInt32Tensor: #(1 2 3 4) shape: #(4).
	self testAsInt32Tensor: #(#(1 2 3 4) #(-314 171 -212 -78)) shape: #(2 4)
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testAsInt32Tensor: tensorArray shape: shapeArray [
	| tensor index ints |
	tensor := tensorArray asInt32Tensor.
	
	self assert: tensor shape equals: shapeArray.
	
	index := 1.
	ints := tensor allInt32s.
	TFTensor elementsOf: tensorArray do: [:each |
		self assert: (ints at: index) equals: each.
		index := index + 1].


]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testAsInt64Tensor [
	self testAsInt64Tensor: 1 shape: #().
	self testAsInt64Tensor: #(1 2 3 4) shape: #(4).
	self testAsInt64Tensor: #(#(1 2 3 4) #(-314 171 -212 -78)) shape: #(2 4)
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testAsInt64Tensor: tensorArray shape: shapeArray [
	| tensor index ints |
	tensor := tensorArray asInt64Tensor.
	self assert: tensor shape equals: shapeArray.
	index := 1.
	ints := tensor allInt64s.
	TFTensor
		elementsOf: tensorArray
		do: [ :each | 
			self assert: (ints at: index) equals: each.
			index := index + 1 ]
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testAsStringGraphRunOn: tensor [
	| graph session in out result |
	graph := self asStringGraphType: tensor type.
	session := TFSession on: graph.
	in := graph operationNamed: 'in'.
	out := graph operationNamed: 'out'.
	result := session
		runInputs: {in input: 0}
		 values: {tensor} 
		outputs: {out output: 0}.
	^ result first
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testAttrGetBoolFalse [
	| graph in op |
	graph := TFGraph create.
	in := graph placeholder: 'in' type: TFTensor typeDouble.
	op := graph asString: 'out' described: [ :description | description addInput: (in output: 0) ].
	self assert: (op boolAt: 'scientific') equals: false
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testAttrGetBoolTrue [
	| graph in op input_min input_max |
	graph := TFGraph create.
	in := graph placeholder: 'in' type: TFTensor typeDouble.
	input_min := graph placeholder: 'input_min' type: TFTensor typeDouble.
	input_max := graph placeholder: 'input_max' type: TFTensor typeDouble.
	op := graph newOperation: 'QuantizeAndDequantizeV2' named: 'out' described: [ :description | description addInput: (in output: 0).
		description addInput: (input_min output:0).
		description addInput: (input_max output:0)].
	self assert: (op boolAt: 'signed_input') equals: true
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testAttrGetFloat [
	| graph in op |
	graph := TFGraph create.
	in := graph placeholder: 'in' type: TFTensor typeFloat.
	op := graph newOperation: 'FakeQuantWithMinMaxArgs' named: 'out' described: [ :description | description addInput: (in output: 0) ].
	self assert: (op floatAt: 'min') equals: -6.0.
	self assert: (op floatAt: 'max') equals: 6.0
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testAttrGetInt [
	| op graph |
	graph := self concatGraphInputList.
	op := graph operationNamed: 'concat'.
	self assert: (op intAt: 'N') equals: 2
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testAttrGetShape [
	| graph op |
	graph := TFGraph create.
	op := graph placeholder: 'in' type: TFTensor typeDouble.
	self assert: (op shapeAt: 'shape') equals: #()
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testAttrGetString [
	| graph in op |
	graph := TFGraph create.
	in := graph placeholder: 'in' type: TFTensor typeDouble.
	op := graph
		newOperation: 'AsString'
		named: 'out'
		described: [ :description | description addInput: (in output: 0) ].
	self assert: (op stringAt: 'fill') equals: ''
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testAttrGetStrings [
	| graph template in op strings |

	graph := TFGraph create.
	template := #('hola' 'como' 'estas?').
	in := graph const: 'in' value: (TFTensor fromFloats: 1).
	op := graph
		newOperation: 'DebugIdentity'
		named: 'out'
		described: [ :description | 
			description at: 'debug_urls' putStrings: template.
			description addInput: (in output: 0) ].
	strings := op stringsAt: 'debug_urls'.
	self assert: template equals: strings
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testAttrGetTensor [
	| op graph tensor |
	graph := self constantInt64Graph.
	op := graph operationNamed: 'a'.
	tensor := op tensorAt: 'value'.
	self assert: tensor type equals: TFTensor typeInt64.
	self assert: tensor shape equals: #().
	self assert: tensor allInt64s equals: #(16r4242424242424242)
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testAttrGetType [
	| op graph |
	graph := self concatGraphInputList.
	op := graph operationNamed: 'concat'.
	self assert: (op typeAt: 'T') equals: TFTensor typeInt64
]

{ #category : #'testing structures size' }
TensorFlowCAPITest >> testAttrMetadataStructureSizeIs32bits [
	self assert: TFAttrMetadata byteSize  equals: 32
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testAttrSetBoolFalse [
	| graph in op input_min input_max |
	graph := TFGraph
		create.
	in := graph
		placeholder: 'in'
		type:
			TFTensor
				typeDouble.
	input_min := graph
		placeholder:
			'input_min'
		type:
			TFTensor
				typeDouble.
	input_max := graph
		placeholder:
			'input_max'
		type:
			TFTensor
				typeDouble.
	op := graph
		newOperation:
			'QuantizeAndDequantizeV2'
		named:
			'out'
		described:
			[ :description | 
			description
				at:
					'signed_input'
				putBoolean:
					false.
			description
				addInput:
					(in
						output: 0).
			description
				addInput:
					(input_min
						output: 0).
			description
				addInput:
					(input_max
						output: 0) ].
	self
		assert:
			(op
				boolAt:
					'signed_input')
		equals:
			false
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testAttrSetBoolTrue [
	| graph in op |
	graph := TFGraph create.
	in := graph placeholder: 'in' type: TFTensor typeDouble.
	op := graph
		asString: 'out'
		described: [ :description | 
			description at: 'scientific' putBoolean: true.
			description addInput: (in output: 0) ].
	self assert: (op boolAt: 'scientific') equals: true
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testAttrSetFloat [
	| graph in op min max |
	min := -1234.5678e10.
	max := 12345678e-10 asFraction.
	graph := TFGraph create.
	in := graph placeholder: 'in' type: TFTensor typeFloat.
	op := graph
		newOperation: 'FakeQuantWithMinMaxArgs'
		named: 'out'
		described: [ :description | 
			description at: 'min' putFloat: min.
			description at: 'max' putFloat: max.
			description addInput: (in output: 0) ].
	self assert: ((op floatAt: 'min') closeTo: min).
	self assert: ((op floatAt: 'max') closeTo: max)
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testAttrSetShape [
	self testAttrSetShape: TensorShape scalar.
	self testAttrSetShape: (TensorShape vectorSized: 16r1234567890ABCDEF).
	self testAttrSetShape: (TensorShape withDimensionsSized: #(1 2 3 4)).
	self testAttrSetShape: (TensorShape withDimensionsSized: (1 to: 16) asArray)
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testAttrSetShape: anIntegerArray [
	| graph op |
	graph := TFGraph create.
	op := graph
		newOperation: 'Placeholder'
		named: 'const'
		described: [:description |
			description at: 'shape' putShape: anIntegerArray.
			description at: 'dtype' putType: TFTensor typeInt64].
		
	self assert: (op shapeAt: 'shape') equals: anIntegerArray.

]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testAttrSetString [
	self testAttrSetString: '1'.
	self testAttrSetString: '12'.
	self testAttrSetString: '1234'.
	self testAttrSetString: '1234567'.
	self testAttrSetString: '12345678'.
	self testAttrSetString: '123456789'.
	self testAttrSetString: ((ByteArray new: 100) atAllPut: 65) asString.
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testAttrSetString: aString [
	| graph in op copy |
	graph := TFGraph create.
	copy := aString asByteArray.
	
	in := graph placeholder: 'in' type: TFTensor typeDouble.
	op := graph newOperation: 'AsString' named: 'out' described: [:description |
		description at: 'fill' putString: copy.
		description addInput: (in output: 0)].
	
	copy at: 1 put: 65.	"Change Smalltalk String to see if TensorFlow makes a copy"	
	
	self assert: (op stringAt: 'fill') equals: aString.

]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testAttrSetStrings: aAnArrayOfStrings [
	| graph template in op |
	graph := TFGraph create.
	template := #((1 2 3) (4 5 6) (7 8 9)).
	in := graph const: 'in' value: (TFTensor fromFloats: template).
	op := graph newOperation: 'DebugIdentity' named: 'out' described: [:description |
		description at: 'debug_urls' putStrings: aAnArrayOfStrings.
		description addInput: (in output: 0)].
	
	(TFSession on: graph)
		runOutput: (op output: 0).


]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testAttrSetStringsInvalid [
	| graph template in notAList |
	graph := TFGraph create.
	template := #((1 2 3) (4 5 6) (7 8 9)).
	in := graph const: 'in' value: (TFTensor fromFloats: template).
	
	notAList := 'INVALID_ARGUMENT: AttrValue had value with type ''list(string)'' when ''string'' expected
	 for attr ''tensor_name''
	; NodeDef: {{node out}}; Op<name=DebugIdentity; signature=input:T -> output:T; attr=T:type; attr=device_name:string,default=""; attr=tensor_name:string,default=""; attr=debug_urls:list(string),default=[]; attr=gated_grpc:bool,default=false; allows_uninitialized_input=true>'.

	self
		should: [
			graph newOperation: 'DebugIdentity' named: 'out' described: [:description |
				description at: 'tensor_name' putStrings: #('hola' 'como' 'estas?').
				description addInput: (in output: 0)]]
		raiseError: notAList.	
]

{ #category : #'testing buffer' }
TensorFlowCAPITest >> testBufferDataBytes [
	| buffer string data |
	string := ' hola manola'.
	buffer := TFBuffer fromString: string.
	data := buffer dataBytes.
	self assert: string equals: data asString.
	buffer delete
]

{ #category : #'testing buffer' }
TensorFlowCAPITest >> testBufferNoNeedExternalize [
	| buffer string data |
	string := ' hola manola'.
	buffer := TFBuffer fromString: string.
	string := string copy.
	Smalltalk garbageCollect.
	data := buffer dataBytes.
	self assert: string equals: data asString.
	buffer delete
]

{ #category : #'testing structures size' }
TensorFlowCAPITest >> testBufferStructureSizeIs24bits [
	self assert: TFBuffer byteSize equals: 24
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testConcatGraphInputList [
	| wrongSize wrongType |
	wrongSize := 'INVALID_ARGUMENT: Inconsistent values for attr ''N'' 2 vs. 0 while building NodeDef ''concat'' using Op<name=Concat; signature=concat_dim:int32, values:N*T -> output:T; attr=N:int,min=2; attr=T:type>'.
	wrongType := 'INVALID_ARGUMENT: Inconsistent values for attr ''T'' DT_INT64 vs. DT_INT32 while building NodeDef ''concat'' using Op<name=Concat; signature=concat_dim:int32, values:N*T -> output:T; attr=N:int,min=2; attr=T:type>'.
	
	self concatGraphInputListNoSizeNoType.
	self concatGraphInputList.
	self
		should: [self concatGraphInputListWrongSize]
		raiseError: wrongSize.
		
	self
		should: [self concatGraphInputListWrongType]
		raiseError: wrongType.
	
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testCreateGraphAddTwoInputs [
	| graph |
	graph := self addGraphTwoInputsInt64
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testCreateGraphMulOneInput [
	| graph input mul |
	graph := self mulGraphOneInputInt64.
	input := graph operationNamed: 'in'.
	mul := graph operationNamed: 'mul'.
	self assert: input name equals: 'in'.
	self assert: mul name equals: 'mul'
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testDecodeCSVGraphCreate [
	| defaults |
	defaults := {
		TFTensor fromInt64s: #(-1).
		TFTensor fromInt64s: #(-1).
		TFTensor fromInt64s: #(-1).
		TFTensor fromInt64s: #(-1)}.
		
	self decodeCSVGraphDefaults: defaults.
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testDecodeCSVGraphRunCSV: csvLines [
	| defaults graph output records session results values |
	defaults := {
		TFTensor fromInt64s: #(-1).
		TFTensor fromInt64s: #(-1).
		TFTensor fromInt64s: #(-1).
		TFTensor fromInt64s: #(-1)}.
		
	graph := self decodeCSVGraphDefaults: defaults.
	records := (graph operationNamed: 'records') input: 0.
	output := graph operationNamed: 'output'.
	values := TFTensor fromStringArray: csvLines.
	
	session := TFSession on: graph.
	results := session
		runInputs: {records}
		values: {values}
		outputs: {
			(output output: 0).
			(output output: 1).
			(output output: 2).
			(output output: 3)}.
	^ (1 to: 4) collect: [:i |
		(results at: i) allInt64s].

]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testDecodeCSVGraphRunManyLines [
	| cols |
	cols := self testDecodeCSVGraphRunCSV:
	'1,2,3,4
	 11,22,33,44
	 111,222,333,444
	 1111,2222,3333,4444' lines.
	
	
	self assert: cols first equals: #(1 11 111 1111).
	self assert: cols second equals: #(2 22 222 2222).
	self assert: cols third equals: #(3 33 333 3333).
	self assert: cols fourth equals: #(4 44 444 4444).
	
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testDecodeCSVGraphRunOneLine [
	| cols |
	cols := self testDecodeCSVGraphRunCSV: '11111111111,22222222,33333333,44444444' lines.
	
	self assert: cols first equals: #(11111111111).
	self assert: cols second equals: #(22222222).
	self assert: cols third equals: #(33333333).
	self assert: cols fourth equals: #(44444444).
	
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testDescriptionDevice [
	| graph in op expected |
	graph := TFGraph create.
	in := graph const: 'const' value: (TFTensor fromInt64: 12345678).
	op := graph
		newOperation: 'Mul'
		named: 'out'
		described: [ :description | 
			description
				device: 'anInvalidDevice';
				addInput: (in output: 0);
				addInput: (in output: 0) ].
	expected := 'INVALID_ARGUMENT: Malformed device specification ''anInvalidDevice'' in node: {name:''out'' id:3 op device:{} def:{{{node out}} = Mul[T=DT_INT64, _device="anInvalidDevice"](const, const)}}
	 [[out]]'.
	self should: [ (TFSession on: graph) runOutput: (op output: 0) ] raiseError: expected
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testElementsOf: tensorArray sum: aNumber [
	| sum |
	sum := 0.
	TFTensor elementsOf: tensorArray do: [ :each | sum := sum + each ].
	self assert: sum equals: aNumber
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testElementsOfTensorDoIteratesAll [
	self testElementsOf: -13123213 sum: -13123213.
	self testElementsOf: #(123 123 123 123) sum: 123 * 4.
	self testElementsOf: #(#(1 2 3) #(4 5 6) #(7 8 9) #(10 11 12)) sum: 12 * 13 / 2.
	self testElementsOf: #(#(#(1) #(2) #(3)) #(#(4) #(5) #(6)) #(#(7) #(8) #(9))) sum: 9 * 10 / 2.
	self
		testElementsOf: #(#(#(1 100) #(2 100) #(3 100)) #(#(4 100) #(5 100) #(6 100)) #(#(7 100) #(8 100) #(9 100)))
		sum: 9 * 10 / 2 + (100 * 9)
]

{ #category : #'testing options' }
TensorFlowCAPITest >> testExternalizeString [
	| original copy |
	original := 'hola manola'.
	copy := library externalizeString: original.
	original withIndexDo: [ :each :index | self assert: each asciiValue equals: (copy byteAt: index) ].
	self assert: (copy byteAt: original size + 1) equals: 0
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testFloatAsStringGraphCreate [
	self floatAsStringGraph
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testFloatAsStringGraphRun [
	| result str expected |
	
	expected := '0.420000'.
	result := self runFloatAsStringGraph.
	
	self deny: result isNull.
	self deny: result data isNull.
	str := result dataBytes.
	
	self assert: 8+1+ expected size equals: str size.
	self assert: (str unsignedLongLongAt: 1) equals: 0.
	self assert: (str at: 9) equals: expected size.
	self assert: (str copyFrom: 10 to: (9+expected size)) asString equals: expected.
	
	result delete.

]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testGet2x2FloatFromGraphDef [
	| templates consts |
	templates := #(-1.1 -2.1 -1.2 -2.2).
	consts := self get2x2FloatFromGraphDef allFloats.
	templates with: consts do: [ :temp :const | self assert: (temp closeTo: const) ]
]

{ #category : #'testing library' }
TensorFlowCAPITest >> testGetAllOps [
	| ops |
	self skip: 'This test is failing, and don''t full understand what should be testing.
So i''ll just skip it'.
	ops := library getAllOps.
	self assert: (ops data fromCString includesSubstring: 'tensor').
	ops delete
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testGetAttrMetadataBoolean [
	| graph in op template metadata |
	template := '1234567890abc'.
	graph := TFGraph create.
	in := graph placeholder: 'in' type: TFTensor typeDouble.
	op := graph
		newOperation: 'AsString'
		named: 'out'
		described: [ :description | 
			description at: 'fill' putString: template.
			description addInput: (in output: 0) ].
	metadata := op attrMetadata: 'scientific'.
	self assert: metadata isBoolean.
	self assert: metadata isList equals: false
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testGetAttrMetadataFloat [
	| graph in op metadata |
	graph := TFGraph create.
	in := graph placeholder: 'in' type: TFTensor typeFloat.
	op := graph newOperation: 'FakeQuantWithMinMaxArgs' named: 'out' described: [ :description | description addInput: (in output: 0) ].
	metadata := op attrMetadata: 'min'.
	self assert: metadata isFloat.
	self assert: metadata isList equals: false
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testGetAttrMetadataInt [
	| graph in op template metadata |
	template := '1234567890abc'.
	graph := TFGraph create.
	in := graph placeholder: 'in' type: TFTensor typeDouble.
	op := graph
		newOperation: 'AsString'
		named: 'out'
		described: [ :description | 
			description at: 'fill' putString: template.
			description addInput: (in output: 0) ].
	metadata := op attrMetadata: 'precision'.
	self assert: metadata isInt.
	self assert: metadata isList equals: false
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testGetAttrMetadataShape [
	| graph op template metadata |
	template := TensorShape withDimensionsSized: #(1 2 3 4 5).
	graph := TFGraph create.
	op := graph
		newOperation: 'Placeholder'
		named: 'const'
		described: [ :description | 
			description at: 'shape' putShape: template.
			description at: 'dtype' putType: TFTensor typeInt64 ].
	metadata := op attrMetadata: 'shape'.
	self assert: metadata isShape.
	self assert: metadata isList equals: false.
	self assert: metadata totalSize equals: template size
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testGetAttrMetadataString [
	| graph in op template metadata |
	template := '1234567890abc'.
	graph := TFGraph create.
	in := graph placeholder: 'in' type: TFTensor typeDouble.
	op := graph newOperation: 'AsString' named: 'out' described: [:description |
		description at: 'fill' putString: template.
		description addInput: (in output: 0)].
		
	self assert: (op stringAt: 'fill') equals: template.
	
	metadata := op attrMetadata: 'fill'.
	self assert: metadata isString.
	self assert: metadata isList equals: false.
	self assert: metadata totalSize equals: template size.

]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testGetAttrMetadataTensor [
	| graph op template metadata |
	template := #(1 2 3 4 5).
	graph := TFGraph create.
	op := graph const: 'const' value: (TFTensor fromInt64s: template).
		
	metadata := op attrMetadata: 'value'.
	self assert: metadata isTensor.
	self assert: metadata isList equals: false.

]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testGetAttrMetadataType [
	| graph op template metadata |
	template := TensorShape withDimensionsSized: #(1 2 3 4 5).
	graph := TFGraph create.
	op := graph
		newOperation: 'Placeholder'
		named: 'const'
		described: [ :description | 
			description at: 'shape' putShape: template.
			description at: 'dtype' putType: TFTensor typeInt64 ].
	metadata := op attrMetadata: 'dtype'.
	self assert: metadata isType.
	self assert: metadata isList equals: false
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testGetOperationOnConstantGraph [
	| graph op |
	graph := self constantFloatGraphFromDef.
	op := graph operationNamed: 'a'.
	self assert: op name equals: 'a'.
	self assert: op type equals: 'Const'.
	self assert: op inputsCount equals: 0.
	self assert: op outputsCount equals: 1
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testGetOperationOnEmptyGraph [
	| graph |
	graph := self emptyGraph.
	self should: [ graph operationNamed: 'something' ] raiseError: 'Operation not found'
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testGraph: aTF_Graph outputType: anInteger [
	| operation output |
	operation := aTF_Graph operationNamed: 'a'.
	output := operation output: 0.
	self assert: output type equals: anInteger
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testGraphCreationConst [
	| graph operation |
	graph := self constantInt64Graph.
	
	operation := graph operationNamed: 'a'.
	self assert: operation type equals: 'Const'.
	self assert: operation name equals: 'a'.
	self assert: operation inputsCount equals: 0.
	self assert: operation outputsCount equals: 1.

]

{ #category : #'testing graph' }
TensorFlowCAPITest >> testGraphDefinition [
	| definition operations |
	definition := self mulGraphTwoInputsInt64 definition.
	operations := (TFGraph fromString: definition) allInputs.
	self assert: operations size equals: 2.
	self assert: operations first name equals: 'in1'.
	self assert: operations second name equals: 'in2'
]

{ #category : #'testing graph' }
TensorFlowCAPITest >> testGraphDeletionDoesntBreakOperations [
	| graph in1 in2 add |
	self skip: 'This method crash until we are able to remove instances from finalization list.
TFGraph>>#delete is not even available anymore'.
	graph := self addGraphTwoInputsInt64.
	graph ignoreFinalization.
	in1 := graph operationNamed: 'in1'.
	in2 := graph operationNamed: 'in2'.
	add := graph operationNamed: 'add'.
	self assert: in1 name equals: 'in1'.
	self assert: in2 name equals: 'in2'.
	self assert: add name equals: 'add'.
	graph delete.
	self assert: in1 name equals: 'in1'.
	self assert: in2 name equals: 'in2'.
	self assert: add name equals: 'add'.
	graph := self mulGraphTwoInputsInt64.
	graph ignoreFinalization.
	graph delete.
	self assert: in1 name equals: 'in1'.
	self assert: in2 name equals: 'in2'.
	self assert: add name equals: 'add'
]

{ #category : #'testing graph' }
TensorFlowCAPITest >> testGraphDeletionDoesntBreakSessions [
	| graph inputs inputValues add output session results |
	self skip: 'This method crash until we are able to remove instances from finalization list.
TFGraph>>#delete is not even available anymore'.
	graph := self addGraphTwoInputsInt64.
	"graph ignoreFinalization."
	inputs := Array
		with: ((graph operationNamed: 'in1') input: 0)
		with: ((graph operationNamed: 'in2') input: 0).
	inputValues := Array
		with: (TFTensor fromInt64: 16r2021222021222021)
		with: (TFTensor fromInt64: 16r2221202221202221).
	add := graph operationNamed: 'add'.
	output := add output: 0.
	session := TFSession on: graph.
	graph delete.
	graph := self addGraphTwoInputsInt64.
	"graph ignoreFinalization."
	graph delete.
	results := session
		runOperations: (Array with: add)
		inputs: inputs
		values: inputValues
		outputs: (Array with: output).
	self deny: results isNull.
	self deny: results first isNull.
	self deny: results first data isNull.
	self
		assert: (results first data getHandle signedLongLongAt: 1)
		equals: 16r4242424242424242.
	results first delete
]

{ #category : #'testing graph' }
TensorFlowCAPITest >> testGraphFromBlockIdentity [
	| graph output inputs results |
	graph := TFGraph fromBlock: [ :a | a ].
	inputs := graph allInputs collect: [ :placeholder | placeholder input: 0 ].
	output := graph operationNamed: 'output'.
	results := (TFSession on: graph) runInputs: inputs values: {(TFTensor fromFloats: 3.1415)} outputs: {(output output: 0)}.
	self assert: (results first allFloats first closeTo: 3.1415)
]

{ #category : #'testing graph' }
TensorFlowCAPITest >> testGraphFromBlockIdentityInstance [
	| graph output inputs results |
	graph := TFGraph create.
	output := graph fromBlock: [ :a | a alias: 'a_1' ].
	inputs := graph allInputs collect: [ :input | input input: 0 ].
	results := (TFSession on: graph) runInputs: inputs values: {(TFTensor fromFloats: 3.1415)} outputs: {(output output: 0)}.
	self assert: (results first allFloats first closeTo: 3.1415)
]

{ #category : #'testing graph' }
TensorFlowCAPITest >> testGraphFromBlockSimple [
	| graph output inputs results |
	
	graph := TFGraph fromBlock: [ :a :b | a + b ].
	inputs := graph allInputs collect: [ :placeholder | placeholder input: 0 ].
	output := graph operationNamed: 'output'.
	results := (TFSession on: graph)
		runInputs: inputs
		values:
			{(TFTensor fromFloats: 3.1415).
			(TFTensor fromFloats: 1.2345)}
		outputs: {(output output: 0)}.
	self assert: (results first allFloats first closeTo: 3.1415 + 1.2345)
]

{ #category : #'testing graph' }
TensorFlowCAPITest >> testGraphFromBlockSimpleInstance [
	| graph output inputs results |
	graph := TFGraph create.
	output := graph fromBlock: [ :a :b | a + b ].
	inputs := graph allInputs collect: [ :placeholder | placeholder input: 0 ].
	results := (TFSession on: graph)
		runInputs: inputs
		values:
			{(TFTensor fromFloats: 3.1415).
			(TFTensor fromFloats: 1.2345)}
		outputs: {(output output: 0)}.
	self assert: (results first allFloats first closeTo: 3.1415 + 1.2345)
]

{ #category : #'testing graph' }
TensorFlowCAPITest >> testGraphNotFinalizedWhenHeldByOperations [
	| graph in1 in2 add |
	graph := self addGraphTwoInputsInt64.
	graph useFinalization.
	in1 := graph operationNamed: 'in1'.
	in2 := graph operationNamed: 'in2'.
	add := graph operationNamed: 'add'.
	self assert: in1 name equals: 'in1'.
	self assert: in2 name equals: 'in2'.
	self assert: add name equals: 'add'.
	graph := nil.
	Smalltalk garbageCollect.
	self assert: in1 name equals: 'in1'.
	self assert: in2 name equals: 'in2'.
	self assert: add name equals: 'add'.
	graph := self mulGraphTwoInputsInt64.
	"graph delete."
	self assert: in1 name equals: 'in1'.
	self assert: in2 name equals: 'in2'.
	self assert: add name equals: 'add'
]

{ #category : #'testing graph' }
TensorFlowCAPITest >> testGraphOperationAt [
	| graph operation context |
	graph := self mulGraphTwoInputsInt64.
	context := graph newOperationIteratorContext.
	operation := graph operationAt: context.
	self assert: operation name equals: 'in1'.
	self assert: operation type equals: 'Placeholder'.
	operation := graph operationAt: context.
	self assert: operation name equals: 'in2'.
	self assert: operation type equals: 'Placeholder'.
	operation := graph operationAt: context.
	self assert: operation name equals: 'const'.
	self assert: operation type equals: 'Const'.
	operation := graph operationAt: context.
	self assert: operation name equals: 'mul1'.
	self assert: operation type equals: 'Mul'.
	operation := graph operationAt: context.
	self assert: operation name equals: 'mul2'.
	self assert: operation type equals: 'Mul'.
	operation := graph operationAt: context.
	self assert: operation isNull
]

{ #category : #'testing graph' }
TensorFlowCAPITest >> testGraphOperationsCount [
	| graph |
	graph := self mulGraphTwoInputsInt64.
	self assert: graph operationsCount equals: 5
]

{ #category : #'testing graph' }
TensorFlowCAPITest >> testGraphOperationsDo [
	| graph operations |
	graph := self mulGraphTwoInputsInt64.
	operations := OrderedCollection new.
	
	graph operationsDo: [:op |
		operations add: op name].
	
	self assert: operations size equals: 5.
	self assert: operations first equals: 'in1'.
	self assert: operations second equals: 'in2'.
	self assert: operations third equals: 'const'.
	self assert: operations fourth equals: 'mul1'.
	self assert: operations fifth equals: 'mul2'.

]

{ #category : #'testing graph' }
TensorFlowCAPITest >> testGraphOperationsSelect [
	| operations |
	operations := self mulGraphTwoInputsInt64 allInputs.
	self assert: operations size equals: 2.
	self assert: operations first name equals: 'in1'.
	self assert: operations second name equals: 'in2'
]

{ #category : #'testing graph' }
TensorFlowCAPITest >> testGraphOperationsSelectEmpty [
	| graph operations |
	graph := self mulGraphTwoInputsInt64.
	operations := graph operationsSelect: [ :op | false ].
	self assert: operations size equals: 0
]

{ #category : #'testing graph' }
TensorFlowCAPITest >> testGraphRunInputsOutputs [
	| graph output result input |
	graph := TFGraph create.
	
	output := graph fromBlock: [:a |
		input := a.
		a @* TFTensor pi].

	result := graph
		runInputs: {input input: 0}
		values: {7.23 asTensor}
		outputs: {output output}.	
	self assert: Float pi * 7.23 closeTo: result first asNumbers.
]

{ #category : #'testing graph' }
TensorFlowCAPITest >> testGraphRunOutput [
	| graph output result |
	graph := TFGraph create.
	output := graph const: TFTensor pi.
	result := graph runOutput: output output.
	self assert: Float pi closeTo: result asNumbers
]

{ #category : #'testing graph' }
TensorFlowCAPITest >> testGraphRunOutputs [
	| graph output1 output2 results |
	graph := TFGraph create.
	output1 := graph const: TFTensor pi.
	output2 := output1 @/ 2.0 asTensor.
	results := graph
		runOutputs:
			{output1 output.
			output2 output}.
	self assert: Float pi closeTo: results first asNumbers.
	self assert: Float pi / 2 closeTo: results second asNumbers
]

{ #category : #'testing graph' }
TensorFlowCAPITest >> testImportBad [
	| graph buffer |
	graph := TFGraph create.
	buffer := TFBuffer fromString: 'ouch'.
	self should: [ graph import: buffer ] raiseError: 'INVALID_ARGUMENT: Invalid GraphDef'.
	buffer delete
]

{ #category : #'testing graph' }
TensorFlowCAPITest >> testImportConstantGraph [
	self shouldnt: [
		self constantFloatGraphFromDef.
		self constantInt32GraphFromDef.
		self constantInt64GraphFromDef.
	] raise: Error.
	
]

{ #category : #'testing graph' }
TensorFlowCAPITest >> testImportEmpty [
	self emptyGraph
]

{ #category : #'testing graph' }
TensorFlowCAPITest >> testInitializeOn [
	| graph session |
	graph := TFGraph create.
	session := TFSession on: graph.
	graph initializeOn: session
]

{ #category : #'testing structures size' }
TensorFlowCAPITest >> testInputStructureSizeIs16bits [
	self assert: TFInput byteSize equals: 16
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testInt64AsStringGraph [
	| result tensor |
	tensor := TFTensor fromInt64: 101010101.
	result := self testAsStringGraphRunOn: tensor.
	
	self assert: result allStrings first equals: '101010101'.

	result delete.
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testInt64rrayAsStringGraph [
	| result tensor strings template |
	template := #(101010101 -123321 1 2 3 4).
	tensor := TFTensor fromInt64s: template.
	result := self testAsStringGraphRunOn: tensor.
	strings := result allStrings.
	strings withIndexDo: [ :value :index | self assert: value equals: (template at: index) asString ].
	result delete
]

{ #category : #'testing buffer' }
TensorFlowCAPITest >> testNewBufferFromFileNamed [
	| buffer string data temporaryFile |
	string := ' hola manola'.
	temporaryFile := 'temporaryFile.txt'.
	temporaryFile asFileReference writeStream
		nextPutAll: string;
		close.
	buffer := TFBuffer fromFileNamed: temporaryFile.
	temporaryFile asFileReference delete.
	self deny: buffer isNull.
	self assert: buffer length equals: string size.
	data := buffer data fromCString first: string size.
	self assert: string equals: data.
	buffer delete.
	self assert: buffer isNull
]

{ #category : #'testing buffer' }
TensorFlowCAPITest >> testNewBufferFromString [
	| buffer string data |
	string := ' hola manola'.
	buffer := TFBuffer fromString: string.
	self deny: buffer isNull.
	self assert: buffer length equals: string size.
	data := buffer data fromCString first: string size.
	self assert: string equals: data.
	buffer delete.
	self assert: buffer isNull
]

{ #category : #'testing options' }
TensorFlowCAPITest >> testNewImportGraphDefOptions [
	| options |
	options := TFImportGraphDefOptions create.
	self deny: options isNull.
	options delete.
	self assert: options isNull
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testNewOperationDescription [
	| graph description |
	graph := TFGraph create.
	description := graph newOperationDescription: 'Const' named: 'first_operation'.
	self deny: description isNull.
	self should: [ description finish ] raise: Error description: 'This should have complained of missing attributes'
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testNewOperationMul [
	| graph operation a b |
	graph := TFGraph create.
	a := graph placeholder: 'a' type: TFTensor typeInt64.
	b := graph placeholder: 'b' type: TFTensor typeInt64.
	operation := graph
		mul: 'aMultiplication'
		described: [ :description | 
			description addInputFromOutput: 0 of: a.
			description addInputFromOutput: 0 of: b ].
	self assert: operation type equals: 'Mul'.
	self assert: operation name equals: 'aMultiplication'.
	self assert: operation inputsCount equals: 2.
	self assert: operation outputsCount equals: 1.
	operation := graph operationNamed: 'aMultiplication'.
	self assert: operation type equals: 'Mul'.
	self assert: operation name equals: 'aMultiplication'.
	self assert: operation inputsCount equals: 2.
	self assert: operation outputsCount equals: 1
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testNewOperationPlaceholder [
	| graph operation |
	graph := TFGraph create.
	operation := graph
		placeholder: 'aPlaceholder'
		type: TFTensor typeInt64.
	self assert: operation type equals: 'Placeholder'.
	self assert: operation name equals: 'aPlaceholder'.
	self assert: operation inputsCount equals: 0.
	self assert: operation outputsCount equals: 1.
	operation := graph operationNamed: 'aPlaceholder'.
	self assert: operation type equals: 'Placeholder'.
	self assert: operation name equals: 'aPlaceholder'.
	self assert: operation inputsCount equals: 0.
	self assert: operation outputsCount equals: 1
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testNewOperationPlaceholderNoType [
	| graph noType |
	noType := 'INVALID_ARGUMENT: NodeDef missing attr ''dtype'' from Op<name=Placeholder; signature= -> output:dtype; attr=dtype:type; attr=shape:shape,default=<unknown>>; NodeDef: {{node placeholder}}'.
	graph := TFGraph create.
	self
		should: [(graph newOperationDescription: 'Placeholder' named: 'placeholder') finish]
		raiseError: noType.
]

{ #category : #'testing options' }
TensorFlowCAPITest >> testNewSessionOptions [
	| options |
	options := TFSessionOptions create.
	self deny: options isNull
]

{ #category : #'testing status' }
TensorFlowCAPITest >> testNewStatus [
	| status |
	status := TFStatus create.
	self deny: status isNull
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testNewVariableForTensor [
	| graph var assign result session pisTensor pis |
	graph := TFGraph create.
	pisTensor := TFTensor fromFloats: #(3.14 3.1415 3.141516).
	var := graph variable: 'var' forTensor: pisTensor.
	pis := graph const: 'pis' value: pisTensor.
	assign := graph newOperation: 'Assign' named: 'assign' described: [:description |
		description
			addInput: (var output: 0);
			addInput: (pis output: 0)].
	
	session := TFSession on: graph.
	
	session runOutput: (assign output: 0).
	result := session runOutput: (var output: 0).

	self assert: result allFloats equals: pisTensor allFloats
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testNewVariableInitialValue [
	| graph var assign result session pisTensor |
	graph := TFGraph create.
	pisTensor := TFTensor fromFloats: #(3.14 3.1415 3.141516).
	var := graph variable: 'var' initialValue: pisTensor.
	assign := graph operationNamed: 'var_initializer'.
	
	session := TFSession on: graph.
	
	session runOutput: (assign output: 0).
	result := session runOutput: (var output: 0).

	self assert: result allFloats equals: pisTensor allFloats
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testNewVariableInitialValueAutomaticInitialization [
	| graph var result session pisTensor |
	graph := TFGraph create.
	pisTensor := TFTensor fromFloats: #(3.14 3.1415 3.141516).
	var := graph variable: 'var' initialValue: pisTensor.
	
	session := TFSession on: graph.
	
	graph initializeOn: session.
	result := session runOutput: (var output: 0).

	self assert: result allFloats equals: pisTensor allFloats
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testNewVariableInitialization [
	| graph var assign pi result session |
	graph := TFGraph create.
	var := graph variable: 'var' type: TFTensor typeFloat shape: TensorShape scalar.
	pi := graph const: 'pi' value: (TFTensor fromFloats: 3.14).
	assign := graph newOperation: 'Assign' named: 'assign' described: [:description |
		description
			addInput: (var output: 0);
			addInput: (pi output: 0)].
	
	session := TFSession on: graph.
	
	session runOutput: (assign output: 0).
	result := session runOutput: (var output: 0).

	self assert: (result allFloats first closeTo: 3.14)
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testNewVariableInitializationNodeNotRun [
	| graph var pi lastError |
	graph := TFGraph create.
	var := graph variable: 'var' type: TFTensor typeFloat shape: TensorShape scalar.
	pi := graph const: 'pi' value: (TFTensor fromFloats: 3.14).
	graph newOperation: 'Assign' named: 'assign' described: [:description |
		description
			addInput: (var output: 0);
			addInput: (pi output: 0)].
	
	[(TFSession on: graph)
		runOutput: (var output: 0)] ifError: [:description :receiver | lastError := description].
	
	self
		assert: 'Error: FAILED_PRECONDITION: Attempting to use uninitialized value var'
		equals: lastError lines first
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testNewVariableNoInitialization [
	| graph var expectedError lastError |
	graph := TFGraph create.
	var := graph variable: 'var' type: TFTensor typeFloat shape: TensorShape scalar.
	[ (TFSession on: graph) runOutput: (var output: 0) ] ifError: [ :description :receiver | lastError := description ].
	expectedError := 'Error: FAILED_PRECONDITION: Attempting to use uninitialized value var'.
	self assert: expectedError equals: lastError lines first
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testOperationAsOperationDifferentGraph [
	| const graph1 graph2 |
	graph1 := TFGraph create.
	graph2 := TFGraph create.
	const := graph1 const: 1.0 asTensor.
	self should: [const asOperationOn: graph2] raiseError: 'Can''t move an operation to another Graph'.
	

]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testOperationAsOperationOk [
	| const1 const2 graph |
	graph := TFGraph create.
	const1 := graph const: 1.0 asTensor.
	const2 := const1 asOperationOn: graph.
	self assert: const1 == const2
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testOperationEquals [
	| graph in1 |
	graph := TFGraph create.
	in1 := graph placeholder: 'in1' type: TFTensor typeFloat.
	self assert: in1 equals: in1.
	self deny: in1 = 'in1'
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testOperationOutputTypeFloat [
	^ self testGraph: self constantFloatGraphFromDef outputType: TFTensor typeFloat
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testOperationOutputTypeInt32 [
	^ self testGraph: self constantInt32GraphFromDef outputType: TFTensor typeInt32
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testOperationOutputTypeInt64 [
	^ self testGraph: self constantInt64GraphFromDef outputType: TFTensor typeInt64
]

{ #category : #'testing graph' }
TensorFlowCAPITest >> testOutputDims [
	| graph operation output |
	graph := self constantInt64GraphFromDef.
	operation := graph operationNamed: 'a'.
	output := operation output: 0.
	self assert: (graph outputDimensionsCount: output) equals: 0
]

{ #category : #'testing structures size' }
TensorFlowCAPITest >> testOutputStructureSizeIs16bits [
	self assert: TFOutput byteSize equals: 16
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testPlaceholderType: type [
	| graph var session result tensor abs |
	graph := TFGraph create.
	tensor := TFTensor type: type shape: TensorShape scalar.
	var := graph placeholder: 'var' type: type.
	abs := graph newOperation: 'Abs' named: 'abs' described: [ :description | description addInput: (var output: 0) ].
	session := TFSession on: graph.
	result := session
		runInputs: {var input: 0}
		values: {tensor}
		outputs: {abs output: 0}.
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testPlaceholderTypes [
	self testPlaceholderType: TFTensor typeInt64.
	self testPlaceholderType: TFTensor typeInt32.
	self testPlaceholderType: TFTensor typeFloat
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testPrintOn [
	| graph printString |
	graph := self addGraphTwoInputsInt64.
	printString := (graph operationNamed: 'in1') printString substrings.
	self assert: printString second equals: 'TFOperation((void*)@'.
	self assert: (printString third beginsWith: '16r').
	self assert: printString fourth equals: '''Placeholder'''.
	self assert: printString last equals: '''in1'''.
	printString := (graph operationNamed: 'add') printString substrings.
	self assert: printString second equals: 'TFOperation((void*)@'.
	self assert: (printString third beginsWith: '16r').
	self assert: printString fourth equals: '''Add'''.
	self assert: printString last equals: '''add'''
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testRankOfOutput [
	| graph template const rank |
	graph := TFGraph create.
	template := TFTensor fromFloats: #(
		((1) (2) (3)) 
		((4) (5) (6))
	).
	const := graph const: 'const' value: template.
	rank := graph rankOf: (const output: 0).
	
	self assert: template shape size equals: rank.

]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testRanks [
	self assertRankOf: -13123213 is: 0.
	self assertRankOf: #(123 123 123 123) is: 1.
	self assertRankOf: #(#(1 2 3) #(4 5 6) #(7 8 9)) is: 2.
	self assertRankOf: #(#(#(1) #(2) #(3)) #(#(4) #(5) #(6)) #(#(7) #(8) #(9))) is: 3
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testRunGraphAddTwoInputs [
	| graph inputs inputValues add output session results |
	graph := self addGraphTwoInputsInt64.
	
	inputs := Array
		with: ((graph operationNamed: 'in1') input: 0)
		with: ((graph operationNamed: 'in2') input: 0).
	inputValues := Array
		with: (TFTensor fromInt64: 16r2021222021222021)
		with: (TFTensor fromInt64: 16r2221202221202221).
	add := graph operationNamed: 'add'.
	output := add output: 0.
	session := TFSession on: graph.
	results := session
		runInputs: inputs
		values: inputValues
		outputs: (Array with: output).
	
	self deny: results isNil.
	self deny: results first isNull.
	self deny: results first data isNull.
	self assert: (results first data getHandle signedLongLongAt: 1) equals: 16r4242424242424242.

	results first delete.

]

{ #category : #'testing session' }
TensorFlowCAPITest >> testRunGraphMulOneInput [
	| graph input inputValue result mul output session |
	graph := self mulGraphOneInputInt64.
	input := (graph operationNamed: 'in') input: 0.
	inputValue := TFTensor fromInt64: 11.
	mul := graph operationNamed: 'mul'.
	output := mul output: 0.
	session := TFSession on: graph.
	result := (session
		runInputs: {input}
		values: {inputValue}
		outputs: {output}) first.
	self deny: result isNull.
	self deny: result data isNull.
	self assert: (result data getHandle signedLongLongAt: 1) equals: 16r4242424242424242
]

{ #category : #'testing session' }
TensorFlowCAPITest >> testRunGraphMulTwoInputs [
	| graph inputs inputValues mul output session results |
	graph := self mulGraphTwoInputsInt64.
	
	inputs := Array
		with: ((graph operationNamed: 'in1') input: 0)
		with: ((graph operationNamed: 'in2') input: 0).
	inputValues := Array
		with: (TFTensor fromInt64: 6)
		with: (TFTensor fromInt64: 11).
	mul := graph operationNamed: 'mul2'.
	output := mul output: 0.
	session := TFSession on: graph.
	results := session
		runInputs: inputs
		values: inputValues
		outputs: (Array with: output).
	
	self deny: results isNil.
	self deny: results first isNull.
	self deny: results first data isNull.
	self assert: (results first data getHandle signedLongLongAt: 1) equals: 16r4242424242424242
]

{ #category : #'testing session' }
TensorFlowCAPITest >> testRunGraphMulTwoInputsRunInputsOutputs [
	| graph inputs inputValues mul output session results |
	graph := self mulGraphTwoInputsInt64.
	
	inputs := Array
		with: ((graph operationNamed: 'in1') input: 0)
		with: ((graph operationNamed: 'in2') input: 0).
	inputValues := Array
		with: (TFTensor fromInt64: 6)
		with: (TFTensor fromInt64: 11).
	mul := graph operationNamed: 'mul2'.
	output := mul output: 0.
	session := TFSession on: graph.
	
	results := session
		runInputs: inputs
		values: inputValues
		outputs: {output}.
	
	self deny: results first isNull.
	self deny: results first data isNull.
	self assert: (results first data getHandle signedLongLongAt: 1) equals: 16r4242424242424242
]

{ #category : #'testing session' }
TensorFlowCAPITest >> testSessionOnEmptyGraph [
	| session |
	session := TFSession on: self emptyGraph.
	self should: [ session run ] raiseError: 'INVALID_ARGUMENT: Must specify at least one target to fetch or execute.'
]

{ #category : #'testing options' }
TensorFlowCAPITest >> testSessionOptionsFromProtoBufEmpty [
	TFSessionOptions fromProtoBuf: ''
]

{ #category : #'testing options' }
TensorFlowCAPITest >> testSessionOptionsFromProtoBufInvalid [
	self should: [ TFSessionOptions fromProtoBuf: '.' ] raiseError: 'INVALID_ARGUMENT: Unparseable ConfigProto'
]

{ #category : #'testing options' }
TensorFlowCAPITest >> testSessionOptionsFromProtoBufValid [
	"
	In [241]: tf.ConfigProto(allow_soft_placement=True, log_device_placement=True).SerializeToString()
	Out[241]: b'8\x01@\x01'
	"
	| config |
	config := #[16r38 1 16r40 1].
	TFSessionOptions fromProtoBuf: config
]

{ #category : #'testing session' }
TensorFlowCAPITest >> testSessionRunOutput [
	^ self testSessionRunOutputOnGraph: self constantInt64GraphFromDef
]

{ #category : #'testing session' }
TensorFlowCAPITest >> testSessionRunOutputOnGraph: graph [
	| operation session output tensor |
	session := TFSession on: graph.
	operation := graph operationNamed: 'a'.
	output := operation output: 0.
	tensor := session runOutput: output.
	self deny: tensor isNull.
	self deny: tensor data isNull.
	self assert: (tensor data getHandle signedLongLongAt: 1) equals: 16r4242424242424242
]

{ #category : #'testing session' }
TensorFlowCAPITest >> testSessionRunTarget [
	| graph operation session |
	graph := self constantFloatGraphFromDef.
	session := TFSession on: graph.
	operation := graph operationNamed: 'a'.
	session runOperation: operation
]

{ #category : #'testing session' }
TensorFlowCAPITest >> testSessionRunTargetOutput [
	^ self testSessionRunTargetOutputOnGraph: self constantInt64GraphFromDef
]

{ #category : #'testing session' }
TensorFlowCAPITest >> testSessionRunTargetOutputOnGraph: graph [
	| operation session output tensor |
	session := TFSession on: graph.
	operation := graph operationNamed: 'a'.
	output := operation output: 0.
	
	tensor := session runOperation: operation output: output.
	
	self deny: tensor isNull.
	self deny: tensor data isNull.
	self assert: (tensor data getHandle signedLongLongAt: 1) equals: 16r4242424242424242
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testShape [
	self assertShapeOf: -13123213 is: #().
	self assertShapeOf: #(123 123 123 123) is: #(4).
	self assertShapeOf: #(#(1 2 3) #(4 5 6) #(7 8 9) #(10 11 12)) is: #(4 3).
	self assertShapeOf: #(#(#(1) #(2) #(3)) #(#(4) #(5) #(6)) #(#(7) #(8) #(9))) is: #(3 3 1)
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testShapeOfInput [
	| graph template const shape same |
	graph := TFGraph create.
	template := TFTensor fromFloats: #(#(#(1) #(2) #(3)) #(#(4) #(5) #(6))).
	const := graph const: 'const' value: template.
	same := const identity.
	shape := graph shapeOf: (same input: 0).
	self assert: template shape equals: shape
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testShapeOfOutput [
	| graph template const shape |
	graph := TFGraph create.
	template := TFTensor fromFloats: #(#(#(1) #(2) #(3)) #(#(4) #(5) #(6))).
	const := graph const: 'const' value: template.
	shape := graph shapeOf: (const output: 0).
	self assert: template shape equals: shape
]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testShapeOfOutputSet [
	| graph var shape output |
	graph := TFGraph create.
	
	var := graph newOperation: 'Placeholder' named: 'var' described: [:description |
		description
			at: 'dtype' putType: TFTensor typeInt64;
			at: 'shape' putShape: (TensorShape withDimensionsSized: #(3 -1 -1))].
	
	output := var output: 0.
	
	shape := graph shapeOf: output.
	self assert: shape equals: #(3 -1 -1).

	graph shapeOf: output set: #(-1 3 -1).

	shape := graph shapeOf: output.
	self assert: shape equals: #(3 3 -1).

]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testShapeOfOutputSetInvalid [
	| graph template const output |
	graph := TFGraph create.
	template := TFTensor fromFloats: #(
		((1) (2) (3)) 
		((4) (5) (6))
	).
	const := graph const: 'const' value: template.
	output := const output: 0.
	
	self
		should: [graph shapeOf: output set: #(1 2 3)] 
		raiseError: 'INVALID_ARGUMENT: Dimension 0 in both shapes must be equal, but are 2 and 1. Shapes are [2,3,1] and [1,2,3].'.

]

{ #category : #'testing operation' }
TensorFlowCAPITest >> testShapeOfOutputSetInvalidRank [
	| graph template const output |
	graph := TFGraph create.
	template := TFTensor fromFloats: #(
		((1) (2) (3)) 
		((4) (5) (6))
	).
	const := graph const: 'const' value: template.
	output := const output: 0.
	
	self
		should: [graph shapeOf: output set: #(1 2 3 -1)]
		raiseError: 'INVALID_ARGUMENT: Shapes must be equal rank, but are 3 and 4'.
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testSizes [
	self assertSizeOf: -13123213 is: 1.
	self assertSizeOf: #(123 123 123 123) is: 4.
	self assertSizeOf: #(#(1 2 3) #(4 5 6) #(7 8 9) #(10 11 12)) is: 4 * 3.
	self assertSizeOf: #(#(#(1) #(2) #(3)) #(#(4) #(5) #(6)) #(#(7) #(8) #(9))) is: 3 * 3 * 1
]

{ #category : #'testing status' }
TensorFlowCAPITest >> testStatusCodes [
	| status msg |
	status := TFStatus create.
	self assert: status isOk.
	self assert: status codeText equals: 'OK'.
	status check.
	msg := 'You cancelled it!'.
	status code: 1 message: msg.
	self assert: status codeText equals: 'CANCELLED'.
	self should: [ status check ] raiseError: 'CANCELLED: ' , msg
]

{ #category : #'testing status' }
TensorFlowCAPITest >> testStatusGetMessage [
	| status message |
	status := TFStatus create.
	status code: 1 message: 'All is one'.
	message := status message.
	self assert: message equals: 'All is one'.
	status code: 7 message: 'Something is very seven'.
	message := status message.
	self assert: message equals: 'Something is very seven'
]

{ #category : #'testing status' }
TensorFlowCAPITest >> testStatusSetGetCode [
	| status code |
	status := TFStatus create.
	status code: 1 message: ''.
	code := status code.
	self assert: code equals: 1.
	status code: 2 message: ''.
	code := status code.
	self assert: code equals: 2
]

{ #category : #'testing strings' }
TensorFlowCAPITest >> testStringAsTensor [
	| tensor template |
	template := 'hola manola'.
	tensor := template asTensor.
	self assert: tensor dataBytes first equals: template size.
	self assert: tensor dataBytes allButFirst asString equals: template
]

{ #category : #'testing strings' }
TensorFlowCAPITest >> testStringDecode [
	| size string encoded decoded status |
	" This test assumes the internal representation of a TensorFlow string. May fail if they change it "
	string := 'a ver como queda este string encodeado?'.
	status := TFStatus create.
	size := library stringEncodedSize: string.
	encoded := ExternalAddress gcallocate: size + 20.
	encoded byteAt: size + 1 put: $@ asciiValue.
	library
		stringEncode: string
		len: string size
		destination: encoded
		len: size + 20
		status: status.
	status check.
	decoded := library stringDecode: encoded.
	self deny: decoded = (string , '@').
	self assert: decoded equals: string
]

{ #category : #'testing strings' }
TensorFlowCAPITest >> testStringEncode [
	| size string encoded encodedSize |
	" This test assumes the internal representation of a TensorFlow string. May fail if they change it "
	string := 'a ver como queda este string encodeado?'.
	size := library stringEncodedSize: string.
	encoded := ByteArray new: size + 20.
	encodedSize := library stringEncode: string to: encoded.
	self assert: encodedSize equals: size.
	self assert: (encoded byteAt: 1) equals: string size.
	self assert: (encoded structAt: 2 length: string size) asString equals: string
]

{ #category : #'testing strings' }
TensorFlowCAPITest >> testStringEncodeExternal [
	| size string encoded encodedSize status |
	" This test assumes the internal representation of a TensorFlow string. May fail if they change it "
	status := TFStatus create.
	string := 'a ver como queda este string encodeado?'.
	size := library stringEncodedSize: string.
	encoded := ExternalAddress gcallocate: size + 20.
	encodedSize := library
		stringEncode: string
		len: string size
		destination: encoded
		len: size + 20
		status: status.
	status check.
	self assert: encodedSize equals: size.
	self assert: (encoded unsignedByteAt: 1) equals: string size.
	self assert: (encoded structAt: 2 length: string size) asString equals: string
]

{ #category : #'testing strings' }
TensorFlowCAPITest >> testStringSize [
	self assert: (library primStringEncodedSize: 0) equals: 0 + 1.
	self assert: (library primStringEncodedSize: 127) equals: 127 + 1.
	self assert: (library primStringEncodedSize: 128) equals: 128 + 2.
	self assert: (library primStringEncodedSize: 127 * 127) equals: 127 * 127 + 2.
	self assert: (library primStringEncodedSize: 127 * 127 + 123) equals: 127 * 127 + 123 + 2.
	self assert: (library primStringEncodedSize: 127 * 127 * 127) equals: 127 * 127 * 127 + 3.
	self assert: (library stringEncodedSize: '') equals: 0 + 1.
	self assert: (library stringEncodedSize: (String new: 127)) equals: 127 + 1.
	self assert: (library stringEncodedSize: (String new: 128)) equals: 128 + 2
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorAllElements [
	self assertTensor: -13123213 asInt32Tensor elementsEquals: #(-13123213).
	self assertTensor: #(123 123 123 123) asInt32Tensor elementsEquals: #(123 123 123 123).
	self assertTensor: #(#(1 2 3) #(4 5 6) #(7 8 9) #(10 11 12)) asFloatTensor elementsEquals: #(1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 11.0 12.0).
	self
		assertTensor: #(#(#(1 100) #(2 100) #(3 100)) #(#(4 100) #(5 100) #(6 100)) #(#(7 100) #(8 100) #(9 100))) asFloatTensor
		elementsEquals: #(1.0 100.0 2.0 100.0 3.0 100.0 4.0 100.0 5.0 100.0 6.0 100.0 7.0 100.0 8.0 100.0 9.0 100.0)
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorAllStrings [
	| result strings expected |
	expected := #('0.420000').
	result := self runFloatAsStringGraph.
	strings := result allStrings.
	self assert: strings equals: expected.
	result delete
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorArrayNumbersAt [
	| graph inputValues inputs mul numbers output results session |
	graph := self mulGraphTwoInputsInt64.
	inputs := Array with: ((graph operationNamed: 'in1') input: 0) with: ((graph operationNamed: 'in2') input: 0).
	inputValues := Array with: (TFTensor fromInt64: 6) with: (TFTensor fromInt64: 11).
	mul := graph operationNamed: 'mul2'.
	output := mul output: 0.
	session := TFSession on: graph.
	results := session
		runInputs: inputs
		values: inputValues
		outputs: (Array with: output).
	numbers := results first allElements at: 1.
	self assert: numbers equals: 16r4242424242424242
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorAsNumbers [
	| tensor template array |
	template := #(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16).
	tensor := TFTensor fromFloats: template shape: (TensorShape vectorSized: 16).
	array := tensor asNumbers.
	self assert: template equals: array.
	tensor := TFTensor fromFloats: template shape: (TensorShape matrixSized: 2 by: 8).
	array := tensor asNumbers.
	self assert: #(#(1 2 3 4 5 6 7 8) #(9 10 11 12 13 14 15 16)) equals: array.
	tensor := TFTensor fromFloats: template shape: (TensorShape withDimensionsSized: #(2 4 2))..
	array := tensor asNumbers.
	self
		assert: #(#(#(1 2) #(3 4) #(5 6) #(7 8)) #(#(9 10) #(11 12) #(13 14) #(15 16)))
		equals: array
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorAsNumbersFloats [
	| tensor template array |
	template := #(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16).
	tensor := TFTensor fromFloats: template shape: (TensorShape vectorSized: 16).
	array := tensor asNumbers.
	self assert: #(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16) equals: array.
	tensor := TFTensor fromFloats: template shape: (TensorShape matrixSized: 2 by: 8).
	array := tensor asNumbers.
	self assert: #(#(1 2 3 4 5 6 7 8) #(9 10 11 12 13 14 15 16)) equals: array.
	tensor := TFTensor fromFloats: template shape: (TensorShape withDimensionsSized: #(2 4 2))..
	array := tensor asNumbers.
	self
		assert: #(#(#(1 2) #(3 4) #(5 6) #(7 8)) #(#(9 10) #(11 12) #(13 14) #(15 16)))
		equals: array
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorAsNumbersInt32 [
	| tensor template array |
	template := #(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16).
	tensor := TFTensor fromInt32s: template shape: (TensorShape vectorSized: 16).
	array := tensor asNumbers.
	self assert: #(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16) equals: array.
	tensor := TFTensor fromInt32s: template shape: (TensorShape matrixSized: 2 by: 8).
	array := tensor asNumbers.
	self assert: #(#(1 2 3 4 5 6 7 8) #(9 10 11 12 13 14 15 16)) equals: array.
	tensor := TFTensor fromInt32s: template shape: (TensorShape withDimensionsSized: #(2 4 2)).
	array := tensor asNumbers.
	self
		assert: #(#(#(1 2) #(3 4) #(5 6) #(7 8)) #(#(9 10) #(11 12) #(13 14) #(15 16)))
		equals: array
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorAsNumbersRank0 [
	self assert: 1 equals: 1 asInt32Tensor asNumbers.
	self assert: 1.0 equals: 1.0 asTensor asNumbers
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorAsOperation [
	| graph a b result |
	graph := TFGraph create.
	a := graph const: 3.14 asTensor.
	b := a + 1.234 asTensor.
	result := (TFSession on: graph) runOutput: b output.
	self assert: 3.14 + 1.234 closeTo: result asNumbers
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorAsStream [
	self assertTensor: -13123213 asInt32Tensor streamEquals: #(-13123213).
	self assertTensor: #(123 123 123 123) asInt32Tensor streamEquals: #(123 123 123 123).
	self
		assertTensor: #(#(1 2 3) #(4 5 6) #(7 8 9) #(10 11 12)) asFloatTensor
		streamEquals: #(1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 11.0 12.0).
	self
		assertTensor: #(#(#(1 100) #(2 100) #(3 100)) #(#(4 100) #(5 100) #(6 100)) #(#(7 100) #(8 100) #(9 100))) asFloatTensor
		streamEquals: #(1.0 100.0 2.0 100.0 3.0 100.0 4.0 100.0 5.0 100.0 6.0 100.0 7.0 100.0 8.0 100.0 9.0 100.0)
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorByteSize [
	| tensor |
	tensor := TFTensor type: TFTensor typeInt64 shape: (TensorShape matrixSized: 2 by: 3).
	self assert: tensor byteSize equals: 8 * 2 * 3
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorData [
	| tensor |
	tensor := TFTensor type: TFTensor typeInt64 shape: (TensorShape matrixSized: 2 by: 3).
	self assert: tensor rank equals: 2.
	self deny: tensor data getHandle asInteger = 0.
	self deny: tensor data getHandle isNil
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorElementsOf [
	self assertElementsOf: -13123213 are: #(-13123213).
	self assertElementsOf: #(123 123 123 123) are: #(123 123 123 123).
	self assertElementsOf: #(#(1 2 3) #(4 5 6) #(7 8 9) #(10 11 12)) are: (1 to: 12) asArray.
	self
		assertElementsOf: #(#(#(1) #(2) #(3)) #(#(4) #(5) #(6)) #(#(7) #(8) #(9)))
		are: (1 to: 9) asArray.
	self
		assertElementsOf: #(#(#(1 100) #(2 100) #(3 100)) #(#(4 100) #(5 100) #(6 100)) #(#(7 100) #(8 100) #(9 100)))
		are: #(1 100 2 100 3 100 4 100 5 100 6 100 7 100 8 100 9 100)
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorFromDoublesOutOfRange [
	| tensor template values |
	template := #(1.23456 0.0 -1.234567 1.0e39 1.0e-50 1.0e309 1.0e-324) copy.
	tensor := TFTensor fromDoubles: template.
	
	template at: 6 put: Float infinity.
	
	values := tensor allElements.
		
	self assert: tensor shape equals: #(7).
	self assert: tensor size equals: 7.
	self assert: tensor byteSize equals: (7*8).
	template with: values do: [:expected :actual |
		self assert: expected closeTo: actual].
	self assert: 0.0 equals: values last.

]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorFromDoublesOutOfRangeForFloats [
	| tensor template values |
	template := #(1.23456 0.0 -1.234567 3.402824e38 1.175494351e-46 1.0e39 1.0e-50) copy.
	tensor := TFTensor fromDoubles: template.
	
	values := tensor allElements.
		
	self assert: tensor shape equals: #(7).
	self assert: tensor size equals: 7.
	self assert: tensor byteSize equals: (7*8).
	template with: values do: [:expected :actual |
		self assert: expected closeTo: actual].
	self assert: 0.0 ~= values last.
	self assert: 0.0 ~= (values at: 5).
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorFromDoublesShape [
	| tensor template values |
	template := #(1.23456 0.0 -1.234567 1.1).
	tensor := TFTensor fromDoubles: template shape: (TensorShape matrixSized: 2 by: 2).
	values := tensor allElements.
		
	self assert: tensor shape equals: (TensorShape matrixSized: 2 by: 2).
	self assert: tensor size equals: 4.
	self assert: tensor byteSize equals: (tensor size*8).
	template with: values do: [:templ :actual |
		self assert: (templ closeTo: actual)]

]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorFromFloats [
	| tensor template values |
	template := #(1.23456 0.0 -1.234567 3.402823466e38 1.175494351e-38).
	tensor := TFTensor fromFloats: template.
	values := tensor allFloats.
		
	self assert: tensor shape equals: #(5).
	self assert: tensor size equals: 5.
	self assert: tensor byteSize equals: (5*4).
	template @ values do: [:point |
		self assert: (point x closeTo: point y)]

]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorFromFloats2x2 [
	| tensor template values |
	template := #(
		(-1.1 -2.1)
		(-1.2 -2.2)).
		
	tensor := TFTensor fromFloats: template.
	values := tensor allFloats.
		
	self assert: tensor shape equals: #(2 2).
	self assert: tensor size equals: 4.
	self assert: tensor byteSize equals: (4*4).
		
	#(-1.1 -2.1 -1.2 -2.2) with: values do: [:reference :value |
		self assert: (reference closeTo: value)]

]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorFromFloats2x2SameElementsOrder [
	| tensor template values constTensor consts |
	template := #(#(-1.1 -2.1) #(-1.2 -2.2)).
	tensor := TFTensor fromFloats: template.
	values := tensor allFloats.
	constTensor := self get2x2FloatFromGraphDef.
	consts := constTensor allFloats.
	consts with: values do: [ :const :value | self assert: (const closeTo: value) ]
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorFromFloatsOutOfRange [
	| tensor template values |
	template := #(1.23456 0.0 -1.234567 3.402824e38 1.175494351e-46 1.0e39 1.0e-50) copy.
	tensor := TFTensor fromFloats: template.
	
	template at: 4 put: Float infinity.
	template at: 6 put: Float infinity.
	
	values := tensor allElements.
		
	self assert: tensor shape equals: #(7).
	self assert: tensor size equals: 7.
	self assert: tensor byteSize equals: (7*4).
	template with: values do: [:expected :actual |
		self assert: expected closeTo: actual].
	self assert: 0.0 equals: values last.
	self assert: 0.0 equals: (values at: 5).
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorFromFloatsScalar [
	| tensor template values |
	template := 3.141516.
	tensor := TFTensor fromFloats: template.
	values := tensor allFloats.
		
	self assert: tensor shape equals: #().
	self assert: tensor size equals: 1.
	self assert: tensor byteSize equals: (1*4).
	
	self assert: (template closeTo: values first).
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorFromFloatsShape [
	| tensor template values |
	template := #(1.23456 0.0 -1.234567 1.1).
	tensor := TFTensor fromFloats: template shape: (TensorShape matrixSized: 2 by: 2).
	values := tensor allFloats.
		
	self assert: tensor shape equals: (TensorShape matrixSized: 2 by: 2).
	self assert: tensor size equals: 4.
	self assert: tensor byteSize equals: (tensor size*4).
	template with: values do: [:templ :actual |
		self assert: (templ closeTo: actual)]

]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorFromFloatsShapeUndefinedSize [
	| template |
	template := #(1.23456 0.0 -1.234567 1.1).
	
	self
		should: [TFTensor fromFloats: template shape: (TensorShape withDimensionsSized: #(2 2 -1))]
		raiseError: 'Inferred size and real size don''t match.'.
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorFromInt32 [
	| tensor template values |
	template := -1123123123.
	tensor := TFTensor fromInt32: template.
	values := tensor allInt32s.
	self assert: tensor shape equals: #().
	self assert: tensor size equals: 1.
	self assert: tensor byteSize equals: 4.
	self assert: values equals: {template}
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorFromInt32Shape [
	| tensor template values |
	template := #(123456 0 -1234567 11).
	tensor := TFTensor fromInt32s: template shape: (TensorShape matrixSized: 2 by: 2).
	values := tensor allFloats.
	self assert: tensor type equals: TFTensor typeInt32.
	self assert: tensor shape equals: (TensorShape matrixSized: 2 by: 2).
	self assert: tensor size equals: 4.
	self assert: tensor byteSize equals: tensor size * 4.
	template with: values do: [ :templ :actual | self assert: (templ closeTo: actual) ]
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorFromInt32s [
	| tensor template values |
	template := #(0 -1 1 -2 2 32768 65536 -1123123123).
	tensor := TFTensor fromInt32s: template.
	values := tensor allInt32s.
	self assert: tensor shape equals: {template size}.
	self assert: tensor size equals: template size.
	self assert: tensor byteSize equals: template size * 4.
	self assert: values equals: template
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorFromInt64Shape [
	| tensor template values |
	template := #(123456 0 -1234567 11).
	tensor := TFTensor fromInt64s: template shape: (TensorShape matrixSized: 2 by: 2).
	values := tensor allFloats.
	self assert: tensor type equals: TFTensor typeInt64.
	self assert: tensor shape equals: (TensorShape matrixSized: 2 by: 2).
	self assert: tensor size equals: 4.
	self assert: tensor byteSize equals: tensor size * 8.
	template with: values do: [ :templ :actual | self assert: (templ closeTo: actual) ]
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorFromInt64s [
	| tensor template values |
	template := #(16r1234567812345678 0 -12345678910111213).
	tensor := TFTensor fromInt64s: template.
	values := tensor allInt64s.
	self assert: tensor shape equals: #(3).
	self assert: tensor size equals: 3.
	self assert: tensor byteSize equals: 3 * 8.
	self assert: template equals: values
]

{ #category : #'testing strings' }
TensorFlowCAPITest >> testTensorFromString [
	| tensor template |
	template := 'hola manola'.
	tensor := TFTensor fromString: template.
	self assert: tensor dataBytes first equals: template size.
	self assert: tensor dataBytes allButFirst asString equals: template
]

{ #category : #'testing strings' }
TensorFlowCAPITest >> testTensorFromStringArray [
	| tensor template |
	template := #('hola manola' 'te traje una lola' 'pamela' 'que pandulce!').
	tensor := TFTensor fromStringArray: template.
	self assert: tensor allStrings equals: template
]

{ #category : #'testing strings' }
TensorFlowCAPITest >> testTensorFromStrings [
	| tensor template flatten |
	template := #(#('hola manola' 'te traje una lola') #('pamela' 'que pandulce!') #('habia una vez' 'truz')).
	flatten := TFTensor elementsOf: template.
	tensor := TFTensor fromStrings: template.
	self assert: (TensorShape matrixSized: 3 by: 2) equals: tensor shape.
	self assert: flatten equals: tensor allStrings
]

{ #category : #'testing strings' }
TensorFlowCAPITest >> testTensorFromStringsShape [
	| template |
	template := #('hola manola' 'te traje una lola' 'pamela' 'que pandulce!' 'habia una vez' 'truz').
	self assertTensorFromStrings: template shape: (TensorShape vectorSized: 6).
	self assertTensorFromStrings: template shape: (TensorShape matrixSized: 3 by: 2).
	self assertTensorFromStrings: template shape: (TensorShape withDimensionsSized: #(1 1 6 1 1)).
	self assertTensorFromStrings: #('hola como estas?') shape: TensorShape scalar
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorNewScalar [
	| tensor |
	tensor := TFTensor type: TFTensor typeInt64 shape: TensorShape scalar.
	tensor ignoreFinalization.
	self deny: tensor isNull.
	tensor delete.
	self assert: tensor isNull
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorShape0D [
	^ self testTensorShape: #()
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorShape10D [
	^ self testTensorShape: #(1 2 3 4 5 6 7 8 9 10)
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorShape1D [
	^ self testTensorShape: #(7)
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorShape2D [
	^ self testTensorShape: #(1 4)
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorShape: anArray [
	| tensor shape size |
	tensor := TFTensor type: TFTensor typeInt64 shape: (TensorShape withDimensionsSized: anArray).
	self assert: tensor rank equals: anArray size.
	anArray
		withIndexDo: [ :each :index | self assert: (tensor sizeOn: index - 1) equals: (anArray at: index) ].
	shape := tensor shape.
	size := anArray isEmpty
		ifTrue: [ 1 ]
		ifFalse: [ anArray product ].
	self assert: shape equals: anArray.
	self assert: tensor size equals: size
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorType [
	| tensor |
	tensor := TFTensor type: TFTensor typeInt64 shape: TensorShape scalar.
	self assert: tensor type equals: tensor class typeInt64.
	tensor := TFTensor type: TFTensor typeFloat shape: TensorShape scalar.
	self assert: tensor type equals: tensor class typeFloat
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorTypes [
	| types |
	types := #(
		Float 1
		Double 2
		Int32 3
		UInt8 4
		Int16 5
		Int8 6
		String 7
		Complex64 8
		Int64 9
		Boolean 10
		QInt8 11
		QUInt8 12
		QInt32 13
		BFloat16 14
		QInt16 15
		QUInt16 16
		UInt16 17
		Complex128 18
		Half 19
		Resource 20).
	types pairsDo: [:name :value |
		self assert: (TFTensor perform: (#type, name) asSymbol) equals: value]
]

{ #category : #'testing library' }
TensorFlowCAPITest >> testVersion [
	| version |
	version := library version.
	self assert: (#('2.3.1') includes: version)
]

{ #category : #'testing graph' }
TensorFlowCAPITest >> testWriteDefTo [
	| graph stream |
	graph := self constantInt64GraphFromDef.
	stream := WriteStream on: String new.
	graph writeDefTo: stream.
	self assert: stream contents size equals: self constantInt64GraphDef size
]

{ #category : #'testing graph' }
TensorFlowCAPITest >> testWriteDefToFileNamed [
	| graph filename filedata |
	filename := 'temporaryGraph.pb'.
	graph := self constantInt64GraphFromDef.
	graph writeDefToFileNamed: filename.
	filedata := filename asFileReference readStream upToEnd.
	filename asFileReference delete.
	self assert: filedata size equals: self constantInt64GraphDef size
]
