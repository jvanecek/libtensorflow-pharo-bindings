Class {
	#name : #TensorFlowPharoLibrary,
	#superclass : #FFILibrary,
	#classInstVars : [
		'current'
	],
	#category : #TensorFlowPharoCore
}

{ #category : #accessing }
TensorFlowPharoLibrary class >> current [
	^ current ifNil: [ current := self uniqueInstance ]
]

{ #category : #examples }
TensorFlowPharoLibrary class >> example1 [
	"Add two float numbers"

	| graph c1 c2 sum session result |
	graph := TFGraph create.
	c1 := graph const: 'c1' value: 3.0 asTensor.
	c2 := graph const: 'c2' value: 4.0 asTensor.
	sum := c1 + c2.
	session := TFSession on: graph.
	result := session runOutput: (sum output: 0).
	result asNumbers
]

{ #category : #examples }
TensorFlowPharoLibrary class >> example2 [
	"Multiply two float matrices"

	| graph t1 t2 c1 c2 mult session result |
	graph := TFGraph create.
	t1 := TFTensor fromFloats: #(#(1 2) #(3 4)).
	t2 := TFTensor fromFloats: #(#(5 6) #(7 8)).
	c1 := graph const: 'c1' value: t1.
	c2 := graph const: 'c2' value: t2.
	mult := c1 * c2.
	session := TFSession on: graph.
	result := session runOutput: (mult output: 0).
	result asNumbers
]

{ #category : #examples }
TensorFlowPharoLibrary class >> example3 [
	"Return a 3D tensor with 1 million elements filled with 0"

	| graph zeros session result |
	graph := TFGraph create.
	zeros := graph zerosShaped: #(100 100 100).
	session := TFSession on: graph.
	result := session runOutput: (zeros output: 0).
	result asNumbers
]

{ #category : #initialization }
TensorFlowPharoLibrary class >> initialize [ 
	
	TensorFlowCAPI setCurrentPlatformLibraryTo: self current. 
]

{ #category : #tensor }
TensorFlowPharoLibrary >> allStringsOf: aTFTensor [

	| total answer bytes data |

	total := aTFTensor size.
	answer := WriteStream on: ( Array new: total ).
	bytes := aTFTensor dataBytes.
	data := aTFTensor data getHandle + ( 8 * total ).
	1 to: total do: [ :i | 
		| offset str |

		offset := bytes unsignedLongLongAt: ( i - 1 ) * 8 + 1.
		str := self stringDecode: data + offset.
		answer nextPut: str
		].

	^ answer contents
]

{ #category : #accessing }
TensorFlowPharoLibrary >> allocateTensorOf: aTensorDomain length: aLenght [

	| externalized answer |

	externalized := FFIExternalArray
		externalNewType: 'int64'
		fromArray: aTensorDomain shape dimensionSizes.

	answer := self
		allocateTensorType: aTensorDomain type
		shape: externalized getHandle
		rank: aTensorDomain shape rank
		length: aLenght.
	answer autoRelease.
	^ answer
]

{ #category : #tensor }
TensorFlowPharoLibrary >> allocateTensorType: anInteger shape: aLongLongArray rank: dimCount length: len [
	"TF_CAPI_EXPORT extern TF_Tensor* TF_AllocateTensor(TF_DataType,
                                                   const int64_t* dims, int num_dims, size_t len);"

	^ self
		ffiCall: #(
		#TFTensor * TF_AllocateTensor #(
			int anInteger,
			int64 * aLongLongArray,
			int dimCount,
			size_t len))
		module: TensorFlowPharoLibrary
]

{ #category : #status }
TensorFlowPharoLibrary >> checkStatusAfter: aBlock [

	| status answer |

	status := TFStatus create.
	answer := aBlock cull: status.
	status check.
	^answer
]

{ #category : #session }
TensorFlowPharoLibrary >> closeSession: aTF_Session status: aTF_Status [

	"TF_CAPI_EXPORT extern void TF_CloseSession(TF_Session*, TF_Status* status);"

	^ self
		ffiCall: #(void TF_CloseSession #(TFSession * aTF_Session , TFStatus * aTF_Status))
		module: TensorFlowPharoLibrary
]

{ #category : #buffer }
TensorFlowPharoLibrary >> deleteBuffer: aTF_Buffer [
	"<cdecl: void 'TF_DeleteBuffer' (TF_Buffer*)>"

	^ self
		ffiCall: #(void TF_DeleteBuffer #(#TFBuffer * aTF_Buffer))
		module: TensorFlowPharoLibrary
]

{ #category : #graph }
TensorFlowPharoLibrary >> deleteGraph: aTF_Graph [
	"<cdecl: void 'TF_DeleteGraph' (TF_Graph*)>"

	^ self ffiCall: #(void TF_DeleteGraph #(TFGraph * aTF_Graph)) module: TensorFlowPharoLibrary
]

{ #category : #options }
TensorFlowPharoLibrary >> deleteImportGraphDefOptions: aTF_ImportGraphDefOptions [
	"<cdecl: void 'TF_DeleteImportGraphDefOptions' (TF_ImportGraphDefOptions*)>"

	^ self ffiCall: #(void TF_DeleteImportGraphDefOptions #(#TFImportGraphDefOptions * aTF_ImportGraphDefOptions)) module: TensorFlowPharoLibrary
]

{ #category : #session }
TensorFlowPharoLibrary >> deleteSession: aTF_Session status: aTF_Status [

	"TF_CAPI_EXPORT extern void TF_DeleteSession(TF_Session*, TF_Status* status);"

	^ self
		ffiCall: #(void TF_DeleteSession #(TFSession * aTF_Session , TFStatus * aTF_Status))
		module: TensorFlowPharoLibrary
]

{ #category : #options }
TensorFlowPharoLibrary >> deleteSessionOptions: aTF_SessionOptions [

	"<cdecl: void 'TF_DeleteSessionOptions' (TF_SessionOptions*)>"

	^ self
		ffiCall: #(void TF_DeleteSessionOptions #(TFSessionOptions * aTF_SessionOptions))
		module: TensorFlowPharoLibrary
]

{ #category : #status }
TensorFlowPharoLibrary >> deleteStatus: aTF_Status [

	"<cdecl: void 'TF_DeleteStatus' (TF_Status*)>"

	^ self ffiCall: #(void TF_DeleteStatus #(TFStatus * aTF_Status)) module: TensorFlowPharoLibrary
]

{ #category : #tensor }
TensorFlowPharoLibrary >> deleteTensor: aTF_Tensor [
	"<cdecl: void 'TF_DeleteTensor' (TF_Tensor*)>"

	^ self
		ffiCall: #(void TF_DeleteTensor #(#TFTensor * aTF_Tensor))
		module: TensorFlowPharoLibrary
]

{ #category : #'operation description' }
TensorFlowPharoLibrary >> description: aTF_OperationDescription addControlInput: aTF_Output [

	"<cdecl: void 'TF_AddControlInput' (TF_OperationDescription* desc, TF_Operation* input)>"

	^ self
		ffiCall:
			#(void TF_AddControlInput #(TFOperationDescription * aTF_OperationDescription , TFOperation * aTF_Output))
		module: TensorFlowPharoLibrary
]

{ #category : #'operation description' }
TensorFlowPharoLibrary >> description: aTF_OperationDescription addInput: aTF_Output [

	"<cdecl: void 'TF_AddInput' (TF_OperationDescription* TF_Output)>"

	^ self
		ffiCall: #(void TF_AddInput #(TFOperationDescription * aTF_OperationDescription , TFOutput aTF_Output))
		module: TensorFlowPharoLibrary
]

{ #category : #'operation description' }
TensorFlowPharoLibrary >> description: aTFOperationDescription addInputs: anArrayOfTFOutput [

	| inputs |

	inputs := TFOutputArray fromCollection: anArrayOfTFOutput.
	self description: aTFOperationDescription addInputs: inputs size: anArrayOfTFOutput size
]

{ #category : #'operation description' }
TensorFlowPharoLibrary >> description: aTF_OperationDescription addInputs: aTF_OutputArray size: anInteger [

	"<TF_CAPI_EXPORT extern void TF_AddInputList(TF_OperationDescription* desc,
                                           const TF_Output* inputs, int num_inputs);>"

	^ self
		ffiCall:
			#(void TF_AddInputList #(#TFOperationDescription * aTF_OperationDescription , #TFOutputArray * aTF_OutputArray , int anInteger))
		module: TensorFlowPharoLibrary
]

{ #category : #'operation description' }
TensorFlowPharoLibrary >> description: desc set: attr_name toBool: value [

	"TF_CAPI_EXPORT extern void TF_SetAttrBool(TF_OperationDescription* desc,
                                          const char* attr_name, unsigned char value);"

	^ self
		ffiCall: #(void TF_SetAttrBool #(TFOperationDescription * desc , String attr_name , bool value))
		module: TensorFlowPharoLibrary
]

{ #category : #'operation description' }
TensorFlowPharoLibrary >> description: aTF_OperationDescription set: aString toFloat: valueFloat [
	"TF_CAPI_EXPORT extern void TF_SetAttrFloat(TF_OperationDescription* desc, const char* attr_name, float value);"

	^ self
		ffiCall: #(void TF_SetAttrFloat #(#TFOperationDescription * aTF_OperationDescription , String aString , float valueFloat))
		module: TensorFlowPharoLibrary
]

{ #category : #'operation description' }
TensorFlowPharoLibrary >> description: desc set: attr_name toInt64: value [
	"TF_CAPI_EXPORT extern void TF_SetAttrInt(TF_OperationDescription* desc, const char* attr_name, int64_t value);"

	^ self
		ffiCall: #(void TF_SetAttrInt #(#TFOperationDescription * desc , String attr_name , int64 value))
		module: TensorFlowPharoLibrary
]

{ #category : #'operation description' }
TensorFlowPharoLibrary >> description: aTFOperationDescription set: anAttributeName toInts: aListOfIntegers [

	^ self
		description: aTFOperationDescription
		set: anAttributeName
		toInts: ( FFIExternalArray externalNewType: 'int64' fromArray: aListOfIntegers ) getHandle
		size: aListOfIntegers size
]

{ #category : #'operation description' }
TensorFlowPharoLibrary >> description: aTFOperationDescription set: anAttributeName toInts: aCollection size: aCollectionSize [

	"TF_CAPI_EXPORT extern void TF_SetAttrIntList(TF_OperationDescription* desc,
                                             const char* attr_name,
                                             const int64_t* values,
                                             int num_values);"

	^ self
		ffiCall:
			#(void TF_SetAttrIntList #(TFOperationDescription * aTFOperationDescription , String anAttributeName , int64 * aCollection , int aCollectionSize))
		module: TensorFlowPharoLibrary
]

{ #category : #'operation description' }
TensorFlowPharoLibrary >> description: aTFOperationDescription set: anAttributeName toShape: aTensorShape [

	| status value |

	value := FFIExternalArray externalNewType: 'int64' fromArray: aTensorShape dimensionSizes.
	status := TFStatus create.
	self 
		description: aTFOperationDescription
		set: anAttributeName asAsciiZ
		toShape: value getHandle
		size: aTensorShape dimensionSizes size.
	status check
]

{ #category : #'operation description' }
TensorFlowPharoLibrary >> description: aTF_OperationDescription set: aString toShape: anInt64Array size: size [

	"TF_CAPI_EXPORT extern void TF_SetAttrShape(TF_OperationDescription* desc,
                                           const char* attr_name, const int64_t* dims, int num_dims);"

	^ self
		ffiCall:
			#(void TF_SetAttrShape #(TFOperationDescription * aTF_OperationDescription , String aString , int64 * anInt64Array , int size))
		module: TensorFlowPharoLibrary
]

{ #category : #'operation description' }
TensorFlowPharoLibrary >> description: aTFOperationDescription set: anAttributeName toShapes: aListOfShapes [

	| status pointers shapes shapeSizes |

	shapes := aListOfShapes
		collect:
			[ :shape | ( FFIExternalArray externalNewType: 'int64' fromArray: shape dimensionSizes ) autoRelease ].
	pointers := ByteArray new: Smalltalk wordSize * shapes size.
	shapes
		withIndexDo: [ :each :index | pointers pointerAt: ( index - 1 ) * Smalltalk wordSize + 1 put: each getHandle ].

	shapeSizes := aListOfShapes collect: #rank.
	status := TFStatus create.
	self
		description: aTFOperationDescription
		set: anAttributeName
		toShapes: pointers
		sizesOfEach: ( FFIExternalArray externalNewType: 'int32' fromArray: shapeSizes ) getHandle
		size: aListOfShapes size.
	status check
]

{ #category : #'operation description' }
TensorFlowPharoLibrary >> description: aTFOperationDescription set: anAttributeName toShapes: aShapeCollection sizesOfEach: aShapeSizes size: aNumberOfShapes [

	" // `dims` and `num_dims` must point to arrays of length `num_shapes`.
	// Set `num_dims[i]` to -1 to represent 'unknown rank'.  Otherwise,
	// `dims[i]` points to an array of length `num_dims[i]`.  `dims[i][j]`
	// must be >= -1, with -1 meaning 'unknown dimension'.
	TF_CAPI_EXPORT extern void TF_SetAttrShapeList(TF_OperationDescription* desc,
                                               const char* attr_name,
                                               const int64_t* const* dims,
                                               const int* num_dims,
                                               int num_shapes);"

	self
		ffiCall:
			#(void TF_SetAttrShapeList #(#TFOperationDescription * aTFOperationDescription , String anAttributeName , int64 * aShapeCollection , int32 * aShapeSizes , int aNumberOfShapes))
		module: TensorFlowPharoLibrary
]

{ #category : #'operation description' }
TensorFlowPharoLibrary >> description: desc set: attr_name toString: value size: size [

	"TF_CAPI_EXPORT extern void TF_SetAttrString(TF_OperationDescription* desc,
                                            const char* attr_name, const void* value, size_t length);"

	^ self
		ffiCall:
			#(void TF_SetAttrString #(#TFOperationDescription * desc , String attr_name , String value , size_t size))
		module: TensorFlowPharoLibrary
]

{ #category : #'operation description' }
TensorFlowPharoLibrary >> description: aTFOperationDescription set: anAttributeName toStrings: anArrayOfStrings [

	| status sizes strings pointers |

	sizes := anArrayOfStrings collect: [ :str | str size ].
	sizes := FFIExternalArray externalNewType: 'int64' fromArray: sizes.
	sizes autoRelease.
	strings := anArrayOfStrings collect: [ :each | ( self externalizeString: each ) autoRelease ].
	pointers := ByteArray new: Smalltalk wordSize * strings size.
	strings
		withIndexDo: [ :each :index | pointers pointerAt: ( index - 1 ) * Smalltalk wordSize + 1 put: each ].

	status := TFStatus create.
	self
		description: aTFOperationDescription
		set: anAttributeName
		toStrings: pointers
		sizes: sizes getHandle
		count: anArrayOfStrings size.
	status check
]

{ #category : #'operation description' }
TensorFlowPharoLibrary >> description: aTF_OperationDescription set: aString toStrings: anArrayOfString sizes: sizes count: count [
	"TF_CAPI_EXPORT extern void TF_SetAttrStringList(TF_OperationDescription* desc,
                                                const char* attr_name,
                                                const void* const* values,
                                                const size_t* lengths,
															  int num_values);"

	^ self
		ffiCall:
			#(void TF_SetAttrStringList #(#TFOperationDescription * aTF_OperationDescription , String aString , void * anArrayOfString , int64 * sizes , int count))
		module: TensorFlowPharoLibrary
]

{ #category : #'operation description' }
TensorFlowPharoLibrary >> description: aTF_OperationDescription set: aString toTensor: aTF_Tensor status: aTF_Status [

	"<cdecl: void 'TF_SetAttrTensor' (TF_OperationDescription* char* TF_Tensor* TF_Status*)>"

	^ self
		ffiCall:
			#(void TF_SetAttrTensor #(TFOperationDescription * aTF_OperationDescription , String aString , TFTensor * aTF_Tensor , TFStatus * aTF_Status))
		module: TensorFlowPharoLibrary
]

{ #category : #'operation description' }
TensorFlowPharoLibrary >> description: aTF_OperationDescription set: aString toType: anInt [

	"TF_CAPI_EXPORT extern void TF_SetAttrType(TF_OperationDescription* desc,
                                          const char* attr_name, TF_DataType value);"

	^ self
		ffiCall:
			#(void TF_SetAttrType #(TFOperationDescription * aTF_OperationDescription , String aString , int anInt))
		module: TensorFlowPharoLibrary
]

{ #category : #'operation description' }
TensorFlowPharoLibrary >> description: aTFOperationDescription set: anAttributeName toTypes: aListOfTypes [

	| status |

	status := TFStatus create.
	self
		description: aTFOperationDescription
		set: anAttributeName
		toTypes: ( FFIExternalArray externalNewType: 'int32' fromArray: aListOfTypes ) getHandle
		size: aListOfTypes size.
	status check
]

{ #category : #'operation description' }
TensorFlowPharoLibrary >> description: aTFOperationDescription set: anAttributeName toTypes: aCollection size: aCollectionSize [ 
	" TF_CAPI_EXPORT extern void TF_SetAttrTypeList(TF_OperationDescription* desc,
                                              const char* attr_name,
                                              const TF_DataType* values,
                                              int num_values); "
	^ self
		ffiCall:
			#(void TF_SetAttrTypeList #(TFOperationDescription * aTFOperationDescription , String anAttributeName , int32 * aCollection, int aCollectionSize))
		module: TensorFlowPharoLibrary
]

{ #category : #'operation description' }
TensorFlowPharoLibrary >> description: aTF_OperationDescription setDevice: aString [
	"<cdecl: void 'TF_SetDevice' (TF_OperationDescription* char*)>"

	^ self
		ffiCall:
			#(void TF_SetDevice #(#TFOperationDescription * aTF_OperationDescription , String aString))
		module: TensorFlowPharoLibrary
]

{ #category : #utils }
TensorFlowPharoLibrary >> externalizeString: aString [
	| answer |
	answer := ExternalAddress allocate: aString size + 1.
	answer byteAt: aString size + 1 put: 0.
	aString withIndexDo: [:char :index |
		answer byteAt:  index put: char asciiValue].
	^ answer
]

{ #category : #'operation description' }
TensorFlowPharoLibrary >> finishOperation: aTF_OperationDescription status: aTF_Status [
	| answer |
	
	answer := self finishOperationAsVoid: aTF_OperationDescription status: aTF_Status.
	aTF_OperationDescription handle: nil.
	"answer handle: answer getHandle getHandle."
	^answer
]

{ #category : #'operation description' }
TensorFlowPharoLibrary >> finishOperationAsVoid: desc status: status [

	"TF_CAPI_EXPORT extern TF_Operation* TF_FinishOperation(TF_OperationDescription* desc, TF_Status* status);"

	"// If this function succeeds:
//   * *status is set to an OK value,
//   * a TF_Operation is added to the graph,
//   * a non-null value pointing to the added operation is returned --
//     this value is valid until the underlying graph is deleted.
// Otherwise:
//   * *status is set to a non-OK value,
//   * the graph is not modified,
//   * a null value is returned.
// In either case, it deletes `desc`."

	^ self
		ffiCall: #(#TFOperation * TF_FinishOperation #(#TFOperationDescription * desc , #TFStatus * status))
		module: TensorFlowPharoLibrary
]

{ #category : #operation }
TensorFlowPharoLibrary >> forGraph: aTF_Graph outputDims: aTF_Output status: aTF_Status [

	"<cdecl: ulonglong 'TF_GraphGetTensorNumDims' (TF_Graph* TF_Output TF_Status*)>"

	"Returns the number of dimensions of the Tensor referenced by `output`
in `graph`.

If the number of dimensions in the shape is unknown, returns -1.

Returns an error into `status` if:
   * `output` is not in `graph`."

	^ self
		ffiCall:
			#(int TF_GraphGetTensorNumDims #(#TFGraph * aTF_Graph , #TFOutput aTF_Output , #TFStatus * aTF_Status))
		module: TensorFlowPharoLibrary
]

{ #category : #utils }
TensorFlowPharoLibrary >> getAllOps [
	"<cdecl: TF_Buffer* 'TF_GetAllOpList' (void)>"

	^ self ffiCall: #(#TFBuffer * TF_GetAllOpList #()) module: TensorFlowPharoLibrary
]

{ #category : #status }
TensorFlowPharoLibrary >> getCode: aTF_Status [

	"<cdecl: ulong 'TF_GetCode' (TF_Status*)>"

	^ self ffiCall: #(ulong TF_GetCode #(TFStatus * aTF_Status)) module: TensorFlowPharoLibrary
]

{ #category : #graph }
TensorFlowPharoLibrary >> getGraphVersionsOf: aTF_Graph buffer: aTF_Buffer status: aTF_Status [
	"// Returns the serialized VersionDef proto for this graph.
TF_CAPI_EXPORT extern void TF_GraphVersions(TF_Graph* graph,
                                            TF_Buffer* output_version_def, TF_Status* status);"

	^ self ffiCall: #(void TF_GraphVersions #(#TFGraph * aTF_Graph , #TFBuffer * aTF_Buffer , #TFStatus * aTF_Status)) module: TensorFlowPharoLibrary
]

{ #category : #gradients }
TensorFlowPharoLibrary >> gradientsOf: yArrayOfTFOutput withRespectTo: xArrayOfTFOutput product: dxArrayOfOutput in: aTFGraph [

	| y x dx status dy |

	y := TFOutputArray externalFromArray: yArrayOfTFOutput.
	x := TFOutputArray externalFromArray: xArrayOfTFOutput.
	dx := dxArrayOfOutput
		ifNil: [ ExternalData fromHandle: ExternalAddress new beNull type: ExternalType char asPointerType ]
		ifNotNil: [ TFOutputArray externalFromArray: dxArrayOfOutput ].
	dy := TFOutputArray externalNew: xArrayOfTFOutput size.
	status := TFStatus create.
	self
		graph: aTFGraph
		y: y
		yCount: yArrayOfTFOutput size
		x: x
		xCount: xArrayOfTFOutput size
		dx: dx
		status: status
		into: dy.
	status check.
	^ dy
]

{ #category : #graph }
TensorFlowPharoLibrary >> graph: aTF_Graph getOperationNamed: aString [
	| answer |
	answer := self graph: aTF_Graph getOperationNamedAsVoid: aString.
	answer := TFOperation fromHandle: answer.
	answer graph: aTF_Graph.
	^ answer
]

{ #category : #graph }
TensorFlowPharoLibrary >> graph: aTF_Graph getOperationNamedAsVoid: aString [

	"<cdecl: void* 'TF_GraphOperationByName' (TF_Graph* char*)>"

	^ self
		ffiCall: #(void * TF_GraphOperationByName #(TFGraph * aTF_Graph , String aString))
		module: TensorFlowPharoLibrary
]

{ #category : #utils }
TensorFlowPharoLibrary >> graph: aTFGraph getRankOf: aTFOutputOrInput [

	| status answer |

	status := TFStatus create.
	answer := self graph: aTFGraph getRankOf: aTFOutputOrInput status: status.
	status check.
	^ answer
]

{ #category : #graph }
TensorFlowPharoLibrary >> graph: aTF_Graph getRankOf: aTF_OutputOrInput status: status [

	"<cdecl: ulonglong 'TF_GraphGetTensorNumDims' (TF_Graph* TF_Output TF_Status*)>"

	^ self
		ffiCall:
			#(int TF_GraphGetTensorNumDims #(TFGraph * aTF_Graph , TFOutput aTF_OutputOrInput , TFStatus * status))
		module: TensorFlowPharoLibrary
]

{ #category : #utils }
TensorFlowPharoLibrary >> graph: aTFGraph getShapeOf: aTFOutputOrInput [

	| status value size answer |

	size := self graph: aTFGraph getRankOf: aTFOutputOrInput.
	value := FFIExternalArray externalNewType: 'int64' size: size.
	status := TFStatus create.
	self
		graph: aTFGraph
		getShapeOf: aTFOutputOrInput
		into: value getHandle
		size: size
		status: status.
	status check.
	answer := ( 1 to: size ) collect: [ :i | value at: i ].
	^ answer asTensorShape
]

{ #category : #graph }
TensorFlowPharoLibrary >> graph: aTF_Graph getShapeOf: aTF_OutputOrInput into: anInt64Array size: anInteger status: status [

	"TF_CAPI_EXPORT extern void TF_GraphGetTensorShape(TF_Graph* graph,
                                                  TF_Output output,
                                                  int64_t* dims, int num_dims,
																TF_Status* status);"

	^ self
		ffiCall:
			#(void TF_GraphGetTensorShape #(TFGraph * aTF_Graph , TFOutput aTF_OutputOrInput , int64 * anInt64Array , int anInteger , TFStatus * status))
		module: TensorFlowPharoLibrary
]

{ #category : #operation }
TensorFlowPharoLibrary >> graph: aTF_Graph operationAt: contextULongLongPtr [
	| answer |
	answer := self graph: aTF_Graph operationAtAsVoid: contextULongLongPtr.
	answer handle: answer getHandle.
	answer graph: aTF_Graph.
	^ answer
]

{ #category : #operation }
TensorFlowPharoLibrary >> graph: aTF_Graph operationAtAsVoid: contextULongLongPtr [

	"TF_CAPI_EXPORT extern TF_Operation* TF_GraphNextOperation(TF_Graph* graph, size_t* pos);"

	^ self
		ffiCall: #(#TFOperation * TF_GraphNextOperation #(TFGraph * aTF_Graph , size_t * contextULongLongPtr))
		module: TensorFlowPharoLibrary
]

{ #category : #utils }
TensorFlowPharoLibrary >> graph: aTFGraph setShapeOf: aTFOutputOrInput to: aShape [

	| status value |

	value := FFIExternalArray externalNewType: 'int64' fromArray: aShape.
	status := TFStatus create.
	self
		graph: aTFGraph
		setShapeOf: aTFOutputOrInput
		to: value getHandle
		size: aShape size
		status: status.
	status check
]

{ #category : #graph }
TensorFlowPharoLibrary >> graph: aTF_Graph setShapeOf: aTF_OutputOrInput to: anInt64Array size: anInteger status: status [
	"<cdecl: void 'TF_GraphSetTensorShape' (TF_Graph* TF_Output Int64Array* ulonglong TF_Status*)>"

^ self ffiCall: #(void TF_GraphSetTensorShape #(#TFGraph * aTF_Graph, #TFOutput aTF_OutputOrInput, int64 * anInt64Array, int anInteger, #TFStatus * status)) module: TensorFlowPharoLibrary
]

{ #category : #graph }
TensorFlowPharoLibrary >> graph: aTF_Graph toGraphDef: aTF_Buffer status: aTF_Status [
	"<cdecl: void 'TF_GraphToGraphDef' (TF_Graph* TF_Buffer* TF_Status*)>"

	^ self
		ffiCall: #(void TF_GraphToGraphDef #(#TFGraph * aTF_Graph , #TFBuffer * aTF_Buffer , #TFStatus * aTF_Status))
		module: TensorFlowPharoLibrary
]

{ #category : #gradients }
TensorFlowPharoLibrary >> graph: aTFGraph y: yTFOutputArray yCount: yCount x: xTFOutputArray xCount: xCount dx: dxTFOutputArray status: aTFStatus into: dyTFOutputArray [

	" void TF_AddGradients(TF_Graph* g, TF_Output* y, int ny,
						   TF_Output* x, int nx, TF_Output* dx,
						   TF_Status* status, TF_Output* dy); "

	^ self
		ffiCall:
			#(void * TF_AddGradients #(TFGraph * aTFGraph , TFOutputArray * yTFOutputArray , int yCount , TFOutputArray * xTFOutputArray , int xCount , TFOutputArray * dxTFOutputArray , TFStatus * aTFStatus , TFOutputArray * dyTFOutputArray))
		module: TensorFlowPharoLibrary
]

{ #category : #graph }
TensorFlowPharoLibrary >> importGraphDefInto: aTF_Graph from: aTF_Buffer options: aTF_ImportGraphDefOptions status: aTF_Status [
	"<cdecl: void 'TF_GraphImportGraphDef' (TF_Graph* TF_Buffer* TF_ImportGraphDefOptions* TF_Status*)>"

	^ self ffiCall: #(void TF_GraphImportGraphDef #(#TFGraph * aTF_Graph, #TFBuffer * aTF_Buffer, #TFImportGraphDefOptions * aTF_ImportGraphDefOptions, #TFStatus * aTF_Status)) module: TensorFlowPharoLibrary
]

{ #category : #'accessing platform' }
TensorFlowPharoLibrary >> macModuleName [
	^ '/usr/local/Cellar/libtensorflow/1.14.0/lib/libtensorflow.so'
]

{ #category : #status }
TensorFlowPharoLibrary >> message: aTF_Status [
	"<cdecl: char* 'TF_Message' (TF_Status*)>"

	^ self ffiCall: #(String TF_Message #(#TFStatus * aTF_Status)) module: TensorFlowPharoLibrary 
]

{ #category : #session }
TensorFlowPharoLibrary >> newAutoreleaseSessionOn: aTFGraph [

	| options status answer session |

	options := TFSessionOptions create.
	status := TFStatus create.
	answer := self newSession: aTFGraph options: options status: status.
	status check.
	session := answer autoRelease.
	aTFGraph initializeOn: session.
	^ session
]

{ #category : #options }
TensorFlowPharoLibrary >> newAutoreleaseSessionOptions [

	^ self newSessionOptions autoRelease
]

{ #category : #status }
TensorFlowPharoLibrary >> newAutoreleaseStatus [

	^ self newStatus autoRelease
]

{ #category : #buffer }
TensorFlowPharoLibrary >> newBufferFromString: aString size: anInteger [
	"<cdecl: TF_Buffer* 'TF_NewBufferFromString' (char* size_t)>"

	^ self
		ffiCall: #(#TFBuffer * TF_NewBufferFromString #(String aString , size_t anInteger))
		module: TensorFlowPharoLibrary
]

{ #category : #'instance creation' }
TensorFlowPharoLibrary >> newGraph [
	| answer |
	answer := self newGraphAsVoid.
	answer := TFGraph fromHandle: answer getHandle.
	^ answer initialize autoRelease
]

{ #category : #'instance creation' }
TensorFlowPharoLibrary >> newGraphAsVoid [

	"F_CAPI_EXPORT extern TF_Graph* TF_NewGraph();"

	^ self ffiCall: #(#TFGraph * TF_NewGraph #()) module: TensorFlowPharoLibrary
]

{ #category : #options }
TensorFlowPharoLibrary >> newImportGraphDefOptions [
	"<cdecl: TF_ImportGraphDefOptions* 'TF_NewImportGraphDefOptions' (void)>"

	^ self ffiCall: #(#TFImportGraphDefOptions * TF_NewImportGraphDefOptions #()) module: TensorFlowPharoLibrary
]

{ #category : #operation }
TensorFlowPharoLibrary >> newOperationDescriptionOn: graph type: type named: aName [

	"<cdecl: TF_OperationDescription* 'TF_NewOperation' (TF_Graph* char* char*)>"

	^ self
		ffiCall: #(#TFOperationDescription * TF_NewOperation #(TFGraph * graph , String type , String aName))
		module: TensorFlowPharoLibrary
]

{ #category : #session }
TensorFlowPharoLibrary >> newSession: aTF_Graph options: aTF_SessionOptions status: aTF_Status [

	"<cdecl: TF_Session* 'TF_NewSession' (TF_Graph* TF_SessionOptions* TF_Status*)>"

	^ self
		ffiCall:
			#(#TFSession * TF_NewSession #(TFGraph * aTF_Graph , #TFSessionOptions * aTF_SessionOptions , #TFStatus * aTF_Status))
		module: TensorFlowPharoLibrary
]

{ #category : #options }
TensorFlowPharoLibrary >> newSessionOptions [

	"<cdecl: TF_SessionOptions* 'TF_NewSessionOptions' (void)>"

	^ self ffiCall: #(#TFSessionOptions * TF_NewSessionOptions #()) module: TensorFlowPharoLibrary
]

{ #category : #status }
TensorFlowPharoLibrary >> newStatus [

	"<cdecl: TF_Status* 'TF_NewStatus' (void)>"

	^ self ffiCall: #(#TFStatus * TF_NewStatus #()) module: TensorFlowPharoLibrary
]

{ #category : #tensor }
TensorFlowPharoLibrary >> newTensorType: anInteger shape: aLongLongArray rank: dimCount data: aData length: len deallocator: deallocator args: args [
	"TF_CAPI_EXPORT extern TF_Tensor* TF_NewTensor(
    	TF_DataType, const int64_t* dims, int num_dims, void* data, size_t len,
    	void (*deallocator)(void* data, size_t len, void* arg),
    	void* deallocator_arg);"

	^ self
		ffiCall: #(
		#TFTensor * TF_NewTensor #(
			int anInteger,
			int64 * aLongLongArray,
			int dimCount,
			void* aData,
			size_t len,
			void* deallocator,
			void* args
			))
		module: TensorFlowPharoLibrary
]

{ #category : #operation }
TensorFlowPharoLibrary >> operation: aTF_Operation attr: nameZString getBool: valueBoolPtr status: status [
	"<cdecl: void 'TF_OperationGetAttrBool' (TF_Operation* char* ulonglong* TF_Status*)>"

	^ self
		ffiCall:
			#(void TF_OperationGetAttrBool #(#TFOperation * aTF_Operation , String nameZString , ulonglong * valueBoolPtr , #TFStatus * status))
		module: TensorFlowPharoLibrary
]

{ #category : #operation }
TensorFlowPharoLibrary >> operation: aTF_Operation attr: nameZString getFloat: valueFloatPtr status: status [
	"<cdecl: void 'TF_OperationGetAttrFloat' (TF_Operation* char* float* TF_Status*)>"

	^ self
		ffiCall:
			#(void TF_OperationGetAttrFloat #(#TFOperation * aTF_Operation , String nameZString , float * valueFloatPtr , #TFStatus * status))
		module: TensorFlowPharoLibrary
]

{ #category : #operation }
TensorFlowPharoLibrary >> operation: aTF_Operation attr: nameZString getInt64: valueLongPtr status: status [
	"TF_CAPI_EXPORT extern void TF_OperationGetAttrInt(TF_Operation* oper,
                                                  const char* attr_name,
                                                  int64_t* value, TF_Status* status);"

	^ self
		ffiCall: #(void TF_OperationGetAttrInt #(#TFOperation * aTF_Operation , String nameZString , int64 * valueLongPtr , #TFStatus * status))
		module: TensorFlowPharoLibrary
]

{ #category : #operation }
TensorFlowPharoLibrary >> operation: aTF_Operation attr: nameZString getShape: int64array size: maxSize status: status [
	"TF_CAPI_EXPORT extern void TF_OperationGetAttrShape(TF_Operation* oper,
                                                    const char* attr_name,
                                                    int64_t* value,
                                                    int num_dims, TF_Status* status);"

	^ self
		ffiCall: #(void TF_OperationGetAttrShape #(#TFOperation * aTF_Operation , String nameZString , int64 * int64array , int maxSize, #TFStatus * status))
		module: TensorFlowPharoLibrary
]

{ #category : #operation }
TensorFlowPharoLibrary >> operation: aTF_Operation attr: nameZString getString: valueString size: maxSize status: status [
	"TF_CAPI_EXPORT extern void TF_OperationGetAttrString(TF_Operation* oper,
                                                     const char* attr_name,
                                                     void* value,
                                                     size_t max_length,
																	TF_Status* status);"

	^ self
		ffiCall: #(void TF_OperationGetAttrString #(#TFOperation * aTF_Operation , String nameZString , void * valueString , size_t maxSize , #TFStatus * status))
		module: TensorFlowPharoLibrary
]

{ #category : #operation }
TensorFlowPharoLibrary >> operation: aTF_Operation attr: nameZString getStrings: valueStringArray sizes: sizesArray maxCount: maxCount storage: aByteArray size: storageSize status: status [
	"TF_CAPI_EXPORT extern void TF_OperationGetAttrStringList(
    TF_Operation* oper, const char* attr_name, void** values, size_t* lengths,
int max_values, void* storage, size_t storage_size, TF_Status* status);"

	^ self
		ffiCall:
			#(void TF_OperationGetAttrStringList #(#TFOperation * aTF_Operation , String nameZString , void * valueStringArray , int64 * sizesArray , int maxCount , void * aByteArray , size_t storageSize , #TFStatus * status))
		module: TensorFlowPharoLibrary
]

{ #category : #operation }
TensorFlowPharoLibrary >> operation: aTF_Operation attr: nameZString getTensor: valueLongPtr status: status [
	"<cdecl: void 'TF_OperationGetAttrTensor' (TF_Operation* char* void* TF_Status*)>"

	^ self
		ffiCall:
			#(void TF_OperationGetAttrTensor #(TFOperation * aTF_Operation , String nameZString , void * valueLongPtr, TFStatus * status))
		module: TensorFlowPharoLibrary
]

{ #category : #operation }
TensorFlowPharoLibrary >> operation: aTF_Operation attr: nameZString getType: valueLongPtr status: status [
	"<cdecl: void 'TF_OperationGetAttrType' (TF_Operation* char* ulonglong* TF_Status*)>"

	^ self
		ffiCall: #(void TF_OperationGetAttrType #(#TFOperation * aTF_Operation , String nameZString , ulonglong * valueLongPtr , #TFStatus * status))
		module: TensorFlowPharoLibrary
]

{ #category : #'operation attribute' }
TensorFlowPharoLibrary >> operation: aTFOperation getBoolAt: anAttributeName [

	| value status |

	status := TFStatus create.
	value := ByteArray new: 1.
	self
		operation: aTFOperation
		attr: anAttributeName asAsciiZ
		getBool: value
		status: status.
	status check.
	^ value booleanAt: 1
]

{ #category : #'operation attribute' }
TensorFlowPharoLibrary >> operation: aTFOperation getFloatAt: anAttributeName [

	| value status |

	status := TFStatus create.
	value := ByteArray new: 8.
	self
		operation: aTFOperation
		attr: anAttributeName asAsciiZ
		getFloat: value
		status: status.
	status check.
	^ value floatAt: 1
]

{ #category : #'operation attribute' }
TensorFlowPharoLibrary >> operation: aTFOperation getInt64At: anAttributeName [

	| value status |

	status := TFStatus create.
	value := ByteArray new: 8.
	self
		operation: aTFOperation
		attr: anAttributeName
		getInt64: value
		status: status.
	status check.
	^ value unsignedLongLongAt: 1
]

{ #category : #'operation attribute' }
TensorFlowPharoLibrary >> operation: aTFOperation getMetadataFor: anAttributeName [

	| status answer |

	status := TFStatus create.
	answer := self operation: aTFOperation getMetadataFor: anAttributeName status: status.
	status check.
	^answer
]

{ #category : #operation }
TensorFlowPharoLibrary >> operation: aTF_Operation getMetadataFor: nameZString status: status [
	"<cdecl: TF_AttrMetadata 'TF_OperationGetAttrMetadata' (TF_Operation* char* TF_Status*)>"

	^ self
		ffiCall:
			#(#TFAttrMetadata TF_OperationGetAttrMetadata #(#TFOperation * aTF_Operation , String nameZString , #TFStatus * status))
		module: TensorFlowPharoLibrary
]

{ #category : #'operation attribute' }
TensorFlowPharoLibrary >> operation: aTFOperation getShapeAt: anAttributeName [

	| value status size answer |

	size := ( self operation: aTFOperation getMetadataFor: anAttributeName ) total_size.
	size = -1
		ifTrue: [ ^ TensorShape scalar ].
	status := TFStatus create.
	value := FFIExternalArray externalNewType: 'int64' size: size.
	self
		operation: aTFOperation
		attr: anAttributeName
		getShape: value getHandle
		size: size
		status: status.
	status check.

	answer := ( 1 to: size ) collect: [ :i | value at: i ].
	^ TensorShape withDimensionsSized: answer
]

{ #category : #'operation attribute' }
TensorFlowPharoLibrary >> operation: aTFOperation getStringAt: anAttributeName [

	| metadata value status |

	metadata := self operation: aTFOperation getMetadataFor: anAttributeName.
	status := TFStatus create.
	value := ByteArray new: metadata total_size.
	self
		operation: aTFOperation
		attr: anAttributeName
		getString: value
		size: metadata total_size
		status: status.
	status check.
	^ value asString
]

{ #category : #'operation attribute' }
TensorFlowPharoLibrary >> operation: aTFOperation getStringsAt: anAttributeName [

	| status pointers sizes spaceRequired storage metadata valuesCount |

	metadata := self operation: aTFOperation getMetadataFor: anAttributeName.
	spaceRequired := metadata totalSize.
	valuesCount := metadata listSize.
	pointers := ByteArray new: Smalltalk wordSize * valuesCount.
	sizes := ( FFIExternalArray externalNewType: 'int64' size: valuesCount ) autoRelease.
	storage := ExternalAddress gcallocate: spaceRequired.
	status := TFStatus create.
	self
		operation: aTFOperation
		attr: anAttributeName
		getStrings: pointers
		sizes: sizes getHandle
		maxCount: valuesCount
		storage: storage
		size: spaceRequired
		status: status.
	status check.
	^ ( 1 to: valuesCount )
		collect: [ :i | | one |
			one := pointers pointerAt: ( i - 1 ) * Smalltalk wordSize + 1.
			one := one structAt: 1 length: ( sizes at: i ).
			one asString ]
]

{ #category : #'operation attribute' }
TensorFlowPharoLibrary >> operation: aTFOperation getTensorAt: anAttributeName [

	| value status |

	status := TFStatus create.
	value := ByteArray new: ExternalAddress wordSize.
	self
		operation: aTFOperation
		attr: anAttributeName
		getTensor: value
		status: status.
	status check.
	^ TFTensor fromHandle: ( value pointerAt: 1 )
]

{ #category : #'operation attribute' }
TensorFlowPharoLibrary >> operation: aTFOperation getTypeAt: anAttributeName [

	| value status |

	status := TFStatus create.
	value := ByteArray new: 8.
	self
		operation: aTFOperation
		attr: anAttributeName
		getType: value
		status: status.
	status check.
	^ value unsignedLongLongAt: 1
]

{ #category : #operation }
TensorFlowPharoLibrary >> operationDevice: aTF_Operation [
	"<cdecl: char* 'TF_OperationDevice' (TF_Operation*)>"

	^ self ffiCall: #(String TF_OperationDevice #(#TFOperation * aTF_Operation)) module: TensorFlowPharoLibrary
]

{ #category : #operation }
TensorFlowPharoLibrary >> operationInput: aTF_Input [
	"TF_CAPI_EXPORT extern TF_Output TF_OperationInput(TF_Input oper_in);"

	^ self ffiCall: #(#TFOutput TF_OperationInput #(#TFInput aTF_Input)) module: TensorFlowPharoLibrary
]

{ #category : #operation }
TensorFlowPharoLibrary >> operationName: aTF_Operation [

	"<cdecl: char* 'TF_OperationName' (TF_Operation*)>"

	^ self
		ffiCall: #(String TF_OperationName #(TFOperation * aTF_Operation))
		module: TensorFlowPharoLibrary
]

{ #category : #operation }
TensorFlowPharoLibrary >> operationNumInputs: aTF_Operation [
	"TF_CAPI_EXPORT extern int TF_OperationNumInputs(TF_Operation* oper);"

	^ self
		ffiCall: #(int TF_OperationNumInputs #(#TFOperation * aTF_Operation))
		module: TensorFlowPharoLibrary
]

{ #category : #operation }
TensorFlowPharoLibrary >> operationNumOutputs: aTF_Operation [
	"TF_CAPI_EXPORT extern int TF_OperationNumOutputs(TF_Operation* oper)"

	^ self
		ffiCall: #(int TF_OperationNumOutputs #(#TFOperation * aTF_Operation))
		module: TensorFlowPharoLibrary
]

{ #category : #operation }
TensorFlowPharoLibrary >> operationOpType: aTF_Operation [

	"<cdecl: char* 'TF_OperationOpType' (TF_Operation*)>"

	^ self
		ffiCall: #(String TF_OperationOpType #(TFOperation * aTF_Operation))
		module: TensorFlowPharoLibrary
]

{ #category : #operation }
TensorFlowPharoLibrary >> operationOutputType: aTF_Output [

	"<cdecl: TF_DataType 'TF_OperationOutputType' (TF_Output)>"

	^ self ffiCall: #(int TF_OperationOutputType #(TFOutput aTF_Output)) module: TensorFlowPharoLibrary
]

{ #category : #strings }
TensorFlowPharoLibrary >> primStringEncodedSize: anInteger [
	"TF_CAPI_EXPORT extern size_t TF_StringEncodedSize(size_t len)"

	^ self ffiCall: #(size_t TF_StringEncodedSize #(size_t anInteger)) module: TensorFlowPharoLibrary
]

{ #category : #session }
TensorFlowPharoLibrary >> runSession: aTFSession inputs: inArrayOfTFInputs values: inArrayOfTFTensor outputs: outArrayOfTFOutputs [

	| inputs invalues outputs outvalues status |

	status := TFStatus create.
	inputs := TFInputArray fromCollection: inArrayOfTFInputs.
	invalues := TFTensorPtrArray fromCollection: inArrayOfTFTensor.
	outputs := TFOutputArray externalFromArray: outArrayOfTFOutputs.
	outvalues := TFTensorPtrArray externalNew: outArrayOfTFOutputs size.
	self
		runSession: aTFSession
		options: nil
		inputs: inputs getHandle
		values: invalues getHandle
		count: inArrayOfTFInputs size
		outputs: outputs getHandle
		values: outvalues getHandle
		count: outArrayOfTFOutputs size
		targets: nil
		count: 0
		metadata: nil
		status: status.
	status check.
	^ outvalues asArray
]

{ #category : #session }
TensorFlowPharoLibrary >> runSession: aTFSession operation: aTFOperation output: aTFOutput [

	| operations answer outputs status outvalues |

	operations := TFOperationPtrArray externalNew: 1.
	outputs := TFOutputArray externalNew: 1.
	outputs at: 1 put: aTFOutput.
	operations at: 1 put: aTFOperation getHandle getHandle.
	status := TFStatus create.
	outvalues := TFTensorPtrArray externalNew: 1.
	self 
		runSession: aTFSession
		options: nil
		inputs: nil
		values: nil
		count: 0
		outputs: outputs getHandle
		values: outvalues getHandle
		count: 1
		targets: operations getHandle
		count: 1
		metadata: nil
		status: status.
	status check.
	answer := outvalues asArray.
	^ answer first
]

{ #category : #session }
TensorFlowPharoLibrary >> runSession: aTFSession operations: anArrayOfTFOperations [

	| status operations |

	status := TFStatus create.
	operations := TFOperationPtrArray
		fromCollection: ( anArrayOfTFOperations collect: [ :op | op getHandle getHandle ] ).
	self
		runSession: aTFSession
		options: nil
		inputs: nil
		values: nil
		count: 0
		outputs: nil
		values: nil
		count: 0
		targets: operations getHandle
		count: anArrayOfTFOperations size
		metadata: nil
		status: status.
	status check
]

{ #category : #session }
TensorFlowPharoLibrary >> runSession: aTF_Session options: opsTF_Buffer inputs: inTF_OutputArray values: inTF_TensorArray count: inCount outputs: outTF_OutputArray values: outTF_TensorArrayPtr count: outCount targets: aTF_OperationArray count: targetCount metadata: metaTF_Buffer status: aTF_Status [

	"F_CAPI_EXPORT extern void TF_SessionRun(
    TF_Session* session,
    // RunOptions
    const TF_Buffer* run_options,
    // Input tensors
    const TF_Output* inputs, TF_Tensor* const* input_values, int ninputs,
    // Output tensors
    const TF_Output* outputs, TF_Tensor** output_values, int noutputs,
    // Target operations
    const TF_Operation* const* target_opers, int ntargets,
    // RunMetadata
    TF_Buffer* run_metadata,
    // Output status
TF_Status*);"

	^ self
		ffiCall:
			#(void TF_SessionRun #(TFSession * aTF_Session , TFBuffer * opsTF_Buffer , void * inTF_OutputArray , void * inTF_TensorArray , int inCount , void * outTF_OutputArray , void * outTF_TensorArrayPtr , int outCount , void * aTF_OperationArray , int targetCount , TFBuffer * metaTF_Buffer , TFStatus * aTF_Status))
		module: TensorFlowPharoLibrary
]

{ #category : #session }
TensorFlowPharoLibrary >> runSession: aTFSession outputs: anArrayOfTFOutputs [ 
	
	| aTFOutputArray anInteger status outvalues |

	aTFOutputArray := TFOutputArray fromCollection: anArrayOfTFOutputs.
	anInteger := anArrayOfTFOutputs size.
	status := TFStatus create.
	outvalues := TFTensorPtrArray externalNew: anInteger.
	self
		runSession: aTFSession
		options: nil
		inputs: nil
		values: nil
		count: 0
		outputs: aTFOutputArray getHandle
		values: outvalues getHandle
		count: anInteger
		targets: nil
		count: 0
		metadata: nil
		status: status.
	status check.
	^ outvalues asArray
]

{ #category : #options }
TensorFlowPharoLibrary >> sessionOptions: aTF_SessionOptions setConfig: aString configSize: anInteger status: aTF_Status [
	" not sure how to use this. Best information found in http://devdocs.io/tensorflow~python/contrib.learn#RunConfig"

	"<TF_CAPI_EXPORT extern void TF_SetConfig(TF_SessionOptions* options,
                                        const void* proto, size_t proto_len,
													TF_Status* status);>"

	^ self
		ffiCall: #(void TF_SetConfig #(#TFSessionOptions * aTF_SessionOptions , String aString , size_t anInteger , #TFStatus * aTF_Status))
		module: TensorFlowPharoLibrary
]

{ #category : #options }
TensorFlowPharoLibrary >> sessionOptions: aTF_SessionOptions setTarget: aString [
	"<cdecl: void 'TF_SetTarget' (TF_SessionOptions* char*)>"

	^ self
		ffiCall: #(void TF_SetTarget #(#TFSessionOptions * aTF_SessionOptions , String aString))
		module: TensorFlowPharoLibrary
]

{ #category : #status }
TensorFlowPharoLibrary >> setStatus: aTF_Status code: anInteger message: anExternalString [
	"TF_CAPI_EXPORT extern void TF_SetStatus(TF_Status* s, TF_Code code, const char* msg);"

	^ self ffiCall: #(void TF_SetStatus #(#TFStatus * aTF_Status , ulong anInteger , String anExternalString)) module: TensorFlowPharoLibrary
]

{ #category : #accessing }
TensorFlowPharoLibrary >> sizeOfDataType: anInteger [

	TFTensor typeFloat = anInteger ifTrue: [^4].
	TFTensor typeInt64 = anInteger ifTrue: [^8].
	TFTensor typeInt32 = anInteger ifTrue: [^4].
	TFTensor typeUInt8 = anInteger ifTrue: [^1].
	TFTensor typeDouble = anInteger ifTrue: [^8].
	TFTensor typeBoolean = anInteger ifTrue: [^1].

"
8
		UInt8 4
		Int8 6
		QInt8 11
		QUInt8 12

16
		Int16 5
		BFloat16 14
		QInt16 15
		QUInt16 16
		UInt16 17
		Half 19

32
		Float 1
		Int32 3
		QInt32 13

64
		Double 2
		Complex64 8
		Int64 9

128
		Complex128 18

		String 7
		Resource 20).

		Bool 10
"


	^ self shouldBeImplemented.
]

{ #category : #strings }
TensorFlowPharoLibrary >> stringDecode: src [
	| destination status answer dstSize |
	destination := ByteArray new: 8.
	dstSize := ByteArray new: 8.
	status := TFStatus create.
	answer := self stringDecode: src len: src size destination: destination len: dstSize status: status.
	status check.
	dstSize := dstSize unsignedLongLongAt: 1.
	destination := destination pointerAt: 1.
	answer := (destination structAt: 1 length: dstSize) asString.
	^ answer
]

{ #category : #strings }
TensorFlowPharoLibrary >> stringDecode: srcString len: srcLen destination: dstPointer len: dstLenPointer status: status [
	"TF_CAPI_EXPORT extern size_t TF_StringDecode(const char* src, size_t src_len,
                                             const char** dst, size_t* dst_len,
TF_Status* status);"

	^ self
		ffiCall:
			#(size_t TF_StringDecode #(String srcString , size_t srcLen , String dstPointer , size_t * dstLenPointer, #TFStatus * status))
		module: TensorFlowPharoLibrary
]

{ #category : #strings }
TensorFlowPharoLibrary >> stringEncode: srcString len: srcLen destination: dstString len: dstLen status: status [
	"TF_CAPI_EXPORT extern size_t TF_StringEncode(const char* src, size_t src_len,
                                             char* dst, size_t dst_len,
													TF_Status* status);"

	^ self
		ffiCall:
			#(size_t TF_StringEncode #(String srcString , size_t srcLen , String dstString , size_t dstLen, #TFStatus * status))
		module: TensorFlowPharoLibrary
]

{ #category : #strings }
TensorFlowPharoLibrary >> stringEncode: src to: dst [
	^ self stringEncode: src to: dst size: dst size
]

{ #category : #strings }
TensorFlowPharoLibrary >> stringEncode: src to: dst size: dstSize [
	| status answer |
	status := TFStatus create.
	answer := self
		stringEncode: src
		len: src size
		destination: dst
		len: dstSize
		status: status.
	status check.
	^ answer
]

{ #category : #strings }
TensorFlowPharoLibrary >> stringEncoded: aString [ 
	self shouldBeImplemented.
]

{ #category : #strings }
TensorFlowPharoLibrary >> stringEncodedSize: aString [
	^ self primStringEncodedSize: aString size
]

{ #category : #tensor }
TensorFlowPharoLibrary >> tensor: aTF_Tensor sizeOn: dimension [

	"TF_CAPI_EXPORT extern int64_t TF_Dim(const TF_Tensor* tensor, int dim_index);"

	^ self
		ffiCall: #(int64 TF_Dim #(TFTensor * aTF_Tensor , int dimension))
		module: TensorFlowPharoLibrary
]

{ #category : #tensor }
TensorFlowPharoLibrary >> tensorByteSize: aTF_Tensor [
	"TF_CAPI_EXPORT extern size_t TF_TensorByteSize(const TF_Tensor*);"

	^ self ffiCall: #(size_t TF_TensorByteSize #(#TFTensor * aTF_Tensor)) module: TensorFlowPharoLibrary
]

{ #category : #tensor }
TensorFlowPharoLibrary >> tensorDataOf: aTF_Tensor [
	"TF_CAPI_EXPORT extern void* TF_TensorData(const TF_Tensor*)"

	^ self
		ffiCall: #(void * TF_TensorData #(TFTensor * aTF_Tensor))
		module: TensorFlowPharoLibrary
]

{ #category : #tensor }
TensorFlowPharoLibrary >> tensorFromString: aString [

	| bytesize |

	bytesize := self stringEncodedSize: aString.

	^ TFTensor
		newTyped: TFTensor typeString
		shaped: TensorShape scalar
		bytesize: bytesize
		thenDo: [ :tensor | self stringEncode: aString to: tensor data getHandle size: bytesize ]
]

{ #category : #tensor }
TensorFlowPharoLibrary >> tensorFromStrings: aStringArray shaped: aTensorShape [

	| sizes offsets offsetSize bytesize |

	sizes := aStringArray collect: [ :each | self stringEncodedSize: each ].
	offsetSize := self sizeOfDataType: TFTensor typeInt64.
	bytesize := offsetSize * aStringArray size + sizes sum.
	offsets := OrderedCollection new: sizes size.

	sizes
		inject: 0
		into: [ :prev :each | 
			offsets add: prev.
			each + prev
			].

	^ TFTensor
		newTyped: TFTensor typeString
		shaped: aTensorShape
		bytesize: bytesize
		thenDo: [ :answer | 
			TFTensor int64Array: offsets into: answer data getHandle.

			aStringArray
				withIndexDo: [ :each :index | 
					| offset |

					offset := offsetSize * aStringArray size + ( offsets at: index ).
					self stringEncode: each to: answer data getHandle + offset size: bytesize - offset
					]
			]
]

{ #category : #tensor }
TensorFlowPharoLibrary >> tensorRank: aTF_Tensor [

	"<cdecl: longlong 'TF_NumDims' (TF_Tensor*)>"

	^ self ffiCall: #(int TF_NumDims #(TFTensor * aTF_Tensor)) module: TensorFlowPharoLibrary
]

{ #category : #tensor }
TensorFlowPharoLibrary >> tensorType: aTF_Tensor [

	"<cdecl: ulonglong 'TF_TensorType' (TF_Tensor*)>"

	^ self ffiCall: #(ulonglong TF_TensorType #(TFTensor * aTF_Tensor)) module: TensorFlowPharoLibrary
]

{ #category : #'accessing platform' }
TensorFlowPharoLibrary >> unixModuleName [
	^ '/usr/local/lib/libtensorflow.so'
]

{ #category : #utils }
TensorFlowPharoLibrary >> version [
	"TF_Version returns a string describing version information of the
	TensorFlow library. TensorFlow using semantic versioning."

	"TF_CAPI_EXPORT extern const char* TF_Version();"


	^ self ffiCall: #(String TF_Version #()) module: TensorFlowPharoLibrary
]
