Extension { #name : #TensorFlowCAPITest }

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> asStringGraphType: type [
	| graph in |
	graph := TFGraph create.
	in := graph placeholder: 'in' type: type.
	graph asString: 'out' described: [ :description | description addInput: (in output: 0) ].
	^ graph
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> constant2x2FloatGraphDef [
	" This GraphDef corresponds to simple Graph, defined as
	
	a = tf.constant([[-1.1, -2.1],[-1.2,-2.2]], name='a')
	
	saved as ProtoBuf "

	^ #[16r0A 16r42 16r0A 16r01 16r61 16r12 16r05 16r43 16r6F 16r6E 16r73 16r74 16r2A 16r29 16r0A 16r05 16r76 16r61 16r6C 16r75 16r65 16r12 16r20 16r42 16r1E 16r08 16r01 16r12 16r08 16r12 16r02 16r08 16r02 16r12 16r02 16r08 16r02 16r22 16r10 16rCD 16rCC 16r8C 16rBF 16r66 16r66 16r06 16rC0 16r9A 16r99 16r99 16rBF 16rCD 16rCC 16r0C 16rC0 16r2A 16r0B 16r0A 16r05 16r64 16r74 16r79 16r70 16r65 16r12 16r02 16r30 16r01 16r0A 16r0C 16r0A 16r04 16r69 16r6E 16r69 16r74 16r12 16r04 16r4E 16r6F 16r4F 16r70 16r22 16r02 16r08 16r11]
		asString
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> constant2x2FloatGraphFromDef [
	^ TFGraph fromString: self constant2x2FloatGraphDef
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> floatAsStringGraph [
	| graph const |
	graph := self constantFloatGraphFromDef.
	const := graph operationNamed: 'a'.
	graph asString: 'output' described: [ :description | description addInput: (const output: 0) ].
	^ graph
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> get2x2FloatFromGraphDef [
	| graph session const result |
	graph := self constant2x2FloatGraphFromDef.
	
	const := (graph operationNamed: 'a') output: 0.
	session := TFSession on: graph.
	result := session runOutput: const.
	
	^ result
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> runFloatAsStringGraph [
	| session graph output result |
	graph := self floatAsStringGraph.
	session := TFSession on: graph.
	output := graph operationNamed: 'output'.
	result := session runOperation: output output: (output output: 0).
	^ result
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testAttrGetBoolFalse [
	| graph in op |
	graph := TFGraph create.
	in := graph placeholder: 'in' type: TFTensor typeDouble.
	op := graph asString: 'out' described: [ :description | description addInput: (in output: 0) ].
	self assert: (op boolAt: 'scientific') equals: false
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testAttrGetFloat [
	| graph in op |
	graph := TFGraph create.
	in := graph placeholder: 'in' type: TFTensor typeFloat.
	op := graph newOperation: 'FakeQuantWithMinMaxArgs' named: 'out' described: [ :description | description addInput: (in output: 0) ].
	self assert: (op floatAt: 'min') equals: -6.0.
	self assert: (op floatAt: 'max') equals: 6.0
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testAttrGetInt [
	| op graph |
	graph := self concatGraphInputList.
	op := graph operationNamed: 'concat'.
	self assert: (op intAt: 'N') equals: 2
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testAttrGetShape [
	| graph op |
	graph := TFGraph create.
	op := graph placeholder: 'in' type: TFTensor typeDouble.
	self assert: (op shapeAt: 'shape') equals: #()
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testAttrGetTensor [
	| op graph tensor |
	graph := self constantInt64Graph.
	op := graph operationNamed: 'a'.
	tensor := op tensorAt: 'value'.
	self assert: tensor type equals: TFTensor typeInt64.
	self assert: tensor shape equals: #().
	self assert: tensor allInt64s equals: #(16r4242424242424242)
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testAttrGetType [
	| op graph |
	graph := self concatGraphInputList.
	op := graph operationNamed: 'concat'.
	self assert: (op typeAt: 'T') equals: TFTensor typeInt64
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testAttrSetString [
	self testAttrSetString: '1'.
	self testAttrSetString: '12'.
	self testAttrSetString: '1234'.
	self testAttrSetString: '1234567'.
	self testAttrSetString: '12345678'.
	self testAttrSetString: '123456789'.
	self testAttrSetString: ((ByteArray new: 100) atAllPut: 65) asString.
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testAttrSetStrings [
	"self assert: false description: 'DebugIdentity operation does not exist anymore in TF r1.7'.
	self testAttrSetStrings: #('file://tmp/TFDebug.log').
	self testAttrSetStrings: #('file://tmp/TFDebug.log' 'file://tmp/TFDebug.2.log')"
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testCreateGraphAddTwoInputs [
	| graph |
	graph := self addGraphTwoInputsInt64
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testCreateGraphMulOneInput [
	| graph input mul |
	graph := self mulGraphOneInputInt64.
	input := graph operationNamed: 'in'.
	mul := graph operationNamed: 'mul'.
	self assert: input name equals: 'in'.
	self assert: mul name equals: 'mul'
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testDecodeCSVGraphCreate [
	| defaults |
	defaults := {
		TFTensor fromInt64s: #(-1).
		TFTensor fromInt64s: #(-1).
		TFTensor fromInt64s: #(-1).
		TFTensor fromInt64s: #(-1)}.
		
	self decodeCSVGraphDefaults: defaults.
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testDecodeCSVGraphRunOneLine [
	| cols |
	cols := self testDecodeCSVGraphRunCSV: '11111111111,22222222,33333333,44444444' lines.
	
	self assert: cols first equals: #(11111111111).
	self assert: cols second equals: #(22222222).
	self assert: cols third equals: #(33333333).
	self assert: cols fourth equals: #(44444444).
	
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testFloatAsStringGraphCreate [
	self floatAsStringGraph
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testGet2x2FloatFromGraphDef [
	| templates consts |
	templates := #(-1.1 -2.1 -1.2 -2.2).
	consts := self get2x2FloatFromGraphDef allFloats.
	templates with: consts do: [ :temp :const | self assert: (temp closeTo: const) ]
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testGetAllOps [
	| ops |

	ops := library getAllOps.
	self assert: (ops data fromCString includesSubstring: 'tensor').
	ops delete
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testGetAttrMetadataFloat [
	| graph in op metadata |
	graph := TFGraph create.
	in := graph placeholder: 'in' type: TFTensor typeFloat.
	op := graph newOperation: 'FakeQuantWithMinMaxArgs' named: 'out' described: [ :description | description addInput: (in output: 0) ].
	metadata := op attrMetadata: 'min'.
	self assert: metadata isFloat.
	self assert: metadata isList equals: false
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testGetAttrMetadataTensor [
	| graph op template metadata |
	template := #(1 2 3 4 5).
	graph := TFGraph create.
	op := graph const: 'const' value: (TFTensor fromInt64s: template).
		
	metadata := op attrMetadata: 'value'.
	self assert: metadata isTensor.
	self assert: metadata isList equals: false.

]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testGraphCreationConst [
	| graph operation |
	graph := self constantInt64Graph.
	
	operation := graph operationNamed: 'a'.
	self assert: operation type equals: 'Const'.
	self assert: operation name equals: 'a'.
	self assert: operation inputsCount equals: 0.
	self assert: operation outputsCount equals: 1.

]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testGraphDefinition [
	| definition operations |
	definition := self mulGraphTwoInputsInt64 definition.
	operations := (TFGraph fromString: definition) allInputs.
	self assert: operations size equals: 2.
	self assert: operations first name equals: 'in1'.
	self assert: operations second name equals: 'in2'
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testGraphFromBlockIdentity [
	| graph output inputs results |
	graph := TFGraph fromBlock: [ :a | a ].
	inputs := graph allInputs collect: [ :placeholder | placeholder input: 0 ].
	output := graph operationNamed: 'output'.
	results := (TFSession on: graph) runInputs: inputs values: {(TFTensor fromFloats: 3.1415)} outputs: {(output output: 0)}.
	self assert: (results first allFloats first closeTo: 3.1415)
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testGraphFromBlockIdentityInstance [
	| graph output inputs results |
	graph := TFGraph create.
	output := graph fromBlock: [ :a | a alias: 'a_1' ].
	inputs := graph allInputs collect: [ :input | input input: 0 ].
	results := (TFSession on: graph) runInputs: inputs values: {(TFTensor fromFloats: 3.1415)} outputs: {(output output: 0)}.
	self assert: (results first allFloats first closeTo: 3.1415)
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testGraphOperationsCount [
	| graph |
	graph := self mulGraphTwoInputsInt64.
	self assert: graph operationsCount equals: 5
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testGraphOperationsSelect [
	| operations |
	operations := self mulGraphTwoInputsInt64 allInputs.
	self assert: operations size equals: 2.
	self assert: operations first name equals: 'in1'.
	self assert: operations second name equals: 'in2'
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testGraphOperationsSelectEmpty [
	| graph operations |
	graph := self mulGraphTwoInputsInt64.
	operations := graph operationsSelect: [ :op | false ].
	self assert: operations size equals: 0
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testGraphRunOutput [
	| graph output result |
	graph := TFGraph create.
	output := graph const: TFTensor pi.
	result := graph runOutput: output output.
	self assert: Float pi closeTo: result asNumbers
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testInt64AsStringGraph [
	| result tensor |
	tensor := TFTensor fromInt64: 101010101.
	result := self testAsStringGraphRunOn: tensor.
	
	self assert: result allStrings first equals: '101010101'.

	result delete.
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testInt64rrayAsStringGraph [
	| result tensor strings template |
	template := #(101010101 -123321 1 2 3 4).
	tensor := TFTensor fromInt64s: template.
	result := self testAsStringGraphRunOn: tensor.
	strings := result allStrings.
	strings withIndexDo: [ :value :index | self assert: value equals: (template at: index) asString ].
	result delete
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testNewGraph [
	"Comment because #delete is deprecated 
	| graph |
	graph := TFGraph create.
	self deny: graph isNull.
	graph delete.
	self assert: graph isNull"
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testNewVariableNoInitialization [
	| graph var expectedError lastError |
	graph := TFGraph create.
	var := graph variable: 'var' type: TFTensor typeFloat shape: TensorShape scalar.
	[ (TFSession on: graph) runOutput: (var output: 0) ] ifError: [ :description :receiver | lastError := description ].
	expectedError := 'Error: FAILED_PRECONDITION: Attempting to use uninitialized value var'.
	self assert: expectedError equals: lastError lines first
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testOperationAsOperationDifferentGraph [
	| const graph1 graph2 |
	graph1 := TFGraph create.
	graph2 := TFGraph create.
	const := graph1 const: 1.0 asTensor.
	self should: [const asOperationOn: graph2] raiseError: 'Can''t move an operation to another Graph'.
	

]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testOperationAsOperationOk [
	| const1 const2 graph |
	graph := TFGraph create.
	const1 := graph const: 1.0 asTensor.
	const2 := const1 asOperationOn: graph.
	self assert: const1 == const2
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testOperationEquals [
	| graph in1 |
	graph := TFGraph create.
	in1 := graph placeholder: 'in1' type: TFTensor typeFloat.
	self assert: in1 equals: in1.
	self deny: in1 = 'in1'
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testPlaceholderTypes [
	self testPlaceholderType: TFTensor typeInt64.
	self testPlaceholderType: TFTensor typeInt32.
	self testPlaceholderType: TFTensor typeFloat
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testSessionDeletionDoesntDeleteGraphs [
	"| session graph allocatedObjects |
	graph := TFGraph create.
	session := TFSession on: graph.
	session ignoreFinalization.
	session close.
	session delete.

	 Allocate some external objects using the library, if the graph was released, we expect its space to be reused 
	allocatedObjects := OrderedCollection new: 10.
	10 timesRepeat: [ allocatedObjects add: TFStatus create ].
	self
		shouldnt: [ graph placeholder: 'a' type: TFTensor typeInt64 ]
		raise: Error
		description: 'The FFI call would crash if the graph was released by deleting the session'"
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testSessionRunOutput [
	^ self testSessionRunOutputOnGraph: self constantInt64GraphFromDef
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testSessionRunTarget [
	| graph operation session |
	graph := self constantFloatGraphFromDef.
	session := TFSession on: graph.
	operation := graph operationNamed: 'a'.
	session runOperation: operation
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testSessionRunTargetOutput [
	^ self testSessionRunTargetOutputOnGraph: self constantInt64GraphFromDef
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testShapeOfInput [
	| graph template const shape same |
	graph := TFGraph create.
	template := TFTensor fromFloats: #(#(#(1) #(2) #(3)) #(#(4) #(5) #(6))).
	const := graph const: 'const' value: template.
	same := const identity.
	shape := graph shapeOf: (same input: 0).
	self assert: template shape equals: shape
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testShapeOfOutput [
	| graph template const shape |
	graph := TFGraph create.
	template := TFTensor fromFloats: #(#(#(1) #(2) #(3)) #(#(4) #(5) #(6))).
	const := graph const: 'const' value: template.
	shape := graph shapeOf: (const output: 0).
	self assert: template shape equals: shape
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testTensorAllStrings [
	| result strings expected |
	expected := #('0.420000').
	result := self runFloatAsStringGraph.
	strings := result allStrings.
	self assert: strings equals: expected.
	result delete
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
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

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testTensorAsOperation [
	| graph a b result |
	graph := TFGraph create.
	a := graph const: 3.14 asTensor.
	b := a + 1.234 asTensor.
	result := (TFSession on: graph) runOutput: b output.
	self assert: 3.14 + 1.234 closeTo: result asNumbers
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPITest >> testTensorFromFloats2x2SameElementsOrder [
	| tensor template values constTensor consts |
	template := #(#(-1.1 -2.1) #(-1.2 -2.2)).
	tensor := TFTensor fromFloats: template.
	values := tensor allFloats.
	constTensor := self get2x2FloatFromGraphDef.
	consts := constTensor allFloats.
	consts with: values do: [ :const :value | self assert: (const closeTo: value) ]
]
