Class {
	#name : #TensorFlowCAPITest,
	#superclass : #TestCase,
	#instVars : [
		'library'
	],
	#category : #TensorFlowCoreTests
}

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
TensorFlowCAPITest >> emptyGraph [
	^ TFGraph fromString: self emptyGraphDef
]

{ #category : #graphs }
TensorFlowCAPITest >> emptyGraphDef [
	" This GraphDef corresponds to an Empty Graph (no operations), saved as ProtoBuf "

	^ #[16r0A 16r0C 16r0A 16r04 16r69 16r6E 16r69 16r74 16r12 16r04 16r4E 16r6F 16r4F 16r70 16r22 16r02 16r08 16r0F]
		asString
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
	aBlock on: Error do: [:ex | message := ex description].
	self assert: 'Error: ',aString isEqualSkippingSeparatorsTo: message.
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

{ #category : #'testing structures size' }
TensorFlowCAPITest >> testAttrMetadataStructureSizeIs32bits [
	self assert: TFAttrMetadata byteSize  equals: 32
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

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testRanks [
	self assertRankOf: -13123213 is: 0.
	self assertRankOf: #(123 123 123 123) is: 1.
	self assertRankOf: #(#(1 2 3) #(4 5 6) #(7 8 9)) is: 2.
	self assertRankOf: #(#(#(1) #(2) #(3)) #(#(4) #(5) #(6)) #(#(7) #(8) #(9))) is: 3
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
	tensor := TFTensor newTyped: TFTensor typeInt64 shaped: (TensorShape matrixSized: 2 by: 3).
	self assert: tensor byteSize equals: 8 * 2 * 3
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorData [
	| tensor |
	tensor := TFTensor newTyped: TFTensor typeInt64 shaped: (TensorShape matrixSized: 2 by: 3).
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
	tensor := TFTensor newTyped: TFTensor typeInt64 shaped: TensorShape scalar.
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
	tensor := TFTensor newTyped: TFTensor typeInt64 shaped: (TensorShape withDimensionsSized: anArray).
	self assert: tensor rank equals: anArray size.
	anArray
		withIndexDo: [ :each :index | self assert: (tensor sizeOn: index - 1) equals: (anArray at: index) ].
	shape := tensor shape.
	size := anArray isEmpty
		ifTrue: [ 1 ]
		ifFalse: [ anArray inject: 1 into: [:prev :next | prev*next] ].
	self assert: shape equals: anArray.
	self assert: tensor size equals: size
]

{ #category : #'testing tensor' }
TensorFlowCAPITest >> testTensorType [
	| tensor |
	tensor := TFTensor newTyped: TFTensor typeInt64 shaped: TensorShape scalar.
	self assert: tensor type equals: tensor class typeInt64.
	tensor := TFTensor newTyped: TFTensor typeFloat shaped: TensorShape scalar.
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
