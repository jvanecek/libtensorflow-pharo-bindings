Extension { #name : #TFGraph }

{ #category : #'*TFOperationGradientModel' }
TFGraph >> gradientsOf: yArrayOfTFOutput withRespectTo: xArrayOfTFOutput product: dxArrayOfOutput [

	| y x dx status dy |

	y := TFOutputArray externalFromArray: yArrayOfTFOutput.
	x := TFOutputArray externalFromArray: xArrayOfTFOutput.
	dx := dxArrayOfOutput
		ifNil: [ ExternalData fromHandle: ExternalAddress new beNull type: ExternalType char asPointerType ]
		ifNotNil: [ TFOutputArray externalFromArray: dxArrayOfOutput ].
	dy := TFOutputArray externalNew: xArrayOfTFOutput size.
	status := TFStatus create.
	self library
		graph: self
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
